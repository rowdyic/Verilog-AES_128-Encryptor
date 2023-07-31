`timescale 1ns / 1ps

// Bitwise XOR the input with the key
module addRoundKey(
    input [127:0] key,
    input [127:0] in,
    output [127:0] out
    );
    
    assign out = in ^ key;
    
endmodule
