`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:19 12/08/2018 
// Design Name: 
// Module Name:    npc 
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
module npc(
	input beqd, jumpd, jrd, jalrd, bned, bltzd, bgtzd, blezd, bgezd,
    input equald, ltzd, gtzd, lezd, gezd,
    input [31:0] pcd,
    input [31:0] immd, instrd, read1d,
	output reg [31:0] npcd 
    );
	  
	wire [31:0] pcplus4d = pcd + 4;
	 
	always @ (*) begin
	    if(jumpd === 1)
		    npcd <= {pcplus4d[31:28],instrd[25:0],2'b00};
		else if(jrd === 1)
		    npcd <= read1d;
	   else if(jalrd === 1)
		    npcd <= read1d;
		else if((beqd && equald) || (bned && !equald) || (bltzd && ltzd) || (bgtzd && gtzd) || (blezd && lezd) || (bgezd && gezd))
		    npcd <= pcplus4d + {immd[29:0],2'b00};
		else 
		    npcd <= 0;
	end

endmodule
