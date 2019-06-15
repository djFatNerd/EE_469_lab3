`timescale 1ns/10ps
module signExtend26(SED26, Imm26);
	input logic [25:0]Imm26;
	output logic [63:0] SED26; 
	
	assign SED26[63:0] = {{38{Imm26[25]}},Imm26[25:0]};
	
endmodule


module signExtend26_testbench;
	logic [25:0]Imm26;
	logic [63:0]SED26;
	initial begin
		Imm26 = 26'b11111111111111111111111111; #10;
		Imm26 = 26'b01111111111111111111111111; #10;
		Imm26 = 26'b00000000000000000000000000; #10;
		Imm26 = 26'b10000000000000000000000000; #10;	
	end
	
	signExtend26 dut(.SED26, .Imm26);

endmodule