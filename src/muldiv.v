`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:11:17 12/23/2018 
// Design Name: 
// Module Name:    muldiv 
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
module muldiv(
    input [31:0] a, b, instr,
	 input clk, reset,
	 output reg start,
	 output reg busy,
    output [31:0] multdivout
    );
	 
	 reg [31:0] hi,lo;
	 
	 integer i = 0, j = 0;
	 
	 
	 wire [5:0] opcode = instr[31:26];
	 wire [5:0] funct = instr[5:0];
	 
	 wire Rtype = !(|opcode);
	 wire mult =  (Rtype & (funct == 6'b011000)) ? 1 : 0;
	 wire div =  (Rtype & (funct == 6'b011010)) ? 1 : 0;
	 wire multu =  (Rtype & (funct == 6'b011001)) ? 1 : 0;
	 wire divu =  (Rtype & (funct == 6'b011011)) ? 1 : 0;
	 wire mfhi =  (Rtype & (funct == 6'b010000)) ? 1 : 0;
	 wire mflo =  (Rtype & (funct == 6'b010010)) ? 1 : 0;
	 wire mthi=  (Rtype & (funct == 6'b010001)) ? 1 : 0;
	 wire mtlo =  (Rtype & (funct == 6'b010011)) ? 1 : 0;

	 
	 always @ (posedge clk, reset) begin
	     if(reset) begin
		      i <= 0; 
				j <= 0;
				busy <= 0;
				start <= 0;
				lo <= 0;
				hi <= 0;
		  end
		  else if((i != 0) | (j != 0)) begin 
				     if(i != 0) begin
		                start <= 0;
				          busy <= 1;
                      i <= i + 1;
					  end
					  if(i == 6) begin
				          i <= 0;
					       busy <= 0;
                 end
                 if(j != 0) begin
		                start <= 0;
				          busy <= 1;
                      j <= j + 1;
					  end
					  if(j == 11) begin
				          j <= 0;
					       busy <= 0;
                 end					  
		      end
	     else if((mult === 1) | (multu === 1))  begin
            {hi,lo} <= $signed(a) * $signed(b);
				start <= 1;
			   i <= i + 1;			         			
		  end
		  else if((div === 1) | (divu === 1)) begin
		      hi <= $signed(a) % $signed(b);
				lo <= $signed(a) / $signed(b);
				start <= 1;
			   j <= j + 1;		
        end
        else if(mtlo === 1) begin
		      lo <= a;
        end	
        else if(mthi === 1) begin
				hi <= a;
        end		  	 
	 end
	 
	 assign multdivout = (mfhi === 1) ? hi : lo;


endmodule
