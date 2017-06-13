/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "common_pkg.sv"

class InstructionTrans;
static int unsigned inst_id = 0; //statistics for instruction count 
string name = "Instruction Transaction";
word_t IR;
opcode_mnemonic opcode_ex; //opcode used by execute state and set by decode 
word_t src_operand;  //for JSR this will contain the contents of the source_reg 
word_t dest_operand; //for JSR this will contain the value which should be loaded into PC 
word_t dest;   //where the final result will go : value is reg if write_reg_en is set and mem loc if write_mem_en is set //for JSR this will contain the name of the register where the actual contents of the PC should be stored 
word_t offset; //shifted and sign extended 
bit write_reg_en; // set to specify a dest as reg   //for JSR this will be set to specify that the value in dest is a register  
bit write_mem_en; //set to specify a dest as mem
word_t result;		//result of the aritmetic 
psop_t old_psw;  //status bits 
psop_t new_psw;  //status bits 
logic N,Z,V,C;		// Easy access to status flags for branch instructions
branch_taken_t br_taken; // 1-bit enum for creating branch trace file
mem_addr_t instr_pc; // The PC value of current instruction
mem_addr_t tgt_addr;
///////////////////for JSR /////////////////////////
// src_operand -  will contain the contents of the source_reg which should be pushed on stack
// dest_operand - will contain the value which should be loaded into PC 
//  dest - will contain the name of the register where the actual contents of the PC should be stored
//write_reg_en will be set : call writeback (dest, PC);
////////////////////////////////////////////////////
//////////////////for RTS  opcode///////////////////
//  src_operand contains the contents of the src reg
//  dest contains the register number where the TOP OF STACK is to be popped into 
//  write_reg_en will be set
//  first restore reg to pc, THEN pop top of stack to reg
///////////////////////////////////////////////////



function new();
inst_id += 1;
`DEBUG($sformatf("%s:Created an instruction transaction with ID:%0d",name,inst_id))
endfunction

extern function string print();
endclass


//will both print and retun a snap shot string of the transaction class
function string InstructionTrans::print();
//function InstructionTrans::print();

string msg;
   msg = $sformatf("\n\n****************************************************************************\n\
                 INSTRUCTION DETAILS\n\
         ID:%0d  PC:%o  INSTRUCTION:%o  OPCODE:%s \n\
         SRC_OP:%o  DEST_OP:%o  OFFSET:%o \n\
         DEST:%o RESULT:%o WR_MEM:%o WR_REG:%o \n\
         TGT_ADDR:%o, BR_TAKEN:%s \n\
         OLD_PSW:%p  NEW_PSW:%p \n\
********************************************************************************\n"
                   ,inst_id,instr_pc, IR, opcode_ex,src_operand,dest_operand,offset,
		   dest,result,write_mem_en,write_reg_en,tgt_addr,br_taken,old_psw,new_psw);
`DEBUG(msg)
`FILE_TRACE(txn_f,msg)
return(msg);

endfunction 

