module score(clk, reset, start, add, display, addOne);
	// basic input
	input logic clk, reset, start, add;
	logic [6:0] ps, ns;
	// whether to add one point
	output logic addOne;
	// hex display
	output logic [6:0] display;
	
	always_comb
		if (add)
			case(ps)
				7'b1000000: ns = 7'b1111001; // 0-1
				7'b1111001: ns = 7'b0100100; // 1-2
				7'b0100100: ns = 7'b0110000; // 2-3
				7'b0110000: ns = 7'b0011001; // 3-4
				7'b0011001: ns = 7'b0010010; // 4-5
				7'b0010010: ns = 7'b0000010; // 5-6
				7'b0000010: ns = 7'b1111000; // 6-7
				7'b1111000: ns = 7'b0000000; // 7-8
				7'b0000000: ns = 7'b0010000; // 8-9
				7'b0010000: ns = 7'b1000000; // 9-0
				default ns = 7'b1111001; // 1
			endcase
		else
			ns = ps;
			
	assign display[6:0] = ps[6:0];		
	assign addOne = (ps[6:0] == 7'b0010000) & add; // nine and increment
	// update
	always_ff @(posedge clk)
		if(reset | !start)
			ps <= 7'b1000000;
		else
			ps <= ns;
			
endmodule


module score_testbench();
	logic clk, reset, start, add, addOne;
	logic [6:0] display;
	score dut(clk, reset, start, add, display, addOne);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
	

	initial begin

		

		reset <= 1;	start <= 0;	

					add <= 1;	@(posedge clk);


		reset <= 0;									@(posedge clk);

						start <= 1;				@(posedge clk);

										add <= 0;	@(posedge clk);

										add <= 1;	@(posedge clk);

														@(posedge clk);

														@(posedge clk);

														@(posedge clk);

														@(posedge clk);

														@(posedge clk);

														@(posedge clk);

														@(posedge clk);

										add <= 0;	@(posedge clk);

										add <= 1;	@(posedge clk);

														@(posedge clk);

		$stop;

	end

endmodule