/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "common_pkg.sv"

class Memory;
byte_t mem [mem_addr_t];
bit  breakpoint [mem_addr_t];
bit valid [mem_addr_t]; 

extern function void SetWord (mem_addr_t Address, word_t Data, bit MemLoad=FALSE);
extern function void SetByte (mem_addr_t Address, byte_t Data);
extern function word_t GetWord (mem_addr_t Address);
extern function byte_t GetByte (mem_addr_t Address);
extern function void ExamineWord (mem_addr_t Address); // prints the contents of memory location
extern function void Print (bit Mode); // 
extern function bit isBreakpoint (mem_addr_t Address); // returns 1 if breakpoint set for that memory location
endclass



function void Memory::SetByte (mem_addr_t Address, byte_t Data);
mem_access_t AccessType;
AccessType = DATA_WRITE;
mem[Address] = Data; 
valid[Address] = 1;
`MEM_TRACE($sformatf("%0d \t %6o", AccessType, Address))
`DEBUG_MEM_TRACE($sformatf("%s \t %6o \t %6o", AccessType, Address, Data))
endfunction


function void Memory::SetWord (mem_addr_t Address, word_t Data, bit MemLoad=FALSE);
mem_access_t AccessType;
AccessType = DATA_WRITE;
for (int i=0; i<=1; i++) begin
	mem[Address+i] = Data[(i*MEM_WIDTH)+:MEM_WIDTH];
	valid[Address+i] = 1;
	if (MemLoad==TRUE) begin
		`LOAD_MEM_TRACE($sformatf("%6o \t %3o", Address, mem[Address+i]))
	end
end
if (MemLoad==FALSE) begin
`MEM_TRACE($sformatf("%0d \t %6o", AccessType, Address))
`DEBUG_MEM_TRACE($sformatf("%s \t %6o \t %6o", AccessType, Address, Data))
end
endfunction

function word_t Memory::GetWord (mem_addr_t Address);
endfunction

function byte_t Memory::GetByte (mem_addr_t Address);
endfunction

function void Memory::ExamineWord (mem_addr_t Address); // prints the contents of memory location
endfunction

function void Memory::Print (bit Mode); // 
endfunction

function bit Memory::isBreakpoint (mem_addr_t Address); // 
endfunction