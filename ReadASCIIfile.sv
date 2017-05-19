
parameter TRUE=1, FALSE=0;
parameter MEM_WIDTH = 16;
parameter MEM_ADDR_LEN = 16;
parameter REG_WIDTH = 16;
parameter MEM_DATA_WIDTH = 16; 
typedef reg [MEM_ADDR_LEN-1:0] mem_addr_t;
typedef reg [REG_WIDTH-1:0] register_t;
typedef reg [MEM_DATA_WIDTH-1:0] mem_data_t;
typedef mem_data_t memory_image_t [2**(MEM_ADDR_LEN)];
enum logic [7:0] {LoadMem="-", ChangeLoadAddr="@", SetInitPC="*"} action;
int debug=1, info=1;


/***************************/
//import "DPI-C" function int getStartingAddr();

module top();

mem_data_t Mem [mem_addr_t];

function void MemWrite (mem_addr_t Address, mem_data_t Data, bit MemLoad);
Mem[Address] = Data; 
if (debug) begin
	if (MemLoad)
		$display ("File: %s Line:%0d \t Loading %o at Memory Address %o\n", `__FILE__, `__LINE__, Data, Address);
	else begin
		$display ("File: %s Line:%0d \t Writing %o to Memory Address %o\n", `__FILE__, `__LINE__, Data, Address);
		// Write to Trace file
	end
end
endfunction

function automatic void loadMem ();
	string asciiFile;
	integer file_h, readSuccess;
	integer value, line;
	bit promptForPC;
	mem_addr_t loadAddr;
	register_t initPC;

	promptForPC = 1;
	loadAddr = '0;
	line = 1;
	if (!$value$plusargs("IFILE=%s", asciiFile))
		asciiFile = "source.ascii"; // Default input file
	if (info) $display ("\nLoading Memory Image from source file %s\n\n", asciiFile);
	file_h = $fopen(asciiFile, "r");
	
	while (!$feof(file_h)) begin
		readSuccess = $fscanf(file_h, "%c%o\n", action, value);
		assert(readSuccess);
		if (debug) $display ("Read from Line %0d: action=%s, value=%6o", line++, action, value);
		case (action)
		LoadMem:	begin
				MemWrite (.Address(loadAddr), .Data(value), .MemLoad(TRUE));
				loadAddr+=2;
				end

		SetInitPC: 	begin
				promptForPC=0;
				initPC=value;
				if(debug) $display("Setting initial PC=%o\n", initPC);
				end

		ChangeLoadAddr:	begin
				loadAddr=value;
				if(debug) $display("Changing Load Address to %6o\n", loadAddr);
				end
		endcase
	end

	if (promptForPC) begin
		if (!$value$plusargs("IPC=%o", initPC)) begin
			if (info) $display ("File: %s Line:%0d \t [ERROR] Starting address not defined", `__FILE__, `__LINE__);
			$finish();
		end
	end
	
	if (info) $display ("\nStarting Address of Program=%o\n\n", initPC);	
	$fclose(file_h);
endfunction



//memory_image_t Mem;


initial
begin
loadMem;
end

endmodule
