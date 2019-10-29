module	tb_mux4to1	;

reg	[3:0]	in	;
reg	[1:0]	sel	;

wire	out	;
wire	out2	;
wire	out3	;

mux_4to1_inst	dut_1(	.out	(	out	),
			.in	(	in	),
			.sel	(	sel	));


mux4to1_if	dut_2(	.out	(	out2	),
			.in	(	in	),
			.sel	(	sel	));

mux4to1_case	dut_3(	.out	(	out3	),
			.in	(	in	),
			.sel	(	sel	));

initial begin
	$display("inst:	out");
	$display("if:	out2");
	$display("case: out3");
	$display("==========================================================================");
	$display("	sel[1]	sel[2]	in[3]	in[2]	in[1]	in[0]	out	out2	out3");
	$display("==========================================================================");
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000000;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000001;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000010;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000011;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000100;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000101;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000110;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_000111;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001000;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001001;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001010;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001011;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001100;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001101;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001110;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	{sel[1], sel[0], in[3], in[2], in[1], in[0]} = 6'b_001111;	#(50)	$display("	%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", sel[1], sel[0], in[3], in[2], in[1], in[0], out, out2, out3);
	#(50)	$finish;
end


endmodule



