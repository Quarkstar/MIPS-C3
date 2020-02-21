`timescale 1ns / 1ps
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define fn 5:0 

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:40:31 12/09/2018 
// Design Name: 
// Module Name:    hazard 
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
module hazard(
    input [31:0] instrd,instre,instrm,instrw,
	 input start,busy,
	output stallf,stalld,flushe,
	output frtm,
	output [1:0] frse,frte,
	output [2:0] frsd,frtd
    );

	wire bfamilyd, rrfamilyd, rifamilyd, loadfamilyd, storefamilyd, jalfamilyd, jrfamilyd,mdfamilyd,
		bfamilye, rrfamilye, rifamilye, loadfamilye, storefamilye, jalfamilye, jrfamilye,mdfamilye,
		bfamilym, rrfamilym, rifamilym, loadfamilym, storefamilym, jalfamilym, jrfamilym,
		bfamilyw, rrfamilyw, rifamilyw, loadfamilyw, storefamilyw, jalfamilyw, jrfamilyw;

   decoder decoderd(.instr(instrd),  .bfamily(bfamilyd), .rrfamily(rrfamilyd),
	                 .rifamily(rifamilyd), .loadfamily(loadfamilyd), .storefamily(storefamilyd),
					 .jalfamily(jalfamilyd), .jrfamily(jrfamilyd), .mdfamily(mdfamilyd));

	decoder decodere(.instr(instre), .bfamily(bfamilye), .rrfamily(rrfamilye),
	                 .rifamily(rifamilye), .loadfamily(loadfamilye), .storefamily(storefamilye),
					 .jalfamily(jalfamilye), .jrfamily(jrfamilye), .mdfamily(mdfamilye));

	decoder decoderm(.instr(instrm), .bfamily(bfamilym), .rrfamily(rrfamilym),
	                 .rifamily(rifamilym), .loadfamily(loadfamilym), .storefamily(storefamilym),
					 .jalfamily(jalfamilym), .jrfamily(jrfamilym));

	decoder decoderw(.instr(instrw), .bfamily(bfamilyw), .rrfamily(rrfamilyw),
	                 .rifamily(rifamilyw), .loadfamily(loadfamilyw), .storefamily(storefamilyw),
					 .jalfamily(jalfamilyw), .jrfamily(jrfamilyw));
	 


    wire stallb,stallrr,stallri,stallswrs,stalljr;
	assign stallf = stall;
	assign stalld = stall;
	assign flushe = stall;
	wire stall = stallb || stallrr || stallri || stallload || stallswrs || stalljr || stallmd;
	 
	assign stallb =   bfamilyd & rrfamilye & ((instre[`rd] === instrd[`rs]) | (instre[`rd] === instrd[`rt]))
	                | bfamilyd & rifamilye & ((instre[`rt] === instrd[`rs]) | (instre[`rt] === instrd[`rt]))
	                | bfamilyd & loadfamilye & ((instre[`rt] === instrd[`rs]) | (instre[`rt] === instrd[`rt]))
					| bfamilyd & loadfamilym & ((instrm[`rt] === instrd[`rs]) | (instrm[`rt] === instrd[`rt]));
	 
	assign stallrr =  rrfamilyd & loadfamilye & ((instre[`rt] === instrd[`rs]) | (instre[`rt] === instrd[`rt]));	
    
    assign stallri =  rifamilyd & loadfamilye & (instre[`rt] === instrd[`rs]);
	 
	assign stallload = loadfamilyd & loadfamilye & (instre[`rt] === instrd[`rs]);
	 
	assign stallswrs = storefamilyd & loadfamilye & (instre[`rt] === instrd[`rs]);

	assign stalljr =  jrfamilyd & rrfamilye & (instre[`rd] === instrd[`rs]) 
	                | jrfamilyd & rifamilye & (instre[`rt] === instrd[`rs]) 
	                | jrfamilyd & loadfamilye & (instre[`rt] === instrd[`rs]) 
					| jrfamilyd & loadfamilym & (instrm[`rt] === instrd[`rs]);
						  
	assign stallmd = mdfamilyd & (start | busy);
						  
	assign frsd =	
            (instrd[`rs] == 0) ? 0 :	 
				(bfamilyd | jrfamilyd) & jalfamilye & (instrd[`rs] == 5'b11111 ) ? 1 :
				(bfamilyd | jrfamilyd) & rrfamilym & (instrd[`rs] == instrm[`rd]) ? 2 :
				(bfamilyd | jrfamilyd) & rifamilym & (instrd[`rs] == instrm[`rt]) ? 2 :
				(bfamilyd | jrfamilyd) & jalfamilym & (instrd[`rs] == 5'b11111 ) ? 3 :
				(bfamilyd | jrfamilyd) & rrfamilyw & (instrd[`rs] == instrw[`rd]) ? 4 :
				(bfamilyd | jrfamilyd) & rifamilyw & (instrd[`rs] == instrw[`rt]) ? 4 :
				(bfamilyd | jrfamilyd) & loadfamilyw & (instrd[`rs] == instrw[`rt]) ? 4 :
                (bfamilyd | jrfamilyd) & jalfamilyw & (instrd[`rs] == 5'b11111 ) ? 4 : 0;
				
	assign frtd =	
            (instrd[`rt] == 0) ? 0 :	 
				bfamilyd & jalfamilye & (instrd[`rt] == 5'b11111 ) ? 1 :
				bfamilyd & rrfamilym & (instrd[`rt] == instrm[`rd]) ? 2 :
				bfamilyd & rifamilym & (instrd[`rt] == instrm[`rt]) ? 2 :
				bfamilyd & jalfamilym & (instrd[`rt] == 5'b11111 ) ? 3 :
				bfamilyd & rrfamilyw & (instrd[`rt] == instrw[`rd]) ? 4 :
				bfamilyd & rifamilyw & (instrd[`rt] == instrw[`rt]) ? 4 :
				bfamilyd & loadfamilyw & (instrd[`rt] == instrw[`rt]) ? 4 :
                bfamilyd & jalfamilyw & (instrd[`rt] == 5'b11111 ) ? 4 : 0;
								
	assign frse = 
	        (instre[`rs] == 0) ? 0 :
				(rrfamilye | rifamilye | loadfamilye | storefamilye | mdfamilye) & rrfamilym & (instre[`rs] == instrm[`rd]) ? 1 :
				(rrfamilye | rifamilye | loadfamilye | storefamilye | mdfamilye) & rifamilym & (instre[`rs] == instrm[`rt]) ? 1 :
				(rrfamilye | rifamilye | loadfamilye | storefamilye | mdfamilye) & jalfamilym & (instre[`rs] == 5'b11111 ) ? 2 :
				(rrfamilye | rifamilye | loadfamilye | storefamilye | mdfamilye) & rrfamilyw & (instre[`rs] == instrw[`rd]) ? 3 :
				(rrfamilye | rifamilye | loadfamilye | storefamilye | mdfamilye) & rifamilyw & (instre[`rs] == instrw[`rt]) ? 3 :
				(rrfamilye | rifamilye | loadfamilye | storefamilye | mdfamilye) & loadfamilyw & (instre[`rs] == instrw[`rt]) ? 3 :
            (rrfamilye | rifamilye | loadfamilye | storefamilye | mdfamilye) & jalfamilyw & (instre[`rs] == 5'b11111 ) ? 3 : 0;
				
	assign frte =
	        (instre[`rt] == 0) ? 0 :
				(rrfamilye | storefamilye | mdfamilye) & rrfamilym & (instre[`rt] == instrm[`rd]) ? 1 :
				(rrfamilye | storefamilye | mdfamilye) & rifamilym & (instre[`rt] == instrm[`rt]) ? 1 :
				(rrfamilye | storefamilye | mdfamilye) & jalfamilym & (instre[`rt] == 5'b11111 ) ? 2 :
				(rrfamilye | storefamilye | mdfamilye) & rrfamilyw & (instre[`rt] == instrw[`rd]) ? 3 :
				(rrfamilye | storefamilye | mdfamilye) & rifamilyw & (instre[`rt] == instrw[`rt]) ? 3 :
				(rrfamilye | storefamilye | mdfamilye) & loadfamilyw & (instre[`rt] == instrw[`rt]) ? 3 :
            (rrfamilye | storefamilye | mdfamilye) & jalfamilyw & (instre[`rt] == 5'b11111 ) ? 3 : 0;
				
	assign frtm =
	        (instrm[`rt] == 0) ? 0 :
				storefamilym & rrfamilyw & (instrm[`rt] == instrw[`rd]) ? 1 :
				storefamilym & rifamilyw & (instrm[`rt] == instrw[`rt]) ? 1 :
				storefamilym & loadfamilyw & (instrm[`rt] == instrw[`rt]) ? 1 :
				storefamilym & jalfamilyw & (instrm[`rt] == 5'b11111) ? 1 : 0;
										  
endmodule
