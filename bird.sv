module bird(clk, reset, press, over, start, initialState, upper, lower, light, highest);
	input logic clk, reset, press, over, start, initialState, upper, lower, highest;
	logic ns;
	output logic light;
	// update speed controler
	logic [6:0] count;
	
	always_comb	
		if (over) 
			ns = light;
		else begin
			case(light)
			   // when currently light is off
				// if lower light is on and key pressed --> light on
				// if upper light is on and key not pressed --> light on
				1'b0: if ((press & lower) | (~press & upper)) ns = 1'b1; 
						else ns = 1'b0;
				// when currnet light is on
				// if this light is the upper limit and the key is pressed --> light is on
				1'b1: if (highest & press) ns = 1'b1;
						else ns = 1'b0;
			endcase
		end
		
	always_ff @(posedge clk)
	// reset the game
		if (reset | !start) begin
			light <= initialState;
			count <= 6'b000000;
		end
		// update the status
		else begin 
			if (count == 0) light <= ns;
			count <= count + 6'b000001;
	   end	
endmodule

module bird_testbench();
	logic clk, reset, press, over, start, initialState, upper, lower, highest, light;
	bird dut(clk, reset, press, over, start, initialState, upper, lower, light, highest);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
	
			initial begin

		reset <= 1;	start <= 0;

		highest <= 0;	over <= 0;		upper <= 0;	lower <= 0;

						initialState <= 1;								@(posedge clk);

						initialState <= 0;								@(posedge clk);

						press <= 1;				lower <= 1;	@(posedge clk);

		

		reset <= 0;											@(posedge clk);

						press <= 0;							@(posedge clk);

						press <= 1;							@(posedge clk);

		start <= 1;										@(posedge clk);

													lower <= 0;	@(posedge clk);

										upper <= 1;				@(posedge clk);

						press <= 0;							@(posedge clk);

										upper <= 0;				@(posedge clk);

													lower <= 1;	@(posedge clk);

													

			highest <= 1;	press <= 1;							@(posedge clk);

													lower <= 0;	@(posedge clk);

			over <= 1;										@(posedge clk);

						press <= 0;							@(posedge clk);

																@(posedge clk);

		$stop;

	end

endmodule