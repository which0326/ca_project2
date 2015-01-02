module PC
(
    clk_i,
	rst_i,
    start_i,
    pc_i,
	IsHazzard_i,
	hold_i,
    pc_o
);

// Ports
input               clk_i;
input               IsHazzard_i;
input               start_i;
input				rst_i;
input   [31:0]      pc_i;
output  reg [31:0]  pc_o;

// Wires & Registers

always@(posedge clk_i) begin
  if(start_i)begin
    if(IsHazzard_i || hold_i)
      pc_o <= pc_i-4;
    else
      pc_o <= pc_i;
  end
  else
		pc_o <= 32'b0;
end

endmodule
