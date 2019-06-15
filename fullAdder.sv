// 1 bit full adder
`timescale 1ns/10ps

module fullAdder(sum_o, co_o, cin_i, A_i, B_i);
	input logic A_i, B_i, cin_i;
	output logic sum_o;
	output logic co_o;
	
	// calculate carryout
	logic AB, AC, BC;
	and #5 andGate (AB, A_i, B_i);
	and #5 andGate2 (AC, A_i, cin_i);
	and #5 andGate3 (BC, B_i, cin_i);
	or #5 carryout (co_o, AB, AC, BC);
	
	// calculate sum
	xor #5 sum (sum_o, A_i, B_i, cin_i);
	
endmodule

module fullAdder_testbench;
	logic A_i;
	logic B_i;
	logic cin_i;
	
	integer i;
	initial begin	
		for (int i = 0; i < 8; i++) begin
			{cin_i, B_i, A_i} = i; #10;
		end
	end
	
	fullAdder dut(.cin_i, .A_i, .B_i);

endmodule






