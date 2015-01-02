module Signed_Extend(
    data_i,
    data_o
);
input [15:0] data_i;
output reg [31:0] data_o;
	 
always @(*)
begin
	data_o[15:0]  = data_i[15:0];
	data_o[31:16] = {16{data_i[15]}};
end
endmodule
