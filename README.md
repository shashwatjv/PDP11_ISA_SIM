# PDP11_ISA_SIM
PDP-11 ISA Simulator

Language Used: SystemVerilog

Design Strategy

We used an object oriented approach to designing the simulator, where the main object being modeled
is the execution of an instruction through different phases:
	1. In fetch phase, a new instruction object is created. The IR and current PC fields are populated.
	2. In decode phase, the opcode is determined. Based upon the type of instruction, effective address
	   calculation is performed and operands are fetched.
	3. The decoded object is passed to the execute phase, where the actual operation is performed upon
	   operands and memory write and register writeback takes place, if required. If the decoded
	   instruction is HALT, then then simulation is terminated and instruction count is displayed.

Verification Strategy
	We exhaustively verified the ISA simulator, targeting the following aspects:
	1. Simulation of each opcode
	2. Condition codes affected by instructions
	3. Subroutine calls and returns
	4. Multiple combinations of addressing modes for source and destination operands

Summary of Extra Credit
	1. Implemented and verified byte variants of instructions.
	2. Produced a branch trace file as required.

Using the simulator
	1. Compile the PDP-11/20 ISA simulator using the Makefile as follows:
		make clean
		make compile
	2. Use the bash script mac2ascii.sh to convert the macro-11 assembly file (ex: fib.mac) 
	   to produce the object file (fib.obj), list file (fib.lst) and ascii (fib.ascii) files as follows. 
	   This will automatically pick the starting PC from START label.
		mac2ascii fib
	3. Invoke the ISA simulator as follows.
		make sim options
		IFILE = path to input ascii file
		IPC = program start address in octal
		REG_DUMP = 1 (for optional display of register file dump)
