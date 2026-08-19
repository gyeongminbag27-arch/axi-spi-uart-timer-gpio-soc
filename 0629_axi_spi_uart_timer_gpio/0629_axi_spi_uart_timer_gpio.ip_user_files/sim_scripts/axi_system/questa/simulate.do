onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib axi_system_opt

do {wave.do}

view wave
view structure
view signals

do {axi_system.udo}

run -all

quit -force
