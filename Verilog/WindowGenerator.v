module WindowGenerator #(
    parameter width = 5
)(
    input clk,
    input [7:0]pixel_input,
    input valid_input,
    input reset,

    output reg valid_output,
    output reg [7:0]pixel_00, pixel_01, pixel_02,
    output reg [7:0]pixel_10, pixel_11, pixel_12,
    output reg [7:0]pixel_20, pixel_21, pixel_22,
    output [7:0]p00,p01,p02,p03,p04,
    output [7:0]p10,p11,p12,p13,p14,
    output [7:0]new_pixel
);
    reg [7:0]line_buffer1[0:width-1];
    reg [7:0]line_buffer0[0:width-1];
    reg [9:0]total_pixels = 10'd0;
    reg [9:0]pointer = 10'd0;

    wire [7:0]add_upper = line_buffer1[pointer];
    wire [7:0]add_middle = line_buffer0[pointer];
    wire [7:0]add_lower = pixel_input;

    always @(posedge clk) begin 
        if (!reset) pointer = 10'd0;
        else if (valid_input) begin 
            if (pointer == width - 1) pointer <= 10'd0;
            else pointer <= pointer + 1;
        end
        else pointer <= pointer;

        line_buffer0[pointer] <= pixel_input;
        line_buffer1[pointer] <= line_buffer0[pointer];
    end

    always @(posedge clk) begin 
        if (!reset) begin 
            {pixel_00, pixel_01, pixel_02} = 24'd0;
            {pixel_10, pixel_11, pixel_12} = 24'd0;
            {pixel_20, pixel_21, pixel_22} = 24'd0;
        end
        else begin 
            pixel_00 <= pixel_01; pixel_01 <= pixel_02; pixel_02 <= add_upper;
            pixel_10 <= pixel_11; pixel_11 <= pixel_12; pixel_12 <= add_middle;
            pixel_20 <= pixel_21; pixel_21 <= pixel_22; pixel_22 <= add_lower;
        end
    end

    always @(posedge clk) begin 
        if (!reset) begin 
            total_pixels <= 10'd0;
            valid_output <= 0;
        end
        else if (valid_input) begin 
            if (total_pixels >= width + 1) valid_output <= 1;
            else begin 
                total_pixels <= total_pixels + 1;
                valid_output <= 0;
            end
        end
        else begin 
            valid_output <= 0;
            total_pixels <= total_pixels;
        end
    end

    assign new_pixel = pixel_input;
    assign p00 = line_buffer0[0];
    assign p01 = line_buffer0[1];
    assign p02 = line_buffer0[2];
    assign p03 = line_buffer0[3];
    assign p04 = line_buffer0[4];
    assign p10 = line_buffer1[0];
    assign p11 = line_buffer1[1];
    assign p12 = line_buffer1[2];
    assign p13 = line_buffer1[3];
    assign p14 = line_buffer1[4];
endmodule
