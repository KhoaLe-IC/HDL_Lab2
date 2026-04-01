module TB_RGB2Grey();
    reg clk;
    reg [7:0] Valid_in;
    reg [191:0] rgb_in;
    reg signed [8:0] brightness;
    
    reg [23:0] File_inp [0:2795519]; 
    
    wire [7:0] Valid_out;
    wire [63:0] Gray_out;
    
    integer i, j, File_id;
    
    Topmodule RGB2grey (.clk(clk), .valid_in(Valid_in), .valid_out(Valid_out), 
						.brightness(brightness), .rgb_in(rgb_in), .gray_out(Gray_out));
    
    always #10 clk = ~clk;
    
    initial begin
        clk = 0;
        Valid_in = 8'd0;
        rgb_in = 192'd0;
        brightness = 9'd0; 
    end
    
    initial begin
        $readmemh("baitap2.hex", File_inp);
        File_id = $fopen("baitap2_out.hex", "w");
        
        for (i = 0; i < 1365; i = i + 1) begin
            for (j = 0; j < 2048; j = j + 8) begin 
                rgb_in = {File_inp[i*2048 + j + 7], File_inp[i*2048 + j + 6], File_inp[i*2048 + j + 5],
						  File_inp[i*2048 + j + 4], File_inp[i*2048 + j + 3], File_inp[i*2048 + j + 2],
						  File_inp[i*2048 + j + 1], File_inp[i*2048 + j + 0]};
                Valid_in = 8'hFF; 
                
                @(posedge clk); 
            end
        end
        
        Valid_in = 8'h00; 
        
        #500
        
        $fclose(File_id);
        $finish;
    end
    
    always @(posedge clk) begin
        if(Valid_out[0]) begin
            $fdisplay(File_id, "%02x", Gray_out[7:0]);
            $fdisplay(File_id, "%02x", Gray_out[15:8]);
            $fdisplay(File_id, "%02x", Gray_out[23:16]);
            $fdisplay(File_id, "%02x", Gray_out[31:24]);
            $fdisplay(File_id, "%02x", Gray_out[39:32]);
            $fdisplay(File_id, "%02x", Gray_out[47:40]);
            $fdisplay(File_id, "%02x", Gray_out[55:48]);
            $fdisplay(File_id, "%02x", Gray_out[63:56]);
        end
    end
endmodule