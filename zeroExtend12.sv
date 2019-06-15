`timescale 1ns/10ps
module zeroExtend12(ZED12, Imm12);
	input logic [11:0]Imm12;
	output logic [63:0] ZED12; 
	
	assign ZED12[63:0] = {52'b0, Imm12[11:0]};
	
endmodule


module zeroExtend12_testbench;
	logic [11:0]Imm12;
	logic [63:0]ZED12;
	initial begin
		Imm12 = 12'b111111111111; #10;
		Imm12 = 12'b011111111111; #10;
		Imm12 = 12'b100000000000; #10;	
	end
	
	zeroExtend12 dut(.ZED12, .Imm12);

endmodule