`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:32:07 12/09/2018 
// Design Name: 
// Module Name:    wb 
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
module wb(
    input [31:0] instrw,pcw,
	input [31:0] aluoutw,readdataw,
	output regwritew,
	output reg [4:0] writeregw,
	output [31:0] resultw
    );
	 
	wire [31:0] tempresultw,finalreaddataw;
	wire [31:0] pcplus8w = pcw + 8;
	wire [1:0] regdstw;
	wire pctoregw,memtoregw;
	wire lww,lbw,lbuw,lhw,lhuw;
	 
	ctrl ctrlw( .instr(instrw), 
	            .regdst(regdstw),  .pctoreg(pctoregw), .memtoreg(memtoregw),
				.regwrite(regwritew),
				.lw(lww), .lb(lbw), .lbu(lbuw), .lh(lhw), .lhu(lhuw));
				
	wbloadext loadext(.lw(lww), .lb(lbw), .lbu(lbuw), .lh(lhw), .lhu(lhuw),
	                  .byteaddr(aluoutw[1:0]),
							.readdata(readdataw),
							.finalreaddata(finalreaddataw));
	 
    mux2 writedatamux(.a(aluoutw), .b(finalreaddataw),  .s(memtoregw), .result(tempresultw));
	 
	mux2 pcplus8mux(.a(tempresultw), .b(pcplus8w),  .s(pctoregw), .result(resultw));
	 
	always @ (*) begin
	    case(regdstw)
		    2'b00: writeregw <= instrw[20:16];
			2'b01: writeregw <= instrw[15:11];
			2'b10: writeregw <= 5'b11111;
		endcase
	end

endmodule
