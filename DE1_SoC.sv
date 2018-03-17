module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, KEY, SW, GPIO_0);
	 input logic CLOCK_50; // 50MHz CLOCK_50.
	 output logic [6:0] HEX0, HEX1, HEX2;
	 input logic [3:0] KEY; // True when not pressed, False when pressed
	 input logic [9:0] SW;
	 output logic [35:0] GPIO_0;
	 logic w;
	 logic start;
	 logic over;
	 logic player;
	 logic [7:0][7:0] red_array, green_array;
	 logic[7:0] pattern;
	 logic reset;
	 logic [2:0]  randomNum;
	 
	 // Generate clk off of CLOCK_50, whichClock picks rate.
	 logic [31:0] clk;
	 parameter whichClock = 15;
	 clock_divider cdiv(CLOCK_50, clk);
	 
	 always_ff @(posedge clk[whichClock])
		w <= SW[9];
    always_ff @(posedge clk[whichClock])
	   reset <= w; // Reset when SW[9] is pressed.
	 

	 
	 
	 userInput  user(.reset(reset), .clk(CLOCK_50), .key(~KEY[0]), .press(player));
	 gameStart gameActivate(.clk(clk[whichClock]), .reset, .press(player), .start);
	 
	 bird l0 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(1'b0), .lower(red_array[0][6]), .light(red_array[0][7]), .highest(1'b1));
	 bird l1 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][7]), .lower(red_array[0][5]), .light(red_array[0][6]), .highest(1'b0));
	 bird l2 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][6]), .lower(red_array[0][4]), .light(red_array[0][5]), .highest(1'b0));
	 bird l3 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][5]), .lower(red_array[0][3]), .light(red_array[0][4]), .highest(1'b0));
	 bird l4 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b1), .upper(red_array[0][4]), .lower(red_array[0][2]), .light(red_array[0][3]), .highest(1'b0));
	 bird l5 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][3]), .lower(red_array[0][1]), .light(red_array[0][2]), .highest(1'b0));
	 bird l6 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][2]), .lower(red_array[0][0]), .light(red_array[0][1]), .highest(1'b0));
	 bird l7 (.clk(clk[whichClock]), .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][1]), .lower(1'b0), .light(red_array[0][0]), .highest(1'b0));
	
    assign red_array[7][7:0] = 8'b00000000;
	 assign red_array[6][7:0] = 8'b00000000;	
	 assign red_array[5][7:0] = 8'b00000000;	
	 assign red_array[4][7:0] = 8'b00000000;	
	 assign red_array[3][7:0] = 8'b00000000;	
	 assign red_array[2][7:0] = 8'b00000000;	
	 assign red_array[1][7:0] = 8'b00000000;	
	 
	 LFSR3 random(.clk(clk[whichClock]), .reset(reset), .active(start), .enable(1), .out(randomNum));
	 pipePattern pipe0(.clk(clk[whichClock]), .reset(reset), .start(start), .over(over), .random(randomNum), .pattern(pattern));
	 horizontal pipe1(.clk(clk[whichClock]), .reset(reset), .pattern(pattern), .start(start), .over(over), .array(green_array));
	 
	 logic [7:0] rowsink, redDriver, greenDriver;
	 assign GPIO_0 [35:28] = greenDriver;
	 assign GPIO_0 [27:20] = redDriver;
	 assign GPIO_0 [19:12] = rowsink;
	 led_matrix_driver led_array(.clock(clk[10]), .red_array, .green_array, .red_driver(redDriver), .green_driver(greenDriver), .row_sink(rowsink));
	 logic point;
	 gameOver isOver(.clk(clk[whichClock]), .reset(reset), .playerPosition(red_array[0]), .wallPosition(green_array[0]), .start, .point, .over);
	 
	 logic add0, add1, add2;
	 score display0(.clk(clk[whichClock]), .reset, .start, .add(point), .display(HEX0[6:0]), .addOne(add0));
	 score display1(.clk(clk[whichClock]), .reset, .start, .add(add0), .display(HEX1[6:0]), .addOne(add1));
	 score display2(.clk(clk[whichClock]), .reset, .start, .add(add1), .display(HEX2[6:0]), .addOne(add2));
endmodule

	// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz,
	// [25] = 0.75Hz, ... 
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;

	initial
		divided_clocks <= 0;

	always_ff @(posedge clock)
		divided_clocks <= divided_clocks + 1;
endmodule 
/*

module DE1_SoC (clk, HEX0, HEX1, HEX2, KEY, SW, GPIO_0);
	 input logic clk; // 50MHz CLOCK_50.
	 output logic [6:0] HEX0, HEX1, HEX2;
	 input logic [3:0] KEY; // True when not pressed, False when pressed
	 input logic [9:0] SW;
	 output logic [35:0] GPIO_0;
	 logic w;
	 logic start;
	 logic over;
	 logic player;
	 logic [7:0][7:0] red_array, green_array;
	 logic[7:0] pattern;
	 logic reset;
	 logic [2:0]  randomNum;
	 
	 
	 always_ff @(posedge clk)
		w <= SW[9];
    always_ff @(posedge clk)
	   reset <= w; // Reset when SW[9] is pressed.
	 

	 
	 
	 userInput  user(.reset(reset), .clk, .key(~KEY[0]), .press(player));
	 gameStart gameActivate(.clk, .reset, .press(player), .start);
	 
	 bird l0 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(1'b0), .lower(red_array[0][6]), .light(red_array[0][7]), .highest(1'b1));
	 bird l1 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][7]), .lower(red_array[0][5]), .light(red_array[0][6]), .highest(1'b0));
	 bird l2 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][6]), .lower(red_array[0][4]), .light(red_array[0][5]), .highest(1'b0));
	 bird l3 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][5]), .lower(red_array[0][3]), .light(red_array[0][4]), .highest(1'b0));
	 bird l4 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b1), .upper(red_array[0][4]), .lower(red_array[0][2]), .light(red_array[0][3]), .highest(1'b0));
	 bird l5 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][3]), .lower(red_array[0][1]), .light(red_array[0][2]), .highest(1'b0));
	 bird l6 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][2]), .lower(red_array[0][0]), .light(red_array[0][1]), .highest(1'b0));
	 bird l7 (.clk, .reset, .press(player), .over(over), .start, .initialState(1'b0), .upper(red_array[0][1]), .lower(1'b0), .light(red_array[0][0]), .highest(1'b0));
	
    assign red_array[7][7:0] = 8'b00000000;
	 assign red_array[6][7:0] = 8'b00000000;	
	 assign red_array[5][7:0] = 8'b00000000;	
	 assign red_array[4][7:0] = 8'b00000000;	
	 assign red_array[3][7:0] = 8'b00000000;	
	 assign red_array[2][7:0] = 8'b00000000;	
	 assign red_array[1][7:0] = 8'b00000000;	
	 
	 LFSR3 random(.clk, .reset(reset), .active(start), .enable(1), .out(randomNum));
	 pipePattern pipe0(.clk, .reset(reset), .start(start), .over(over), .random(randomNum), .pattern(pattern));
	 horizontal pipe1(.clk, .reset(reset), .pattern(pattern), .start(start), .over(over), .array(green_array));
	 
	 logic [7:0] rowsink, redDriver, greenDriver;
	 assign GPIO_0 [35:28] = greenDriver;
	 assign GPIO_0 [27:20] = redDriver;
	 assign GPIO_0 [19:12] = rowsink;
	 led_matrix_driver led_array(.clock(clk), .red_array, .green_array, .red_driver(redDriver), .green_driver(greenDriver), .row_sink(rowsink));
	 logic point;
	 gameOver isOver(.clk, .reset(reset), .playerPosition(red_array[0]), .wallPosition(green_array[0]), .start, .point, .over);
	 
	 logic add0, add1, add2;
	 score display0(.clk, .reset, .start, .add(point), .display(HEX0[6:0]), .addOne(add0));
	 score display1(.clk, .reset, .start, .add(add0), .display(HEX1[6:0]), .addOne(add1));
	 score display2(.clk, .reset, .start, .add(add1), .display(HEX2[6:0]), .addOne(add2));
endmodule

module DE1_SoC_testbench();
	logic clk;
	logic [6:0] HEX0, HEX1, HEX2;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [35:0] GPIO_0;
	DE1_SoC dut(clk, HEX0, HEX1, HEX2, KEY, SW, GPIO_0);
	
	// set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin  
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end
	
	initial begin

		SW[9] <= 1;	KEY[0] <= 1;	@(posedge clk);

						KEY[0] <= 0;	@(posedge clk);

		SW[9] <= 0;						@(posedge clk);

						KEY[0] <= 1;	@(posedge clk);

											@(posedge clk);

						KEY[0] <= 0;	@(posedge clk);

						KEY[0] <= 1;	@(posedge clk);

						KEY[0] <= 0;	@(posedge clk);

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

		$stop;

	end

endmodule
*/
