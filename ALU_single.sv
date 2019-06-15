// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B = A + ~B + 1
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant


`timescale 1ns/10ps
module ALU_single(out_o, co_o, a_i, b_i, cin_i, sel_i);
	input logic a_i, b_i, cin_i;
   input logic [2:0] sel_i;
	output logic out_o, co_o;
	
	// sel_i = 010 --- > A + B
	// sel_i = 011 --- > A - B
	
	// produce "not b"
	logic not_b;
	not #5 b_inverter (not_b, b_i); 
	
	//  select "b" or "not b" base on the "subtract" signal
	//  in this case "subtract" is controlled by sel_i[0]
	//  "subtract" = sel_i[0]	
	logic final_b; 
	mux_2x1 chooseB (final_b, {not_b, b_i}, sel_i[0]);
   	
	
	// full adder, perform either A+B or A-B, output in "sum"
	logic sum;
	
	// co_o = adder_co_o 
	fullAdder addSub (sum, co_o, cin_i, a_i, final_b); 
	
	// sel_i = 100 --- > bitwise A & B 
	// sel_i = 101 --- > bitwise A | B
	// sel_i = 110 --- > bitwise A XOR B
	
	
	logic bitand, bitor, bitxor;
	
	// produce A & B
	and #5 and_gate (bitand, a_i, b_i);
	
	// produce A | B
	or #5 or_gate (bitor, a_i, b_i);
	
	// produce A XOR B
	xor #5 xor_gate (bitxor, a_i, b_i);
										
										// 111   110   101    100     011  010  001   000 
										// X		XOR	OR		 AND	   -	  +	 X		 B
	mux_8x1 controlMux (out_o, {1'b0, bitxor, bitor, bitand, sum, sum, 1'b0, b_i}, sel_i[2:0]);
endmodule



module ALU_single_testbench;
	logic a_i, b_i, cin_i;
	logic [2:0]sel_i;
	logic out_o;
	logic co_o;
	
	
	integer i;
	initial begin	
		for (int i = 0; i < 64; i++) begin
			{sel_i[2:0], cin_i, b_i, a_i} = i; #10;
		end
	end

	
	ALU_single dut (.out_o, .co_o, .a_i, .b_i, .cin_i, .sel_i);
endmodule


