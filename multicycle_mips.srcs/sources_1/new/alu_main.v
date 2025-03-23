`timescale 1ns / 1ns

module alu_main #(parameter data_width = 32)(
    input [2:0] op_select, // which operation to be done selected by controller
    input [data_width - 1 : 0] operand_a, // it will be always coming from rs of register file
    input [data_width - 1 :0] operand_b, // rt of R-Type , offset of lw,sw and rt for beq of I Type
    output reg [data_width - 1 :0] result,
    output zero // Used in branch statement beq to compare if they are equal
    );

always@(*) begin
    case(op_select) 
        3'b000: result = operand_a & operand_b ; /// Bitwise AND   // for logical-->&(only 1 or 0 output)
        3'b001: result = operand_a | operand_b ;
        3'b010: result = operand_a + operand_b ;
        3'b110: result = operand_a - operand_b ;
        3'b111: begin
                if(operand_a < operand_b)
                    result = 1'b1;
                else
                    result = 1'b0;
            end 
    endcase
end    

assign zero = (operand_a == operand_b) ? 1'b1 : 1'b0; 
  
endmodule
