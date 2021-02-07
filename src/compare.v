///////////////////////////////////////////
// Module compare.v                                            
// Info:  Verilog Code for Compare
//        Cpmpares two Input to Alu for 
//        for Branch Instructions
///////////////////////////////////////////

module compare
(
    input [31:0] in1,
    input [31:0] in2,
    input [2:0]   op,
    output reg out
)
    always @(*) begin
        case(op)
            3'b000:  out = (in1 == in2);                        // BEQ
            3'b001:  out = (in1 != in2);                        // BNE
            3'b100:  out = ($signed(in1) < $signed(in2));       // BLT
            3'b101:  out = ($signed(in1) >= $signed(in2));      // BGE
            3'b110:  out = (in1 < in2);                         // BLTU
            3'b111:  out = (in1 >= in2);                        // BGEU
            default: out = 1'bx;                                // Default - Dont Care
        endcase
    end

endmodule