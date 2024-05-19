`timescale 1ns / 1ps

module vga_game(

    input clk, reset, higher_btn, lower_btn, confirm_btn,
    output [2:0] rgb_led, state, 
    output o_hsync, o_vsync,
    output [3:0] o_red, o_green, o_blue,
    output [7:0] counter

    );
    
    wire [2:0] fsm_state;
    wire higher_btn_debounce, lower_btn_debounce;
    wire [7:0] i_counter, i_rand_num, i_temp_rand_num;
    wire [11:0] bcd_rand_num, bcd_temp_num, bcd_counter;
    
    assign counter = i_counter;
    assign state = fsm_state;
    
    button_pulse bp_0 (
        
        .clk(clk),
        .raw_button(higher_btn),
        .button_pulse(higher_btn_debounce)
        
    );
        
    button_pulse bp_1 (
        
        .clk(clk),
        .raw_button(lower_btn),
        .button_pulse(lower_btn_debounce)
        
    );
    
    double_dabble dd1 (
    
        .num_in(i_rand_num),
        .bcd_out(bcd_rand_num)
    
    );
    
    double_dabble dd2 (
    
        .num_in(i_temp_rand_num),
        .bcd_out(bcd_temp_num)
    
    );
    
    double_dabble dd3 (
    
        .num_in(i_counter),
        .bcd_out(bcd_counter)
    
    );
    
    higher_or_lower_fsm hol_fsm1 (
    
        .clk(clk),
        .reset(reset),
        .higher_btn(higher_btn_debounce),
        .lower_btn(lower_btn_debounce),
        .confirm_btn(confirm_btn),
        .rgb_led(rgb_led),
        .state(fsm_state),
        .rand_num(i_rand_num),
        .counter(i_counter),
        .temp_rand_num(i_temp_rand_num)
    
    );
    
    vga_driver vga_driver1 (
        
        .clk_100MHz(clk),
        .fsm_state(fsm_state),
        .bcd_rand_num(bcd_rand_num),
        .bcd_temp_rand_num(bcd_temp_num),
        .bcd_counter(bcd_counter),
        .o_hsync(o_hsync),
        .o_vsync(o_vsync),
        .o_red(o_red),
        .o_green(o_green),
        .o_blue(o_blue)
        
    );
    
    
    
endmodule
