module	tb_mux2to1	;

reg	in0	;
reg	in1	;
reg	sel	;

wire	out	;
wire	out2	;
wire	out3	;

mux2to1_cond	dut_1(	.out	(	out	),
			.sel	(	sel	),
			.in0	(	in0	),
			.in1	(	in1	));


mux2to1_if	dut_2(	.out	(	out2	),
			.sel	(	sel	),
			.in0	(	in0	),
			.in1	(	in1	));

mux2to1_case	dut_3(	.out	(	out3	),
			.sel	(	sel	),
			.in0	(	in0	),
			.in1	(	in1	));

initial begin
	$display("cond:	out");
	$display("if:	out2");
	$display("case: out3");
	$display("======================================================");
	$display("	in0	in1	sel	out	out2	out3	");
	$display("======================================================");
	#(50)	{in0, in1, sel } = 3'b_000;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	{in0, in1, sel } = 3'b_001;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	{in0, in1, sel } = 3'b_010;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	{in0, in1, sel } = 3'b_011;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	{in0, in1, sel } = 3'b_100;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	{in0, in1, sel } = 3'b_101;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	{in0, in1, sel } = 3'b_110;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	{in0, in1, sel } = 3'b_111;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t", in0, in1, sel, out, out2, out3);
	#(50)	$finish;
end
	

endmodule



