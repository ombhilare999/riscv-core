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
            memory [0] = 32'h002081B3;  //Add
            memory [1] = 32'h402081B3;  //Subtract
            memory [2] = 32'h00108213;  //Addi
            //memory [2] = 32'h002091B3;  //sll
            //memory [3] = 32'h0020A1B3;  //slt
            //memory [4] = 32'h0020B1B3;  //sltu
            //memory [5] = 32'h0020C1B3;  //xor
            //memory [6] = 32'h0020D1B3;  //srl
            //memory [7] = 32'h4020D1B3;  //sra
            //memory [8] = 32'h0020E1B3;  //or 
            //memory [9] = 32'h0020F1B3;  //and
        end
    `endif
endmodule