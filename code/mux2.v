module mux2(
	data1_i, //mux1.data_o
	data2_i, //jump_addr
	Isjump_i,
	data_o   
);
input	[31:0]		data1_i;
input	[31:0]		data2_i;
input				Isjump_i;
output reg [31:0]	data_o;

always@(*)begin
	if(Isjump_i)
		data_o = data2_i;
	else
		data_o = data1_i;
end

endmodule