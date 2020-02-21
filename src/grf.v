`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:40:32 12/08/2018 
// Design Name: 
// Module Name:    grf 
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
module grf(
	input clk, reset,
    input regwrite,
    input [4:0] addr1, addr2, writereg,
    input [31:0] writedata, pc,instr,
    output reg [31:0] readdata1, readdata2
    );

    reg [31:0] RF [31:0];
	integer i;
	 
	always @ ( * ) begin
	        readdata1 <= (addr1 === 0) ? 0 : RF[addr1];
	        readdata2 <= (addr2 === 0) ? 0 : RF[addr2];
	end
	 
	initial begin
	for(i=0; i<32; i=i+1)
		    RF[i] <= 0;
	end
	 
	always @ (negedge clk) begin
	    if(reset === 1) begin
	        for(i=0; i<32; i=i+1)
		        RF[i] <= 0;
	    end
	    else if(regwrite) begin
	        RF[writereg] <= writedata;
			 // if(pc==32'h00003040) $display("%d@%h: $%d <= %h", $time, pc, writereg,instr);
		   // else 
			 $display("%d@%h: $%d <= %h", $time, pc, writereg,writedata);
	    end
	end

endmodule
