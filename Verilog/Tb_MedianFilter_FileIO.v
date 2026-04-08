`timescale 1ns/1ps

module Tb_MedianFilter_FileIO();
    // Parameters for image dimensions
    parameter WIDTH = 430; 
    parameter HEIGHT = 554; 
    parameter IMG_SIZE = 238220; // Number of pixels in baitap1.hex

    reg clk;
    reg reset;
    reg valid_input;
    reg [7:0] pixel_input;

    wire [9:0] finish;
    wire valid_output;
    wire valid_win;
    wire [9:0] x, y;
    wire [7:0] pixel_out00, pixel_out01, pixel_out02;
    wire [7:0] pixel_out10, pixel_out11, pixel_out12;
    wire [7:0] pixel_out20, pixel_out21, pixel_out22;
    wire [7:0] median;

    // Memory arrays for file I/O
    reg [7:0] img_mem [0:IMG_SIZE-1];
    integer file_out;
    integer i;

    MedianFilter #(
        .width(WIDTH), 
        .height(HEIGHT)
    ) dut (
        .clk(clk),
        .reset(reset),
        .valid_input(valid_input),
        .pixel_input(pixel_input),
        .finish(finish),
        .valid_output(valid_output),
        .valid_win(valid_win),
        .x(x), .y(y),
        .pixel_out00(pixel_out00), .pixel_out01(pixel_out01), .pixel_out02(pixel_out02),
        .pixel_out10(pixel_out10), .pixel_out11(pixel_out11), .pixel_out12(pixel_out12),
        .pixel_out20(pixel_out20), .pixel_out21(pixel_out21), .pixel_out22(pixel_out22),
        .median(median)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer write_count = 0;

    // File writing logic: Write median when valid_output is high
    // MedianFilter already handles the 10-stage pipeline delay internally!
    always @(posedge clk) begin
        if (valid_output) begin
            $fdisplay(file_out, "%02X", median);
            write_count = write_count + 1;
            
            // Stop exactly when we have written all IMG_SIZE pixels
            if (write_count == IMG_SIZE) begin
                $fclose(file_out);
                $display("=== KET THUC MO PHONG & DA LUU %0d KET QUA VAO ketqua1.hex ===", write_count);
                $finish;
            end
        end
    end

    initial begin
        // Initialize memory and files using absolute paths
        $readmemh("D:/DOCUMENTS/UNIVERSITIES/PDF OF LESSONS/Semester 4/HDL/Practise/Lab2/Vivado_baitap1/baitap1.hex", img_mem);
        file_out = $fopen("D:/DOCUMENTS/UNIVERSITIES/PDF OF LESSONS/Semester 4/HDL/Practise/Lab2/Vivado_baitap1/ketqua1.hex", "w");
        
        if (file_out == 0) begin
            $display("Error: Could not open ketqua1.hex for writing.");
            $finish;
        end

        // Reset
        valid_input = 0;
        pixel_input = 0;
        reset = 0;
        #20;
        reset = 1;
        #20;

        $display("=== BAT DAU NAP DU LIEU TU FILE ===");
        
        // Feed image pixels to DUT
        for (i = 0; i < IMG_SIZE; i = i + 1) begin
            @(posedge clk);
            valid_input <= 1;
            pixel_input <= img_mem[i];
        end

        // To flush the remaining pixels out of the pipeline,
        // we must continue asserting valid_input with dummy pixels.
        // The file writing block will automatically terminate the simulation
        // when exactly IMG_SIZE pixels have been written.
        while (1) begin
            @(posedge clk);
            valid_input <= 1;
            pixel_input <= 8'd0;
        end
    end

endmodule