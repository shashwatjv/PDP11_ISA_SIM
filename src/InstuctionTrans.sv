/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "common_pkg.sv"

class InstructionTrans;
static int unsigned inst_id = 0;
string name = "Instruction Transaction";
word_t IR;
opcode_mnemonic opcode_ex;
word_t src_operand;
word_t dest_operand;
word_t dest;
word_t offset;
bit write_reg_en;
bit write_mem_en;
word_t result;
register_t old_psw;
register_t new_psw;

function new();
inst_id += 1;
`DEBUG($sformatf("%s:Created an instruction transaction with ID:%0d",name,inst_id))
endfunction

extern function void print();
endclass

function void InstructionTrans::print();

string msg;
msg = $sformatf("ID:%5d\tINSTRUCTION:%o\tOPCODE:%s\n",inst_id,IR,opcode_ex);
`DEBUG(msg)

endfunction 
