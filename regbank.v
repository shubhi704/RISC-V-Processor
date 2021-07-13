  module regbank(RE_A, RE_B, RE_X, WD, MEM_WD, SRA, SRB, DR, W_INST, R_INST, CLK);
    
	 input CLK;
	 input [5:0] SRA, SRB,W_INST,R_INST, DR;   //source and destination reg
	 input [31:0] WD, MEM_WD;            // write data
	 output [31:0] RE_X,RE_A, RE_B;    //read data 
	
	
	 reg [31:0] regfile [0:63];  //array of registers
	initial
         begin
          $readmemh("mem.txt",regfile,0,63);
         end
	 
	 assign RE_A = regfile[SRA];
	 assign RE_B = regfile[SRB];
	 assign RE_X = regfile[R_INST];

	 
	 always @(posedge CLK)
		         begin regfile [DR] <= WD; 
                               regfile[W_INST] <= MEM_WD;
			 end
	    	   
  endmodule
