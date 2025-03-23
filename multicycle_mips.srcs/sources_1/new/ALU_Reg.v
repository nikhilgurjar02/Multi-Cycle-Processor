`timescale 1ns / 1ps

module ALU_Reg #(parameter data_width = 32)(
    input clk,rst,
    input [data_width -1 : 0] reg_dataout,
    output reg [data_width -1 : 0] reg_out
    );

always@(posedge clk) begin
    if(rst)
        reg_out <= 32'b0;
    else 
        reg_out <= reg_dataout ;
end

                
endmodule
