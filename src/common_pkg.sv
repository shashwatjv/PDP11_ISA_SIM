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
	parameter HWORD_SIZE = WORD_SIZE/2;
	parameter MEM_WIDTH = 8; 
        
        parameter WSIGN = WORD_SIZE-1;
        parameter BSIGN = HWORD_SIZE-1;
        parameter LSB = 0;
        
	const logic [WORD_SIZE-1:0] bop_mask = ~( '1 << HWORD_SIZE ); 
	const logic [WORD_SIZE-1:0] wop_max = ~( '1 << (WORD_SIZE-1) ); 
	const logic [WORD_SIZE-1:0] wop_min = ( '1 << (WORD_SIZE-1) ); 
	const logic [WORD_SIZE-1:0] bop_max = ~( '1 << (HWORD_SIZE-1) ); 
	const logic [WORD_SIZE-1:0] bop_min = ( '1 << (HWORD_SIZE-1) ); 
  
	typedef logic [WORD_SIZE-1:0] mem_addr_t;
	typedef logic [MEM_WIDTH-1:0] mem_data_t;
	typedef logic [WORD_SIZE-1:0] word_t;
	typedef logic [HWORD_SIZE-1:0] byte_t;
	typedef enum {R0, R1, R2, R3, R4, R5, SP, PC, PSW} register_t;

	// INSTRUCTION SET RELATED
	typedef enum {MOV,MOVB,CMP,CMPB,BIT,BITB,BIC,BICB,BIS,BISB,
		      ADD,SUB,BR,BNE,BEQ,BGE,BLT,BGT,BLE,BPL,BMI,BHI,
		      BLOS,BVC,BVS,BCC,BCS,JSR,RTS,CLR,CLRB,COM,COMB,INC,
		      INCB,DEC,DECB,NEG,NEGB,ADC,ADCB,SBC,SBCB,TST,TSTB,
		      ROR,RORB,ROL,ROLB,ASR,ASRB,ASL,ASLB,JMP,SWAB,HALT,NOP,
		      CLC,CLV,CLZ,CLN,SEC,SEV,SEZ,SEN} opcode_mnemonic;
	
	typedef enum bit {word_op, byte_op} op_size;
	
	// FILE IO
	int debug=1, info=1, console=0, reg_dump=0, print_mem=0;
	typedef enum {DATA_READ=0, DATA_WRITE=1, INST_FETCH=2} mem_access_t;
	typedef enum {mem_debug, mem_file} mem_print_t; 
	//integer mem_trace_f, debug_mem_f, load_mem_f, log_f;
	integer mem_trace_f = $fopen("traces/mem_trace.f", "w");
	integer debug_mem_f = $fopen("traces/debug_mem_trace.f", "w");
	integer load_mem_f = $fopen("traces/load_mem_trace.f", "w");
	integer log_f = $fopen("output.log", "w");
	integer br_f = $fopen("traces/branch_trace.f", "w");
	integer txn_f = $fopen("transaction.log","w");
	integer mem_cont_f = $fopen("traces/memory_contents.log","w");

				  
	typedef logic [2:0] op_t; // instruction opcode
	typedef logic [1:0] op2_t; // sub opcode 

	typedef logic [2:0] mode_t; // addressing mode
	typedef logic [2:0] reg_t; // register address

	typedef logic [7:0] ofst_t; // offset for branch instructions

	const logic [3:0] cnst_br = 4'b000_0; // branch ops leading constant [14:11] = 0_0
	const logic [3:0] cnst_sop = 4'b000_1; // single ops leading constant [14:11] = 0_1
	const logic [9:0] cnst_psop = 10'b0_000_000_010; // program status instructions, leading constant [15:6] = 'o0002
        const logic [12:0] cnst_sys = 13'b0_000_000_000_000; // system instructions leading zeros
	const logic [9:0] cnst_jump = 10'b0_000_000_001; // jump leading constant
	const logic [9:0] cnst_swab = 10'b0_000_000_011; // swab leading constant

	typedef struct packed {
		op_size sz;
		op_t op;
		mode_t smod;
		reg_t sreg;
		mode_t dmod;
		reg_t dreg;
	} dop_t; // double operand instructions 

	typedef struct packed {
		op_size sz;
	        logic [3:0] cnst;
		op2_t typ;
		logic flag;
		ofst_t ofst;
	} brop_t; // branch instructions 

	typedef struct packed {
		op_size sz;
	        logic [3:0] cnst;
		op2_t typ;
		op_t op; // exception: SREG forJSR(typ==0)
		mode_t dmod;
		reg_t dreg;
	} sop_t; // single operand instructions, JSR-jump subroutine, EMT,TRAP-emulator traps

	typedef struct packed {
	        logic [9:0] cnst;
		logic flag; // 1-PSW : 0-RTS
		logic S; // exception: 0 for RTS
		logic N; // exception: 0 for RTS
		logic Z; // exception: SREG[2] for RTS
		logic V; // exception: SREG[1] for RTS
		logic C;  // exception: SREG[0] for RTS
	} psop_t; // PSW flag set/clear instructions, RTS-subroutine return 

	typedef struct packed {
         	logic [12:0] cnst;
		op_t op;
	} sys_t; // RESET,WAIT,HALT,IO,Interrupt system instructions

	typedef struct packed {
	        logic [9:0] cnst;
		mode_t dmod;
		reg_t dreg;
	} jump_t; //  jump instruction 

	typedef struct packed {
	        logic [9:0] cnst;
		mode_t dmod;
		reg_t dreg;
	} swab_t; //  swab instruction 


	typedef enum bit [2:0] {REG,REG_DEF,A_INCR,A_INCR_DEF,A_DEC,A_DEC_DEF,INDEX,INDEX_DEF} amod_t;

        function word_t bsign_ext(word_t in); 
           return ( (signed'(in) << HWORD_SIZE) >>> HWORD_SIZE) ;
        endfunction

	typedef enum bit {NT, T} branch_taken_t;
endpackage

import common_pkg::*;

`define DEFS_DONE
`endif
