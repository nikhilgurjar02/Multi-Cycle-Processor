`timescale 1ns / 1ps
module controller(
    input clk,rst,Start,
    
    //memory interface
    output reg ren,
    output reg wen,
    
    //Datapath Interface
    input [5:0] opcode,
    input zero,
    output reg AluSrcA,
    output reg [1:0] AluSrcB,
    output reg [1:0] PCSource,
    output reg RegDst,
    output reg RegWrite,
    output reg MemtoReg,
    output reg IorD,
    output reg IRWrite,
    output reg PCWrite,
    output reg PCWriteCond,
    
    //ALU Controller Interface
    output reg [1:0] ALUop
    );

parameter Idle = 4'b1111;
parameter IF = 4'b0000;    //Instruction Fetch

parameter Decode = 4'b0001 ;   //Instruction Decode

parameter Execute_B = 4'b0010; //Branch Instruction (Write PC on branch condition)

parameter Execute_J = 4'b0011; //Jump Instruction (Write Jump Address in PC)

parameter Execute_R = 4'b0100; //R-type Instruction (perform alu operation)
parameter R_write_reg = 4'b0110 ; //Writing alu result in register

parameter Execute_M = 4'b0101; //Memory Instruction i.e lw/sw (Calculate memory address = base+offset) 
parameter Store = 4'b0111 ;    //Write/Store in memory on calculated address in previous state
parameter Load_read_mem = 4'b1000;  //Read data from memory from address calculated in previous state
parameter Load_write_reg = 4'b1001; //Write/Load in register on address given in instruction

reg [3:0] State;

always@(posedge clk) begin
    if(rst) begin
        State <= Idle ;
    end
    else begin
        case(State)
        
            Idle : begin
                if(Start)
                    State <= IF;
                else
                    State <= Idle;    
            end
            
            IF : State <= Decode ;
            
            Decode: begin
                case(opcode)
                    6'b000_100 : State <= Execute_B ;   //opcode for Branch
                    6'b000_010 : State <= Execute_J ;   //opcode for Jump
                    6'b000_000 : State <= Execute_R ;   //opcode for R
                    6'b100_011 : State <= Execute_M ;   //opcode for I lw
                    6'b101_011 : State <= Execute_M ;   //opcode for I sw
                endcase   
            end    
            
            Execute_B: State <= IF ;
            
            Execute_J: State <= IF ;
            
            Execute_R: State <= R_write_reg ;
            R_write_reg: State <= IF ;
            
            Execute_M: begin 
                if(opcode == 6'b101_011)
                 State <= Store ;
                else if (opcode == 6'b100_011) 
                 State <= Load_read_mem;
            end
            
            Store: State <= IF;
            
            Load_read_mem: State <= Load_write_reg;
            
            Load_write_reg: State <= IF;
        endcase
    end
end

always@(State) begin
    case(State) 
        Idle : begin
              ren <= 1'b0;
              wen <= 1'b0;
              AluSrcA <= 1'b0;
              AluSrcB <= 2'b00;
              PCSource <= 2'b00;
              RegDst <= 1'b0;
              RegWrite <= 1'b0;
              MemtoReg <= 1'b0;
              IorD <= 1'b0;
              IRWrite <= 1'b0;
              PCWrite <= 1'b0;
              PCWriteCond <= 1'b0;
              ALUop <= 2'b00;    
        end
    
        IF : begin
            ren <= 1'b1;
            AluSrcA <= 1'b0;
            IorD <= 1'b0;
            IRWrite <= 1'b1;
            AluSrcB <= 2'b01;
            ALUop <= 2'b00;
            PCWrite <= 1'b1;
            PCSource <= 2'b00;
            RegWrite <= 1'b0;
            wen <= 1'b0;
            PCWriteCond <= 1'b0;
        end
        
        Decode : begin
            AluSrcA <= 1'b0;
            AluSrcB <= 2'b11;
            ALUop <= 2'b00;
            ren <= 1'b0;
            IRWrite <= 1'b0;
            PCWrite <= 1'b0;
        end
        
        Execute_B : begin
            AluSrcA <= 1'b1;
            AluSrcB <= 2'b00;
            ALUop <= 2'b01;
            PCWriteCond <= 1'b1;//PCWriteCond = (zero==1)?1:0;
            PCSource <= 2'b01;//PCSource = (zero==1)?01:00;       
        end
        
        Execute_J : begin
            PCWrite <= 1'b1;
            PCSource <= 2'b10;
        end     
        
        Execute_R : begin
            AluSrcA <= 1'b1;
            AluSrcB <= 2'b00;
            ALUop <= 2'b10;
        end
        
        R_write_reg : begin
            RegWrite <= 1'b1;
            MemtoReg <= 1'b0;
            RegDst <= 1'b1;
        end  
        
        Execute_M : begin
            AluSrcA <= 1'b1;
            AluSrcB <= 2'b10;
            ALUop <= 2'b00;
        end 
        
        Store : begin
            wen <= 1'b1;
            IorD <= 1'b1;
            ren <=1'b0;
        end
        
        Load_read_mem : begin
            ren <= 1'b1;
            IorD <= 1'b1;
            wen <= 1'b0;      
        end
        
        Load_write_reg : begin
            RegWrite <= 1'b1;
            MemtoReg <= 1'b1;
            RegDst <= 1'b0;
        end 
        
    endcase
    
end 
   
endmodule
