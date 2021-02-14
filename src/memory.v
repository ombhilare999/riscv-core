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
            //Add (00104083)
            memory [0] = 32'h002081B3;  //func7_rs2_rs1_func3_rd_opcode
            memory [1] = 32'd0;
            memory [2] = 32'd2;
            //Subtract
            memory [4] = 32'h402081B3;  //func7_rs2_rs1_func3_rd_opcode
        /*    $display("Zeroth Location   :: %b", memory[0]);
            $display("First Location    :: %b", memory[1]);
            $display("Second Location   :: %b", memory[2]);
            $display("Fourth Location   :: %b", memory[4]);*/
        end
    `endif
endmodule