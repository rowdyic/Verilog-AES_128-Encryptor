`timescale 1ns / 1ps

// Rotates the input word left by 1 byte
module rotateWord(
    input [31:0] in,
    output [31:0] out
    );
    
    assign out[7:0] = in[31:24];
    assign out[31:8] = in[23:0];
    
endmodule