`include "common_pkg.sv";

class Execute;
string name = "Execution Unit";
longint unsigned ICOUNT;
Memory mem_h;
RegisterFile reg_h;
InstructionTrans txn;

function new(Memory mem_h, RegisterFile regfile_h);
//this.name=name;
this.mem_h = mem_h;
this.reg_h = regfile_h;
`DEBUG($sformatf("%s:Created a new InstructionExecution unit", name))
endfunction

extern function void IncrementCount();
extern function void ExitSim();
extern function void run(InstructionTrans txn);
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

function void Execute::run(InstructionTrans txn);
this.txn = txn;
IncrementCount();
ExitSim();
endfunction
