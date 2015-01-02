module CPU
(
	clk_i,
	rst_i,
	start_i,
   
	mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o
);

//input
input clk_i;
input rst_i;
input start_i;

//
// to Data Memory interface		
//
input	[256-1:0]	mem_data_i; 
input				mem_ack_i; 	
output	[256-1:0]	mem_data_o; 
output	[32-1:0]	mem_addr_o; 	
output				mem_enable_o; 
output				mem_write_o;

wire      [31:0]      inst_addr, inst; 
wire                  flush;
wire				  cache_stall;

assign flush = Control.Jump_o | (Control.Branch_o & Eq.branch_o);

Control Control(
	.Inst_i(IF_ID.instruction_out[31:26]),
	.Branch_o(),
	.Jump_o(),
	.Control_o()
);

Eq Eq(
	.data1_i(Registers.RSdata_o),
	.data2_i(Registers.RTdata_o),
	.branch_o()
);

FW FW(
  .EX_MEM_RegWrite(EX_MEM.WB_out[0]),
  .MEM_WB_RegWrite(MEM_WB.RegWrite),
  .EX_MEM_RegisterRd(EX_MEM.instruction_mux_out),
  .MEM_WB_RegisterRd(MEM_WB.instruction_mux_out),
  .ID_EX_RegisterRs(ID_EX.Inst_25_to_21_out),
  .ID_Ex_RegisterRt(ID_EX.Inst_20_to_16_out),
  .ForwardA(),
  .ForwardB()
);

HD HD(
    .ID_EX_MemRead(ID_EX.M_out[0]),
    .IF_ID_RegisterRs(IF_ID.instruction_out[25:21]),
    .IF_ID_RegisterRt(IF_ID.instruction_out[20:16]),
    .ID_EX_RegisterRt(ID_EX.Inst_20_to_16_out),
    .PC_Write(),
    .IF_ID_Write(),
    .data_o()
);

Instruction_Memory IM
(
    .addr_i(PC.pc_o), 
    .instr_o()
);

mux1 mux1(
	.data1_i(ADD.data_o),	//branch_addr
	.data2_i(add_pc.data_o),	//Add_pc + 4
	.Isbranch_i(Control.Branch_o & Eq.branch_o),	//control && Eq
	.data_o()
);

mux2 mux2(
	.data1_i(mux1.data_o), //mux1.data_o
	//	DEBUG
	.data2_i({mux1.data_o[31:28], IF_ID.instruction_out[25:0], 2'b00}), //jump_addr
	.Isjump_i(Control.Jump_o),
	.data_o()   
);

mux3 mux3(
	.data1_i(ID_EX.Inst_20_to_16_out),//RT
	.data2_i(ID_EX.Inst_15_to_11_out),//RD
	.IsRegDst_i(ID_EX.RegDst_out),
	.data_o()
);

mux4 mux4(
	.data1_i(mux7.data_o),//mux7 result
	.data2_i(ID_EX.sign_extended_out),//signed extend
	.IsALUSrc_i(ID_EX.ALUSrc_out),
	.data_o()
);

mux5 mux5(
	.data1_i(MEM_WB.ReadData_out),//read data from memory
	.data2_i(MEM_WB.ALU_out),//ALU result
	.IsMemtoReg_i(MEM_WB.MemtoReg),
	.data_o()
);

mux6 mux6(
	.data1_i(ID_EX.RDdata1_out),// ID/EX's read data1
	.data2_i(mux5.data_o),// from REG's result 
	.data3_i(EX_MEM.ALU_out),// from EX's result
	.IsForward_i(FW.ForwardA),
	.data_o()
);

mux7 mux7(
	.data1_i(ID_EX.RDdata2_out),// ID/EX's read data2
	.data2_i(mux5.data_o),// from REG's result 
	.data3_i(EX_MEM.ALU_out),// from EX's result
	.IsForward_i(FW.ForwardB),
	.data_o()
);

mux8 mux8(
	.data_i(Control.Control_o),
	.IsHazzard_i(HD.data_o),
	.data_o()
);

PC PC(
    .clk_i(clk_i),
	.rst_i(rst_i),
    .start_i(start_i),
    .pc_i(mux2.data_o),
	.IsHazzard_i(HD.PC_Write),
	.hold_i(cache_stall),
    .pc_o()
);

Registers Registers
(
    .clk_i(clk_i),
    .RSaddr_i(IF_ID.instruction_out[25:21]),
    .RTaddr_i(IF_ID.instruction_out[20:16]),
    .RDaddr_i(MEM_WB.instruction_mux_out), 
    .RDdata_i(mux5.data_o),
    .RegWrite_i(MEM_WB.RegWrite), 
    .RSdata_o(), 
    .RTdata_o() 
);

Signed_Extend Signed_Extend(
    .data_i(IF_ID.instruction_out[15:0]),
    .data_o()
);

Adder ADD(
	.data1_in(Signed_Extend.data_o << 2),
	.data2_in(IF_ID.pc_plus4_out),
	.data_o()
);

Adder add_pc(
	.data1_in(PC.pc_o),
	.data2_in(32'b100),
	.data_o()
);

/*Data_memory Data_memory(
	.clk_i(clk_i),
	.addr_i(EX_MEM.ALU_out),
	.data_i(EX_MEM.RDdata2_out),
	.IsMemWrite(EX_MEM.MemWrite),
	.IsMemRead(EX_MEM.MemRead),
	.data_o()
);*/

IF_ID IF_ID(
	.clk(clk_i),
	.reset(),
	.hazard_in(HD.IF_ID_Write),
	.flush(Control.Jump_o | (Control.Branch_o & Eq.branch_o)),
	.pc_plus4_in(add_pc.data_o),
	.instruction_in(IM.instr_o),
	.instruction_out(),
	.pc_plus4_out(),
	.hold_i(cache_stall)
);

ID_EX ID_EX(
	.clk(clk_i),
    .reset(),
	.WB_in(mux8.data_o[1:0]),
    .M_in(mux8.data_o[3:2]),
    .EX_in(mux8.data_o[7:4]),
    .RDdata1_in(Registers.RSdata_o),
    .RDdata2_in(Registers.RTdata_o),
    .sign_extended_in(Signed_Extend.data_o),
    .Inst_25_to_21_in(IF_ID.instruction_out[25:21]),
    .Inst_20_to_16_in(IF_ID.instruction_out[20:16]),
    .Inst_15_to_11_in(IF_ID.instruction_out[15:11]),
    .Inst_5_to_0_in(),
	.pc_plus4_in(IF_ID.pc_plus4_out),
    .WB_out(),
    .M_out(),
    .ALUSrc_out(),
	.ALUOp_out(),
	.RegDst_out(),
    .RDdata1_out(),
    .RDdata2_out(),
    .sign_extended_out(),
    .Inst_25_to_21_out(),
    .Inst_20_to_16_out(),
    .Inst_15_to_11_out(),
    .Inst_5_to_0_out(),
	.hold_i(cache_stall)
);

EX_MEM EX_MEM(
	.clk(clk_i),
    .reset(),
    .WB_in(ID_EX.WB_out),
    .M_in(ID_EX.M_out),
    .ALU_in(ALU.data_o),
    .instruction_mux_in(mux3.data_o),
    .RDdata2_in(mux7.data_o),
    .MemWrite(),
	.MemRead(),
    .WB_out(),
    .ALU_out(),
    .instruction_mux_out(),
    .RDdata2_out(),
	.hold_i(cache_stall)
);

MEM_WB MEM_WB(
	.clk(clk_i),
    .reset(),
    .WB_in(EX_MEM.WB_out),
	.ReadData_in(dcache.p1_data_o),
	.ALU_in(EX_MEM.ALU_out),
	.instruction_mux_in(EX_MEM.instruction_mux_out),
	.RegWrite(),
	.MemtoReg(),
	.ReadData_out(),
	.ALU_out(),
	.instruction_mux_out(),
	.hold_i(cache_stall)
);

ALU ALU(
    .data1_i    (mux6.data_o),
    .data2_i    (mux4.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (ID_EX.sign_extended_out[5:0]),
    .ALUOp_i    (ID_EX.ALUOp_out),
    .ALUCtrl_o  ()
);

//data cache
dcache_top dcache
(
    // System clock, reset and stall
	.clk_i(clk_i), 
	.rst_i(rst_i),
	
	// to Data Memory interface		
	.mem_data_i(mem_data_i), 
	.mem_ack_i(mem_ack_i), 	
	.mem_data_o(mem_data_o), 
	.mem_addr_o(mem_addr_o), 	
	.mem_enable_o(mem_enable_o), 
	.mem_write_o(mem_write_o), 
	
	// to CPU interface	
	.p1_data_i(EX_MEM.RDdata2_out), 
	.p1_addr_i(EX_MEM.ALU_out), 	
	.p1_MemRead_i(EX_MEM.MemRead), 
	.p1_MemWrite_i(EX_MEM.MemWrite), 
	.p1_data_o(), 
	.p1_stall_o(cache_stall)
);

endmodule
