module datapath_tb ();
	wire [63:0] f;
	wire [63:0] d;
	wire [3:0]  status;						
	reg  [63:0] k;								
	reg  [4:0]  addrR, addrA, addrB;	
	reg  [4:0]  fs;							
	reg  sd, sb;								
	reg  s;
	reg  w, clk, rst;						
	reg  c0;	

	wire [63:0] R0, R1,  R3, R5, R20, R21, R22, R23;

	alu_reg dut (f, d, status, k, fs, addrR, addrA, addrB, s, sd, sb, c0, w, clk, rst);
	
	initial begin
		k <= 64'd0;
		addrR <= 5'b00000;
		addrA <= 5'b00000;
		addrB <= 5'b00000;
		fs <= 5'b01000;
		sd <= 1'b0;
		sb <= 1'b0;
		s <= 1'b0;
		w <= 1'b0;
		clk <= 1'b0;
		rst <= 1'b0;
		c0 <= 1'b0;
	end
	
	always #1 clk <= ~clk;
	
	always begin
		// pulse rst
		#1 rst <= 1'b1;
		#1 rst <= 1'b0;
		
		// load registers
		#1 k <= 64'd916;
		#1 addrR <= 5'd0;
		#1 s <= 1'b1;
		#1 sd <= 1'b1;
		#1 addrA <= 5'd31;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		
		#1 k <= 64'd619;
		#1 addrR <= 5'd1;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		
		#1 k <= 64'b01010111;
		#1 addrR <= 5'd3;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		
		#1 k <= 64'b111;
		#1 addrR <= 5'd5;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		
		#1 s <= 1'b0;
		
		// math time
		
		/* 
		function select inputs
		fs[0] - invert dataB
		fs[1] - invert dataA
		fs[4:2]:
			000 - AND
			001 - OR
			010 - ADD
			011 - XOR
			100 - LSL
			101 - LSR
			110 - unused
			111 - unused
	*/
		
		#1 fs <= 5'b01000;
		#1 addrR <= 5'd20;
		#1 addrA <= 5'd0;
		#1 addrB <= 5'd1;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		
		#1 fs <= 5'b00000;
		#1 addrR <= 5'd21;
		#1 addrA <= 5'd3;
		#1 addrB <= 5'd5;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		
		#1 fs <= 5'b10000;
		#1 addrR <= 5'd22;
		#1 addrA <= 5'd5;
		#1 k <= 64'd3;
		#1 s <= 1'b1;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 s <= 1'b0;
		
		
		
		#1 $stop;
	end
	
	assign R0 = dut.R0;
	assign R1 = dut.R1;
	assign R3 = dut.R3;
	assign R5 = dut.R5;
	assign R20 = dut.R20;
	assign R21 = dut.R21;
	assign R22 = dut.R22;
	assign R23 = dut.R23;

endmodule 