// generate random number 
module LFSR3 (clk, reset, active, enable, out);
	input logic clk, reset, enable, active;
	output logic [2:0] out;
	wire feedback;
	assign feedback = !(out[2]^out[1]);
	// control the speed of the clock
	logic[7:0] control = 0;

	always @(posedge clk) begin
		if (reset | ~active) begin
			out <= 3'b0;
			control <= 0;
		end else if(enable) begin
			if (control == 1) begin
				out <= {out[1], out[0], feedback};
			end
			control <= control + 1;
		end	
	end
endmodule

module LFSR3_testbench();
	logic clk, reset, enable, active;
	logic [2:0] out;
	LFSR3 dut(clk, reset, active, enable, out);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
	
	initial begin
	   reset <= 1;  active <= 0; @(posedge clk);
		            @(posedge clk);
						@(posedge clk);
	   reset <= 0; enable <= 1; active <= 1; @(posedge clk);
										             @(posedge clk);
										             @(posedge clk);
										             @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);											
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
									 	 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
										 @(posedge clk);
	   $stop; // End the simulation.
   end
endmodule