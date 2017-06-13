function void Execute::exe_mov(ref InstructionTrans t_h);
   result = t_h.src_operand;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV('0);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_mov

function void Execute::exe_movb(ref InstructionTrans t_h);
   result = bsign_ext(t_h.src_operand);
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV('0);
   if(t_h.write_reg_en) wback(word_op, t_h); // arg: (op_size, xaction_ptr)
   else wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_movb

function void Execute::exe_cmp(ref InstructionTrans t_h);
   word_t d2s;
   d2s = -t_h.dest_operand;
   {cy,result} = t_h.src_operand + d2s;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(~cy);
   reg_h.SetV((t_h.src_operand[WSIGN] ^ t_h.dest_operand[WSIGN]) &&
	      (result[WSIGN] ~^ t_h.dest_operand[WSIGN]));
endfunction // exe_cmp

function void Execute::exe_cmpb(ref InstructionTrans t_h);
   word_t d,d2s;
   d=bsign_ext(t_h.dest_operand);
   d2s = -d;
   {cy,result} = bsign_ext(t_h.src_operand) + d2s;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(~cy);
   reg_h.SetV((t_h.src_operand[BSIGN] ^ t_h.dest_operand[BSIGN]) &&
	      (result[WSIGN] ~^ t_h.dest_operand[BSIGN]));
endfunction // exe_cmpb

function void Execute::exe_bit(ref InstructionTrans t_h);
   result = t_h.src_operand & t_h.dest_operand;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV('0);
endfunction // exe_bit

function void Execute::exe_bitb(ref InstructionTrans t_h);
   result = t_h.src_operand & t_h.dest_operand;
   reg_h.SetZ((result & bop_mask) === '0);
   reg_h.SetN(result[BSIGN]);
   // no change to C flag
   reg_h.SetV('0);
endfunction // exe_bitb

function void Execute::exe_bic(ref InstructionTrans t_h);
   result = ~(t_h.src_operand) & t_h.dest_operand;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV('0);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_bic

function void Execute::exe_bicb(ref InstructionTrans t_h);
   result = ~(t_h.src_operand) & t_h.dest_operand;
   reg_h.SetZ((result & bop_mask) === '0);
   reg_h.SetN(result[BSIGN]);
   // no change to C flag
   reg_h.SetV('0);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_bicb

function void Execute::exe_bis(ref InstructionTrans t_h);
   result = t_h.src_operand | t_h.dest_operand;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV('0);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_bis

function void Execute::exe_bisb(ref InstructionTrans t_h);
   result = t_h.src_operand | t_h.dest_operand;
   reg_h.SetZ((result & bop_mask) === '0);
   reg_h.SetN(result[BSIGN]);
   // no change to C flag
   reg_h.SetV('0);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_bisb

function void Execute::exe_add(ref InstructionTrans t_h);
   {cy,result} = t_h.src_operand + t_h.dest_operand;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV((t_h.src_operand[WSIGN] ~^ t_h.dest_operand[WSIGN]) &&
	      (result[WSIGN] ^ t_h.dest_operand[WSIGN]));
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_add

function void Execute::exe_sub(ref InstructionTrans t_h);
   word_t s2;
   s2 = -t_h.src_operand;
   {cy,result} = t_h.dest_operand + s2;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(~cy);
   reg_h.SetV((t_h.src_operand[WSIGN] ^ t_h.dest_operand[WSIGN]) &&
	      (result[WSIGN] ~^ t_h.src_operand[WSIGN]));
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_sub

function void Execute::exe_clr(ref InstructionTrans t_h);
   result = '0;
   reg_h.SetZ('1);
   reg_h.SetN('0);
   reg_h.SetC('0);
   reg_h.SetV('0);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_clr

function void Execute::exe_clrb(ref InstructionTrans t_h);
   result = '0;
   reg_h.SetZ('1);
   reg_h.SetN('0);
   reg_h.SetC('0);
   reg_h.SetV('0);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_clrb

function void Execute::exe_com(ref InstructionTrans t_h);
   result = ~(t_h.dest_operand);
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC('1);
   reg_h.SetV('0);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_com

function void Execute::exe_comb(ref InstructionTrans t_h);
   result = ~(bsign_ext(t_h.dest_operand));
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC('1);
   reg_h.SetV('0);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_comb

function void Execute::exe_inc(ref InstructionTrans t_h);
   result = t_h.dest_operand + 1'b1;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV(t_h.dest_operand === wop_max);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_inc

function void Execute::exe_incb(ref InstructionTrans t_h);
   result = bsign_ext(t_h.dest_operand) + 1'b1;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV(bsign_ext(t_h.dest_operand) === bop_max);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_incb

function void Execute::exe_dec(ref InstructionTrans t_h);
   result = t_h.dest_operand - 1'b1;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to V flag
   reg_h.SetC(t_h.dest_operand === wop_min);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_dec

function void Execute::exe_decb(ref InstructionTrans t_h);
   result = bsign_ext(t_h.dest_operand) - 1'b1;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   // no change to C flag
   reg_h.SetV(t_h.dest_operand === bop_min);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_decb

function void Execute::exe_neg(ref InstructionTrans t_h);
   result = -(signed'(t_h.dest_operand));
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(|result);
   reg_h.SetV(result === wop_min);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_neg

function void Execute::exe_negb(ref InstructionTrans t_h);
   result = -(signed'(bsign_ext(t_h.dest_operand)));
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(|result);
   reg_h.SetV(result === bop_min);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_negb

function void Execute::exe_adc(ref InstructionTrans t_h);
   bit c;
   c = reg_h.GetC();
   result = t_h.dest_operand + c;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(c && (t_h.dest_operand === '1));
   reg_h.SetV(c && (t_h.dest_operand === wop_max));
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_adc

function void Execute::exe_adcb(ref InstructionTrans t_h);
   bit c;
   c = reg_h.GetC();
   result = bsign_ext(t_h.dest_operand) + c;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(c && (bsign_ext(t_h.dest_operand) === '1));
   reg_h.SetV(c && (bsign_ext(t_h.dest_operand) === bop_max));
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_adcb

function void Execute::exe_sbc(ref InstructionTrans t_h);
   bit c;
   c = reg_h.GetC();
   result = t_h.dest_operand - c;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(!(c && (result === '0)));
   reg_h.SetV(result === wop_min);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_sbc

function void Execute::exe_sbcb(ref InstructionTrans t_h);
   bit c;
   c = reg_h.GetC();
   result = bsign_ext(t_h.dest_operand) - c;
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(!(c && (result === '0)));
   reg_h.SetV(result === bop_min);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_sbcb

function void Execute::exe_tst(ref InstructionTrans t_h);
   result = -(signed'(t_h.dest_operand));
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC('0);
   reg_h.SetV('0);
endfunction // exe_tst

function void Execute::exe_tstb(ref InstructionTrans t_h);
   result = -(signed'(bsign_ext(t_h.dest_operand)));
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC('0);
   reg_h.SetV('0);
endfunction // exe_tstb

function void Execute::exe_ror(ref InstructionTrans t_h);
   bit c;
   c = reg_h.GetC();
   cy = t_h.dest_operand[LSB];
   result = {c,t_h.dest_operand[1 +: WORD_SIZE-1]};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[WSIGN]);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_ror

function void Execute::exe_rorb(ref InstructionTrans t_h); 
   bit c;
   c = reg_h.GetC();
   cy = t_h.dest_operand[LSB];
   result = {t_h.dest_operand[HWORD_SIZE +: HWORD_SIZE], c, t_h.dest_operand[1 +: HWORD_SIZE-1]};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[BSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[BSIGN]);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_rorb

function void Execute::exe_rol(ref InstructionTrans t_h);
   bit c;
   c = reg_h.GetC();
   {cy,result} = {t_h.dest_operand,c};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[WSIGN]);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_rol
   
function void Execute::exe_rolb(ref InstructionTrans t_h); 
   bit c;
   c = reg_h.GetC();
   cy = t_h.dest_operand[BSIGN];
   result = {t_h.dest_operand,c};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[BSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[BSIGN]);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_rolb

function void Execute::exe_asr(ref InstructionTrans t_h);
   cy = t_h.dest_operand[LSB];
   result = {t_h.dest_operand[WSIGN],t_h.dest_operand[1 +: (WORD_SIZE-1)]};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[WSIGN]);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_asr
      
function void Execute::exe_asrb(ref InstructionTrans t_h); 
   cy = t_h.dest_operand[LSB];
   result = {t_h.dest_operand[HWORD_SIZE-1 +: HWORD_SIZE+1], t_h.dest_operand[1 +: HWORD_SIZE-1]};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[BSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[BSIGN]);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_asrb

function void Execute::exe_asl(ref InstructionTrans t_h);
   {cy,result} = {t_h.dest_operand, 1'b0};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[WSIGN]);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_asl
	 
function void Execute::exe_aslb(ref InstructionTrans t_h);
   cy = t_h.dest_operand[BSIGN];
   result = {t_h.dest_operand, 1'b0};
   reg_h.SetZ(result === '0);
   reg_h.SetN(result[BSIGN]);
   reg_h.SetC(cy);
   reg_h.SetV(cy ^ result[BSIGN]);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_aslb

function void Execute::exe_swab(ref InstructionTrans t_h);
   // add assertion to check even address
   
   result = {t_h.dest_operand[LSB +: HWORD_SIZE], t_h.dest_operand[HWORD_SIZE +: HWORD_SIZE]};
   reg_h.SetZ(result[LSB +: HWORD_SIZE] === '0);
   reg_h.SetN(result[BSIGN]);
   reg_h.SetC('0);
   reg_h.SetV('0);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
endfunction // exe_swab

function void Execute::exe_clc(ref InstructionTrans t_h);
   reg_h.SetC('0);
endfunction // exe_clc

function void Execute::exe_clv(ref InstructionTrans t_h); 
   reg_h.SetV('0);
endfunction // exe_clv

function void Execute::exe_clz(ref InstructionTrans t_h); 
   reg_h.SetZ('0);
endfunction // exe_clz

function void Execute::exe_cln(ref InstructionTrans t_h); 
   reg_h.SetN('0);
endfunction // exe_cln

function void Execute::exe_sec(ref InstructionTrans t_h); 
   reg_h.SetC('1);
endfunction // exe_sec

function void Execute::exe_sev(ref InstructionTrans t_h); 
   reg_h.SetV('1);
endfunction // exe_sev

function void Execute::exe_sez(ref InstructionTrans t_h); 
   reg_h.SetZ('1);
endfunction // exe_sez

function void Execute::exe_sen(ref InstructionTrans t_h); 
   reg_h.SetN('1);
endfunction // exe_sen

function void Execute::exe_halt(ref InstructionTrans t_h);
   reg_h.Print();
   mem_h.Print(mem_file);
   $display("\n Instructions Executed = %0d \n",ICOUNT);
   ExitSim();
   $stop();
endfunction // exe_halt

function void Execute::exe_nop(ref InstructionTrans t_h);
   $display("\n Executed NOP at Instruction Count = %0d \n",ICOUNT);
endfunction // exe_nop



				    
