/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`ifndef DEFS_DONE
`include "defines.sv"

package common_pkg;

	parameter TRUE=1, FALSE=0;

	// PDP11 ORGANIZATION
	parameter MEM_ADDR_LEN = 16;
	parameter WORD_SIZE = 16;
	parameter MEM_WIDTH = 8; 
	typedef logic [WORD_SIZE-1:0] mem_addr_t;
	typedef logic [MEM_WIDTH-1:0] mem_data_t;
	typedef logic [WORD_SIZE-1:0] word_t;
	typedef logic [7:0] byte_t;
	typedef enum {R0, R1, R2, R3, R4, R5, SP, PC, PSW} register_t;

	// OPCODE MNEMONICS
	typedef enum {MOV,MOVB,CMP,CMPB,BIT,BITB,BIC,BICB,BIS,BISB,
				  ADD,SUB,BR,BNE,BEQ,BGE,BLT,BGT,BLE,BPL,BMI,BHI,
				  BLOS,BVC,BVS,BCC,BCS,JSR,RTS,CLR,CLRB,COM,COMB,INC,
				  INCB,DEC,DECB,NEG,NEGB,ADC,ADCB,SBC,SBCB,TST,TSTB,
				  ROR,RORB,ROL,ROLB,ASR,ASRB,ASL,ASLB,JMP,SWAB,HALT} opcode_mnemonic;

	// FILE IO
	int debug=1, info=1, console=0;
	typedef enum {DATA_READ=0, DATA_WRITE=1, INSTRUCTION_FETCH=2} mem_access_t;				  	
	//integer mem_trace_f, debug_mem_f, load_mem_f, log_f;
	integer mem_trace_f = $fopen("traces/mem_trace.f", "w");
	integer debug_mem_f = $fopen("traces/debug_mem_trace.f", "w");
	integer load_mem_f = $fopen("traces/load_mem_trace.f", "w");
	integer log_f = $fopen("output.log", "w");
				  
endpackage

import common_pkg::*;

`define DEFS_DONE
`endif