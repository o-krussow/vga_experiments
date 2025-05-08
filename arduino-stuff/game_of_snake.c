#include <Arduino.h> // Include base Arduino library (usually implicit, but good practice)
#include "YM2151.h"

#include <avr/pgmspace.h>
#include "sounds/eat.h"

// Display dimensions (in 8x8 tiles)
#define GRID_WIDTH 80
#define GRID_HEIGHT 60

// Maximum possible snake length (adjust based on memory/gameplay needs)
// Each segment needs 2 bytes (x, y). 256 segments = 512 bytes. Well within 8KB.
#define MAX_SNAKE_LENGTH 256

// Game speed control (milliseconds per step)
unsigned long moveInterval = 200; // Initial speed (lower is faster)
unsigned long lastMoveTime = 0;

// Snake direction (use values that don't conflict easily)
#define DIR_STOP 0
#define DIR_UP 1
#define DIR_DOWN 2
#define DIR_LEFT 3
#define DIR_RIGHT 4

//YM2151 variables
unsigned int vgmpos = 0xb0;

bool vgmend = true;
unsigned long startTime;
unsigned long duration;

// --- Pin Definitions ---
// FPGA Data/Address Pins
int tx0_pin = 46; int tx1_pin = 48; int tx2_pin = 50; int tx3_pin = 52;
int tx4_pin = 47; int tx5_pin = 49; int tx6_pin = 51; int tx7_pin = 53;
int ty0_pin = 45; int ty1_pin = 43; int ty2_pin = 41; int ty3_pin = 39;
int ty4_pin = 44; int ty5_pin = 42; int ty6_pin = 40; int ty7_pin = 38;
int val_pin = 34; // Tile value (0 or 1)
// FPGA Control Pins
int clk_pin = 37; // Clock signal
int en_pin = 36;  // Enable signal

// Input pins (Joystick/Buttons)
int up_pin = 40;
int down_pin = 41;
int left_pin = 42;
int right_pin = 43;

// --- Global Variables ---
// FPGA Communication State
int tx_num = 0;
int ty_num = 0;

// Snake data structure
byte snakeX[MAX_SNAKE_LENGTH]; // X coordinates of segments (head is index 0)
byte snakeY[MAX_SNAKE_LENGTH]; // Y coordinates of segments
int snakeLength;
byte currentDirection;
byte requestedDirection; // Buffer input to prevent 180 turns between updates

// Food position
byte foodX;
byte foodY;

// Game state
bool gameOver = false;
int score = 0;

//====================================================================
// FPGA Communication Functions
//====================================================================

/*
 * Sets the tile address pins (TX0-7, TY0-7) based on global tx_num, ty_num
 */
void set_tile_addr() {
    digitalWrite(tx0_pin, (tx_num & 1));
    digitalWrite(tx1_pin, ((tx_num >> 1) & 1));
    digitalWrite(tx2_pin, ((tx_num >> 2) & 1));
    digitalWrite(tx3_pin, ((tx_num >> 3) & 1));
    digitalWrite(tx4_pin, ((tx_num >> 4) & 1));
    digitalWrite(tx5_pin, ((tx_num >> 5) & 1));
    digitalWrite(tx6_pin, ((tx_num >> 6) & 1));
    digitalWrite(tx7_pin, ((tx_num >> 7) & 1));

    digitalWrite(ty0_pin, (ty_num & 1));
    digitalWrite(ty1_pin, ((ty_num >> 1) & 1));
    digitalWrite(ty2_pin, ((ty_num >> 2) & 1));
    digitalWrite(ty3_pin, ((ty_num >> 3) & 1));
    digitalWrite(ty4_pin, ((ty_num >> 4) & 1));
    digitalWrite(ty5_pin, ((ty_num >> 5) & 1));
    digitalWrite(ty6_pin, ((ty_num >> 6) & 1));
    digitalWrite(ty7_pin, ((ty_num >> 7) & 1));
}

/*
 * Sends a command to the FPGA to set a tile's value
 * val: Value (0 for off, 1 for on)
 * ltx_num: X tile coordinate (0 to GRID_WIDTH-1)
 * lty_num: Y tile coordinate (0 to GRID_HEIGHT-1)
 */
void send_command(int val, int ltx_num, int lty_num) {
  // Range check coordinates (optional but good practice)
  if (ltx_num < 0 || ltx_num >= GRID_WIDTH || lty_num < 0 || lty_num >= GRID_HEIGHT) {
      // Serial.print("WARN: Coords out of bounds: "); // Debug
      // Serial.print(ltx_num); Serial.print(","); Serial.println(lty_num); // Debug
      return; // Don't send command for invalid coordinates
  }

  tx_num = ltx_num;
  ty_num = lty_num;
  set_tile_addr();          // Set the address pins
  digitalWrite(val_pin, val); // Set the value pin

  // Clock cycle to latch data in FPGA
  // Ensure EN is high only during the clock pulse (adjust timing if needed)
  digitalWrite(en_pin, HIGH);
  delayMicroseconds(1);     // Small delay for setup time
  digitalWrite(clk_pin, HIGH);
  delayMicroseconds(1);     // Small delay for clock pulse width
  digitalWrite(clk_pin, LOW);
  delayMicroseconds(1);     // Small delay for hold time
  digitalWrite(en_pin, LOW);  // De-assert enable after clock edge
}

//====================================================================
// Audio play Functions
//====================================================================

uint8_t getByte() {
    uint8_t ret = pgm_read_byte_near(vgmdata + vgmpos);
    vgmpos++;
    return ret;
}

unsigned int read16() {
    return getByte() + (getByte() << 8);
}

void pause(long samples){
    duration = ((1000.0 / (44100.0 / (float)samples)) * 1000);
    startTime = micros();
}

void vgmplay() {
    if((micros() - startTime) <= duration) {
        return;
    }

    byte command = getByte();
    uint8_t reg;
    uint8_t dat;

    switch (command) {
        case 0x54:
            // YM2151
            reg = getByte();
            dat = getByte();
            YM2151.write(reg, dat);
            break;
        case 0x61:
            pause(read16());
            break;
        case 0x62:
            pause(735);
            break;
        case 0x63:
            pause(882);
            break;
        case 0x66:
            vgmend = true;
            vgmpos = 0xb0;
            break;
        case 0x70:
        case 0x71:
        case 0x72:
        case 0x73:
        case 0x74:
        case 0x75:
        case 0x76:
        case 0x77:
        case 0x78:
        case 0x79:
        case 0x7A:
        case 0x7B:
        case 0x7C:
        case 0x7D:
        case 0x7E:
        case 0x7F:
            pause((command & 0x0f) + 1);
            break;
        default:
            break;
    }
}


//====================================================================
// Game Logic Functions
//====================================================================

/*
 * Finds a random empty spot on the grid and places the food tile there.
 */
void placeFood() {
    bool placed = false;
    while (!placed) {
        foodX = random(0, GRID_WIDTH);
        foodY = random(0, GRID_HEIGHT);

        // Check if the food location overlaps with the snake
        bool overlap = false;
        for (int i = 0; i < snakeLength; i++) {
            if (snakeX[i] == foodX && snakeY[i] == foodY) {
                overlap = true;
                break;
            }
        }

        if (!overlap) {
            send_command(1, foodX, foodY); // Draw food tile
            placed = true;
            // Serial.print("Food placed at: "); Serial.print(foodX); Serial.print(","); Serial.println(foodY); // Debug
        }
    }
}

/*
 * Checks if the proposed next head position results in a collision.
 * nextX: The potential next X coordinate of the snake head.
 * nextY: The potential next Y coordinate of the snake head.
 * Returns: true if collision occurs, false otherwise.
 */
bool checkCollision(byte nextX, byte nextY) {
    // Wall collision
    if (nextX >= GRID_WIDTH || nextY >= GRID_HEIGHT) { // Assumes byte wraps around for < 0 check
         return true;
     }
    // Correct check for hitting left/top walls if using byte (unsigned)
    // The condition `nextX < 0` or `nextY < 0` will never be true for `byte`.
    // However, if the snake is at x=0 and moves left, nextX becomes 255 (wraps around).
    // This check handles boundary collision correctly. If the next coordinate is outside
    // the valid 0 to GRID_WIDTH-1 or 0 to GRID_HEIGHT-1 range.
    // The unsigned nature handles the wrap-around case implicitly by comparing against >= GRID_WIDTH/HEIGHT.


    // Self collision (check against segments *excluding* the tail that will move away)
    for (int i = 0; i < snakeLength - 1 ; i++) { // Check only up to snakeLength-1
        if (snakeX[i] == nextX && snakeY[i] == nextY) {
            return true; // Collision with self
        }
    }
    return false; // No collision
}

/*
 * Updates the snake's position based on current direction,
 * handles food consumption and growth, checks for collisions,
 * and sends necessary screen update commands.
 */
void updateSnake() {
    if (gameOver) return; // Do nothing if game is over

    // Update current direction based on requested input, preventing 180-degree turns
    if ((requestedDirection == DIR_LEFT && currentDirection != DIR_RIGHT) ||
        (requestedDirection == DIR_RIGHT && currentDirection != DIR_LEFT) ||
        (requestedDirection == DIR_UP && currentDirection != DIR_DOWN) ||
        (requestedDirection == DIR_DOWN && currentDirection != DIR_UP)) {
        currentDirection = requestedDirection;
    }

    // Calculate next head position based on the confirmed currentDirection
    byte nextX = snakeX[0];
    byte nextY = snakeY[0];

    switch (currentDirection) {
        case DIR_UP:    nextY--; break; // Y decreases going up
        case DIR_DOWN:  nextY++; break; // Y increases going down
        case DIR_LEFT:  nextX--; break; // X decreases going left
        case DIR_RIGHT: nextX++; break; // X increases going right
        default: return; // Not moving (shouldn't happen in normal play)
    }

    // Check for collisions (walls or self)
    if (checkCollision(nextX, nextY)) {
        gameOver = true;
        Serial.println("----------------");
        Serial.println("   GAME OVER!   ");
        Serial.print("  Final Score: "); Serial.println(score);
        Serial.println("----------------");
        // Optional: Add code here to display "Game Over" on the VGA screen
        return; // Stop the update process
    }

    // Check if the snake head is on the food
    bool ateFood = (nextX == foodX && nextY == foodY);

    // Store the current tail position *before* shifting the body
    byte tailX = snakeX[snakeLength - 1];
    byte tailY = snakeY[snakeLength - 1];

    // Move snake body: Shift all segments one position back
    // Start from the tail end and move towards the head
    for (int i = snakeLength - 1; i > 0; i--) {
        snakeX[i] = snakeX[i - 1];
        snakeY[i] = snakeY[i - 1];
    }

    // Move head to the new calculated position
    snakeX[0] = nextX;
    snakeY[0] = nextY;

    // Handle eating food
    if (ateFood) {
        vgmpos = 0xb0;
        vgmend = false;
        score++;
        // Increase snake length if possible
        if (snakeLength < MAX_SNAKE_LENGTH) {
            snakeLength++;
            // The new segment is implicitly added where the old tail was,
            // because we don't erase the tail tile this turn.
        }
        // Optional: Increase game speed slightly (make moveInterval smaller)
        if (moveInterval > 50) { // Set a minimum interval (fastest speed)
           moveInterval -= 5; // Decrease interval by 5ms
        }
	send_command(0, foodX, foodY);
        placeFood(); // Place new food (this function also draws it)
        Serial.print("Ate food! Score: "); Serial.print(score);
        Serial.print(" Speed Interval: "); Serial.println(moveInterval);
    } else {
        // No food eaten: Erase the old tail tile from the screen
        send_command(0, tailX, tailY);
    }

    // Draw the new head tile in its new position
    send_command(1, snakeX[0], snakeY[0]);
}

/*
 * Reads the joystick/button input pins and updates the requestedDirection.
 * Uses internal pullups (assumes buttons connect pin to GND when pressed).
 */
void readInput() {
     // Read digital pins. LOW means pressed with INPUT_PULLUP.
    if (digitalRead(up_pin) == LOW) {
        requestedDirection = DIR_UP;
    } else if (digitalRead(down_pin) == LOW) {
        requestedDirection = DIR_DOWN;
    } else if (digitalRead(left_pin) == LOW) {
        requestedDirection = DIR_LEFT;
    } else if (digitalRead(right_pin) == LOW) {
        requestedDirection = DIR_RIGHT;
    }
    // Note: Only the last valid direction pressed before the next `updateSnake()`
    // call will be considered, due to the 180-degree turn prevention logic
    // inside `updateSnake()`.
}

/*
 * Clears the entire screen by setting all tiles to 0.
 */
void clearScreen() {
    Serial.println("Clearing screen...");
    for (int i = 0; i < GRID_HEIGHT; i++) {
        for (int j = 0; j < GRID_WIDTH; j++) {
            send_command(0, j, i); // Set tile (j, i) to off
        }
    }
    Serial.println("Screen cleared.");
}

/*
 * Initializes the game state, snake, and food for a new game.
 */
void gameInit() {
    // Initial snake position (e.g., near center, moving right)
    snakeLength = 3; // Start with 3 segments
    snakeX[0] = GRID_WIDTH / 2;     snakeY[0] = GRID_HEIGHT / 2;
    snakeX[1] = GRID_WIDTH / 2 - 1; snakeY[1] = GRID_HEIGHT / 2;
    snakeX[2] = GRID_WIDTH / 2 - 2; snakeY[2] = GRID_HEIGHT / 2;

    // Draw initial snake on the screen
    for (int i = 0; i < snakeLength; i++) {
        send_command(1, snakeX[i], snakeY[i]); // Turn on initial snake segment tiles
    }

    currentDirection = DIR_RIGHT; // Start moving right
    requestedDirection = DIR_RIGHT; // Match initial direction
    gameOver = false;             // Start the game
    score = 0;                    // Reset score
    moveInterval = 200;           // Reset speed
    lastMoveTime = millis();      // Initialize game timer

    placeFood(); // Place the first piece of food

    Serial.println("Game Initialized. Ready to play!");
}


//====================================================================
// Arduino Setup and Loop Functions
//====================================================================

/*
 * Standard Arduino setup function. Runs once at power-on or reset.
 */
void setup() {

    YM2151.begin();
    // --- Pin Mode Setup ---
    // Outputs to FPGA
    pinMode(tx0_pin, OUTPUT); pinMode(tx1_pin, OUTPUT); pinMode(tx2_pin, OUTPUT); pinMode(tx3_pin, OUTPUT);
    pinMode(tx4_pin, OUTPUT); pinMode(tx5_pin, OUTPUT); pinMode(tx6_pin, OUTPUT); pinMode(tx7_pin, OUTPUT);
    pinMode(ty0_pin, OUTPUT); pinMode(ty1_pin, OUTPUT); pinMode(ty2_pin, OUTPUT); pinMode(ty3_pin, OUTPUT);
    pinMode(ty4_pin, OUTPUT); pinMode(ty5_pin, OUTPUT); pinMode(ty6_pin, OUTPUT); pinMode(ty7_pin, OUTPUT);
    pinMode(val_pin, OUTPUT);
    pinMode(clk_pin, OUTPUT);
    pinMode(en_pin, OUTPUT);

    // Inputs from Joystick/Buttons (using internal pullups)
    pinMode(up_pin, INPUT_PULLUP);
    pinMode(down_pin, INPUT_PULLUP);
    pinMode(left_pin, INPUT_PULLUP);
    pinMode(right_pin, INPUT_PULLUP);

    // --- Initial Pin States ---
    digitalWrite(en_pin, LOW);  // Ensure command is not enabled initially
    digitalWrite(clk_pin, LOW); // Ensure clock is low initially

    // --- Serial Setup (for debugging) ---
    Serial.begin(9600);
    while (!Serial); // Wait for serial connection (optional)
    Serial.println("Arduino Snake Starting...");

    // --- Random Seed ---
    randomSeed(analogRead(A0)); // Seed random number generator using an unconnected analog pin

    // --- Game Initialization ---
    clearScreen(); // Clear the VGA display
    gameInit();    // Setup snake, food, score, etc.
}

/*
 * Standard Arduino loop function. Runs repeatedly after setup().
 */
void loop() {
    // 1. Read Inputs
    readInput(); // Continuously check for player input

    // 2. Check Game Timing
    unsigned long currentTime = millis();
    if (currentTime - lastMoveTime >= moveInterval) { // Time for the next step?

        // 3. Update Game State (if not game over)
        if (!gameOver) {
            updateSnake(); // Move snake, check food/collisions, update screen
            while (!vgmend) {
              vgmplay();
            }
        } else {
            // Game is over.
            // Optional: Add logic here, e.g., wait for a button press to restart.
            // For now, it just stops moving. A simple restart could be:
            // if (digitalRead(some_restart_button_pin) == LOW) {
            //    clearScreen();
            //    gameInit();
            // }
        }

        // 4. Reset Timer
        lastMoveTime = currentTime; // Record the time of this step
    }

    // Small delay to prevent the loop from running excessively fast,
    // potentially causing issues or consuming unnecessary power.
    // Adjust or remove if it impacts input responsiveness.
    delay(5);
}

