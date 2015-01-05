//Sprite must be of dimensions exact same dimensions as resolution 
module vga_sprite (
	input sel,
	input vidon,
	input [9:0] hc, vc,
	input [7:0] M, 
	input [9:0] hbp, hfp, vbp, vfp, 
	output [15:0] rom_addr16,
	output reg [2:0] red, green,
	output reg [1:0] blue
);

	reg spriteon;
		
	always @(*) begin
		if((hc < hfp) && (hc > hbp) && (vc < vfp) && (vc > vbp)) spriteon=1;
		else spriteon=0
	end
	
	always@(*) begin
		if(sel == 1) begin
			red = 0;
			green = 0;
			blue = 0;
			if((spriteon == 1) && (vidon == 1)) begin
				red = M[7:5];
				green = M[4:2];
				blue = M[1:0];
			end
		end
	end
endmodule 