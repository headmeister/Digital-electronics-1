# Project
## General description
The circuit can perform a slow dimming of output device like LED through PWM after the set time has expired. The remaining time can be set by rotary encoder. The maximmum time to count down is set to 1 Hour and can be set in increments of seconds. Since it could take considerable amount of time to set the countdown to large values, the encoder module uses simple velocity-like control, so that when turning the knob for longer period of time and fast the increment of the counter rises as well. For convenience the remaining time is displayed on group of four 7 segment displays in MM:SS format. When the remaining time is less or equal to 10 seconds the display starts to blink to attract the attendance of user and remains blinking after the time has expired. When the time has expired the output is also slowly dimmed through PWM. The frequency of the PWM is roughly 100 Hz and the dimming is performed in 100 steps every PWM cycle so that the total dimming time is 1 second.

## Modules and block diagram
![Diagram](blok_s.PNG)

The chart has been generated in Quartus prime lite for better visuals than RTL viewer in Xilinx ise. The inputs A and B are two outputs of the encoder, the outpus PWM are for the LED or electronics driving larger light sources. 

### Counter Module
Counter module works as the main countdown for the light, in addition it works in cooperation with hex27seg as binary to clock ( MM:SS) converter. It performs division of the current counter value by 600 (tenths of minutes) , 60 (minutes), 10 (tenths of seconds), 1( seconds), to convert the counter value to current remaining time. The other and in fact main function of this module is to countdown the main counter, since the period of the counter is defined to be 1 second the counter value is in seconds. So the module decrements the current counter value by 1 every second and then executes the conversion to MM:SS format. Because this conversion can take different amount of time for different counter values and the main clock frequency is quite low (10 kHz) the display is synchronously updated so that, the change of digits on display appears to change in intervals of the same lenght.

### Encoder Module
Encoder module has responsibility to read the movement of rotary encoder. It uses simple detection of movement using one output pin of rotary encoder while checking the value of the other one it decides wheter it should increase or decrease the counter value i.e. the knob has been turned clockwise or counterclockwise. For better usability when the knob is beeing turned for longer amount of time and with certain speed the increment increases as well. So if turning slowly the increment is 1 second, when turning faster the increment can rise up to 1 minute. 

### Clock enable module
This module is used several times throughout the design and it is used to divide the input clock by creating enable signal which is high every n clock periods. The duration of this pulse is equal to one clock half period. 

### Clock Divider Module
This module divides the clock in contrast to clock_enable module, it does not generate pulses of one clock half period length, but it creates equal lenght of high and low values, this block is used for display blinking when the countdown is about to end. This is decided in disp_blink process, which either connects the display enable signal to 1 or the output of clock divider module, which period is set to 500 ms.

### Driver7seg Module
This module is used to drive the four 7-segment displays to show the remaining time, it complies of hexadecimal (binary) to output digits converter and mux to update each digit separately, since the wiring diagram does not allow to drive all of them all at once. In addition to implementation which has been done during the labs this module has a turn off signal, which can shut the display down completely (turn off all digits), in this design it is used to blink the display when the countdown is about to finish.

### PWM 