`timescale 1ns / 1ps

// LUT for the Rijndael S-box
module sTable(
    input [7:0] in,
    output [7:0] out
    );
    
    reg [7:0] s_table [0:255];
    
    initial begin
        $readmemh("s_table.mem", s_table);
    end
    
    assign out = s_table[in];
    
endmodule
