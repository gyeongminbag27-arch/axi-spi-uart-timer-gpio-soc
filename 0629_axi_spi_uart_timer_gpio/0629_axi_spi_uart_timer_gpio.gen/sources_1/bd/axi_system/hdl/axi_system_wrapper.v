//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Tue Jun 30 08:36:52 2026
//Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
//Command     : generate_target axi_system_wrapper.bd
//Design      : axi_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module axi_system_wrapper
   (GPIOA,
    GPIOB,
    GPIOC,
    GPIOD,
    clk,
    lcd_dc,
    lcd_gpio,
    lcd_rst,
    reset,
    rx_0,
    spi_miso,
    spi_mosi,
    spi_sclk,
    spi_ss_n,
    tx_0);
  inout [7:0]GPIOA;
  inout [7:0]GPIOB;
  inout [7:0]GPIOC;
  inout [7:0]GPIOD;
  input clk;
  output lcd_dc;
  inout [7:0]lcd_gpio;
  output lcd_rst;
  input reset;
  input rx_0;
  input spi_miso;
  output spi_mosi;
  output spi_sclk;
  output spi_ss_n;
  output tx_0;

  wire [7:0]GPIOA;
  wire [7:0]GPIOB;
  wire [7:0]GPIOC;
  wire [7:0]GPIOD;
  wire clk;
  wire lcd_dc;
  wire [7:0]lcd_gpio;
  wire lcd_rst;
  wire reset;
  wire rx_0;
  wire spi_miso;
  wire spi_mosi;
  wire spi_sclk;
  wire spi_ss_n;
  wire tx_0;

  axi_system axi_system_i
       (.GPIOA(GPIOA),
        .GPIOB(GPIOB),
        .GPIOC(GPIOC),
        .GPIOD(GPIOD),
        .clk(clk),
        .lcd_dc(lcd_dc),
        .lcd_gpio(lcd_gpio),
        .lcd_rst(lcd_rst),
        .reset(reset),
        .rx_0(rx_0),
        .spi_miso(spi_miso),
        .spi_mosi(spi_mosi),
        .spi_sclk(spi_sclk),
        .spi_ss_n(spi_ss_n),
        .tx_0(tx_0));
endmodule
