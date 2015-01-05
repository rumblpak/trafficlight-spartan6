module vga (
	input clk,
	input clr,
	input reg[9:0] hpixels,  
	input reg[9:0] vlines,
	input reg[9:0] hbp, // HBP = 1/40 * hpixels
	input reg[9:0] hfp, // HFP = 1/40 * hpixels
	input reg[9:0] hsp, // HSP = 1/5 * hpixels
	//(VFP + VBP) = 0.08125 * vlines
	input reg[9:0] vbp, // VBP = 0.75 * (VFP + VBP)
	input reg[9:0] vfp, // VFP = 0.25 * (VFP + VBP)
	input reg[9:0] vsp, // VSP = 1/240 * vlines
	output reg hsync,
	output reg vsync,
	output reg[9:0] hc,
	output reg[9:0] vc,
	output reg vidon
);

reg vsenable;		

always @(posedge clk or posedge clr) begin
	if(clr) hc <= 0;
	else begin
		if (hc == hpixels - 1) begin
			hc <= 0;
			vsenable <= 1;
		end
		else begin
			hc <= hc + 1;
			vsenable <= 0;
		end
	end
end
		
always @(*) begin
	if (hc < hsp) hsync = 0;
	else hsync = 1;
end

always @(posedge clk or posedge clr) begin
	if(clr) vc <= 0;
	else begin
		if (vsenable == 1) begin
			if (vc == vlines - 1) vc <= 0;
			else vc = vc + 1;
		end
	end
end

always @(*) begin
	if((hc < hfp) && (hc > hbp) && (vc < vfp) && (vc > vbp)) vidon = 1;
	else vidon = 0;
end
		
endmodule 