/* --------------------------------------------------------------------
   1. reset <-- module buzz_reset_n 586
                2. beat  <-- i_nco_num = 1250000 * beat      568
   3. brk   <-= split pitch         819
-----------------------------------------------------------------------*/
module	buzz(
		o_buzz,
		i_buzz_en,
		i_countdowner_buzz_en,
		clk,
		rst_n);

output		o_buzz			;

input		i_countdowner_buzz_en	;
input		i_buzz_en		;
input		clk			;
input		rst_n			;

parameter	cnt_max = 97	;

parameter	C_7 = 191113	;
parameter	D_7 = 170262	;
parameter	E_7 = 151686	;
parameter	F_7 = 143173	;
parameter	G_7 = 127553	;
parameter	A_7 = 113636	;
parameter	B_7 = 101238	;

parameter	C_8 = 95556	;
parameter	D_8 = 85131	;
parameter	E_8 = 75843	;
parameter	F_8 = 71586	;


wire		last_buzz_en	;
assign		last_buzz_en = (i_buzz_en | i_countdowner_buzz_en)	;


wire	i_buzz_rst_n	;
buzz_reset_n	u_buzz_reset_n(
				.o_buzz_rst_n(	i_buzz_rst_n	),
				.rst_n(   	rst_n   	),
				.i_buzz_en(	last_buzz_en	));

reg	[6:0]	beat		;
wire		clk_beat	;
nco	u_nco_bit(	
		.o_gen_clk	( clk_beat	),
		.i_nco_num	( 1250000 * beat 	),
		.clk		( clk		),
		.rst_n		( rst_n		)); //reset

reg	[6:0]	cnt		;
always @(posedge clk_beat or negedge i_buzz_rst_n) begin
	if(i_buzz_rst_n == 1'b0) begin
		cnt <= 6'd0;
	end else begin
		//nco_num <= 100;
		if(cnt >= cnt_max) begin
			cnt <= 6'd0		;
		end else begin
			cnt <= cnt + 1'd1	;
		end
	end
end

reg	[31:0]	nco_num		;
reg		brk		;
always @ (*) begin
	case(cnt)

		7'd00: begin
			nco_num = B_7	;
			beat = 1	;
		end
		7'd02: begin
			nco_num = B_7	;
			beat = 1	;
		end
		7'd04: begin
			nco_num = B_7   ;
			beat = 2   	;
		end


		7'd06: begin
			nco_num = B_7   ;
			beat = 1   	;
		end
		7'd08: begin
			nco_num = B_7   ;
			beat = 1   	;
		end
		7'd10: begin
			nco_num = B_7   ;
			beat = 2   	;
		end


		7'd12: begin
			nco_num = B_7   ;
			beat = 1   	;
		end
		7'd14: begin
			nco_num = D_8   ;
			beat = 1   	;
		end
		7'd16: begin
			nco_num = G_7   ;
			beat = 1   	;
		end
		7'd18: begin
			nco_num = A_7   ;
			beat = 1   	;
		end
		7'd20: begin
			nco_num = B_7   ;
			beat = 4    	;
		end

		7'd22: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd24: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd26: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd28: begin
			nco_num = C_8   ;
			beat = 1   ;
		end


		7'd30: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd32:begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd34: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd36: begin
			nco_num = B_7   ;
			beat = 1    ;
		end


		7'd38: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd40: begin
			nco_num = A_7   ;
			beat = 1   ;
		end
		7'd42: begin
			nco_num = A_7   ;
			beat = 1   ;
		end
		7'd44: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd46: begin
			nco_num = A_7   ;
			beat = 2   ;
		end
		7'd48: begin
			nco_num = D_8   ;
			beat = 2   ;
		end


		7'd50: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd52: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd54: begin
			nco_num = B_7   ;
			beat = 2   ;
		end


		7'd56: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd58: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd60: begin
			nco_num = B_7   ;
			beat = 2   ;
		end


		7'd62: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd64: begin
			nco_num = D_8   ;
			beat = 1   ;
		end
		7'd66: begin
			nco_num = G_7   ;
			beat = 1   ;
		end
		7'd68: begin
			nco_num = A_7   ;
			beat = 1   ;
		end
		7'd70: begin
			nco_num = B_7   ;
			beat = 4   ;
		end


		7'd72: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd74: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd76: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd78: begin
			nco_num = C_8   ;
			beat = 1   ;
		end


		7'd80: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd82: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd84: begin
			nco_num = B_7   ;
			beat = 1   ;
		end
		7'd86: begin
			nco_num = B_7   ;
			beat = 1   ;
		end


		7'd88: begin
			nco_num = D_8   ;
			beat = 1   ;
		end
		7'd90: begin
			nco_num = D_8   ;
			beat = 1   ;
		end
		7'd92: begin
			nco_num = C_8   ;
			beat = 1   ;
		end
		7'd94: begin
			nco_num = A_7   ;
			beat = 1   ;
		end
		7'd96: begin
			nco_num = G_7   ;
			beat = 4   ;
		end
		default: begin
			nco_num = C_7   ;
			beat = 5   ;
			brk = 1      ;
		end

	endcase
	if (cnt %2 ==0) begin
		beat <= beat*10      ;
		brk <=0         ;
	end
end


wire	buzz	;
nco	u_nco_buzz(
			.o_gen_clk	( buzz		),
			.i_nco_num	( nco_num	),
			.clk		( clk		),
			.rst_n		( rst_n		));


assign	o_buzz = buzz & last_buzz_en & ~brk	;

endmodule