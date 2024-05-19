`timescale 1ns / 1ps
   
module button_pulse(
		    input clk,
		    input raw_button,
		    output button_pulse
		    );
    
    localparam N = 3;
    
    reg [N - 1:0] Q_reg;
    
    always @(posedge clk)
    begin
        Q_reg <= {Q_reg[N - 2:0], raw_button};
    end

	// only sends a pulse after 2 clock cycles of raw_button == 1
	// if Q_reg[2:0] == 3'b111 then button_pulse = 0;
    assign button_pulse = (&Q_reg[N - 2:0]) & ~Q_reg[N-1];
endmodule
