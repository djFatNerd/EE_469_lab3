// 2:1 64bits mux

`timescale 1ns/10ps
module mux_5x2x1(out, A, B, sel);
	input logic  [4:0] A;
	input logic  [4:0] B;
	input logic  sel;
	
	output logic [4:0] out;
	
	genvar i;
	generate 
		for (i=0 ; i < 5; i++) begin: eachBit
			mux_2x1 eachMux(out[i], {A[i], B[i]}, sel);
		end
	endgenerate
	
endmodule


module mux_5x2x1_testbench;
   logic  [4:0] A;
	logic  [4:0] B;
	logic  sel;
	logic [4:0] out;
	
	initial begin
		A = 5'b11000; B = 5'b00000; sel = 1; #10;
		sel = 0;  #10;
		A = 5'b11111; B = 5'b11100; #10;
      sel = 1;  #10;
	end
	
	 
	mux_5x2x1 dut(.out, .A, .B, .sel);

endmodule
