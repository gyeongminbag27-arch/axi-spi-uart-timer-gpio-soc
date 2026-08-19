-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ipshared/7604/hdl/spi_axi_v1_0_S00_AXI.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/axi_system/ipshared/7604/src/spi_master.sv" \
  "../../../bd/axi_system/ipshared/7604/hdl/spi_slave.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ipshared/7604/hdl/spi_axi_v1_0.v" \
  "../../../bd/axi_system/ip/axi_system_spi_axi_0_0/sim/axi_system_spi_axi_0_0.v" \
-endlib
-makelib xcelium_lib/microblaze_v11_0_4 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/9285/hdl/microblaze_v11_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_microblaze_0_0/sim/axi_system_microblaze_0_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ipshared/99c1/hdl/uart_two_v1_0_S00_AXI.v" \
  "../../../bd/axi_system/ipshared/99c1/hdl/uart_two_v1_0.v" \
  "../../../bd/axi_system/ip/axi_system_uart_two_0_0/sim/axi_system_uart_two_0_0.v" \
  "../../../bd/axi_system/ipshared/0a22/hdl/timer_counter.v" \
  "../../../bd/axi_system/ipshared/0a22/hdl/timer_two_v1_0_S00_AXI.v" \
  "../../../bd/axi_system/ipshared/0a22/hdl/timer_two_v1_0.v" \
  "../../../bd/axi_system/ip/axi_system_timer_two_0_0/sim/axi_system_timer_two_0_0.v" \
  "../../../bd/axi_system/ipshared/c344/hdl/gpio_v1_0_S00_AXI.v" \
  "../../../bd/axi_system/ipshared/c344/hdl/gpio_v1_0.v" \
  "../../../bd/axi_system/ip/axi_system_gpio_0_0/sim/axi_system_gpio_0_0.v" \
  "../../../bd/axi_system/ip/axi_system_gpio_1_0/sim/axi_system_gpio_1_0.v" \
  "../../../bd/axi_system/ip/axi_system_gpio_1_1/sim/axi_system_gpio_1_1.v" \
  "../../../bd/axi_system/ip/axi_system_gpio_1_2/sim/axi_system_gpio_1_2.v" \
  "../../../bd/axi_system/ip/axi_system_gpio_1_3/sim/axi_system_gpio_1_3.v" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_intc_v4_1_15 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/47b8/hdl/axi_intc_v4_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_axi_intc_0_0/sim/axi_system_axi_intc_0_0.vhd" \
-endlib
-makelib xcelium_lib/xlconcat_v2_1_4 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/4b67/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_xlconcat_0_0/sim/axi_system_xlconcat_0_0.v" \
-endlib
-makelib xcelium_lib/lmb_v10_v3_0_11 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/c2ed/hdl/lmb_v10_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_dlmb_v10_0/sim/axi_system_dlmb_v10_0.vhd" \
  "../../../bd/axi_system/ip/axi_system_ilmb_v10_0/sim/axi_system_ilmb_v10_0.vhd" \
-endlib
-makelib xcelium_lib/lmb_bram_if_cntlr_v4_0_19 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/0b98/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_dlmb_bram_if_cntlr_0/sim/axi_system_dlmb_bram_if_cntlr_0.vhd" \
  "../../../bd/axi_system/ip/axi_system_ilmb_bram_if_cntlr_0/sim/axi_system_ilmb_bram_if_cntlr_0.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_lmb_bram_0/sim/axi_system_lmb_bram_0.v" \
-endlib
-makelib xcelium_lib/mdm_v3_2_19 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/8715/hdl/mdm_v3_2_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_mdm_1_0/sim/axi_system_mdm_1_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_clk_wiz_1_0/axi_system_clk_wiz_1_0_clk_wiz.v" \
  "../../../bd/axi_system/ip/axi_system_clk_wiz_1_0/axi_system_clk_wiz_1_0.v" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_rst_clk_wiz_1_100M_0/sim/axi_system_rst_clk_wiz_1_100M_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_22 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/af2c/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_21 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/54c0/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_23 \
  "../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/bc0a/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_system/ip/axi_system_xbar_0/sim/axi_system_xbar_0.v" \
  "../../../bd/axi_system/sim/axi_system.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

