// This module solves metastability
module userInput (clk, reset, key, press);
	input logic clk, reset;
	input logic key;
	output logic press;
   logic	ps, ns;
   // next state is the key press
	always_comb begin
		ns = key;
	end
	
	assign press = ps;

	
	// pass input through flipflop
	always @(posedge clk) begin
		if (reset) ps <= 1'b0;
		else ps <= ns;
	end
endmodule

// test bench
module userInput_testbench();
	logic clk, reset, key, press;
	userInput dut(clk, reset, key, press);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
   initial begin

		reset <= 1;	key <= 1;	@(posedge clk);

						key <= 0;	@(posedge clk);

		reset <= 0;					@(posedge clk);

						key <= 1;	@(posedge clk);

										@(posedge clk);

										@(posedge clk);

						key <= 0;	@(posedge clk);

										@(posedge clk);

		$stop;

	end

endmodule
