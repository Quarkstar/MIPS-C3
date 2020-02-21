`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:39:43 12/08/2018 
// Design Name: 
// Module Name:    if 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IF(
	input clk, reset,stallf,
	input pcchangef,
	input [31:0] pcbranchf,
	output [31:0] instrf, pcf
    );
	 
	wire [31:0] npcin;
	wire [31:0] pcplus4 = pcf + 4;
	
	mux2 pcmux(.a(pcplus4), .b(pcbranchf), .s(pcchangef), .result(npcin));

	pc pc(.clk(clk), .reset(reset), .en(stallf), .pcin(npcin), .pcout(pcf));

	imem imem(.addr(pcf[13:2]), .instr(instrf));
	
endmodule
