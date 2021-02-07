//Verilog Code of Register File

module register_file 
(     
    input clock,              //Clock for register 
    input read1,              //5 Bit address of register 1
    input read2,              //5 Bit address of register 2
    input writereg,           //5 Bit Write Register Address 
    input writedata,          //32 Bit data for write Register
    input regwrite,           //Control Signal for regwrite
    output data1,             //Data 1 from register 1 
    output data2              //Data 2 from register 2
);
    reg [31:0] RF [31:0];                       //32 Registers each 32 bits long

    assign data1 = RF[read1];
    assign data2 = RF[read2];

    always@(posedge clock)
    begin
        if(regwrite) begin
            if(writereg != 0) begin 
                RF[writereg] <= writedata;
        end
    end              
endmodule