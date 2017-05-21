/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

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
endclass



function word_t RegisterFile::Read (register_t Source);
endfunction

function void RegisterFile::Write(register_t Destination, word_t Data);
endfunction

function void RegisterFile::Examine (register_t Destination); // Print a particular register for debug
endfunction

function void RegisterFile::Print (); // Print the contents of register file in octal
endfunction