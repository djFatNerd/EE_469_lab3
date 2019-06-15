`timescale 1ns/10ps
module signExtend19(SED19, Imm19);
	input logic [18:0]Imm19;
	output logic [63:0] SED19; 
	
	assign SED19[63:0] = {{45{Imm19[18]}},Imm19[18:0]};
	
endmodule


module signExtend19_testbench;
	logic [18:0]Imm19;
	logic [63:0]SED19;
	initial begin
		Imm19 = 19'b1111111111111111111; #10;
		Imm19 = 19'b0111111111111111111; #10;
		Imm19 = 19'b0000000000000000000; #10;
		Imm19 = 19'b1000000000000000000; #10;	
	end
	
	signExtend19 dut(.SED19, .Imm19);

endmodule
