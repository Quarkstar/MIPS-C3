`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:22:27 12/09/2018 
// Design Name: 
// Module Name:    ext 
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
module ext(
	input [1:0] extop,
    input [15:0] in,
    output reg [31:0] out
    );
	 
	always @ (in, extop ) begin
		case(extop)
			2'b 00 : out <= {16'h 0000, in};
			2'b 01 : out <= {{16{in[15]}}, in}; 
			2'b 10 : out <= {in, 16'h 0000};
			default : out <= 32'b0;
		endcase
	end

endmodule
