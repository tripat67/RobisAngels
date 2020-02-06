module register_file (en, addr, din, rst, sa, sb, clk, da, db);

	output [63:0] da, db;  // data to function unit
	input  [63:0] din;         //	data from function unit
	input  [4:0] addr, sa, sb; // addresses for muxes and decoder
	input  en, rst, clk;			// enable and clock
	
	wire [31:0]c;              // decoder output
	wire [31:0]e;				   // en && c
	wire [63:0]r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31;
	
	decoder5_32 d1 (addr[0], addr[1], addr[2], addr[3], addr[4], c);
	
	and a0 (e[0], c[0], en);
	and a1 (e[1], c[1], en);
	and a2 (e[2], c[2], en);
	and a3 (e[3], c[3], en);
	and a4 (e[4], c[4], en);
	and a5 (e[5], c[5], en);
	and a6 (e[6], c[6], en);
	and a7 (e[7], c[7], en);
	and a8 (e[8], c[8], en);
	and a9 (e[9], c[9], en);
	and a10 (e[10], c[10], en);
	and a11 (e[11], c[11], en);
	and a12 (e[12], c[12], en);
	and a13 (e[13], c[13], en);
	and a14 (e[14], c[14], en);
	and a15 (e[15], c[15], en);
	and a16 (e[16], c[16], en);
	and a17 (e[17], c[17], en);
	and a18 (e[18], c[18], en);
	and a19 (e[19], c[19], en);
	and a20 (e[20], c[20], en);
	and a21 (e[21], c[21], en);
	and a22 (e[22], c[22], en);
	and a23 (e[23], c[23], en);
	and a24 (e[24], c[24], en);
	and a25 (e[25], c[25], en);
	and a26 (e[26], c[26], en);
	and a27 (e[27], c[27], en);
	and a28 (e[28], c[28], en);
	and a29 (e[29], c[29], en);
	and a30 (e[30], c[30], en);
	and a31 (e[31], c[31], en);

	register reg0 (din, e[0], rst, clk, r0);
	register reg1 (din, e[1], rst, clk, r1);
	register reg2 (din, e[2], rst, clk, r2);
	register reg3 (din, e[3], rst, clk, r3);
	register reg4 (din, e[4], rst, clk, r4);
	register reg5 (din, e[5], rst, clk, r5);
	register reg6 (din, e[6], rst, clk, r6);
	register reg7 (din, e[7], rst, clk, r7);
	register reg8 (din, e[8], rst, clk, r8);
	register reg9 (din, e[9], rst, clk, r9);
	register reg10 (din, e[10], rst, clk, r10);
	register reg11 (din, e[11], rst, clk, r11);
	register reg12 (din, e[12], rst, clk, r12);
	register reg13 (din, e[13], rst, clk, r13);
	register reg14 (din, e[14], rst, clk, r14);
	register reg15 (din, e[15], rst, clk, r15);
	register reg16 (din, e[16], rst, clk, r16);
	register reg17 (din, e[17], rst, clk, r17);
	register reg18 (din, e[18], rst, clk, r18);
	register reg19 (din, e[19], rst, clk, r19);
	register reg20 (din, e[20], rst, clk, r20);
	register reg21 (din, e[21], rst, clk, r21);
	register reg22 (din, e[22], rst, clk, r22);
	register reg23 (din, e[23], rst, clk, r23);
	register reg24 (din, e[24], rst, clk, r24);
	register reg25 (din, e[25], rst, clk, r25);
	register reg26 (din, e[26], rst, clk, r26);
	register reg27 (din, e[27], rst, clk, r27);
	register reg28 (din, e[28], rst, clk, r28);
	register reg29 (din, e[29], rst, clk, r29);
	register reg30 (din, e[30], rst, clk, r30);
	register reg31 (64'b0, e[31], rst, clk, r31);
	
	mux32_1 ma (da, sa, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31);
	mux32_1 mb (db, sb, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31);
	
endmodule

module decoder5_32 (in0, in1, in2, in3, in4, out); // 5 to 32 decoder

		output [31:0] out;
		input in4, in3, in2, in1, in0;
		
		wire in4n, in3n, in2n, in1n, in0n;
		
		not n4 (in4n, in4);
		not n3 (in3n, in3);
		not n2 (in2n, in2);
		not n1 (in1n, in1);
		not n0 (in0n, in0);

		and a0  (out[0],  in4n, in3n, in2n, in1n, in0n); 
		and a1  (out[1],  in4n, in3n, in2n, in1n, in0);
		and a2  (out[2],  in4n, in3n, in2n, in1,  in0n);
		and a3  (out[3],  in4n, in3n, in2n, in1,  in0);
		and a4  (out[4],  in4n, in3n, in2,  in1n, in0n);
		and a5  (out[5],  in4n, in3n, in2,  in1n, in0);
		and a6  (out[6],  in4n, in3n, in2,  in1,  in0n);
		and a7  (out[7],  in4n, in3n, in2,  in1,  in0);
		and a8  (out[8],  in4n, in3,  in2n, in1n, in0n);
		and a9  (out[9],  in4n, in3,  in2n, in1n, in0);
		and a10 (out[10], in4n, in3,  in2n, in1,  in0n);
		and a11 (out[11], in4n, in3,  in2n, in1,  in0);
		and a12 (out[12], in4n, in3,  in2,  in1n, in0n);
		and a13 (out[13], in4n, in3,  in2,  in1n, in0);
		and a14 (out[14], in4n, in3,  in2,  in1,  in0n);
		and a15 (out[15], in4n, in3,  in2,  in1,  in0);
		and a16 (out[16], in4,  in3n, in2n, in1n, in0n);
		and a17 (out[17], in4,  in3n, in2n, in1n, in0);
		and a18 (out[18], in4,  in3n, in2n, in1,  in0n);
		and a19 (out[19], in4,  in3n, in2n, in1,  in0);
		and a20 (out[20], in4,  in3n, in2,  in1n, in0n);
		and a21 (out[21], in4,  in3n, in2,  in1n, in0);
		and a22 (out[22], in4,  in3n, in2,  in1,  in0n);
		and a23 (out[23], in4,  in3n, in2,  in1,  in0);
		and a24 (out[24], in4,  in3,  in2n, in1n, in0n);
		and a25 (out[25], in4,  in3,  in2n, in1n, in0);
		and a26 (out[26], in4,  in3,  in2n, in1,  in0n);
		and a27 (out[27], in4,  in3,  in2n, in1,  in0);
		and a28 (out[28], in4,  in3,  in2,  in1n, in0n);
		and a29 (out[29], in4,  in3,  in2,  in1n, in0);
		and a30 (out[30], in4,  in3,  in2,  in1,  in0n);
		and a31 (out[31], in4,  in3,  in2,  in1,  in0);
		
endmodule

module register (din, e, rst, clk, dout); // 64-bit register
	
	output reg [63:0] dout;
	input [63:0] din;
	input clk, e, rst;
	
	always @(posedge clk or posedge rst) begin
		if(rst)
			dout <= 64'b0;
		else if(e)
			dout <= din;
		else
			dout <= dout;
	end
	
endmodule 		

// 64-bit 32 to 1 multiplexor
module mux32_1 (out, s, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31);

	output reg [63:0] out;
	input [63:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
	input [4:0] s;
	
	always @(s) begin
		case(s)
			5'b00000: out <= in0;
			5'b00001: out <= in1;
			5'b00010: out <= in2;
			5'b00011: out <= in3;
			5'b00100: out <= in4;
			5'b00101: out <= in5;
			5'b00110: out <= in6;
			5'b00111: out <= in7;
			5'b01000: out <= in8;
			5'b01001: out <= in9;
			5'b01010: out <= in10;
			5'b01011: out <= in11;
			5'b01100: out <= in12;
			5'b01101: out <= in13;
			5'b01110: out <= in14;
			5'b01111: out <= in15;
			5'b10000: out <= in16;
			5'b10001: out <= in17;
			5'b10010: out <= in18;
			5'b10011: out <= in19;
			5'b10100: out <= in20;
			5'b10101: out <= in21;
			5'b10110: out <= in22;
			5'b10111: out <= in23;
			5'b11000: out <= in24;
			5'b11001: out <= in25;
			5'b11010: out <= in26;
			5'b11011: out <= in27;
			5'b11100: out <= in28;
			5'b11101: out <= in29;
			5'b11110: out <= in30;
			5'b11111: out <= in31;
			default: out <= 64'b0;
		endcase
	end
endmodule
