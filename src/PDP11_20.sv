/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/
`include "common_pkg.sv"

class PDP11_20;

Memory mem_h;				// Memory handle
RegisterFile reg_h;			// Register File handle
InstructionTrans inst_h;	// Instruction handle
InstructionDecode decode_h; 			// Decode unit handle
//Execute exec_h;				// Execution unit handle

function new ();
this. mem_h = new();
this.reg_h = new (mem_h);
this.inst_h = new ();
this.decode_h = new (mem_h, reg_h, inst_h);
//this.exec_h = new();
endfunction

extern function void LoadMem();
extern function void InstructionFetch();
extern function void Run();
endclass

function void PDP11_20::Run();
LoadMem();
//while (1) begin
	InstructionFetch();
	decode_h.run();
	//execute_h.run();
//end
endfunction

function void PDP11_20::InstructionFetch();
word_t tempPC;
`DEBUG($sformatf("Fetching instruction from PC=%6o", tempPC))
tempPC = reg_h.Read(PC); 
inst_h.IR = mem_h.GetWord (tempPC);
`DEBUG($sformatf("Fetched IR=%6o", inst_h.IR))
tempPC += 16'o2;
reg_h.Write(PC, tempPC);
`DEBUG($sformatf("After fetch stage, value of PC=%6o", tempPC))
`DEBUG ("Contents of Register File after fetch:")
reg_h.Print();
endfunction