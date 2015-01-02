module ALU_Control(funct_i, ALUOp_i, ALUCtrl_o);
  
  output reg [2:0] ALUCtrl_o;
  input  [1:0] ALUOp_i;
  input  [5:0] funct_i;
  
  always@(*)begin
    case(ALUOp_i)
      2'b00: ALUCtrl_o <= 3'b010;
    default:
		  case(funct_i)
          6'b100000: ALUCtrl_o <= 3'b010; //add
          6'b011000: ALUCtrl_o <= 3'b011; //mul
          6'b100010: ALUCtrl_o <= 3'b110; //sub
          6'b100100: ALUCtrl_o <= 3'b000; //and
          6'b100101: ALUCtrl_o <= 3'b001; //or
      endcase
    endcase
  end
endmodule