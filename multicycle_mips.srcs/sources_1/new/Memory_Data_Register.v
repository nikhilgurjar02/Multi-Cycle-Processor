`timescale 1ns/1ns
module Memory_Data_Register #(parameter data_width = 32)(
    input clk,reset,
    input [data_width - 1: 0] read_data,
    output reg [data_width - 1 : 0] mdr_data
);

always@(posedge clk) begin
    if(reset) 
        mdr_data <= 32'b0;
    else
        mdr_data <= read_data;    
end

endmodule