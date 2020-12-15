transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/omkar/VJTI/riscv/src {/home/omkar/VJTI/riscv/src/register_file.v}

