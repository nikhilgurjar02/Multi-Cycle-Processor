`timescale 1ns / 1ns
module program_counter #(parameter data_width = 32)(
    input clk,rst,
    input PCWrite_final,
    input [data_width - 1 : 0] next_pc_address,   //This is PC+4 address and will be executed in next cycle
    output reg [data_width - 1 : 0] current_pc_address  //This is current PC address and getting executed in this cycle
    );
    
always@(posedge clk)  begin  
    if(rst)
        current_pc_address <= 0;
    else if(PCWrite_final)   
        current_pc_address <= next_pc_address;  
    else
        current_pc_address <= current_pc_address;      
       end
       
endmodule

