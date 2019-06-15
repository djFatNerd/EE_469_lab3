// 2:1 64bits mux

`timescale 1ns/10ps
module mux_64x2x1(out, A, B, sel);
	input logic  [63:0] A;
	input logic  [63:0] B;
	input logic  sel;
	
	output logic [63:0] out;
	
	genvar i;
	generate 
		for (i = 0 ; i < 64; i++) begin: eachBit
			mux_2x1 eachMux(out[i], {A[i], B[i]}, sel);
		end
	endgenerate
	
endmodule

module mux_64x2x1_testbench;
	logic  [63:0] A, B;
	logic  sel;
   logic  [63:0] out;
	
	initial begin
		A = 64'hFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFF00000; sel = 1; #10;
		sel = 0;  #10;
		A = 64'hFFFFF00000FFFFF; #10;
      sel = 1;  #10;
		B = 64'b0; sel = 0;  #10;
		sel = 1;  #10;
	end
	
	 
	mux_64x2x1 dut(.out, .A, .B, .sel);

endmodule