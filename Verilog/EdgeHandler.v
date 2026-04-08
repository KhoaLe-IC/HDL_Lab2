module EdgeHandler #(
    parameter width = 430,
    parameter height = 554
)(
    input clk,
    input valid_input,
    input reset,

    input [7:0]pixel_00, pixel_01, pixel_02,
    input [7:0]pixel_10, pixel_11, pixel_12,
    input [7:0]pixel_20, pixel_21, pixel_22,

    output reg finish,
    output reg require_extend,
    output[9:0]x,y,
    output reg [7:0]p00, p01, p02,
    output reg [7:0]p10, p11, p12,
    output reg [7:0]p20, p21, p22,
    output reg edge_detect
);
    reg [9:0]x_count = 10'd0;
    reg [9:0]y_count = 10'd0;

    assign x = x_count;
    assign y = y_count;

    always @(posedge clk) begin 
        if (!reset) begin 
            x_count <= 10'd0;
            y_count <= 10'd0;
        end
        else if (valid_input) begin
            if (x_count == width - 1) begin 
                x_count <= 0; 
                y_count <= y_count + 1;
            end
            else begin 
                if (x_count == 1 && y_count == height) begin 
                    require_extend <= 1;
                end
                else if (x_count == 1 && y_count == height + 1) begin 
                    finish <= 1;
                    y_count <= 0;
                end
                x_count <= x_count + 1;
            end
        end
    end

    always @(*) begin 
        p00 = pixel_00; p01 = pixel_01; p02 = pixel_02;
        p10 = pixel_10; p11 = pixel_11; p12 = pixel_12;
        p20 = pixel_20; p21 = pixel_21; p22 = pixel_22;
        if ((y_count == 1 && x_count >= 2) || (y_count == 2 && (x_count == 0 || x_count == 1))) begin  //Top-edge addressing
            p00 = 0; 
            p01 = 0;
            p02 = 0;
        end
        else if ((y_count == height && x_count >= 2) || (y_count == height + 1 && (x_count == 0 || x_count == 1))) begin //Bottom-edge addressing
            p20 = 0;
            p21 = 0;
            p22 = 0;
        end

        if (x_count == 2) begin //Left-edge addresing
            p00 = 0;
            p10 = 0;
            p20 = 0;
        end    
        else if (x_count == 1) begin //Right-edge addresing
            p02 = 0;
            p12 = 0;
            p22 = 0;
        end
    end

endmodule
