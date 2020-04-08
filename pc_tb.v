module pc_tb ();
	wire [31:0] pc_out;
	reg [31:0] pc_in;
	reg [3:0] status;
	reg [1:0] ps;
	reg clk;
	reg rst;
	
	program_counter dut (pc_out, pc_in, status, ps, clk, rst);
	
	/*
	PS encoding:
	00 - hold
	01 - increment
	10 - load
	11 - offset
	*/
	
	initial begin
		pc_in <= 32'd7;
		status <= 4'b0;
		ps <= 2'b10;
		clk <= 1'b0;
		rst <= 1'b0;
	end
	
	always #5 clk <= ~clk;
	
	always begin
		#3 rst <= 1'b1;
		#1 rst <= 1'b0;
		#10 ps <= 2'b01;
		#20 ps <= 2'b10;
		#10 ps <= 2'b11;
		#10 ps <= 2'b00;
		#10 $stop;
	end
	
endmodule 