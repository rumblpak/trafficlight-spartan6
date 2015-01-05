module traffic ( //this is not a top function
	input clk,
	input clr,
	output reg [5:0] lights;
);
	
	reg[2:0] state; 
	reg [4:0] count;
	
	parameter NorthSouth = 3'b000, NSYellow = 3'b001, NSRed = 3'b010,
				EastWest = 3'b011, EWYellow = 3'b100, EWRed = 3'b101;
	parameter SEC5 = 4'b1010, SEC1 = 4'b0011;
	
	always @(posedge(clk1) or posedge(clr)) begin 
		count = count + 1;
		if (clr) begin
			state <= NorthSouth;
			count <= 0;
		end
		else begin
			case(state): 
				NorthSouth: if (count > SEC5)
					begin
						state <= NSYellow;
						count <= 0;
					end
				NSYellow: if (count > SEC1)
					begin
						state <= NSRed;
						count <= 0;
					end
				NSRed: if (count > SEC1)
					begin
						state <= EastWest;
						count <= 0;
					end
				EastWest: if (count > SEC5)
					begin
						state <= EWYellow;
						count <= 0;
					end
				EWYellow: if (count > SEC1)
					begin
						state <= EWRed;
						count <= 0;
					end
				EWRed: if (count > SEC1)
					begin
						state <= NorthSouth;
						count <= 0;
					end
				default: begin
					state <= NorthSouth;
					count <= 0;
				end
			endcase
		end
	end
	
	always @(*) begin
		case(state)
			NorthSouth: lights = 6'b000001;
			NSYellow: lights = 6'b000010;
			NSRed: lights = 6'b000100;
			EastWest: lights = 6'b001000;
			EWYellow: lights = 6'b010000;
			EWRed: lights = 6'b100000;
			default: lights = 6'b000000;
		endcase
	end
	
endmodule 