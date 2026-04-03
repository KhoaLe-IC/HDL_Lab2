module RGBtoGray(clk, valid_in, valid_out, rgb_in, brightness, gray_out);
	input clk, valid_in;
	input [23:0] rgb_in;
	output reg valid_out;
	input signed [8:0] brightness;
	output reg [7:0] gray_out;
	
	reg [18:0] Y;
	reg [17:0] R, r_temp1, r_temp2;
	reg [17:0] G, g_temp1, g_temp2;
	reg [14:0] B, b_temp1, b_temp2;
	reg [2:0] valid;

	wire [9:0] Temp;
	
	always @(posedge clk) begin
			//Stage 1
			//306 = 256 + 32 + 16 + 2 = x << 8 + x << 5 + x << 4 + x << 1
			r_temp1 <= (rgb_in[23:16] << 8) + (rgb_in[23:16] << 5);
			r_temp2 <= (rgb_in[23:16] << 4) + (rgb_in[23:16] << 1);
			
			//601 = 
			g_temp1 <= (rgb_in[15:8] << 9) + (rgb_in[15:8] << 6);
			g_temp2 <= (rgb_in[15:8] << 4) + (rgb_in[15:8] << 3) + rgb_in[15:8];
			
			b_temp1 <= (rgb_in[7:0] << 6) + (rgb_in[7:0] << 5);
			b_temp2 <= (rgb_in[7:0] << 4) + (rgb_in[7:0] << 2) + rgb_in[7:0];

			valid[0] <= valid_in;
			
			//Stage 2
			R <= r_temp1 + r_temp2;
			G <= g_temp1 + g_temp2;
			B <= b_temp1 + b_temp2;
			valid[1] <= valid[0];
			
			//Stage 3
			Y <= R + G + B;
			valid[2] <= valid[1];
	end
	
	assign Temp = {1'b0,Y[18:10]} + {brightness[8],brightness};
	
	always @(posedge clk) begin
			//Stage 4
			if(valid[2]) begin
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
			valid_out <= valid[2];
		
	end
	
endmodule