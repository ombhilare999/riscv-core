///////////////////////////////////////////
// Module mini_decoder.v   
//                                         
// Info:  Verilog Code for mini decoder
//        Decoder for RISCV
//  
///////////////////////////////////////////

module mini_decoder
(
   input wire [31:0]          instr,          //The instruction to be deocded 
   
   output reg           writeBackEn,          //Asserted when writing to a reg
   output wire [4:0] writeBackRegId,          //The register to be written back
   output wire [4:0]       inRegId1,          //Register output 1
   output wire [4:0]       inRegId2,          //Register output 2

   output [2:0]               func3,         //Operation done by ALU
   output reg              funcQual,         //Operation Qualifier
   
   output reg [31:0]            imm          //Immediate Value decoded from the instruction
);


    //Decoding:
    assign writeBackRegId =  instr[11:7];       //Rd Register
    assign inRegId1       = instr[19:15];       //Rs1 Register
    assign inRegId2       = instr[24:20];       //Rs2 Register
    assign func3          = instr[14:12];       //Decides the operation

    /*Five Immediate formats:
    wire [31:0] Iimm = {{21{instr[31]}}, instr[30:20]};
    wire [31:0] Simm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
    wire [31:0] Bimm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    wire [31:0] Jimm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};   
    wire [31:0] Uimm = {instr[31], instr[30:12], {12{1'b0}}};
    */

    //We need to distinguish shifts for two reasons:
    // - we need to wait for ALU when it is a shift
    // - For ALU ops with immediate: funcQual is 0
    //   EXCEPT for shifts ALU ops/funcqual :: then it is instr[30]

    wire funcisshift = (func3 == 3'b0001) || (func3 == 3'b101);

    //The rest of instruction decoding, for the following signals:
    // WriteBackEn
    // funcqual

    // The Two LSBs are always 11 in the base RV32I instruction set.
    // One can also check for error when these bits are whether or zero or not

    always @(*) begin  
        if( instr[6:2] == 5'b01100) begin   // ALU operation: Register,Register
            writeBackEn =   1'b1;
            funcQual = instr[30];         
        end
    end
    
endmodule 