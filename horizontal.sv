module horizontal(clk, reset, pattern, start, over, array);
	input logic clk, reset, start, over;
	input logic [7:0] pattern;
	// this variable controls the update speed
	logic [7:0] control;
	logic [7:0] [7:0] ps, ns;
	// this is the entire LED matrix output
	output logic [7:0] [7:0] array;
	
	always_comb
		if (over)
			ns [7:0] = ps[7:0];
		else begin
		// shift by one column and push in the newly generated pattern
			ns[6:0] = ps[7:1];
			ns[7] = pattern;
		end
	
	assign array = ps;
	
	always_ff @(posedge clk)
		if (reset | ~start) begin
			control <= 0;
			ps[0] <= 7'b0;
			ps[1] <= 7'b0;
			ps[2] <= 7'b0;
			ps[3] <= 7'b0;
			ps[4] <= 7'b0;
			ps[5] <= 7'b0;
			ps[6] <= 7'b0;
			ps[7] <= 7'b0;
		end
		else begin	
		// controls update speed
		// update when cpmtrol is 0
			if (control == 0) ps <= ns;	
			control <= control + 1;
		end
endmodule

module horizontal_testbench();
	logic clk, reset, start, over;
	logic[7:0] pattern;
	logic[7:0][7:0] array;
	horizontal dut(clk, reset, pattern, start, over, array);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
	

	initial begin
		reset <=1;                                            @(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
		reset <=0; start <=1; over<=0; pattern <= 7'b1000001; @(posedge clk);
												                        @(posedge clk);
												                        @(posedge clk);
												                        @(posedge clk);
		reset <=0; start <=1; over<=0; pattern <= 7'b1100000; @(posedge clk);
												                        @(posedge clk);
												                        @(posedge clk);
												                        @(posedge clk);
	   reset <=0; start <=1; over<=0; pattern <= 7'b1111000; @(posedge clk);
												                        @(posedge clk);
												                        @(posedge clk);
												                        @(posedge clk);
	
		$stop;
	end
endmodule

	
	