/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`define MEM_TRACE(msg) $fdisplay (mem_trace_f, "%s", msg);

`define DEBUG_MEM_TRACE(msg) $fdisplay (debug_mem_f, "%s", msg);

`define LOAD_MEM_TRACE(msg) $fdisplay (load_mem_f, "%s", msg);

`define DEBUG(msg) \
	if (debug) \
		if (console) \
		$display ("%s:%0d \t %s", `__FILE__, `__LINE__, msg); \
		else \
		$fdisplay (log_f, "%s:%0d \t %s", `__FILE__, `__LINE__, msg);


`define INFO(msg) \
	if (info) \
		if (console) \
		$display ("%s:%0d \t %s", `__FILE__, `__LINE__, msg); \
		else \
		$fdisplay (log_f, "%s:%0d \t %s", `__FILE__, `__LINE__, msg);
	
`define R0 0
`define R1 1
`define R2 2
`define R3 3
`define R4 4
`define R5 5
`define SP 6
`define PC 7
`define PSW 8

// Status Bits
`define PSW_N 3
`define PSW_Z 2
`define PSW_V 1
`define PSW_C 0
