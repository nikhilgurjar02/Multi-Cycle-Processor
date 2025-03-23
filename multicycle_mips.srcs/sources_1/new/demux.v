`timescale 1ns / 1ps

module demux #(parameter number_of_outputs =32,
               parameter select_lines = 5)
    (
        input [select_lines - 1 : 0 ]select,
        input in,
        output [number_of_outputs - 1 : 0]out
    );
   
genvar i;
generate
    for(i=0 ; i < number_of_outputs ; i = i +1) begin
    
        assign out[i] = (select == i) ? in : 0; 
    
    end
endgenerate 
    
endmodule
