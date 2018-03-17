module pipePattern(clk, reset, start, over, random, pattern);

	input logic clk, reset, start, over;
	input logic [2:0] random;
	// this variable decides how much gap is between two walls
	logic [1:0] gap;
	logic [7:0] ps, ns;
	logic [7:0] count;
	output logic [7:0] pattern;
	

	always_comb
		if (over)
			ns = ps;
		else begin
			if (gap == 0)
				case(random)
				    // select the wall patterns here
					3'b000: ns = 8'b00001111;
					3'b001: ns = 8'b11001111;
					3'b010: ns = 8'b11100111;
					3'b011: ns = 8'b11110011;
					3'b100: ns = 8'b11110001;
					3'b101: ns = 8'b00001111;
					3'b110: ns = 8'b11000111;
					3'b111: ns = 8'b11100011;
					default: ns = 8'b00000000;
				endcase
			else
				ns = 8'b00000000;
		end
		
	assign pattern = ps;
	// flip flop
	always_ff @(posedge clk)
	// reset
		if (reset | ~start) begin 
			gap <= 0;
			ps <= 8'b00000000;
			count <= 8'b00000000;
		end
		else begin
		   // count controls the speed of the update
			// the state update everytime count is 0 
			if	(count == 0) begin 
				
				ps <= ns;
				gap <= gap + 2'b01;
			end
			count <= count + 1;
		end		
		
endmodule

module pipePattern_testbench();
	logic clk, reset, start, over;
	logic [2:0] random;
	logic [7:0] pattern;
	pipePattern dut(clk, reset, start, over, random, pattern);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end

	initial begin

		reset <= 1;	start <= 0;	random <= 3'b010;	@(posedge clk);

		reset <= 0;											@(posedge clk);

						start <= 1;						@(posedge clk);

											random <= 3'b000;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

											random <= 3'b001;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

											random <= 3'b010;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

											random <= 3'b011;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

											random <= 3'b100;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

											random <= 3'b101;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

											random <= 3'b110;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

											random <= 3'b111;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

						over <= 1;		random <= 3'b110;	@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

																@(posedge clk);

		$stop;

	end

endmodule