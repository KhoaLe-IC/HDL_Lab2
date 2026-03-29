module MedianFilter(
    input clk,
    input [7:0]pixel_0, pixel_1, pixel_2,
    input [7:0]pixel_3, pixel_4, pixel_5,
    input [7:0]pixel_6, pixel_7, pixel_8,
    output [7:0]median
);
    MedianFiding medianfind(
        .clk(clk),
        .pixel_0(pixel_0), .pixel_1(pixel_1), .pixel_2(pixel_2),
        .pixel_3(pixel_3), .pixel_4(pixel_4), .pixel_5(pixel_5),
        .pixel_6(pixel_6), .pixel_7(pixel_7), .pixel_8(pixel_8),
        .median(median)
    );
endmodule