`timescale 1ns / 1ps

module encryptRound(
    input clk,
    // binary encoded value of the round of encryption
    input [3:0] round,
    input [127:0] key,
    input [127:0] in,
    output reg [127:0] out
    );
    
    // Controls whether the operation is performed (1) or the input value is passed through (0)
    wire notRdZr = round != 0;    
    wire subEn = notRdZr;
    wire shiftEn = notRdZr;
    wire mixEn = notRdZr && round != 4'd10;
    
    wire [127:0] sb_sr;
    wire [127:0] sr_mc;
    wire [127:0] mc_ark;
    wire [127:0] ark_out;
    
    // input -> subBytes -> shiftRows -> mixColumns -> addRoundKey -> output
    subBytes sb(subEn, in, sb_sr);
    shiftRows sr(shiftEn, sb_sr, sr_mc);
    mixColumns mc(mixEn, sr_mc, mc_ark);
    addRoundKey ark(key, mc_ark, ark_out);
    
    always @(posedge clk) begin
        if (round != 11) out <= ark_out;
    end
    
endmodule