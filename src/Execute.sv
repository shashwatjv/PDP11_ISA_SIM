`include "common_pkg.sv";

class Execute;
unsigned longint ICOUNT;
Memory mem_h;
RegisterFile reg_h;
InstructionTrans txn;

extern function void IncrementCount();
extern function void ExitSim();
extern function run();
endclass

function void Execute::IncrementCount();
ICOUNT+=1;
`DEBUG($sformatf("Instructions Executed=%0d", ICOUNT))
endfunction

function void Execute::ExitSim();
`INFO($sformatf("ExitSim:: Total Instructions Executed = %0d", ICOUNT))
assert (ICOUNT===txn.inst_id);
$finish;
endfunction

function void Execute::run();
IncrementCount();
ExitSim();
endfunction
