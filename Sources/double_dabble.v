`timescale 1ns / 1ps


module double_dabble (

    input [7:0] num_in,
    output reg [11:0] bcd_out

);

integer i;

always @(*)
begin

    for (i = 0; i <= 7; i = i + 1)
    begin

        if (bcd_out[3:0] >= 5)
            bcd_out[3:0] = bcd_out[3:0] + 3;

        if (bcd_out[7:4] >= 5) 
            bcd_out[7:4] = bcd_out[7:4] + 3;

        if (bcd_out[11:8] >= 5) 
            bcd_out[11:8] = bcd_out[11:8] + 3;

        bcd_out = {bcd_out[10:0], num_in[7-i]}; 
    end

end
endmodule
