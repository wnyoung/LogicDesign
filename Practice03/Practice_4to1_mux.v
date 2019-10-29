module	mux_4to1_inst(	out,
			in,
			sel	);

output	out		;

input	[3:0]	in	;
input	[1:0]	sel	;


wire	[1:0]	mux_o	;


mux2to1_cond	inst_1(	.out	(	mux_o[0]	),
			.sel	(	sel[0]		),
			.in0	(	in[0]		),
			.in1	(	in[1]		));

mux2to1_cond	inst_2(	.out	(	mux_o[1]	),
			.sel	(	sel[0]	),
			.in0	(	in[0]	),
			.in1	(	in[1]	));

mux2to1_cond	inst_3(	.out	(	out	),
			.sel	(	sel[1]	),
			.in0	(	mux_o[0]	),
			.in1	(	mux_o[1]	));


endmodule  




module	mux4to1_if(	out,
			in,
			sel	);

output	out		;
input	[3:0]	in	;
input	[1:0]	sel	;

reg	out	;


always @(*) begin
	if(sel == 2'b00 ) begin
		out = in[0]	;
	end	else if(sel == 2'b01 ) begin
		out = in[1]	;
	end	else if(sel == 2'b10 ) begin
		out = in[2]	;
	end	else begin
		out = in[3]	;
	end

	end

endmodule

module	mux4to1_case(	out,
			in,
			sel	);

output	out		;
input	[3:0]	in	;
input	[1:0]	sel	;

reg	out	;

always @(*) begin
	case( sel)
	2'd0 : out = in[0]	;
	2'd1 : out = in[1]	;
	2'd2 : out = in[2]	;
	2'd3 : out = in[3]	;
	endcase
end

endmodule
