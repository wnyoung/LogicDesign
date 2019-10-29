module	tb_top_nco_cnt_disp;

parameter	tCK 	= 1000/50	; // 50MHz Clock

wire	[5:0]	o_seg_enb	;
wire		o_seg_dp	;
wire	[6:0]	o_seg		;

reg		clk		;
reg		rst_n		;

initial			clk = 1'b0	;
always	#(tCK/2)	clk = ~clk	;


top_nco_cnt_disp	u_top(	.o_seg_enb(	o_seg_enb	),
				.o_seg_dp(	o_seg_dp	),
				.o_seg(		o_seg	),
				.clk(		clk	),
				.rst_n(		rst_n	));

initial begin
	#(0*tCK)	rst_n = 1'b0		;
	#(1*tCK)	rst_n = 1'b1		;
	#(10000000*tCK )	$finish		;
end

endmodule