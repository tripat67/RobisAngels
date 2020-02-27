module RAM256x64(address, clock, in, write, out);
	input [7:0] address;
	input clock;
	input [63:0] in;
	input write;
	output reg [63:0] out;
	
	reg [63:0] mem [0:255];
	
	always @(posedge clock) begin
		if(write) begin
			mem[address] <= in;
		end
	end
	
	always @(posedge clock) begin
		out <= mem[address];
	end
	
endmodule
