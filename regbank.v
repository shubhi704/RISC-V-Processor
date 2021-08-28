module regbank  #(parameter ADDR_WIDTH = 6,
                    parameter DATA_WIDTH = 32,
                    parameter DEPTH = (2*32)-1)
	   (RE_A, RE_B, RE_X, WD, MEM_WD, SRA, SRB, DR, W_INST, R_INST, CLK);
    
	 input CLK;
	input [ADDR_WIDTH-1:0] SRA, SRB,W_INST,R_INST, DR;   //source and destination reg
	  input [DATA_WIDTH-1:0] WD, MEM_WD;            // write data
	  output [DATA_WIDTH-1:0] RE_X,RE_A, RE_B;    //read data 
	
	
	reg [DATA_WIDTH-1:0] regfile [0:DEPTH];  //array of registers
	initial
         begin
          $readmemh("mem.txt",regfile,0,DEPTH);
         end
	 
	 assign RE_A = regfile[SRA];
	 assign RE_B = regfile[SRB];
	 assign RE_X = regfile[R_INST];

	 
	 always @(posedge CLK)
		         begin regfile [DR] <= WD; 
                               regfile[W_INST] <= MEM_WD;
			 end
	    	   
  endmodule
