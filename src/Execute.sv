`include "common_pkg.sv"

class Execute;
   longint unsigned ICOUNT;
   Memory mem_h;
   RegisterFile reg_h;
   InstructionTrans txn;

   word_t result; // RESULT of current executed instruction
   logic cy; // carry to catch 17th bit of 16-bit math operations
   
   function new(Memory m_h, RegisterFile r_h);
     ICOUNT = 0;
     this.mem_h = m_h;
     this.reg_h = r_h;
   endfunction // new

   extern function void IncrementCount();
   extern function void ExitSim();
   extern function void run(ref InstructionTrans t_h);

   extern function void wback(op_size bw, ref InstructionTrans t_h);
			      
   extern function void exe_mov(ref InstructionTrans t_h); 
   extern function void exe_movb(ref InstructionTrans t_h); 
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
   extern function void exe_br(ref InstructionTrans t_h); 
   extern function void exe_bne(ref InstructionTrans t_h); 
   extern function void exe_beq(ref InstructionTrans t_h); 
   extern function void exe_bge(ref InstructionTrans t_h); 
   extern function void exe_blt(ref InstructionTrans t_h); 
   extern function void exe_bgt(ref InstructionTrans t_h); 
   extern function void exe_ble(ref InstructionTrans t_h); 
   extern function void exe_bpl(ref InstructionTrans t_h); 
   extern function void exe_bmi(ref InstructionTrans t_h); 
   extern function void exe_bhi(ref InstructionTrans t_h); 
   extern function void exe_blos(ref InstructionTrans t_h); 
   extern function void exe_bvc(ref InstructionTrans t_h); 
   extern function void exe_bvs(ref InstructionTrans t_h); 
   extern function void exe_bcc(ref InstructionTrans t_h); 
   extern function void exe_bcs(ref InstructionTrans t_h); 
   extern function void exe_jsr(ref InstructionTrans t_h); 
   extern function void exe_rts(ref InstructionTrans t_h); 
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
   extern function void exe_jmp(ref InstructionTrans t_h); 
   extern function void exe_swab(ref InstructionTrans t_h); 
   extern function void exe_halt(ref InstructionTrans t_h); 
   extern function void exe_nop(ref InstructionTrans t_h); 
   extern function void exe_clc(ref InstructionTrans t_h); 
   extern function void exe_clv(ref InstructionTrans t_h); 
   extern function void exe_clz(ref InstructionTrans t_h); 
   extern function void exe_cln(ref InstructionTrans t_h); 
   extern function void exe_sec(ref InstructionTrans t_h); 
   extern function void exe_sev(ref InstructionTrans t_h); 
   extern function void exe_sez(ref InstructionTrans t_h); 
   extern function void exe_sen(ref InstructionTrans t_h); 
   extern function mem_addr_t compute_branch_target(ref InstructionTrans t_h);

endclass

`include "nobranch_instr.sv"

function void Execute::IncrementCount();
   ICOUNT+=1;
   `DEBUG($sformatf("\t\tInstructions Executed=%0d", ICOUNT))
endfunction

function void Execute::ExitSim();
   `INFO($sformatf("\t\tExitSim:: Total Instructions Executed = %0d", ICOUNT))
   assert (ICOUNT===txn.inst_id);
   //$finish;
endfunction

function void Execute::wback(op_size bw, ref InstructionTrans t_h);
   
  // store back result in xaction for info/debug
  t_h.result=result;

   if(t_h.write_mem_en) begin
      if(bw == byte_op) begin
	 mem_h.SetByte(mem_addr_t'(t_h.dest), byte_t'(result), 0);
      end else if(bw == word_op) begin
	 mem_h.SetWord(mem_addr_t'(t_h.dest), result, 0);
      end
   end else if(t_h.write_reg_en) begin
      if(bw == byte_op)  begin
	 reg_h.HWrite(register_t'(t_h.dest), result);
      end else if(bw == word_op) begin
	 reg_h.Write(register_t'(t_h.dest), result);
      end
   end
endfunction
  
function void Execute::run(ref InstructionTrans t_h);
   IncrementCount();

   // store previous PSW for log/debug
   t_h.old_psw=reg_h.Read(PSW);

   case(t_h.opcode_ex)

     MOV : exe_mov(t_h); 
     MOVB : exe_movb(t_h); 
     CMP : exe_cmp(t_h); 
     CMPB : exe_cmpb(t_h); 
     BIT : exe_bit(t_h); 
     BITB : exe_bitb(t_h); 
     BIC : exe_bic(t_h); 
     BICB : exe_bicb(t_h); 
     BIS : exe_bis(t_h); 
     BISB : exe_bisb(t_h); 
     ADD : exe_add(t_h); 
     SUB : exe_sub(t_h); 
     BR : exe_br(t_h); 
     BNE : exe_bne(t_h); 
     BEQ : exe_beq(t_h); 
     BGE : exe_bge(t_h); 
     BLT : exe_blt(t_h); 
     BGT : exe_bgt(t_h); 
     BLE : exe_ble(t_h); 
     BPL : exe_bpl(t_h); 
     BMI : exe_bmi(t_h); 
     BHI : exe_bhi(t_h); 
     BLOS : exe_blos(t_h); 
     BVC : exe_bvc(t_h); 
     BVS : exe_bvs(t_h); 
     BCC : exe_bcc(t_h); 
     BCS : exe_bcs(t_h); 
     JSR : exe_jsr(t_h); 
     RTS : exe_rts(t_h); 
     CLR : exe_clr(t_h); 
     CLRB : exe_clrb(t_h); 
     COM : exe_com(t_h); 
     COMB : exe_comb(t_h); 
     INC : exe_inc(t_h); 
     INCB : exe_incb(t_h); 
     DEC : exe_dec(t_h); 
     DECB : exe_decb(t_h); 
     NEG : exe_neg(t_h); 
     NEGB : exe_negb(t_h); 
     ADC : exe_adc(t_h); 
     ADCB : exe_adcb(t_h); 
     SBC : exe_sbc(t_h); 
     SBCB : exe_sbcb(t_h); 
     TST : exe_tst(t_h); 
     TSTB : exe_tstb(t_h); 
     ROR : exe_ror(t_h); 
     RORB : exe_rorb(t_h); 
     ROL : exe_rol(t_h); 
     ROLB : exe_rolb(t_h); 
     ASR : exe_asr(t_h); 
     ASRB : exe_asrb(t_h); 
     ASL : exe_asl(t_h); 
     ASLB : exe_aslb(t_h); 
     JMP : exe_jmp(t_h); 
     SWAB : exe_swab(t_h); 
     HALT : exe_halt(t_h); 
     NOP : exe_nop(t_h); 
     CLC : exe_clc(t_h); 
     CLV : exe_clv(t_h); 
     CLZ : exe_clz(t_h); 
     CLN : exe_cln(t_h); 
     SEC : exe_sec(t_h); 
     SEV : exe_sev(t_h); 
     SEZ : exe_sez(t_h); 
     SEN : exe_sen(t_h); 
     default  : `DEBUG("\t\tUnknown instruction")

   endcase
	
   // store previous PSW for log/debug
   t_h.new_psw=reg_h.Read(PSW);

`DEBUG($sformatf("\t\tresult : %b : %6o : cy : %b",result,result,cy))
`DEBUG("\n\n********************************************************************************\n")
`DEBUG("                   AFTER EXECUTE: Register File:\n")
reg_h.Print();
`DEBUG("\n********************************************************************************\n")
   // do exit if decoded halt instruction
   // ExitSim();
endfunction // run


`include "exe_branch.sv"



