`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference Book: 
// Chu, Pong P.
// Wiley, 2008
// "FPGA Prototyping by Verilog Examples: Xilinx Spartan-3 Version" 
// 
// Adapted for the Basys 3 by David J. Marion
// Comments by David J. Marion
//
// FOR USE WITH AN FPGA THAT HAS 12 PINS FOR RGB VALUES, 4 PER COLOR
//////////////////////////////////////////////////////////////////////////////////

module vga_test(
	input clk_100MHz,      // from Basys 3
	input reset,
	input [11:0] sw,       // 12 bits for color
   input [7:0] tm_wt_x_in,
   input [5:0] tm_wt_y_in,
   input tm_clk,
   input tm_enable,
   input tm_val,
	output hsync, 
	output vsync,
	output [11:0] rgb      // 12 FPGA pins for RGB(4 per color)
);
	
	// Signal Declaration
	reg [11:0] rgb_reg;    // register for Basys 3 12-bit RGB DAC 
	wire video_on;         // Same signal as in controller
	
	wire [9:0] x;
	wire [9:0] y;
	
	wire [7:0] t_x;
	wire [7:0] t_y;
	
	wire [2:0] w_x;
	wire [2:0] w_y;
   wire [7:0] char;

   wire [3:0] r;
   wire [3:0] g;
   wire [3:0] b;

   //assign tm_wt_x = tm_wt_x_in;
   //assign tm_wt_y = tm_wt_y_in;
   
   //assign LED = tm_clk;

   // Instantiate VGA Controller
   vga_controller vga_c(.clk_100MHz(clk_100MHz), .reset(reset), .hsync(hsync), .vsync(vsync),
                        .video_on(video_on), .p_tick(), .x(x), .y(y));
                        
                        
   det_tile det_tile(.x(x), .y(y), .t_x(t_x), .t_y(t_y));   
   sub_tile sub_tile(.x(x), .y(y), .w_x(w_x), .w_y(w_y)); 
   
   tile_mem tile_mem(.rt_x(t_x), .rt_y(t_y), .wt_y(tm_wt_y_in), .wt_x(tm_wt_x_in), .clk(clk_100MHz), .tm_clk(tm_clk), .enable(tm_enable), .val(tm_val), .reset(reset), .char(char));

   font_mem font_mem(.w_x(w_x), .w_y(w_y), .char(char), .r(r), .g(g), .b(b));
                             
   // RGB Buffer
   always @(posedge clk_100MHz or posedge reset) begin
      if (reset)
         rgb_reg <= 0;
      else
         rgb_reg <= {r, g, b};
   end
    
    // Output
   assign rgb = (video_on) ? rgb_reg : 12'b0;   // while in display area RGB color = sw, else all OFF
        
endmodule
