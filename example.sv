// how to write comment
/*
	or in this way
*/
module AND_OR(andOut, orOut, A, B);
	input logic A, B;
	output logic andOut, orOut;
	
	and TheAndGate(andOut, A, B);
	or TheOrGate(orOut, A, B);

endmodule
