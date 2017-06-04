/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/

`include "common_pkg.sv"

function void PDP11_20::LoadMem ();
	string ifile;
	integer obj_f, readSuccess;
	integer value, line;
	bit promptForPC;
	mem_addr_t loadAddr;
	word_t initPC;
	enum logic [7:0] {LoadMem="-", ChangeLoadAddr="@", SetInitPC="*"} action;

	promptForPC = 1;
	loadAddr = '0;
	line = 1;
	if (!$value$plusargs("IFILE=%s", ifile))
		ifile = "source.ascii"; // Default input file
	`INFO($sformatf("\nLoading Memory Image from source file %s\n\n", ifile))
	obj_f = $fopen(ifile, "r");
	
	while (!$feof(obj_f)) begin
		readSuccess = $fscanf(obj_f, "%c%o\n", action, value);
		assert(readSuccess);
		`DEBUG($sformatf("Read from Line %0d: action=%s, value=%6o", line++, action, value))
		case (action)
		LoadMem:	begin
				mem_h.SetWord (.Address(loadAddr), .Data(value), .MemLoad(TRUE));
				loadAddr+=2;
				end

		SetInitPC: 	begin
				promptForPC=0;
				initPC=value;
				`DEBUG($sformatf("Setting initial PC=%o\n", initPC))
				end

		ChangeLoadAddr:	begin
				loadAddr=value;
				`DEBUG($sformatf("Changing Load Address to %6o\n", loadAddr))
				end
		endcase
	end

	if (promptForPC) begin
		if ($value$plusargs("IPC=%o", initPC)) begin
			$display ("initPC=%o", initPC);
		end
		else begin
			`INFO ($sformatf("[ERROR] Starting address not defined"))
			$finish();
		end
	end
	
	reg_h.Write(PC, initPC);
	
	`INFO($sformatf("\nStarting Address of Program=%o\n\n", initPC))
	$fclose(obj_f);
endfunction
