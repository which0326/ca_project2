module mux7(
	data1_i,// ID/EX's read data2
	data2_i,// from REG's result 
	data3_i,// from EX's result
	IsForward_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input	[31:0]		data3_i;
input	[1:0]		IsForward_i;
output reg [31:0]	data_o;

always@(*)begin
	if(IsForward_i == 2'b00)
		data_o = data1_i;
	else if(IsForward_i == 2'b10)
		data_o = data3_i;
	else if(IsForward_i == 2'b01) 
		data_o = data2_i;
	else
		data_o = data1_i;

end

endmodule