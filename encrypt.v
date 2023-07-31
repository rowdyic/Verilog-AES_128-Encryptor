`timescale 1ns / 1ps

// Encryption module for AES-128 encryption. The module can be written to on the negative edge of clk,
// The resulting cipher is outputted on the positive edge of clk ~10 clock cycles later, 
// cipher_ready will output 1 to notify that encryption is complete.
module encrypt(
    input clk,
    input enable_input,
    input [127:0] data,
    input [127:0] key,
    output reg cipher_ready,
    output reg [127:0] cipher
    );
    
    reg [3:0] round_reg;
    reg [127:0] data_reg;
    reg [127:0] key_reg;
    
    always @(negedge clk) begin
        if(enable_input) begin
            round_reg <= 4'b0;
            data_reg <= data;
            key_reg <= key;
            cipher_ready <= 1'b0;
        end
        else begin
            // encryption is complete after the 10th round
            cipher_ready <= (round_reg == 4'd10);
            // encryptRound and keySchedule are deactivated when round = 11
            if (round_reg != 4'd11) round_reg <= round_reg + 1'b1;
        end
    end
    
    wire [127:0] data_mux;
    wire [127:0] key_mux;
    wire [127:0] er_out;
    wire [127:0] ks_out;
    
    encryptRound er(clk, round_reg, key_mux, data_mux, er_out);
    keySchedule ks(clk, round_reg, key_mux, ks_out);
    
    assign data_mux = enable_input ? data_reg : er_out;
    assign key_mux = enable_input ? key_reg : ks_out;
    
    always @(posedge cipher_ready) cipher <= er_out;
    
endmodule
