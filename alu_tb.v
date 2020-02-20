module alu_tb ();
	wire [63:0]out;
	wire [3:0]status;
	reg [63:0]dataA, dataB;
	reg [4:0]fs;
	reg c0;

	alu dut (.dataA(dataA), .dataB(dataB), .fs(fs), .c0(c0), .out(out), .status(status));
	
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
	
	initial begin
		dataA <= 64'b10101;
		dataB <= 64'b01010;
		fs 	<= 5'b00000;
		c0    <= 1'b0;
	end
	
	always begin
		#5 fs <= 5'b00100;
		#5 fs <= 5'b01000;
		#5 fs <= 5'b01100;
		#5 fs <= 5'b10000;
		#5 fs <= 5'b10100;
		#5 fs <= 5'b00010;
		#5 fs <= 5'000001;
		#5 $stop;
	end
		
endmodule
