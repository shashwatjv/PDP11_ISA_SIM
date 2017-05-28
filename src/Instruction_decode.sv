/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/
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


`include "common_pkg.sv"

class InstructionDecode;
string name = "InstructionDecode";
Memory mem_h;
RegisterFile regfile_h;
InstructionTrans inst;

//function new(Memory mem_h, RegisterFile regfile_h, InstructionTrans inst);
function new(Memory mem_h, RegisterFile regfile_h);
this.mem_h = mem_h;
this.regfile_h = regfile_h;
`DEBUG($sformatf("%s:Created a new InstructionDecode unit",name))
endfunction

extern function void run(InstructionTrans inst);
extern function void identify_inst_format();
extern function void double_op();
extern function void single_op();
extern function void subroutine();
extern function void branch();
extern function void r_subroutine();
extern function void decode_src_am();
extern function void decode_dest_am();
extern function void halt();
extern function word_t fetch_operand(mode,register);
extern function word_t read_mem (mem_addr_t addr);  // Instead of this you can directly use mem_h.GetWord or GetByte
extern function word_t read_reg (register_t reg_num); // Instead of this you can directly use reg_h.Read(`R1)
endclass

function void InstructionDecode::run(InstructionTrans inst);
// Can simply check inst.IR here and set other fields of inst object
this.inst = inst;
identify_inst_format();
endfunction

function void InstructionDecode::identify_inst_format();

	let bw = inst.IR[15];

	`DEBUG($sformatf("%s:identify_inst_format:Received instruction of %o",name,inst.IR))

	priority case (inst.IR) inside //{
	WORD_SIZE'o000000	:	begin //{
					`OP1(HALT);
					halt();		
					end //}
	WORD_SIZE'o00020?	:	begin //{
					`OP1(RTS);
					r_subroutine();
					end //}
	WORD_SIZE'o0004??	:	begin //{
					`OP1(JSR);
					subroutine();
					end //}
	WORD_SIZE'o?050??	:	begin //{
					`OPS(CLRB,CLR);
					end //}
	WORD_SIZE'o?051??	:	begin //{
					`OPS(COMB,COM);
					end //}
	WORD_SIZE'o?052??	:	begin //{
					`OPS(INCB,INC);
					end //}
	WORD_SIZE'o?053??	:	begin //{
					`OPS(DECB,DEC);
					end //}
	WORD_SIZE'o?054??	:	begin //{
					`OPS(NEGB,NEG);
					end //}
	WORD_SIZE'o?055??	:	begin //{
					`OPS(ADCB,ADC);
					end //}
	WORD_SIZE'o?056??	:	begin //{
					`OPS(SBCB,SBC);
					end //}
	WORD_SIZE'o?057??	:	begin //{
					`OPS(TSTB,TST);
					end //}
	WORD_SIZE'o?060??	:	begin //{
					`OPS(RORB,ROR);
					end //}
	WORD_SIZE'o?061??	:	begin //{
					`OPS(ROLB,ROL);
					end //}
	WORD_SIZE'o?062??	:	begin //{
					`OPS(ASRB,ASR);
					end //}
	WORD_SIZE'o?063??	:	begin //{
					`OPS(ASLB,ASL);
					end //}
	WORD_SIZE'o0001??	:	begin //{
					`OP1(JMP);
					`S;
					end //}
	WORD_SIZE'o0003??	:	begin //{
					`OP1(SWAB);
					`S;
					end //}
	WORD_SIZE'o0004??	:	begin //{
					`OPB(BR);
					end //}
	WORD_SIZE'o0010??	:	begin //{
					`OPB(BNE);
					end //}
	WORD_SIZE'o0014??	:	begin //{
					`OPB(BEQ);
					end //}
	WORD_SIZE'o0020??	:	begin //{
					`OPB(BGE);
					end //}
	WORD_SIZE'o0024??	:	begin //{
					`OPB(BLT);
					end //}
	WORD_SIZE'o0030??	:	begin //{
					`OPB(BGT);
					end //}
	WORD_SIZE'o0034??	:	begin //{
					`OPB(BLE);
					end //}
	WORD_SIZE'o1000??	:	begin //{
					`OPB(BPL);
					end //}
	WORD_SIZE'o1004??	:	begin //{
					`OPB(BMI);
					end //}
	WORD_SIZE'o1010??	:	begin //{
					`OPB(BHI);
					end //}
	WORD_SIZE'o1014??	:	begin //{
					`OPB(BLOS);
					end //}
	WORD_SIZE'o1020??	:	begin //{
					`OPB(BVC);
					end //}
	WORD_SIZE'o1024??	:	begin //{
					`OPB(BVS);
					end //}
	WORD_SIZE'o1030??	:	begin //{
					`OPB(BCC);
					end //}
	WORD_SIZE'o1030??	:	begin //{
					`OPB(BCS);
					end //}
	WORD_SIZE'o?1????	:	begin //{
					`OPD(MOVB,MOV);
					end //}
	WORD_SIZE'o?2????	:	begin //{
					`OPD(CMPB,CMP);
					end //}
	WORD_SIZE'o?3????	:	begin //{
					`OPD(BITB,BIT);
					end //}
	WORD_SIZE'o?4????	:	begin //{
					`OPD(BICB,BIC);
					end //}
	WORD_SIZE'o?5????	:	begin //{
					`OPD(BISB,BIS);
					end //}
	WORD_SIZE'o06????	:	begin //{
					`OP1(ADD);
					`D;
					end //}
	WORD_SIZE'o16????	:	begin //{
					`OP1(SUB);
					`D;
					end //}
	WORD_SIZE'o??????	: 	`OP1(NOP);
	endcase //}

	`DEBUG($sformatf("%s:identify_inst_format:ocode is %s",inst.opcode_ex))

endfunction


function void InstructionDecode::double_op();

	dop d_ir = inst.IR;
	decode_src_am(d_ir.smod,d_ir.sreg);
	decode_dest_am(d_ir.dmod,d_ir.dreg);


endfunction 


function void InstructionDecode::decode_src_am();
endfunction

function void InstructionDecode::decode_dest_am();
endfunction



function word_t InstructionDecode::fetch_operand(mode,register);
endfunction

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

function word_t InstructionDecode::read_reg(register_t reg_num);
return regfile_h.Read(reg_num);
endfunction



`undef S 
`undef D 
`undef B 
`undef OP(x,y) 
`undef OP1(x)  
`undef OPS(x,y) 
`undef OPD(x,y)
`undef OPB(x)  
