`timescale 1ns / 1ps

module vga_num_gen(

    input enable, clk,
    input [9:0] h_size, v_size, h_start, v_start, h_counter, v_counter,
    input [3:0] bcd,
    output reg [3:0] o_red, o_green, o_blue

    );
    
    reg [3:0] i_red = 0, i_green = 0, i_blue = 0;
    always @(posedge clk)
    begin
        o_red <= i_red;
        o_green <= i_green;
        o_blue <= i_blue;
        
    end
    
    
    always @(*) 
    begin
    
        if (enable)
        begin
        
        i_red = o_red;
        i_green = o_green;
        i_blue = o_blue;
        
        case(bcd)
        
                0:
                begin
                
                    if(((h_counter == h_size + h_start) || h_counter == h_start) && v_counter >= v_start && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if ((v_counter == v_start || (v_counter == v_start + v_size)) && (h_counter >= h_start && h_counter <= (h_start + h_size)))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else 
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF;
                    end
                    
                end
                
                1:
                begin
                
                    if(h_counter == h_size + h_start && v_counter >= v_start && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else 
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF;
                    end
                
                end
                
                2:
                begin
                
                    if (h_counter >= h_start && v_counter == v_start && h_counter <= h_start + h_size)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if (v_counter > v_start && (v_counter < (v_start + (v_size / 2))) && h_counter == h_start + h_size)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end else if (v_counter == (v_start + (v_size / 2)) && h_counter >= h_start && h_counter <= (h_start + h_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if (h_counter == h_start && (v_counter >= v_start + (v_size/2)) && v_counter <= v_start + v_size)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if(v_counter == v_start + v_size && h_counter >= h_start && h_counter <= (h_start + h_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF; 
                    end
                
                end
                
                
                3:
                begin
                
                    if(v_counter == v_start && h_counter >= h_start && h_counter <= (h_start + h_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if (h_counter == (h_start + h_size) && v_counter >= v_start && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if (h_counter >= h_start && h_counter <= (h_start + h_size) && v_counter == (v_start + (v_size/2)))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if (h_counter >= h_start && h_counter <= (h_start + h_size) && v_counter == (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else 
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF; 
                    end
                
                
                end


                4:
                begin
                
                    if (h_counter == h_start && v_counter >= v_start && v_counter <= (v_start + v_size/2))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if (h_counter >= h_start && h_counter <= (h_start + h_size) && v_counter == (v_start + (v_size/2)))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if(h_counter == h_size + h_start && v_counter >= v_start && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else 
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF;
                    end


                end
                
                5:
                begin
                
                    if ((h_counter >= h_start) && (h_counter <= (h_start + h_size)) && v_counter == v_start)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if(h_counter == h_start && (v_counter >= v_start && v_counter <= (v_start + v_size/2)))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if((h_counter >= h_start) && (h_counter <= (h_start + h_size)) && v_counter == (v_start + v_size/2))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if (h_counter == (h_start + h_size) && v_counter >= (v_start + v_size/2) && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if((h_counter >= h_start) && (h_counter <= (h_start + h_size)) && v_counter == (v_size + v_start))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF; 
                    end
                    
                    
                end


                6:
                begin
                
                    if ((h_counter >= h_start) && (h_counter <= (h_start + h_size)) && v_counter == v_start)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if (h_counter == h_start && v_counter >= v_start && v_counter <= v_start + v_size)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if((h_counter >= h_start) && (h_counter <= (h_start + h_size)) && v_counter == (v_start + v_size/2))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if (h_counter == (h_start + h_size) && v_counter >= (v_start + v_size/2) && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if((h_counter >= h_start) && (h_counter <= (h_start + h_size)) && v_counter == (v_size + v_start))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF; 
                    end

                end

                7:
                begin
                
                    if (h_counter >= h_start && v_counter == v_start && h_counter <= h_start + h_size)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if(h_counter == h_size + h_start && v_counter >= v_start && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else 
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF;
                    end

                end
                
                8:
                begin
                
                    if(((h_counter == h_size + h_start) || h_counter == h_start) && v_counter >= v_start && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if ((v_counter == v_start || (v_counter == v_start + v_size)) && (h_counter >= h_start && h_counter <= (h_start + h_size)))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if((h_counter >= h_start) && (h_counter <= (h_start + h_size)) && v_counter == (v_start + v_size/2))
                    begin
                        i_red = 0; 
                        i_green = 0;
                        i_blue = 0;
                    end
                    else 
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF;
                    end

                end

                9:
                begin
                
                    if (h_counter == h_start && v_counter >= v_start && v_counter <= (v_start + v_size/2))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if (h_counter >= h_start && h_counter <= (h_start + h_size) && v_counter == (v_start + (v_size/2)))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end 
                    else if(h_counter == h_size + h_start && v_counter >= v_start && v_counter <= (v_start + v_size))
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else if(h_counter >= h_start && h_counter <= h_start + h_size && v_counter == v_start)
                    begin
                        i_red = 0;
                        i_green = 0;
                        i_blue = 0;
                    end
                    else 
                    begin
                        i_red = 4'hF;
                        i_green = 4'hF;
                        i_blue = 4'hF;
                    end

                end
                
                default;
            
            
            endcase

        end
        else
        begin
            i_red = 4'hF;
            i_green = 4'hF;
            i_blue = 4'hF;
        end

    
    end
    
    
endmodule
