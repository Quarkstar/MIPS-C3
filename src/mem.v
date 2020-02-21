`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:49 12/08/2018 
// Design Name: 
// Module Name:    mem 
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
module mem(
    input clk,reset,
    input [31:0] instrm,pcm,
	input [31:0] aluoutm, tempwritedatam,
	//forward
	input frtm,
	input [31:0] resultw,
    output [31:0] readdatam,pcplus8m	 
    );
	 
	wire memreadm,memwritem;
	wire swm, shm, sbm;
	wire [31:0] writedatam;
	assign pcplus8m = pcm + 8;
	 
	ctrl ctrlm( .instr(instrm),
				.memread(memreadm), .memwrite(memwritem),
				.sw(swm), .sh(shm), .sb(sbm));
					
	mux2 mfrtm(.a(tempwritedatam), .b(resultw), .s(frtm), .result(writedatam));

					
	dmem dmem(  .clk(clk), .reset(reset),
	            .memread(memreadm), .memwrite(memwritem),
					.sw(swm), .sh(shm), .sb(sbm),
	            .addr(aluoutm), .writedata(writedatam), .pc(pcm),
	            .readdata(readdatam));

endmodule
