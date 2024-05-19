`timescale 1ns/1ps

module vga_driver
    #(parameter HORZ_RES = 640, 
    parameter VERT_RES = 480, 
    parameter H_FRONT_PORCH = 16, 
    parameter H_SYNC_PULSE = 96, 
    parameter H_BACK_PORCH = 48, 
    parameter H_TOTAL = 800, 
    parameter V_FRONT_PORCH = 10, 
    parameter V_SYNC_PULSE = 2, 
    parameter V_BACK_PORCH = 33, 
    parameter V_TOTAL = 525) 
    (
        input clk_100MHz, 
        input [2:0] fsm_state,
        input [11:0] bcd_rand_num, bcd_temp_rand_num, bcd_counter,
        output o_hsync, o_vsync,
        output [3:0] o_red, o_green, o_blue
    );

    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;
    wire clk_25MHz;
    
    clk_25MHz_divider clk_25 (

        .clk(clk_100MHz),
        .reset(0),
        .clk_25MHz_o(clk_25MHz)
    );

    always@(posedge clk_25MHz)
    begin

        if (h_counter < H_TOTAL - 1)
        begin
            h_counter <= h_counter + 1;
        end 
        else 
        begin
            h_counter <= 0;

            if(v_counter < V_TOTAL - 1)
            begin
                v_counter <= v_counter + 1;
            end else
            begin
                v_counter <= 0;
            end
        end

    end
    
    // hsync and vsync are low during their sync pulse periods
    assign o_hsync = ((h_counter > (HORZ_RES + H_FRONT_PORCH)) && (h_counter < (H_TOTAL - H_BACK_PORCH))) ? 0 : 1; 
    assign o_vsync = ((v_counter > (VERT_RES + V_FRONT_PORCH)) && (v_counter < (V_TOTAL - V_BACK_PORCH))) ? 0 : 1; 

    // PATTERN GENERATION

    localparam Idle = 0;
    localparam Game_Start = 1;
    localparam Game_Over = 2;


    reg [3:0] i_red = 0, i_green = 0, i_blue = 0;
    reg [3:0] next_red = 0, next_green = 0, next_blue = 0;
    reg [2:0] state = Idle;

    reg num_enb;
    reg [9:0] h_size = 0, h_start = 0, v_size = 0, v_start = 0; 
    reg [3:0] bcd = 0;
    wire [3:0] num_red, num_green, num_blue;

    vga_num_gen vga_num1 (
            .enable(num_enb),
            .clk(clk_100MHz),
            .h_size(h_size),
            .h_start(h_start),
            .v_size(v_size),
            .v_start(v_start),
            .bcd(bcd),
            .o_red(num_red),
            .o_green(num_green),
            .o_blue(num_blue),
            .h_counter(h_counter),
            .v_counter(v_counter)
        );

    always@(posedge clk_100MHz)
    begin
        
        if (fsm_state == 0)
            state <= Idle;
        else if (fsm_state >= 1 && fsm_state <= 3)
            state <= Game_Start;
        else 
        
        state <= Game_Over;
        i_red <= next_red;
        i_green <= next_green;
        i_blue <= next_blue;
        
    end

    always @(*)
    begin
        next_red = i_red;
        next_green = i_green;
        next_blue = i_blue;
        num_enb = 0;
        h_size = 0;
        v_size = 0;
        h_start = 0;
        v_start = 0;
        bcd = 0;
        case(state)

            Idle:
            begin
                if(h_counter < HORZ_RES && v_counter < VERT_RES)
                begin
                    // top left box
                    if (h_counter >= 100 && h_counter <= 200 && v_counter >= 50 && v_counter <= 150)
                    begin
                        if(h_counter == 100 || h_counter == 200)
                        begin
                            if(v_counter >= 50 && v_counter <= 150)
                            begin
                                next_red = 0;
                                next_green = 0;
                                next_blue = 0;
                            end
                        end 
                        else if(v_counter == 50 || v_counter == 150)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end
                        // h_start - 1 to allow enable to happen
                        else if(h_counter >= 110-1 && h_counter <= 130+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 110;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[11:8];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 140-1 && h_counter <= 160+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 140;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[7:4];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 170-1 && h_counter <= 190+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 170;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[3:0];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else 
                        begin
                            next_red = 4'hF;
                            next_blue = 4'hF;
                            next_green = 4'hF;
                        end
                    end

                    // large center box

                    else if ((h_counter >= 220 && h_counter <= 420) && (v_counter >= 175 && v_counter <= 275))
                    begin
                        if (h_counter == 220 || h_counter == 420)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (v_counter == 175 || v_counter == 275)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        
                        
                        else if(h_counter >= 250-1 && h_counter <= 290+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 250;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_rand_num[11:8];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 300-1 && h_counter <= 340+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 300;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_rand_num[7:4];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 350-1 && h_counter <= 390+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 350;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_rand_num[3:0];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        
                        else
                        begin
                            next_red = 4'hF;
                            next_blue = 4'hF;
                            next_green = 4'hF;
                        end
                    end
                    // smaller center confirm box
                    else if (h_counter >= 270 && h_counter <= 370 && v_counter >= 300 && v_counter <= 400)
                    begin
                        if(h_counter == 270 || h_counter == 370)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (v_counter == 300 || v_counter == 400)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (h_counter >= 290 && h_counter <= 350 && v_counter >= 320 && v_counter <= 380)
                        begin
                            if (v_counter == 320)
                            begin
                                next_green = 4'hF;
                                next_red = 0;
                                next_blue = 0;
                            end 
                            else if (v_counter == 380)
                            begin
                                next_green = 4'hF;
                                next_red = 0;
                                next_blue = 0;
                            end 
                            else if (h_counter == 290)
                            begin
                                next_green = 4'hF;
                                next_red = 0;
                                next_blue = 0;
                            end 
                            else
                            begin
                                next_red = 4'hF;
                                next_green = 4'hF;
                                next_blue = 4'hF;
                            end
                        end
                        else 
                        begin
                            next_red = 4'hF;
                            next_green = 4'hF;
                            next_blue = 4'hF;
                        end
                    end
                    else 
                    begin
                        next_red = 4'hF;
                        next_green = 4'hF;
                        next_blue = 4'hF;
                    end
                end
                else 
                begin
                    next_red = 0;
                    next_green = 0;
                    next_blue = 0;
                end
            end

            Game_Start:
            begin
            
            
                if(h_counter < HORZ_RES && v_counter < VERT_RES)
                begin
                    // top left box
                    if (h_counter >= 100 && h_counter <= 200 && v_counter >= 50 && v_counter <= 150)
                    begin
                        if(h_counter == 100 || h_counter == 200)
                        begin
                            if(v_counter >= 50 && v_counter <= 150)
                            begin
                                next_red = 0;
                                next_green = 0;
                                next_blue = 0;
                            end
                        end 
                        else if(v_counter == 50 || v_counter == 150)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end
                        // h_start - 1 to allow enable to happen
                        else if(h_counter >= 110-1 && h_counter <= 130+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 110;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[11:8];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 140-1 && h_counter <= 160+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 140;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[7:4];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 170-1 && h_counter <= 190+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 170;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[3:0];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else 
                        begin
                            next_red = 4'hF;
                            next_blue = 4'hF;
                            next_green = 4'hF;
                        end
                    end

                    // large center box

                    else if ((h_counter >= 220 && h_counter <= 420) && (v_counter >= 175 && v_counter <= 275))
                    begin
                        if (h_counter == 220 || h_counter == 420)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (v_counter == 175 || v_counter == 275)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        
                        
                        else if(h_counter >= 250-1 && h_counter <= 290+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 250;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_rand_num[11:8];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 300-1 && h_counter <= 340+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 300;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_rand_num[7:4];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 350-1 && h_counter <= 390+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 350;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_rand_num[3:0];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        
                        else
                        begin
                            next_red = 4'hF;
                            next_blue = 4'hF;
                            next_green = 4'hF;
                        end
                    end


                    // H button Box
                    else if (h_counter >= 120 && h_counter <= 220 && v_counter >= 300 && v_counter <= 400)
                    begin
                        if(h_counter == 120 || h_counter == 220)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (v_counter == 300 || v_counter == 400)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (h_counter >= 140 && h_counter <= 200 && v_counter >= 320 && v_counter <= 380)
                        begin
                            if (v_counter == 350)
                            begin
                                next_green = 0;
                                next_red = 0;
                                next_blue = 4'hF;
                            end 
                            else if (h_counter == 140 || h_counter == 200)
                            begin
                                next_green = 0;
                                next_red = 0;
                                next_blue = 4'hF;
                            end 
                            else
                            begin
                                next_red = 4'hF;
                                next_green = 4'hF;
                                next_blue = 4'hF;
                            end
                        end
                        else 
                        begin
                            next_red = 4'hF;
                            next_green = 4'hF;
                            next_blue = 4'hF;
                        end
                    end


                    // L button Box
                    else if (h_counter >= 420 && h_counter <= 520 && v_counter >= 300 && v_counter <= 400)
                        begin
                            if(h_counter == 420 || h_counter == 520)
                            begin
                                next_red = 0;
                                next_green = 0;
                                next_blue = 0;
                            end 
                            else if (v_counter == 300 || v_counter == 400)
                            begin
                                next_red = 0;
                                next_green = 0;
                                next_blue = 0;
                            end 
                            else if (h_counter >= 440 && h_counter <= 500 && v_counter >= 320 && v_counter <= 380)
                            begin
                                if (v_counter == 380 && h_counter <= 470)
                                begin
                                    next_green = 0;
                                    next_red = 0;
                                    next_blue = 4'hF;
                                end 
                                else if (h_counter == 440)
                                begin
                                    next_green = 0;
                                    next_red = 0;
                                    next_blue = 4'hF;
                                end 
                                else
                                begin
                                    next_red = 4'hF;
                                    next_green = 4'hF;
                                    next_blue = 4'hF;
                                end
                            end
                            else 
                            begin
                                next_red = 4'hF;
                                next_green = 4'hF;
                                next_blue = 4'hF;
                            end
                        end
                    else 
                    begin
                        next_red = 4'hA;
                        next_green = 4'h2;
                        next_blue = 4'hE;
                    end
                end
                else 
                begin
                    next_red = 0;
                    next_green = 0;
                    next_blue = 0;
                end
            end

            Game_Over:
            begin
            
             if(h_counter < HORZ_RES && v_counter < VERT_RES)
                begin
                    // top left box
                    if (h_counter >= 100 && h_counter <= 200 && v_counter >= 50 && v_counter <= 150)
                    begin
                        if(h_counter == 100 || h_counter == 200)
                        begin
                            if(v_counter >= 50 && v_counter <= 150)
                            begin
                                next_red = 0;
                                next_green = 0;
                                next_blue = 0;
                            end
                        end 
                        else if(v_counter == 50 || v_counter == 150)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end
                        // h_start - 1 to allow enable to happen
                        else if(h_counter >= 110-1 && h_counter <= 130+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 110;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[11:8];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 140-1 && h_counter <= 160+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 140;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[7:4];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 170-1 && h_counter <= 190+1 && v_counter >= 60 && v_counter <= 140)
                        begin
                            num_enb = 1;
                            h_size = 20;
                            h_start = 170;
                            v_start = 60;
                            v_size = 80;
                            bcd = bcd_counter[3:0];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else 
                        begin
                            next_red = 4'hF;
                            next_blue = 4'hF;
                            next_green = 4'hF;
                        end
                    end

                    // large center box

                    else if ((h_counter >= 220 && h_counter <= 420) && (v_counter >= 175 && v_counter <= 275))
                    begin
                        if (h_counter == 220 || h_counter == 420)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (v_counter == 175 || v_counter == 275)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        
                        
                        else if(h_counter >= 250-1 && h_counter <= 290+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 250;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_temp_rand_num[11:8];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 300-1 && h_counter <= 340+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 300;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_temp_rand_num[7:4];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        else if(h_counter >= 350-1 && h_counter <= 390+1 && v_counter >= 185 && v_counter <= 265)
                        begin
                            num_enb = 1;
                            h_size = 40;
                            h_start = 350;
                            v_start = 185;
                            v_size = 80;
                            bcd = bcd_temp_rand_num[3:0];
                            next_red = num_red;
                            next_green = num_green;
                            next_blue = num_blue;
                        end
                        
                        else
                        begin
                            next_red = 4'hF;
                            next_blue = 4'hF;
                            next_green = 4'hF;
                        end
                    end
                    // smaller center confirm box
                    else if (h_counter >= 270 && h_counter <= 370 && v_counter >= 300 && v_counter <= 400)
                    begin
                        if(h_counter == 270 || h_counter == 370)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (v_counter == 300 || v_counter == 400)
                        begin
                            next_red = 0;
                            next_green = 0;
                            next_blue = 0;
                        end 
                        else if (h_counter >= 290 && h_counter <= 350 && v_counter >= 320 && v_counter <= 380)
                        begin
                            if (v_counter == 320)
                            begin
                                next_green = 4'hF;
                                next_red = 0;
                                next_blue = 0;
                            end 
                            else if (v_counter == 380)
                            begin
                                next_green = 4'hF;
                                next_red = 0;
                                next_blue = 0;
                            end 
                            else if (h_counter == 290)
                            begin
                                next_green = 4'hF;
                                next_red = 0;
                                next_blue = 0;
                            end 
                            else
                            begin
                                next_red = 4'hF;
                                next_green = 4'hF;
                                next_blue = 4'hF;
                            end
                        end
                        else 
                        begin
                            next_red = 4'hF;
                            next_green = 4'hF;
                            next_blue = 4'hF;
                        end
                    end
                    else 
                    begin
                        next_red = 4'hF;
                        next_green = 0;
                        next_blue = 0;
                    end
                end
                else 
                begin
                    next_red = 0;
                    next_green = 0;
                    next_blue = 0;
                end
            end
            
            default ;

        endcase


    end

    assign o_red = i_red;
    assign o_blue = i_blue;
    assign o_green = i_green;

endmodule