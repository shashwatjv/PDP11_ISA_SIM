`include "common_pkg.sv"

class InstructionFetch;
InstructionTrans itxn_h;
Memory mem_h;
RegisterFile reg_h;

extern function InstructionTrans CreateTransaction();
extern function void GetInstruction();
endclass

function void InstructionFetch:CreateTransaction();
itxn_h = new();
endfunction

function void InstructionFetch::GetInstruction();
word_t tempPC;
`DEBUG($sformatf("Fetching instruction from PC=%6o", tempPC))
tempPC = reg_h.Read(PC); 
// Check breakpoint array here
itxn_h.IR = mem_h.GetWord (tempPC, ifetch=1);
`DEBUG($sformatf("Fetched IR=%6o", itxn_h.IR))
tempPC += 16'o2;
reg_h.Write(PC, tempPC);
`DEBUG($sformatf("After fetch stage, value of PC=%6o", tempPC))
`DEBUG ("Contents of Register File after fetch:")
reg_h.Print();
endfunction

function InstructionTrans InstructionFetch::run();
CreateTransaction();
GetInstruction();
return itxn_h;
end
