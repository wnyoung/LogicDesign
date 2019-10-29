module	tb_sequential	;


reg		d	;
reg		clk	;
reg		rst_n	;

wire		out	;
wire		out2	;
wire		out3	;

initial		clk = 1'b0	;
always	#(100)	clk = ~clk	;

d_latch		dut_1(	.q	(	out	),
			.d	(	d	),
			.clk	(	clk	),
			.rst_n	(	rst_n	));

dff_asyn	dut_2(	.q	(	out2	),
			.d	(	d	),
			.clk	(	clk	),
			.rst_n	(	rst_n	));

dff_syn		dut_3(	.q	(	out3	),
			.d	(	d	),
			.clk	(	clk	),
			.rst_n	(	rst_n	));

initial begin
	$display("dut_1: out");
	$display("dut_2: out2");
	$display("dut_3: out3");
	$display("==========================================================================");
	$display("	rst_n	d	out	out2	out3");
	$display("==========================================================================");
	#(0)	{rst_n, d} = 2'b_00;
	#(50)	{rst_n, d} = 2'b_00;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t", rst_n, d, out, out2, out3);
	#(50)	{rst_n, d} = 2'b_10;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t", rst_n, d, out, out2, out3);
	#(50)	{rst_n, d} = 2'b_10;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t", rst_n, d, out, out2, out3);
	#(50)	{rst_n, d} = 2'b_11;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t", rst_n, d, out, out2, out3);
	#(50)	{rst_n, d} = 2'b_11;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t", rst_n, d, out, out2, out3);
	#(50)	{rst_n, d} = 2'b_10;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t", rst_n, d, out, out2, out3);
	#(50)	{rst_n, d} = 2'b_11;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t", rst_n, d, out, out2, out3);
	$finish;

	end
endmodule

