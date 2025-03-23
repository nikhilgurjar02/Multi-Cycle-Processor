`timescale 1ns / 1ps
module datapath #(parameter data_width = 32, parameter address_width = 5)(
    input reset,clk,
    
    //Memory Interace
    output [31:0] address,
    output [31:0] write_data,
    input [31:0] read_data,
    
    //Controller Interface
    output [5:0] opcode,
    output zero,    // Used in branch statement beq to compare if they are equal
    input AluSrcA,
    input [1:0] AluSrcB,
    input [1:0] PCSource,
    input RegDst,
    input RegWrite,
    input MemtoReg,
    input IorD,
    input IRWrite,
    input PCWrite,
    input PCWriteCond,
    
    //ALU Controller Interface
    input [2:0] op_select,// which operation to be done selected by controller
    output [5:0] funct
    );

//PROGRAM COUNTER
wire PCWrite_final;
wire [data_width - 1 : 0] next_pc_address;   //This is PC+4 address and will be executed in next cycle
wire [data_width - 1 : 0] current_pc_address;
program_counter pc(.clk(clk),.rst(reset),
                   .PCWrite_final(PCWrite_final),
                   .next_pc_address(next_pc_address),.current_pc_address(current_pc_address)); 

//PC AND MEMORY MUX
wire [data_width - 1 : 0] aluout_reg;
assign address = (IorD ==1'b0)? current_pc_address : aluout_reg ;

//INSTRUCTION REGISTER
wire [data_width - 1 : 0] ir_data;
Instruction_Register IR(.clk(clk),.reset(reset),
                        .IRWrite(IRWrite),.read_data(read_data),
                        .ir_data(ir_data));  

assign funct = ir_data[5:0] ;   //Function to ALU Control for Arithmetic Op of R-type intruction 
assign opcode = ir_data[31:26] ;
//MEMORY DATA REGISTER                                          
wire [data_width - 1 : 0] mdr_data;
Memory_Data_Register MD_reg(.clk(clk),.reset(reset),.read_data(read_data),.mdr_data(mdr_data));

//RGISTER FILE
wire [address_width - 1 : 0] reg1_addr;  ///rs of R-type Instruction
wire [address_width - 1 : 0] reg2_addr;  ///rt of R-type Instruction
wire [address_width - 1 : 0] reg3_addr;  ///rd of R-type and rt of I-type Instruction
wire [data_width - 1 : 0] reg_write_data; ///Writing data into register file from ALU in R-type Instruction and from Data memory in I-type
wire [data_width -1 : 0] reg1_dataout;  ///this will be data output from reg file which will be going in ALU
wire [data_width -1 : 0] reg2_dataout;

reg_file register_file(.reg1_addr(reg1_addr),.reg2_addr(reg2_addr),.reg3_addr(reg3_addr),
                        .write_data(reg_write_data),.RegWrite(RegWrite),
                        .clk(clk),.rst(reset),
                        .reg1_dataout(reg1_dataout),.reg2_dataout(reg2_dataout));

assign reg1_addr = ir_data[25:21]    ;
assign reg2_addr = ir_data[20:16]    ;
assign reg3_addr = (RegDst == 0)? ir_data[20:16] : ir_data[15:11] ;  
assign reg_write_data = (MemtoReg == 0)? aluout_reg : mdr_data ;    

//ALU A REGISTER
wire [data_width -1 : 0] reg_A_out;
ALU_Reg ALU_A_REG(.clk(clk),.rst(reset),
                  .reg_dataout(reg1_dataout),.reg_out(reg_A_out));

//ALU B REGISTER
wire [data_width -1 : 0] reg_B_out;
ALU_Reg ALU_B_REG(.clk(clk),.rst(reset),
                  .reg_dataout(reg2_dataout),.reg_out(reg_B_out));

assign write_data = reg_B_out ; //This data goes for write into memory

//Operand A MUX
wire [data_width - 1 : 0] operand_a; // it will be coming from rs of register file or PC address for +4 in address
assign operand_a = (AluSrcA == 0)? current_pc_address : reg_A_out ;

//Operand B MUX
wire [data_width - 1 :0] operand_b; // rt of R-Type , offset of lw,sw and rt for beq of I Type
wire [data_width - 1 :0] sign_ex_data;
wire [data_width - 1 :0] sl_two;

assign sign_ex_data = {{16{ir_data[15]}},ir_data[15:0]} ;
assign sl_two = {sign_ex_data[29:0],2'b00};
alu_mux alu_op_b_mux(.select(AluSrcB),.a(reg_B_out),.b(sign_ex_data),.c(sl_two),.out(operand_b));


//ALU 
wire [data_width - 1 :0] result;
alu_main alu_op(.op_select(op_select),.operand_a(operand_a),.operand_b(operand_b),
                .result(result),.zero(zero));
                
//ALU OUTPUT REGISTER
ALUOut_reg Alu_out_reg(.clk(clk),.rst(reset),.in(result),.out(aluout_reg)); 

wire [data_width - 1 :0] pc_sl_two;
assign pc_sl_two = {current_pc_address[31:28],ir_data[25:0],2'b00}; //FOR Jump Address

pc_mux pc_address_mux(.select(PCSource),.a(pc_sl_two),.b(result),.c(aluout_reg),.out(next_pc_address));              

assign  PCWrite_final = PCWrite || (zero && PCWriteCond) ;           
endmodule
