module processor (rst, clk);
	input rst, clk;
	
	wire [63:0] k;
	wire [38:0] cw;
	wire [31:0] rom_addr;
	wire [3:0] status;
	
	datapath 	dp (rom_addr, status, k, cw[36:32], cw[31:27], cw[26:22], cw[18:14], cw[7:6], cw[21], cw[20], cw[19], cw[12], cw[11], cw[10], cw[9], cw[8], cw[0], cw[4], cw[3], cw[5], cw[13], rst, clk);
	controlpath cp (k, cw, rom_addr, status, clk);
	
endmodule 