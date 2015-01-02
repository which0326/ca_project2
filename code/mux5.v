module mux5(
	data1_i,//read data from memory
	data2_i,//ALU result
	IsMemtoReg_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input				IsMemtoReg_i;
output reg [31:0]	data_o;

always@(*)begin
	if(IsMemtoReg_i)
		data_o = data1_i;
	else
		data_o = data2_i;
end

endmodule