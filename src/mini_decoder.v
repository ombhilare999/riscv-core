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
   output wire [4:0]             rd,          //The register to be written back
   output wire [4:0]            rs1,          //Register output 1
   output wire [4:0]            rs2,          //Register output 2

   output [2:0]               func3,         //Operation done by ALU
   output reg              funcQual,         //Operation Qualifier

   output reg               alusel1,         //   alu sel1        alusel 2  
   output reg               alusel2,         // 0  : Register   0  : Register
                                             // 1  :    PC      1  :    imm 

   output reg                 isALU,         // Status signal for ALU operation
   output reg [31:0]            imm          //Immediate Value decoded from the instruction
);


    //Decoding:
    assign rd        =  instr[11:7];       //Rd Register
    assign rs1       = instr[19:15];       //Rs1 Register
    assign rs2       = instr[24:20];       //Rs2 Register
    assign func3     = instr[14:12];       //Decides the operation


    //Five Immediate formats:
    wire [31:0] Iimm = {{21{instr[31]}}, instr[30:20]}; 
    //wire [31:0] Simm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
    //wire [31:0] Bimm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    //wire [31:0] Jimm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};   
    //wire [31:0] Uimm = {instr[31], instr[30:12], {12{1'b0}}};
    

    //We need to distinguish shifts for two reasons:
    // - For ALU ops with immediate: funcQual is 0
    //   EXCEPT for shifts ALU ops/funcqual :: then it is instr[30]

    wire funcisshift = (func3 == 3'b001) || (func3 == 3'b101);

    /*The rest of instruction decoding, for the following signals:
       WriteBackEn
       funcqual
          alu sel1     |      alusel 2  
        0  : Register  |    0  : Register
        1  :    PC     |    1  :    imm 
    */

    // The Two LSBs are always 11 in the base RV32I instruction set.
    // One can also check for error when these bits are whether or zero or not

    always @(*) begin  

        isALU    = 1'b0;
        funcQual = 1'b0;

        alusel1  = 1'bx;
        alusel2  = 1'bx;

        imm      = 32'bx;
        writeBackEn = 1'bx;


        (* parallel_case, full_case *)
        case(instr[6:2])
            5'b00100: begin   // ALU operation: Register,Immediate
                writeBackEn =   1'b1;   //Enables write Back
                funcQual    = funcisshift ? instr[30] : 1'b0;   
                isALU       =   1'b1;   //ALU operation

                alusel1     =   1'b0;   //ALU source 1: register
                alusel2     =   1'b1;   //ALU source 2: Immediate
                imm = Iimm;             // imm format = I
            end

            5'b01100: begin   // ALU operation: Register,Register
                writeBackEn =   1'b1;   //Enables write Back
                funcQual = instr[30];   //Function Qualifier
                isALU       =   1'b1;   //ALU opearation

                alusel1     =   1'b0;   //ALU source 1: register
                alusel2     =   1'b0;   //ALU source 2: register
            end
        endcase
    end

    //-----------------------------For Debug---------------------------------
    
    `ifdef DEBUG
        always @(*) begin 
            $display("instr: %b", instr);
            $display("Destination Register:%b", rd);
            $display("Source Register: %b", rs1);
            $display("Source Register: %b", rs2);
            $display("Func3 : %b", func3);
        end  
    `endif

endmodule 