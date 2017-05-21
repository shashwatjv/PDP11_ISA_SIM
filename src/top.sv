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
proc_h = new();
proc_h.Run();
end

endmodule