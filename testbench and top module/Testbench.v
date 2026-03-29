module Testbench();
	reg clk, Valid_in, res;
	reg [7:0] p0,p1,p2,p3,p4,p5,p6,p7,p8;
	
	reg [7:0] File_inp [0:238219];
	
	wire Valid_out;
	wire [7:0] Out_pixel;
	
	integer i, j, File_id;
	
	// instantiate the topmodule
	MedianTop topmodule(
        .clk(clk), .p0(p0), .p1(p1), .p2(p2), .p3(p3), .res(res),
		.p4(p4), .p5(p5), .p6(p6), .p7(p7), .p8(p8),
        .Valid_in(Valid_in), .Valid_out(Valid_out), .Out_pixel(Out_pixel)
    );
	initial begin
		clk = 0;
		Valid_in = 0;
		res=0;
	end
	
	// clock generation
	always #10 clk = ~clk;
	
	
	initial begin
		
		// load hex data from "input.txt"
		$readmemh("image_hex.txt", File_inp);
		File_id = $fopen("output.txt", "w");
		
		{p0, p1, p2, p3, p4, p5, p6, p7, p8} = 0;
        #45; res=1;
	
		// sliding window loop 
		for (i = 0; i < 554; i = i+1) begin
			for (j = 0; j < 430; j = j+1) begin
				@(posedge clk);
				p0 <= ((i-1)<0 || (j-1)<0) ? 8'd0 : File_inp[(i-1)*430 + (j-1)];
                p1 <= ((i-1)<0) ? 8'd0 : File_inp[(i-1)*430 + (j)];
                p2 <= ((i-1)<0 || (j+1)>429) ? 8'd0 : File_inp[(i-1)*430 + (j+1)];	
				
                p3 <= ((j-1)<0) ? 8'd0 : File_inp[(i)*430 + (j-1)];
                p4 <= File_inp[(i)*430 + (j)];
                p5 <= ((j+1)>429) ? 8'd0 : File_inp[(i)*430 + (j+1)];
                
				p6 <= ((i+1)>553) ? 8'd0 : File_inp[(i+1)*430 + (j-1)];
                p7 <= ((i+1)>553) ? 8'd0 : File_inp[(i+1)*430 + (j)];
                p8 <= ((i+1)>553 || (j+1)>429) ? 8'd0 : File_inp[(i+1)*430 + (j+1)];
				Valid_in <= 1'b1;
			end
		end
		@(posedge clk);
		Valid_in <= 1'b0;
		
		#500
		$fclose(File_id);
		$finish;
	end
	
	always @(posedge clk) begin
		if(Valid_out) begin
			$fdisplay(File_id,"%h",Out_pixel);
		end
	end
endmodule