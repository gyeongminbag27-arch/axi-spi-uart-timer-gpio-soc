# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\jh_workspace\0629_axi_spi_uart_timer_gpio\final\0630_faxi_spi_uart\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\jh_workspace\0629_axi_spi_uart_timer_gpio\final\0630_faxi_spi_uart\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {0630_faxi_spi_uart}\
-hw {D:\jh_workspace\0629_axi_spi_uart_timer_gpio\0630_faxi_spi_uart.xsa}\
-fsbl-target {psu_cortexa53_0} -out {D:/jh_workspace/0629_axi_spi_uart_timer_gpio/final}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {0630_faxi_spi_uart}
platform generate -quick
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
