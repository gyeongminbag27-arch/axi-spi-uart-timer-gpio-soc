## =====================================================
## Basys3 XDC for AXI GPIO / UART / SPI / LCD Project
## Board: Basys3 Rev B
## =====================================================


## =====================================================
## Clock
## BD top port name must be: clk
## Basys3 100 MHz clock = W5
## =====================================================
set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]


## =====================================================
## Reset Button
## reset = BTNC
## =====================================================
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports reset]


## =====================================================
## GPIOA -> LEDs[7:0]
## Role: LED output
## Vitis: GPIOA_CR = 0xFF, GPIOA_ODR write
## =====================================================
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[0]}]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[1]}]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[2]}]
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[3]}]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[4]}]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[5]}]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[6]}]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports {GPIOA[7]}]


## =====================================================
## GPIOB -> Switches[7:0]
## Role: Switch input
## Vitis: GPIOB_CR = 0x00, GPIOB_IDR read
## =====================================================
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[0]}]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[1]}]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[2]}]
set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[3]}]
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[4]}]
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[5]}]
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[6]}]
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports {GPIOB[7]}]


## =====================================================
## GPIOC -> Pmod JB
## Role: Extension GPIO
## =====================================================
set_property -dict { PACKAGE_PIN A14 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[0]}]
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[1]}]
set_property -dict { PACKAGE_PIN B15 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[2]}]
set_property -dict { PACKAGE_PIN B16 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[3]}]
set_property -dict { PACKAGE_PIN A15 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[4]}]
set_property -dict { PACKAGE_PIN A17 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[5]}]
set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[6]}]
set_property -dict { PACKAGE_PIN C16 IOSTANDARD LVCMOS33 } [get_ports {GPIOC[7]}]


## =====================================================
## GPIOD -> Pmod JC
## Role: Extension GPIO
## =====================================================
set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[0]}]
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[1]}]
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[2]}]
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[3]}]
set_property -dict { PACKAGE_PIN L17 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[4]}]
set_property -dict { PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[5]}]
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[6]}]
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports {GPIOD[7]}]


## =====================================================
## Parallel Character LCD -> Pmod JA
##
## lcd_gpio[0] = LCD RS
## lcd_gpio[1] = LCD E
## lcd_gpio[2] = LCD D4
## lcd_gpio[3] = LCD D5
## lcd_gpio[4] = LCD D6
## lcd_gpio[5] = LCD D7
## lcd_gpio[6] = LCD BLA, backlight anode
## lcd_gpio[7] = unused
##
## LCD fixed wiring:
## RW  -> GND
## BLK -> GND
## GND -> GND
## VDD -> 5V or 3.3V depending on LCD module
## VO  -> contrast control
## =====================================================
set_property -dict { PACKAGE_PIN J1 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[0]}]
set_property -dict { PACKAGE_PIN L2 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[1]}]
set_property -dict { PACKAGE_PIN J2 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[2]}]
set_property -dict { PACKAGE_PIN G2 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[3]}]
set_property -dict { PACKAGE_PIN H1 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[4]}]
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[5]}]
set_property -dict { PACKAGE_PIN H2 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[6]}]
set_property -dict { PACKAGE_PIN G3 IOSTANDARD LVCMOS33 } [get_ports {lcd_gpio[7]}]


## =====================================================
## Custom UART -> Basys3 USB-RS232
##
## FPGA rx_0 receives data from PC
## FPGA tx_0 sends data to PC
## =====================================================
set_property -dict { PACKAGE_PIN B18 IOSTANDARD LVCMOS33 } [get_ports rx_0]
set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports tx_0]


## =====================================================
## SPI External Test Pins -> JXADC
##
## Role: board-to-board SPI slave test
## If you do not use external SPI test, remove these external ports from BD.
## Since they are currently external ports, they must be constrained.
## =====================================================
set_property -dict { PACKAGE_PIN J3 IOSTANDARD LVCMOS33 } [get_ports spi_sclk]
set_property -dict { PACKAGE_PIN L3 IOSTANDARD LVCMOS33 } [get_ports spi_mosi]
set_property -dict { PACKAGE_PIN M2 IOSTANDARD LVCMOS33 } [get_ports spi_miso]
#set_property -dict { PACKAGE_PIN N2 IOSTANDARD LVCMOS33 } [get_ports spi_ss_n]


## =====================================================
## SPI LCD-style Control Pins
##
## Current character LCD does not use these.
## But if lcd_dc / lcd_rst remain as external BD ports,
## they must be constrained.
## =====================================================
set_property -dict { PACKAGE_PIN K3 IOSTANDARD LVCMOS33 } [get_ports lcd_dc]
set_property -dict { PACKAGE_PIN M3 IOSTANDARD LVCMOS33 } [get_ports lcd_rst]


## =====================================================
## Optional Button GPIO
##
## Use this section only if you added external port button[7:0].
## If there is no button[7:0] port in BD, keep all lines commented.
##
## button[0] = btnU
## button[1] = btnL
## button[2] = btnR
## button[3] = btnD
## button[4]~[7] = spare
## =====================================================
# set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports {button[0]}]
# set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports {button[1]}]
# set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports {button[2]}]
# set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports {button[3]}]

# set_property -dict { PACKAGE_PIN V2 IOSTANDARD LVCMOS33 } [get_ports {button[4]}]
# set_property -dict { PACKAGE_PIN T3 IOSTANDARD LVCMOS33 } [get_ports {button[5]}]
# set_property -dict { PACKAGE_PIN T2 IOSTANDARD LVCMOS33 } [get_ports {button[6]}]
# set_property -dict { PACKAGE_PIN R3 IOSTANDARD LVCMOS33 } [get_ports {button[7]}]
