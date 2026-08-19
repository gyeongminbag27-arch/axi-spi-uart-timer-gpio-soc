vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/microblaze_v11_0_4
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/axi_intc_v4_1_15
vlib modelsim_lib/msim/xlconcat_v2_1_4
vlib modelsim_lib/msim/lmb_v10_v3_0_11
vlib modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_19
vlib modelsim_lib/msim/blk_mem_gen_v8_4_4
vlib modelsim_lib/msim/mdm_v3_2_19
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_22
vlib modelsim_lib/msim/fifo_generator_v13_2_5
vlib modelsim_lib/msim/axi_data_fifo_v2_1_21
vlib modelsim_lib/msim/axi_crossbar_v2_1_23

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap microblaze_v11_0_4 modelsim_lib/msim/microblaze_v11_0_4
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap axi_intc_v4_1_15 modelsim_lib/msim/axi_intc_v4_1_15
vmap xlconcat_v2_1_4 modelsim_lib/msim/xlconcat_v2_1_4
vmap lmb_v10_v3_0_11 modelsim_lib/msim/lmb_v10_v3_0_11
vmap lmb_bram_if_cntlr_v4_0_19 modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_19
vmap blk_mem_gen_v8_4_4 modelsim_lib/msim/blk_mem_gen_v8_4_4
vmap mdm_v3_2_19 modelsim_lib/msim/mdm_v3_2_19
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_22 modelsim_lib/msim/axi_register_slice_v2_1_22
vmap fifo_generator_v13_2_5 modelsim_lib/msim/fifo_generator_v13_2_5
vmap axi_data_fifo_v2_1_21 modelsim_lib/msim/axi_data_fifo_v2_1_21
vmap axi_crossbar_v2_1_23 modelsim_lib/msim/axi_crossbar_v2_1_23

vlog -work xpm  -incr -sv "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../bd/axi_system/ipshared/7604/hdl/spi_axi_v1_0_S00_AXI.v" \

vlog -work xil_defaultlib  -incr -sv "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../bd/axi_system/ipshared/7604/src/spi_master.sv" \
"../../../bd/axi_system/ipshared/7604/hdl/spi_slave.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../bd/axi_system/ipshared/7604/hdl/spi_axi_v1_0.v" \
"../../../bd/axi_system/ip/axi_system_spi_axi_0_0/sim/axi_system_spi_axi_0_0.v" \

vcom -work microblaze_v11_0_4  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/9285/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/axi_system/ip/axi_system_microblaze_0_0/sim/axi_system_microblaze_0_0.vhd" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
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

vcom -work axi_lite_ipif_v3_0_4  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work axi_intc_v4_1_15  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/47b8/hdl/axi_intc_v4_1_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/axi_system/ip/axi_system_axi_intc_0_0/sim/axi_system_axi_intc_0_0.vhd" \

vlog -work xlconcat_v2_1_4  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/4b67/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../bd/axi_system/ip/axi_system_xlconcat_0_0/sim/axi_system_xlconcat_0_0.v" \

vcom -work lmb_v10_v3_0_11  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/c2ed/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/axi_system/ip/axi_system_dlmb_v10_0/sim/axi_system_dlmb_v10_0.vhd" \
"../../../bd/axi_system/ip/axi_system_ilmb_v10_0/sim/axi_system_ilmb_v10_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_19  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/0b98/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/axi_system/ip/axi_system_dlmb_bram_if_cntlr_0/sim/axi_system_dlmb_bram_if_cntlr_0.vhd" \
"../../../bd/axi_system/ip/axi_system_ilmb_bram_if_cntlr_0/sim/axi_system_ilmb_bram_if_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_4  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../bd/axi_system/ip/axi_system_lmb_bram_0/sim/axi_system_lmb_bram_0.v" \

vcom -work mdm_v3_2_19  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/8715/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/axi_system/ip/axi_system_mdm_1_0/sim/axi_system_mdm_1_0.vhd" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../bd/axi_system/ip/axi_system_clk_wiz_1_0/axi_system_clk_wiz_1_0_clk_wiz.v" \
"../../../bd/axi_system/ip/axi_system_clk_wiz_1_0/axi_system_clk_wiz_1_0.v" \

vcom -work lib_cdc_v1_0_2  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/axi_system/ip/axi_system_rst_clk_wiz_1_100M_0/sim/axi_system_rst_clk_wiz_1_100M_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_22  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/af2c/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_5  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5  -93 \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_21  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/54c0/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_23  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/bc0a/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/d0f7" "+incdir+../../../../0629_axi_spi_uart_timer_gpio.gen/sources_1/bd/axi_system/ipshared/ec67/hdl" \
"../../../bd/axi_system/ip/axi_system_xbar_0/sim/axi_system_xbar_0.v" \
"../../../bd/axi_system/sim/axi_system.v" \

vlog -work xil_defaultlib \
"glbl.v"

