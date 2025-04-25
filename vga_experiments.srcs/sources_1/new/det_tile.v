`timescale 1ns / 1ps


//This module is used to determine WHAT x, y tile we are in based off of x, y we are at.
module det_tile(
  input [9:0] x,
  input [9:0] y,
  output [7:0] t_x,
  output [7:0] t_y
);

assign t_x = x >> 3; // 2^3 = 8x8 tiles
assign t_y = y  >> 3;

endmodule
