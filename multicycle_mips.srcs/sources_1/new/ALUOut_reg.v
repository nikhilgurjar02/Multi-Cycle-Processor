`timescale 1ns / 1ns

module ALUOut_reg(
    input clk,rst,
    input [31:0] in,
    output reg [31:0] out
);

always@(posedge clk) begin
    if(rst) 
        out <= 32'b0;
    else
        out <= in;    
end
endmodule