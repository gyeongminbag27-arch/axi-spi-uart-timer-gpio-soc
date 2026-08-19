# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\jh_workspace\0629_axi_spi_uart_timer_gpio\export\axi_system_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\jh_workspace\0629_axi_spi_uart_timer_gpio\export\axi_system_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {axi_system_wrapper}\
-hw {D:\jh_workspace\0629_axi_spi_uart_timer_gpio\export\axi_system_wrapper.xsa}\
-fsbl-target {psu_cortexa53_0} -out {D:/jh_workspace/0629_axi_spi_uart_timer_gpio/export}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {axi_system_wrapper}
platform generate -quick
