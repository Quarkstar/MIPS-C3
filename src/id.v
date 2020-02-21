`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:39:56 12/08/2018 
// Design Name: 
// Module Name:    id 
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
module id(
	input clk,reset,regwritew,
	input [4:0] writeregw,
    input [31:0] instrd,pcd,pcw,resultw,instrw,
	input [2:0] frsd,frtd,
	input [31:0] pcplus8e,aluoutm,pcplus8m,
	output pcchanged,
	output [31:0] read1d, read2d, immd, pcbranchd
    );
	 
	wire regwrited,jumpd,jrd,beqd,jalrd;
	wire [1:0] extopd;
	wire [31:0] tempread1d,tempread2d;
	 
	ctrl ctrld( .instr(instrd),
                .jump(jumpd), .jr(jrd), .jalr(jalrd), .beq(beqd), .bne(bned), .bltz(bltzd), .bgtz(bgtzd), .blez(blezd), .bgez(bgezd),
				.extop(extopd));
	 
	grf  grf(   .clk(clk), .reset(reset),
	            .regwrite(regwritew),
	            .addr1(instrd[25:21]), .addr2(instrd[20:16]), .writereg(writeregw), 
				.writedata(resultw), .pc(pcw), .instr(instrw),  
				.readdata1(tempread1d), .readdata2(tempread2d));
				 
	mux8 mfrsd(.a(tempread1d), .b(pcplus8e), .c(aluoutm), .d(pcplus8m), .e(resultw), .s(frsd), .result(read1d));
	 
	mux8 mfrtd(.a(tempread2d), .b(pcplus8e), .c(aluoutm), .d(pcplus8m), .e(resultw), .s(frtd), .result(read2d));
	 
	wire equald = (read1d === read2d) ? 1 : 0;
	wire ltzd = ($signed(read1d) < 0 ) ? 1 : 0;
	wire gtzd = ($signed(read1d) > 0 ) ? 1 : 0;
	wire lezd = ($signed(read1d) <= 0 ) ? 1 : 0;
	wire gezd = ($signed(read1d) >= 0 ) ? 1 : 0;

	 
	npc  npc(   .beqd(beqd), .bned(bned), .bltzd(bltzd), .bgtzd(bgtzd), .jumpd(jumpd), .jrd(jrd), .jalrd(jalrd), .blezd(blezd), .bgezd(bgezd), 
	            .equald(equald), .ltzd(ltzd), .gtzd(gtzd), .lezd(lezd), .gezd(gezd), 
				.pcd(pcd),
	            .read1d(read1d), .immd(immd), .instrd(instrd), 
		        .npcd(pcbranchd));
		  
    assign pcchanged = jrd |  jumpd | jalrd | (beqd && equald) | (bned && !equald) |(bltzd && ltzd) | (bgtzd && gtzd)  |(blezd && lezd)  |(bgezd && gezd);	
	
	ext  ext(.extop(extopd), .in(instrd[15:0]), .out(immd));


endmodule
