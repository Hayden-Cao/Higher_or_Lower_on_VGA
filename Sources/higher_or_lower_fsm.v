`timescale 1ns/1ps

module higher_or_lower_fsm (

    input clk, reset, higher_btn, lower_btn, confirm_btn,
    output reg [2:0] rgb_led,
    output reg [2:0] state,
    output reg [7:0] rand_num, counter, temp_rand_num
    
);

    localparam Idle = 0;
    localparam Guess = 1;
    localparam Get_Next = 2;
    localparam Check_Next = 3;
    localparam Results = 4;
    

    wire [7:0] i_rand;
    // 3 bits of rgb will be for the red, green, and blue bits, respectively, of the onboard RGB led
    reg [2:0] next_rgb_led = 0;
    reg [2:0] next_state = Idle;
    reg [7:0] next_rand_num = 0, next_temp_rand_num = 0;
    reg [7:0] next_counter = 0;
    reg rng_enb = 0;
    reg [1:0] guess;
    reg [1:0] next_guess; //

    rand_num_gen rng1 (

        .clk(clk),
        .reset(reset),
        .enable(rng_enb),
        .o_rand(i_rand)

    );

    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            state <= Idle;
            rgb_led <= 3'b000;
            rand_num <= 0;
            counter <= 0;
            temp_rand_num <= 0;
            guess <= 0;
        end
        else 
        begin
            state <= next_state;
            rgb_led <= next_rgb_led;
            rand_num <= next_rand_num;
            temp_rand_num <= next_temp_rand_num;
            counter <= next_counter;
            guess <= next_guess;
        end
    end

    always @(*)
    begin

        // default to keeping the same values 
        next_state = state;
        next_rgb_led = rgb_led;
        next_rand_num = rand_num;
        next_counter = counter;
        next_temp_rand_num = temp_rand_num;
        next_guess = guess;

        case(state)

            Idle:
            begin
                next_counter = 0;
                next_rand_num = 0;
                next_temp_rand_num = 0;
                next_guess = 2'b00;
                next_rgb_led = 3'b001; // blue
                rng_enb = 1;
                next_guess = 2'b00;
                if(confirm_btn)
                    next_state = Guess;

            end

            Guess:
            begin
                next_rand_num = i_rand;
                rng_enb = 0;
                next_rgb_led = 3'b111; // white
                if (higher_btn)
                begin
                    next_state = Get_Next;
                    next_guess = 2'b10;
                    rng_enb = 1;
                end else if (lower_btn)
                begin
                    next_state = Get_Next;
                    next_guess = 2'b01;
                    rng_enb = 1;
                end

            end

            Get_Next:
            begin
                next_temp_rand_num = i_rand;
                next_state = Check_Next;
                rng_enb = 0;
            end

            Check_Next:
            begin
                rng_enb = 0;
                if (((rand_num <= temp_rand_num) && guess[1]) || ((rand_num >= temp_rand_num) && guess[0]))
                begin
                    next_counter = counter + 1;
                    next_state = Guess;
                end 
                else
                begin
                    next_state = Results;
                end
                
            end

            Results:
            begin
                next_rgb_led = 3'b100; // red

                rng_enb = 1; // lets the random number gen cycle through the list of numbers for 5 seconds
                
                if(confirm_btn)
                begin
                    next_state = Idle;
                end
              
            end 

            default:
            begin
                next_state = Idle;
                rng_enb = 0;
            end
        endcase


    end
endmodule