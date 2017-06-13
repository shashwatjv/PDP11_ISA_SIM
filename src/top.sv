/*
Portland State University
ECE 586, Spring 2017
PDP 11/20 ISA simulator
Authors: Harathi, Khanna, Vinchurkar
*/


`include "common_pkg.sv"

module top();

PDP11_20 proc_h;

initial
begin
if ($value$plusargs("REG_DUMP=%d",reg_dump));
proc_h = new();
proc_h.run();
end

endmodule
