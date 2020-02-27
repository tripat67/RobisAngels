module datapath_tb ();
	wire [63:0]f;
	wire [63:0] dout;
	wire [3:0] status; 
	reg  [63:0] din;
	reg  [63:0] k; 
	reg  [4:0] fs; 
	reg  [4:0] addrR, addrA, addrB;
	reg s, sb, sd, c0, w, clk, rst;
	
	wire [63:0] R0, R1, R3, R5, R20, R21, R22, R23;
	
	alu_reg dut (f, dout, status, din, k, fs, addrR, addrA, addrB, s, sb, sd, c0, w, clk, rst);
	
	initial begin 
		din <= 64'b0;
		k <= 64'b0;
		fs <= 5'b00000;
		addrR <= 5'b0;
		addrA <= 5'b0;
		addrB <= 5'b0;
		s <= 1'b0;
		sb <= 1'b1;
		sd <= 1'b1;
		c0 <= 1'b0;
		w <= 1'b0;
		clk <= 1'b0;
		rst <= 1'b1;
	end
	
	always #1 clk <= ~ clk;
	
	always begin 
		#1 rst <= 1'b0;
		#1 din <= 64'd18;
		#1 addrR <= 5'd20;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 din <= 64'd7;
		#1 addrR <= 5'd21;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 din <= 64'd12;
		#1 addrR <= 5'd22;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 din <= 64'd5;
		#1 addrR <= 5'd23;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 addrA <= 5'd23;
		#1 addrB <= 5'd20;
		#1 fs <= 5'b01100;
		#1 addrR <= 5'd0;
		#1 din <= f;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 addrA <= 5'd21;
		#1 k <= 64'd3;
		#1 s <= 1'b1;
		#1 fs <= 5'b10000;
		#1 addrR <= 5'd1;
		#1 din <= f;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 s <= 1'b0;
		#1 addrA <= 5'd22;
		#1 addrB <= 5'd23;
		#1 fs <= 5'b01000;
		#1 addrR <= 5'd3;
		#1 din <= f;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#1 addrA <= 5'd20;
		#1 addrB <= 5'd22;
		#1 fs <= 5'b00000;
		#1 addrR <= 5'd5;
		#1 din <= f;
		#1 w <= 1'b1;
		#3 w <= 1'b0;
		#20 $stop;
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
