`timescale 1ns / 1ps

// Multiplies the matrix [2,3,1,1;1,2,3,1;1,1,2,3;3,1,1,2] by the input as a 4x4 matrix of bytes
module mixColumns(
    input ctrl,
    input [127:0] in,
    output [127:0] out
    );
    
    wire [127:0] result;
    
    function [7:0] mult2;
        input [7:0] n;
        begin
            // multiplication by 2 = left shift of 1 bit, subtract 1b if value exceeds 8 bits
            mult2 = n[7] ? n << 1 ^ 8'h1b : {n[6:0], 1'b0};
        end
    endfunction
    
    function [7:0] mult3;
        input [7:0] n;
        begin
            // multiplication by 3 = multiplication by 2, plus n
            mult3 = mult2(n) ^ n;
        end
    endfunction
    
    // row of transformation, col of state
    genvar row, col;
    generate
        for (col = 0; col < 4; col = col + 1) begin
            localparam cm = col*32;
            for (row = 0; row < 4; row = row + 1) begin
                localparam rm = row*8;
                assign result[127 - (cm+rm) -: 8] 
                = mult2(in[127 - (cm+rm) -: 8]) 
                ^ mult3(in[127 - (cm+(rm+8)%32) -: 8]) 
                ^       in[127 - (cm+(rm+16)%32) -: 8] 
                ^       in[127 - (cm+(rm+24)%32) -: 8];
            end
        end
    endgenerate
    
    // module does nothing if ctrl is 0
    assign out = ctrl ? result : in;
    
endmodule
