///////////////////////////////////////////
// Module register_file.v                                            
// Info:  Verilog Code for register_file
//        Two Combinational Read  
//        One clocked Write
///////////////////////////////////////////
`include "macros.v"

module register_file 
(     
    input             clock,             //Clock for register 
    input [4:0]       read1,             //5 Bit address of register 1
    input [4:0]       read2,             //5 Bit address of register 2
    input [4:0]    writereg,             //5 Bit Write Register Address 
    input [31:0]  writedata,             //32 Bit data for write Register
    input              inEn,             //Control Signal for regwrite

    output     [31:0] data1,             //Data 1 from register 1 
    output     [31:0] data2              //Data 2 from register 2
);
    reg [31:0] RF [31:0];                //32 Registers each 32 bits long

    assign data1 = RF[read1];            //This Requires more BRAM resulting in more LUTs
    assign data2 = RF[read2];            //BRAM is slower, one solution two banks and simultaneous write

    always@(posedge clock)
    begin
        if(inEn) begin
            if(writereg != 0) begin 
                RF[writereg] <= writedata;
            end
        end
    end 

    //-----------------------------For Debug---------------------------------
    
    `ifdef DEBUG
        integer i;

        initial begin
        RF[0] <= 32'h0000_0000;
        RF[3] <= 32'h0000_0005;
        RF[4] <= 32'h0000_0003;
        end

        always @(*) begin 
            $display("");
            $display("");
            $display("Write Data: %d",writedata);
            $display("Write reg:  %d",writereg);
            $display("REGISTER FILE:");
            for(i = 0; i<32; i++) begin 
                $display("R[%d]     ::      %d", i, RF[i]);
            end
            $display("\n\n");
        end  
    `endif
endmodule