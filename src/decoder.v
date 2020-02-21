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
module decoder(
    input [31:0] instr,
    output bfamily,
    output rrfamily,
    output rifamily, 
    output loadfamily,
    output storefamily,
    output jalfamily,
    output jrfamily,
	 output mdfamily
    );

    wire [5:0] opcode = instr[31:26];
	wire [5:0] funct = instr[5:0];
	wire [4:0] rt = instr[20:16];
	 
	wire nop = (instr == 0) ? 1 : 0;

    wire Rtype = !(|opcode);
    assign rrfamily = (Rtype & !nop & !mdfamily) | jalr | mflo | mfhi;
	 


    wire beq = (opcode === 6'b000100) ? 1 : 0;
	wire bne = (opcode === 6'b000101) ? 1 : 0;
	wire bltz = ((opcode === 6'b000001) && (rt === 5'b00000)) ? 1 : 0;
	wire bgtz = (opcode === 6'b000111) ? 1 : 0;
	wire blez = (opcode === 6'b000110) ? 1 : 0;
	wire bgez = ((opcode === 6'b000001) && (rt === 5'b00001)) ? 1 : 0;
    assign bfamily = beq | bne | bltz | bgtz | blez | bgez;

    wire ori = (opcode === 6'b001101) ? 1 : 0;
	wire lui = (opcode === 6'b001111) ? 1 : 0;
	wire addi = (opcode === 6'b001000) ? 1 : 0;
	wire addiu = (opcode === 6'b001001) ? 1 : 0;
	wire andi = (opcode === 6'b001100) ? 1 : 0;
	wire xori = (opcode === 6'b001110) ? 1 : 0;
	wire slti = (opcode === 6'b001010) ? 1 : 0;
	wire sltiu = (opcode === 6'b001011) ? 1 : 0;
    assign rifamily = ori | lui | addi | addiu | andi | xori | slti | sltiu;

    wire lw  = (opcode === 6'b100011) ? 1 : 0;
	wire lb  = (opcode === 6'b100000) ? 1 : 0;
	wire lbu = (opcode === 6'b100100) ? 1 : 0;
	wire lh  = (opcode === 6'b100001) ? 1 : 0;
	wire lhu = (opcode === 6'b100101) ? 1 : 0;
    assign loadfamily = lw | lb | lbu | lh | lhu;

	wire sw  = (opcode === 6'b101011) ? 1 : 0;
	wire sh  = (opcode === 6'b101001) ? 1 : 0;
	wire sb  = (opcode === 6'b101000) ? 1 : 0;
    assign storefamily = sw | sh | sb;

    wire jal = (opcode === 6'b000011) ? 1 : 0;
    assign jalfamily = jal;

    wire jr = Rtype && (funct === 6'b001000) ? 1 : 0;
	wire jalr = Rtype && (funct === 6'b001001) ? 1 : 0;
    assign jrfamily = jr | jalr;
	 
	wire mult =  (Rtype & (funct == 6'b011000)) ? 1 : 0;
	wire div =  (Rtype & (funct == 6'b011010)) ? 1 : 0;
	wire multu =  (Rtype & (funct == 6'b011001)) ? 1 : 0;
	wire divu =  (Rtype & (funct == 6'b011011)) ? 1 : 0;
	wire mfhi =  (Rtype & (funct == 6'b010000)) ? 1 : 0;
	wire mflo =  (Rtype & (funct == 6'b010010)) ? 1 : 0;
	wire mthi=  (Rtype & (funct == 6'b010001)) ? 1 : 0;
	wire mtlo =  (Rtype & (funct == 6'b010011)) ? 1 : 0;
   
	assign mdfamily = mult | multu | div | divu  | mthi | mtlo;


					
endmodule