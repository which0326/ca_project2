module mux8(
	data_i,
	IsHazzard_i,
	data_o
);
input	[7:0]		data_i;
output	reg [7:0]	data_o;
input IsHazzard_i;

always@(*)begin
	if(IsHazzard_i)begin
		data_o = 7'b0;
	end
	else begin 
		data_o = data_i;
	end
end

endmodule