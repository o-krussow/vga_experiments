//vars
int tx0_pin = 22;
int tx1_pin = 24;
int tx2_pin = 26;
int tx3_pin = 28;
int tx4_pin = 30;
int tx5_pin = 32;
int tx6_pin = 34;
int tx7_pin = 36;

int ty0_pin = 23;
int ty1_pin = 25;
int ty2_pin = 27;
int ty3_pin = 29;
int ty4_pin = 31;
int ty5_pin = 33;
int ty6_pin = 35;
int ty7_pin = 37;

int val_pin = 46;
int clk_pin = 47;
int en_pin = 48;

int tx_num = 0;
int ty_num = 0;

// Board dimensions
const int BOARD_WIDTH = 80;
const int BOARD_HEIGHT = 60;

// Memory optimization: Use byte arrays and bit packing (8 cells per byte)
const int BOARD_BYTE_WIDTH = (BOARD_WIDTH + 7) / 8; // Round up division
byte currentBoard[BOARD_HEIGHT][BOARD_BYTE_WIDTH]; // Current state
byte nextBoard[BOARD_HEIGHT][BOARD_BYTE_WIDTH];    // Next state
byte changeMap[BOARD_HEIGHT][BOARD_BYTE_WIDTH];    // Tracks cell changes

// For timing
unsigned long lastFrameTime = 0;
unsigned long frameCount = 0;
const unsigned long FRAME_RATE_CHECK_INTERVAL = 5000; // Check every 5 seconds

// Function to get cell state from specified board (1 or 0)
byte getCell(byte board[][BOARD_BYTE_WIDTH], int x, int y) {
  // Handle wrapping (toroidal board)
  x = (x + BOARD_WIDTH) % BOARD_WIDTH;
  y = (y + BOARD_HEIGHT) % BOARD_HEIGHT;
  
  int byteIndex = x / 8;
  int bitPosition = x % 8;
  
  return (board[y][byteIndex] & (1 << bitPosition)) ? 1 : 0;
}

// Function to set cell state in specified board
void setCell(byte board[][BOARD_BYTE_WIDTH], int x, int y, byte state) {
  // Handle wrapping
  x = (x + BOARD_WIDTH) % BOARD_WIDTH;
  y = (y + BOARD_HEIGHT) % BOARD_HEIGHT;
  
  int byteIndex = x / 8;
  int bitPosition = x % 8;
  
  if (state) {
    board[y][byteIndex] |= (1 << bitPosition); // Set bit
  } else {
    board[y][byteIndex] &= ~(1 << bitPosition); // Clear bit
  }
}

// Function to mark a cell as changed
void markCellChanged(int x, int y) {
  x = (x + BOARD_WIDTH) % BOARD_WIDTH;
  y = (y + BOARD_HEIGHT) % BOARD_HEIGHT;
  
  int byteIndex = x / 8;
  int bitPosition = x % 8;
  
  changeMap[y][byteIndex] |= (1 << bitPosition); // Set bit
}

// Function to check if cell is marked as changed
bool isCellChanged(int x, int y) {
  x = (x + BOARD_WIDTH) % BOARD_WIDTH;
  y = (y + BOARD_HEIGHT) % BOARD_HEIGHT;
  
  int byteIndex = x / 8;
  int bitPosition = x % 8;
  
  return (changeMap[y][byteIndex] & (1 << bitPosition)) ? true : false;
}

// Function to clear the change map
void clearChangeMap() {
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_BYTE_WIDTH; x++) {
      changeMap[y][x] = 0;
    }
  }
}

void setup() {
  // Initialize serial for debugging
  Serial.begin(115200);
  
  // Set pin modes
  pinMode(tx0_pin, OUTPUT);
  pinMode(tx1_pin, OUTPUT);
  pinMode(tx2_pin, OUTPUT);
  pinMode(tx3_pin, OUTPUT);
  pinMode(tx4_pin, OUTPUT);
  pinMode(tx5_pin, OUTPUT);
  pinMode(tx6_pin, OUTPUT);
  pinMode(tx7_pin, OUTPUT);
  pinMode(ty0_pin, OUTPUT);
  pinMode(ty1_pin, OUTPUT);
  pinMode(ty2_pin, OUTPUT);
  pinMode(ty3_pin, OUTPUT);
  pinMode(ty4_pin, OUTPUT);
  pinMode(ty5_pin, OUTPUT);
  pinMode(ty6_pin, OUTPUT);
  pinMode(ty7_pin, OUTPUT);
  pinMode(val_pin, OUTPUT);
  pinMode(clk_pin, OUTPUT);
  pinMode(en_pin, OUTPUT);

  // Clear the board initially
  clearBoard();
  
  // Set up some initial pattern (Glider)
  setupGlider(10, 10);
  
  // Initial update of the display
  updateEntireDisplay();
  
  // Initialize timing
  lastFrameTime = millis();
}

void setupGlider(int x, int y) {
  // Create a glider pattern
  setCell(currentBoard, x+1, y, 1);
  setCell(currentBoard, x+2, y+1, 1);
  setCell(currentBoard, x, y+2, 1);
  setCell(currentBoard, x+1, y+2, 1);
  setCell(currentBoard, x+2, y+2, 1);
}

void setupBlinker(int x, int y) {
  // Create a blinker pattern (vertical line of 3 cells)
  setCell(currentBoard, x, y, 1);
  setCell(currentBoard, x, y+1, 1);
  setCell(currentBoard, x, y+2, 1);
}

void setupGosperGliderGun(int x, int y) {
  // Left block
  setCell(currentBoard, x+0, y+4, 1);
  setCell(currentBoard, x+0, y+5, 1);
  setCell(currentBoard, x+1, y+4, 1);
  setCell(currentBoard, x+1, y+5, 1);
  
  // Right block
  setCell(currentBoard, x+34, y+2, 1);
  setCell(currentBoard, x+34, y+3, 1);
  setCell(currentBoard, x+35, y+2, 1);
  setCell(currentBoard, x+35, y+3, 1);
  
  // Left ship
  setCell(currentBoard, x+10, y+4, 1);
  setCell(currentBoard, x+10, y+5, 1);
  setCell(currentBoard, x+10, y+6, 1);
  setCell(currentBoard, x+11, y+3, 1);
  setCell(currentBoard, x+11, y+7, 1);
  setCell(currentBoard, x+12, y+2, 1);
  setCell(currentBoard, x+12, y+8, 1);
  setCell(currentBoard, x+13, y+2, 1);
  setCell(currentBoard, x+13, y+8, 1);
  setCell(currentBoard, x+14, y+5, 1);
  setCell(currentBoard, x+15, y+3, 1);
  setCell(currentBoard, x+15, y+7, 1);
  setCell(currentBoard, x+16, y+4, 1);
  setCell(currentBoard, x+16, y+5, 1);
  setCell(currentBoard, x+16, y+6, 1);
  setCell(currentBoard, x+17, y+5, 1);
  
  // Right ship
  setCell(currentBoard, x+20, y+2, 1);
  setCell(currentBoard, x+20, y+3, 1);
  setCell(currentBoard, x+20, y+4, 1);
  setCell(currentBoard, x+21, y+2, 1);
  setCell(currentBoard, x+21, y+3, 1);
  setCell(currentBoard, x+21, y+4, 1);
  setCell(currentBoard, x+22, y+1, 1);
  setCell(currentBoard, x+22, y+5, 1);
  setCell(currentBoard, x+24, y+0, 1);
  setCell(currentBoard, x+24, y+1, 1);
  setCell(currentBoard, x+24, y+5, 1);
  setCell(currentBoard, x+24, y+6, 1);
}

void setupRandomPattern() {
  // Fill about 25% of the board randomly
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      setCell(currentBoard, x, y, random(100) < 25 ? 1 : 0);
      
      // Mark all cells as changed for display update
      markCellChanged(x, y);
    }
  }
}

void clearBoard() {
  // Clear both boards
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_BYTE_WIDTH; x++) {
      currentBoard[y][x] = 0;
      nextBoard[y][x] = 0;
      changeMap[y][x] = 0xFF; // Mark all cells as changed for initial display
    }
  }
}

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

void send_command(int val, int ltx_num, int lty_num) {
  tx_num = ltx_num;
  ty_num = lty_num;

  set_tile_addr();

  digitalWrite(val_pin, val);
  digitalWrite(en_pin, HIGH);
  digitalWrite(clk_pin, HIGH);
  digitalWrite(en_pin, LOW);
  digitalWrite(clk_pin, LOW);
}

int countNeighbors(int x, int y) {
  int count = 0;
  
  // Check all 8 neighbors
  for (int dy = -1; dy <= 1; dy++) {
    for (int dx = -1; dx <= 1; dx++) {
      // Skip the cell itself
      if (dx == 0 && dy == 0) continue;
      
      // Count live neighbors
      count += getCell(currentBoard, x + dx, y + dy);
    }
  }
  
  return count;
}

void calculateNextGeneration() {
  // Clear the next board
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_BYTE_WIDTH; x++) {
      nextBoard[y][x] = 0;
    }
  }
  
  // Calculate the next state for each cell
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      int neighbors = countNeighbors(x, y);
      int current = getCell(currentBoard, x, y);
      int next = 0;
      
      // Apply Conway's Game of Life rules
      if (current == 1 && (neighbors == 2 || neighbors == 3)) {
        next = 1;  // Cell stays alive
      } else if (current == 0 && neighbors == 3) {
        next = 1;  // Cell becomes alive
      }
      
      // Set cell in next board
      setCell(nextBoard, x, y, next);
      
      // If state changed, mark as changed
      if (next != current) {
        markCellChanged(x, y);
      }
    }
  }
}

void updateEntireDisplay() {
  // Update every cell on the display
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      send_command(getCell(currentBoard, x, y), x, y);
    }
  }
}

void updateChangedCells() {
  // Only update cells that changed
  int updatedCells = 0;
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      if (isCellChanged(x, y)) {
        send_command(getCell(currentBoard, x, y), x, y);
        updatedCells++;
      }
    }
  }
  
  // Clear change map for next iteration
  clearChangeMap();
  
  // Debug info about update efficiency
  if (updatedCells > 0) {
    Serial.print("Updated cells: ");
    Serial.println(updatedCells);
  }
}

void swapBoards() {
  // Swap current and next boards by copying values
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_BYTE_WIDTH; x++) {
      currentBoard[y][x] = nextBoard[y][x];
    }
  }
}

void displayFrameRate() {
  unsigned long currentTime = millis();
  unsigned long elapsedTime = currentTime - lastFrameTime;
  
  if (elapsedTime >= FRAME_RATE_CHECK_INTERVAL) {
    float fps = (float)frameCount * 1000.0 / elapsedTime;
    Serial.print("Frame rate: ");
    Serial.print(fps);
    Serial.println(" fps");
    
    lastFrameTime = currentTime;
    frameCount = 0;
  }
}

void loop() {
  // Calculate the next generation
  calculateNextGeneration();
  
  // Swap the boards
  swapBoards();
  
  // Update only the changed cells on the display
  updateChangedCells();
  
  // Increment frame counter
  frameCount++;
  
  // Display frame rate periodically
  displayFrameRate();
  
  // Control simulation speed
  delay(100);  // Adjust this value to control simulation speed
  
  // Check for user commands from serial input
  if (Serial.available() > 0) {
    char cmd = Serial.read();
    switch (cmd) {
      case 'r':  // Random pattern
        setupRandomPattern();
        break;
      case 'c':  // Clear board
        clearBoard();
        break;
      case 'g':  // Add glider
        setupGlider(random(BOARD_WIDTH-10), random(BOARD_HEIGHT-10));
        break;
      case 'b':  // Add blinker
        setupBlinker(random(BOARD_WIDTH-5), random(BOARD_HEIGHT-5));
        break;
      case 'u':  // Add Gosper Glider Gun
        setupGosperGliderGun(5, 5);
        break;
    }
  }
}
