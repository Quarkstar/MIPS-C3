`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:47:19 12/08/2018 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(
    input [31:0] instr,
	//branch
    output jr, jalr,
    output jump,
    output beq, bne, bltz, bgtz, blez, bgez,
	//mux select
    output [1:0] regdst,
    output memtoreg,
	output pctoreg,
	output alusrc,
	// read or write enable 
    output regwrite,
    output memread,
    output memwrite,
	//funtion op
    output [1:0] extop,
    output reg [3:0] aluop,
	 //store or write
	 output sw,
	 output sh,
	 output sb,
	 output lw,
	 output lb,
	 output lbu,
	 output lh,
	 output lhu,
	 output mdfamily
    );
	
	wire Rtype = !(|opcode);
	wire [5:0] opcode = instr[31:26];
	wire [5:0] funct = instr[5:0];
	wire [4:0] rt = instr[20:16];

	wire add  = Rtype && (funct === 6'b100000) ? 1 : 0;
	wire addu = Rtype && (funct === 6'b100001) ? 1 : 0;
	wire sub  = Rtype && (funct === 6'b100010) ? 1 : 0;
	wire subu = Rtype && (funct === 6'b100011) ? 1 : 0;
	wire andc = Rtype && (funct === 6'b100100) ? 1 : 0;
	wire orc  = Rtype && (funct === 6'b100101) ? 1 : 0;
	wire xorc = Rtype && (funct === 6'b100110) ? 1 : 0;
	wire norc = Rtype && (funct === 6'b100111) ? 1 : 0;
	wire slt  = Rtype && (funct === 6'b101010) ? 1 : 0;
	wire sltu = Rtype && (funct === 6'b101011) ? 1 : 0;
	wire sll  = Rtype && (funct === 6'b000000) ? 1 : 0;
	wire srl  = Rtype && (funct === 6'b000010) ? 1 : 0;
	wire sra  = Rtype && (funct === 6'b000011) ? 1 : 0;
	wire sllv = Rtype && (funct === 6'b000100) ? 1 : 0;
	wire srlv = Rtype && (funct === 6'b000110) ? 1 : 0;
	wire srav = Rtype && (funct === 6'b000111) ? 1 : 0;
	assign jr = Rtype && (funct === 6'b001000) ? 1 : 0;
	assign jalr = Rtype && (funct === 6'b001001) ? 1 : 0;
	
	
	wire ori = (opcode === 6'b001101) ? 1 : 0;
	wire lui = (opcode === 6'b001111) ? 1 : 0;
	wire addi = (opcode === 6'b001000) ? 1 : 0;
	wire addiu = (opcode === 6'b001001) ? 1 : 0;
	wire andi = (opcode === 6'b001100) ? 1 : 0;
	wire xori = (opcode === 6'b001110) ? 1 : 0;
	wire slti = (opcode === 6'b001010) ? 1 : 0;
	wire sltiu = (opcode === 6'b001011) ? 1 : 0;

	assign lw  = (opcode === 6'b100011) ? 1 : 0;
	assign lb  = (opcode === 6'b100000) ? 1 : 0;
	assign lbu = (opcode === 6'b100100) ? 1 : 0;
	assign lh  = (opcode === 6'b100001) ? 1 : 0;
	assign lhu = (opcode === 6'b100101) ? 1 : 0;

	assign sw  = (opcode === 6'b101011) ? 1 : 0;
	assign sh  = (opcode === 6'b101001) ? 1 : 0;
	assign sb  = (opcode === 6'b101000) ? 1 : 0;

	assign beq = (opcode === 6'b000100) ? 1 : 0;
	assign bne = (opcode === 6'b000101) ? 1 : 0;
	assign bltz = ((opcode === 6'b000001) && (rt === 5'b00000)) ? 1 : 0;
	assign bgtz = (opcode === 6'b000111) ? 1 : 0;
	assign blez = (opcode === 6'b000110) ? 1 : 0;
	assign bgez = ((opcode === 6'b000001) && (rt === 5'b00001)) ? 1 : 0;
	
	wire j   = (opcode === 6'b000010) ? 1 : 0;
	wire jal = (opcode === 6'b000011) ? 1 : 0;
	
	wire nop = (instr == 0) ? 1 : 0;
	
	wire mult =  (Rtype & (funct == 6'b011000)) ? 1 : 0;
	wire div =  (Rtype & (funct == 6'b011010)) ? 1 : 0;
	wire multu =  (Rtype & (funct == 6'b011001)) ? 1 : 0;
	wire divu =  (Rtype & (funct == 6'b011011)) ? 1 : 0;
	wire mfhi =  (Rtype & (funct == 6'b010000)) ? 1 : 0;
	wire mflo =  (Rtype & (funct == 6'b010010)) ? 1 : 0;
	wire mthi=  (Rtype & (funct == 6'b010001)) ? 1 : 0;
	wire mtlo =  (Rtype & (funct == 6'b010011)) ? 1 : 0;
   
	assign mdfamily = mult | multu | div | divu | mfhi | mflo | mthi | mtlo;
	
	
	assign jump = j | jal ;
	
	assign regdst = {jal  , Rtype | jalr};

	assign memtoreg = lw | lb | lbu | lh | lhu ;

	assign pctoreg = jal | jalr;

	assign alusrc = ori | lui | addi | addiu | xori | andi | slti |sltiu
	              | lw | lb | lbu | lh | lhu
					  | sw | sh | sb ;
	
	assign regwrite = jal | jalr
	            | add | addu | sub | subu | andc | orc | xorc | norc | slt | sltu |sllv | srlv | (sll & !nop) | srl | sra | srav | 
					| ori | lui  | slti | sltiu | addi | addiu | andi | xori | 
					| lw | lb | lbu | lh | lhu
					|mfhi|mflo;
	
	assign memread = lw | lb | lbu | lh | lhu;
	assign memwrite = sw | sh | sb;
	
	assign extop = {lui, lw | lb | lbu | lh | lhu
	                | sw | sh | sb
					| beq  | bne | bltz | bgtz | blez | bgez |
					| addi | addiu | slti | sltiu };


	always @ ( * ) begin
			 if (add | addu | addi | addiu| lw | sw | lb | lbu | lh | lhu | sh | sb | lui) aluop <= 4'b0000;
		else if (sub | subu)                aluop <= 4'b0001;
		else if (andc | andi )              aluop <= 4'b0010;
		else if (orc | ori)		            aluop <= 4'b0011;
		else if (xorc | xori)		        aluop <= 4'b0100;
		else if (norc)		                aluop <= 4'b0101;
		else if (slt | slti)		    aluop <= 4'b0110;
		else if (sllv)		                aluop <= 4'b0111; 
		else if (srlv)                      aluop <= 4'b1000;
		else if (sra)	                	aluop <= 4'b1001;
		else if (sll)                       aluop <= 4'b1010;
		else if (srl)		                aluop <= 4'b1011;
		else if (srav)		                aluop <= 4'b1100;
		else if (sltu | sltiu)            aluop <= 4'b1101;
	end
	
endmodule

