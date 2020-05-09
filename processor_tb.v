module processor_tb();
	reg rst;
	reg clk;
	
	wire [63:0] k;
	wire [31:0] rom_addr;
	wire [4:0] r_addr, a_addr, b_addr, fs;
	wire [1:0] ps;
	
	processor dut (rst, clk);
	
	initial begin
		rst <= 1'b0;
		clk <= 1'b0;
	end
	
	always #5 clk <= ~clk;
	
	always begin
		#1 rst <= 1'b1;
		#1 rst <= 1'b0;
		#200 $stop;
	end

	assign k = dut.k;
	assign rom_addr = dut.rom_addr;
	assign r_addr = dut.cw[36:32];
	assign a_addr = dut.cw[31:27];
	assign b_addr = dut.cw[26:22];
	assign fs = dut.cw[18:14];
	assign ps = dut.cw[7:6];
	
endmodule 