module gameOver(clk, reset, playerPosition, wallPosition, start, point, over);
   // basic inputs 
	input logic clk, reset, start;
	input logic [7:0] playerPosition, wallPosition;
	
	// positions of the wall and the bird
	logic nsplayerPosition, psplayerPosition;
	logic [7:0] nswall, pswall;
	output logic over, point;
	
	always_comb begin
	   // below are cases when the player looses the game
		nsplayerPosition = playerPosition[0] // this is when the bird hits the floor
					// below is the cases when birds hits the pipe
					| (playerPosition[7] & wallPosition[7])
					| (playerPosition[6] & wallPosition[6])
					| (playerPosition[5] & wallPosition[5])
					| (playerPosition[4] & wallPosition[4])
					| (playerPosition[3] & wallPosition[3])
					| (playerPosition[2] & wallPosition[2])
					| (playerPosition[1] & wallPosition[1]);
		nswall = wallPosition;
	end
	
	assign over = psplayerPosition;
	// when the bird jump over one wall, the player gets 1 point
	assign point = ~(pswall == 8'b00000000) & (wallPosition == 8'b00000000);
	
	always_ff @(posedge clk)
		// reset the game
		if (reset | !start) begin
			psplayerPosition <= 1'b0;
			pswall <= 8'b00000000;
	   end
		// update 
		else begin
			psplayerPosition <= nsplayerPosition;
			pswall <= nswall;
		end
endmodule


module gameOver_testbench();
	logic clk, reset, start, point, over;
	logic [7:0] playerPosition, wallPosition;
	gameOver dut(clk, reset, playerPosition, wallPosition, start, point, over);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
	
		initial begin

		reset <= 1; start <= 0;

			playerPosition <= 8'b00010000;	wallPosition <= 8'b1111111; 	@(posedge clk);

		reset <= 0;														@(posedge clk);

						start <= 1;									@(posedge clk);

											wallPosition <= 8'b11001111;	@(posedge clk);

											wallPosition <= 8'b00000000;	@(posedge clk);

											wallPosition <= 8'b11111001;	@(posedge clk);

			playerPosition <= 8'b00000001;									@(posedge clk);

		reset <= 1;														@(posedge clk);

																			@(posedge clk);

		$stop;

	end

endmodule