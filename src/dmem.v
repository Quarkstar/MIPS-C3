`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:53:41 12/08/2018 
// Design Name: 
// Module Name:    dmem 
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
module dmem(
	input clk, reset,
	input memread, memwrite,
	input sw, sh, sb,
    input [31:0] addr, writedata, pc,
	output reg [31:0] readdata
    );
	 
	integer i;
	reg [31:0] ram [4095:0];
	wire [11:0] address = addr[13:2];
	reg [31:0] finalwritedata;
	 
	initial begin
		for(i=0;i<=1023;i=i+1)
			ram[i] <= 32'b0;
	end
	
	always @ ( * ) begin
	      if(sw === 1)
			finalwritedata <= writedata;
        else if( sh === 1) begin
                 if(addr[1] === 1)
                     finalwritedata <= {writedata[15:0],ram[address][15:0]};
                 else
                     finalwritedata <= {ram[address][31:16],writedata[15:0]};
             end
        else if( sb === 1 ) begin
				     case(addr[1:0])
					      2'b00: finalwritedata <= {ram[address][31:8], writedata[7:0]};
							2'b01: finalwritedata <= {ram[address][31:16], writedata[7:0],ram[address][7:0]};
							2'b10: finalwritedata <= {ram[address][31:24], writedata[7:0],ram[address][15:0]};
							2'b11: finalwritedata <= {writedata[7:0],ram[address][23:0]};
					  endcase
             end
        else finalwritedata <= writedata;				
	end
	

	 
	always @ (posedge clk) begin 
	    if(reset == 1) 
            for(i = 0; i <= 4095; i=i+1)		
		        ram[i] <= 32'b0;
		
		else if(memwrite == 1) begin
		    ram[address] <= finalwritedata;
		    $display("%d@%h: *%h <= %h", $time, pc, {addr[31:2],2'b00}, finalwritedata);
		end
	end
	 
	always @ (*) begin
		if(memread === 1)
			readdata <= ram[address];
		else
		    readdata <= 0; //avoid xxxxxxxxx
	end

endmodule
