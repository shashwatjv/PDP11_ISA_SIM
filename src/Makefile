IPC?=0
IFILE ?=../asm/fib.ascii
REG_DUMP?=0

all: lib compile sim

lib:
	vlib work
	vmap work work
	mkdir traces
		
compile:
	vlog -mfcu -f file_sv.f -l compile.log
sim:
	vsim -c -novopt -do "run -all; quit" +IFILE=$(IFILE)  +IPC=$(IPC) +REG_DUMP=$(REG_DUMP) top
	
clean:
	rm -rf work output.log traces transaction.log compile.log transcript

