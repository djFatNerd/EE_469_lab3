// 4:1 mux constructed by 3 2:1 mux
`timescale 1ns/10ps
module mux_4x1(out, in, sel);
	input logic [3:0]in;
	input logic [1:0]sel;
	output logic out;
	
	logic [1:0]temp;
	
	mux_2x1 mux_2x1_1 (temp[1], in[3:2], sel[0]);
	mux_2x1 mux_2x1_2 (temp[0], in[1:0], sel[0]);
	mux_2x1 mux_2x1_3 (out, temp[1:0], sel[1]);
endmodule


module mux_4x1_testbench;
	logic [3:0]in;
	logic [1:0]sel;
	logic out;
	
	integer i;
	initial begin	
		for (int i = 0; i < 64; i++) begin
			{sel[1:0], in[3:0]} = i; #10;
		end
	end	
	 
	mux_4x1 dut(.out, .in, .sel);

endmodule