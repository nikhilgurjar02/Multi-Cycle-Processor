`timescale 1ns / 1ps
module register #(parameter data_width = 32)(
    input clk,rst,
    input en,
    input [data_width - 1 : 0] data_in,
    output  [data_width - 1 :0] data_out
    );

/*    
always@(posedge clk) begin
if(en)
    data_out <= data_in;
else
    data_out <= data_out;    
end
*///We can use this as well for instantiating dff with enable

genvar i ;

  generate  
        for (i = 0 ; i < data_width ; i= i+1) begin
        dff_en dff1(.clk(clk),.rst(rst),.en(en),.d(data_in[i]),.q(data_out[i]));
    end    
  endgenerate 

endmodule
