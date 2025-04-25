module tile_mem (
    input wire clk,              // System clock
    input wire reset,           // Reset signal
    
    // Write port (from switches/Arduino)
    input wire tm_clk,          // Tile memory write clock
    input wire enable,       // Write enable
    input wire val,          // Tile value (could expand to character code)
    input wire [7:0] wt_x, // X position (0-79)
    input wire [7:0] wt_y, // Y position (0-59)
    
    // Read port (for display)
    input wire [9:0] rt_x,    // Current X pixel position (0-639)
    input wire [9:0] rt_y,    // Current Y pixel position (0-479)
    output reg char
    //output reg tile_active      // Whether current pixel is in an active tile
);

    // Calculate tile address from coordinates (80 tiles per row)
    // Total tiles: 80*60 = 4800, needs 13 bits (2^13 = 8192)
    parameter TILE_WIDTH = 8;
    parameter TILE_HEIGHT = 8;
    parameter H_TILES = 80;
    parameter V_TILES = 60;
    
    // Memory to store tile states (1 bit per tile for now)
    // Could be expanded to store character codes or other tile properties
    reg [0:0] tile_data[0:H_TILES*V_TILES-1]; // 1-bit per tile
    
    // Calculate the current tile coordinates from pixel position
    //wire [6:0] read_tile_x = rt_x[9:3]; // Division by 8
    //wire [5:0] read_tile_y = rt_y[9:3]; // Division by 8
    wire [12:0] read_address = rt_y * H_TILES + rt_x;
    
    // Calculate write address
    wire [12:0] write_address = wt_y * H_TILES + wt_x;
    
    integer i;
    
    // Write process (from switches/Arduino)
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
    
    reg tile_active;
    
    // Read process (for display)
    always @(rt_x or rt_y) begin
        // Check if we're in valid tile range
        if (rt_x < H_TILES && rt_y < V_TILES) begin
            tile_active <= tile_data[read_address];
            if (tile_active) begin
                char <= 35;
            end else begin
                char <= 32;
            end
        end else begin
            tile_active <= 1'b0;
        end
        
    end
    
    
    
endmodule