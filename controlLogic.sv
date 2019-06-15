`timescale 1ns/10ps
module controlLogic (Reg2Loc, RegWrite, MemWrite, BrTaken, UnCondBr, setFlag, ALUSrc, MemToReg, ALUOp, memRead, Rd, Rn, Rm, Imm12,
                    Imm9, Imm26, Imm19, SHAMT, operation, zero, negative, overflow, carryout, zero_new, negative_new, overflow_new, carry_out_new);

	input logic [31:0] operation;
	input logic zero, negative, overflow, carryout, zero_new, negative_new, overflow_new, carry_out_new;

	output logic Reg2Loc, RegWrite, MemWrite, BrTaken, UnCondBr, setFlag, memRead;	
	output logic [1:0] ALUSrc, MemToReg;
	output logic [2:0] ALUOp;
	output logic [4:0] Rd, Rn, Rm;
	output logic [11:0] Imm12;
	output logic [8:0] Imm9;
	output logic [25:0] Imm26;
	output logic [18:0] Imm19;
	output logic [5:0] SHAMT;

	assign Rd = operation[4:0];
	assign Rn = operation[9:5];
	assign Rm = operation[20:16];
	assign SHAMT = operation[15:10];

	assign Imm9  = operation[20:12];
	assign Imm12 = operation[21:10];
	assign Imm19 = operation[23:5];
	assign Imm26 = operation[25:0];
	
	parameter ADDI = 10'b1001000100;          // 0x244
	parameter ADDS = 11'b10101011000;         // 0x558
	parameter AND =  11'b10001010000;         // 0x450
	parameter B = 6'b000101;                  // 0x05;
	parameter BLT = 8'b01010100;              // 0x54 to choose B.cond
	parameter CBZ = 8'b10110100;              // 0xB4
	parameter EOR = 11'b11001010000;           // 0x650
	parameter LDUR = 11'b11111000010;         // 0x7c2
	parameter LSR = 11'b11010011010;          // 0x69a
	parameter STUR = 11'b11111000000;         // 0x7c0
	parameter SUBS = 11'b11101011000;         // 0x758
	
  // cntrl			Operation				  		Notes:
  // 000:			result = B						value of overflow and carry_out unimportant
  // 010:			result = A + B
  // 011:			result = A - B
  // 100:			result = bitwise A & B		value of overflow and carry_out unimportant
  // 101:			result = bitwise A | B		value of overflow and carry_out unimportant
  // 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
  logic [13:0] control;
  
  //        [13]      [12:11]     [10:9]           [8]     [7]        [6]       [5]      [4]      [3:1]       [0]     
  assign  {Reg2Loc, ALUSrc[1:0], MemToReg[1:0], RegWrite, MemWrite, setFlag, BrTaken, UnCondBr, ALUOp[2:0], memRead} = control;

  
	always_comb begin
		if(operation[31:22] == ADDI) begin			
			control = 14'bx01101000x0100;
			// memRead = 1'b0;
		end else if (operation [31:21] == ADDS) begin
			control = 14'b011101010x0100;
			// memRead = 1'b0;
		end else if (operation[31:21] == AND) begin
			control = 14'b011101000x1000;
			// memRead = 1'b0;
		end else if (operation[31:26] == B) begin
			control = 14'bxxxxx00010xxx0;
			// memRead = 1'b0;
		end else if (operation[31:24] == BLT && operation[4:0] == 5'b01011) begin
			// memRead = 1'b0;
//			Reg2Loc = 1'bx;
//			ALUSrc = 2'bx;
//		   MemToReg = 2'bx;
//			RegWrite = 1'b0;
//			MemWrite = 1'b0;
//			setFlag = 1'b0;
//	      BrTaken = (negative != overflow);
//			UnCondBr = 1'b1;
//			ALUOp = 3'bx;
			control = 14'bxxxxx000x1xxx0;
			control[5] = (negative != overflow);
		end else if (operation[31:24] == CBZ) begin
			//memRead = 1'b0;
//			Reg2Loc = 1'b0;
//			ALUSrc = 2'b0;
//		   MemToReg = 2'bx;
//			RegWrite = 1'b0;
//			MemWrite = 1'b0;
//			setFlag = 1'b0;
//			BrTaken = zero;
//			UnCondBr = 1'b1;
//			ALUOp = 3'bx;
			control = 14'b111xx000x10000; // bypass? test 0
			control[5] = zero_new;
		end else if (operation[31:21] == EOR) begin
			// memRead = 1'b0;
			control = 14'b011101000x1100;
		end else if(operation[31:21] == LDUR) begin
			//memRead = 1'b1;
			control = 14'bx10011000x0101;
		end else if(operation[31:21] == LSR) begin
			//memRead = 1'b0;
			control = 14'bxxx111000xxxx0;
		end else if(operation[31:21] == STUR) begin
			//memRead = 1'b0;
			control = 14'b110xx0100x0100;
		end else if(operation[31:21] == SUBS) begin
			//memRead = 1'b0;
			control = 14'b011101010x0110;
		end else begin
			control = 14'b0;
		end
	end
endmodule

module controlLogic_testbench();
   logic [31:0] operation;
	logic zero, negative, overflow, carryout, zero_new, negative_new, overflow_new, carry_out_new;

	logic Reg2Loc, RegWrite, MemWrite, BrTaken, UnCondBr, setFlag, memRead;	
	logic [1:0] ALUSrc, MemToReg;
	logic [2:0] ALUOp;
	logic [4:0] Rd, Rn, Rm;
	logic [11:0] Imm12;
	logic [8:0] Imm9;
	logic [25:0] Imm26;
	logic [18:0] Imm19;
	logic [5:0] SHAMT;

    
		
	initial begin
	   zero = 0; negative = 0; overflow = 0; carryout = 0; zero_new = 0; 
		negative_new = 0; overflow_new = 0; carry_out_new = 0;
		operation = 32'b10010001000000000000001111100000; #10; //ADDI
		operation = 32'b00010100000000000000000000000000;  #10;  //B
		operation = 32'b11101011000000100000000000100011; #10;   //SUBS
      operation = 32'b10101011000001010000000000100111;  #10;  //ADDS
		operation = 32'b10110100000000000000001010011111; #10; //CBZ
		operation = 32'b11111000000000000000001111100000; #10; //STUR
		operation = 32'b11111000010000000101000001000110; #10; //LDUR
	end


   controlLogic dut (.Reg2Loc, .RegWrite, .MemWrite, .BrTaken, .UnCondBr, .setFlag, .ALUSrc, .MemToReg, .ALUOp, .memRead, .Rd, .Rn, .Rm, .Imm12,
                    .Imm9, .Imm26, .Imm19, .SHAMT, .operation, .zero, .negative, .overflow, .carryout, .zero_new, .negative_new, .overflow_new, .carry_out_new);

						  
						  
						  
endmodule
