/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/
/*
`define S single_op()
`define D double_op()
`define B branch()
`define OP(x,y) inst.opcode_ex = bw ? x : y
`define OP1(x)  inst.opcode_ex = x
`define OPS(x,y)  `OP(x,y); \ 
		   `S 
`define OPD(x,y)  `OP(x,y);\
		   `D
`define OPB(x)    `OP1(x);\
		   `B
*/

`define S single_op()
`define D double_op()
`define B branch()

`define OP(a,b) inst.opcode_ex = inst.IR[15] ? a : b

`define OP1(a) inst.opcode_ex = a

`define OPS(a,b) inst.opcode_ex = inst.IR[15] ? a : b;single_op()

`define OPD(a,b) inst.opcode_ex = inst.IR[15] ? a : b;double_op()

`define OPB(a) inst.opcode_ex = a;branch()		

`define reg_write(x,y) regfile_h.Write(register_t'(x),y)  

//`include "common_pkg.sv"

import common_pkg::*;
class InstructionDecode;
string name;
string inst_num;
Memory mem_h;
RegisterFile regfile_h;
InstructionTrans inst;
typedef enum {SRC,DST} am;
typedef logic [7:0] radr_t;

function new(Memory mem_h, RegisterFile regfile_h);
this.mem_h = mem_h;
this.regfile_h = regfile_h;
`DEBUG($sformatf("%s:Created a new InstructionDecode unit",name))
endfunction

extern task run(InstructionTrans inst);
extern task identify_inst_format();
extern task double_op();
extern task single_op();
extern task subroutine();
extern task branch();
extern task r_subroutine();
extern task decode_src_am(op_size b_w,amod_t am_s,radr_t rs_num);
extern task decode_dest_am(op_size b_w,amod_t am_d,radr_t rd_num);
extern task fetch_operand(input op_size b_w,amod_t mode,radr_t register,am src_dest,output word_t return_value,word_t dst,bit reg_vld,bit mem_vld);
extern function word_t read_mem (op_size b_w,mem_addr_t addr);  
extern function word_t read_reg (op_size b_w,radr_t reg_num); 
extern function word_t inc_dec_reg(op_size b_w,amod_t mode,radr_t register);
endclass


//copies the passed handle to local handle
task InstructionDecode::run(InstructionTrans inst);
this.inst = inst;
inst_num = $sformatf("ID %0d::",inst.inst_id);
//name = {"Decode::",inst_num};
name = {inst_num};
	`DEBUG($sformatf("\n\n############################### START INSTRUCTION DECODE PHASE: INSTRUCTION NUMBER : %0d ###############################\n",inst.inst_id))
	//`INFO($sformatf("\n\n############################### START INSTRUCTION DECODE PHASE: INSTRUCTION NUMBER : %0d ###############################\n",inst.inst_id))
identify_inst_format();
endtask


/////////assigns the opcode_ex field of the trasanction class and calls the respective task depinding on the Instruction format 

task InstructionDecode::identify_inst_format();


	`DEBUG($sformatf("%s IDENTIFY_INST_FORMAT:RECEIVED INSTRUCTION OF %o\n",name,inst.IR))
	      

	priority case (inst.IR) inside //{

	16'o000000	:	begin //{
					`OP1(HALT);
					end //}
	16'o00020?	:	begin //{
					`OP1(RTS);
					r_subroutine();
					end //}
	16'o004???	:	begin //{
					`OP1(JSR);
					subroutine();
					end //}
	16'o?050??	:	begin //{
					`OPS(CLRB,CLR);
					end //}
	16'o?051??	:	begin //{
					`OPS(COMB,COM);
					end //}
	16'o?052??	:	begin //{
					`OPS(INCB,INC);
					end //}
	16'o?053??	:	begin //{
					`OPS(DECB,DEC);
					end //}
	16'o?054??	:	begin //{
					`OPS(NEGB,NEG);
					end //}
	16'o?055??	:	begin //{
					`OPS(ADCB,ADC);
					end //}
	16'o?056??	:	begin //{
					`OPS(SBCB,SBC);
					end //}
	16'o?057??	:	begin //{
					`OPS(TSTB,TST);
					end //}
	16'o?060??	:	begin //{
					`OPS(RORB,ROR);
					end //}
	16'o?061??	:	begin //{
					`OPS(ROLB,ROL);
					end //}
	16'o?062??	:	begin //{
					`OPS(ASRB,ASR);
					end //}
	16'o?063??	:	begin //{
					`OPS(ASLB,ASL);
					end //}
	16'o0001??	:	begin //{
					`OP1(JMP);
					`S;
					end //}
	16'o0003??	:	begin //{
					`OP1(SWAB);
					`S;
					end //}
	{8'h01,8'h??}	:	begin //{
					`OPB(BR);
					end //}
	{8'h02,8'h??}	:	begin //{
					`OPB(BNE);
					end //}
	{8'h03,8'h??}	:	begin //{
					`OPB(BEQ);
					end //}
	{8'h04,8'h??}	:	begin //{
					`OPB(BGE);
					end //}
	{8'h05,8'h??}	:	begin //{
					`OPB(BLT);
					end //}
	{8'h06,8'h??}	:	begin //{
					`OPB(BGT);
					end //}
	{8'h07,8'h??}	:	begin //{
					`OPB(BLE);
					end //}
	{8'h80,8'h??}	:	begin //{
					`OPB(BPL);
					end //}
	{8'h81,8'h??}	:	begin //{
					`OPB(BMI);
					end //}
	{8'h82,8'h??}	:	begin //{
					`OPB(BHI);
					end //}
	{8'h83,8'h??}	:	begin //{
					`OPB(BLOS);
					end //}
	{8'h84,8'h??}	:	begin //{
					`OPB(BVC);
					end //}
	{8'h85,8'h??}	:	begin //{
					`OPB(BVS);
					end //}
	{8'h86,8'h??}	:	begin //{
					`OPB(BCC);
					end //}
	{8'h87,8'h??}	:	begin //{
					`OPB(BCS);
					end //}
	16'o?1????	:	begin //{
					`OPD(MOVB,MOV);
					end //}
	16'o?2????	:	begin //{
					`OPD(CMPB,CMP);
					end //}
	16'o?3????	:	begin //{
					`OPD(BITB,BIT);
					end //}
	16'o?4????	:	begin //{
					`OPD(BICB,BIC);
					end //}
	16'o?5????	:	begin //{
					`OPD(BISB,BIS);
					end //}
	16'o06????	:	begin //{
					`OP1(ADD);
					`D;
					end //}
	16'o16????	:	begin //{
					`OP1(SUB);
					`D;
					end //}
	16'o000241	:	begin //{
					`OP1(CLC);
				end //}
	16'o000242	:	begin //{
					`OP1(CLV);
				end //}
	16'o000244	:	begin //{
					`OP1(CLZ);
				end //}
	16'o000250	:	begin //{
					`OP1(CLN);
				end //}
	16'o000261	:	begin //{
					`OP1(SEC);
				end //}
	16'o000262	:	begin //{
					`OP1(SEV);
				end //}
	16'o000264	:	begin //{
					`OP1(SEZ);
				end //}
	16'o000270	:	begin //{
					`OP1(SEN);
				end //}
	16'o??????	: 	begin //{
					`DEBUG($sformatf("%s %o Unidentified Instruction turning into NOP ",name,inst.IR))
					`OP1(NOP);
					end //}
	endcase //}

	//`DEBUG($sformatf("%s:identify_inst_format:opcode identified is %s",name,inst.opcode_ex))
	`DEBUG($sformatf("\n\n############################### END INSTRUCTION DECODE PHASE: INSTRUCTION NUMBER : %0d ###############################\n",inst.inst_id))
	//`INFO($sformatf("\n############################### END INSTRUCTION DECODE PHASE: INSTRUCTION NUMBER : %0d ###############################\n",inst.inst_id))

endtask

//******* for all the byte operations the src_operand contains the complete sign extended 16 bit value***************// 



// source operand is accessed first and then the destination operand
//src_operand - has the source operand 
//dest_operand - has the destination operand 
//dest - has the register number or the destination address depending on write_reg_en and write_mem_en respectively 
task InstructionDecode::double_op();

	dop_t d_ir = inst.IR;
`INFO($sformatf("%s DOUBLE OP: OPCODE: %s SRC: AM:%s, REG:%s  DEST: AM:%s, REG:%s",name,inst.opcode_ex,amod_t'(d_ir.smod),register_t'(d_ir.sreg),amod_t'(d_ir.dmod),register_t'(d_ir.dreg)))
	if (inst.opcode_ex == SUB) d_ir.sz = word_op;
	decode_src_am(d_ir.sz,amod_t'(d_ir.smod),d_ir.sreg);
	decode_dest_am(d_ir.sz,amod_t'(d_ir.dmod),d_ir.dreg);
	if (inst.opcode_ex inside {CMPB,CMP,BITB,BIT}) {inst.write_reg_en,inst.write_mem_en} = 2'b00; 
endtask 

//dest_operand - has the destination operand 
//dest - has the register number or the destination address depending on write_reg_en and write_mem_en respectively 
task InstructionDecode::single_op();
	sop_t s_ir = inst.IR;
`INFO($sformatf("%s SINGLE OP: OPCODE: %s  DEST: AM:%s, REG:%s",name,inst.opcode_ex,amod_t'(s_ir.dmod),register_t'(s_ir.dreg)))
	//assert (!(inst.opcode_ex == JMP) && (s_ir.dmod == REG)) $fatal ("REGISTER MODE ILLEGAL IN JUMP");
	assert (!((inst.opcode_ex == JMP) && (s_ir.dmod == REG))) else $warning ("REGISTER MODE ILLEGAL IN JUMP");
	if ((inst.opcode_ex == JMP) && (s_ir.dmod == REG_DEF)) begin //{
	decode_dest_am(s_ir.sz,REG,s_ir.dreg);
	end //}
	decode_dest_am(s_ir.sz,amod_t'(s_ir.dmod),s_ir.dreg);
	assert (!((inst.opcode_ex == JMP) && (inst.dest_operand[0] == 1'b1))) else $warning ("Boundary error condition access to odd address for a JUMP");
	if (inst.opcode_ex inside {TSTB,TST}) {inst.write_reg_en,inst.write_mem_en} = 2'b00; 
endtask

///offset - has the shifted sign extended value 

task InstructionDecode::branch();
	brop_t b_ir = inst.IR;
	inst.offset = {{7{b_ir.ofst[7]}},b_ir.ofst,1'b0};
`INFO($sformatf("%s BRANCH OP: OPCODE: %s OFFSET:%o",name,inst.opcode_ex,inst.offset))
endtask

///////////////////for JSR /////////////////////////
// src_operand -  will contain the contents of the source_reg 
// dest_operand - will contain the value which should be loaded into PC 
//  dest - will contain the name of the register where the actual contents of the PC should be stored
//write_reg_en will be set
////////////////////////////////////////////////////
task InstructionDecode::subroutine();

	sop_t subr_ir = inst.IR;
`INFO($sformatf("%s JUMP TO SUBROUTINE : REG_PUSH:%s DEST:AM:%s : REG:%s",name,register_t'(subr_ir.op),amod_t'(subr_ir.dmod),register_t'(subr_ir.dreg)))
	decode_dest_am(subr_ir.sz,amod_t'(subr_ir.dmod),subr_ir.dreg); //dest is calculated first
	decode_src_am(word_op,REG,subr_ir.op);
	//decode_dest_am(subr_ir.sz,amod_t'(subr_ir.dmod),subr_ir.dreg);
	inst.dest = {{13{1'b0}},subr_ir.op};
	inst.write_reg_en = 1'b1;
	inst.write_mem_en = 1'b0;
endtask

//////////////////for RTS  opcode///////////////////
//  src_operand contains the contents of the src reg
//  dest contains the register number where the TOP is to be popped into 
//  write_reg_en will be set
///////////////////////////////////////////////////
task InstructionDecode::r_subroutine();
	sys_t rsubr_ir = inst.IR;
`INFO($sformatf("%s RETURN FROM SUBROUTINE: REG_POP:%s",name,register_t'(rsubr_ir.op)))
	decode_src_am(word_op,REG,rsubr_ir.op);
	inst.dest = {{13{1'b0}},rsubr_ir.op};
	inst.write_reg_en = 1'b1;
	inst.write_mem_en = 1'b0;
endtask



///the src_operand is set in this task 
task InstructionDecode::decode_src_am(op_size b_w,amod_t am_s,radr_t rs_num);
word_t d;
bit d1,d2;
`INFO($sformatf("\n#################################### %s DECODE_SRC_AM ################################################\n",name))
fetch_operand(b_w,am_s,rs_num,SRC,inst.src_operand,d,d1,d2);
endtask

//dest_operand,dest_operand,write_reg_en,write_mem_en are set in this task 
task InstructionDecode::decode_dest_am(op_size b_w,amod_t am_d,radr_t rd_num);
`INFO($sformatf("\n#################################### %s DECODE_DEST_AM ################################################\n",name))
fetch_operand(b_w,am_d,rd_num,DST,inst.dest_operand,inst.dest,inst.write_reg_en,inst.write_mem_en);
endtask


//Common task for accessing both source and destination operand, calucaltes the effective address, reads the memory or register to populate the operands and sets the desitnation bits depending upon addressing mode

//an assertion is in place in the memory file that will check if word operations access odd addresses 

task InstructionDecode::fetch_operand(input op_size b_w,amod_t mode,radr_t register,am src_dest,output word_t return_value,word_t dst,bit reg_vld,bit mem_vld);

	//word_t return_value;
	word_t eff_addr,eff_addr_1,disp,eff_addr_2;

	return_value='h0;eff_addr='h0;eff_addr_1='h0;eff_addr_2='h0;
	unique case (mode) //{
	REG	: begin //{
			return_value = read_reg(b_w,register);	
			`DEBUG($sformatf("%s Reg AM:Value in the register=16'o%o",name,return_value))
			if (src_dest == DST) begin //{
			dst = {{13{1'b0}},register}; 
			reg_vld = 1'b1;
			mem_vld = 1'b0;
			`DEBUG($sformatf("%s Reg AM:Value in the dst=16'o%o",name,dst))
			end //}
		  end //}
	REG_DEF	: begin //{
			eff_addr = read_reg(word_op,register);
			`DEBUG($sformatf("%s Reg Def AM:Effective Address=16'o%o",name,eff_addr))
			//if (((inst.opcode_ex == MOV) || (inst.opcode_ex == MOVB)) && ()) return_value = b_w ? read_mem(byte_op,eff_addr) : read_mem(word_op,eff_addr); 
	if (~((inst.opcode_ex inside {MOV,MOVB,JSR,JMP}) && (src_dest == DST))) return_value = b_w ? read_mem(byte_op,eff_addr) : read_mem(word_op,eff_addr); else return_value = eff_addr; 
			if (src_dest == DST) begin //{
			dst = eff_addr;
			mem_vld = 1'b1;
			reg_vld = 1'b0;
			`DEBUG($sformatf("%s Reg Def AM:Value in the dst=16'o%o",name,dst))
			end //}
			`DEBUG($sformatf("%s Reg Def AM:Return Value=16'o%o",name,return_value))
		  end //}
	A_INCR,A_DEC	: begin //{
				eff_addr = inc_dec_reg(b_w,mode,register);
			`DEBUG($sformatf("%s Auto Incr/Decr AM:Effective Address=16'o%o",name,eff_addr))
				//return_value = b_w ? read_mem(byte_op,eff_addr) : read_mem(word_op,eff_addr); 
	if (~((inst.opcode_ex inside {MOV,MOVB,JSR,JMP}) && (src_dest == DST))) return_value = b_w ? read_mem(byte_op,eff_addr) : read_mem(word_op,eff_addr); else return_value = eff_addr; 
				if (src_dest == DST) begin //{
				dst = eff_addr;
				mem_vld = 1'b1;
				reg_vld = 1'b0;
			`DEBUG($sformatf("%s:Auto Incr/Decr AM:Value in the dst =16'o%o",name,dst))
				end //}
			`DEBUG($sformatf("%s:Auto Incr/Decr AM:Return Value=16'o%o",name,return_value))
			  end //}
	A_INCR_DEF,A_DEC_DEF	: begin //{
					eff_addr = inc_dec_reg(b_w,mode,register);
			`DEBUG($sformatf("%s,Register Auto Incr/Decr Deffered AM:Effective Address=16'o%o",name,eff_addr))
					//assert(eff_addr[0] == 0) ; else $warning("Unaligned acess to Memory");
					eff_addr_1 = read_mem(word_op,eff_addr);
			`DEBUG($sformatf("%s,Register Auto Incr/Decr Deffered AM:Effective Address_1=16'o%o",name,eff_addr_1))
					//return_value = b_w ? read_mem(byte_op,eff_addr_1) : read_mem(word_op,eff_addr_1); 
	if (~((inst.opcode_ex inside {MOV,MOVB,JSR,JMP}) && (src_dest == DST))) return_value = b_w ? read_mem(byte_op,eff_addr_1) : read_mem(word_op,eff_addr_1); else return_value = eff_addr_1; 
					if (src_dest == DST) begin //{
					dst = eff_addr_1;
					mem_vld = 1'b1;
					reg_vld = 1'b0;
			`DEBUG($sformatf("%s Auto Incr/Decr Def AM:Value in the dst=16'o%o",name,dst))
					end //}
			`DEBUG($sformatf("%s Auto Incr/Dec Deffered AM:Return Value 16'o%o",name,return_value))
				  end //}
	INDEX			: begin //{
					disp = read_mem(word_op,inc_dec_reg(word_op,A_INCR,`PC));
			`DEBUG($sformatf("%s Reg Indexed AM:Displacement=16'o%o",name,disp))
					eff_addr = read_reg(word_op,register);
			`DEBUG($sformatf("%s Reg Indexed AM:Effective Address=16'o%o",name,eff_addr))
					eff_addr_1 = eff_addr + disp;
			`DEBUG($sformatf("%s Reg Indexed AM:Effective Address_1=16'o%o",name,eff_addr_1))
					//return_value = b_w ? read_mem(byte_op,eff_addr_1) : read_mem(word_op,eff_addr_1); 
	if (~((inst.opcode_ex inside {MOV,MOVB,JSR,JMP}) && (src_dest == DST))) return_value = b_w ? read_mem(byte_op,eff_addr_1) : read_mem(word_op,eff_addr_1); else return_value = eff_addr_1; 
					if (src_dest == DST) begin //{
					dst = eff_addr_1;
					mem_vld = 1'b1;
					reg_vld = 1'b0;
			`DEBUG($sformatf("%s Reg Indexed AM:Value in the dst=16'o%o",name,dst))
					end //}
			`DEBUG($sformatf("%s Reg Indexed AM:Return Value=16'o%o",name,return_value))
				  end //}
	INDEX_DEF		: begin //{
					disp = read_mem(word_op,inc_dec_reg(word_op,A_INCR,`PC));
			`DEBUG($sformatf("%s Auto Indexed Deffered AM:Displacement=16'o%o",name,disp))
					eff_addr = read_reg(word_op,register);
			`DEBUG($sformatf("%s Auto Indexed Deffered AM:Effective Address=16'o%o",name,eff_addr))
					eff_addr_1 = eff_addr + disp;
			`DEBUG($sformatf("%s Auto Indexed Deffered AM:Effective Address_1=16'o%o",name,eff_addr_1))
					eff_addr_2 = read_mem(word_op,eff_addr_1);
			`DEBUG($sformatf("%s Auto Indexed Deffered AM:Effective Address_2=16'o%o",name,eff_addr_2))
	if (~((inst.opcode_ex inside {MOV,MOVB,JSR,JMP}) && (src_dest == DST))) return_value = b_w ? read_mem(byte_op,eff_addr_2) : read_mem(word_op,eff_addr_2); else return_value = eff_addr_2; 
					//return_value = b_w ? read_mem(byte_op,eff_addr_2) : read_mem(word_op,eff_addr_2); 
					if (src_dest == DST) begin //{
					dst = eff_addr_2;
					mem_vld = 1'b1;
					reg_vld = 1'b0;
			`DEBUG($sformatf("%s Auto Indexed Deffered AM:Value in the dst=16'o%o",name,dst))
					end //}
			`DEBUG($sformatf("%s Auto Indexed Deffered AM:Return Value=16'o%o",name,return_value))
				  end //}
	endcase //}
endtask


//read the memory - in byte operations sign extend the data 

function word_t InstructionDecode::read_mem(op_size b_w,mem_addr_t addr);
byte_t temp;
unique case (b_w) //{
	word_op : begin //{
		return (mem_h.GetWord(addr));
	end //}
	byte_op : begin //{  //sign extend the byte 
	temp = mem_h.GetByte(addr); 
	return ({{MEM_WIDTH{temp[7]}},temp});
	end //}
endcase //}

endfunction

//read the regiaters  - in byte operations sign extend the data 
function word_t InstructionDecode::read_reg(op_size b_w,radr_t reg_num);
word_t temp;
unique case (b_w) //{
	word_op : begin //{
		return (regfile_h.Read(register_t'(reg_num)));
	end //}
	byte_op : begin //{  //sign extend the byte  
	temp = regfile_h.Read(register_t'(reg_num)); 
	return ({{MEM_WIDTH{temp[7]}},temp[7:0]});
	end //}
endcase //}
endfunction



///increment/decrement  the given register depending on addressing mode



function word_t InstructionDecode::inc_dec_reg(op_size b_w,amod_t mode,radr_t register);

word_t actual_value,inc_value,dec_value;
actual_value = read_reg(word_op,register);
`DEBUG($sformatf("%s inc_dec_reg:Actual Value=16'o%o",name,actual_value))

//assert(!(actual_value[0] == 1'b1) && ((register == `PC) || (register == `SP)))  $warning ("PC or SP having an unaligned address");
//assume ((actual_value[0] == 1'b0) && ((register == `PC) || (register == `SP)))  $warning ("PC or SP having an unaligned address");

///assert((actual_value[0] =  ((register == `PC) || (register == `SP)) ? );// $warning ("PC or SP having an unaligned address");
//if((register == `PC) || (register == `SP)) begin //{
//assume (actual_value[0] == 1'b0) else $warning ("PC or SP having an unaligned address");
//end //}

unique case (mode) //{
	A_INCR		: begin //{ word increments if the registers are PC or SP or the opcode is a word instruction  
					if ((register == `PC) || (register == `SP)) begin //{
						inc_value = actual_value + 2;
					end //}
					else begin//{
						if (b_w == byte_op) begin //{
						inc_value = actual_value + 1;
						end //}
						else if (b_w == word_op) begin //{
						inc_value = actual_value + 2;
						end //}
					end //}
			`DEBUG($sformatf("%s Auto Incr AM:inc_value=16'o%o",name,inc_value))
				`reg_write(register,inc_value);
		 	  end //}
	A_INCR_DEF	: begin // 
				//assert(actual_value[0] == 1'b1) $warning("Unaligned Address in Deffered mode");
				inc_value = actual_value + 2;
			`DEBUG($sformatf("%s Auto Incr Deffered AM:inc_value=16'o%o",name,inc_value))
				`reg_write(register,inc_value);
			  end //}
	A_DEC		: begin //{
					if ((register == `PC) || (register == `SP)) begin //{
						dec_value = actual_value - 2;
						//assert (register === `PC) $warning("using PC in a AUTO_DECREMENT mode");
					end //}
					else begin//{
						if (b_w == byte_op) begin //{
						dec_value = actual_value - 1;
						end //}
						else if (b_w == word_op) begin //{
						dec_value = actual_value - 2;
						end //}
					end //}
			`DEBUG($sformatf("%s Auto Decr AM:dec_value=16'o%o",name,dec_value))
				`reg_write(register,dec_value);
			  end //}
	A_DEC_DEF	: begin //{
				//assert(actual_value[0] == 1'b1) $warning("Unaligned Address in Deffered mode");
				//assert (register === `PC) $warning("using PC in a AUTO_DECREMENT_DEFFERED mode");
				dec_value = actual_value - 2;
			`DEBUG($sformatf("%s Auto Decr Def AM:dec_value=16'o%o",name,dec_value))
				`reg_write(register,dec_value);
			  end //}
endcase 

if (mode inside {A_INCR,A_INCR_DEF}) begin //{
return actual_value;
end //}
else if (mode inside {A_DEC,A_DEC_DEF}) begin //{
return dec_value;
end //}
endfunction



`undef S 
`undef D 
`undef B 
`undef OP 
`undef OP1  
`undef OPS 
`undef OPD
`undef OPB  
`undef reg_write
