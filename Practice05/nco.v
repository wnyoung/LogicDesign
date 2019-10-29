// Numerical Controlled Oscillator
module nco(	clk_gen,
		num,
		clk,
		rst_n);

output		clk_gen	;// 1Hz CLK

input	[31:0]	num	;
input		clk	;// 50Mhz CLK
input		rst_n	;

reg	[31:0]	cnt	;
reg		clk_gen	;


always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt 	<= 32'd0	;	//reset
		clk_gen <= 1'd0		;
	end else begin
		if(cnt >= num/2-1) begin
			cnt	<= 32'd0 ;
			clk_gen <= ~clk_gen;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule
