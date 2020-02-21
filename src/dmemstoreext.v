`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:13:48 12/11/2018 
// Design Name: 
// Module Name:    dmemstoreext 
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
module dmemstoreext(
	 input sw, sh, sb,
	 input [1:0] byteaddr,
	 output reg [3:0] be
    );
	 
	 always @ ( * ) begin
	     if(sw === 1)
		      be <= 4'b1111;
        else if( sh === 1) begin
                 if(byteaddr[1] === 1)
                     be <= 4'b1100;
                 else
                     be <= 4'b0011;
             end
        else if( sb === 1 ) begin
				     case(byteaddr)
					      2'b00: be <= 4'b0001;
							2'b01: be <= 4'b0010;
							2'b10: be <= 4'b0100;
							2'b11: be <= 4'b1000;
					  endcase
             end
        else be <= 4'b0000;				 
	 
	 end


endmodule
