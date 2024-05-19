`timescale 1ns/1ps

module rand_num_gen 
    #(parameter N = 8)(

    input clk, reset, enable,
    output [N-1:0] o_rand

    );

    reg [N-1 : 0] i_rand, i_rand_next;
    wire shift_in;

    always @ (posedge clk or posedge reset)
    begin
        
        if(reset)
        begin
            i_rand <= 'd1;
        end
        else if (enable)
        begin
            i_rand <= i_rand_next;
        end
        else // keeps the same value if enable is off
        begin
            i_rand <= o_rand;
        end

    end

    always @(*)
    begin
        i_rand_next = {o_rand[N-1:1], shift_in};
    end

    assign o_rand = i_rand;
    assign shift_in = o_rand[0] ^ o_rand[2] ^ o_rand[3] ^ o_rand[4];


endmodule