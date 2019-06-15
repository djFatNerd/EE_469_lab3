`timescale 1ns/10ps
module adder_64(result, carryout, A, B, carryin);
	input logic [63:0] A;
	input logic [63:0] B;
	input logic carryin;
	
	output logic [63:0]result;
	output logic carryout;
	
	logic [63:0]inner_co;
	
	fullAdder firstBit(result[0], inner_co[0], carryin, A[0], B[0]);
	
	genvar i;
	generate
		for(i = 1; i < 64; i++) begin:eachAdder
			fullAdder otherAdders(result[i], inner_co[i], inner_co[i - 1], A[i], B[i]);	
		end
	endgenerate
endmodule

// incomplete
module adder_64_testbench;
	logic [63:0] A;
	logic [63:0] B;
	logic carryin;
	
	logic [63:0]result;
	logic carryout;

	
	initial begin
	   carryin = 0;
		A = 64'h000000000000001; B = 64'hFFFFFFFFFF00000; #10;
		A = 64'b0; B = 64'h0000000000000FF;  #10;
		B = 64'h0000000000FFFFF; #10;
      A = 64'h000000000000001; B = 64'hF00000000000000;  #10;
	end
	

	
	adder_64 dut(.result, .carryout, .A, .B, .carryin);
endmodule


