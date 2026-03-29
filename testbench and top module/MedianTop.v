module MedianTop(clk, p0, p1, p2, p3, p4, p5, p6, p7, p8, Valid_in, res, Valid_out, Out_pixel);
    input clk, Valid_in, res;
    input [7:0] p0,p1,p2,p3,p4,p5,p6,p7,p8;
    output [7:0] Out_pixel;    
    output Valid_out;
    
    // Gọi lõi 9 tầng của bạn
    MedianFinding ALG1(
        .clk(clk), 
        .pixel_0(p0), .pixel_1(p1), .pixel_2(p2), 
        .pixel_3(p3), .pixel_4(p4), .pixel_5(p5), 
        .pixel_6(p6), .pixel_7(p7), .pixel_8(p8),
        .median(Out_pixel)
    );
    
    // Thanh ghi dịch 9-bit cho Pipeline 9 tầng
    reg [8:0] valid_delay; 

    always @(posedge clk or negedge res) begin
        if(!res) begin
            valid_delay <= 9'b0;
        end
        else begin
            // Dịch chuyển tín hiệu Valid_in
            valid_delay <= {valid_delay[7:0], Valid_in};
        end
    end

    // Valid_out sẽ bật lên sau đúng 9 chu kỳ clock
    assign Valid_out = valid_delay[8]; 
endmodule