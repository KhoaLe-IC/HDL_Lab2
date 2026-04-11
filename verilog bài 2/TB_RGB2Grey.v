`timescale 1ns/1ps
module TB_RGB2Grey();
    reg clk;
    reg Valid_in;
    reg [49151:0] rgb_in;
    reg signed [8:0] brightness;
    
    reg [23:0] File_inp [0:2795519]; 
    
    wire Valid_out;
    wire [16383:0] Gray_out;
    
    integer i, j, o, File_id;
    
    Topmodule RGB2grey (.clk(clk), .valid_in(Valid_in), .valid_out(Valid_out), 
						.brightness(brightness), .rgb_in(rgb_in), .gray_out(Gray_out));
    
    always #3 clk = ~clk;
    
    initial begin
        clk = 0;
        Valid_in = 0;
        rgb_in = 0;
        brightness = -30; 
    end
    
    initial begin
        $readmemh("baitap2.hex", File_inp);
        File_id = $fopen("baitap2_out.hex", "w");
        
        for (i = 0; i < 1365; i = i + 1) begin
            for (j = 0; j < 2048; j = j + 1) begin 
                rgb_in[24*j +: 24] = File_inp[i*2048+j];
                 
            end
			Valid_in = 1; 
            @(posedge clk);
        end
        
        Valid_in = 0; 
        
        #100
        
        $fclose(File_id);
        $finish;
    end
    
    always @(posedge clk) begin
        if(Valid_out) begin
            for (o = 0; o < 2048; o = o + 1) begin
                $fdisplay(File_id, "%02x", Gray_out[(o * 8) +: 8]);
            end
        end
    end
endmodule
