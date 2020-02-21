`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:54 12/08/2018 
// Design Name: 
// Module Name:    imem 
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
module imem(
    input [13:2] addr,
    output reg [31:0] instr
    );
	 
	reg [31:0] rom [4095:0];
	wire [11:0] addrnew = addr - 3072;
	 
	initial begin
		$readmemh("code.txt",rom);
	end
	 
	always @ (addr)
	    instr <= rom[addrnew];


endmodule
