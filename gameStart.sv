module gameStart(clk, reset, press, start);
	input logic clk, reset, press;
	logic ps, ns;
	output logic start;
	
	// The game starts by pressing the key, and stays on
	always_comb
		ns = ps | press;
	
	// update the status
	always_ff @(posedge clk)
		if (reset)
			ps <= 1'b0;
		else 
			ps <= ns;
			
	assign start = ps;
	
endmodule

module gameStart_testbench();
	logic clk, reset, press, start;
	gameStart dut(clk, reset, press, start);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
	
	initial begin

		reset <= 1;	press <= 1;	@(posedge clk);

						press <= 0;	@(posedge clk);

		reset <= 0;					@(posedge clk);

										@(posedge clk);

						press <= 1;	@(posedge clk);

						press <= 0;	@(posedge clk);

		reset <= 1;					@(posedge clk);

										@(posedge clk);

		$stop;

	end

endmodule


	
