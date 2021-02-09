# PIPELINED MIPS PROCESSOR AND I/O INTERFACE
 Build and convert the **fifteen-instructions 32-bit MIPS processor** from `single cycle` design into `five-stage pipelined` design. Furthermore, interface the processor with the `factorial accelerator `and the `GPIO using memory-mapped interface registers`. All of the designs need to go through multiple processes such as *functional verification*, *hardware validation* and *performance analysis*.

### Table of Contents

- [PIPELINED MIPS PROCESSOR AND I/O INTERFACE](#pipelined-mips-processor-and-io-interface)
    - [Table of Contents](#table-of-contents)
    - [Software tools](#software-tools)
    - [Hardware Tools](#hardware-tools)
  - [Requirements](#requirements)
  - [Design methodology](#design-methodology)
      - [Five-stage Pipelined](#five-stage-pipelined)
      - [System on Chip](#system-on-chip)
        - [Factorial accelerator](#factorial-accelerator)
        - [GPIO](#gpio)
  - [Schematics](#schematics)
      - [Five-stage Pipelined](#five-stage-pipelined-1)
      - [System on Chip](#system-on-chip-1)
      - [FPGA validation wrapper](#fpga-validation-wrapper)
  - [Truth table](#truth-table)
      - [Five-stage Pipelined](#five-stage-pipelined-2)
        - [Control Unit sub-module](#control-unit-sub-module)
      - [System on Chip](#system-on-chip-2)
  - [Performance Analysis](#performance-analysis)
  - [Simulation Result](#simulation-result)
    - [SoC with single-cycle system](#soc-with-single-cycle-system)
    - [Factorial accelerator wrapper](#factorial-accelerator-wrapper)
    - [GPIO](#gpio-1)
    - [SoC address decoder](#soc-address-decoder)
    - [SoC with complete pipelined system](#soc-with-complete-pipelined-system)
  - [FPGA validation](#fpga-validation)
  - [References](#references)
  - [License](#license)
  - [Author Info](#author-info)

---

### Software tools
- Verilog
- HDL EDA tool -  [Xilinx Vivado](https://www.xilinx.com/support/download.html)
- MIPS compiler - [Mars](http://courses.missouristate.edu/kenvollmar/mars/)
- CAD tool - [Draw.io](https://app.diagrams.net)

### Hardware Tools

- FPGA Board - [Basys3 Artix-7 ](https://www.digikey.com/en/product-highlight/d/digilent/basys3-artix-7-fpga-board?utm_adgroup=Basys%203&utm_source=google&utm_medium=cpc&utm_campaign=EN_Product_New%20Products_MBR&utm_term=%2Bartix%20%2B7%20%2Bfpga&utm_content=Basys%203&gclid=Cj0KCQiA34OBBhCcARIsAG32uvMz1Zjg5tey4vPFj3mT_gtDZViFdWR0x6-aL8t9HmVKI899pc81ME0aAkdyEALw_wcB)

[Back To The Top](#pipelined-mips-processor-and-io-interface)

---

## Requirements

The following **required** functionality is complete:

* [x] Design SoC:
  * [x] SoC interface schematic
    * [X] GPIO
    * [X] Factorial 
  * [x] Tables for MIPS SoC interface
  * [x] The factorial accelerator should be able to handle 4-bit input data (n).
  * [x] Use the simple GPIO for FPGA validation:
    * [X] The MIPS read input (n) from on-board switch via GPIO
    * [X] Display the result (n!) on on-board 7-segment LEDs, also via GPIO.
  * [x] Analytical performance comparison between the software-only and hardware-accelerated execution of the factorial function.
* [x] Pipelined MIPS microarchitecture:
  * [X] Schematic
  * [X] Tables for MIPS control unit
* [x] Functional Verification
* [x] Hardware validation

The following **future improvement** features are implemented:

* [x] Hazard handling
  * [x] Data Forwarding
  * [x] Early branch Determination

[Back To The Top](#pipelined-mips-processor-and-io-interface)

---

## Design methodology
#### Five-stage Pipelined
Five stages include instruction `fetching, decoding, executing, data memory,` and` writing back`. The purpose of pipelining is to expedite the throughput of the computer system. Pipelining has some limits such as instruction latency, more complex design. There are also some factors that cause pipelining to not perform fluently. First, data dependency is when one instruction depends on the results of the previous instructions, which stalls the pipeline and some no-operating instructions `nops` are added to the pipeline to do nothing. 

Second, `conditional branch` instructions also `stall` the pipeline until they are determined if the branches are `taken` or `not`. Besides that, jump instruction takes one cycle of doing nothing to get the address of the destination. To make the pipeline perform better without wasting nop instructions, a hazard unit is added to the pipeline to control the behavior of branch and data dependency.

The block diagram of the pipeline is shown as in Figure 1. It contains all five stages needed for a pipeline along with all the muxes for the instruction set including `add, sub, and, or, slt, lw, sw, beq, j, addi, multu, mfhi, mflo, jr, jal, sll, srl`. Also, a hazard unit is added to the pipeline to eliminate some unnecessary nops. Early branch determination is used so that the result of the branch instruction is available in the decoding stage, which saves two cycles. Branch stall is also implemented which will stall the instruction after branch while the result of branch is being calculated. Full forwarding path is included in the design. Four signals `sel_AE, sel_BE, sel_AD,` and `sel_BD` are used to `forward data` to the next instructions where data dependency occurs as in ***Table 3***.


#### System on Chip
The system on chip`SoC` which interfaces the MIPS processor design with the `factorial accelerator` and the `general-purpose I/O(GPIO)` designs. Moreover, an `address decoder` is needed to support the communication between interfaces based on the memory-mapped shown in ***Table 4***. A `4-to-1 mux` is also necessary to select the appropriate data loaded into the MIPS processor’s register file.

##### Factorial accelerator 
The `factorial accelerator` needs to be put inside an `interface wrapper` in order to communicate with the MIPS processor as shown in ***Figure 6*** below. The wrapper also has its own memory-mapped table to support its functionality shown in ***Table 6*** below. Moreover, it has a `4-to-1 Mux` so select the output based on `RdSel` signal.

##### GPIO 
Similar to the factorial accelerator wrapper, the `GPIO-Mapped` also has an `address
decoder` as well as a `4-to-1 Mux` which follow the functionality in ***Table 5***. For this project, the GPIO was used to `load` the data from the `input switches` to the processor using the general input function of the GPIO. The GPIO also outputs the final result when the general output function is selected.

[Back To The Top](#pipelined-mips-processor-and-io-interface)


---
## Schematics
#### Five-stage Pipelined
![asdf](https://lh4.googleusercontent.com/Zd9GF6cYRVEpZ2zVPe6bciRl-jsKDaFmvNBm0m1JdLsvhOJeDafs11u1brSF7mjdDaS9t1SnpPUyRZH_8kH2KSSABdyw1z5gUxDh2D9H3jJrpnlpNTxThkUSue6MBmaJr1FgMyk)
***Figure 1: Pipeline Design (Overview)***

![asdf](https://lh3.googleusercontent.com/yFF5gsTznaonsP2Q-1BXKmAEowBNZ-Pytn7Dkkna6UrgAUIpAxlz4BttUnAgCl-4V-8npU7fh8ckP97glRLccWBw_V615bSE8phHyDOuNLdFkOFlbmsLOHDZclzId7375FZaN40)
***Figure 2: Pipeline Design (zoom in of IF-ID stage)***


![asdf](https://lh5.googleusercontent.com/5j2skr1GTq2L4PoHeVMUhPJ-hPDwrx8Irk9BduWIwI73wZ9_2DYtDDABTeGWopi5OPc3QPE14xWBq1uPMYmRNpHqEqTqkik81m9_FB8AVm60AoTxv_7q9Bb0WCdJO60OllzlH8U)
***Figure 3: Pipeline Design (zoom in of EX-MEM-WB)***

![asdf](https://lh4.googleusercontent.com/5p7AD1WwKk08C6DuYim_Lvj_SXBsHaI8fpJcCCS8i57DlUar-Z0r4WpsmdUsvXaOJR7XaNJOZf5F5gzW1R5NOF80Tf3G4XqMgIPovuUsYlK4_QSp5nMoTjt2VK4xB-F5FhnIgbg)
***Figure 4: Pipeline Design (zoom in of Hazard Unit)***

#### System on Chip
![asdf](https://lh5.googleusercontent.com/-nOeW7KIj5oWC3QVkqTWHNQ1Z8qYvPnTr_QUSZAeVPE-Dm4I9jT0oTGfbMSZDGZIFBI6ZESWd3pD2mn-NQvaDpABMoyubP7E9V0fyHN9VDPYmGMEPVbWjdt5sEEGpQWY5zx37pU)
***Figure 5: SoC top-level design***

![asdf](https://lh5.googleusercontent.com/qXDlgI249_ModkypVikrxfDPzEyCRzUTdVIdWf6yzA25H8eWldtCMK59hmb532Wj3S8Uu07-6Xok-PLiZdJ8HpezPtHdy_7zg1_6QkQN_NsvQcfu0R8nplLnu4WPvM5804HSrI4)
***Figure 6: Factorial accelerator wrapper top-level design***

![asdf](https://lh5.googleusercontent.com/pUkxFTpIhzWBb8uIhddRbJVuxD-eJTwFlYbF2PDuv8LGDuGLTd1GqbqXVtfBqCdoKoHU-8rJyyWEMAQ2FQ5Xa3jZM-xfKLzGMlCXQAlrp9rBBVv6l3-tICYPJ5KaAXx3xOD3xuw)
***Figure 7: GPIO top-level design***

#### FPGA validation wrapper
![asdf](https://lh5.googleusercontent.com/K4Z7SMCQ0vVhP_IyEjBZInTDJlEt1m18gPr-df2uqd-j-P2X3OkiOuKvEBKjOkWZAcoGAeUwV6lP5PQCtST9OFW3him7A2xc2x97VlUZAtH7jvj0aEb7bSjhtA7MIa68FSE043g)
*FFigure 22: FPGA top-level design*

[Back To The Top](#pipelined-mips-processor-and-io-interface)

---
## Truth table
For all the signals coming in from the control unit to the datapath, they are asserted to the ID stage, then pipelined through all the stages as in ***Figure 1***. All signals should be following the truth tables.
#### Five-stage Pipelined
##### Control Unit sub-module
***Table 1: Truth Table for Maindec***
![asdf](https://lh3.googleusercontent.com/emMabp8TwbPfynRu9kP-ZUWO3RHR4S3OIUIIzJvX9jqCRsakqdi5MLeZ-Pu2Mha_K37S413wnq6TAufce0lOqFpp5cmWr4pFrdMHsZae5aeYOiUgidXEimn1l1-NYNy8beiQw_Cl)

***Table 2: Truth Table for Auxdec***
![asdf](https://lh5.googleusercontent.com/kcID8PQYg4rBzkKkVUci8aOQAEdKEsjXcUhsChE1qaxO7GDSqVqFwPPQX2XfPZ7SXX9QknBOKptIRuB82vx_Cc70Mf_D77FbiZE3ihA8UmIS7Pn7CQmUYhRGqdgb-Rzu04JRPCHA)

***Table 3: Forwarding signals and their functionalities***
![asdf](https://lh3.googleusercontent.com/W_JUX5AKApFZLfGcuo-i_Y4WYxVEgFoRFVY10ui-uWOfmd3cS04M4M0yAfGDQMnsaS3rOySIK-xuHEaoWUNMYg2S2EgzIyIrr3NFbuHcAbvDYU9amAay0T6MYIqQedLkFpXRE1Vm)

#### System on Chip
***Table 4: SoC Memory-Mapped interface***
![asdf](https://lh5.googleusercontent.com/sR9F7-BiII7mfrbMfjLbK5MbSdvP6ciRnVV9m_pPPnwG2M02sl0il6fRD44nq6tltTbUmig6_9WxLJnqKNdsDEGC_tvkK8ig-9ATs710qnsWl0Ft79XxHxUC_aN1ui50emFX8qiW)

***Table 5: GPIO Memory-Mapped Interface Registers***
![asdf](https://lh5.googleusercontent.com/6j7OiGuuZhKF65PRudBsRAAioe6pGIkCM7Od21PmH8jhosLwgqV97l313qjF8WkHVCtR7W1DEeyz7jbWUMW_mK946R8kgq9u6LYumMiVVfUOK4AmI2mY3LMsL2IvQ-5TAHH_loAL)

***Table 6: Factorial Accelerator Memory-Mapped***
![asdf](https://lh4.googleusercontent.com/uUsknuaUpZodqnV_SZGc_sgYOM7gvD4MYrwBwM0Zng7tlzwPRq6v8UaoUf8x5yxjFPkpcu2Yd1-arLxZoSIX-E8c9_48s9BX0GIqq4uFMKsilQBHUslslTCriG76e6d-tHsTPTv3)

[Back To The Top](#pipelined-mips-processor-and-io-interface)

---
## Performance Analysis 
The resulting cycles for all `12 input n` values were compared for `polling` and `recursive` in regards to the factorial function included in a `pipelined` architecture and a `non-pipelined` architecture. The results showed the difference and effect a pipelined architecture can have on the system. From the result, the pipelined method had `more cycles` for the inputs than the non pipelined. Since the system implemented `data forwarding` and `branch determination`, the number of cycles that would have otherwise been present were bypassed. The pipelined architecture should ideally `reduce time` irrespective of how many cycles relative to the non-pipelined architecture. 

***Table 12: Single-cycle architecture vs. Pipelined architecture***
![asdf](https://lh3.googleusercontent.com/wEjgTTASJsSjTb1Jtdg5qO8Rjlcv_haUS5n8qYBCixxI84FS6R6JIOWSRiJWpzqQ8DHBNhtxyulPxwhhYKtqTAsm8dp22AaxxFoFL9zHymtK7hOXZx-Km-E0FCP4zA)

![asdf](https://lh5.googleusercontent.com/-W2vgza_SCzL49GG8MLE0plfK4xUATOzJ3YANazipBIkT0rMMA00FMJcrgjQQ4NkJkMMmyRXLuVWBmdT_ZRfCwAFoP8UvkeBhopGPO6JrqqjWseTZE4AUjc2WfCvhxd2jzPX2lRT)

***Figure 8: Performance analysis for non-pipelined polling and recursive functions***

![asdf](https://lh5.googleusercontent.com/bHwd1gFQJ2iU8blwaTdlGBb15LNZjELIC0ISzfvRb6kJ6ooS9uldx22EpFFeFmH9fspXv6zZaFkqcfrK55MCSnX8xT8lGJt5YMNOFY-PLmAsIbB2SJ7eqJy2eIg4a95dcaJqrKwB)

***Figure 9: Performance analysis for the pipelined polling and recursive functions***

[Back To The Top](#pipelined-mips-processor-and-io-interface)

---
## Simulation Result
### SoC with single-cycle system
The testbench for the SoC would run until the program counter reached the end of the MIPS program counter. In this case, the SoC would run until `pc_current = 40`. To test the system, the testbench provided the value of `n` for the `gpI1`. 
According to the instructions code, `gpO1` would output the select and error signal at pc_current = 3c. The first Hex is the error and the second Hex is the `hi` or `low` select signal. Furthermore, the gpO2 would output the factorial result at pc_current = 40. ***Figure 11*** shows the `factorial of 12` to be correct at `gpO2`. ***Figure 11*** and ***Figure 12*** also demonstrated the system was able to display the `hi` or `low` selection at `GPO1 = 10` or `00`. When `n = 13`, the error signal was displayed as the `gpO1 = 11` shown in ***Figure 10***.

![asdf](https://lh6.googleusercontent.com/k98OtZxqJO4nYlFN66A5wHa74acX_Y5hVM0AIcfVfyvy8v1iVqLF3nB2mcF0-F8LKnN9xvBQ3uqBka_X8XHsM38jk_z69FSXX4ZajNZfKw88RYrlK_1S9_zgGxNz0fDwklLrWBM)

***Figure 10: Waveform of the factorial system when input is 13***


![asdf](https://lh3.googleusercontent.com/60ua2WUbQKmuJjlUGIdKQ-WavXgKHqnqnTyIC39KSlgN5PDX8nsNSAt_IR_JgfusEw7e5r0b4srwR9XoLSXhyCIWfZtJ6RRlL_J_vCRnkmjvtbntO0WJgC3Wp7ldQUaK3nyTMrg)

***Figure 11: Waveform of the SoC when input is 12(dispSe = 1)***

![asdf](https://lh6.googleusercontent.com/f3TQlyqOiUZRDoNS73wO58No7x-Dh-4Mrw-2l5eXmvmiLQw2Hy2rFI8jIFZF7J6ziJYIwetZrGZdwzaxix8LRMW3DpJ8K73LgyqRolkqMV_tANtp_HfQs3vglmp7k5lJ-QmAmuA)

***Figure 12: Waveform of the SoC system when input is 12(dispSe = 0)***

### Factorial accelerator wrapper
The testbench plan was to provide all possible cases of n input (from `0 to 15`). Each of the case, the testbench also provided a `go` signal (`WD_tb = 1`) to begin the factorial operation. According to ***Figure 13*** below, when `n = 12` (`WD_tb = c`), the clock would run until it received a done signal (`RD_tb = 1`). It can easily be observed that the final result is correct (`!12 = 1c8cfc00`).

![asdf](https://lh3.googleusercontent.com/zMlWiJ5E8ljcfuZWbL6XbUDAjDDY8GDzxfNRq-xwalpImFBrWnV7Hmxownxe_WPORZaxafr84JpDLmQhkZ_hXe7y_nKDqkl7DoBRNzTTbylqV3lvnTt7V_fxj1mYFFC8hG7fBk8)

***Figure 13: Waveform of the factorial accelerator wrapper when input is 12***

### GPIO
The testbench for the GPIO would test the output `RD_tb` based on random input provided for the `gpI1, gpI2,` and `WD`. According to ***Figure 14*** below, when the address `A_tb` was `0`, which means that `gpI1` was selected, the value of `RD_tb` matched the value of `gpI1(12153524)`. When gpI2 was selected(A_tb = 1), RD_tb also matched the value of `gpI2(c0895e81)`. For the general purpose output, the data was passed from `WD_tb` to `RD_tb`. For instance, when `A_tb = 2 `or `3`, the `gpO1_tb` and `gpO2_tb` respectively output the exact value taken from `WD_tb`.

![asdf](https://lh6.googleusercontent.com/oMDLul6kJZ76osPtUfp9T6JghGocvuqm6t5wQsnch2nhvWfEr6YwI2ykkIdfm-td5aO0dOwZ9M1xIbXSkjOLXIAtWsaXHFjAyANW1ZpLaqg0_gDZJ4-LPYXIFLYlRa3vZ8OKsb0)
***Figure 14: Waveform of the GPIO***

### SoC address decoder
The testbench for the SoC address decoder would check the value of outputs `WE1, WE2, WEM, `and `Rd_Sel` based on random address input(`A_tb`) and the write enable signal (`WE_tb`). ***Figure 15*** below demonstrated that when the address is `0000_1011_10`, which fall in the range of `0000_xxxx_xx`, the SoC would select to store or load data to the data memory(`dmem`) by making `RdSel_tb = 00`. Furthermore, the dmem write enable signal(`WEM`) should match the `WE_tb` signal. Similar to the dmem select, `1000_0000_01 `and` 1001_0000_11` would respectively select the factorial(`1000_0000_xx`) and GPIO(`1000_0000_xx`) as expected.

![asdf](https://lh6.googleusercontent.com/5aNf5Lm1CjK3hJwhDA3CKgoz3O9ud0iYr0bOqw1VXiB2UVEQjV1Z1898BBAm4atgtYPCZDagb0N9PMYWIdduJNePxhHU2MZVIXxm7h3nhVLxDqL_BY7nTYvOzSGfe2Ktp5aOgcY)
***Figure 15: Waveform of the address decoder of the SoC***

### SoC with complete pipelined system
To take advantage of the `forwarding paths` and reduce the number of `nops`, the MIPS code is `rearranged` so that only `lw` instruction need nops inserted. The results of the factorial are shown after the `j fact` instruction. The inputs are limited from `0 to 12` because of the limitation of the FPGA board. ***Figure 17*** shows the result of factorial of `12`, where `gpO2` is `1C8CFC00` and `gpO1` is showing no error with the value of `10000` where high signal is selected. ***Figure 19*** shows the result of factorial of `13`. Because the input is greater than `12`, factorial of `13 `is not shown, but error signal can be seen in `gpO1` output as `10001`.

![asdf](https://lh6.googleusercontent.com/klcBfixkY8zLUoldJ1307hLEBtOpvnt9CTzkdk1YRs9WMJIEiklYm2GcBfv_4RnoEk317I5j_-VzeE6mPD1qPe250V-oaHPJclttNRQ_Fc-JEuikQL55iMuJbwyVpbVeyjQLRnY)
***Figure 16 : Waveform of the factorial system when input is 12***

![asdf](https://lh6.googleusercontent.com/JSRfTaM6SYUsYmFQlNRoY3Sn2Def914EESSDaJpbkVMFie2Xs2v2EQOAASxhe8XSnd_yFLrtY4JU673YkNtv5uteRTtgKULbfOAe5vsLGE9dkUUBDOMfnUOf35-ScqxNPBueIEg)
***Figure 17: Zoomed in waveform of factorial of 12***

![asdf](https://lh3.googleusercontent.com/7gVTGQMOouyqXztflmBkP__lEJ6eboZT4iB-28kYP5d3n192iIgo5hXeG7zMRHuyqByXnuhqNF6XRQ49NVssN37-H-heMMjDFII3yf5_qjCz5dscKILgH2nK0ar3g9vbKNGWjw4)
***Figure 18 : Waveform of factorial system when input is 13***

![asdf](https://lh6.googleusercontent.com/j9rmW-CWnZq85VlcoJf3UGDiQmehB_QPqHrdrdYCuTJtfev67oSWz1gfjWxfIFQO7b7bUemJXEZVc6cHMSuuxcg2_UuHZZssFl9bR0Nd1iFm08qoybqYAynPBcqpeL3N86eblaU)
***Figure 19: Zoomed in wave form of factorial of 13***

***Figure 20*** below shows the `branch stalls`. `Branch` instruction is where `pc_current` is `0x2c`. The instruction after that is stalled while waiting for the `result` of the branch to be calculated. When it turns out that branch is `taken`, instruction `0x30` is `flushed`, and it `jumps` to the target where `pc_current = 0x20`.

![asdf](https://lh4.googleusercontent.com/mTcEnMa3Hf9QX0j3znJZesPGF_4ZWVoFc71dDyqMLgSSpZ-adva-8RKAjh5CIAPlEb30PGdn61PER8_MrIRTDL8wCTIspNJoxNWkZqdmTT6fWv8BHJHzsYnL8ciHlkdQQUIvn98)
***Figure 20: Waveform shows branch stalls***

***Figure 21*** below shows an example of a `forwarding path`. When looking at `sel_BE = 2’b01`, we can see there is a forwarding path. Data from the `Write Back(WB)` stage is passed to `Execute(EXE)` stage. At the `c_current` value of `0x00`, the instruction is `addi $t1, $0, 1`. At the `pc_current` value of `0x08`, the instruction is `sll $t4, $t1, 4`. Therefore, the value of register `$t1` is passed from `WB` to `EXE` stage so the `shift left` instruction can be executed right away without being stalled.

![asdf](https://lh4.googleusercontent.com/wOw00LnA5Z_2fmzNAlSGsuUysVGNd8kJRGJnT_OGvQ48bJfzATJ3QyR_IIaOLIcoCIX_gpRYUtQinXYmmoc-Y82l0Tv-vaiTAUy4aw61Ir9CJOFQeG3LtuWu9HK9sgfTrNbBw3Y)
***Figure 21: Waveform of an example of forwarding path***

[Back To The Top](#pipelined-mips-processor-and-io-interface)

---
## FPGA validation
The FPGA diagram is as in ***Figure 22***. Because the `clk_4sec` is used as the clock of the system, it will take a while for the result to show up on the `7-segment LEDs`. In particular, the whole process will take `4 × number of cycles` seconds to calculate the final results. The result of factorial of `12` is as in ***Figure 23*** and ***Figure 24***. The high part is `1C8C` and the low part is `FC00`. Also, because of the limit of the displayed outputs, it can only take in the maximum input of 12. Any numbers greater than `12` will be displayed in errors as in ***Figure 25***.

![asdf](https://lh4.googleusercontent.com/fip-P3ufx4muv8NTuLGBr3r5TEvmmZpgaLmya7_8maUdsTInmKzQZEtzDVzdI-R-meq1eQqR66qMS63oKghjZmWY_rtNlJU-M63Dp0y41Pj1Nto7TTPDQ5bsdru3U3Z5spS7WGM)
***Figure 23: Result of Factorial of 12 at High Selection***

![asdf](https://lh4.googleusercontent.com/jT78KgrKBdVbYadeeUikMX68Ar4O4k1gFRLGsdwhToL7hHJIvOpQGMyCNyVsqXzvjc-RiZh0M3b_NCG1c4WfLzTfmbB8xhEFUjZOcxTz6N1MEFU5p1axtzSMmNWws2VnnG8q1kU)
***Figure 24: Result of Factorial of 12 at Low Selection***

![asdf](https://lh3.googleusercontent.com/F_k5YmIP0-olLV_cH6PJHlWMG_iuoRZw6-sLYGGZ_50_ZJwgDGsOOkfUEVzBJZ7GbpocxrLNjq61BM7Gh2kqxQTOmIIjroHVoxoWGZKD-KzPBSJGqxAxHd9gnvwl_6mU9lHtMOI)
***Figure 25: Result of Factorial of 15***

---
## References

- MIPS reference sheet - [here](hhttps://www.yumpu.com/en/document/read/39588603/m-i-p-s-reference-data)

[Back To The Top](#pipelined-mips-processor-and-io-interface)

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

[Back To The Top](#Anti-car-Theft-Camera-System)

---

## Author Info

- Github - [PhatLe15](https://github.com/PhatLe15)
- Linkedin - [phat-tan-le](https://www.linkedin.com/in/phat-tan-le/)
- Email - [phat.le@sjsu.edu]()


[Back To The Top](#Anti-car-Theft-Camera-System)


