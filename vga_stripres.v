module vga_stripes (
	input wire vidon,
	input wire [9:0] hc, vc,
	output reg [2:0] red, green,
	output reg [1:0] blue
);

always @(*) begin
	red = 0;
	blue = 0;
	green = 0;
	if (vidon == 1) begin
		red = {vc[4], vc[4], vc[4]};
		green = ~{vc[4], vc[4], vc[4]};
	end
end

endmodule 