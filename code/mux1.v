module mux1(
	data1_i,	//branch_addr
	data2_i,	//Add_pc + 4
	Isbranch_i,	//control && Eq
	data_o
);
input   [31:0]		data1_i;
input   [31:0]		data2_i;
input				Isbranch_i;
output reg [31:0]	data_o;

always@(*)begin
	if(Isbranch_i)
		data_o = data1_i;
	else
		data_o = data2_i;
end

endmodule