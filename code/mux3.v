 module mux3(
	data1_i,//RT
	data2_i,//RD
	IsRegDst_i,
	data_o
);

input [4:0]		data1_i;
input [4:0]		data2_i;
input			IsRegDst_i;
output reg	[4:0]	data_o;

always@(*)begin
	if(IsRegDst_i)
		data_o = data2_i;
	else
		data_o = data1_i;
end

endmodule