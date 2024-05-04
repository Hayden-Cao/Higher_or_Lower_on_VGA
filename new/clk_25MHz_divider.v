`timescale 1ns / 1ps

module clk_25MHz_divider(
    input clk, reset,
    output clk_25MHz_o
    );
    
    reg clk_25MHz = 0;
    reg [1:0] clk_counter = 0;
    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            clk_25MHz <= 0;
            clk_counter <= 0;
        end
        else
        begin
            clk_counter <= clk_counter + 1;
            // clk_counter overflows back to 0 every 4 clk cycles
            if(clk_counter == 0)
            begin
                clk_25MHz <= 1;
            end 
            else
            begin
                clk_25MHz <= 0;
            end
        end
    end

    assign clk_25MHz_o = clk_25MHz;

endmodule