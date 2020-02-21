`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:10 12/08/2018 
// Design Name: 
// Module Name:    mux 
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
module mux2 #(parameter WIDTH=32)
   (input [WIDTH-1:0] a,b,
	input s,
    output [WIDTH-1:0] result);
	  
    assign result = (s == 0) ? a : b;

endmodule

module mux4 #(parameter WIDTH=32)
   (input [WIDTH-1:0] a,b,c,d,
	input [1:0] s,
    output reg [WIDTH-1:0] result);
	  
    always @ ( * ) begin
	    case(s)
			2'b00: result <= a;
			2'b01: result <= b;
			2'b10: result <= c;
			2'b11: result <= d;
			default: result <= 0;
	    endcase
	end

endmodule

module mux8 #(parameter WIDTH=32)
   (input [WIDTH-1:0] a,b,c,d,e,f,g,h,
	input [2:0] s,
    output reg [WIDTH-1:0] result);
	  
    always @ ( * ) begin
	    case(s)
			3'b000: result <= a;
			3'b001: result <= b;
			3'b010: result <= c;
			3'b011: result <= d;
			3'b100: result <= e;
			default: result <= 0;
	    endcase
	end
	
endmodule



