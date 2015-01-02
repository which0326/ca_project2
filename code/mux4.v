module mux4(
	data1_i,//mux7 result
	data2_i,//signed extend
	IsALUSrc_i,
	data_o
);

input	[31:0]		data1_i;			
input	[31:0]		data2_i;
input				IsALUSrc_i;
output reg	[31:0]	data_o;		

always@(*)begin
	if(IsALUSrc_i)
		data_o = data2_i;
	else
		data_o = data1_i;
end	

endmodule