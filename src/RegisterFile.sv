/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

//`include "defines.sv"
//`include "common_pkg.sv"

import common_pkg::*;
class RegisterFile;
local word_t Regs [9]; // R0, R1, R2, R3, R4, R5, SP, PC, PSW
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
extern function mem_addr_t RegMemMap(register_t Source);
extern function void HWrite(register_t Destination, word_t Data);
endclass

function void RegisterFile::HWrite(register_t Destination, word_t Data);
mem_addr_t address;
Regs[Destination][HWORD_SIZE-1:0] = Data [HWORD_SIZE-1:0];
address = RegMemMap (Destination);
mem_h.SetWord (address, Regs[Destination][HWORD_SIZE-1:0], .log(0));
endfunction

function word_t RegisterFile::Read (register_t Source);
word_t Data;
Data = Regs[Source];
`DEBUG($sformatf("Read %6o from %s", Data, Source))
return Data;
endfunction

function void RegisterFile::Write(register_t Destination, word_t Data);
mem_addr_t address;
address = RegMemMap (Destination);
mem_h.SetWord (address, Data, .log(0));
Regs[Destination]=Data;
`DEBUG($sformatf("Writing %6o to %s", Data, Destination))
endfunction

function void RegisterFile::Examine (register_t Destination); // Print a particular register for debug
`DEBUG($sformatf("Regs[%s]: %6o", Destination, Read(Destination)))
endfunction

function void RegisterFile::Print (); // Print the contents of register file in octal
Examine (R0);
Examine (R1);
Examine (R2);
Examine (R3);
Examine (R4);
Examine (R5);
Examine (SP);
Examine (PC);
Examine (PSW);
endfunction

function void RegisterFile::SetN(logic N);
  Regs[PSW][`PSW_N] = N;
  Write(PSW, Regs[PSW]);
  `DEBUG($sformatf("Setting N=%b", N))
endfunction // SetN

function void RegisterFile::SetZ(logic Z);
  this.Regs[PSW][`PSW_Z] = Z;
  Write(PSW, Regs[PSW]);
  `DEBUG($sformatf("Setting Z=%b", Z))
endfunction // SetZ

function void RegisterFile::SetV(logic V);
  this.Regs[PSW][`PSW_V] = V;
  Write(PSW, Regs[PSW]);
  `DEBUG($sformatf("Setting V=%b", V))
endfunction // SetV

function void RegisterFile::SetC(logic C);
  this.Regs[PSW][`PSW_C] = C;
  Write(PSW, Regs[PSW]);
  `DEBUG($sformatf("Setting C=%b", C))
endfunction // SetC

function logic RegisterFile::GetN();
  return (this.Regs[PSW][`PSW_N]);
endfunction // GetN

function logic RegisterFile::GetZ();
  return (this.Regs[PSW][`PSW_Z]);
endfunction // GetZ

function logic RegisterFile::GetV();
  return (this.Regs[PSW][`PSW_V]);
endfunction // GetV

function logic RegisterFile::GetC();
  return (this.Regs[PSW][`PSW_C]);
endfunction // GetC

function mem_addr_t RegisterFile::RegMemMap(register_t Source);
	case (Source)
		R0: return `R0_MLOC;
		R1: return `R1_MLOC;
		R2: return `R2_MLOC;
		R3: return `R3_MLOC;
		R4: return `R4_MLOC;
		R5: return `R5_MLOC;
		SP: return `SP_MLOC;
		PC: return `PC_MLOC;
		PSW: return `PSW_MLOC;
		default: `DEBUG ("Illegal register source")
	endcase
endfunction


