/////////////////////////////////////////////////////////////////////////
// Module rv32_soc.v   
//                                         
// Info:  Verilog Code for rv32 soc 
//        (For R type instructions)
//  
////////////////////////////////////////////////////////////////////////

`include "rv32.v"                   
`include "memory.v"                   

module rv32_soc();

wire clk;
wire reset;
wire [31:0] i_data, o_data;
wire mem_wr, mem_rd;
wire [31:0] PC;

memory ram
(
    .clk(clk),          //Clock
    .PC(PC),            //Address
    .rd(mem_rd),        //read signal
    .wr(mem_wr),        //write signal
    .i_data(o_data),    //Input Data
    .o_data(i_data)     //Output Data
);

rv32 core 
(
    .clk(clk),          //Clock
    .reset(reset),      //High to reset processor

    .in_data(i_data),   //Word Read From Memory
    .out_data(o_data),  //Word to store in memory
    .out_mem_addr(PC),  //Memory Access address

    .mem_wr(mem_wr),    //Memory Write
    .mem_rd(mem_rd)     //Memory Read
);

endmodule