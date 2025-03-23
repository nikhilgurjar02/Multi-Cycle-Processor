`timescale 1ns / 1ns
module memory(
    input [31:0] address,
    input [31:0] write_data,
    input ren,
    input wen,  //read enable or write enable => ren_wen[1] = read_enable and ren_wen[0]= write_enable
    output [31:0] read_data,
    
    //Testing Inputs
    input [31:0] test_address,
    input [31:0] test_data,
    input fill
    );

reg [7:0] data_mem [255:0] ;

assign read_data[7:0] = (ren == 1'b1) ? data_mem[address] : 8'b0;
assign read_data[15:8] = (ren == 1'b1) ? data_mem[address+1] : 8'b0;
assign read_data[23:16] = (ren == 1'b1) ? data_mem[address+2] : 8'b0;
assign read_data[31:24] = (ren == 1'b1) ? data_mem[address+3] : 8'b0;

always@(wen | address) begin
    data_mem[address] <= (wen == 1'b1) ? write_data[7:0] : data_mem[address];
    data_mem[address + 32'd1] <= (wen == 1'b1) ? write_data[15:8] : data_mem[address + 1];
    data_mem[address + 32'd2] <= (wen == 1'b1) ? write_data[23:16] : data_mem[address + 2];
    data_mem[address + 32'd3] <= (wen == 1'b1) ? write_data[31:24] : data_mem[address + 3];      
 end


//Verifying:
always@(test_address) begin
 data_mem[test_address] = test_data[7:0];
 data_mem[test_address + 32'd1] = test_data[15:8];
 data_mem[test_address + 32'd2] = test_data[23:16];
 data_mem[test_address + 32'd3] = test_data[31:24];
end

endmodule
