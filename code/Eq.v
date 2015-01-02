module Eq(
	data1_i,
	data2_i,
	branch_o
);
input [31:0]   data1_i;
input [31:0]   data2_i;
output reg    branch_o;
always@(*)begin
	if(data1_i == data2_i)
		branch_o = 1;
	else
		branch_o = 0;
end

endmodule