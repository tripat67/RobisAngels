module program_counter (pc_out, pc_in, status, ps, clk, rst);

	output [31:0] pc_out;									// program counter output
	input [31:0] pc_in;										// program counter input
	input [3:0] status;										// alu status
	input [1:0] ps;											// mux select bits
	input clk;													// clock
	input rst;													// reset
		
	wire[31:0] pc_hold, pc_incr, pc_load, pc_offs;	// mux inputs
	
	/*
	PS encoding:
	00 - hold
	01 - increment
	10 - load
	11 - offset
	*/
	
	assign pc_hold = pc_out;
	assign pc_load = pc_in;
	assign pc_offs = pc_out + pc_in;
	
	incrementer inc0 (pc_incr, pc_out, clk, rst);
	mux_4to1 	mux0 (pc_out, pc_hold, pc_incr, pc_load, pc_offs, ps);

endmodule 

// 32-bit 4-to-1 mux
module mux_4to1 (out, in0, in1, in2, in3, s);

	output reg [31:0] out;
	input [31:0] in0, in1, in2, in3;
	input [1:0] s;
	
	always @ (s) begin
		case (s)
			2'b00: out <= in0;
			2'b01: out <= in1;
			2'b10: out <= in2;
			2'b11: out <= in3;
		endcase
	end

endmodule 

// 1-bit 16-to-1 mux
module mux_16to1 (out, in, s);
	
	output reg out;
	input [15:0] in;
	input [3:0] s;
	
	always @(s) begin
		case(s)
			4'b0000: out <= in[0];
			4'b0001: out <= in[1];
			4'b0010: out <= in[2];
			4'b0011: out <= in[3];
			4'b0100: out <= in[4];
			4'b0101: out <= in[5];
			4'b0110: out <= in[6];
			4'b0111: out <= in[7];
			4'b1000: out <= in[8];
			4'b1001: out <= in[9];
			4'b1010: out <= in[10];
			4'b1011: out <= in[11];
			4'b1100: out <= in[12];
			4'b1101: out <= in[13];
			4'b1110: out <= in[14];
			4'b1111: out <= in[15];
		endcase
	end	
	
endmodule 	

// 32-bit incrementer
module incrementer (out, in, clk, rst);

	output reg [31:0] out;
	input [31:0] in;
	input clk, rst;

	always @(posedge clk or posedge rst) begin
		if (rst == 1'b1)
			out  <= 32'b0;
		else
			out <= in + 1'b1;
	end	

endmodule 