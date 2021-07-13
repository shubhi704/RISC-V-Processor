
`timescale 1ns/1ns

 module Memory
   #(parameter ADDR_WIDTH = 32,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = (2*32)-1)
    (
     input [ADDR_WIDTH-1:0] ADDR,
     input CS,CLK,
     input RE,
     input [DATA_WIDTH-1:0] WR_MEM_DATA,
     output reg[DATA_WIDTH-1:0] RE_MEM_DATA
     );

  
   reg [DATA_WIDTH-1:0] mem[0:DEPTH];

   parameter init_file_select = 0;
    	
     initial
         begin
	 if(init_file_select ==1)
               $readmemh("input.txt",mem,0,((2*32)-1));
         else if(init_file_select == 2)
	       $readmemh("mem_y.txt",mem,0,((2*32)-1));
         end
   
     always @(posedge CLK) begin
	     if(CS)
		     if(RE) begin
			     RE_MEM_DATA <= mem[ADDR];
		     end
		     else if(RE == 1'b0) begin
			     mem[ADDR] <= WR_MEM_DATA;
		     end
	     end

 endmodule
