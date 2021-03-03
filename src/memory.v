/////////////////////////////////////////////////////////////////////////
// Module memory.v   
//                                         
// Info:  Verilog Code for memory
////////////////////////////////////////////////////////////////////////
`include "macros.v"

module memory
(
    input                 clk,
    input  [31:0]          PC,
    input                  rd,    //read signal
    input                  wr,    //write signal
    input  [31:0]      i_data,    //Input Data
    output reg [31:0]  o_data     //Output Data
);

    reg [31:0] memory [15:0];

    always@(posedge clk) begin
        if (wr) begin
            memory[PC] <= i_data;
        end      
        if (rd) begin
            o_data <= memory[PC];
        end 
    end

    //-----------------------------For Debug---------------------------------
    
    `ifdef DEBUG
        initial begin
            memory [0] = 32'h66618213;           //addi	tp,gp,1638
            memory [1] = 32'h6661a213;           //slti	tp,gp,1638
            memory [2] = 32'h6661b213;           //sltiu tp,gp,1638
            memory [3] = 32'h6661c213;           //xori	tp,gp,1638
            memory [4] = 32'h6661e213;           //ori	tp,gp,1638
            memory [5] = 32'h6661f213;           //andi	tp,gp,1638
            memory [6] = 32'h00619213;           //slli	tp,gp,0x6
            memory [7] = 32'h0061d213;           //srli	tp,gp,0x6
            memory [8] = 32'h4061d213;           //srai	tp,gp,0x6
        end
    `endif
endmodule