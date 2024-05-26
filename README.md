# Higher_or_Lower_on_VGA

VGA Driver for a Higher or Lower Number Guessing Game. Implemented on a Nexys A7-100T FPGA development board

**VGA Driver Demonstration**

To View click on the Image to open the Youtube Link

[![IMAGE ALT TEXT](http://img.youtube.com/vi/zv1wZgNr_dA/0.jpg)](http://www.youtube.com/watch?v=zv1wZgNr_dA) 

**Overview**

This project is focused on creating a VGA video that changes with user input to provide a display for a Higher or Lower Number Guessing Game. To complete this project we need to follow the VGA standard for a 640 x 480 display @60Hz refresh rate.

I obtained information about the VGA standard from this website: http://tinyvga.com/vga-timing/640x480@60Hz 


I created a pseudo-random number generator by using an 8-bit linear feedback shift register (LFSR) . I followed a design provided by Xlinx to get information on which taps to XOR together to create the bit that is continously shifted in.

Link to Xlinx Document: https://docs.amd.com/v/u/en-US/xapp052

The double dabble algorithm is used to create BCD numbers from the LSFR and score counter from the internal finite state machine that controls the game logic. The BCD numbers are then input into a vga_num_gen module that will take the BCD input and display the number on the VGA display.

The onboard buttons on the Nexys A7-100T are used in this project which require debouncing for accurate inputs. The button debouncer I created sends only one pulse for each press regardless of how long the button is pressed.


**Block Diagram**

![image](https://github.com/pileofhay/Higher_or_Lower_on_VGA/assets/130268332/bae9d178-ab54-49e2-9d92-1c96444ec559)




