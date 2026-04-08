module MedianFilter #(
    parameter width = 5,
    parameter height = 5
)(
    input clk,
    input reset,
    input valid_input,
    input [7:0]pixel_input,
    output reg [9:0]finish,
    output valid_output,
    output [9:0]x,y,
    output [7:0]pixel_out00, pixel_out01, pixel_out02,
    output [7:0]pixel_out10, pixel_out11, pixel_out12,
    output [7:0]pixel_out20, pixel_out21, pixel_out22,
    output [7:0]median,
    output valid_win
);
    wire [7:0]pixel_00, pixel_01, pixel_02;
    wire [7:0]pixel_10, pixel_11, pixel_12;
    wire [7:0]pixel_20, pixel_21, pixel_22;
    wire valid_window;

    WindowGenerator #(.width(width)) win_gen (
        .clk(clk),
        .pixel_input(pixel_input),
        .valid_input(valid_input),
        .reset(reset),
        .valid_output(valid_window),
        .pixel_00(pixel_00), .pixel_01(pixel_01), .pixel_02(pixel_02),
        .pixel_10(pixel_10), .pixel_11(pixel_11), .pixel_12(pixel_12),
        .pixel_20(pixel_20), .pixel_21(pixel_21), .pixel_22(pixel_22)
    );

    wire [7:0]p00, p01, p02;
    wire [7:0]p10, p11, p12;
    wire [7:0]p20, p21, p22;
    wire done;
    wire require_extend;

    EdgeHandler #(.width(width), .height(height)) handling_edge (
        .clk(clk),
        .valid_input(valid_input),
        .reset(reset),
        .pixel_00(pixel_00), .pixel_01(pixel_01), .pixel_02(pixel_02),
        .pixel_10(pixel_10), .pixel_11(pixel_11), .pixel_12(pixel_12),
        .pixel_20(pixel_20), .pixel_21(pixel_21), .pixel_22(pixel_22),
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22),
        .require_extend(require_extend),
        .finish(done),
        .x(x), .y(y)
    );

    reg [9:0]valid_output_pipe;

    always @(posedge clk) begin 
        if (!reset) begin
            valid_output_pipe <= 0;
            finish <= 0;
        end
        else begin
            if (require_extend == 1) begin
                valid_output_pipe <= {valid_output_pipe[8:0], 1'b1};
                if (done == 1) finish <= {finish[8:0], 1'b1};
                else finish <= {finish[8:0], 1'b0};
            end
            else valid_output_pipe <= {valid_output_pipe[8:0], valid_window};
        end
    end

    MedianFiding find_median (
        .clk(clk),
        .pixel_00(p00), .pixel_01(p01), .pixel_02(p02),
        .pixel_10(p10), .pixel_11(p11), .pixel_12(p12),
        .pixel_20(p20), .pixel_21(p21), .pixel_22(p22),
        .median(median)
    );
    assign valid_win = valid_window;
    assign valid_output = valid_output_pipe[9];
    assign pixel_out00 = p00; 
    assign pixel_out01 = p01;
    assign pixel_out02 = p02;
    assign pixel_out10 = p10;
    assign pixel_out11 = p11;
    assign pixel_out12 = p12;
    assign pixel_out20 = p20;
    assign pixel_out21 = p21;
    assign pixel_out22 = p22;

endmodule