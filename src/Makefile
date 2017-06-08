IPC?=10
IFILE ?= src2.ascii

all: clean lib compile sim

lib:
	vlib work
	vmap work work
		
compile:
	vlog -mfcu -f files_sv.f 
sim:
	vsim -c -novopt -do "run -all" +IFILE=$(IFILE)  +IPC=$(IPC) top
	
clean:
	rm -rf work output.log traces/mem_trace.f traces/debug_mem_trace.f traces/load_mem_trace.f

