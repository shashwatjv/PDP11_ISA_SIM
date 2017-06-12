/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "common_pkg.sv"
//import common_pkg::*;
//



class Memory;
byte_t mem [mem_addr_t];
bit  breakpoint [mem_addr_t];
bit valid [mem_addr_t]; 

extern function void SetWord (mem_addr_t Address, word_t Data, bit MemLoad=FALSE, bit log=1);
extern function void SetByte (mem_addr_t Address, byte_t Data, bit log=1);
extern function word_t GetWord (mem_addr_t Address, bit ifetch=0, bit log=1);
extern function byte_t GetByte (mem_addr_t Address, bit log=1);
extern function void ExamineWord (mem_addr_t Address); // prints the contents of memory address
extern function void Print (mem_print_t mode); // 
extern function bit isBreakpoint (mem_addr_t Address); // returns 1 if breakpoint set for address
endclass



function void Memory::SetByte (mem_addr_t Address, byte_t Data, bit log=1);
mem_access_t AccessType;
`DEBUG($sformatf("\t \tSetByte: Address=%o, Data=%o", Address, Data))
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
`DEBUG($sformatf("\t\tSetWord: Address=%o, Data=%o", Address, Data))

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

AccessType = ifetch ? INST_FETCH : DATA_READ;

assert (Address[0]==1'b0)
else `INFO("SetWord:: Unaligned word access")

for (int i=0; i<(WORD_SIZE/MEM_WIDTH); i++) begin
//for (int i=0; i<2; i++) begin
	Data[(i*MEM_WIDTH)+:MEM_WIDTH] = mem[Address+i];
	valid[Address+i] = 1;
	//`DEBUG($sformatf("Inner loop: Data=%6o, Mem=%6o", Data, mem[Address+i]))
end

if (log===1) begin
`MEM_TRACE($sformatf("%0d \t %6o", AccessType, Address))
`DEBUG_MEM_TRACE($sformatf("%s \t %6o \t %6o", AccessType, Address, Data))
end
`DEBUG($sformatf("\t\tGetWord: Returning Data: %6o from Address: %6o", Data, Address))
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
`DEBUG($sformatf("\t\tGetByte: Returning Data: %6o from Address: %o", Data, Address))
return Data;
endfunction



function void Memory::ExamineWord (mem_addr_t Address); // prints the contents of memory location
endfunction


function void Memory::Print (mem_print_t mode); // Print Contents of valid memory locations
	string msg;
	mem_addr_t idx;
	if (mem.first(idx)) begin
		do begin
		        if(idx%2) msg = $sformatf ("\tMem[%6o] : %3o", idx, mem[idx]);
		        else begin
			   if(mem.exists(idx+1)) msg = $sformatf ("\tMem[%6o] : %3o \t WORD[%6o] : %6o", idx, mem[idx],idx,{mem[idx+1],mem[idx]});
			   else msg = $sformatf ("\tMem[%6o] : %3o \t WORD[%6o] : ---%3o", idx, mem[idx],idx,mem[idx]);
			end
			case (mode)
			mem_debug: `DEBUG(msg)
			mem_file:  `FILE_TRACE(mem_cont_f, msg)
			endcase
		end
		while (mem.next(idx));
	end
endfunction


function bit Memory::isBreakpoint (mem_addr_t Address); // 
endfunction
