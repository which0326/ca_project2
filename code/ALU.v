`timescale 1 ns/1 ns

module ALU(data1_i, data2_i, ALUCtrl_i, data_o);
input [31:0] data1_i, data2_i;
input [2:0] ALUCtrl_i;
output reg[31:0] data_o;
//wire [31:0] data_o;
//reg [31:0] data_out_tmp;

//assign data_o = data_out_tmp;

always@(data1_i, data2_i, ALUCtrl_i)begin
  if(ALUCtrl_i==3'b000)begin
    data_o = data1_i & data2_i;
  end
  else if(ALUCtrl_i==3'b001)begin
    data_o = data1_i | data2_i;
  end
  else if(ALUCtrl_i==3'b010)begin
    data_o = data1_i + data2_i;
  end
  else if(ALUCtrl_i==3'b011)begin
    data_o = data1_i * data2_i;
  end
  else if(ALUCtrl_i==3'b110)begin
    data_o = data1_i - data2_i;
  end
  else begin
    data_o = data1_i;
  end
end

endmodule