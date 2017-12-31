`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/11 08:29:00
// Design Name: 
// Module Name: ControlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit(
    input CLK,
    input RST,
    input [5:0] command,
    input zero,
    input sign,
    output  [1:0] PCSrc,
    output [1:0] RegDst,
    output  InsMemRW,
    output  PCWre,
    output  ExtSel,
    output  DBDataSrc,
    output  WR,
    output  ALUSrcB,
    output  ALUSrcA,
    output  [2:0] ALUOp,
    output  RegWre,
    output  RD,
    output  WrRegDSrc,
    output  IRWre,
    output reg[3:0] state,
    output reg[3:0] next_state
    );
    reg[3:0] state_out;
    parameter [3:0]  sIF=4'b0000,
                 sID=4'b0001,
                sEAL=4'b1000,
                sEBR=4'b0100,
                sELS=4'b0010,
                sMLD=4'b0011,
                sMST=4'b0101,
                sWAL=4'b1001,
                sWLD=4'b0110;
 parameter [5:0] j=6'b111000,
                jr=6'b111001,
               jal=6'b111010,
                lw=6'b110001,
                sw=6'b110000,
               beq=6'b110100,
               bne=6'b110101,
              bgtz=6'b110110,					
               add=6'b000000,
               sub=6'b000001,
               And=6'b010001,
                Or=6'b010000,
               sll=6'b011000,
               slt=6'b100110,
              addi=6'b000010,
               ori=6'b010010,
              slti=6'b100111,
              half=6'b111111;	
  
    always@(posedge CLK) 
        begin
            if(RST==0)
                begin
                    state=sIF;
                end
            else 
                begin
                    state=next_state;
                end
            state_out=state;
        end

always@(command or state) 
    begin
        case(state)
            sIF:next_state=sID;
            sID:
                if(command[5:3]==3'b111)
                    begin
                        next_state=sIF;
                    end
                else if(command[5:2]==4'b1100)
                    begin
                        next_state=sELS;
                    end
                else if(command[5:2]==4'b1101)
                    begin
                        next_state=sEBR;
                    end
                else 
                    begin
                        next_state=sEAL;
                    end 
            sELS:
                if(command==lw)
                    begin
                        next_state=sMLD;
                    end 
                else 
                    begin
                        next_state=sMST;
                    end
            sEBR:next_state=sIF;    
            sEAL:next_state=sWAL;
            sWAL:next_state=sIF;
            sMLD:next_state=sWLD;
            sWLD:next_state=sIF; 
            sMST:next_state=sIF; 
        endcase
    end
    CU_Output cu_output(state,command,zero,sign,PCSrc,RegDst,InsMemRW,PCWre,ExtSel,DBDataSrc,WR,ALUSrcB,ALUSrcA,ALUOp,RegWre,RD,WrRegDSrc,IRWre);
endmodule
