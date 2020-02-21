`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:01:11 12/23/2018
// Design Name:   muldiv
// Module Name:   D:/Documents/verilog_test/p6/testmult.v
// Project Name:  p6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: muldiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testmult;

	// Inputs
	reg [31:0] a;
	reg [31:0] b;
	reg mult;
	reg div;
	reg multu;
	reg divu;
	reg mfhi;
	reg mflo;
	reg mthi;
	reg mtlo;
	reg clk;
	reg reset;

	// Outputs
	wire start;
	wire busy;
	wire [31:0] multdivout;

	// Instantiate the Unit Under Test (UUT)
	muldiv uut (
		.a(a), 
		.b(b), 
		.mult(mult), 
		.div(div), 
		.multu(multu), 
		.divu(divu), 
		.mfhi(mfhi), 
		.mflo(mflo), 
		.mthi(mthi), 
		.mtlo(mtlo), 
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.busy(busy), 
		.multdivout(multdivout)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		mult = 0;
		div = 0;
		multu = 0;
		divu = 0;
		mfhi = 0;
		mflo = 0;
		mthi = 0;
		mtlo = 0;
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		a = 5;
		b = 3;
		mult = 1;
		#2
		mult = 0;
		
		#19
		reset = 1;
		#1
		reset = 0;
		
		#5
		div = 1;
		#2
		div = 0;
		
		#40
		mthi = 1;
		#2
		mthi = 0;
		
		#5
		mtlo = 1;
		#2
		mtlo = 0;
		
					#5
		mfhi = 1;
		#2
		mfhi = 0;
		
					#5
		mflo = 1;
		#2
		mflo = 0;
		
		
		

	end
      always #1 clk = ~clk;
		
endmodule

