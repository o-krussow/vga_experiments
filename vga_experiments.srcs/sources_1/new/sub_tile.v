`timescale 1ns / 1ps

module sub_tile(
  input [9:0] x,
  input [9:0] y,
  output [2:0] w_x,
  output [2:0] w_y
);

assign w_x = x & 3'b111;
assign w_y = y & 3'b111;


endmodule
