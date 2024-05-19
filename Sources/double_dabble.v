`timescale 1ns / 1ps


module double_dabble (

    input [7:0] num_in,
    output reg [11:0] bcd_out

);

    integer i; 
    
    always @(num_in)
    begin
        bcd_out = 0;
        for(i = 0; i < 8; i = i + 1)
        begin

            bcd_out = {bcd_out[10:0], num_in[7-i]};

            if (i < 7 && bcd_out[3:0] > 4)
                bcd_out[3:0] = bcd_out[3:0] + 3;

             if (i < 7 && bcd_out[7:4] > 4)
                bcd_out[7:4] = bcd_out[7:4] + 3;   
            
             if (i < 7 && bcd_out[11:8] > 4)
                bcd_out[11:8] = bcd_out[11:8] + 3;

        end

    end

endmodule