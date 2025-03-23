`timescale 1ns / 1ps
module pc_mux #(parameter data_width = 32)(
    input [1:0] select,
    input [data_width - 1 :0] a,     //jump address
    input [data_width - 1 :0] b,    //ALU output result
    input [data_width - 1 :0] c,    //ALUOut reg output
    output reg [data_width - 1 :0] out
    );

always@(*) begin
    case(select) 
        2'b00: out = b;     //ALU OUTPUT i.e (PC+4)result sent to PC
        2'b01: out = c;     //ALUOut reg branch target address
        2'b10: out = a;     //jump address
        default: out = out;
    endcase
    end
endmodule
