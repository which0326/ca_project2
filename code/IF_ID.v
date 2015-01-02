module IF_ID(input clk,
			 input reset,
			 input hazard_in,
			 input flush,
			 input [31:0]pc_plus4_in,
			 input [31:0]instruction_in,
			 input hold_i,
			 output reg[31:0] instruction_out,
			 output reg[31:0] pc_plus4_out);
			
always@(posedge reset)begin
	instruction_out = 0;
	pc_plus4_out = 0;
end

always@(posedge clk)begin
	pc_plus4_out <= pc_plus4_in;
  if(flush)begin
  //  TODO: flush method
    instruction_out <= 32'b0;
  end
	else begin
	  //  DEBUG: stall method
		if(hazard_in || hold_i)
			instruction_out <= instruction_out;
		else
    		instruction_out <= instruction_in;
	end
	  
	
end
endmodule
