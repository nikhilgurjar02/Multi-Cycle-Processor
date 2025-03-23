`timescale 1ns / 1ps

module alu_control(
    input [1:0] ALUop,
    input [5:0] func,
    output reg [2:0] op_select
    );

//ALUop == 00 means lw or sw Instruction
//ALUop == 01 means beq instruction so we subtract to compare;
//ALUop == 10 means R-type so we check function field for op_select

always@(ALUop) begin
    case(ALUop)
        2'b00 : op_select = 3'b010; // ADD
        2'b01 : op_select = 3'b110; // Sub
        2'b10 : begin              //R-Type instruction
            case(func)
                 6'b000_000 : op_select = 3'b010; //Let function = 000_001 for ADD
                 6'b000_001 : op_select = 3'b110; //Let function = 000_001 for Subtract
                 6'b000_010 : op_select = 3'b000; //Let function = 000_010 for AND
                 6'b000_011 : op_select = 3'b001; //Let function = 000_011 for OR
                 6'b000_100 : op_select = 3'b111; //Let function = 000_100 for Set if Less Than
            endcase
        end
    endcase
end    
    
endmodule
