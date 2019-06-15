// 8:1 mux constructed by two 4:1 and one 2:1 mux

`timescale 1ns/10ps
module mux_8x1(out_o, in_i, sel_i);
	input logic [7:0]in_i;
	input logic [2:0]sel_i;
	output logic out_o;
	
	logic [1:0]temp;
	
	mux_4x1 mux_4x1_1 (temp[1], in_i[7:4], sel_i[1:0]);
	mux_4x1 mux_4x1_2 (temp[0], in_i[3:0], sel_i[1:0]);
	
	mux_2x1 mux_2x1_1 (out_o, temp[1:0], sel_i[2]);
  
endmodule


module mux_8x1_testbench;
	logic [7:0]in_i;
	logic [2:0]sel_i;
	logic out_o;
	
	integer i;
	initial begin	
		for (int i = 0; i < 2048; i++) begin
			{sel_i[2:0], in_i[7:0]} = i; #10;
		end
	end
	
	mux_8x1 dut(.out_o, .in_i, .sel_i);
	
endmodule