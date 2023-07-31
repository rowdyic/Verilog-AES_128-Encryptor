`timescale 1ns / 1ps

// Rotates each row left by its row index in bytes (e.g. row 2 is rotated 2 bytes left)
module shiftRows(
    input ctrl,
    input [127:0] in,
    output [127:0] out
    );
    
    wire [127:0] result;
    
    genvar row;
    genvar col;
    
    generate
        for (row = 0; row < 4; row = row + 1) begin
            localparam rm = row*8;
            for (col = 0; col < 4; col = col + 1) begin
                localparam cm = col*32;
                assign result[127-(cm+rm) -: 8] 
                // addition by 128 is needed because verilog does not mod by negative numbers correctly
                = in[127-(cm+row*32+rm+128)%128 -: 8];
            end
        end
    endgenerate
    
    // module does nothing if ctrl is 0
    assign out = ctrl ? result : in;
    
endmodule
