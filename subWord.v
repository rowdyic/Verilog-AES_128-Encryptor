`timescale 1ns / 1ps

// passes each byte of the input through an s-box LUT
module subWord(
    input [31:0] in,
    output [31:0] out
    );
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i+8) begin
            sTable st(in[i +: 8], out[i +: 8]);
        end
    endgenerate
    
endmodule
