module RGBtoGray(clk, valid_in, rgb_in, brightness, gray_out);
	input clk, valid_in;
	input [23:0] rgb_in;
	input signed [8:0] brightness;
	output reg [7:0] gray_out;
	
	
	reg [18:0] Y;
	reg [17:0] R;
	reg [17:0] G;
	reg [14:0] B;
	reg [9:0] Temp;
	
	always @(posedge clk) begin
			//Stage 1
			//306 = 256 + 32 + 16 + 2
			R <= (rgb_in[23:16] << 8) + (rgb_in[23:16] << 5) + (rgb_in[23:16] << 4) + (rgb_in[23:16] << 1);
			
			//601 = 512 + 64 + 16 + 8 + 1
			G <= (rgb_in[15:8] << 9) + (rgb_in[15:8] << 6) + (rgb_in[15:8] << 4) + (rgb_in[15:8] << 3) + rgb_in[15:8];
			
			//117 = 64 + 32 + 16 + 4 + 1
			B <= (rgb_in[7:0] << 6) + (rgb_in[7:0] << 5) + (rgb_in[7:0] << 4) + (rgb_in[7:0] << 2) + rgb_in[7:0];
			
			//Stage 2
			Y <= R + G + B;
			
			//Stage 3
			Temp <= {1'b0,Y[18:10]} + {brightness[8],brightness};
			
			//Stage 4
			if(valid_in) begin
				if(Temp[9]) begin
					gray_out <= 8'd0;
				end
				else if(Temp[8]) begin
					gray_out <= 8'd255;
				end
				else begin
					gray_out <= Temp[7:0];
				end
			end
			
	end	
endmodule