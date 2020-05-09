module control_tb ();
	reg [31:0] i;
	reg [3:0] status;
	reg clk;
	wire [38:0] ctrl_word;
	wire [63:0] k;
	
	wire [102:0] ex0, ex1, ex2;
	
	wire [4:0] r_addr, a_addr, b_addr, fs;
	wire [1:0] ps, ns;
	wire [1:0] ctrl_sel, ex0_sel;
	
	control_unit dut (ctrl_word, k, i, status, clk);

	initial begin
		i <= 32'b0; // ADD X2 = X0 + X1
		status <= 4'b0;
		clk <= 1'b0;
	end
	
	always #5 clk <= ~clk;
	
	always begin
		#5  i <= 32'b10001011000000010000000000000010; // ADD X2 = X0 + X1
		#10 i <= 32'b10010001000000000000110000000001; // ADDI X1 = X0 + 3
		#10 i <= 32'b10110101000000000000000001100001; // CBNZ
		#50 $stop;
	end
	
	assign r_addr = ctrl_word[36:32];
	assign a_addr = ctrl_word[31:27];
	assign b_addr = ctrl_word[26:22];
	assign fs = ctrl_word[18:14];
	assign ps = ctrl_word[7:6];
	assign ns = ctrl_word[38:37];
	
	assign ctrl_sel = dut.ctrl_sel;
	assign ex0_sel = dut.ex0_sel;
	
	assign ex0 = dut.ex0;
	assign ex1 = dut.ex1;
	assign ex2 = dut.ex2;
	
endmodule 