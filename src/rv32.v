/////////////////////////////////////////////////////////////////////////
// Module rv32.v   
//                                         
// Info:  Verilog Code for rv32I
//        For R type instructions
//  
////////////////////////////////////////////////////////////////////////


`include "register_file.v"                  //32 General Purpose Registers
`include "compare.v"                        //Compare module for single bit output for branch instructions                             
`include "alu.v"                            //32 Bit ALU
`include "mini_decoder.v"                   //Mini Decoder for decoding R Type registers

module rv32
(
    input                      clk,         //Clock
    input                    reset,         //High to reset processor

    input  wire [31:0]      in_data,        //Word Read From Memory
    output reg  [31:0]     out_data,        //Word to store in memory
    output reg [31:0]  out_mem_addr,        //Memory Access address

    output reg               mem_wr,        //Memory Write
    output reg               mem_rd         //Memory Read
);
    parameter ADDR_WIDTH = 32;              //width of the the address bus

    //The Program Counter 
    reg [ADDR_WIDTH - 1:0] PC;

    //The Latched Instruction
    reg [31:0] instr;

    //Program Counter in Normal Operation
    wire [ADDR_WIDTH - 1:0] PCplus4 = PC + 1;

    ///////////////////////////////////////////////////////////////////
    // Instruction Decoding
    ////////////////////////////////////////////////////////////////////

    wire [4:0] writeBackRegId;          //The register to be written back
    wire [4:0]         RegId1;          //Register output 1
    wire [4:0]         RegId2;          //Register output 2
    
    wire [2:0] 	        func3;          // operation done by the ALU, tests, load/store mode
    wire 	         funcQual;          // 'qualifier' used by some operations (+/-, logic/arith shifts)

    wire          writeBackEn;          //Asserted when writing to a reg
    wire              alusel1;          //   alu sel1        alusel 2  
    wire              alusel2;          // 0  : Register   0  : Register
                                        // 1  :    PC      1  :    imm 

    wire                isALU;          //Asserted for ALU opeartion

    wire [31:0] 	      imm;          // immediate value decoded from the instruction

    mini_decoder decoder
    (
        .instr(instr),                   //The instruction to be deocded 
   
        .writeBackEn(writeBackEn),      //Asserted when writing to a reg
        .rd(writeBackRegId),            //The register to be written back
        .rs1(RegId1),                   //Register output 1
        .rs2(RegId2),                   //Register output 2

        .func3(func3),                  //Operation done by ALU
        .funcQual(funcQual),            //Operation Qualifier

        .alusel1(alusel1),              //Selectes whether input to ALU is PC, Registers or IMM
        .alusel2(alusel2),

        .isALU(isALU),                  //Asserted for ALU opeartion           

        .imm(imm)                       //Immediate Value decoded from the instruction
    );

    ////////////////////////////////////////////////////////////////////
    // Register File
    ////////////////////////////////////////////////////////////////////
    
    wire writeBack;                     // asserted if register write back is done.
    reg  [31:0] writeBackData;
    wire [31:0] regOut1;
    wire [31:0] regOut2;

    assign writeBack = writeBackEn;
    
    register_file regs
    (     
        .clock(clk),                       //Clock for register 
        .read1(RegId1),                    //5 Bit address of register 1
        .read2(RegId2),                    //5 Bit address of register 2
        .writereg(writeBackRegId),         //5 Bit Write Register Address 
        .writedata(writeBackData),         //32 Bit data for write Register
        .inEn(writeBack),                  //Control Signal for regwrite
        .data1(regOut1),                   //Data 1 from register 1 
        .data2(regOut2)                    //Data 2 from register 2
    );

    ////////////////////////////////////////////////////////////////////
    // ALU
    ////////////////////////////////////////////////////////////////////

    wire [31:0] aluout;
    reg [31:0] aluIn1;
    reg [31:0] aluIn2;

    alu ALU
    (   
        .clk(clk),
        .in1(aluIn1),
        .in2(aluIn2),
        .func3(func3),          // Control Signal op: [14:12]
        .opequal(funcQual),     // Operation Qualification (+/-, Logical/Arithmetic)
        .out(aluout)            // ALU result
    );

    ////////////////////////////////////////////////////////////////////
    // The State Machine
    ////////////////////////////////////////////////////////////////////
    
    // The states, using 1-hot encoding (reduces both LUT count and critical path).
    reg [4:0] state;

    always @(posedge clk) begin
        state <= 0;
        mem_wr <= 0;
        mem_rd <= 0;

        //Reset Condition
        if (reset) begin
            state[0] <= 1'b1;
            PC      <= 32'b0;    
        end
        else begin 
            case(1'b1)
                //-------------------------Fetch----------------------------------
                state[0]: begin         
                    out_mem_addr <= PC;
                    mem_rd       <=  1;
                    state[1]     <=  1;
                end
                //-------------------------Delay----------------------------------                
                state[1]: begin         
                    state[2]     <=  1;
                end
                //-------------------------Decode----------------------------------   
                state[2]: begin
                    instr        <= in_data;
                    state[3]     <=  1;
                end  
                //-------------------------Execute----------------------------------   
                state[3]: begin
                    PC <= PCplus4;
                    writeBackData <= aluout;
                    aluIn1 <= regOut1;
                    aluIn2 <= regOut2;
                    state[0]     <=  1;
                end  
                default: state[0] <= 1;     
            endcase
        end
    end
endmodule 