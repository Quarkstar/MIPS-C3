`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:45:24 12/11/2018 
// Design Name: 
// Module Name:    wbloadext 
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
module wbloadext(
    input lw,lb,lbu,lh,lhu,
	 input [1:0] byteaddr,
	 input [31:0] readdata,
	 output reg [31:0] finalreaddata
    );
	 
	 always @ ( * ) begin
	     if(lw == 1)
		      finalreaddata <= readdata;
		  else if(lh == 1) begin
		           if(byteaddr[1] == 1)
		              finalreaddata <= {{16{readdata[31]}},readdata[31:16]};
                 else	
                    finalreaddata <= {{16{readdata[15]}},readdata[15:0]};
			    end
        else if(lhu == 1) begin
		          if(byteaddr[1] == 1)
		              finalreaddata <= {16'b0,readdata[31:16]};
                else	
                    finalreaddata <= {16'b0,readdata[15:0]};
                end						  
        else if(lb == 1) begin
		          if(byteaddr == 2'b00)
		              finalreaddata <= {{24{readdata[7]}},readdata[7:0]};
                else if(byteaddr == 2'b01)
                    	finalreaddata <= {{24{readdata[15]}},readdata[15:8]};
                else if(byteaddr == 2'b10)
                    finalreaddata <= {{24{readdata[23]}},readdata[23:16]};
                else if(byteaddr == 2'b11)
                    finalreaddata <= {{24{readdata[31]}},readdata[31:24]};
		       end
        else if(lbu == 1) begin
		           if(byteaddr == 2'b00)
		              finalreaddata <= {24'b0,readdata[7:0]};
                else if(byteaddr == 2'b01)
                     finalreaddata <= {24'b0,readdata[15:8]};	
                else if(byteaddr == 2'b10)
                     finalreaddata <= {24'b0,readdata[23:16]};
                else if(byteaddr == 2'b11)
                    	finalreaddata <= {24'b0,readdata[31:24]};
			     end
        else
            finalreaddata <= readdata;		  
	 end


endmodule
