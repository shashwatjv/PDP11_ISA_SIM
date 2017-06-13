`include "common_pkg.sv"

class InstructionFetch;
InstructionTrans itxn_h;
Memory mem_h;
RegisterFile reg_h;

function new (Memory mem_h, RegisterFile reg_h);
	this.mem_h = mem_h;
	this.reg_h = reg_h;
endfunction

extern function void CreateTransaction();
extern function void GetInstruction();
extern function InstructionTrans run ();
endclass

function void InstructionFetch::CreateTransaction();
itxn_h = new();
endfunction

function void InstructionFetch::GetInstruction();
word_t tempPC;
tempPC = reg_h.Read(PC);
`DEBUG($sformatf("Fetching instruction from PC=%6o", tempPC))
itxn_h.instr_pc = tempPC;
itxn_h.IR = mem_h.GetWord (tempPC, .ifetch(1));
`DEBUG($sformatf("Fetched IR=%6o", itxn_h.IR))
tempPC += 16'o2;
reg_h.Write(PC, tempPC);
`DEBUG($sformatf("After fetch stage, value of PC=%6o", tempPC))

if(reg_dump) begin
$display("\n\nFetched IR=%6o", itxn_h.IR);
$display("Contents of Register File after fetch:");
reg_h.Print(1);
end

endfunction

function InstructionTrans InstructionFetch::run();
CreateTransaction();
GetInstruction();
return itxn_h;
endfunction
