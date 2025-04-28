module tile_mem (
    // Read port (for display) - VGA clock domain
    input wire clk,              // VGA clock (likely 25MHz or 100MHz)
    input wire reset,            // System reset
    input wire [7:0] rt_x,       // Current X tile position
    input wire [7:0] rt_y,       // Current Y tile position
    output reg [7:0] char,       // Output character to display
    
    // Write port (from switches/Arduino) - External clock domain
    input wire tm_clk,           // Tile memory write clock (separate domain)
    input wire enable,           // Write enable
    input wire val,              // Tile value to write
    input wire [7:0] wt_x,       // X position to write to
    input wire [7:0] wt_y        // Y position to write to
);

    // Parameters for tile dimensions and screen layout
    parameter TILE_WIDTH = 8;
    parameter TILE_HEIGHT = 8;
    parameter H_TILES = 80;      // 640/8 = 80 tiles horizontally
    parameter V_TILES = 60;      // 480/8 = 60 tiles vertically
    
    // Memory to store tile states (1 bit per tile for now)
    (* ram_style = "block" *) // Optional synthesis directive for block RAM
    reg [0:0] tile_data[0:H_TILES*V_TILES-1]; // 1-bit per tile
    
    // Calculate read address from tile coordinates
    wire [12:0] read_address = rt_y * H_TILES + rt_x;
    
    // Calculate write address from coordinates
    wire [12:0] write_address = wt_y * H_TILES + wt_x;
    
    integer i;
    
    // Write process (from external clock domain)
    always @(posedge tm_clk or posedge reset) begin
        if (reset) begin
            // Reset all tiles to inactive
            for (i = 0; i < H_TILES*V_TILES; i = i + 1) begin
                tile_data[i] <= 1'b0;
            end
        end else if (enable) begin
            // Write tile data when enabled
            if (wt_x < H_TILES && wt_y < V_TILES) begin
                tile_data[write_address] <= val;
            end
        end
    end
    
    // Read process (VGA clock domain)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            char <= 32; // Space character as default
        end else begin
            // Check if we're in valid tile range
            if (rt_x < H_TILES && rt_y < V_TILES) begin
                if (tile_data[read_address]) begin
                    char <= 35; // ASCII for '#'
                end else begin
                    char <= 32; // ASCII for space
                end
            end else begin
                char <= 32; // Default to space outside valid range
            end
        end
    end
    
endmodule