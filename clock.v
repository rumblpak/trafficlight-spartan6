module clock(
	output clkout,
	input clkin,
	input [31:0] count
);

wire bufferedClk, dividedClk = 0, bufferedDividedClk;
reg [31:0] i = 0;
reg clear;

//buffering the clock
IBUFG clockbuffer ( .I(clkin), .O(bufferedClk));

//generate clock 
always @(posedge(bufferedClk) or posedge(clear)) begin
	if(clear) begin
		i = 0;
	end
	else i = i + 1;
end

always @(i) begin
	if( i == count ) begin
		dividedClk = ~dividedClk;
		clear = 1;
	end
	else 
		clear = 0;
end

//buffer the divided clock
BUFG dividedbuffer (.I(dividedClk), .O(bufferedDividedClk));

assign clkout = bufferedDividedClk;

endmodule 
