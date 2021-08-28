 module Memory (ADDR, CS, CLK, R_W, BSEL, WR_MEM_DATA, RE_MEM_DATA);

   input  [31:0]WR_MEM_DATA;
   input  [1:0]BSEL;
   input  [31:0] ADDR;
   input  CLK,CS,R_W;
   output reg [31:0]RE_MEM_DATA;
    


     reg [7:0] mem [0:(2**10)-1];

   //reg [31:0] temp1,temp2;

   parameter init_file_select = 0;
    	
     initial
         begin
	 if(init_file_select ==1)
               $readmemh("x_indirect.txt",mem,0,1023);
         else if(init_file_select == 2)
	       $readmemh("mem_y.txt",mem,0,1023);
         end

     //assign RE_MEM_DATA = IN_reg  ? temp2 : temp1 ; 


    always @(posedge CLK) begin
     if(CS) begin
      if (R_W==1'b0) begin
        case (BSEL)
         2'b00:    mem[ADDR] <= WR_MEM_DATA[7:0];
         2'b01:   {mem[ADDR+1], mem[ADDR]} <= WR_MEM_DATA[15:0];
         2'b10:   {mem[ADDR+2], mem[ADDR+1], mem[ADDR]} <= WR_MEM_DATA[23:0];
         default: {mem[ADDR+3], mem[ADDR+2], mem[ADDR+1], mem[ADDR]} <= WR_MEM_DATA ;
        endcase
      end

    else if (R_W==1'b1) begin
       case (BSEL)
       2'b00:  RE_MEM_DATA = {24'dx,mem[ADDR]};
       2'b01:  RE_MEM_DATA <= {16'dx,mem[ADDR+1], mem[ADDR]};
       2'b10:  RE_MEM_DATA <= {8'dx,mem[ADDR+2], mem[ADDR+1], mem[ADDR]};
       default: RE_MEM_DATA <= {mem[ADDR+3], mem[ADDR+2], mem[ADDR+1], mem[ADDR]} ;
      endcase
    end
  end
  end

endmodule   
