module Control(
	Inst_i,
	Branch_o,
	Jump_o,
	Control_o
);
input		     [5:0]   Inst_i;
output reg	         Branch_o,Jump_o;
output reg 	[7:0]   Control_o;

//WB
// Control_o[0] is RegWrite
// Control_o[1] is MemtoReg
//M
// Control_o[2] is MemRead
// Control_o[3] is MemWrite
//EX
// Control_o[4] is ALUSrc
// Control_o[5][6] is ALUOp 2 bit
// Control_o[7] is RegDst

always@(*) begin // R-type
	Branch_o = 0;
	Jump_o = 0;
	if(Inst_i == 6'b000000)begin
		Control_o[0] = 1;
		Control_o[1] = 0;
		Control_o[2] = 0;
		Control_o[3] = 0;
		Control_o[4] = 0;
		Control_o[6:5] = 2'b10;
		Control_o[7] = 1;
	end
	
	if(Inst_i == 6'b001000)begin // addi
		Control_o[0] = 1;
		Control_o[1] = 0;
		Control_o[2] = 0;
		Control_o[3] = 0;
		Control_o[4] = 1;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0;
	end
	
	if(Inst_i == 6'b101011)begin // sw
		Control_o[0] = 0;
		Control_o[1] = 0;// don't care
		Control_o[2] = 0;
		Control_o[3] = 1;
		Control_o[4] = 1;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0; // don't care
	end
	
	if(Inst_i == 6'b100011)begin // lw
		Control_o[0] = 1;
		Control_o[1] = 1;
		Control_o[2] = 1;
		Control_o[3] = 0;
		Control_o[4] = 1;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0;
	end
	
	if(Inst_i == 6'b000010)begin // j
		Jump_o = 1;
		Control_o[0] = 0;
		Control_o[1] = 0; // don't care
		Control_o[2] = 0; 
		Control_o[3] = 0;
		Control_o[4] = 0;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0; // don't care
	end
	
	if(Inst_i == 6'b000100)begin // beq
		Branch_o = 1;
		Control_o[0] = 0;
		Control_o[1] = 0; // don't care
		Control_o[2] = 0; 
		Control_o[3] = 0;
		Control_o[4] = 0;
		Control_o[6:5] = 2'b01;
		Control_o[7] = 0; // don't care
	end
end


endmodule