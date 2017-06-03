/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "defines.sv"
`include "common_pkg.sv"

class RegisterFile;
word_t Regs [9]; // R0, R1, R2, R3, R4, R5, SP, PC, PSW
Memory mem_h;

function new (Memory mem_h);
this.mem_h = mem_h;
endfunction

extern function word_t Read (register_t Source);
extern function void Write(register_t Destination, word_t Data);
extern function void Examine (register_t Destination); 
extern function void Print ();
extern function void SetN(logic);
extern function void SetZ(logic);
extern function void SetV(logic);
extern function void SetC(logic);
extern function logic GetN();
extern function logic GetZ();
extern function logic GetV();
extern function logic GetC();
   
endclass

function word_t RegisterFile::Read (register_t Source);
endfunction

function void RegisterFile::Write(register_t Destination, word_t Data);
endfunction

function void RegisterFile::Examine (register_t Destination); // Print a particular register for debug
endfunction

function void RegisterFile::Print (); // Print the contents of register file in octal
endfunction

function void RegisterFile::SetN(logic N)
  this.Regs[PSW][`PSW_N] = N;
endfunction // SetN

function void RegisterFile::SetZ(logic Z)
  this.Regs[PSW][`PSW_Z] = Z;
endfunction // SetZ

function void RegisterFile::SetV(logic V)
  this.Regs[PSW][`PSW_V] = V;
endfunction // SetV

function void RegisterFile::SetC(logic C)
  this.Regs[PSW][`PSW_C] = C;
endfunction // SetC

function logic RegisterFile::GetN()
  return (this.Regs[PSW][`PSW_N]);
endfunction // GetN

function logic RegisterFile::GetZ()
  return (this.Regs[PSW][`PSW_Z]);
endfunction // GetZ

function logic RegisterFile::GetV()
  return (this.Regs[PSW][`PSW_V]);
endfunction // GetV

function logic RegisterFile::GetC()
  return (this.Regs[PSW][`PSW_C]);
endfunction // GetC




