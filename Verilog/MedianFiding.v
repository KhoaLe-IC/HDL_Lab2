module MedianFiding(
    input clk,
    input [7:0]pixel_00, pixel_01, pixel_02, pixel_10, pixel_11, pixel_12, pixel_20, pixel_21, pixel_22,
    output reg[7:0]median
);
    reg [7:0]pipe1[0:8];
    reg [7:0]pipe2[0:8];
    reg [7:0]pipe3[0:8];
    reg [7:0]pipe4[0:8];
    reg [7:0]pipe5[0:8];
    reg [7:0]pipe6[0:8];
    reg [7:0]pipe7[0:8];
    reg [7:0]pipe8[0:8];
    reg [7:0]pipe9[0:8];

    always @(posedge clk) begin
        pipe1[4] <= pixel_11;
        
        pipe1[5] <= (pixel_12 > pixel_00)? pixel_12 : pixel_00;
        pipe1[0] <= (pixel_12 > pixel_00)? pixel_00 : pixel_12;
        
        pipe1[6] <= (pixel_20 > pixel_01)? pixel_20 : pixel_01;
        pipe1[1] <= (pixel_20 > pixel_01)? pixel_01 : pixel_20;

        pipe1[7] <= (pixel_21 > pixel_02)? pixel_21 : pixel_02;
        pipe1[2] <= (pixel_21 > pixel_02)? pixel_02 : pixel_21;
        
        pipe1[8] <= (pixel_22 > pixel_10)? pixel_22 : pixel_10;
        pipe1[3] <= (pixel_22 > pixel_10)? pixel_10 : pixel_22;
    end

    always @(posedge clk) begin 
        pipe2[4] <= pipe1[4];

        pipe2[8] <= (pipe1[8] > pipe1[6]) ? pipe1[8] : pipe1[6];
        pipe2[6] <= (pipe1[8] > pipe1[6]) ? pipe1[6] : pipe1[8];
        pipe2[3] <= (pipe1[8] > pipe1[6]) ? pipe1[3] : pipe1[1];
        pipe2[1] <= (pipe1[8] > pipe1[6]) ? pipe1[1] : pipe1[3];

        pipe2[7] <= (pipe1[7] > pipe1[5]) ? pipe1[7] : pipe1[5];
        pipe2[5] <= (pipe1[7] > pipe1[5]) ? pipe1[5] : pipe1[7];
        pipe2[2] <= (pipe1[7] > pipe1[5]) ? pipe1[2] : pipe1[0];
        pipe2[0] <= (pipe1[7] > pipe1[5]) ? pipe1[0] : pipe1[2];
    end

    always @(posedge clk) begin
        pipe3[4] <= pipe2[4];
        
        pipe3[8] <= (pipe2[8] > pipe2[7]) ? pipe2[8] : pipe2[7];
        pipe3[7] <= (pipe2[8] > pipe2[7]) ? pipe2[7] : pipe2[8];
        
        pipe3[1] <= (pipe2[8] > pipe2[7]) ? pipe2[1] : pipe2[0];
        pipe3[0] <= (pipe2[8] > pipe2[7]) ? pipe2[0] : pipe2[1];

        pipe3[3] <= (pipe2[8] > pipe2[7]) ? pipe2[3] : pipe2[2];
        pipe3[2] <= (pipe2[8] > pipe2[7]) ? pipe2[2] : pipe2[3];

        pipe3[6] <= (pipe2[8] > pipe2[7]) ? pipe2[6] : pipe2[5];
        pipe3[5] <= (pipe2[8] > pipe2[7]) ? pipe2[5] : pipe2[6];
    end

    always @(posedge clk) begin
        pipe4[8] <= pipe3[8];
        pipe4[5] <= pipe3[5];
        pipe4[0] <= pipe3[0];

        pipe4[7] <= (pipe3[7] > pipe3[6]) ? pipe3[7] : pipe3[6];
        pipe4[6] <= (pipe3[7] > pipe3[6]) ? pipe3[6] : pipe3[7];
        pipe4[2] <= (pipe3[7] > pipe3[6]) ? pipe3[2] : pipe3[1];
        pipe4[1] <= (pipe3[7] > pipe3[6]) ? pipe3[1] : pipe3[2];

        pipe4[4] <= (pipe3[4] > pipe3[3]) ? pipe3[4] : pipe3[3];
        pipe4[3] <= (pipe3[4] > pipe3[3]) ? pipe3[3] : pipe3[4];
    end

    always @(posedge clk) begin
        pipe5[8] <= pipe4[8];
        pipe5[7] <= pipe4[7];
        pipe5[3] <= pipe4[3];

        pipe5[6] <= (pipe4[6] > pipe4[5]) ? pipe4[6] : pipe4[5];
        pipe5[5] <= (pipe4[6] > pipe4[5]) ? pipe4[5] : pipe4[6];
        pipe5[1] <= (pipe4[6] > pipe4[5]) ? pipe4[1] : pipe4[0];
        pipe5[0] <= (pipe4[6] > pipe4[5]) ? pipe4[0] : pipe4[1];

        pipe5[4] <= (pipe4[4] > pipe4[2]) ? pipe4[4] : pipe4[2];
        pipe5[2] <= (pipe4[4] > pipe4[2]) ? pipe4[2] : pipe4[4];
    end

    always @(posedge clk) begin
        pipe6[8] <= pipe5[8];
        pipe6[7] <= pipe5[7];
        pipe6[5] <= pipe5[5];
        pipe6[3] <= pipe5[3];
        pipe6[0] <= pipe5[0];

        pipe6[6] <= (pipe5[6] > pipe5[4]) ? pipe5[6] : pipe5[4];
        pipe6[4] <= (pipe5[6] > pipe5[4]) ? pipe5[4] : pipe5[6];
        pipe6[2] <= (pipe5[6] > pipe5[4]) ? pipe5[2] : pipe5[1];
        pipe6[1] <= (pipe5[6] > pipe5[4]) ? pipe5[1] : pipe5[2];
    end

    always @(posedge clk) begin
        pipe7[8] <= pipe6[8];
        pipe7[7] <= pipe6[7];
        pipe7[6] <= pipe6[6];

        pipe7[5] <= (pipe6[5] > pipe6[4]) ? pipe6[5] : pipe6[4];
        pipe7[4] <= (pipe6[5] > pipe6[4]) ? pipe6[4] : pipe6[5];
        pipe7[2] <= (pipe6[5] > pipe6[4]) ? pipe6[2] : pipe6[0];
        pipe7[0] <= (pipe6[5] > pipe6[4]) ? pipe6[0] : pipe6[2];

        pipe7[3] <= (pipe6[3] > pipe6[1]) ? pipe6[3] : pipe6[1];
        pipe7[1] <= (pipe6[3] > pipe6[1]) ? pipe6[1] : pipe6[3];
    end

    always @(posedge clk) begin
        pipe8[8] <= pipe7[8];
        pipe8[7] <= pipe7[7];
        pipe8[6] <= pipe7[6];
        pipe8[4] <= pipe7[4];
        pipe8[2] <= pipe7[2];

        pipe8[5] <= (pipe7[5] > pipe7[3]) ? pipe7[5] : pipe7[3];
        pipe8[3] <= (pipe7[5] > pipe7[3]) ? pipe7[3] : pipe7[5];
        pipe8[1] <= (pipe7[5] > pipe7[3]) ? pipe7[1] : pipe7[0];
        pipe8[0] <= (pipe7[5] > pipe7[3]) ? pipe7[0] : pipe7[1];
    end

    always @(posedge clk) begin
        pipe9[8] <= pipe8[8];
        pipe9[7] <= pipe8[7];
        pipe9[6] <= pipe8[6];
        pipe9[5] <= pipe8[5];
        pipe9[0] <= pipe8[0];

        pipe9[4] <= (pipe8[4] > pipe8[3]) ? pipe8[4] : pipe8[3];
        pipe9[3] <= (pipe8[4] > pipe8[3]) ? pipe8[3] : pipe8[4];
        pipe9[2] <= (pipe8[4] > pipe8[3]) ? pipe8[2] : pipe8[1];
        pipe9[1] <= (pipe8[4] > pipe8[3]) ? pipe8[1] : pipe8[2];
    end

    always @(posedge clk) begin
        median <= (pipe9[4] > pipe9[0]) ? pipe9[4] : pipe9[0];
    end 
endmodule