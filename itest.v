
 `timescale 1ns/1ns

  module test;
    parameter DATA_WIDTH = 32;
      
    // reg [5:0]INST_ADDR;
     reg CLK=0,RST;
     wire parity_flag,zero_flag,sign_flag,carry_flag,auxillary_flag;
     wire [DATA_WIDTH-1:0]Result;   
 
     integer i,command;
     reg [6*8:0]string_cmd;

  top  dut(
	    CLK,RST,
	    parity_flag,zero_flag,sign_flag,carry_flag,auxillary_flag,
	    Result
            );
  /* parameter ADD = 0,
		         SUB = 1,
		      A_PASS = 2,
		      B_PASS = 3,
		       L_AND = 4,
		        L_OR = 5,
		       L_NOT = 6,
		        L_EQ = 7,
		       B_AND = 8,
		        B_OR = 9,
		       B_NOT = 10,
		       B_XOR = 11,
		        SH_R = 12,
		        SH_L = 13,
		       ASH_L = 14,
		       ASH_R = 15,
		       B_ADDI = 16,
		       B_SUBI = 17,
		       A_ORI = 18,
		       A_ANI = 19,
		       MOVI = 20,
		       AB_ADI = 21,
		       LOAD4 = 22,
		       LOAD3 = 23,
		       LOAD2 = 24,
		       LOAD1 = 25,
		       STORE4=26,
		       STORE3=27,
		       STORE2=28,
                       STORE1=29,
		       PASSx=30,
		       
		       IADDRL1=32,
		       IADDRL2=33,
		       PASSy=34,
                       IADDRS1=36,
		       IADDR2=37,
		       IADDR3=38; */
                       
		    
   always #5 CLK = ~CLK;

  initial
    begin
	    RST=0;
	  @(negedge CLK) RST= 1; 
    /*  for(i=0; i<=41; i=i+1) begin
       INST_ADDR = i;
       command = i;
       @(negedge CLK);
       end */
      #600;
      repeat(2) @(negedge CLK);
      $finish;
    end
   

  /*  always @(command) begin
	    case(command)
		    ADD: string_cmd = "ADD";
		    SUB: string_cmd = "SUM";
		 B_PASS: string_cmd = "B_PASS";
		 A_PASS: string_cmd = "A_PASS";
		  L_AND: string_cmd = "L_AND";
		   L_OR: string_cmd = "L_OR";
		  L_NOT: string_cmd = "L_NOT";
		   L_EQ: string_cmd = "L_EQ";
		  B_AND: string_cmd = "B_AND";
		   B_OR: string_cmd = "B_OR";
		  B_NOT: string_cmd = "B_NOT";
		  B_XOR: string_cmd = "B_XOR";
		   SH_R: string_cmd = "SH_R";
		   SH_L: string_cmd = "SH_L";
		  ASH_L: string_cmd = "ASH_L";
		  ASH_R: string_cmd = "ASH_R";

		  B_ADDI :  string_cmd = "B_ADDI";
		  B_SUBI :  string_cmd = "B_SUBI";
		  A_ORI :  string_cmd =  "A_ORI";
		  A_ANI :  string_cmd = "A_ANI";
		  MOVI :  string_cmd = "MOVI";
		  AB_ADI :  string_cmd = "AB_ADI";
		  LOAD4 :  string_cmd = "LOAD4";
		  LOAD3 :  string_cmd = "LOAD3";
		  LOAD2 :  string_cmd = "LOAD2";
		  LOAD1 :  string_cmd = "LOAD1";

		       STORE4: string_cmd = "STORE4";
		       STORE3: string_cmd = "STORE3";
		       STORE2: string_cmd = "STORE2";
                       STORE1: string_cmd = "STORE1";
		       PASSx: string_cmd = "PASS";
		       
		       IADDRL1: string_cmd = "IADDRL";
		       IADDRL2: string_cmd = "IADDRL";
		       PASSy: string_cmd = "PASS";
                       IADDRS1: string_cmd ="IADDRS"; 
		       IADDR2: string_cmd = "IADDRS";
		       IADDR3: string_cmd = "IADDRS";

		  default: string_cmd = "MEM";
	  endcase 
  end */






   initial begin
   $dumpfile("comp.vcd");
   $dumpvars;
   end
 
  endmodule


