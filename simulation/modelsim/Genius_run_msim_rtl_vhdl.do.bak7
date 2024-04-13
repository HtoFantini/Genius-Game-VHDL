transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Destr/Desktop/GEN/GEN/Xorshift.vhd}
vcom -93 -work work {C:/Users/Destr/Desktop/GEN/GEN/Genius.vhd}

vcom -93 -work work {C:/Users/Destr/Desktop/GEN/GEN/tb_Genius.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  tb_Genius

add wave *
view structure
view signals
run -all
