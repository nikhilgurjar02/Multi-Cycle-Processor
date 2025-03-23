`timescale 1ns / 1ns
module dff_en(
    input clk,rst,
    input d,
    input en,
    output reg q
    );

always@(posedge clk) begin
if(rst)
    q <= 1'b0;
else if(en) 
    q <= d;
else
    q <= q;    
end 
    
endmodule
