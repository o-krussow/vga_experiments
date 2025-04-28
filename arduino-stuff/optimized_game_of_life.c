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
byte currentBoard[BOARD_HEIGHT][BOARD_BYTE_WIDTH];
byte nextBoard[BOARD_HEIGHT][BOARD_BYTE_WIDTH];

// Performance optimization: Skip empty regions with activity tracking
const int REGION_SIZE = 8; // 8x8 regions
const int REGIONS_WIDTH = (BOARD_WIDTH + REGION_SIZE - 1) / REGION_SIZE;
const int REGIONS_HEIGHT = (BOARD_HEIGHT + REGION_SIZE - 1) / REGION_SIZE;
boolean activeRegions[REGIONS_HEIGHT][REGIONS_WIDTH]; // Tracks regions with activity
boolean nextActiveRegions[REGIONS_HEIGHT][REGIONS_WIDTH]; // For the next generation

// For timing
unsigned long lastFrameTime = 0;
unsigned long frameCount = 0;
unsigned long totalCellsProcessed = 0;
unsigned long totalCellsUpdated = 0;
const unsigned long FRAME_RATE_CHECK_INTERVAL = 5000; // Check every 5 seconds

// Direct x,y bit access (optimized for speed)
inline boolean getCellDirect(byte board[][BOARD_BYTE_WIDTH], int x, int y) {
  return (board[y][x >> 3] & (1 << (x & 7))) != 0;
}

inline void setCellDirect(byte board[][BOARD_BYTE_WIDTH], int x, int y, boolean state) {
  if (state) {
    board[y][x >> 3] |= (1 << (x & 7));
  } else {
    board[y][x >> 3] &= ~(1 << (x & 7));
  }
}

// Function to get cell state from specified board with wrapping (1 or 0)
byte getCell(byte board[][BOARD_BYTE_WIDTH], int x, int y) {
  // Handle wrapping (toroidal board)
  x = (x + BOARD_WIDTH) % BOARD_WIDTH;
  y = (y + BOARD_HEIGHT) % BOARD_HEIGHT;
  
  return getCellDirect(board, x, y) ? 1 : 0;
}

// Function to set cell state in specified board with wrapping
void setCell(byte board[][BOARD_BYTE_WIDTH], int x, int y, byte state) {
  // Handle wrapping
  x = (x + BOARD_WIDTH) % BOARD_WIDTH;
  y = (y + BOARD_HEIGHT) % BOARD_HEIGHT;
  
  setCellDirect(board, x, y, state);
}

// Mark a region and its neighbors as active for the next generation
void markRegionActive(int regionX, int regionY) {
  for (int dy = -1; dy <= 1; dy++) {
    for (int dx = -1; dx <= 1; dx++) {
      int nx = (regionX + dx + REGIONS_WIDTH) % REGIONS_WIDTH;
      int ny = (regionY + dy + REGIONS_HEIGHT) % REGIONS_HEIGHT;
      nextActiveRegions[ny][nx] = true;
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
  
  // Set up some initial pattern
  setupGosperGliderGun(5, 5);
  
  // Initial update of the display
  updateEntireDisplay();
  
  // Initialize timing
  lastFrameTime = millis();
  
  Serial.println("Conway's Game of Life - Optimized Version");
  Serial.println("Commands: 'r'=random, 'c'=clear, 'g'=glider, 'u'=glider gun");
}

void setupGlider(int x, int y) {
  setCell(currentBoard, x+1, y, 1);
  setCell(currentBoard, x+2, y+1, 1);
  setCell(currentBoard, x, y+2, 1);
  setCell(currentBoard, x+1, y+2, 1);
  setCell(currentBoard, x+2, y+2, 1);
  
  // Mark this region as active
  markRegionAsActive(x, y, 3, 3);
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
  
  // Mark the entire gun area as active (plus buffer)
  markRegionAsActive(x, y, 36, 9);
}

void setupRandomPattern() {
  // Fill about 25% of the board randomly
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      boolean state = random(100) < 25;
      setCellDirect(currentBoard, x, y, state);
    }
  }
  
  // Mark all regions as active for random pattern
  for (int ry = 0; ry < REGIONS_HEIGHT; ry++) {
    for (int rx = 0; rx < REGIONS_WIDTH; rx++) {
      activeRegions[ry][rx] = true;
    }
  }
  
  // Force full display update
  updateEntireDisplay();
}

void markRegionAsActive(int startX, int startY, int width, int height) {
  int endX = startX + width;
  int endY = startY + height;
  
  // Convert to region coordinates and mark as active
  int startRegionX = startX / REGION_SIZE;
  int startRegionY = startY / REGION_SIZE;
  int endRegionX = (endX + REGION_SIZE - 1) / REGION_SIZE;
  int endRegionY = (endY + REGION_SIZE - 1) / REGION_SIZE;
  
  for (int ry = startRegionY; ry < endRegionY; ry++) {
    for (int rx = startRegionX; rx < endRegionX; rx++) {
      if (rx >= 0 && rx < REGIONS_WIDTH && ry >= 0 && ry < REGIONS_HEIGHT) {
        activeRegions[ry][rx] = true;
      }
    }
  }
}

void clearBoard() {
  // Clear both boards
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_BYTE_WIDTH; x++) {
      currentBoard[y][x] = 0;
      nextBoard[y][x] = 0;
    }
  }
  
  // Clear active regions
  for (int y = 0; y < REGIONS_HEIGHT; y++) {
    for (int x = 0; x < REGIONS_WIDTH; x++) {
      activeRegions[y][x] = false;
      nextActiveRegions[y][x] = false;
    }
  }
  
  // Force full display update (all zeros)
  updateEntireDisplay();
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

// Optimized version that sends multiple commands in quick succession
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

// Fast neighbor counting for active regions
int countNeighbors(int x, int y) {
  int neighbors = 0;
  
  // Unrolled neighbor counting for speed
  neighbors += getCell(currentBoard, x-1, y-1);
  neighbors += getCell(currentBoard, x,   y-1);
  neighbors += getCell(currentBoard, x+1, y-1);
  neighbors += getCell(currentBoard, x-1, y);
  neighbors += getCell(currentBoard, x+1, y);
  neighbors += getCell(currentBoard, x-1, y+1);
  neighbors += getCell(currentBoard, x,   y+1);
  neighbors += getCell(currentBoard, x+1, y+1);
  
  return neighbors;
}

void calculateNextGeneration() {
  // Clear next board and next active regions
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_BYTE_WIDTH; x++) {
      nextBoard[y][x] = 0;
    }
  }
  
  for (int ry = 0; ry < REGIONS_HEIGHT; ry++) {
    for (int rx = 0; rx < REGIONS_WIDTH; rx++) {
      nextActiveRegions[ry][rx] = false;
    }
  }
  
  // Process only active regions and their neighbors
  for (int ry = 0; ry < REGIONS_HEIGHT; ry++) {
    for (int rx = 0; rx < REGIONS_WIDTH; rx++) {
      if (!activeRegions[ry][rx]) continue; // Skip inactive regions
      
      // Calculate region boundaries
      int startX = rx * REGION_SIZE;
      int startY = ry * REGION_SIZE;
      int endX = min(startX + REGION_SIZE, BOARD_WIDTH);
      int endY = min(startY + REGION_SIZE, BOARD_HEIGHT);
      
      boolean regionHasLife = false;
      
      // Process cells in this region
      for (int y = startY; y < endY; y++) {
        for (int x = startX; x < endX; x++) {
          int neighbors = countNeighbors(x, y);
          boolean current = getCellDirect(currentBoard, x, y);
          boolean next = false;
          
          // Apply Conway's Game of Life rules
          if (current && (neighbors == 2 || neighbors == 3)) {
            next = true;  // Cell stays alive
          } else if (!current && neighbors == 3) {
            next = true;  // Cell becomes alive
          }
          
          // Set cell in next board
          setCellDirect(nextBoard, x, y, next);
          
          // If cell is alive, mark region as having life
          if (next) {
            regionHasLife = true;
          }
          
          // Track processed cells
          totalCellsProcessed++;
          
          // If state changed, send update command immediately
          if (next != current) {
            send_command(next ? 1 : 0, x, y);
            totalCellsUpdated++;
          }
        }
      }
      
      // If region has life, mark it and neighbors as active for next generation
      if (regionHasLife) {
        markRegionActive(rx, ry);
      }
    }
  }
}

void updateEntireDisplay() {
  // Update every cell on the display
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_WIDTH; x++) {
      send_command(getCellDirect(currentBoard, x, y) ? 1 : 0, x, y);
    }
  }
}

void swapBoards() {
  // Swap current and next boards
  byte temp;
  for (int y = 0; y < BOARD_HEIGHT; y++) {
    for (int x = 0; x < BOARD_BYTE_WIDTH; x++) {
      currentBoard[y][x] = nextBoard[y][x];
    }
  }
  
  // Swap active regions
  boolean temp_active;
  for (int y = 0; y < REGIONS_HEIGHT; y++) {
    for (int x = 0; x < REGIONS_WIDTH; x++) {
      activeRegions[y][x] = nextActiveRegions[y][x];
    }
  }
}

void displayStats() {
  unsigned long currentTime = millis();
  unsigned long elapsedTime = currentTime - lastFrameTime;
  
  if (elapsedTime >= FRAME_RATE_CHECK_INTERVAL) {
    float fps = (float)frameCount * 1000.0 / elapsedTime;
    
    // Count active regions
    int active = 0;
    for (int y = 0; y < REGIONS_HEIGHT; y++) {
      for (int x = 0; x < REGIONS_WIDTH; x++) {
        if (activeRegions[y][x]) active++;
      }
    }
    
    Serial.print("FPS: ");
    Serial.print(fps, 2);
    Serial.print(" | Active regions: ");
    Serial.print(active);
    Serial.print("/");
    Serial.print(REGIONS_WIDTH * REGIONS_HEIGHT);
    Serial.print(" | Cells processed/frame: ");
    Serial.print(totalCellsProcessed / frameCount);
    Serial.print(" | Cells updated/frame: ");
    Serial.println(totalCellsUpdated / frameCount);
    
    lastFrameTime = currentTime;
    frameCount = 0;
    totalCellsProcessed = 0;
    totalCellsUpdated = 0;
  }
}

void loop() {
  // Starting time for performance measurement
  unsigned long frameStartTime = millis();
  
  // Calculate the next generation
  calculateNextGeneration();
  
  // Swap the boards
  swapBoards();
  
  // Increment frame counter
  frameCount++;
  
  // Display performance statistics periodically
  displayStats();
  
  // Control simulation speed - dynamic delay to maintain target frame rate
  unsigned long frameDuration = millis() - frameStartTime;
  int targetDelay = 50; // Target 20fps if possible
  
  if (frameDuration < targetDelay) {
    delay(targetDelay - frameDuration);
  } else {
    // No delay needed - already taking longer than desired
    delay(1); // Just a minimal delay to allow system tasks
  }
  
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
      case 'u':  // Add Gosper Glider Gun
        setupGosperGliderGun(5, 5);
        break;
    }
  }
}
