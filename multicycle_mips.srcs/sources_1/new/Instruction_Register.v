`timescale 1ns/1ns
module Instruction_Register #(parameter data_width = 32)(
    input clk,reset,
    input IRWrite,
    input [data_width - 1: 0] read_data,
    output reg [data_width - 1 : 0] ir_data
);

always@(posedge clk) begin
    if(reset) begin
        ir_data <= 32'b0;
    end
    else if(IRWrite)
        ir_data <= read_data;
    else
        ir_data <= ir_data;    
end

endmodule