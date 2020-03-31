module register_4bit (q, d, en, rst, clk);
	
	output reg [3:0] q;
	input [3:0] d;
	input en;
	input rst;
	input clk;
	
	always @ (posedge clk or posedge rst) begin
		if (rst == 1'b1)
			q <= 1'b0;
		else if (en == 1'b1)
			q <= d;
		else 
			q <= q;
	end
endmodule 