/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "common_pkg.sv"
//import common_pkg::*;
class Memory;
byte_t mem [mem_addr_t];
bit  breakpoint [mem_addr_t];
bit valid [mem_addr_t]; 

extern function void SetWord (mem_addr_t Address, word_t Data, bit MemLoad=FALSE, bit log=1);
extern function void SetByte (mem_addr_t Address, byte_t Data, bit log=1);
extern function word_t GetWord (mem_addr_t Address, bit ifetch=0, bit log=1);
extern function byte_t GetByte (mem_addr_t Address, bit log=1);
extern function void ExamineWord (mem_addr_t Address); // prints the contents of memory address
extern function void Print (bit Mode); // 
extern function bit isBreakpoint (mem_addr_t Address); // returns 1 if breakpoint set for address
endclass



function void Memory::SetByte (mem_addr_t Address, byte_t Data, bit log=1);
mem_access_t AccessType;
AccessType = DATA_WRITE;
mem[Address] = Data; 
valid[Address] = 1;
if (log===1) begin
`MEM_TRACE($sformatf("%0d \t %6o", AccessType, Address))
`DEBUG_MEM_TRACE($sformatf("%s \t %6o \t %6o", AccessType, Address, Data))
end
endfunction


function void Memory::SetWord (mem_addr_t Address, word_t Data, bit MemLoad=FALSE, bit log=1);
mem_access_t AccessType;

AccessType = DATA_WRITE;

assert (Address[0]==1'b0)
else `INFO("SetWord:: Unaligned word access")

for (int i=0; i<=(WORD_SIZE/MEM_WIDTH)-1; i++) begin
	mem[Address+i] = Data[(i*MEM_WIDTH)+:MEM_WIDTH];
	valid[Address+i] = 1;
	if (MemLoad==TRUE) begin
		`LOAD_MEM_TRACE($sformatf("%6o \t %3o", Address+i, mem[Address+i]))
	end
end

if (MemLoad==FALSE && log==1) begin
`MEM_TRACE($sformatf("%0d \t %6o", AccessType, Address))
`DEBUG_MEM_TRACE($sformatf("%s \t %6o \t %6o", AccessType, Address, Data))
end
endfunction



function word_t Memory::GetWord (mem_addr_t Address, bit ifetch=0, bit log=1);
mem_access_t AccessType;
word_t Data;

$display ("Call to get-word: Address=%x", Address);
AccessType = ifetch ? INSTRUCTION_FETCH : DATA_READ;

assert (Address[0]==1'b0)
else `INFO("SetWord:: Unaligned word access")

for (int i=0; i<(WORD_SIZE/MEM_WIDTH)-1; i++) begin
	Data[(i*MEM_WIDTH)+:MEM_WIDTH] = mem[Address+i];
	valid[Address+i] = 1;
end

if (log===1) begin
`MEM_TRACE($sformatf("%0d \t %6o", AccessType, Address))
`DEBUG_MEM_TRACE($sformatf("%s \t %6o \t %6o", AccessType, Address, Data))
end
return Data;
endfunction



function byte_t Memory::GetByte (mem_addr_t Address, bit log=1);
mem_access_t AccessType;
byte_t Data;
AccessType = DATA_READ;
assert (valid[Address]==1);
Data = mem[Address]; 
if (log===1) begin
`MEM_TRACE($sformatf("%0d \t %6o", AccessType, Address))
`DEBUG_MEM_TRACE($sformatf("%s \t %6o \t %6o", AccessType, Address, Data))
end
return Data;
endfunction



function void Memory::ExamineWord (mem_addr_t Address); // prints the contents of memory location
endfunction


function void Memory::Print (bit Mode); // 
endfunction


function bit Memory::isBreakpoint (mem_addr_t Address); // 
endfunction
