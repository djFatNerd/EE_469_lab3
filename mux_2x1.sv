// 2:1 mux
`timescale 1ns/10ps


module mux_2x1(out, in, sel);
	input logic [1:0]in;
	input logic sel;
	output logic out;
	
	// assign out = (i1 & sel) | (i0 & ~sel); 
	
	logic temp_1;
	logic temp_2;
	logic not_sel;
	
	
	and #5 and_gate_1 (temp_1, in[1], sel); // in[1] & sel
	
	not #5 not_gate (not_sel, sel); // ~sel
	and #5 and_gate_2 (temp_2, in[0], not_sel);
 
	or #5 or_gate_1(out, temp_1, temp_2);
	
endmodule


module mux_2x1_testbench;
	logic [1:0]in;
	logic sel;
	logic out;
	
	integer i;
	initial begin	
		for (int i = 0; i < 8; i++) begin
			{sel, in[1:0]} = i; #10;
		end
	end	
	 
	mux_2x1 dut(.out, .in, .sel);

endmodule