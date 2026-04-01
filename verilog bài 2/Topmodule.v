module Topmodule(clk, valid_in, valid_out, rgb_in, brightness, gray_out);
	input clk;
	input [7:0] valid_in;
	input [191:0] rgb_in;
	output [7:0] valid_out;
	input signed [8:0] brightness;
	output [63:0] gray_out;
	
	genvar i;
	generate 
		for (i = 0; i < 8; i = i+1) begin : rgb2grey_gen
			RGBtoGray rgb2grey (.clk(clk), .valid_in(valid_in[i]), .valid_out(valid_out[i]), .rgb_in(rgb_in[(24*i + 23):(24*i)]),
								.gray_out(gray_out[(8*i + 7):(8*i)]), .brightness(brightness));
		end
	endgenerate

endmodule