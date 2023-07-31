`timescale 1ns / 1ps

// Passes each byte of the input through an s-box 
module subBytes(
    input ctrl,
    input [127:0] in,
    output [127:0] out
    );
    
    wire [127:0] result;
    
    genvar i;
    generate
        // 16 s-tables to substitute 16 8-bit inputs
        for (i = 0; i < 128; i = i + 8) begin
            sTable s_table(in[i +: 8], result[i +: 8]);
        end
    endgenerate
    
    // module does nothing if ctrl is 0
    assign out = ctrl ? result : in;
    
endmodule
