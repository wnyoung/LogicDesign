module cnt6(	out,
		clk,
		rst_n);

output	[5:0]	out	;
input		clk	;
input		rst_n	;

reg	[5:0]	out	;

always @(posedge clk or negedge rst_n ) begin
	if(rst_n == 1'b0 ) begin
		out <= 6'd0;
	end else begin
		if(out >= 6'd59 ) begin
			out <= 6'd0;
		end else begin
			out <= out + 1'b1;
		end
	end
end
endmodule


