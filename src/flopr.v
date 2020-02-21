`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:28 12/08/2018 
// Design Name: 
// Module Name:    flopr 
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
module flopr #(parameter WIDTH = 32)
   (input clk, reset, stall,
	input [WIDTH-1:0] in,
	output reg [WIDTH-1:0] out);
	  
	initial begin
	    out <= 0;
	end
	
    always @ (posedge clk) begin
	    if(reset) out <= 0;
	    else if(stall == 0)  out <= in;
	end
	
endmodule


