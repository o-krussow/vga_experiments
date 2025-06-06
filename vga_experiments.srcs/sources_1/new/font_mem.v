`timescale 1ns / 1ps

module font_mem(
  input [2:0] w_x, //tile coordinates, x res / 8
  input [2:0] w_y, //same 
  input [7:0] char,
  output [3:0] r,
  output [3:0] g,
  output [3:0] b
);

parameter CHAR_WIDTH = 8;    // 8 pixels wide
parameter CHAR_HEIGHT = 8;  // 8 pixels high
parameter NUM_CHARS = 128;   // Supporting full ASCII range

//Each character needs CHAR_HEIGHT rows of CHAR_WIDTH bits each
reg [CHAR_WIDTH-1:0] font_rom [0:NUM_CHARS-1][0:CHAR_HEIGHT-1];

//font ROM
initial begin
  font_rom[0][0] = 8'b11111111;
  font_rom[0][1] = 8'b11111111;
  font_rom[0][2] = 8'b11111111;
  font_rom[0][3] = 8'b11111111;
  font_rom[0][4] = 8'b11111111;
  font_rom[0][5] = 8'b11111111;
  font_rom[0][6] = 8'b11111111;
  font_rom[0][7] = 8'b11111111;
  font_rom[1][0] = 8'b00000000;
  font_rom[1][1] = 8'b00000000;
  font_rom[1][2] = 8'b00000000;
  font_rom[1][3] = 8'b00000000;
  font_rom[1][4] = 8'b00000000;
  font_rom[1][5] = 8'b00000000;
  font_rom[1][6] = 8'b00000000;
  font_rom[1][7] = 8'b00000000;
  font_rom[2][0] = 8'b00000000;
  font_rom[2][1] = 8'b00000000;
  font_rom[2][2] = 8'b00000000;
  font_rom[2][3] = 8'b00000000;
  font_rom[2][4] = 8'b00000000;
  font_rom[2][5] = 8'b00000000;
  font_rom[2][6] = 8'b00000000;
  font_rom[2][7] = 8'b00000000;
  font_rom[3][0] = 8'b00000000;
  font_rom[3][1] = 8'b00000000;
  font_rom[3][2] = 8'b00000000;
  font_rom[3][3] = 8'b00000000;
  font_rom[3][4] = 8'b00000000;
  font_rom[3][5] = 8'b00000000;
  font_rom[3][6] = 8'b00000000;
  font_rom[3][7] = 8'b00000000;
  font_rom[4][0] = 8'b00000000;
  font_rom[4][1] = 8'b00000000;
  font_rom[4][2] = 8'b00000000;
  font_rom[4][3] = 8'b00000000;
  font_rom[4][4] = 8'b00000000;
  font_rom[4][5] = 8'b00000000;
  font_rom[4][6] = 8'b00000000;
  font_rom[4][7] = 8'b00000000;
  font_rom[5][0] = 8'b00000000;
  font_rom[5][1] = 8'b00000000;
  font_rom[5][2] = 8'b00000000;
  font_rom[5][3] = 8'b00000000;
  font_rom[5][4] = 8'b00000000;
  font_rom[5][5] = 8'b00000000;
  font_rom[5][6] = 8'b00000000;
  font_rom[5][7] = 8'b00000000;
  font_rom[6][0] = 8'b00000000;
  font_rom[6][1] = 8'b00000000;
  font_rom[6][2] = 8'b00000000;
  font_rom[6][3] = 8'b00000000;
  font_rom[6][4] = 8'b00000000;
  font_rom[6][5] = 8'b00000000;
  font_rom[6][6] = 8'b00000000;
  font_rom[6][7] = 8'b00000000;
  font_rom[7][0] = 8'b00000000;
  font_rom[7][1] = 8'b00000000;
  font_rom[7][2] = 8'b00000000;
  font_rom[7][3] = 8'b00000000;
  font_rom[7][4] = 8'b00000000;
  font_rom[7][5] = 8'b00000000;
  font_rom[7][6] = 8'b00000000;
  font_rom[7][7] = 8'b00000000;
  font_rom[8][0] = 8'b00000000;
  font_rom[8][1] = 8'b00000000;
  font_rom[8][2] = 8'b00000000;
  font_rom[8][3] = 8'b00000000;
  font_rom[8][4] = 8'b00000000;
  font_rom[8][5] = 8'b00000000;
  font_rom[8][6] = 8'b00000000;
  font_rom[8][7] = 8'b00000000;
  font_rom[9][0] = 8'b00000000;
  font_rom[9][1] = 8'b00000000;
  font_rom[9][2] = 8'b00000000;
  font_rom[9][3] = 8'b00000000;
  font_rom[9][4] = 8'b00000000;
  font_rom[9][5] = 8'b00000000;
  font_rom[9][6] = 8'b00000000;
  font_rom[9][7] = 8'b00000000;
  font_rom[10][0] = 8'b00000000;
  font_rom[10][1] = 8'b00000000;
  font_rom[10][2] = 8'b00000000;
  font_rom[10][3] = 8'b00000000;
  font_rom[10][4] = 8'b00000000;
  font_rom[10][5] = 8'b00000000;
  font_rom[10][6] = 8'b00000000;
  font_rom[10][7] = 8'b00000000;
  font_rom[11][0] = 8'b00000000;
  font_rom[11][1] = 8'b00000000;
  font_rom[11][2] = 8'b00000000;
  font_rom[11][3] = 8'b00000000;
  font_rom[11][4] = 8'b00000000;
  font_rom[11][5] = 8'b00000000;
  font_rom[11][6] = 8'b00000000;
  font_rom[11][7] = 8'b00000000;
  font_rom[12][0] = 8'b00000000;
  font_rom[12][1] = 8'b00000000;
  font_rom[12][2] = 8'b00000000;
  font_rom[12][3] = 8'b00000000;
  font_rom[12][4] = 8'b00000000;
  font_rom[12][5] = 8'b00000000;
  font_rom[12][6] = 8'b00000000;
  font_rom[12][7] = 8'b00000000;
  font_rom[13][0] = 8'b00000000;
  font_rom[13][1] = 8'b00000000;
  font_rom[13][2] = 8'b00000000;
  font_rom[13][3] = 8'b00000000;
  font_rom[13][4] = 8'b00000000;
  font_rom[13][5] = 8'b00000000;
  font_rom[13][6] = 8'b00000000;
  font_rom[13][7] = 8'b00000000;
  font_rom[14][0] = 8'b00000000;
  font_rom[14][1] = 8'b00000000;
  font_rom[14][2] = 8'b00000000;
  font_rom[14][3] = 8'b00000000;
  font_rom[14][4] = 8'b00000000;
  font_rom[14][5] = 8'b00000000;
  font_rom[14][6] = 8'b00000000;
  font_rom[14][7] = 8'b00000000;
  font_rom[15][0] = 8'b00000000;
  font_rom[15][1] = 8'b00000000;
  font_rom[15][2] = 8'b00000000;
  font_rom[15][3] = 8'b00000000;
  font_rom[15][4] = 8'b00000000;
  font_rom[15][5] = 8'b00000000;
  font_rom[15][6] = 8'b00000000;
  font_rom[15][7] = 8'b00000000;
  font_rom[16][0] = 8'b00000000;
  font_rom[16][1] = 8'b00000000;
  font_rom[16][2] = 8'b00000000;
  font_rom[16][3] = 8'b00000000;
  font_rom[16][4] = 8'b00000000;
  font_rom[16][5] = 8'b00000000;
  font_rom[16][6] = 8'b00000000;
  font_rom[16][7] = 8'b00000000;
  font_rom[17][0] = 8'b00000000;
  font_rom[17][1] = 8'b00000000;
  font_rom[17][2] = 8'b00000000;
  font_rom[17][3] = 8'b00000000;
  font_rom[17][4] = 8'b00000000;
  font_rom[17][5] = 8'b00000000;
  font_rom[17][6] = 8'b00000000;
  font_rom[17][7] = 8'b00000000;
  font_rom[18][0] = 8'b00000000;
  font_rom[18][1] = 8'b00000000;
  font_rom[18][2] = 8'b00000000;
  font_rom[18][3] = 8'b00000000;
  font_rom[18][4] = 8'b00000000;
  font_rom[18][5] = 8'b00000000;
  font_rom[18][6] = 8'b00000000;
  font_rom[18][7] = 8'b00000000;
  font_rom[19][0] = 8'b00000000;
  font_rom[19][1] = 8'b00000000;
  font_rom[19][2] = 8'b00000000;
  font_rom[19][3] = 8'b00000000;
  font_rom[19][4] = 8'b00000000;
  font_rom[19][5] = 8'b00000000;
  font_rom[19][6] = 8'b00000000;
  font_rom[19][7] = 8'b00000000;
  font_rom[20][0] = 8'b00000000;
  font_rom[20][1] = 8'b00000000;
  font_rom[20][2] = 8'b00000000;
  font_rom[20][3] = 8'b00000000;
  font_rom[20][4] = 8'b00000000;
  font_rom[20][5] = 8'b00000000;
  font_rom[20][6] = 8'b00000000;
  font_rom[20][7] = 8'b00000000;
  font_rom[21][0] = 8'b00000000;
  font_rom[21][1] = 8'b00000000;
  font_rom[21][2] = 8'b00000000;
  font_rom[21][3] = 8'b00000000;
  font_rom[21][4] = 8'b00000000;
  font_rom[21][5] = 8'b00000000;
  font_rom[21][6] = 8'b00000000;
  font_rom[21][7] = 8'b00000000;
  font_rom[22][0] = 8'b00000000;
  font_rom[22][1] = 8'b00000000;
  font_rom[22][2] = 8'b00000000;
  font_rom[22][3] = 8'b00000000;
  font_rom[22][4] = 8'b00000000;
  font_rom[22][5] = 8'b00000000;
  font_rom[22][6] = 8'b00000000;
  font_rom[22][7] = 8'b00000000;
  font_rom[23][0] = 8'b00000000;
  font_rom[23][1] = 8'b00000000;
  font_rom[23][2] = 8'b00000000;
  font_rom[23][3] = 8'b00000000;
  font_rom[23][4] = 8'b00000000;
  font_rom[23][5] = 8'b00000000;
  font_rom[23][6] = 8'b00000000;
  font_rom[23][7] = 8'b00000000;
  font_rom[24][0] = 8'b00000000;
  font_rom[24][1] = 8'b00000000;
  font_rom[24][2] = 8'b00000000;
  font_rom[24][3] = 8'b00000000;
  font_rom[24][4] = 8'b00000000;
  font_rom[24][5] = 8'b00000000;
  font_rom[24][6] = 8'b00000000;
  font_rom[24][7] = 8'b00000000;
  font_rom[25][0] = 8'b00000000;
  font_rom[25][1] = 8'b00000000;
  font_rom[25][2] = 8'b00000000;
  font_rom[25][3] = 8'b00000000;
  font_rom[25][4] = 8'b00000000;
  font_rom[25][5] = 8'b00000000;
  font_rom[25][6] = 8'b00000000;
  font_rom[25][7] = 8'b00000000;
  font_rom[26][0] = 8'b00000000;
  font_rom[26][1] = 8'b00000000;
  font_rom[26][2] = 8'b00000000;
  font_rom[26][3] = 8'b00000000;
  font_rom[26][4] = 8'b00000000;
  font_rom[26][5] = 8'b00000000;
  font_rom[26][6] = 8'b00000000;
  font_rom[26][7] = 8'b00000000;
  font_rom[27][0] = 8'b00000000;
  font_rom[27][1] = 8'b00000000;
  font_rom[27][2] = 8'b00000000;
  font_rom[27][3] = 8'b00000000;
  font_rom[27][4] = 8'b00000000;
  font_rom[27][5] = 8'b00000000;
  font_rom[27][6] = 8'b00000000;
  font_rom[27][7] = 8'b00000000;
  font_rom[28][0] = 8'b00000000;
  font_rom[28][1] = 8'b00000000;
  font_rom[28][2] = 8'b00000000;
  font_rom[28][3] = 8'b00000000;
  font_rom[28][4] = 8'b00000000;
  font_rom[28][5] = 8'b00000000;
  font_rom[28][6] = 8'b00000000;
  font_rom[28][7] = 8'b00000000;
  font_rom[29][0] = 8'b00000000;
  font_rom[29][1] = 8'b00000000;
  font_rom[29][2] = 8'b00000000;
  font_rom[29][3] = 8'b00000000;
  font_rom[29][4] = 8'b00000000;
  font_rom[29][5] = 8'b00000000;
  font_rom[29][6] = 8'b00000000;
  font_rom[29][7] = 8'b00000000;
  font_rom[30][0] = 8'b00000000;
  font_rom[30][1] = 8'b00000000;
  font_rom[30][2] = 8'b00000000;
  font_rom[30][3] = 8'b00000000;
  font_rom[30][4] = 8'b00000000;
  font_rom[30][5] = 8'b00000000;
  font_rom[30][6] = 8'b00000000;
  font_rom[30][7] = 8'b00000000;
  font_rom[31][0] = 8'b00000000;
  font_rom[31][1] = 8'b00000000;
  font_rom[31][2] = 8'b00000000;
  font_rom[31][3] = 8'b00000000;
  font_rom[31][4] = 8'b00000000;
  font_rom[31][5] = 8'b00000000;
  font_rom[31][6] = 8'b00000000;
  font_rom[31][7] = 8'b00000000;
  font_rom[32][0] = 8'b00000000;
  font_rom[32][1] = 8'b00000000;
  font_rom[32][2] = 8'b00000000;
  font_rom[32][3] = 8'b00000000;
  font_rom[32][4] = 8'b00000000;
  font_rom[32][5] = 8'b00000000;
  font_rom[32][6] = 8'b00000000;
  font_rom[32][7] = 8'b00000000;
  font_rom[33][0] = 8'b00011000;
  font_rom[33][1] = 8'b00111100;
  font_rom[33][2] = 8'b00111100;
  font_rom[33][3] = 8'b00011000;
  font_rom[33][4] = 8'b00011000;
  font_rom[33][5] = 8'b00000000;
  font_rom[33][6] = 8'b00011000;
  font_rom[33][7] = 8'b00000000;
  font_rom[34][0] = 8'b00110110;
  font_rom[34][1] = 8'b00110110;
  font_rom[34][2] = 8'b00000000;
  font_rom[34][3] = 8'b00000000;
  font_rom[34][4] = 8'b00000000;
  font_rom[34][5] = 8'b00000000;
  font_rom[34][6] = 8'b00000000;
  font_rom[34][7] = 8'b00000000;
  font_rom[35][0] = 8'b00110110;
  font_rom[35][1] = 8'b00110110;
  font_rom[35][2] = 8'b01111111;
  font_rom[35][3] = 8'b00110110;
  font_rom[35][4] = 8'b01111111;
  font_rom[35][5] = 8'b00110110;
  font_rom[35][6] = 8'b00110110;
  font_rom[35][7] = 8'b00000000;
  font_rom[36][0] = 8'b00001100;
  font_rom[36][1] = 8'b00111110;
  font_rom[36][2] = 8'b00000011;
  font_rom[36][3] = 8'b00011110;
  font_rom[36][4] = 8'b00110000;
  font_rom[36][5] = 8'b00011111;
  font_rom[36][6] = 8'b00001100;
  font_rom[36][7] = 8'b00000000;
  font_rom[37][0] = 8'b00000000;
  font_rom[37][1] = 8'b01100011;
  font_rom[37][2] = 8'b00110011;
  font_rom[37][3] = 8'b00011000;
  font_rom[37][4] = 8'b00001100;
  font_rom[37][5] = 8'b01100110;
  font_rom[37][6] = 8'b01100011;
  font_rom[37][7] = 8'b00000000;
  font_rom[38][0] = 8'b00011100;
  font_rom[38][1] = 8'b00110110;
  font_rom[38][2] = 8'b00011100;
  font_rom[38][3] = 8'b01101110;
  font_rom[38][4] = 8'b00111011;
  font_rom[38][5] = 8'b00110011;
  font_rom[38][6] = 8'b01101110;
  font_rom[38][7] = 8'b00000000;
  font_rom[39][0] = 8'b00000110;
  font_rom[39][1] = 8'b00000110;
  font_rom[39][2] = 8'b00000011;
  font_rom[39][3] = 8'b00000000;
  font_rom[39][4] = 8'b00000000;
  font_rom[39][5] = 8'b00000000;
  font_rom[39][6] = 8'b00000000;
  font_rom[39][7] = 8'b00000000;
  font_rom[40][0] = 8'b00011000;
  font_rom[40][1] = 8'b00001100;
  font_rom[40][2] = 8'b00000110;
  font_rom[40][3] = 8'b00000110;
  font_rom[40][4] = 8'b00000110;
  font_rom[40][5] = 8'b00001100;
  font_rom[40][6] = 8'b00011000;
  font_rom[40][7] = 8'b00000000;
  font_rom[41][0] = 8'b00000110;
  font_rom[41][1] = 8'b00001100;
  font_rom[41][2] = 8'b00011000;
  font_rom[41][3] = 8'b00011000;
  font_rom[41][4] = 8'b00011000;
  font_rom[41][5] = 8'b00001100;
  font_rom[41][6] = 8'b00000110;
  font_rom[41][7] = 8'b00000000;
  font_rom[42][0] = 8'b00000000;
  font_rom[42][1] = 8'b01100110;
  font_rom[42][2] = 8'b00111100;
  font_rom[42][3] = 8'b11111111;
  font_rom[42][4] = 8'b00111100;
  font_rom[42][5] = 8'b01100110;
  font_rom[42][6] = 8'b00000000;
  font_rom[42][7] = 8'b00000000;
  font_rom[43][0] = 8'b00000000;
  font_rom[43][1] = 8'b00001100;
  font_rom[43][2] = 8'b00001100;
  font_rom[43][3] = 8'b00111111;
  font_rom[43][4] = 8'b00001100;
  font_rom[43][5] = 8'b00001100;
  font_rom[43][6] = 8'b00000000;
  font_rom[43][7] = 8'b00000000;
  font_rom[44][0] = 8'b00000000;
  font_rom[44][1] = 8'b00000000;
  font_rom[44][2] = 8'b00000000;
  font_rom[44][3] = 8'b00000000;
  font_rom[44][4] = 8'b00000000;
  font_rom[44][5] = 8'b00001100;
  font_rom[44][6] = 8'b00001100;
  font_rom[44][7] = 8'b00000110;
  font_rom[45][0] = 8'b00000000;
  font_rom[45][1] = 8'b00000000;
  font_rom[45][2] = 8'b00000000;
  font_rom[45][3] = 8'b00111111;
  font_rom[45][4] = 8'b00000000;
  font_rom[45][5] = 8'b00000000;
  font_rom[45][6] = 8'b00000000;
  font_rom[45][7] = 8'b00000000;
  font_rom[46][0] = 8'b00000000;
  font_rom[46][1] = 8'b00000000;
  font_rom[46][2] = 8'b00000000;
  font_rom[46][3] = 8'b00000000;
  font_rom[46][4] = 8'b00000000;
  font_rom[46][5] = 8'b00001100;
  font_rom[46][6] = 8'b00001100;
  font_rom[46][7] = 8'b00000000;
  font_rom[47][0] = 8'b01100000;
  font_rom[47][1] = 8'b00110000;
  font_rom[47][2] = 8'b00011000;
  font_rom[47][3] = 8'b00001100;
  font_rom[47][4] = 8'b00000110;
  font_rom[47][5] = 8'b00000011;
  font_rom[47][6] = 8'b00000001;
  font_rom[47][7] = 8'b00000000;
  font_rom[48][0] = 8'b00111110;
  font_rom[48][1] = 8'b01100011;
  font_rom[48][2] = 8'b01110011;
  font_rom[48][3] = 8'b01111011;
  font_rom[48][4] = 8'b01101111;
  font_rom[48][5] = 8'b01100111;
  font_rom[48][6] = 8'b00111110;
  font_rom[48][7] = 8'b00000000;
  font_rom[49][0] = 8'b00001100;
  font_rom[49][1] = 8'b00001110;
  font_rom[49][2] = 8'b00001100;
  font_rom[49][3] = 8'b00001100;
  font_rom[49][4] = 8'b00001100;
  font_rom[49][5] = 8'b00001100;
  font_rom[49][6] = 8'b00111111;
  font_rom[49][7] = 8'b00000000;
  font_rom[50][0] = 8'b00011110;
  font_rom[50][1] = 8'b00110011;
  font_rom[50][2] = 8'b00110000;
  font_rom[50][3] = 8'b00011100;
  font_rom[50][4] = 8'b00000110;
  font_rom[50][5] = 8'b00110011;
  font_rom[50][6] = 8'b00111111;
  font_rom[50][7] = 8'b00000000;
  font_rom[51][0] = 8'b00011110;
  font_rom[51][1] = 8'b00110011;
  font_rom[51][2] = 8'b00110000;
  font_rom[51][3] = 8'b00011100;
  font_rom[51][4] = 8'b00110000;
  font_rom[51][5] = 8'b00110011;
  font_rom[51][6] = 8'b00011110;
  font_rom[51][7] = 8'b00000000;
  font_rom[52][0] = 8'b00111000;
  font_rom[52][1] = 8'b00111100;
  font_rom[52][2] = 8'b00110110;
  font_rom[52][3] = 8'b00110011;
  font_rom[52][4] = 8'b01111111;
  font_rom[52][5] = 8'b00110000;
  font_rom[52][6] = 8'b01111000;
  font_rom[52][7] = 8'b00000000;
  font_rom[53][0] = 8'b00111111;
  font_rom[53][1] = 8'b00000011;
  font_rom[53][2] = 8'b00011111;
  font_rom[53][3] = 8'b00110000;
  font_rom[53][4] = 8'b00110000;
  font_rom[53][5] = 8'b00110011;
  font_rom[53][6] = 8'b00011110;
  font_rom[53][7] = 8'b00000000;
  font_rom[54][0] = 8'b00011100;
  font_rom[54][1] = 8'b00000110;
  font_rom[54][2] = 8'b00000011;
  font_rom[54][3] = 8'b00011111;
  font_rom[54][4] = 8'b00110011;
  font_rom[54][5] = 8'b00110011;
  font_rom[54][6] = 8'b00011110;
  font_rom[54][7] = 8'b00000000;
  font_rom[55][0] = 8'b00111111;
  font_rom[55][1] = 8'b00110011;
  font_rom[55][2] = 8'b00110000;
  font_rom[55][3] = 8'b00011000;
  font_rom[55][4] = 8'b00001100;
  font_rom[55][5] = 8'b00001100;
  font_rom[55][6] = 8'b00001100;
  font_rom[55][7] = 8'b00000000;
  font_rom[56][0] = 8'b00011110;
  font_rom[56][1] = 8'b00110011;
  font_rom[56][2] = 8'b00110011;
  font_rom[56][3] = 8'b00011110;
  font_rom[56][4] = 8'b00110011;
  font_rom[56][5] = 8'b00110011;
  font_rom[56][6] = 8'b00011110;
  font_rom[56][7] = 8'b00000000;
  font_rom[57][0] = 8'b00011110;
  font_rom[57][1] = 8'b00110011;
  font_rom[57][2] = 8'b00110011;
  font_rom[57][3] = 8'b00111110;
  font_rom[57][4] = 8'b00110000;
  font_rom[57][5] = 8'b00011000;
  font_rom[57][6] = 8'b00001110;
  font_rom[57][7] = 8'b00000000;
  font_rom[58][0] = 8'b00000000;
  font_rom[58][1] = 8'b00001100;
  font_rom[58][2] = 8'b00001100;
  font_rom[58][3] = 8'b00000000;
  font_rom[58][4] = 8'b00000000;
  font_rom[58][5] = 8'b00001100;
  font_rom[58][6] = 8'b00001100;
  font_rom[58][7] = 8'b00000000;
  font_rom[59][0] = 8'b00000000;
  font_rom[59][1] = 8'b00001100;
  font_rom[59][2] = 8'b00001100;
  font_rom[59][3] = 8'b00000000;
  font_rom[59][4] = 8'b00000000;
  font_rom[59][5] = 8'b00001100;
  font_rom[59][6] = 8'b00001100;
  font_rom[59][7] = 8'b00000110;
  font_rom[60][0] = 8'b00011000;
  font_rom[60][1] = 8'b00001100;
  font_rom[60][2] = 8'b00000110;
  font_rom[60][3] = 8'b00000011;
  font_rom[60][4] = 8'b00000110;
  font_rom[60][5] = 8'b00001100;
  font_rom[60][6] = 8'b00011000;
  font_rom[60][7] = 8'b00000000;
  font_rom[61][0] = 8'b00000000;
  font_rom[61][1] = 8'b00000000;
  font_rom[61][2] = 8'b00111111;
  font_rom[61][3] = 8'b00000000;
  font_rom[61][4] = 8'b00000000;
  font_rom[61][5] = 8'b00111111;
  font_rom[61][6] = 8'b00000000;
  font_rom[61][7] = 8'b00000000;
  font_rom[62][0] = 8'b00000110;
  font_rom[62][1] = 8'b00001100;
  font_rom[62][2] = 8'b00011000;
  font_rom[62][3] = 8'b00110000;
  font_rom[62][4] = 8'b00011000;
  font_rom[62][5] = 8'b00001100;
  font_rom[62][6] = 8'b00000110;
  font_rom[62][7] = 8'b00000000;
  font_rom[63][0] = 8'b00011110;
  font_rom[63][1] = 8'b00110011;
  font_rom[63][2] = 8'b00110000;
  font_rom[63][3] = 8'b00011000;
  font_rom[63][4] = 8'b00001100;
  font_rom[63][5] = 8'b00000000;
  font_rom[63][6] = 8'b00001100;
  font_rom[63][7] = 8'b00000000;
  font_rom[64][0] = 8'b00111110;
  font_rom[64][1] = 8'b01100011;
  font_rom[64][2] = 8'b01111011;
  font_rom[64][3] = 8'b01111011;
  font_rom[64][4] = 8'b01111011;
  font_rom[64][5] = 8'b00000011;
  font_rom[64][6] = 8'b00011110;
  font_rom[64][7] = 8'b00000000;
  font_rom[65][0] = 8'b00001100;
  font_rom[65][1] = 8'b00011110;
  font_rom[65][2] = 8'b00110011;
  font_rom[65][3] = 8'b00110011;
  font_rom[65][4] = 8'b00111111;
  font_rom[65][5] = 8'b00110011;
  font_rom[65][6] = 8'b00110011;
  font_rom[65][7] = 8'b00000000;
  font_rom[66][0] = 8'b00111111;
  font_rom[66][1] = 8'b01100110;
  font_rom[66][2] = 8'b01100110;
  font_rom[66][3] = 8'b00111110;
  font_rom[66][4] = 8'b01100110;
  font_rom[66][5] = 8'b01100110;
  font_rom[66][6] = 8'b00111111;
  font_rom[66][7] = 8'b00000000;
  font_rom[67][0] = 8'b00111100;
  font_rom[67][1] = 8'b01100110;
  font_rom[67][2] = 8'b00000011;
  font_rom[67][3] = 8'b00000011;
  font_rom[67][4] = 8'b00000011;
  font_rom[67][5] = 8'b01100110;
  font_rom[67][6] = 8'b00111100;
  font_rom[67][7] = 8'b00000000;
  font_rom[68][0] = 8'b00011111;
  font_rom[68][1] = 8'b00110110;
  font_rom[68][2] = 8'b01100110;
  font_rom[68][3] = 8'b01100110;
  font_rom[68][4] = 8'b01100110;
  font_rom[68][5] = 8'b00110110;
  font_rom[68][6] = 8'b00011111;
  font_rom[68][7] = 8'b00000000;
  font_rom[69][0] = 8'b01111111;
  font_rom[69][1] = 8'b01000110;
  font_rom[69][2] = 8'b00010110;
  font_rom[69][3] = 8'b00011110;
  font_rom[69][4] = 8'b00010110;
  font_rom[69][5] = 8'b01000110;
  font_rom[69][6] = 8'b01111111;
  font_rom[69][7] = 8'b00000000;
  font_rom[70][0] = 8'b01111111;
  font_rom[70][1] = 8'b01000110;
  font_rom[70][2] = 8'b00010110;
  font_rom[70][3] = 8'b00011110;
  font_rom[70][4] = 8'b00010110;
  font_rom[70][5] = 8'b00000110;
  font_rom[70][6] = 8'b00001111;
  font_rom[70][7] = 8'b00000000;
  font_rom[71][0] = 8'b00111100;
  font_rom[71][1] = 8'b01100110;
  font_rom[71][2] = 8'b00000011;
  font_rom[71][3] = 8'b00000011;
  font_rom[71][4] = 8'b01110011;
  font_rom[71][5] = 8'b01100110;
  font_rom[71][6] = 8'b01111100;
  font_rom[71][7] = 8'b00000000;
  font_rom[72][0] = 8'b00110011;
  font_rom[72][1] = 8'b00110011;
  font_rom[72][2] = 8'b00110011;
  font_rom[72][3] = 8'b00111111;
  font_rom[72][4] = 8'b00110011;
  font_rom[72][5] = 8'b00110011;
  font_rom[72][6] = 8'b00110011;
  font_rom[72][7] = 8'b00000000;
  font_rom[73][0] = 8'b00011110;
  font_rom[73][1] = 8'b00001100;
  font_rom[73][2] = 8'b00001100;
  font_rom[73][3] = 8'b00001100;
  font_rom[73][4] = 8'b00001100;
  font_rom[73][5] = 8'b00001100;
  font_rom[73][6] = 8'b00011110;
  font_rom[73][7] = 8'b00000000;
  font_rom[74][0] = 8'b01111000;
  font_rom[74][1] = 8'b00110000;
  font_rom[74][2] = 8'b00110000;
  font_rom[74][3] = 8'b00110000;
  font_rom[74][4] = 8'b00110011;
  font_rom[74][5] = 8'b00110011;
  font_rom[74][6] = 8'b00011110;
  font_rom[74][7] = 8'b00000000;
  font_rom[75][0] = 8'b01100111;
  font_rom[75][1] = 8'b01100110;
  font_rom[75][2] = 8'b00110110;
  font_rom[75][3] = 8'b00011110;
  font_rom[75][4] = 8'b00110110;
  font_rom[75][5] = 8'b01100110;
  font_rom[75][6] = 8'b01100111;
  font_rom[75][7] = 8'b00000000;
  font_rom[76][0] = 8'b00001111;
  font_rom[76][1] = 8'b00000110;
  font_rom[76][2] = 8'b00000110;
  font_rom[76][3] = 8'b00000110;
  font_rom[76][4] = 8'b01000110;
  font_rom[76][5] = 8'b01100110;
  font_rom[76][6] = 8'b01111111;
  font_rom[76][7] = 8'b00000000;
  font_rom[77][0] = 8'b01100011;
  font_rom[77][1] = 8'b01110111;
  font_rom[77][2] = 8'b01111111;
  font_rom[77][3] = 8'b01111111;
  font_rom[77][4] = 8'b01101011;
  font_rom[77][5] = 8'b01100011;
  font_rom[77][6] = 8'b01100011;
  font_rom[77][7] = 8'b00000000;
  font_rom[78][0] = 8'b01100011;
  font_rom[78][1] = 8'b01100111;
  font_rom[78][2] = 8'b01101111;
  font_rom[78][3] = 8'b01111011;
  font_rom[78][4] = 8'b01110011;
  font_rom[78][5] = 8'b01100011;
  font_rom[78][6] = 8'b01100011;
  font_rom[78][7] = 8'b00000000;
  font_rom[79][0] = 8'b00011100;
  font_rom[79][1] = 8'b00110110;
  font_rom[79][2] = 8'b01100011;
  font_rom[79][3] = 8'b01100011;
  font_rom[79][4] = 8'b01100011;
  font_rom[79][5] = 8'b00110110;
  font_rom[79][6] = 8'b00011100;
  font_rom[79][7] = 8'b00000000;
  font_rom[80][0] = 8'b00111111;
  font_rom[80][1] = 8'b01100110;
  font_rom[80][2] = 8'b01100110;
  font_rom[80][3] = 8'b00111110;
  font_rom[80][4] = 8'b00000110;
  font_rom[80][5] = 8'b00000110;
  font_rom[80][6] = 8'b00001111;
  font_rom[80][7] = 8'b00000000;
  font_rom[81][0] = 8'b00011110;
  font_rom[81][1] = 8'b00110011;
  font_rom[81][2] = 8'b00110011;
  font_rom[81][3] = 8'b00110011;
  font_rom[81][4] = 8'b00111011;
  font_rom[81][5] = 8'b00011110;
  font_rom[81][6] = 8'b00111000;
  font_rom[81][7] = 8'b00000000;
  font_rom[82][0] = 8'b00111111;
  font_rom[82][1] = 8'b01100110;
  font_rom[82][2] = 8'b01100110;
  font_rom[82][3] = 8'b00111110;
  font_rom[82][4] = 8'b00110110;
  font_rom[82][5] = 8'b01100110;
  font_rom[82][6] = 8'b01100111;
  font_rom[82][7] = 8'b00000000;
  font_rom[83][0] = 8'b00011110;
  font_rom[83][1] = 8'b00110011;
  font_rom[83][2] = 8'b00000111;
  font_rom[83][3] = 8'b00001110;
  font_rom[83][4] = 8'b00111000;
  font_rom[83][5] = 8'b00110011;
  font_rom[83][6] = 8'b00011110;
  font_rom[83][7] = 8'b00000000;
  font_rom[84][0] = 8'b00111111;
  font_rom[84][1] = 8'b00101101;
  font_rom[84][2] = 8'b00001100;
  font_rom[84][3] = 8'b00001100;
  font_rom[84][4] = 8'b00001100;
  font_rom[84][5] = 8'b00001100;
  font_rom[84][6] = 8'b00011110;
  font_rom[84][7] = 8'b00000000;
  font_rom[85][0] = 8'b00110011;
  font_rom[85][1] = 8'b00110011;
  font_rom[85][2] = 8'b00110011;
  font_rom[85][3] = 8'b00110011;
  font_rom[85][4] = 8'b00110011;
  font_rom[85][5] = 8'b00110011;
  font_rom[85][6] = 8'b00111111;
  font_rom[85][7] = 8'b00000000;
  font_rom[86][0] = 8'b00110011;
  font_rom[86][1] = 8'b00110011;
  font_rom[86][2] = 8'b00110011;
  font_rom[86][3] = 8'b00110011;
  font_rom[86][4] = 8'b00110011;
  font_rom[86][5] = 8'b00011110;
  font_rom[86][6] = 8'b00001100;
  font_rom[86][7] = 8'b00000000;
  font_rom[87][0] = 8'b01100011;
  font_rom[87][1] = 8'b01100011;
  font_rom[87][2] = 8'b01100011;
  font_rom[87][3] = 8'b01101011;
  font_rom[87][4] = 8'b01111111;
  font_rom[87][5] = 8'b01110111;
  font_rom[87][6] = 8'b01100011;
  font_rom[87][7] = 8'b00000000;
  font_rom[88][0] = 8'b01100011;
  font_rom[88][1] = 8'b01100011;
  font_rom[88][2] = 8'b00110110;
  font_rom[88][3] = 8'b00011100;
  font_rom[88][4] = 8'b00011100;
  font_rom[88][5] = 8'b00110110;
  font_rom[88][6] = 8'b01100011;
  font_rom[88][7] = 8'b00000000;
  font_rom[89][0] = 8'b00110011;
  font_rom[89][1] = 8'b00110011;
  font_rom[89][2] = 8'b00110011;
  font_rom[89][3] = 8'b00011110;
  font_rom[89][4] = 8'b00001100;
  font_rom[89][5] = 8'b00001100;
  font_rom[89][6] = 8'b00011110;
  font_rom[89][7] = 8'b00000000;
  font_rom[90][0] = 8'b01111111;
  font_rom[90][1] = 8'b01100011;
  font_rom[90][2] = 8'b00110001;
  font_rom[90][3] = 8'b00011000;
  font_rom[90][4] = 8'b01001100;
  font_rom[90][5] = 8'b01100110;
  font_rom[90][6] = 8'b01111111;
  font_rom[90][7] = 8'b00000000;
  font_rom[91][0] = 8'b00011110;
  font_rom[91][1] = 8'b00000110;
  font_rom[91][2] = 8'b00000110;
  font_rom[91][3] = 8'b00000110;
  font_rom[91][4] = 8'b00000110;
  font_rom[91][5] = 8'b00000110;
  font_rom[91][6] = 8'b00011110;
  font_rom[91][7] = 8'b00000000;
  font_rom[92][0] = 8'b00000011;
  font_rom[92][1] = 8'b00000110;
  font_rom[92][2] = 8'b00001100;
  font_rom[92][3] = 8'b00011000;
  font_rom[92][4] = 8'b00110000;
  font_rom[92][5] = 8'b01100000;
  font_rom[92][6] = 8'b01000000;
  font_rom[92][7] = 8'b00000000;
  font_rom[93][0] = 8'b00011110;
  font_rom[93][1] = 8'b00011000;
  font_rom[93][2] = 8'b00011000;
  font_rom[93][3] = 8'b00011000;
  font_rom[93][4] = 8'b00011000;
  font_rom[93][5] = 8'b00011000;
  font_rom[93][6] = 8'b00011110;
  font_rom[93][7] = 8'b00000000;
  font_rom[94][0] = 8'b00001000;
  font_rom[94][1] = 8'b00011100;
  font_rom[94][2] = 8'b00110110;
  font_rom[94][3] = 8'b01100011;
  font_rom[94][4] = 8'b00000000;
  font_rom[94][5] = 8'b00000000;
  font_rom[94][6] = 8'b00000000;
  font_rom[94][7] = 8'b00000000;
  font_rom[95][0] = 8'b00000000;
  font_rom[95][1] = 8'b00000000;
  font_rom[95][2] = 8'b00000000;
  font_rom[95][3] = 8'b00000000;
  font_rom[95][4] = 8'b00000000;
  font_rom[95][5] = 8'b00000000;
  font_rom[95][6] = 8'b00000000;
  font_rom[95][7] = 8'b11111111;
  font_rom[96][0] = 8'b00001100;
  font_rom[96][1] = 8'b00001100;
  font_rom[96][2] = 8'b00011000;
  font_rom[96][3] = 8'b00000000;
  font_rom[96][4] = 8'b00000000;
  font_rom[96][5] = 8'b00000000;
  font_rom[96][6] = 8'b00000000;
  font_rom[96][7] = 8'b00000000;
  font_rom[97][0] = 8'b00000000;
  font_rom[97][1] = 8'b00000000;
  font_rom[97][2] = 8'b00011110;
  font_rom[97][3] = 8'b00110000;
  font_rom[97][4] = 8'b00111110;
  font_rom[97][5] = 8'b00110011;
  font_rom[97][6] = 8'b01101110;
  font_rom[97][7] = 8'b00000000;
  font_rom[98][0] = 8'b00000111;
  font_rom[98][1] = 8'b00000110;
  font_rom[98][2] = 8'b00000110;
  font_rom[98][3] = 8'b00111110;
  font_rom[98][4] = 8'b01100110;
  font_rom[98][5] = 8'b01100110;
  font_rom[98][6] = 8'b00111011;
  font_rom[98][7] = 8'b00000000;
  font_rom[99][0] = 8'b00000000;
  font_rom[99][1] = 8'b00000000;
  font_rom[99][2] = 8'b00011110;
  font_rom[99][3] = 8'b00110011;
  font_rom[99][4] = 8'b00000011;
  font_rom[99][5] = 8'b00110011;
  font_rom[99][6] = 8'b00011110;
  font_rom[99][7] = 8'b00000000;
  font_rom[100][0] = 8'b00111000;
  font_rom[100][1] = 8'b00110000;
  font_rom[100][2] = 8'b00110000;
  font_rom[100][3] = 8'b00111110;
  font_rom[100][4] = 8'b00110011;
  font_rom[100][5] = 8'b00110011;
  font_rom[100][6] = 8'b01101110;
  font_rom[100][7] = 8'b00000000;
  font_rom[101][0] = 8'b00000000;
  font_rom[101][1] = 8'b00000000;
  font_rom[101][2] = 8'b00011110;
  font_rom[101][3] = 8'b00110011;
  font_rom[101][4] = 8'b00111111;
  font_rom[101][5] = 8'b00000011;
  font_rom[101][6] = 8'b00011110;
  font_rom[101][7] = 8'b00000000;
  font_rom[102][0] = 8'b00011100;
  font_rom[102][1] = 8'b00110110;
  font_rom[102][2] = 8'b00000110;
  font_rom[102][3] = 8'b00001111;
  font_rom[102][4] = 8'b00000110;
  font_rom[102][5] = 8'b00000110;
  font_rom[102][6] = 8'b00001111;
  font_rom[102][7] = 8'b00000000;
  font_rom[103][0] = 8'b00000000;
  font_rom[103][1] = 8'b00000000;
  font_rom[103][2] = 8'b01101110;
  font_rom[103][3] = 8'b00110011;
  font_rom[103][4] = 8'b00110011;
  font_rom[103][5] = 8'b00111110;
  font_rom[103][6] = 8'b00110000;
  font_rom[103][7] = 8'b00011111;
  font_rom[104][0] = 8'b00000111;
  font_rom[104][1] = 8'b00000110;
  font_rom[104][2] = 8'b00110110;
  font_rom[104][3] = 8'b01101110;
  font_rom[104][4] = 8'b01100110;
  font_rom[104][5] = 8'b01100110;
  font_rom[104][6] = 8'b01100111;
  font_rom[104][7] = 8'b00000000;
  font_rom[105][0] = 8'b00001100;
  font_rom[105][1] = 8'b00000000;
  font_rom[105][2] = 8'b00001110;
  font_rom[105][3] = 8'b00001100;
  font_rom[105][4] = 8'b00001100;
  font_rom[105][5] = 8'b00001100;
  font_rom[105][6] = 8'b00011110;
  font_rom[105][7] = 8'b00000000;
  font_rom[106][0] = 8'b00110000;
  font_rom[106][1] = 8'b00000000;
  font_rom[106][2] = 8'b00110000;
  font_rom[106][3] = 8'b00110000;
  font_rom[106][4] = 8'b00110000;
  font_rom[106][5] = 8'b00110011;
  font_rom[106][6] = 8'b00110011;
  font_rom[106][7] = 8'b00011110;
  font_rom[107][0] = 8'b00000111;
  font_rom[107][1] = 8'b00000110;
  font_rom[107][2] = 8'b01100110;
  font_rom[107][3] = 8'b00110110;
  font_rom[107][4] = 8'b00011110;
  font_rom[107][5] = 8'b00110110;
  font_rom[107][6] = 8'b01100111;
  font_rom[107][7] = 8'b00000000;
  font_rom[108][0] = 8'b00001110;
  font_rom[108][1] = 8'b00001100;
  font_rom[108][2] = 8'b00001100;
  font_rom[108][3] = 8'b00001100;
  font_rom[108][4] = 8'b00001100;
  font_rom[108][5] = 8'b00001100;
  font_rom[108][6] = 8'b00011110;
  font_rom[108][7] = 8'b00000000;
  font_rom[109][0] = 8'b00000000;
  font_rom[109][1] = 8'b00000000;
  font_rom[109][2] = 8'b00110011;
  font_rom[109][3] = 8'b01111111;
  font_rom[109][4] = 8'b01111111;
  font_rom[109][5] = 8'b01101011;
  font_rom[109][6] = 8'b01100011;
  font_rom[109][7] = 8'b00000000;
  font_rom[110][0] = 8'b00000000;
  font_rom[110][1] = 8'b00000000;
  font_rom[110][2] = 8'b00011111;
  font_rom[110][3] = 8'b00110011;
  font_rom[110][4] = 8'b00110011;
  font_rom[110][5] = 8'b00110011;
  font_rom[110][6] = 8'b00110011;
  font_rom[110][7] = 8'b00000000;
  font_rom[111][0] = 8'b00000000;
  font_rom[111][1] = 8'b00000000;
  font_rom[111][2] = 8'b00011110;
  font_rom[111][3] = 8'b00110011;
  font_rom[111][4] = 8'b00110011;
  font_rom[111][5] = 8'b00110011;
  font_rom[111][6] = 8'b00011110;
  font_rom[111][7] = 8'b00000000;
  font_rom[112][0] = 8'b00000000;
  font_rom[112][1] = 8'b00000000;
  font_rom[112][2] = 8'b00111011;
  font_rom[112][3] = 8'b01100110;
  font_rom[112][4] = 8'b01100110;
  font_rom[112][5] = 8'b00111110;
  font_rom[112][6] = 8'b00000110;
  font_rom[112][7] = 8'b00001111;
  font_rom[113][0] = 8'b00000000;
  font_rom[113][1] = 8'b00000000;
  font_rom[113][2] = 8'b01101110;
  font_rom[113][3] = 8'b00110011;
  font_rom[113][4] = 8'b00110011;
  font_rom[113][5] = 8'b00111110;
  font_rom[113][6] = 8'b00110000;
  font_rom[113][7] = 8'b01111000;
  font_rom[114][0] = 8'b00000000;
  font_rom[114][1] = 8'b00000000;
  font_rom[114][2] = 8'b00111011;
  font_rom[114][3] = 8'b01101110;
  font_rom[114][4] = 8'b01100110;
  font_rom[114][5] = 8'b00000110;
  font_rom[114][6] = 8'b00001111;
  font_rom[114][7] = 8'b00000000;
  font_rom[115][0] = 8'b00000000;
  font_rom[115][1] = 8'b00000000;
  font_rom[115][2] = 8'b00111110;
  font_rom[115][3] = 8'b00000011;
  font_rom[115][4] = 8'b00011110;
  font_rom[115][5] = 8'b00110000;
  font_rom[115][6] = 8'b00011111;
  font_rom[115][7] = 8'b00000000;
  font_rom[116][0] = 8'b00001000;
  font_rom[116][1] = 8'b00001100;
  font_rom[116][2] = 8'b00111110;
  font_rom[116][3] = 8'b00001100;
  font_rom[116][4] = 8'b00001100;
  font_rom[116][5] = 8'b00101100;
  font_rom[116][6] = 8'b00011000;
  font_rom[116][7] = 8'b00000000;
  font_rom[117][0] = 8'b00000000;
  font_rom[117][1] = 8'b00000000;
  font_rom[117][2] = 8'b00110011;
  font_rom[117][3] = 8'b00110011;
  font_rom[117][4] = 8'b00110011;
  font_rom[117][5] = 8'b00110011;
  font_rom[117][6] = 8'b01101110;
  font_rom[117][7] = 8'b00000000;
  font_rom[118][0] = 8'b00000000;
  font_rom[118][1] = 8'b00000000;
  font_rom[118][2] = 8'b00110011;
  font_rom[118][3] = 8'b00110011;
  font_rom[118][4] = 8'b00110011;
  font_rom[118][5] = 8'b00011110;
  font_rom[118][6] = 8'b00001100;
  font_rom[118][7] = 8'b00000000;
  font_rom[119][0] = 8'b00000000;
  font_rom[119][1] = 8'b00000000;
  font_rom[119][2] = 8'b01100011;
  font_rom[119][3] = 8'b01101011;
  font_rom[119][4] = 8'b01111111;
  font_rom[119][5] = 8'b01111111;
  font_rom[119][6] = 8'b00110110;
  font_rom[119][7] = 8'b00000000;
  font_rom[120][0] = 8'b00000000;
  font_rom[120][1] = 8'b00000000;
  font_rom[120][2] = 8'b01100011;
  font_rom[120][3] = 8'b00110110;
  font_rom[120][4] = 8'b00011100;
  font_rom[120][5] = 8'b00110110;
  font_rom[120][6] = 8'b01100011;
  font_rom[120][7] = 8'b00000000;
  font_rom[121][0] = 8'b00000000;
  font_rom[121][1] = 8'b00000000;
  font_rom[121][2] = 8'b00110011;
  font_rom[121][3] = 8'b00110011;
  font_rom[121][4] = 8'b00110011;
  font_rom[121][5] = 8'b00111110;
  font_rom[121][6] = 8'b00110000;
  font_rom[121][7] = 8'b00011111;
  font_rom[122][0] = 8'b00000000;
  font_rom[122][1] = 8'b00000000;
  font_rom[122][2] = 8'b00111111;
  font_rom[122][3] = 8'b00011001;
  font_rom[122][4] = 8'b00001100;
  font_rom[122][5] = 8'b00100110;
  font_rom[122][6] = 8'b00111111;
  font_rom[122][7] = 8'b00000000;
  font_rom[123][0] = 8'b00111000;
  font_rom[123][1] = 8'b00001100;
  font_rom[123][2] = 8'b00001100;
  font_rom[123][3] = 8'b00000111;
  font_rom[123][4] = 8'b00001100;
  font_rom[123][5] = 8'b00001100;
  font_rom[123][6] = 8'b00111000;
  font_rom[123][7] = 8'b00000000;
  font_rom[124][0] = 8'b00011000;
  font_rom[124][1] = 8'b00011000;
  font_rom[124][2] = 8'b00011000;
  font_rom[124][3] = 8'b00000000;
  font_rom[124][4] = 8'b00011000;
  font_rom[124][5] = 8'b00011000;
  font_rom[124][6] = 8'b00011000;
  font_rom[124][7] = 8'b00000000;
  font_rom[125][0] = 8'b00000111;
  font_rom[125][1] = 8'b00001100;
  font_rom[125][2] = 8'b00001100;
  font_rom[125][3] = 8'b00111000;
  font_rom[125][4] = 8'b00001100;
  font_rom[125][5] = 8'b00001100;
  font_rom[125][6] = 8'b00000111;
  font_rom[125][7] = 8'b00000000;
  font_rom[126][0] = 8'b01101110;
  font_rom[126][1] = 8'b00111011;
  font_rom[126][2] = 8'b00000000;
  font_rom[126][3] = 8'b00000000;
  font_rom[126][4] = 8'b00000000;
  font_rom[126][5] = 8'b00000000;
  font_rom[126][6] = 8'b00000000;
  font_rom[126][7] = 8'b00000000;
  font_rom[127][0] = 8'b00000000;
  font_rom[127][1] = 8'b00000000;
  font_rom[127][2] = 8'b00000000;
  font_rom[127][3] = 8'b00000000;
  font_rom[127][4] = 8'b00000000;
  font_rom[127][5] = 8'b00000000;
  font_rom[127][6] = 8'b00000000;
  font_rom[127][7] = 8'b00000000;
end



wire pixel = font_rom[char][w_y][w_x];
//for now, testing
assign r = pixel ? 4'b1111 : 4'b0000;
assign g = pixel ? 4'b1111 : 4'b0000;
assign b = pixel ? 4'b1111 : 4'b0000;


endmodule
