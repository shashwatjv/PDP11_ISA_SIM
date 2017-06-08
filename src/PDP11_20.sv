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
InstructionTrans inst_h;		// Instruction handle
InstructionFetch fetch_h;		// Fetch unit handle
InstructionDecode decode_h; 		// Decode unit handle
Execute execute_h;				// Execution unit handle
//Writeback wb_h;				// Writeback unit handle

function new ();
this. mem_h = new();
this.reg_h = new (mem_h);
this.fetch_h = new (mem_h, reg_h);
this.decode_h = new (mem_h, reg_h);
this.execute_h = new(mem_h, reg_h);
endfunction

extern function void LoadMem();
extern task run();
endclass

task PDP11_20::run();
LoadMem();
while (1) begin
	inst_h = fetch_h.run();
	decode_h.run(inst_h);
	execute_h.run(inst_h);
	void'(inst_h.print());
	inst_h = null;
end
endtask

