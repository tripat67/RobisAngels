module alu (dataA, dataB, fs, c0, out, status);
	output [63:0]out;								// result
	output [3:0]status;							// z, n, c, v
	input [63:0]dataA, dataB;					// data in
	input [4:0]fs;									// function select
	input c0;

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
	
	wire z, n, c, v;								// zero, negative, carry out, overflow
	wire [63:0]inA, inB;							// mux input to adder
	wire [63:0]a, o, x, add, lsl, lsr;		// AND out, OR out, XOR out, ADD out, LSL out, LSR out
	
	assign inA = fs[1] ? ~dataA : dataA;	// invert A mux
	assign inB = fs[0] ? ~dataB : dataB;	// invert B mux
	
	assign status = {v, c, n, z};
	assign n = out[63];
	assign z = (out == 64'b0) ? 1'b1 : 1'b0;
	assign v = ~(inA[63] ^ inB[63]) & (out[63] ^ inA[63]);
	
	assign a = inA & inB;
	assign o = inA | inB;
	assign x = inA ^ inB;
	
	adder   add1   (inA, inB, c0, add, c);
	shifter shift1 (dataA, dataB[5:0], lsl, lsr);
	
	mux8_1 function_select (out, fs[4:2], a, o, add, x, lsl, lsr, 64'b0, 64'b0);
	
endmodule 

/* 64-bit 2 to 1 mux
module mux2_1 (out, s, in0, in1);
	output [63:0]out;
	input  [63:0]in0, in1;
	input  s;
	
	assign out = s ? in1 : in0;

endmodule 
*/

// 64-bit 8 to 1 mux
module mux8_1 (out, s, in0, in1, in2, in3, in4, in5, in6, in7);
	output reg [63:0]out;
	input [63:0]in0, in1, in2, in3, in4, in5, in6, in7;
	input [2:0] s;
	
	always @(*) begin
		case(s)
			3'b000: out <= in0;
			3'b001: out <= in1;
			3'b010: out <= in2;
			3'b011: out <= in3;
			3'b100: out <= in4;
			3'b101: out <= in5;
			3'b110: out <= in6;
			3'b111: out <= in7;
		endcase
	end
	
endmodule

// 64-bit adder
module adder (a, b, cin, s, cout);
	output [63:0]s;
	output cout;
	input [63:0]a, b;
	input cin;
	
	assign {cout, s} = a + b + cin;
	
endmodule

// 64-bit shift register
module shifter (data, shamt, left, right);
	output [63:0]left, right;
	input [63:0]data;
	input [5:0]shamt;
	
	assign left = data << shamt;
	assign right = data >> shamt;
	
endmodule
