`timescale 1ns / 1ps

// Generates a new key for the next round of encryption
module keySchedule(
    input clk,
    // binary encoded value of the round of encryption
    input [3:0] round,
    input [127:0] in,
    output reg [127:0] out
    );
    
    // connects the sub-modules of the key schedule
    wire [31:0] rw_sw;
    wire [31:0] sw_rc;
    wire [31:0] rc_x0;
    
    // connects the add (xor) operations
    wire [31:0] x0_x1;
    wire [31:0] x1_x2;
    wire [31:0] x2_x3;
    
    rotateWord rw(in[31:0], rw_sw);
    subWord sw(rw_sw, sw_rc);
    roundConstant rc(round, sw_rc, rc_x0);
    
    assign x0_x1 = rc_x0 ^ in[127:96];
    assign x1_x2 = x0_x1 ^ in[95:64];
    assign x2_x3 = x1_x2 ^ in[63:32];
    
    always @(posedge clk) begin
        if (round != 11) begin
            out[127:96] <= x0_x1;
            out[95:64] <= x1_x2;
            out[63:32] <= x2_x3;
            out[31:0] <= x2_x3 ^ in[31:0];
        end
    end
    
endmodule
