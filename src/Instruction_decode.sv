/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "common_pkg.sv"

class InstructionDecode;
string name = "InstructionDecode";
Memory mem_h;
RegisterFile regfile_h;
InstructionTrans inst;

function new(Memory mem_h, RegisterFile regfile_h, InstructionTrans inst);
this.mem_h = mem_h;
this.regfile_h = regfile_h;
this.inst = inst;
`DEBUG($sformatf("%s:Created a new InstructionDecode unit",name))
endfunction

extern function void run();
extern function void fetch_operand(mode,register);
extern function word_t read_mem (mem_addr_t addr);  // Instead of this you can directly use mem_h.GetWord or GetByte
extern function word_t read_reg (register_t reg_num); // Instead of this you can directly use reg_h.Read(`R1)
endclass

function void InstructionDecode::run();
// Can simply check inst.IR here and set other fields of inst object
endfunction

function void InstructionDecode::fetch_operand(mode,register);
endfunction

function word_t InstructionDecode::read_mem(mem_addr_t addr);
endfunction

function word_t InstructionDecode::read_reg(register_t reg_num);
endfunction