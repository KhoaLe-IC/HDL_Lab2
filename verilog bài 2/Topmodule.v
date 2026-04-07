//code xử lý 1 hàng 2048 pixel thay vì 1 cột 1365 pixel
//kiểu này đơn giản hơn do file input xử lý từng pixel theo từng hàng
module Topmodule(clk,valid_in, valid_out, rgb_in, brightness, gray_out);
	input clk;
	input valid_in;
	input [49151:0] rgb_in;
	output valid_out;
	input signed [8:0] brightness;
	output [16383:0] gray_out;
	
	
	//thanh ghi valid này t lấy ra ngoài do tại mình nạp 2048 pixel cùng 1 lúc thì t nghĩ
	//1 tín hiệu valid thôi có thể thay thế được cho 2048 cái tín hiệu trong module RGBtoGray
	reg [3:0] Valid;
	always @(posedge clk) begin
		// thêm res ở đây không thì những pixel đầu cho ra xx
		
			Valid <= {Valid[2:0],valid_in};
		
	end
	assign valid_out = Valid[3];
	
	
	//valid[3] thì ra xx còn valid[2] thì ra đúng
	//vào cái xung clock thứ 4 thì do valid[3] chưa được nạp giá trị nên còn là xx,
	genvar i;
	generate 
		for (i = 0; i < 2048; i = i+1) begin : rgb2grey_gen
			RGBtoGray rgb2grey (.clk(clk), .valid_in(Valid[2]), .rgb_in(rgb_in[(24*i + 23):(24*i)]),
								.gray_out(gray_out[(8*i + 7):(8*i)]), .brightness(brightness));
		end
	endgenerate

endmodule