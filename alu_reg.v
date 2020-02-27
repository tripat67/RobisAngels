module alu_reg (f, dout, status, din, k, fs, addrR, addrA, addrB, s, sb, sd, c0, w, clk, rst);
	output [63:0] dout;							// in-out port
	output [63:0] f;								// ALU result
	output [3:0]  status;						// ALU status 
	input  [63:0] din;							// data in
	input  [63:0] k;
	input  [4:0]  addrR, addrA, addrB;		// register file decoder and mux addresses
	input  [4:0]  fs;								// ALU function select
	input  sb, sd;									// tristate buffer enables
	input  s;
	input  w, clk, rst;							// write, clock, reset
	input  c0;										// ALU carry in
	
	wire [63:0] dataA, dataB;
	wire [63:0] mout;
	
	wire [63:0] R0, R1, R3, R5, R20, R21, R22, R23;
	
	register_file u0 (w, addrR, din, rst, addrA, addrB, clk, dataA, dataB, R0, R1, R3, R5, R20, R21, R22, R23);
	alu 			  u1 (dataA, mout, fs, c0, f, status);
	
	mux2_1 m1 (mout, dataB, k, s);			// b mux
	
	triStateBuffer tsb0 (dout, dataB, sb);	// dataB tristate buffer
	triStateBuffer tsb1 (dout, f, sd);   	// data tristate buffer

endmodule 

module mux2_1 (out, in0, in1, s);
	output [63:0] out;
	input  [63:0] in0, in1;
	input  s;
	
	assign out = s ? in1 : in0;
	
endmodule 

module triStateBuffer (out, in, s);
	output [63:0] out;
	input  [63:0] in;
	input  s;
	
	assign out = s ? in : 64'bz;
	
endmodule 