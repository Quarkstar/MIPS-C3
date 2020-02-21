`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:16 12/08/2018 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input [31:0] a,
    input [31:0] b,
	input [4:0] c,
    input [3:0] aluop,
    output reg [31:0] out
    );
	 
	 
	parameter   add  = 4'b0000,
	            sub  = 4'b0001,
				andc = 4'b0010,
				orc  = 4'b0011,
				xorc = 4'b0100,
				norc = 4'b0101,
				slt  = 4'b0110,
				sllv  = 4'b0111,
				srlv  = 4'b1000,
				sra  = 4'b1001,
				sll  = 4'b1010,
				srl  = 4'b1011,
				srav = 4'b1100,
				sltu = 4'b1101;
						 
	always @ ( aluop, a, b, c ) begin
		case(aluop)
			add : out <= $signed(a) + $signed(b);
			sub : out <= $signed(a) - $signed(b);
			andc : out <= a & b;
			orc  : out <= a | b;
			xorc : out <= a ^ b;
			norc : out <= ~(a | b);
			slt : out <= $signed(a) < $signed(b) ? 1 : 0;
			sllv : out <= b << a[4:0];
			srlv : out <= b >> a[4:0];
			sra : out <= $signed(b) >>> c;
			sll : out <= b << c;
			srl : out <= b >> c;
			srav: out <= $signed(b) >>> a[4:0];
			sltu: out <= a < b ? 1 : 0;
			default : out <= 0;
		endcase
	end


endmodule
