module RGBtoGray(clk, valid_in, valid_out, rgb_in, brightness, gray_out);
	input clk, valid_in;
	input [23:0] rgb_in;
	output reg valid_out;
	input signed [8:0] brightness;
	output reg [7:0] gray_out;
	
	reg [18:0] Y;
	reg [17:0] r_temp;
	reg [17:0] g_temp;
	reg [14:0] b_temp;
	wire [9:0] Temp;
	reg [1:0] valid;
	reg signed [8:0] brightness_temp1;
	reg signed [8:0] brightness_temp2;
	
	always @(posedge clk) begin
			//Pipe 1: Nhân hệ số trong ct với 2^10
			r_temp <= 306 * rgb_in[23:16];
			g_temp <= 601 * rgb_in[15:8];
			b_temp <= 117 * rgb_in[7:0];
			valid[0] <= valid_in;
			brightness_temp1 <= brightness;
			
			//Pipe 2: Tổng của 3 tích đã tính ở Pipe1
			Y <= r_temp + g_temp + b_temp;
			valid[1] <= valid[0];
			brightness_temp2 <= brightness_temp1;
	end
	
	assign Temp = {1'b0,Y[18:10]} + {brightness_temp2[8],brightness_temp2};
	
	always @(posedge clk) begin
			//Pipe 3: Nếu tính hiệu valid thỏa thì xuất output
			if(valid[1]) begin
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
			valid_out <= valid[1];
		
	end
	
endmodule