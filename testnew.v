`timescale 1ns/1ns

  module test_top;
      parameter DATA_WIDTH = 32;
            reg [DATA_WIDTH-1:0]A_imm, B_imm, ADDR;
	    reg [1:0]sel;
	    reg CLK;
            reg X,Y,R_W;
            reg [5:0]W_INST,R_INST;
            
	    reg [21:0]OSD;
	    wire parity_flag,zero_flag,sign_flag,carry_flag,auxillary_flag;
	    wire [DATA_WIDTH-1:0]Result;

	   
  integer i, file,file2,file3;
  
  top  t1(A_imm,B_imm,ADDR,
	    sel,
	     CLK,
	     OSD,
	     X,Y,R_W,
             W_INST,R_INST,
	     parity_flag,zero_flag,sign_flag,carry_flag,auxillary_flag,
	     Result
             );


  reg enable =0;


  initial begin
   CLK=0;
   forever #5 CLK = ~CLK ;
  end
    reg [31:0]buffer[0:63];
		
       initial
	begin
	 $readmemh ("TVector.txt", buffer,0,63);
       end

       initial
	begin
	file = $fopen("ALUOperationResult.txt"); //blank file
        file2 = $fopen("LOADResult.txt"); //blank file
	file3 = $fopen("STOREResult.txt"); //blank file
        end


  integer k,p,j;
  initial
  begin

  //************ Reading data from X1 and storing at regbank**************//
    
         for (k = 0; k<=63; k = k+1)
		 begin
                  X = 1; Y=0; R_W= 1;
                  W_INST = k;
		  ADDR = k;
		  @(negedge CLK); #20;
                  if(t1.X1.mem[ADDR] == t1.reg_bank.regfile[W_INST])
		     begin 
                           $fwrite (file2,"matched in vector\n",);
	             @(negedge CLK); end
                  else
	             begin
		           $fwrite (file2,$time,"  :%d: mismatched in vector %h\n",k,t1.X1.mem[ADDR]);
	             @(negedge CLK); end
              //  OSD[5:0] = ADDR;
                 end
             $fwrite(file2,"*******************************END OF OPERATION*********************************");

         
  //************ ALU ADD Operation taking previous X1 data as a A number and B Immediate number**************//
         for (j = 0; j<=63; j = j+1)
           begin
                OSD[21:18]=4'D0;  OSD[17:12]=j; B_imm= 32'd43; sel=2'd1;  // adding values in ALU
                 @(negedge CLK)  OSD[5:0]=j;  
		 @(negedge CLK); 
	        
		 if (Result == buffer[j])
	             begin $display ("matched in vector %h", buffer[j]);
		     $fwrite (file, "matched in vector %h\n", buffer[j]); 
		           
	             @(negedge CLK); end
                 else
	             begin $display ("%d: mismatched in vector %h != %h",j, buffer[j],Result);
		            $fwrite (file,"%d: mismatched in vector %h != %h\n",j, buffer[j],Result);

	             @(negedge CLK); end
           end
             $fwrite(file,"\n*******************************END OF OPERATION*********************************");

  //************ Writing Regbank data in Memory Y2**************//
          for (p = 0; p<=63; p = p+1)
           begin
	      @(negedge CLK);
              X=0; Y=1;  R_W=0; R_INST = p; 
	      @(negedge CLK); #15;
	       if(t1.Y2.mem[ADDR] == t1.reg_bank.regfile[R_INST])
		     begin 
                           $fwrite (file3,$time," :matched in vector %h\n", t1.reg_bank.regfile[R_INST]);
	             @(negedge CLK); end
                  else
	             begin
		           $fwrite (file3,$time,"  :%d: mismatched in vector %h != %h\n",k,t1.Y2.mem[ADDR], t1.reg_bank.regfile[R_INST]);
	             @(negedge CLK); end
      
                 end
                     $fwrite(file3,"*******************************END OF OPERATION*********************************");

        repeat(2) @(negedge CLK); 
          #10	$finish;
        end
	

	
	

	
	initial
	begin
	#2500 $fdisplay(file); 
	end
	
	initial
	#5000 $fclose(file); 
	
	
	
  initial begin
   $dumpfile("topWave.vcd");
   $dumpvars;
  end
 
  endmodule


 

