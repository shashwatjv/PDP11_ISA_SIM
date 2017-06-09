IPC?=0
IFILE ?= src2.ascii

all: clean lib compile sim

lib:
	vlib work
	vmap work work
	mkdir traces
		
compile:
	vlog -mfcu -f file_sv.f 
sim:
	vsim -c -novopt -do "run -all" +IFILE=$(IFILE)  +IPC=$(IPC) top
	
clean:
	rm -rf work output.log traces

