module datapath_tb ();
	wire [4:0] status;
	reg [63:0] k;
	reg [4:0] reg_addr;
	reg [4:0] a_addr;
	reg [4:0] b_addr;
	reg [4:0] fs;
	reg reg_w;
	reg b_sel;
	reg b_en;
	reg alu_en;
	reg mem_en;
	reg chip_sel;
	reg mem_w;
	reg mem_r;
	reg stat_en;
	reg c0;
	reg rst;
	reg clk;
	
	wire [63:0] R0, R1, R2, R3, R4, R5, R6, R7;
	wire [63:0] d, f;

	datapath dut (status, k, reg_addr, a_addr, b_addr, fs, reg_w, b_sel, b_en, alu_en, mem_en, chip_sel, mem_w, mem_r, stat_en, c0, rst, clk);
	
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
	
	initial begin 
		k <= 64'd0;
		reg_addr <= 5'b0;
		a_addr <= 5'b0;
		b_addr <= 5'b0;
		fs <= 5'b01000;
		reg_w <= 1'b0;
		b_sel <= 1'b0;
		b_en <= 1'b0;
		alu_en <= 1'b0;
		mem_en <= 1'b0;
		chip_sel <= 1'b0;
		mem_w <= 1'b0;
		mem_r <= 1'b0;
		stat_en <= 1'b0;
		c0 <= 1'b0;
		rst <= 1'b1;
		clk <= 1'b0;
	end
	
	always #5 clk <= ~clk;
	
	always begin
		#1  rst <= 1'b0;
		#1  a_addr <= 5'd31;
		#1  {reg_w, b_sel, alu_en} <= 3'b111;
		#1  {reg_addr, k} <= {5'd0, 64'd2};
		#10 {reg_addr, k} <= {5'd1, 64'd5};
		#10 {reg_addr, k} <= {5'd2, 64'b1010};
		#10 {reg_addr, k} <= {5'd3, 64'b1001};
		
		#1  b_sel <= 1'b0;
		
		#9  {reg_addr, a_addr, b_addr, fs, c0} <= {5'd4, 5'd0, 5'd1, 5'b01000, 1'b0};
		#10 {reg_addr, a_addr, b_addr, fs, c0} <= {5'd5, 5'd0, 5'd1, 5'b01010, 1'b1};
		#10 {reg_addr, a_addr, b_addr, fs, c0} <= {5'd6, 5'd2, 5'd3, 5'b00000, 1'b0};
		#10 {reg_addr, a_addr, b_sel, k, fs} <= {5'd7, 5'd3, 1'b1, 64'd1, 5'b10000};
		
		#10 $stop;
	end
	
	assign R0 = dut.R0;
	assign R1 = dut.R1;
	assign R2 = dut.R2;
	assign R3 = dut.R3;
	assign R4 = dut.R4;
	assign R5 = dut.R5;
	assign R6 = dut.R6;
	assign R7 = dut.R7;
	
	assign d = dut.d;
	assign f = dut.f;
	
endmodule 