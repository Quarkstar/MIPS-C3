`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:08 12/08/2018 
// Design Name: 
// Module Name:    ex 
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
module ex(
    input [31:0] instre, pce,
	input [31:0] read1e, read2e,imme,
	//forward
	input clk, reset,
	input [1:0] frse, frte,
	input [31:0] resultw,pcplus8m,aluoutm,
	output starte,busye,
	output [4:0] writerege,
	output [31:0] aluoute,writedatae,pcplus8e
    );
	 
	wire  alusrce,mdfamily;
	wire [3:0] aluope;
   wire [1:0] regdste;
	wire [31:0] aluinae, tempaluinbe, aluinbe, multdivoute, tempaluoute;
	 
	assign pcplus8e = pce + 8;
	 
	ctrl ctrle( .instr(instre),
	            .mdfamily(mdfamily),
			    .alusrc(alusrce), .regdst(regdste), 
				.regwrite(regwritee),
	            .aluop(aluope));
					
	 mux4 mfrse(.a(read1e), .b(aluoutm), .c(pcplus8m), .d(resultw), .s(frse), .result(aluinae));
	 mux4 mfrte(.a(read2e), .b(aluoutm), .c(pcplus8m), .d(resultw), .s(frte), .result(tempaluinbe));
	 
	 mux2 alumux(.a(tempaluinbe), .b(imme), .s(alusrce), .result(aluinbe));
	 
	 assign writedatae = tempaluinbe;
	 
	 alu alu(.a(aluinae), .b(aluinbe), .c(instre[10:6]), .aluop(aluope), .out(tempaluoute));
	 
	 muldiv muldiv(.a(aluinae), .b(aluinbe), .clk(clk), .reset(reset), .instr(instre), .multdivout(multdivoute), .start(starte), .busy(busye));
	 
	 assign aluoute = (mdfamily) ? multdivoute : tempaluoute;
	 
	 mux4 #(5) regmux(.a(instre[20:16]), .b(instre[15:11]), .c(5'b11111), .s(regdste), .result(writerege));
					
endmodule
