`timescale 1ns / 1ps
module processor(
    input clk,reset,Start,
    
    //For Verifying Functionality
    input [31:0] test_address,
    input [31:0] test_data,
    input fill
    );


//CONTROLLER
    //Memory Interface
    wire ren;
    wire wen;    
    //Datapath Interface
    wire [5:0] opcode;
    wire zero;
    wire AluSrcA;
    wire [1:0] AluSrcB;
    wire [1:0] PCSource;
    wire RegDst;
    wire RegWrite;
    wire MemtoReg;
    wire IorD;
    wire IRWrite;
    wire PCWrite;
    wire PCWriteCond;  
    //ALU Controller Interface
    wire [1:0] ALUop ;
    
controller control(.clk(clk),.rst(reset),.Start(Start),
                .ren(ren),.wen(wen),
                 .opcode(opcode),.zero(zero),
                .AluSrcA(AluSrcA),.AluSrcB(AluSrcB),.PCSource(PCSource),
                .RegDst(RegDst),.RegWrite(RegWrite),.MemtoReg(MemtoReg),.IorD(IorD),
                .IRWrite(IRWrite),.PCWrite(PCWrite),.PCWriteCond(PCWriteCond),
                .ALUop(ALUop)); 

 // ALU CONTROL
    wire [5:0] func;
    wire [2:0] op_select;
alu_control alu_op_select(.ALUop(ALUop),.func(func),.op_select(op_select));

 //MEMORY
    wire  [31:0] address;
    wire [31:0] mem_write_data;
    wire [31:0] read_data ;
memory mem(.ren(ren),.wen(wen),
           .address(address),.write_data(mem_write_data),.read_data(read_data),
           .test_address(test_address),.test_data(test_data),.fill(fill));


//DATAPATH

datapath datapth(.clk(clk),.reset(reset),
                 .address(address),.write_data(mem_write_data),.read_data(read_data),
                .opcode(opcode),.zero(zero),
                .AluSrcA(AluSrcA),.AluSrcB(AluSrcB),.PCSource(PCSource),
                .RegDst(RegDst),.RegWrite(RegWrite),.MemtoReg(MemtoReg),.IorD(IorD),
                .IRWrite(IRWrite),.PCWrite(PCWrite),.PCWriteCond(PCWriteCond),
                .funct(func),.op_select(op_select)
            );
   
endmodule
