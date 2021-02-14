///////////////////////////////////////////
// Module alu.v                                            
// Info:  Verilog Code for ALU
//        Covers All R - Type Instructions 
///////////////////////////////////////////

module alu
(   
    input        clk,
    input [31:0] in1,
    input [31:0] in2,
    input [2:0] func3,    // Control Signal op: [14:12]
    input      opequal,   // Operation Qualification (+/-, Logical/Arithmetic)
    output reg [31:0] out // ALU result
);
    always@(posedge clk) begin
        case(func3)
            3'b000: out = opequal ? in1 - in2 : in1 + in2;                        // ADD/SUB
            3'b010: out = ($signed(in1) < $signed(in2)) ? 32'b1 : 32'b0;          // SLT
            3'b011: out = (in1 < in2) ? 32'b1 : 32'b0;                            // SLTU
            3'b100: out = in1 ^ in2;                                              // XOR
            3'b110: out = in1 | in2;                                              // OR
            3'b111: out = in1 & in2;                                              // AND
            3'b001: out = in1 << in2[4:0];                                        // SLL
            3'b101: out =  $signed({opequal ? in1[31] : 1'b0, in1}) >>> in2[4:0]; // SRL/SRA
        endcase
    end
endmodule 