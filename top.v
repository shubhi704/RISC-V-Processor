

 

  `include "alu.v"
  `include "regbank.v"
  `include "byte_add_mem.v"
  `include "inst_mem.v"
  `include "pc.v"


 `timescale 1ns/1ns


  module top  #(parameter DATA_WIDTH = 32)(
	                                input CLK,RST,
	                                output parity_flag, zero_flag, sign_flag, carry_flag, auxillary_flag,
	                                output reg [DATA_WIDTH-1:0]Result
                                       );

	    wire IN,CON,out1;
	    wire [1:0]BSEL,SEL;
	    wire [21:0]OSD;
	    wire X,Y,R_W;
            wire [5:0]W_INST,R_INST, JUMP_ADDR,PC_ADDR;
         
	   wire [DATA_WIDTH-1:0]alu_out,A_reg,B_reg,ADDR,A_imm,B_imm,A,B,RE_MEM,WR_MEM,RE_MEM_REG,RE_MEM_X, RE_MEM_Y,mem_reg,mem_addr,wr_mem,INST_DATA;
	   reg [5:0] source_A, source_B, des;
	   reg [3:0]opcode;
	   reg [1:0]BSEL_reg;
           reg [DATA_WIDTH-1:0]A_imm_reg,B_imm_reg,ADDR_reg,mem_addr_reg,WR_MEM_;
	   reg [1:0]reg_sel;
	   reg [5:0]W_INST_reg,R_INST_reg;
	   reg X_reg,FS,CON_reg,Y_reg,CS_X_reg,CS_Y_reg,WE_X_reg,WE_Y_reg,RE_X_reg,RE_Y_reg,IN_reg,REG_IN_reg;

	  

         
	 assign  {A,B} = (reg_sel[1:0] == 2'd0) ?  {A_reg,B_reg} : 
		             ((reg_sel[1:0] == 2'd1) ? {A_reg,B_imm_reg} : 
		             ((reg_sel[1:0] == 2'd2) ? {A_imm_reg,B_reg} : 
                             ((reg_sel[1:0] == 2'd3) ? {A_imm_reg,B_imm_reg} : {A,B}))) ;

  
     regbank reg_bank(A_reg, B_reg, WR_MEM, alu_out,
	              RE_MEM_REG, source_A, source_B, des, W_INST_reg, R_INST_reg, CLK);

     pc  program_count( CLK, RST, JUMP_ADDR , CON, FS, INST_DATA[1:0], PC_ADDR ); 

     always @(*) begin
	     if(INST_DATA[31] && (INST_DATA[1:0] == 2'b10)) 
	     begin
		if(INST_DATA[4] == 1'b1)
			FS = !carry_flag;
		else if(INST_DATA[3] == 1'B1)
			FS = !zero_flag;
		else if(INST_DATA[2] == 1'B1)
			FS = !parity_flag;
		else 
	               FS = 1'b0;
	     end
      end
    
        assign out1 = INST_DATA[24];  
  
     alu alu_block(A, B, opcode, alu_out, parity_flag, zero_flag, sign_flag, carry_flag, auxillary_flag);  
 
     inst_mem inst_memory(CLK, PC_ADDR, INST_DATA, RST);

     // Decoding of Instructions
     assign R_INST = ((INST_DATA[1:0] == 2'B11) || ((INST_DATA[1:0] == 2'B10) && INST_DATA[1:0] == 2'b10) ) ? INST_DATA[23:18] : R_INST_reg ;
     assign W_INST = (INST_DATA[1:0]==2'b11) ? INST_DATA[17:12] :  W_INST_reg; 
     assign BSEL =  INST_DATA[31:30];
     assign SEL = INST_DATA[29:28]; 
     assign OSD = (INST_DATA[1:0] == 2'b00 && INST_DATA[29:28]==2'b00) ? INST_DATA[27:6] :
	          ((INST_DATA[1:0] == 2'b01 && INST_DATA[29:28]==2'b01) ? {INST_DATA[27:18],source_B,INST_DATA[17:12]} :
		  ((INST_DATA[1:0] == 2'b01 && INST_DATA[29:28]==2'b10) ? {INST_DATA[27:24],source_A,INST_DATA[23:12]} :
               ((INST_DATA[1:0] == 2'b01 && INST_DATA[29:28]==2'b11) ? {INST_DATA[27:24],source_A,source_B,INST_DATA[23:18]} : {opcode,source_A,source_B,des}))); 

     assign {R_W,X,Y} =  (INST_DATA[1:0]==2'b11) ? INST_DATA[27:25] : {RE_X_reg,CS_X_reg,CS_Y_reg};

     assign IN =  ((INST_DATA[1:0]==2'b11) || (INST_DATA[1:0] == 2'b10)) ? INST_DATA[24] : IN_reg; 
    

     assign {A_imm,B_imm} = (INST_DATA[1:0]==2'b01 && INST_DATA[29:28]==2'b01) ? {A_imm_reg,{22'd0,INST_DATA[11:2]}} :
	                 ((INST_DATA[1:0]==2'b01 && INST_DATA[29:28]==2'b10) ? {{22'd0,INST_DATA[11:2]},B_imm_reg} :
                         ((INST_DATA[1:0] == 2'b01 && INST_DATA[29:28]==2'b11) ? {{24'd0,INST_DATA[9:2]},{24'D0,INST_DATA[17:10]}} : {A_imm_reg,B_imm_reg})); 

     assign ADDR = (INST_DATA[1:0] == 2'b11) ?  {22'd0,INST_DATA[11:2]} : ADDR_reg;

     assign JUMP_ADDR = ((INST_DATA[1:0] == 2'B10) && !INST_DATA[24]) ? INST_DATA[23:18]  :
	                (((INST_DATA[1:0] == 2'B10) && IN_reg) ? WR_MEM :  JUMP_ADDR) ;

     assign CON = (INST_DATA[1:0] == 2'B10) ? INST_DATA[5] : 1'bx ;
     Memory #(.init_file_select(1)) X1(mem_addr, CS_X_reg, CLK, RE_X_reg, BSEL_reg, wr_mem, RE_MEM_X);

     Memory #(.init_file_select(1)) X2(mem_addr, CS_X_reg, CLK, WE_X_reg, BSEL_reg, wr_mem, RE_MEM);

     Memory #(.init_file_select(2)) Y1(mem_addr, CS_Y_reg, CLK, RE_Y_reg, BSEL_reg, wr_mem, RE_MEM_Y);

     Memory #(.init_file_select(2)) Y2(mem_addr, CS_Y_reg, CLK, WE_Y_reg, BSEL_reg, wr_mem, RE_MEM);
    
     assign {mem_addr,wr_mem} = IN_reg ? {WR_MEM,wr_mem} : {ADDR_reg,WR_MEM} ;            // Indirect Addressing Mode mux      
      
     assign RE_MEM_REG = CS_X_reg ? RE_MEM_X : RE_MEM_Y ;      // Memory Select Mux
     
     always @(posedge CLK)
	     	begin
			A_imm_reg <= A_imm;
			B_imm_reg <= B_imm;
                       {opcode,source_A,source_B,des} <= OSD;
			Result <= alu_out;
			reg_sel <= SEL;
			W_INST_reg <= W_INST;
			R_INST_reg <= R_INST;
                        ADDR_reg <= ADDR;		
			if(X == 1) begin
				CS_X_reg <= 1'b1;
				CS_Y_reg <= 1'b0;
				if(R_W) begin
				  RE_X_reg <= 1'b1;
				  RE_Y_reg <= 1'b0;
			          WE_X_reg <= 1'd1;
			          WE_X_reg <= 1'd1; end
				else if(!R_W) begin
					WE_Y_reg <= 1'b1;
					WE_X_reg <= 1'b0; 
				        RE_X_reg <= 1'b0;
			                RE_Y_reg <= 1'd0; end
			else if(Y == 1) begin
				 X_reg <= 1;
				 Y_reg <= 0;
				CS_Y_reg <= 1'b1;
				CS_X_reg <= 1'b0;
				if(R_W) begin
					RE_X_reg <= 1'b0;
					RE_Y_reg <= 1'b1;
			                WE_X_reg <= 1'd1;
			                WE_X_reg <= 1'd1; end
			        else if(!R_W) begin
				  WE_X_reg <= 1'b1;	
				  WE_Y_reg <= 1'b0;
			          RE_Y_reg <= 1'b0;
			          RE_X_reg <= 1'b0; end
			  end

			else
			begin
				CS_X_reg <= 1'b0;
				CS_Y_reg <= 1'b0;
			end
		end
		      //  mem_addr_reg <= mem_addr;  
		       // REG_IN_reg <= REG_IN;
			IN_reg <= IN;
			//{X_reg,Y_reg} <= {X,Y};
			BSEL_reg <= BSEL;
		//	JUMP_ADDR_reg <= JUMP_ADDR;
		    //   CON_reg = CON;
		  
	       	end

  endmodule





 
 






 
 
