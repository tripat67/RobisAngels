module control_unit (ctrl_word, k, i, status, clk);
	output [38:0] ctrl_word;					// 39-bit control word
	output [63:0] k;								// 64-bit constant
	input [31:0] i;								// 32-bit instruction
	input [3:0] status;							// alu status
	input clk;										// clock
	
	wire [102:0] ex0, ex1, ex2;
	wire [102:0] ex00, ex01, ex02, ex03;	// wires for muxes
	wire [102:0] ex10, ex11;
	
	wire [1:0] ctrl_sel;							// ctrl_mux select
	
	wire [1:0] ex0_sel;							// mux_ex0 select
	wire ex1_sel;									// mux_ex1 select
	
	ex0_encoder ex0_enc (ex0_sel, i[28:25]);
	
	not n0 (ex1_sel, i[25]);
	
	data_imm_ex0 dim0 (ex00, i);
	branch_ex0   bra0 (ex01, i);
	memory_ex0 	 mem0 (ex02, i);
	data_reg_ex0 drg0 (ex03, i);
	
	data_imm_ex1 dim1 (ex10, i);
	branch_ex1 	 bra1 (ex11, i, status);
	
	state_machine sm (ctrl_sel, ctrl_word[38:37], clk);
	
	wire [102:0] instr_fetch;
	assign instr_fetch = {2'b01, 5'b0, 5'b0, 5'b0, 3'b0, 5'b00000, 6'b000000, 2'b00, 5'b00111, 1'b0, 64'b0};
		
	assign ex2 = {2'b00, 5'b0, 5'b0, 5'b0, 3'b0, 5'b00000, 6'b000000, 2'b01, 5'b00111, 1'b0, 64'b0};
	
	mux4_1 mux_ex0 (ex0, ex00, ex01, ex02, ex03, ex0_sel);
	mux2_1 mux_ex1 (ex1, ex10, ex11, ex1_sel);
	
	mux4_1 ctrl_mux ({ctrl_word, k}, instr_fetch, ex0, ex1, ex2, ctrl_sel);
	
endmodule 

// {NS, reg_addr, a_addr, b_addr, reg_w, b_sel, b_en, fs, c0, alu_en, mem_en, chip_sel, mem_w, mem_r, ps, pc_sel, pc_reg_en, pc_rom_en, ir_en, ir_w, stat_en, k}

module state_machine (out, in, clk);
	output reg [1:0] out;
	input [1:0] in;
	input clk;
	
	always @(posedge clk) begin
		out <= in;
	end

endmodule

// data immediate mux
module data_imm_ex0 (out, i);
	output [102:0] out;
	input [31:0] i;
	
	wire [102:0] add_sub, logic, mov, shift;
	wire [102:0] ADDI, SUBI, MOVZ, MOVK, ANDI, ORRI, EORI, ANDIS, LSR, LSL;
	
	assign ADDI = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b01000, 6'b010000, 2'b01, 5'b00111, i[29], {52'b0, i[21:10]}};
	assign SUBI = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b01001, 6'b110000, 2'b01, 5'b00111, i[29], {52'b0, i[21:10]}};
	assign MOKZ = {2'b00, i[4:0], 5'b11111, 5'b0, 3'b110, 5'b01000, 6'b010000, 2'b01, 5'b00111, 1'b0, {48'b0, i[20:5]}};
	assign MOVK = {2'b10, i[4:0], i[4:0], 5'b0, 3'b110, 5'b00000, 6'b010000, 2'b00, 5'b00111, 1'b0, {48'b1, 16'b0}};
	assign ANDI = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b00000, 6'b010000, 2'b01, 5'b00111, 1'b0, {52'b0, i[21:10]}};
	assign ORRI = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b00100, 6'b010000, 2'b01, 5'b00111, 1'b0, {52'b0, i[21:10]}};
	assign EORI = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b01100, 6'b010000, 2'b01, 5'b00111, 1'b0, {52'b0, i[21:10]}};
	assign ANDIS = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b00000, 6'b010000, 2'b01, 5'b00111, 1'b1, {52'b0, i[21:10]}};
	assign LSR = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b10100, 6'b010000, 2'b01, 5'b00111, 1'b0, {58'b0, i[15:10]}};
	assign LSL = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b10000, 6'b010000, 2'b01, 5'b00111, 1'b0, {58'b0, i[15:10]}};
	
	mux_8_1 mux0 (out, 103'b0, 103'b0, add_sub, 103'b0, logic, mov, shift, 103'b0, i[25:23]);
	
	mux2_1 mux1 (add_sub, ADDI, SUBI, i[30]);
	mux2_1 mux2 (mov, MOVZ, MOVK, i[29]);
	mux4_1 mux3 (logic, ANDI, ORRI, EORI, ANDIS, i[30:29]);
	mux2_1 mux4 (shift, LSR, LSL, i[21]);

endmodule 

// branch mux
module branch_ex0 (out, i);
	output [102:0] out;
	input [31:0] i;
	
	wire br_sel;
	
	branch_encoder br_en (br_sel, {i[30:29], i[25]});

	wire [102:0] b_bl, cb;
	wire [102:0] B, BL, CBZ, CBNZ, BCOND, BR;
	
	assign B = {2'b00, 5'b0, 5'b0, 5'b0, 3'b000, 5'b00000, 6'b000000, 2'b10, 5'b10111, 1'b0, 64'b0};
	assign BL = {2'b00, 5'b0, 5'b0, 5'b0, 3'b000, 5'b00000, 6'b000000, 2'b10, 5'b10111, 1'b0, 64'b0};
	assign CBZ = {2'b10, 5'b0, i[4:0], 5'b11111, 3'b000, 5'b01000, 6'b000000, 2'b00, 5'b00111, 1'b1, 64'b0};
	assign CBNZ = {2'b10, 5'b0, i[4:0], 5'b11111, 3'b000, 5'b01000, 6'b000000, 2'b00, 5'b00111, 1'b1, 64'b0};
	assign BCOND = {2'b10, 5'b0, i[4:0], 5'b11111, 3'b000, 5'b01000, 6'b000000, 2'b00, 5'b00111, 1'b1, 64'b0};
	assign BR = {2'b00, i[4:0], i[9:5], i[20:16], 3'b000, 5'b01000, 6'b000000, 2'b01, 5'b00111, 1'b0, 64'b0};
	
	mux4_1 mux0 (out, b_bl, cb, BCOND, BR, br_sel);
	
	mux2_1 mux1 (b_bl, B, BL, i[31]);
	mux2_1 mux2 (cb, CBZ, CBNZ, i[24]);
	
endmodule

// memory mux
module memory_ex0 (out, i);
	output [102:0] out;
	input [31:0] i;

	wire [102:0] STUR, LDUR;
	
	assign STUR = {2'b00, 5'b0, i[9:5], i[4:0], 3'b011, 5'b01000, 6'b001110, 2'b01, 5'b00111, 1'b0};
	assign LDUR = {2'b00, i[4:0], i[9:5], 5'b0, 3'b110, 5'b01000, 6'b001101, 2'b01, 5'b00111, 1'b0};
	
	mux2_1 mux0 (out, STUR, LDUR, i[22]);

endmodule

// data register mux
module data_reg_ex0 (out, i);
	output [102:0] out;
	input [31:0] i;
	
	wire [102:0] logic, add_sub;
	wire [102:0] AND, ORR, EOR, ANDS, ADD, ADDS, SUB, SUBS;
	
	assign AND = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b00000, 6'b010000, 2'b01, 5'b00111, 1'b0, 64'b0};
	assign ORR = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b00100, 6'b010000, 2'b01, 5'b00111, 1'b0, 64'b0};
	assign EOR = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b01100, 6'b010000, 2'b01, 5'b00111, 1'b0, 64'b0};
	assign ANDS = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b00000, 6'b010000, 2'b01, 5'b00111, 1'b1, 64'b0};
	assign ADD = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b01000, 6'b010000, 2'b01, 5'b00111, 1'b0, 64'b0};
	assign ADDS = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b01000, 6'b010000, 2'b01, 5'b00111, 1'b1, 64'b0};
	assign SUB = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b01001, 6'b110000, 2'b01, 5'b00111, 1'b0, 64'b0};
	assign SUBS = {2'b00, i[4:0], i[9:5], i[20:16], 3'b100, 5'b01001, 6'b110000, 2'b01, 5'b00111, 1'b1, 64'b0};
	
	mux4_1 mux0 (out, logic, add_sub, 103'b0, 103'b0, {i[28],i[24]});
	
	mux4_1 mux1 (logic, AND, ORR, EOR, ANDS, i[30:29]);
	mux4_1 mux2 (add_sub, ADD, ADDS, SUB, SUBS, i[30:29]);

endmodule

module data_imm_ex1 (out, i);
	output [102:0] out;
	input [31:0] i;
	
	wire [102:0] MOVK;
	
	assign MOVK = {2'b00, i[4:0], i[4:0], 5'b0, 3'b110, 5'b00100, 6'b010000, 2'b00, 5'b00111, 1'b0, {48'b0, i[20:5]}};
	
	assign out = MOVK; 

endmodule

module branch_ex1 (out, i, status);
	output [102:0] out;
	input [31:0] i;
	input [3:0] status;
	
	wire [102:0] cb;
	wire [102:0] CBZ, CBNZ, BCOND;
	
	wire [63:0] k0, k1, k2;
	
	wire [1:0] br_sel;
	
	wire cond;
	
	branch_encoder br_en (br_sel, {i[30:29], i[25]});
	conditions cond0 (cond, status, i[3:0]);
	
	assign CBZ = {2'b11, 5'b0, 5'b0, 5'b0,3'b000, 5'b00000, 6'b000000, 2'b11, 5'b10111, 1'b0, k0};
	assign CBNZ = {2'b11, 5'b0, 5'b0, 5'b0,3'b000, 5'b00000, 6'b000000, 2'b11, 5'b10111, 1'b0, k1};
	assign BCOND = {2'b11, 5'b0, 5'b0, 5'b0,3'b000, 5'b00000, 6'b000000, 2'b11, 5'b10111, 1'b0, k2};
	
	assign k0 = status[0] ? {45'b0, i[23:5]} : 64'b0;
	assign k1 = status[0] ? 64'b0 : {45'b0, i[23:5]};
	assign k2 = cond ? {45'b0, i[23:5]} : 64'b0;
	
	mux4_1 mux0 (out, 103'b0, cb, BCOND, 103'b0, br_sel);
	
	mux2_1 mux2 (cb, CBZ, CBNZ, i[24]);
		
endmodule 

module conditions (out, status, cond_sel);
	output out;
	input [3:0] status;
	input [3:0] cond_sel;
	
	wire v, c, n, z;
	
	wire eq, ne, hs, lo, mi, pl, vs, vc, hi, ls, ge, lt, gt, le, al, nv;
	wire [15:0] cond;
	wire [3:0] cond_sel;
	
	assign v = status[3];
	assign c = status[2];
	assign n = status[1];
	assign z = status[0];
	
	assign eq = z;
	assign ne = ~z;
	assign hs = c;
	assign lo = ~c;
	assign mi = n;
	assign pl = ~n;
	assign vs = v;
	assign vc = ~v;
	assign hi = c & ~z;
	assign ls = ~c | z;
	assign ge = n ~^ v;
	assign lt = n ^ v;
	assign gt = ~z & ge;
	assign le = z | lt;
	assign al = 1'b1;
	assign nv = 1'b0;
	
	assign cond = {eq, ne, hs, lo, mi, pl, vs, vc, hi, ls, ge, lt, gt, le, al, nv};
	
	mux16_1   mux1 (out, cond, cond_sel);

endmodule 

module branch_encoder (out, in);
	output [1:0] out;
	input [2:0] in;
	
	assign out[1] = in[1];
	
	and a (a0, in[2], in[0]);
	or  o (out[0], in[1], a0);
	
endmodule

module ex0_encoder (out, in);
	output [1:0] out;
	input [3:0] in;
	
	wire and0, and1;
	
	assign out[1] = in[2];
	
	and a0 (and0, in[3], in[1]);
	and a1 (and1, in[2], in[0]);
	
	or o1 (out[0], and0, and1);

endmodule 

// 103-bit 2 to 1 mux
module mux2_1 (out, in0, in1, s);
	output [102:0]out;
	input [102:0]in0, in1;
	input s;

	assign out = s ? in1 : in0;
	
endmodule 

//103-bit 4 to 1 mux
module mux4_1 (out, in0, in1, in2, in3, s);
	output [102:0] out;
	input [102:0] in0, in1, in2, in3;
	input [2:0] s;
	
	assign out = (s == 2'b00) ? in0 : (s == 2'b01) ? in1 : (s == 2'b10) ? in2 : in3;
	
	/*always @ (*) begin
		case(s)
			2'b00: out <= in0;
			2'b01: out <= in1;
			2'b10: out <= in2;
			2'b11: out <= in3;
		endcase
	end
	*/
endmodule

//103-bit 8 to 1 mux
module mux_8_1 (out, in0, in1, in2, in3, in4, in5, in6, in7, s);
	output reg [102:0] out;
	input [102:0] in0, in1, in2, in3, in4, in5, in6, in7;
	input [2:0] s;

	always @ (*) begin
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

// 103-bit 16 to 1 mux
module mux16_1 (out, in, s);
	output reg out;
	input [15:0] in;
	input [3:0] s;
	
	always @(*) begin
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