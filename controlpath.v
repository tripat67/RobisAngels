module controlpath (k, ctrl_word, rom_addr, status, clk);
	output [63:0] k;										// constant bus
	output [38:0] ctrl_word;							// control word output
	input [31:0] rom_addr;								// rom address input
	input [3:0] status;									// alu status
	input clk;												// clock
	
	wire [31:0] rom_out;
	wire [31:0] ir_in;
	wire [31:0] i;
	
	wire ir_w;
	assign ir_w = ctrl_word[1];
	
	wire ir_en;
	assign ir_en = ctrl_word[2];
	
	assign ir_in = ir_en ? rom_out : 32'bz;			// rom output tristate buffer

	rom_case 	 rom (rom_out, rom_addr);
	instr_reg    ir  (i, ir_in, ir_w, clk);
	control_unit cu  (ctrl_word, k, i, status, clk);

endmodule 

module instr_reg (out, in, e, clk);
	output reg [31:0] out;
	input [31:0] in;
	input e;
	input clk;
	
	always @(posedge clk) begin
		if (e == 1'b1)
			out <= in;
		else 
			out <= out;
	end
endmodule 