function mem_addr_t Execute::compute_branch_target (ref InstructionTrans t_h);
	mem_addr_t tgt_addr; 
	word_t pc_i;
	pc_i = reg_h.Read(PC);
	tgt_addr = pc_i + t_h.offset;
	
	t_h.N=reg_h.GetN();
	t_h.Z=reg_h.GetZ();
	t_h.V=reg_h.GetV();
	t_h.C=reg_h.GetC();

	// Transaction debug overhead
	t_h.old_psw = reg_h.Read(PSW);
	t_h.new_psw = t_h.old_psw;
	t_h.write_reg_en = 0;
	t_h.write_mem_en = 0;
	return tgt_addr;
endfunction

// UNCONDITIONAL BRANCHES

function void Execute::exe_br (ref InstructionTrans t_h);
	`BR_FUNC(1)
endfunction


// SIMPLE CONDITIONAL BRANCHES

function void Execute::exe_beq (ref InstructionTrans t_h);
	`BR_FUNC(t_h.Z===1)
endfunction

function void Execute::exe_bne (ref InstructionTrans t_h);
	`BR_FUNC(t_h.Z===0)
endfunction

function void Execute::exe_bmi (ref InstructionTrans t_h);
	`BR_FUNC(t_h.N===1)
endfunction

function void Execute::exe_bpl (ref InstructionTrans t_h);
	`BR_FUNC (t_h.N===0)
endfunction

function void Execute::exe_bcs (ref InstructionTrans t_h);
	`BR_FUNC(t_h.C===1)
endfunction

function void Execute::exe_bcc (ref InstructionTrans t_h);
	`BR_FUNC(t_h.C===0)
endfunction

function void Execute::exe_bvs (ref InstructionTrans t_h);
	`BR_FUNC(t_h.V===1)
endfunction

function void Execute::exe_bvc (ref InstructionTrans t_h);
	`BR_FUNC(t_h.V===0)
endfunction


// SIGNED CONDITIONAL BRANCHES

function void Execute::exe_blt (ref InstructionTrans t_h);
	`BR_FUNC((t_h.N ^ t_h.V)===1)
endfunction

function void Execute::exe_bge (ref InstructionTrans t_h);
	`BR_FUNC((t_h.N ^ t_h.V)===0)
endfunction

function void Execute::exe_ble (ref InstructionTrans t_h);
	`BR_FUNC((t_h.Z | (t_h.N ^ t_h.V))===1)
endfunction

function void Execute::exe_bgt (ref InstructionTrans t_h);
	`BR_FUNC((t_h.Z | (t_h.N ^ t_h.V))===0)
endfunction


// UNSIGNED CONDITIONAL BRANCHES

function void Execute::exe_bhi (ref InstructionTrans t_h);
	`BR_FUNC((t_h.C & t_h.Z)===0)
endfunction

function void Execute::exe_blos (ref InstructionTrans t_h);
	`BR_FUNC((t_h.C | t_h.Z)===1)
endfunction


// JUMP INSTRUCTION

function void Execute::exe_jmp (ref InstructionTrans t_h);
// BRANCH TRACE FILE	
endfunction


// SUBROUTINES

function void Execute::exe_jsr (ref InstructionTrans t_h);
// BRANCH TRACE FILE
endfunction

function void Execute::exe_rts (ref InstructionTrans t_h);
// BRANCH TRACE FILE
endfunction


