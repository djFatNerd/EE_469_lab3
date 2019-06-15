`timescale 1ns/10ps
module mux_64x4x1(out, A, B, C, D, sel);
	input logic  [63:0] A, B, C, D;
	input logic  [1:0]  sel;
	output logic [63:0] out;
	
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: eachBit
			mux_4x1 eachMUX(out[i], {A[i], B[i], C[i], D[i]}, sel[1:0]);
		end
	endgenerate
endmodule


module mux_64x4x1_testbench;
	logic  [63:0] A, B, C, D;
	logic  [1:0]  sel;
   logic  [63:0] out;
	
	initial begin
		A = 64'hFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFF00000; C = 64'b0; D = 64'h0000000000000FF; sel = 2'b01; #10;
		sel = 2'b00;  #10;
		A = 64'hFFFFF00000FFFFF; #10;
      sel = 2'b01;  #10;
		sel = 2'b10;  #10;
		sel = 2'b11;  #10;
	end
	
	 
	mux_64x4x1 dut(.out, .A, .B, .C, .D, .sel);

endmodule