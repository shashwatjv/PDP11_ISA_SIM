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

`define R0_MLOC 16'o177700
`define R1_MLOC 16'o177702
`define R2_MLOC 16'o177704
`define R3_MLOC 16'o177706
`define R4_MLOC 16'o177710
`define R5_MLOC 16'o177712
`define SP_MLOC 16'o177714
`define PC_MLOC 16'o177716
`define PSW_MLOC 16'o177776

// Status Bits
`define PSW_N 3
`define PSW_Z 2
`define PSW_V 1
`define PSW_C 0

`define FILE_TRACE(file, msg) \
	$fdisplay (file, "%s", msg);


`define BR_TRACE $fdisplay(br_f, "PC: %6o\tTYPE: %s\tTGT: %6o\t%s", t_h.instr_pc, t_h.opcode_ex, t_h.tgt_addr, t_h.br_taken);

`define one 1

`define BR_FUNC(cond) \
	//mem_addr_t tgt_addr;\
	//tgt_addr = compute_branch_target (t_h);\
	t_h.tgt_addr = compute_branch_target (t_h);\
	t_h.br_taken = (cond) ? T:NT; \
	//if (t_h.br_taken) reg_h.Write(PC, tgt_addr); \
	if (t_h.br_taken) reg_h.Write(PC, t_h.tgt_addr); \
	`BR_TRACE
