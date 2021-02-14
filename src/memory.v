/////////////////////////////////////////////////////////////////////////
// Module memory.v   
//                                         
// Info:  Verilog Code for memory
////////////////////////////////////////////////////////////////////////

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
endmodule