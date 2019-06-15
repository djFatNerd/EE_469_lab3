`timescale 1ns/10ps
module cpu(reset, clk);
	input logic reset;
	input logic clk;
	logic Reg2Loc, RegWrite, MemWrite, BrTaken, UnCondBr, setFlag, memRead;
	logic zero, negative, overflow, carry_out;
	logic adder1_carryout;
	logic adder2_carryout;
	logic negative_new;
	logic zero_new;
	logic overflow_new;
	logic carry_out_new;
	logic [1:0]ALUSrc, MemToReg;
	logic [2:0]ALUOp;
	logic [4:0]Rd, Rn, Rm;
	logic [4:0] RdorRm;
	logic [5:0]SHAMT;
	logic [8:0]Imm9;
	logic [11:0]Imm12;
	logic [18:0]Imm19;
	logic [25:0]Imm26;
	logic [31:0]instruction;
	logic [63:0]SED9;
	logic [63:0]ZED12;
	logic [63:0]SED19;
	logic [63:0]SED26;
	logic [63:0]UnCondBrMUX_out;	
	logic [63:0]shifter1_out;	
	logic [63:0] PC;
	logic [63:0]adder1_out;
	logic [63:0] extended4;
	logic [63:0]adder2_out;
	logic [63:0]BrtakenMUX_out;
	logic [63:0] regWriteData;
	logic [63:0] Da;
	logic [63:0] Db;
	logic [63:0]shifter2_out;
	logic [63:0] ALU_in0;
	logic [63:0] ALU_out;	
	logic [63:0] datamem_out;
		
	logic [63:0] final_PC;
	// initialize or reset PC	
	mux_64x2x1 resetPC(final_PC, 64'b0, BrtakenMUX_out, reset);
	
	D_FF_x64 updatePC (PC, final_PC, clk, 1'b1);
	
	// compute possible new PC
	signExtend19 se19 (SED19,Imm19);
	signExtend26 se26 (SED26,Imm26);	
	mux_64x2x1 UnCondBrMUX (UnCondBrMUX_out, SED19, SED26, UnCondBr);
	shifter shifter1 (UnCondBrMUX_out, 1'b0, 6'b000010, shifter1_out);
	adder_64 adder1 (adder1_out, adder1_carryout, PC, shifter1_out, 1'b0);
	
	// PC = PC + 4
	signExtend9 extend4 (extended4, 9'b000000100);
	adder_64 adder2 (adder2_out, adder2_carryout, PC, extended4, 1'b0);
	
	// branch taken mux
	mux_64x2x1 BrTakenMUX (BrtakenMUX_out, adder1_out, adder2_out, BrTaken);
	
	// uddate PC
	// logic enabelDFF;
	// assign enableDFF = 1'b1;

	//D_FF_x64 updatePC (PC, BrtakenMUX_out, clk, ~reset);
	
	// new instruction fetch
	instructmem imfetch (PC, instruction, clk);
	
	// instruction decode
	controlLogic control (Reg2Loc, RegWrite, MemWrite, BrTaken, UnCondBr, setFlag, ALUSrc, MemToReg, ALUOp, 
								 memRead, Rd, Rn, Rm, Imm12,Imm9, Imm26, Imm19, SHAMT, instruction, zero, negative, 
								 overflow, carry_out, zero_new, negative_new, overflow_new, carry_out_new);
								 
	// regfile
	mux_5x2x1 RdRm  (RdorRm, Rd, Rm, Reg2Loc);
	regfile regdata (Da, Db, regWriteData, Rn, RdorRm, Rd,
						  RegWrite, clk);
	
	// zero or sign extend
	zeroExtend12 se12 (ZED12,Imm12);
	signExtend9 se9	(SED9, Imm9) ;
	mux_64x4x1 ALUsrcMUX (ALU_in0, Db, SED9, ZED12, 64'bx, ALUSrc);
	
	
	// --------------------------------------------------
	// ALU
	ALU alu(ALU_out, negative_new, zero_new, overflow_new, carry_out_new, Da, ALU_in0, ALUOp);
	
	// update flags
	
	flag_update negative_update  (negative,  negative_new,  clk, setFlag);
	flag_update zero_update      (zero, 	  zero_new, 	  clk, setFlag);
	flag_update overflow_update  (overflow,  overflow_new,  clk, setFlag);
	flag_update carry_out_update (carry_out, carry_out_new, clk, setFlag);

	
	// shifter 2
	shifter shifter2 (Da, 1'b1, SHAMT,  shifter2_out);

	// --------------------------------------------------
	// xfer_size need to change
	// data memory
	
											   // read_enable   write_data		xfer_size
	datamem data (ALU_out, MemWrite, memRead, 		  Db,			 clk,	4'b1000,  datamem_out);
	mux_64x4x1 MenToRegMux (regWriteData, shifter2_out, ALU_out, datamem_out, 64'bx, MemToReg); 

endmodule


module cpu_testbench();
	parameter ClockDelay = 5000;
	logic reset;
	logic clk;
	
	cpu dut (.reset, .clk);
	initial begin
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	integer i;
	
	initial begin
		reset <= 1; @(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
		for (i = 0; i < 1500; i = i + 1) begin
			reset <= 0; @(posedge clk);
		end
		$stop;
	end
	
endmodule



















