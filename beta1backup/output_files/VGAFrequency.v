module VGAFrequency(
    // input CLOCK_50, //for test
	 input clk,
    output reg VGAclk
    );
	 
	initial
	begin
		VGAclk = 1;
	end
	
	always @ (posedge clk) begin
				VGAclk <= ~VGAclk; // 25 MHz
	end

endmodule