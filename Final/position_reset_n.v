
//같은 역할 하는 reset관련 모듈 하나로 합쳐야됨
module position_reset_n(	o_position_rst_n,
				i_sw0);

output	o_position_rst_n	;
input	i_sw0	;

assign o_position_rst_n = i_sw0;

endmodule