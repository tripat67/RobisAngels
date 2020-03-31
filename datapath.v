module datapath (status, k, reg_addr, a_addr, b_addr, fs, reg_w, b_sel, b_en, alu_en, mem_en, chip_sel, mem_w, mem_r, stat_en, c0, rst, clk);

	output [4:0] status;									// status register output {v, c, n, z, z_imm}
	input [63:0] k;										// constant in
	input [4:0] reg_addr, a_addr, b_addr;			// register file addresses
	input [4:0] fs;										// alu function select
	input reg_w;											// register file write-enable
	input b_sel;											// b mux select
	input b_en;												// b bus tristate buffer enable
	input alu_en;											// d bus tristate buffer enable
	input mem_en;											// memory address bus tristate buffer enable
	input chip_sel;										// memory chip select (tsb enable)
	input mem_w;											// memory write-enable
	input mem_r;											// memory read-enable
	input stat_en;											// status register enable
	input c0;												// alu carry-in
	input rst;												// async reset
	input clk;												// clock

	wire [63:0] d;											// data bus
	wire [63:0] f;											// alu result
	wire [63:0] dataA, dataB;							// A & B buses
	
	wire [63:0] mux_out;									// output of b mux
	wire [63:0]	mem_out;									// memory output
	
	wire [7:0] mem_addr;									// memory address
	
	wire [3:0] alu_stat;									// alu status output {v, c, v, z}
	wire [3:0] stored_stat;								// status in register
	
	assign status = {stored_stat, alu_stat[0]};	// 5-bit status bus
	
	assign d = b_en ? dataB : 64'bz;					// b bus tristate buffer
	assign d = alu_en ? f : 64'bz;					// d bus tristate buffer
	assign d = chip_sel ? mem_out : 64'bz;			// memory output tristate buffer
	
	assign mux_out = b_sel ? k : dataB;				// b mux
	
	wire [63:0] R0, R1, R2, R3, R4, R5, R6, R7;

	register_file reg1 (reg_w, reg_addr, d, rst, a_addr, b_addr, clk, dataA, dataB, R0, R1, R2, R3, R4, R5, R6, R7);
	alu 			  alu1 (dataA, mux_out, fs, c0, f, alu_stat);
	RAM256x64     ram1 (mem_addr, clk, d, mem_w, mem_out);
	register_4bit stat (stored_stat, alu_stat, stat_en, rst, clk);
	
	
endmodule 