`timescale 1ns/10ps
module signExtend9(SED9, Imm9);
	input logic [8:0]Imm9;
	output logic [63:0] SED9; 
	
	assign SED9[63:0] = {{55{Imm9[8]}},Imm9[8:0]};
	
endmodule


module signExtend9_testbench;
	logic [8:0]Imm9;
	logic [63:0]SED9;
	initial begin
		Imm9 = 9'b111111111; #10;
		Imm9 = 9'b011111111; #10;
		Imm9 = 9'b000000000; #10;
		Imm9 = 9'b100000000; #10;	
	end
	
	signExtend9 dut(.SED9, .Imm9);

endmodule



