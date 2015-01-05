module videoclock(
	output clkout,
	input clkin,
	input multiplier,
	input divider
);

wire bufferedClk, dividedClk, bufferedDividedClk;


//buffering the clock
IBUFG clockbuffer ( .I(clkin), .O(bufferedClk));

//generate clock 
//CLKFX_MULTIPLY set {2,3,4,…,256}
//CLKFX_DIVIDE set {1,2,3,…,256}
DCM_CLKGEN #( .CLKFX_MULTIPLY(multiplier), .CLKFX_DIVIDE(divider) .SPREADSPECTRUM(VIDEO_LINK_M1) ) generatedCLK ( .CLKIN(clk), .CLKFX(dividedClk) );

//buffer the divided clock
BUFG dividedbuffer (.I(dividedClk), .O(bufferedDividedClk));

assign clkout = bufferedDividedClk;

endmodule 
