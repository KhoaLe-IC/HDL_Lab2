
module Topmodule(clk,valid_in, valid_out, rgb_in, brightness, gray_out);
	input clk;
	input valid_in;
	input [49151:0] rgb_in;
	output valid_out;
	input signed [8:0] brightness;
	output [16383:0] gray_out;
		
	
	reg [3:0] Valid;
	always @(posedge clk) begin
		Valid <= {Valid[2:0],valid_in};
	end
	assign valid_out = Valid[3];
		
	genvar i;
	generate 
		for (i = 0; i < 2048; i = i+1) begin : rgb2grey_gen
			RGBtoGray rgb2grey (.clk(clk), .valid_in(Valid[2]), .rgb_in(rgb_in[(24*i + 23):(24*i)]),
								.gray_out(gray_out[(8*i + 7):(8*i)]), .brightness(brightness));
		end
	endgenerate

endmodule
