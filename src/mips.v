`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:14:49 12/08/2018 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 
	wire stallf,stalld,flushe;
	 
	wire pcchangef; 
	wire [31:0] instrf,pcf,pcbranchf;
	 
	wire [2:0] frsd,frtd;
	wire [31:0] instrd,pcd,read1d,read2d,immd;
	
   wire busye, starte;	
	wire [1:0] frse,frte;
	wire [4:0] writerege;
	wire [31:0] instre,pce,read1e,read2e,imme,aluoute,writedatae,pcplus8e;
	 
	wire  frtm;
	wire [31:0] instrm,pcm,aluoutm,readdatam,writedatam,pcplus8m;
	 
	wire regwritew;
	wire [4:0] writeregw;
	wire [31:0] instrw,pcw,aluoutw,readdataw,resultw;
	 
	IF IF(.clk(clk), .reset(reset), .stallf(stallf),
          .pcbranchf(pcbranchf),	 .pcchangef(pcchangef),
	       .pcf(pcf), .instrf(instrf));
	 
	flopr #(64) IF_id(.clk(clk), .reset(reset), .stall(stalld), 
	                   .in( {instrf,pcf}), 
							 .out({instrd,pcd}));
	 
	id id(  .clk(clk), .reset(reset),.regwritew(regwritew),
            .writeregw(writeregw),
	        .instrd(instrd), .pcd(pcd), .pcw(pcw), .resultw(resultw), .instrw(instrw),
	        .frsd(frsd), .frtd(frtd), 
			.pcplus8e(pcplus8e), .aluoutm(aluoutm), .pcplus8m(pcplus8m),
			.pcchanged(pcchangef),
			.read1d(read1d), .read2d(read2d), .immd(immd),.pcbranchd(pcbranchf));
	 
	flopr #(160) id_ex( .clk(clk), .reset(reset || flushe), .stall(1'b0),
	                    .in( {instrd, pcd, read1d, read2d, immd}), 
						.out({instre, pce, read1e, read2e, imme}));
	 
	ex ex(   .clk(clk), .reset(reset),
           	.instre(instre), .pce(pce), 
	        .read1e(read1e), .read2e(read2e), .imme(imme),
		    .frse(frse), .frte(frte),
			.resultw(resultw), .pcplus8m(pcplus8m), .aluoutm(aluoutm),
			.starte(starte), .busye(busye),
			.writerege(writerege), 
			.aluoute(aluoute), .writedatae(writedatae), .pcplus8e(pcplus8e));
	 
	flopr #(128) ex_mem(.clk(clk), .reset(reset), .stall(1'b0),
	                    .in( {instre, pce, aluoute, writedatae}), 
						.out({instrm, pcm, aluoutm, writedatam}));
	 
	mem mem(.clk(clk), .reset(reset),
	         .instrm(instrm), .frtm(frtm), 
				.aluoutm(aluoutm), .tempwritedatam(writedatam), .pcm(pcm), .resultw(resultw),
			   .readdatam(readdatam), .pcplus8m(pcplus8m));
	 
	flopr #(128) mem_wb(.clk(clk), .reset(reset), .stall(1'b0),
	                    .in( {instrm, pcm, aluoutm, readdatam}), 
						.out({instrw, pcw, aluoutw, readdataw}));
	 
	wb wb(  .instrw(instrw), .pcw(pcw),
	        .aluoutw(aluoutw), .readdataw(readdataw),   
			.regwritew(regwritew),  .writeregw(writeregw), .resultw(resultw));
	 
    hazard hazardunit( .instrd(instrd), .instre(instre), .instrm(instrm), .instrw(instrw),
	                    .start(starte), .busy(busye),
	                   .stallf(stallf), .stalld(stalld), .flushe(flushe),
					   .frsd(frsd), .frtd(frtd), .frse(frse), .frte(frte), .frtm(frtm)); 

endmodule
