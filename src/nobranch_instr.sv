function void exe_mov(ref InstructionTrans t_h) begin
   result = t_h.src_operand;
   reg_h.SetZ(result == '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetV('0);
   wback(word_op, t_h); // arg: (op_size, xaction_ptr)
end
endfunction // exe_mov

function void exe_movb(ref InstructionTrans t_h) begin
   result = bsign_ext(t_h.src_operand);
   reg_h.SetZ(result == '0);
   reg_h.SetN(result[WSIGN]);
   reg_h.SetV('0);
   wback(byte_op, t_h); // arg: (op_size, xaction_ptr)
end
endfunction // exe_movb

   extern function void exe_cmp(ref InstructionTrans t_h); 
   extern function void exe_cmpb(ref InstructionTrans t_h); 
   extern function void exe_bit(ref InstructionTrans t_h); 
   extern function void exe_bitb(ref InstructionTrans t_h); 
   extern function void exe_bic(ref InstructionTrans t_h); 
   extern function void exe_bicb(ref InstructionTrans t_h); 
   extern function void exe_bis(ref InstructionTrans t_h); 
   extern function void exe_bisb(ref InstructionTrans t_h); 
   extern function void exe_add(ref InstructionTrans t_h); 
   extern function void exe_sub(ref InstructionTrans t_h); 

   extern function void exe_clr(ref InstructionTrans t_h); 
   extern function void exe_clrb(ref InstructionTrans t_h); 
   extern function void exe_com(ref InstructionTrans t_h); 
   extern function void exe_comb(ref InstructionTrans t_h); 
   extern function void exe_inc(ref InstructionTrans t_h); 
   extern function void exe_incb(ref InstructionTrans t_h); 
   extern function void exe_dec(ref InstructionTrans t_h); 
   extern function void exe_decb(ref InstructionTrans t_h); 
   extern function void exe_neg(ref InstructionTrans t_h); 
   extern function void exe_negb(ref InstructionTrans t_h); 
   extern function void exe_adc(ref InstructionTrans t_h); 
   extern function void exe_adcb(ref InstructionTrans t_h); 
   extern function void exe_sbc(ref InstructionTrans t_h); 
   extern function void exe_sbcb(ref InstructionTrans t_h); 
   extern function void exe_tst(ref InstructionTrans t_h); 
   extern function void exe_tstb(ref InstructionTrans t_h); 
   extern function void exe_ror(ref InstructionTrans t_h); 
   extern function void exe_rorb(ref InstructionTrans t_h); 
   extern function void exe_rol(ref InstructionTrans t_h); 
   extern function void exe_rolb(ref InstructionTrans t_h); 
   extern function void exe_asr(ref InstructionTrans t_h); 
   extern function void exe_asrb(ref InstructionTrans t_h); 
   extern function void exe_asl(ref InstructionTrans t_h); 
   extern function void exe_aslb(ref InstructionTrans t_h); 

   extern function void exe_clc(ref InstructionTrans t_h); 
   extern function void exe_clv(ref InstructionTrans t_h); 
   extern function void exe_clz(ref InstructionTrans t_h); 
   extern function void exe_cln(ref InstructionTrans t_h); 
   extern function void exe_sec(ref InstructionTrans t_h); 
   extern function void exe_sev(ref InstructionTrans t_h); 
   extern function void exe_sez(ref InstructionTrans t_h); 
   extern function void exe_sen(ref InstructionTrans t_h); 

   
