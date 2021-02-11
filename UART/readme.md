# UART Receiver(RX)
 Design and create a UART Receiver Driver to accept signal from keyboard from computer and display 8-bit Hex signal to the 7-segments LEDs of FPGA board. All of the designs need to go through multiple processes such as *functional verification*, *hardware validation*.

 ![asdf](https://github.com/PhatLe15/Computer-Architecture-Design/blob/master/UART/UART%20frame.png?raw=true)


##### *Figure 1: UART Serial Data Stream*

### Table of Contents

- [UART Receiver(RX)](#uart-receiverrx)
        - [*Figure 1: UART Serial Data Stream*](#figure-1-uart-serial-data-stream)
    - [Table of Contents](#table-of-contents)
    - [Software tools](#software-tools)
    - [Hardware Tools](#hardware-tools)
  - [Requirements](#requirements)
  - [Design methodology](#design-methodology)
  - [Design flow](#design-flow)
      - [Finite state machine](#finite-state-machine)
      - [Bubble diagram](#bubble-diagram)
      - [FPGA validation wrapper](#fpga-validation-wrapper)
  - [Simulation Result](#simulation-result)
  - [FPGA validation](#fpga-validation)
        - [*Figure 6: Tera Term interface to set up and send the keyboard input data*](#figure-6-tera-term-interface-to-set-up-and-send-the-keyboard-input-data)
  - [References](#references)
  - [License](#license)
  - [Author Info](#author-info)

---

### Software tools
- Verilog
- HDL EDA tool -  [Xilinx Vivado](https://www.xilinx.com/support/download.html)
- MIPS compiler - [Mars](http://courses.missouristate.edu/kenvollmar/mars/)
- CAD tool - [Draw.io](https://app.diagrams.net)
- Serial sending signal - [Tera Term]()  

### Hardware Tools

- FPGA Board - [Basys3 Artix-7 ](https://www.digikey.com/en/product-highlight/d/digilent/basys3-artix-7-fpga-board?utm_adgroup=Basys%203&utm_source=google&utm_medium=cpc&utm_campaign=EN_Product_New%20Products_MBR&utm_term=%2Bartix%20%2B7%20%2Bfpga&utm_content=Basys%203&gclid=Cj0KCQiA34OBBhCcARIsAG32uvMz1Zjg5tey4vPFj3mT_gtDZViFdWR0x6-aL8t9HmVKI899pc81ME0aAkdyEALw_wcB)

[Back To The Top](#uart-receiver)

---

## Requirements

The following **required** functionality is complete:

* [x] Design UART Driver:
  * [x] Draw state machine
  * [x] Draw bubble diagram
* [x] Create design file from Verilog
* [x] Functional Verification
* [x] Hardware validation

The following **future improvement** features are implemented:

* [ ] Create UART transmitter(TX)
* [ ] Send serial signal from board to computer 
* [ ] Create VGA driver to output image to LCD display 

[Back To The Top](#uart-receiver)

---

## Design methodology
The UART communication protocol that compose of 3 different sections in a frame: one `START bit`, eight `DATA bits`, and one `STOP bit`. For this project, the UART RX would be sampling the data at rate of `115200` baud. For this reason, the design state machine will have 4 states which is `IDLE, START, END` as shown in ***Figure 2***. In addition, the data will be collected at the middle of each bit from the **serial line receiver**(`i_serial`) as shown in ***Figure 1*** above.
Since the chosen FPGA board can run at `50Mhz` with a **clock divider**(`clk_gen`) and the desired transmitting baudrate is `115200`. We can easily find the distance between each bit to be `217(50Mhz/116200)`. As the result, the design will first count the clock until the middle of the `START` bit (`(868-1)/2`). Then, the rest of data bit will be sampled at `217` distance of the input clock.
  


[Back To The Top](#uart-receiver)


---
## Design flow
#### Finite state machine
![asdf](https://github.com/PhatLe15/Computer-Architecture-Design/blob/master/UART/FSM.png?raw=true)
***Figure 2: UART state machine***

#### Bubble diagram
![asdf](https://github.com/PhatLe15/Computer-Architecture-Design/blob/master/UART/Bubble%20Diagram.png?raw=true)
***Figure 3: Bubble diagram***

#### FPGA validation wrapper
![asdf](https://github.com/PhatLe15/Computer-Architecture-Design/blob/master/UART/FPGA_wrapper.png?raw=true)
***Figure 4: FPGA top-level design***

[Back To The Top](#uart-receiver)

---
## Simulation Result
The testbench design was to simulate the value input `0x48` that was sent at `115200 baudrate`. Furthermore, if the output `w_byte` mismatch the input, an error signal was incremented to display an unsuccessful transmission. As shown in ***Figure 5***, the UART receiver has been successfully capture the expected data with a `valid` signal at the end of the last state(`STOP`) as well as showing no error has been incremented.   

![asdf](https://github.com/PhatLe15/Computer-Architecture-Design/blob/master/UART/Simulation%20waveform.png?raw=true)

***Figure 5: Waveform of UART simulation when receiving value 0x48***

[Back To The Top](#uart-receiver)

---
## FPGA validation
The schematic of FPGA wrapper is as in ***Figure 4***. The output data of the `UART_RX` is connected to a hex to 7-segments converter module(`hex_2_7seg`) which is then go through the 7-segments driver(lex_mux). Since there is only 2 hex value per keyboard button, the first two `7-segments LEDs` were used to display the receiving value. Moreover, an LED was also be used to show the `valid` signal when the transmission is finished. 
To actually send a keyboard input data through the micro USB port, the application called **Tera Term** was used to setup the `frame` format as well as the `baudrate` as shown in ***Figure 6*** below. As shown in ***Figure*** below, the FPGA board has been correctly receive the data and display to the 7-segments LEDs.

![asdf](https://cdn.sparkfun.com/assets/2/b/4/0/5/521e941a757b7f09778b4567.png)
##### *Figure 6: Tera Term interface to set up and send the keyboard input data*



---
## References

- UART protocol reference - [here](https://www.circuitbasics.com/basics-uart-communication/)

[Back To The Top](#uart-receiver)

---

## License

MIT License

Copyright (c) 2021 Phat Le

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[Back To The Top](#uart-receiver)

---

## Author Info

- Github - [PhatLe15](https://github.com/PhatLe15)
- Linkedin - [phat-tan-le](https://www.linkedin.com/in/phat-tan-le/)
- Email - [phat.le@sjsu.edu]()


[Back To The Top](#uart-receiver)


