`timescale 1ns / 1ps

// Outputs the bitwise XOR of the input with the round constant of the next round
module roundConstant(
    input [3:0] round,
    input [31:0] in,
    output [31:0] out
    );
    
    reg [7:0] constants [0:9];
    
    initial begin
        $readmemh("round_constants.mem", constants);
    end
    
    assign out[31:24] = in[31:24] ^ constants[round];
    // last 3 bytes are unchanged (last 3 bytes of round constant are always 0 for AES-128)
    assign out[23:0] = in[23:0];
    
endmodule
