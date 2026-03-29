module RGBtoGray(clk, valid_in, valid_out, rgb_in, brightness, gray_out);
	input clk, valid_in;
	input [23:0] rgb_in;
	output reg valid_out;
	input signed [8:0] brightness;
	output reg [7:0] gray_out;
	
	reg [19:0] Y;
	wire [10:0] Temp;
	reg valid;
	reg signed [8:0] brightness_temp;	//thanh ghi này delay brightness đi 1 clk, cái này làm cho kết quả đúng :)))
	
	always @(posedge clk) begin
		Y <= (306 * rgb_in[23:16]) + (601 * rgb_in[15:8]) + (117 * rgb_in[7:0]);
		valid <= valid_in;
		brightness_temp <= brightness;
	end
	
	assign Temp = {1'b0,Y[19:10]} + {{2{brightness_temp[8]}},brightness_temp};
	
	always @(posedge clk) begin
		if(valid) begin
			if(Temp[10]) begin
				gray_out <= 8'd0;
			end
			else if((Temp[9]) || (Temp[8])) begin
				gray_out <= 8'd255;
			end
			else begin
				gray_out <= Temp[7:0];
			end
		end
		valid_out <= valid;
	end
	
endmodule