module	tb_bnb;

reg		d	;
reg		clk	;

wire		q1	;
wire		q2	;

initial		clk = 1'b0	;
always	#(100)	clk = ~clk	;

block		block(	.q	(	q1	),
			.d	(	d	),
			.clk	(	clk	));

nonblock	nonblock(	.q	(	q2	),
				.d	(	d	),
				.clk	(	clk	));

initial begin
	$display("block: q1");
	$display("nonblock: q2");
	$display("==========================================================================");
	$display("	clk	d	q1	q2	");
	$display("==========================================================================");
	#(0)	{d} = 1'b_0;
	#(50)	{d} = 1'b_0;	#(50)
	#(50)	{d} = 1'b_0;	#(50)
	#(50)	{d} = 1'b_1;	#(50)
	#(50)	{d} = 1'b_0;	#(50)
	#(50)	{d} = 1'b_0;	#(50)
	#(50)	{d} = 1'b_0;	#(50)
	#(50)	{d} = 1'b_1;	#(50)
	#(50)	{d} = 1'b_1;	#(50)
	#(50)	{d} = 1'b_1;	#(50)
	#(50)	{d} = 1'b_1;	#(50)
	#(50)	{d} = 1'b_0;	#(50)
	#(50)	{d} = 1'b_0;	#(50)
	#(50)	{d} = 1'b_1;	#(50)
	#(50)	{d} = 1'b_1;	#(50)
	$finish;
	end
endmodule


