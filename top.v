

  `include "alu.v"
  `include "regbank.v"
  `include "memory.v"




 `timescale 1ns/1ns


  module top  #(parameter DATA_WIDTH = 32)(
	    input [DATA_WIDTH-1:0]A_imm,B_imm,ADDR,
	    input [1:0]sel,
	    input CLK,
	    input [21:0]OSD,
	    input X,Y,R_W,
            input [5:0]W_INST,R_INST,
	    output parity_flag,zero_flag,sign_flag,carry_flag,auxillary_flag,
	    output reg [DATA_WIDTH-1:0]Result
            );

	  
	   wire [DATA_WIDTH-1:0]alu_out,A_reg,B_reg,A,B,RE_MEM,WR_MEM,RE_MEM_REG,RE_MEM_X, RE_MEM_Y;
	   reg [5:0]source_A,source_B,des;
	   reg [3:0]opcode;
           reg [DATA_WIDTH-1:0]A_imm_reg,B_imm_reg,ADDR_reg;
	   reg [1:0]reg_sel;
	   reg [5:0]W_INST_reg,R_INST_reg;
	   reg X_reg,Y_reg,CS_X_reg,CS_Y_reg,WE_X_reg,WE_Y_reg,RE_X_reg,RE_Y_reg;
	  

         
	 assign  {A,B} = (reg_sel[1:0] == 2'd0) ?  {A_reg,B_reg} : 
		             ((reg_sel[1:0] == 2'd1) ? {A_reg,B_imm_reg} : 
		             ((reg_sel[1:0] == 2'd2) ? {A_imm_reg,B_reg} : 
                             ((reg_sel[1:0] == 2'd3) ? {A_imm_reg,B_imm_reg} : {A,B}))) ;

  
     regbank reg_bank(A_reg, B_reg, WR_MEM, alu_out ,
	              RE_MEM_REG, source_A, source_B, des,W_INST_reg, R_INST_reg, CLK);


     alu alu_block(A,B,opcode,alu_out,parity_flag,zero_flag,sign_flag,carry_flag,auxillary_flag);  

     Memory #(.init_file_select(1)) X1(ADDR_reg, CS_X_reg, CLK, RE_X_reg, WR_MEM, RE_MEM_X);

     Memory #(.init_file_select(1)) X2(ADDR_reg, CS_X_reg, CLK, WE_X_reg, WR_MEM, RE_MEM);

     Memory #(.init_file_select(2)) Y1(ADDR_reg, CS_Y_reg, CLK, RE_Y_reg, WR_MEM, RE_MEM_Y);

     Memory #(.init_file_select(2)) Y2(ADDR_reg, CS_Y_reg, CLK, WE_Y_reg, WR_MEM, RE_MEM);
    
     
  
   assign RE_MEM_REG = CS_X_reg ? RE_MEM_X : RE_MEM_Y ;

     always @(posedge CLK)
	     	begin
			A_imm_reg <= A_imm;
			B_imm_reg <= B_imm;
		    {opcode,source_A,source_B,des} <= OSD;
			Result <= alu_out;
			reg_sel <= sel;
			W_INST_reg <= W_INST;
			R_INST_reg <= R_INST;
                        ADDR_reg <= ADDR;
			if(X_reg) begin
				CS_X_reg <= 1'b1;
			        if(R_W)
				  RE_X_reg <= 1'b1;
			        else if(!R_W)
				  WE_X_reg <= 1'b0; end
			else if(Y_reg) begin
				CS_Y_reg <= 1'b1;
				if(R_W)
				  RE_Y_reg <= 1'b1;
			        else if(!R_W)
				  WE_Y_reg <= 1'b0; end

			else
			begin
				CS_X_reg <= 1'b0;
				CS_Y_reg <= 1'b0;
			end
		           
		
			{X_reg,Y_reg} <= {X,Y};
		  //  {write_X_reg,write_Y_reg} <= {write_X,write_Y};
	       	end

  endmodule





 
 
