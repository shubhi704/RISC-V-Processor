
  module pc(
    input CLK,RST,
    input [5:0]jump_addr,
    input CON,FS, 
    input [1:0]jump_enable,
    output [5:0]PC_ADDR
  );
  reg [5:0] PC_ADDR_reg;

 
  assign PC_ADDR = PC_ADDR_reg; 

  always @(posedge CLK or negedge RST) begin
   if(!RST) 
      PC_ADDR_reg <= 6'd0; 
   else if(jump_enable == 2'b10)       // JUMP Condition
     begin 
       if(CON == 1'D1)
        begin
          if(FS == 1'B1)              // if flag signal is 1 only do jump
             PC_ADDR_reg <= jump_addr;
          //else 
            // PC_ADDR_reg <= PC_ADDR_reg + 1;
         end
	 else if(CON == 1'D0)                 // for conditional jump
         PC_ADDR_reg <= jump_addr;  
      end
      //PC_ADDR_reg <= jump_addr + 1;
   else
      PC_ADDR_reg <= PC_ADDR_reg + 1;
  end

 endmodule 


