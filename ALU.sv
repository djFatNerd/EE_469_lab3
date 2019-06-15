// 64-bit full ALU
`timescale 1ns/10ps

module alu (result, negative, zero, overflow, carry_out, A, B, cntrl);
	input logic  [63:0]	A, B;
	input logic  [2:0] 	cntrl; 
	output logic [63:0]	result;
	output logic			negative, zero, overflow, carry_out;
	
	
   //  64 single-ALUs collected
	
	logic [63:0] inner_co;
	
	ALU_single first (result[0], inner_co[0], A[0], B[0], cntrl[0], cntrl[2:0]);
	
	genvar i;
	generate
		for(i = 1; i < 64; i++) begin: eachALU
			ALU_single others (result[i], inner_co[i], A[i], B[i], inner_co[i-1], cntrl[2:0]);
		
		end
	endgenerate
	
	// negative, read as two's complement
	assign negative = result[63];
	
	// overflow
	xor #5 overFlow_check (overflow, inner_co[63], inner_co[62]);
	
	// carry_out
	assign carry_out = inner_co[63];
	
	// check zero
	check_zero checkZero (zero, result);
endmodule


module alustim_testbench;

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;

	initial begin
	
		// test pass B
		$display("%t testing PASS_B operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
			
		// test addition	
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD; 
		
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFE && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);
		
		A = 64'h8000000000000000; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 1 && negative == 0 && zero == 1);
		
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
		end
		
		
					
		// test subtraction	
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT; 
		
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		A = 64'h8000000000000000; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1); 
		
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		A = 64'h8000000000000000; B = 64'h7FFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h0000000000000001 && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);
		
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
		end
		

		
		$display("%t testing bitwise AND ", $time);
		cntrl = ALU_AND;
		for (i=0; i< 100; i++) begin
			A = $random(); B = $random();
			#(delay);
		end
		
		$display("%t testing bitwise OR ", $time);
		cntrl = ALU_OR;
		for (i=0; i< 100; i++) begin
			A = $random(); B = $random();
			#(delay);
		end
		
		$display("%t testing bitwise XOR ", $time);
		cntrl = ALU_XOR;
		for (i=0; i< 100; i++) begin
			A = $random(); B = $random();
			#(delay);
		end
		
		
	end
endmodule
