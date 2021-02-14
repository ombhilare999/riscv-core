/////////////////////////////////////////////////////////////////////////
// Module rv32_soc_TB.v   
//                                         
// Info:  Test bench code for rv32 soc
//        (For R type instructions)
//  
////////////////////////////////////////////////////////////////////////

`include "rv32_soc.v"
`timescale 1ns / 1ps

module rv32_soc_TB();

reg clock;
reg reset;

always begin
    clock = 1'b0;
    forever #5  clock = ~clock;
end

initial begin
    #5 reset = 1'b1;
    #5 reset = 1'b0;
    #100 $finish;
end

initial
begin
    $dumpfile("rv32_soc_TB.vcd");
    $dumpvars(0, rv32_soc_TB);
end


rv32_soc uut 
(
    .clk(clock),
    .reset(reset)
);

endmodule