`timescale 1ns / 1ps

module alu_mux #(parameter data_width = 32)(
    input [1:0] select,
    input [data_width - 1 :0] a,
    input [data_width - 1 :0] b,
    input [data_width - 1 :0] c,
    output reg [data_width - 1 :0] out
    );

always@(*) begin
    case(select) 
        2'b00: out = a;
        2'b01: out = 32'd4; 
        2'b10: out = b;
        2'b11: out = c;
    endcase
    end
endmodule
