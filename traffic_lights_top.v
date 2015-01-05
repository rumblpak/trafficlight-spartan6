module traffic_lights_top (
	input clk,
	input [4:0] btns,
	output hsync, vsync,
	output [2:0] red, green,
	output [1:0] blue
);
	wire clk1, clk3, clr, clk25, vidon;
	wire [9:0] hc, vc;
	wire [15:0] redrom, ewgreenrom, ewtransrom, nsgreenrom, nstransrom;
	wire [7:0] redM, ewgreenM, ewtransM, nsgreenM, nstransM;
	reg redSel = 0, ewgreenSel = 0, ewtransSel = 0, nsgreenSel = 0, nstransSel = 0;
	reg[5:0] lights;
	reg[31:0] trafficCounter = 100000000, sevenSegCounter = 100000;
	
	parameter hpixels = 800, vlines = 521, hbp = 144, hfp = 784, hsp = 128, vbp = 31, vfp = 511, vsp = 2; //640x480
	
	///////////
	/*
	hv = horizontal pixels i.e. 640
	vv = vertical pixels i.e. 480
	hpixels = total number of pixels in a horizontal line = HSP + HBP + HV + HFP
	vlines = total number of lines in a vertical image = VSP + VBP + VV + VFP
	HBP = 1/40 * hv
	HFP = 1/40 * hv
	HSP = 1/5 * hv
	(VFP + VBP) = 0.08125 * vv
	VBP = 0.75 * (VFP + VBP)
	VFP = 0.25 * (VFP + VBP)
	VSP = 1/240 * vv 
	
	HOWEVER the parameterized version requires certain additions:
	hbp = HSP + HBP
	hfp = HSP + HBP + hv
	vbp = VSP + VBP
	vfp = VSP + VBP + vv
	
	*/
	///////////
	
	assign clr = btns[0]; //not sure which button this is

	clock trafficClock (.clkout(clk1), .clkin(clk), .count(trafficCounter));
	clock sevensegClock (.clkout(clk3), .clkin(clk), .count(sevenSegCounter));
	videoclock vgaClock (.clkout(clk25), .clkin(clk), .multiplier(1), .divider(4));
	traffic stateMachine (.clk(clk1), .clr(clr), .lights(lights));
	vga vga640x480(.clk(clk25), .clr(clr), .hpixels(hpixels), .vlines(vlines), 
					.hbp(hbp), .hfp(hfp), .hsp(hsp), 
					.vbp(vbp), .vfp(vfp), .vsp(vsp),
					.hsync(hsync), .vsync(vsync), .hc(hc), .vc(vc), .vidon(vidon));
	
	vga_stripes stripes (.vidon(vidon), .hc(hc), .vc(vc), 
					.red(red), .green(green), .blue(blue));
	/*
	///// To use these you must comment out vga_stripes /////
	
	vga_sprite red1(	.sel(redSel), .vidon(vidon), .hc(hc), .vc(vc), .M(redM), 
					.hbp(hbp), .hfp(hfp), .vbp(vbp), .vfp(vfp),
					.rom_addr16(redrom), .red(red), .green(green), .blue(blue) ); 
	
	vga_sprite ewgreen1(	.sel(ewgreenSel), .vidon(vidon), .hc(hc), .vc(vc), .M(ewgreenM), 
					.hbp(hbp), .hfp(hfp), .vbp(vbp), .vfp(vfp),
					.rom_addr16(ewgreenrom), .red(red), .green(green), .blue(blue) ); 
	
	vga_sprite ewtrans1(	.sel(ewtransSel), .vidon(vidon), .hc(hc), .vc(vc), .M(ewtransM), 
					.hbp(hbp), .hfp(hfp), .vbp(vbp), .vfp(vfp),
					.rom_addr16(ewtransrom), .red(red), .green(green), .blue(blue) ); 
	
	vga_sprite nsgreen1(	.sel(nsgreenSel), .vidon(vidon), .hc(hc), .vc(vc), .M(nsgreenM), 
					.hbp(hbp), .hfp(hfp), .vbp(vbp), .vfp(vfp),
					.rom_addr16(nsgreenrom), .red(red), .green(green), .blue(blue) ); 
	
	vga_sprite nstrans1(	.sel(nstransSel), .vidon(vidon), .hc(hc), .vc(vc), .M(nstransM), 
					.hbp(hbp), .hfp(hfp), .vbp(vbp), .vfp(vfp),
					.rom_addr16(nstransrom), .red(red), .green(green), .blue(blue) ); 

	
	*/
	

	always @(*) begin
		redSel = 0; 
		ewgreenSel = 0; 
		ewtransSel = 0; 
		nsgreenSel = 0; 
		nstransSel = 0;
		
		case(lights) begin
			6'b000001: begin
							redSel = 0; 
							ewgreenSel = 0; 
							ewtransSel = 0; 
							nsgreenSel = 1; 
							nstransSel = 0;
					   end
			6'b000010: begin
							redSel = 0; 
							ewgreenSel = 0; 
							ewtransSel = 0; 
							nsgreenSel = 0; 
							nstransSel = 1;
					   end
			6'b000100: begin
							redSel = 1; 
							ewgreenSel = 0; 
							ewtransSel = 0; 
							nsgreenSel = 0; 
							nstransSel = 0;
					   end
			6'b001000: begin
							redSel = 0; 
							ewgreenSel = 1; 
							ewtransSel = 0; 
							nsgreenSel = 0; 
							nstransSel = 0;
					   end
			6'b010000: begin
							redSel = 0; 
							ewgreenSel = 0; 
							ewtransSel = 1; 
							nsgreenSel = 0; 
							nstransSel = 0;
					   end
			6'b100000: begin
							redSel = 1; 
							ewgreenSel = 0; 
							ewtransSel = 0; 
							nsgreenSel = 0; 
							nstransSel = 0;
					   end
			default: begin
							redSel = 0; 
							ewgreenSel = 0; 
							ewtransSel = 0; 
							nsgreenSel = 0; 
							nstransSel = 0;
					 end
		endcase
	end
	
	
endmodule 