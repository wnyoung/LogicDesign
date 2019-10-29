module	tb_decoder	;

reg	[2:0]	in	;
reg		en	;

wire	[7:0]	out	;
wire	[7:0]	out2	;

dec3to8_shift	dut_1(	.out	(	out	),
			.in	(	in	),
			.en	(	en	));

dec3to8_case	dut_2(	.out	(	out2	),
			.in	(	in	),
			.en	(	en	));

initial begin
	$display("inst:	out");
	$display("if:	out2");
	$display("==========================================================================");
	$display("	en	in[2]	in[1]	in[0]	out	out2");
	$display("==========================================================================");
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0000;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0001;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0010;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0011;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0100;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0101;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0110;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_0111;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1000;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1001;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1010;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1011;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1100;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1101;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1110;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	#(50)	{en, in[2], in[1], in[0]} = 4'b_1111;	#(50)	$display("	%b\t%b\t%b\t%b\t%d\t%d\t", en, in[2], in[1], in[0], out, out2);
	end
endmodule


