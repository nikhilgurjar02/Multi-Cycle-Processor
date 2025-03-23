`timescale 1ns / 1ns
module reg_file
    #(parameter data_width = 32 ,
     parameter address_width = 5)   ///address width defines number of registers and data_width defines number of d flip flop in a register
(
    
    input [address_width - 1 : 0] reg1_addr,  ///rs of R-type Instruction
    input [address_width - 1 : 0] reg2_addr,  ///rt of R-type Instruction
    input [address_width - 1 : 0] reg3_addr,  ///rd of R-type and rt of I-type Instruction
    input [data_width - 1 : 0] write_data, ///Writing data into register file from ALU in R-type Instruction
                        // and from Data memory in I-type
    input  RegWrite, ///Write Enable for Write_data from Controller 
    input clk,rst,
    output [data_width -1 : 0] reg1_dataout,  ///this will be data output from reg file which will be going in ALU
    output [data_width -1 : 0] reg2_dataout     ///this will be data output from reg file which will be going in ALU
    
    );
 
 parameter number_of_register = 1 << address_width ;   //Number of Registers in the register file decided by address width (i.e 2^addr_width)
 wire [number_of_register - 1 : 0 ] register_Enable ;   //Register Enable for selecting a particular register in which we want to write data i.e, output of demux
 wire [data_width - 1 : 0] mux_in [number_of_register - 1 : 0 ];          //Register outputs will be connected to this net and this net is input to two Multiplexers which decides which register output is to be selected based on the reg_addr

 genvar i;   /// Instantiating 16/32 Resgisters in a single regiter file
 generate 
 
    for(i=0 ; i<number_of_register ; i = i+1) begin
    
    register #(.data_width(data_width)) registers(.clk(clk),.rst(rst),.en(register_Enable[i]),.data_in(write_data),.data_out(mux_in[i])); 
   ///Make a separate enable which come from Demux whose select line will tell which reg to write on i.e, reg3_addr (destination address)
    //Separate data_out for each reg will go to both the Mux whose select line will be reg1_addr and reg2_addr i.e, rs and rt
    end
 endgenerate

//mux #(.number_of_inputs(number_of_register),.data_width(data_width),.select_lines(address_width)) mux_reg1_addr(.selet(reg1_addr),.in(mux_in),.out(reg1_dataout)); //Output of Registers going in Mux1, output will be decided by reg1_addr i.e, "rs" 
//mux #(.number_of_inputs(number_of_register),.data_width(data_width),.select_lines(address_width)) mux_reg2_addr(.selet(reg2_addr),.in(mux_in),.out(reg2_dataout)); //Output of Registers going in Mux2, output will be decided by reg2_addr i.e, "rt" 
assign reg1_dataout = mux_in[reg1_addr];
assign reg2_dataout = mux_in[reg2_addr];

demux #(.number_of_outputs(number_of_register),.select_lines(address_width)) demux_reg3_addr(.select(reg3_addr),.in(RegWrite),.out(register_Enable)); ////this demux gives enable to only that register where we want to write data i.e, reg3_addr i.e, rd/rt


//Testing
//reg1 storing base address for picking data from data_memory 0th location
     
endmodule
