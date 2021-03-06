module datapath (rom_addr, status, k, reg_addr, a_addr, b_addr, fs, ps, reg_w, b_sel, b_en, alu_en, mem_en, chip_sel, mem_w, mem_r, stat_en, pc_reg_en, pc_rom_en, pc_sel, c0, rst, clk);
	output [31:0] rom_addr;									// rom address output
	output [4:0] status;										// status register output {v, c, n, z, z_imm}
	input [63:0] k;											// constant in
	input [4:0] reg_addr, a_addr, b_addr;				// register file addresses
	input [4:0] fs;											// alu function select
	input [1:0] ps;											// program counter select
	input reg_w;												// register file write-enable
	input b_sel;												// b mux select
	input b_en;													// b bus tristate buffer enable
	input alu_en;												// d bus tristate buffer enable
	input mem_en;												// memory address bus tristate buffer enable
	input chip_sel;											// memory chip select (tsb enable)
	input mem_w;												// memory write-enable
	input mem_r;												// memory read-enable
	input stat_en;												// status register enable
	input pc_reg_en;											//	pc-reg tristate buffer enable
	input pc_rom_en;											// pc-rom tristate buffer enable
	input pc_sel;												// pc mux select
	input c0;													// alu carry-in
	input rst;													// async reset
	input clk;													// clock
	
	wire [63:0] d;												// data bus
	wire [63:0] f;												// alu result
	wire [63:0] dataA, dataB;								// A & B buses
	wire [63:0] mem_addr;
	
	wire [63:0] mux_out;										// output of b mux
	wire [63:0]	mem_out;										// memory output
	
	wire [31:0] pc_in;										// program counter input
	wire [31:0] pc_out;										// program counter output
	
	wire [3:0] alu_stat;										// alu status output {v, c, v, z}
	wire [3:0] stored_stat;									// status in register

	wire [1:0] ps;												// program counter select: hold, increment, load, offset
	
	assign status = {stored_stat, alu_stat[0]};		// 5-bit status bus
	
	assign d = b_en ? dataB : 64'bz;						// b bus tristate buffer
	assign d = alu_en ? f : 64'bz;						// d bus tristate buffer
	assign d = chip_sel ? mem_out : 64'bz;				// memory output tristate buffer
	assign d = pc_reg_en ? pc_out : 64'bz;				// pc-reg tristate buffer
	
	assign mem_addr = mem_en ? d : 64'bz;				// address bus tristate buffer
	
	assign rom_addr = pc_rom_en ? pc_out : 32'bz;	// pc-rom tristate buffer
	
	assign mux_out = b_sel ? k : dataB;					// b mux
	assign pc_in = pc_sel ? k : dataA;					// pc mux
	
	wire [63:0] R0, R1, R2, R3, R4, R5, R6, R7;

	register_file   regf (reg_w, reg_addr, d, rst, a_addr, b_addr, clk, dataA, dataB, R0, R1, R2, R3, R4, R5, R6, R7);
	alu 			    alu  (dataA, mux_out, fs, c0, f, alu_stat);
	RAM256x64       ram  (mem_addr[7:0], clk, d, mem_w, mem_out);
	register_4bit   stat (stored_stat, alu_stat, stat_en, rst, clk);
	program_counter pc   (pc_out, pc_in, ps, clk, rst);
	
	
endmodule 