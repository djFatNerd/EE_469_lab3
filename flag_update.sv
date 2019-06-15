module flag_update(q, d, clk, en);
	output logic q;
	input logic  d; // new flag control signal
	input logic clk;
	input logic en;
	logic data;
	

   mux_2x1 checkEnable(data, {d, q}, en);
   D_FF dffs(q, data, 1'b0, clk);
	
endmodule

module flag_update_testbench();
	logic d;
	logic q;
	logic clk;
	logic en;
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin 
		
		 d <= 0; en <= 0;      		 	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
		 d = 1;			    				@(posedge clk);
												@(posedge clk);
												@(posedge clk);
										      @(posedge clk);
		 d = 1; 	en <= 1;					@(posedge clk); // enable to setFlag
					en <= 0;     			@(posedge clk);
												@(posedge clk);
										      @(posedge clk);
		            						@(posedge clk);
										      @(posedge clk);
												@(posedge clk);
		 d = 0;		       				@(posedge clk);
										      @(posedge clk);
												@(posedge clk);
										      @(posedge clk);								
		 d = 1;	    						@(posedge clk);
										      @(posedge clk);
												@(posedge clk);
										      @(posedge clk);											
		 d = 0;       	 en <= 1;		@(posedge clk);
		 d = 1;								@(posedge clk);
		 										@(posedge clk);
							 en <= 0; 		@(posedge clk);
												@(posedge clk);
		$stop;
	end
	
	flag_update dut (.q, .d, .clk, .en);
	
endmodule