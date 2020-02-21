`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:58:26 12/08/2018 
// Design Name: 
// Module Name:    pc 
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
module pc(
    input clk, reset, en,
	input [31:0] pcin,
    output reg [31:0] pcout
    );
	 
	initial begin
		pcout <= 32'h00003000;
	end
	
	always @ (posedge clk) begin
		if(reset === 1)
			pcout <= 32'h00003000;
		else if(!en)
			pcout <= pcin;
	end

endmodule
