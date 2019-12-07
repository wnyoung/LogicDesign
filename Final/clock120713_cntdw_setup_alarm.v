//   ==================================================
//   Copyright (c) 2019 Sookmyung Women's University.
//   --------------------------------------------------
//   FILE          : dut.v
//   DEPARTMENT      : EE
//   AUTHOR         : WOONG CHOI
//   EMAIL         : woongchoi@sookmyung.ac.kr
//   --------------------------------------------------
//   RELEASE HISTORY
//   --------------------------------------------------
//   VERSION         DATE
//   0.0         2019-11-18
//   --------------------------------------------------
//   PURPOSE         : Digital Clock
//   ==================================================

//   --------------------------------------------------
//   Numerical Controlled Oscillator
//   Hz of o_gen_clk = Clock Hz / num
//   --------------------------------------------------
module	nco(	
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 32'd0;
		o_gen_clk <= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt  <= 32'd0;
			o_gen_clk <= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(
		o_seg,
		i_num);

output	[6:0]	o_seg		;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	[3:0]	i_num		;
reg	[6:0]	o_seg		;
//making
always @(i_num) begin 
 	case(i_num) 
 		4'd0:	o_seg = 7'b111_1110; 
 		4'd1:	o_seg = 7'b011_0000; 
 		4'd2:	o_seg = 7'b110_1101; 
 		4'd3:	o_seg = 7'b111_1001; 
 		4'd4:	o_seg = 7'b011_0011; 
 		4'd5:	o_seg = 7'b101_1011; 
 		4'd6:	o_seg = 7'b101_1111; 
 		4'd7:	o_seg = 7'b111_0000; 
 		4'd8:	o_seg = 7'b111_1111; 
 		4'd9:	o_seg = 7'b111_0011; 
		default:o_seg = 7'b000_0000; 
	endcase 
end


endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
		o_left,
		o_right,
		i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;

endmodule


module   nco_blink(
                   blink_clk,
                   i_nco_num,
                   clk,
                   rst_n);

output     blink_clk ;   // 1Hz CLK

input   [31:0]   i_nco_num ;
input            clk ;   // 50Mhz CLK
input            rst_n ;

reg     [31:0]   cnt ;
reg              blink_clk  ;

always @(posedge clk or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      cnt      <= 32'd0 ;
     blink_clk   <= 1'd0 ;
   end else begin
      if(cnt >= i_nco_num/2-1) begin
         cnt    <= 32'd0 ;
         blink_clk  <= ~blink_clk ;
      end else begin
         cnt <= cnt + 1'b1 ;
      end
   end
end

endmodule

//   --------------------------------------------------
//   0~59 --> 2 Separated Segments
//   --------------------------------------------------
module   led_disp(
                  o_seg,
                  o_seg_dp,
                  o_seg_enb,
                  i_six_digit_seg,
                  i_mode,
                  clk,
                  rst_n,
                  i_position);

output   [5:0]   o_seg_enb ;
output           o_seg_dp ;
output   [6:0]   o_seg ;

input    [41:0]  i_six_digit_seg ;
input    [5:0]   i_mode ;
input            clk ;
input            rst_n ;
input    [5:0]   i_position;

wire             gen_clk ;

nco      u_nco(
               .o_gen_clk      ( gen_clk  ),
               .i_nco_num      ( 32'd5000 ),
               .clk            ( clk      ),
               .rst_n          ( rst_n    ));

wire             blink_clk ;

nco_blink      u_blink(
               .blink_clk      ( blink_clk   ),
               .i_nco_num      ( 32'd5000000 ),
               .clk            ( clk         ),
               .rst_n          ( rst_n       ));

reg      [3:0]   cnt_common_node ;

always @(posedge gen_clk or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      cnt_common_node <= 4'd0 ;
   end else begin
      if(cnt_common_node >= 4'd5) begin
         cnt_common_node <= 4'd0 ;
      end else begin
         cnt_common_node <= cnt_common_node + 1'b1 ;
      end
   end
end

reg   blink ;

always @(posedge blink_clk or negedge rst_n) begin
   if(rst_n == 1'b0) begin
        blink <= 1'b0 ;
      end else begin
        blink <= ~blink; //???? why 1'b1 can't operate?
   end
end

reg     [5:0]   o_seg_enb ;

always @(i_mode, blink, o_seg_enb, cnt_common_node, i_position) begin
      if(i_mode == 3'b001 ) begin
         if((blink==1'b0)&&(i_position==2'b00)) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b1)&&(i_position==2'b00)) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111111 ;
               4'd1:   o_seg_enb = 6'b111111 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b0)&&(i_position==2'b01)) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b1)&&(i_position==2'b01)) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111111 ;
               4'd3:   o_seg_enb = 6'b111111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b0)&&(i_position==2'b10)) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b1)&&(i_position==2'b10)) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b111111 ;
               4'd5:   o_seg_enb = 6'b111111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end
      end else if(i_mode == 3'b000 ) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
      end else if(i_mode == 3'b010 ) begin
         if((blink==1'b0)&&(i_position==2'b00)) begin
            case(cnt_common_node) 
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b1)&&(i_position==2'b00)) begin
            case(cnt_common_node) 
               4'd0:   o_seg_enb = 6'b111111 ;
               4'd1:   o_seg_enb = 6'b111111 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b0)&&(i_position==2'b01)) begin
            case(cnt_common_node) 
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b1)&&(i_position==2'b01)) begin
            case(cnt_common_node) 
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111111 ;
               4'd3:   o_seg_enb = 6'b111111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end else if(( blink == 1'b0)&&(i_position==2'b10)) begin
            case(cnt_common_node) 
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase      
         end else if(( blink == 1'b1)&&(i_position==2'b10)) begin
            case(cnt_common_node) 
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b111111 ;
               4'd5:   o_seg_enb = 6'b111111 ;
            default:o_seg_enb = 6'b111111;
            endcase
         end
      end else if(i_mode ==  3'b011 ) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
      end else if(i_mode ==  3'b100 ) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end
         else if(i_mode ==  3'b101 ) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end
         else if(i_mode ==  3'b110 ) begin
            case(cnt_common_node)
               4'd0:   o_seg_enb = 6'b111110 ;
               4'd1:   o_seg_enb = 6'b111101 ;
               4'd2:   o_seg_enb = 6'b111011 ;
               4'd3:   o_seg_enb = 6'b110111 ;
               4'd4:   o_seg_enb = 6'b101111 ;
               4'd5:   o_seg_enb = 6'b011111 ;
               default:o_seg_enb = 6'b111111 ;
            endcase
         end
end



reg      o_seg_dp ;
always @(cnt_common_node) begin
   case (cnt_common_node)
      4'd0:   o_seg_dp = i_mode[0] ;
      4'd1:   o_seg_dp = i_mode[1] ;
      4'd2:   o_seg_dp = i_mode[2] ;
      4'd3:   o_seg_dp = i_mode[3] ;
      4'd4:   o_seg_dp = i_mode[4] ;
      4'd5:   o_seg_dp = i_mode[5] ;
      default:o_seg_dp = 1'b0;
   endcase
/*
   if ((i_mode == 2'd1) || (i_mode == 2'd2)) begin
      if (cnt_common_node == (2*i_position))
         o_seg_dp = 1'b1;
      else
         o_seg_dp = 1'b0;
   end
   else begin
      if ((cnt_common_node %2) ==0)
         o_seg_dp = 1'b1;
      else
         o_seg_dp = 1'b0;
   end
*/

end

reg   [6:0]   o_seg ;

always @(cnt_common_node) begin
   case (cnt_common_node)
      4'd0:   o_seg = i_six_digit_seg[6:0] ;
      4'd1:   o_seg = i_six_digit_seg[13:7] ;
      4'd2:   o_seg = i_six_digit_seg[20:14];
      4'd3:   o_seg = i_six_digit_seg[27:21] ;
      4'd4:   o_seg = i_six_digit_seg[34:28] ;
      4'd5:   o_seg = i_six_digit_seg[41:35] ;
      default:o_seg = 7'b111_1110; // 0 display
   endcase
end


endmodule

//   --------------------------------------------------
//   HMS(Hour:Min:Sec) CountDown
/*
1. start/stop
2. reset
3. alarm on/off
4. 00:00:00

*/
//   --------------------------------------------------
module	hms_cntdw(
			o_hms_cnt,
			o_max_hit,
			o_circle_en,
			i_countdowner_en,
			i_circle_en,
			i_max_cnt,
			i_countdowner_reset,
			clk,
			rst_n);

output	[5:0]		o_hms_cnt;
output			o_max_hit;
output			o_circle_en;

input			i_countdowner_en;
input			i_circle_en;
input	[5:0]		i_max_cnt;
input			i_countdowner_reset;
input			clk;
input			rst_n;

reg	[5:0]		o_hms_cnt;
reg			o_max_hit;
reg			o_circle_en;

always @(posedge clk or negedge i_countdowner_reset) begin
	if(i_countdowner_reset == 1'b0) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b0;
		o_circle_en <= 1'b0;
	end else begin
	//cntdw -ing
		if((i_countdowner_en == 1'b1) && (i_circle_en == 1'b0)) begin
			if(o_hms_cnt <= 6'd1) begin
         			o_hms_cnt <= 6'd0;
				o_circle_en <= 1'b0;
				o_max_hit <= 1'b0;
		
			end else begin
				o_hms_cnt <= o_hms_cnt - 1'b1;
				o_circle_en <= 1'b1;
				o_max_hit <= 1'b0;
			end
		end 
		if((i_countdowner_en == 1'b1) && (i_circle_en == 1'b1)) begin
			if(o_hms_cnt <= 6'd0) begin
         			o_hms_cnt <= i_max_cnt;
				o_circle_en <= 1'b1;
				o_max_hit <= 1'b1;
		
			end else begin
				o_hms_cnt <= o_hms_cnt - 1'b1;
				o_circle_en <= 1'b1;
				o_max_hit <= 1'b0;
			end
		end 
		if((i_countdowner_en == 1'b0) && (i_circle_en == 1'b0)) begin
			if(o_hms_cnt <= 6'd0) begin
         			o_hms_cnt <= i_max_cnt;
				o_circle_en <= 1'b1;
				o_max_hit <= 1'b0;
		
			end else begin
				o_hms_cnt <= o_hms_cnt - 1'b1;
				o_circle_en <= 1'b1;
				o_max_hit <= 1'b0;
			end
		end 
		if((i_countdowner_en == 1'b0) && (i_circle_en == 1'b1)) begin
			if(o_hms_cnt <= 6'd0) begin
         			o_hms_cnt <= i_max_cnt;
				o_circle_en <= 1'b1;
				o_max_hit <= 1'b0;
		
			end else begin
				o_hms_cnt <= o_hms_cnt - 1'b1;
				o_circle_en <= 1'b1;
				o_max_hit <= 1'b0;
			end
		end 
	end
end
endmodule

//   --------------------------------------------------
//   HMS(Hour:Min:Sec) Counter
//   --------------------------------------------------
module   hms_cnt(
                 o_hms_cnt,
                 o_max_hit,
                 i_max_cnt,
                 clk,
                 rst_n);

output   [6:0]   o_hms_cnt ;
output           o_max_hit ;

input    [6:0]   i_max_cnt ;
input            clk ;
input            rst_n ;


reg      [6:0]   o_hms_cnt ;
reg              o_max_hit ;
always @(posedge clk or negedge  rst_n) begin
   if( rst_n == 1'b0) begin
      o_hms_cnt <= 7'd0 ;
      o_max_hit <= 1'b0 ;
   end else begin
      if(o_hms_cnt >= i_max_cnt) begin
         o_hms_cnt <= 7'd0 ;
         o_max_hit <= 1'b1 ;
      end else begin
         o_hms_cnt <= o_hms_cnt + 1'b1 ;
         o_max_hit <= 1'b0 ;
      end
   end
end

endmodule
//   --------------------------------------------------
//   HMS(Hour:Min:Sec) Stopwatch
//   --------------------------------------------------
module   hms_stopwatch(
                       o_hms_cnt,
                       o_max_hit,
                       i_max_cnt,
                       i_stopwatch_rst_n,
                       clk,
                       rst_n);

output   [6:0]   o_hms_cnt ;
output           o_max_hit ;

input    [6:0]   i_max_cnt ;
input            i_stopwatch_rst_n ;
input            clk ;
input            rst_n ;


reg      [6:0]   o_hms_cnt ;
reg              o_max_hit ;

always @(posedge clk or negedge i_stopwatch_rst_n) begin
   if( i_stopwatch_rst_n == 1'b0) begin
      o_hms_cnt <= 7'd0 ;
      o_max_hit <= 1'b0 ;
   end else begin
      if(o_hms_cnt >= i_max_cnt) begin
         o_hms_cnt <= 7'd0 ;
         o_max_hit <= 1'b1 ;
      end else begin
         o_hms_cnt <= o_hms_cnt + 1'b1 ;
         o_max_hit <= 1'b0 ;
      end
   end
end

endmodule


module  debounce(
		o_sw,
		i_sw,
		clk);
output		o_sw			;

input		i_sw			;
input		clk			;

reg		dly1_sw			;
always @(posedge clk) begin
	dly1_sw <= i_sw;
end

reg		dly2_sw			;
always @(posedge clk) begin
	dly2_sw <= dly1_sw;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule



module	sw_reset_n(   
		o_sw_reset_n,
		sw);     
                     
output		o_sw_reset_n	;

input		sw		;

assign o_sw_reset_n = sw ;

endmodule





//   --------------------------------------------------
//   Clock Controller
//   --------------------------------------------------
module   controller(
                    o_mode,
                    o_position,
                    o_sec_clk,
                    o_min_clk,
                    o_hour_clk,
                    o_alarm_en,
                    o_alarm_sec_clk,
                    o_alarm_min_clk,
                    o_alarm_hour_clk,
                    o_alarm_rst_n,
                    o_countdowner_en,
                    o_countdowner_alarm_en,
                    o_countdowner_reset,
                    o_countdowner_sec_clk,
                    o_countdowner_min_clk,
                    o_countdowner_hour_clk,
                    o_stopwatch_rst_n,
                    o_stopwatch_fast_sec_clk,
                    o_stopwatch_sec_clk,
                    o_stopwatch_min_clk,
                    i_max_hit_sec,
                    i_max_hit_min,
                    i_max_hit_hour,                         
                    i_max_hit_countdowner_sec,
                    i_max_hit_countdowner_min,
                    i_max_hit_countdowner_hour,
                    i_cntdw_00_stop,
                    i_max_hit_stopwatch_fast_sec,
                    i_max_hit_stopwatch_sec,
                    i_max_hit_stopwatch_min,
                    i_sw0,
                    i_sw1,
                    i_sw2,
                    i_sw3,
                    i_sw4,
                    i_sw5,
                    i_sw6,
                    i_sw7,
                    i_sw9,
                    i_sw10,                 
                    clk,
                    rst_n);

output   [2:0]   o_mode ;
output   [1:0]   o_position ;

output           o_sec_clk ;
output           o_min_clk ;
output           o_hour_clk ;

output           o_alarm_en ;
output           o_alarm_sec_clk ;
output           o_alarm_min_clk  ;
output           o_alarm_hour_clk ;
output           o_alarm_rst_n ;

output           o_countdowner_en ;
output           o_countdowner_alarm_en ;
output           o_countdowner_reset ;
output           o_countdowner_sec_clk ;
output           o_countdowner_min_clk ;
output           o_countdowner_hour_clk ;

output           o_stopwatch_rst_n ;
output           o_stopwatch_fast_sec_clk ;
output           o_stopwatch_sec_clk ;
output           o_stopwatch_min_clk ;

input            i_max_hit_sec ;
input            i_max_hit_min ;
input            i_max_hit_hour ;

input            i_max_hit_countdowner_sec ;
input            i_max_hit_countdowner_min ;
input            i_max_hit_countdowner_hour ;
input            i_cntdw_00_stop ;

input            i_max_hit_stopwatch_fast_sec ;
input            i_max_hit_stopwatch_sec ;
input            i_max_hit_stopwatch_min ;

input            i_sw0 ;
input            i_sw1 ;
input            i_sw2 ;
input            i_sw3 ;
input            i_sw4 ;
input            i_sw5 ;
input            i_sw6 ;
input            i_sw7 ;
input            i_sw9 ;
input            i_sw10  ;

input            clk   ;
input            rst_n  ;

parameter   MODE_CLOCK   =  3'b000 ;
parameter   MODE_SETUP   =  3'b001 ;
parameter   MODE_ALARM   =  3'b010 ;
parameter   MODE_COUNTDOWN   =  3'b011 ;
parameter   MODE_STOPWATCH   =  3'b100 ;
parameter   MODE_WORLD_CHINA   =  3'b101 ;
parameter   MODE_WORLD_ENGLAND   =  3'b110 ;

parameter   TIME_GAP_CHINA  =  5'd01 ;
parameter   TIME_GAP_ENGLAND  =  5'd9 ;

parameter   POS_SEC   =  2'b00 ;
parameter   POS_MIN   =  2'b01 ;
parameter   POS_HOUR  =  2'b10 ;

wire            clk_100hz ;

nco      u0_nco(
                .o_gen_clk      ( clk_100hz  ),
                .i_nco_num      ( 32'd500000 ),
                .clk            ( clk        ),
                .rst_n          ( rst_n      ));

wire            sw0 ;

debounce   u0_debounce(
                       .o_sw      ( sw0       ),
                       .i_sw      ( i_sw0     ),
                       .clk       ( clk_100hz ));

wire            sw1 ;

debounce   u1_debounce(
                      .o_sw       ( sw1       ),
                      .i_sw       ( i_sw1     ),
                      .clk        ( clk_100hz ));

wire            sw2 ;

debounce   u2_debounce(
                       .o_sw      ( sw2       ),
                       .i_sw      ( i_sw2     ),
                        .clk      ( clk_100hz ));
 
wire             sw3 ;

debounce   u3_debounce(
                       .o_sw      ( sw3       ),
                       .i_sw      ( i_sw3     ),
                       .clk       ( clk_100hz ));

wire             sw4 ;

debounce   u4_debounce(
                      .o_sw       ( sw4       ),
                      .i_sw       ( i_sw4     ),
                       .clk       ( clk_100hz ));

wire             sw5 ;

debounce   u5_debounce(
                      .o_sw       ( sw5       ),
                      .i_sw       ( i_sw5     ),
                       .clk       ( clk_100hz ));

wire             sw6 ;

debounce   u6_debounce(
                       .o_sw      ( sw6       ),
                       .i_sw      ( i_sw6     ),
                       .clk       ( clk_100hz ));

wire             sw7 ;

debounce   u7_debounce(
                       .o_sw      ( sw7       ),
                       .i_sw      ( i_sw7     ),
                       .clk       ( clk_100hz ));

wire             sw9 ;

debounce   u8_debounce(
                       .o_sw      ( sw9       ),
                       .i_sw      ( i_sw9     ),
                       .clk       ( clk_100hz ));    
      
wire             sw10 ;

debounce   u9_debounce(
                       .o_sw      ( sw10      ),
                       .i_sw      ( i_sw10    ),
                       .clk       ( clk_100hz ));   

reg     [2:0]    o_mode ;

always @(posedge sw0 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_mode <= MODE_CLOCK ;
   end else begin
      if(o_mode >= MODE_WORLD_ENGLAND) begin
         o_mode <= MODE_CLOCK ;
      end else begin
         o_mode <= o_mode + 1'b1 ;
      end
   end   
end


/*----------------------position reset
----------------------------------------*/
wire           i_position_rst_n ;

sw_reset_n   u_position_reset_n(
                                .o_sw_reset_n( i_position_rst_n ),
                                .sw          ( sw0              ));

reg    [1:0]   o_position ;
reg            position_reset ;

always @(posedge sw1 or negedge i_position_rst_n) begin
   if(i_position_rst_n == 1'b0) begin
      o_position <= POS_SEC ;
   end else begin
      if(o_position >= POS_HOUR) begin
         o_position  <= POS_SEC ;
      end else begin
         o_position <= (o_position + 1'b1) ;
      end
   end
end

reg            o_countdowner_en ;

always @(posedge sw4 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_countdowner_en <= 1'b0 ;
   end else begin
      o_countdowner_en <= o_countdowner_en + 1'b1 ;
   end
end
/*
reg	o_countdowner_en	;

always @(i_cntdw_00_stop) begin
   if(i_cntdw_00_stop == 1'b0) begin
      o_countdowner_en = 1'b0 ;
   end else begin
      o_countdowner_en = countdowner_en ;
   end
end
*/

//assign o_countdowner_en = countdowner_en   ;
//assign o_countdowner_en = countdowner_en | ~i_cntdw_00_stop;


wire         o_countdowner_reset ;

sw_reset_n   u_countdowner_reset_n(
                                   .o_sw_reset_n      ( o_countdowner_reset ),
                                   .sw                ( sw6                 ));

wire         o_stopwatch_rst_n ;

sw_reset_n   u_stopwatch_rst_n(
                               .o_sw_reset_n         (o_stopwatch_rst_n ),
                               .sw                   (sw10              ));

   
wire         o_alarm_rst_n ;

sw_reset_n   u_alarm_rst_n(
                           .o_sw_reset_n        ( o_alarm_rst_n ),
                           .sw                  ( sw5            ));
 
reg          o_countdowner_alarm_en ;

always @(posedge sw7 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_countdowner_alarm_en <= 1'b0 ;
   end else begin
      o_countdowner_alarm_en <= o_countdowner_alarm_en + 1'b1 ;
   end
end

reg          o_alarm_en ;

always @(posedge sw3 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_alarm_en <= 1'b0 ;
   end else begin
      o_alarm_en <= o_alarm_en + 1'b1 ;
   end
end

reg          stopwatch_en ;

always @(posedge sw9 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      stopwatch_en <= 1'b0 ;
   end else begin
      stopwatch_en <= stopwatch_en + 1'b1 ;
   end
end

wire         clk_1hz ;

nco      u1_nco(
                .o_gen_clk   ( clk_1hz        ),
                .i_nco_num   ( 32'd50000000   ),
                .clk         ( clk            ),
                .rst_n       ( rst_n          ));
      
nco      u_nco_stopwatch(
                         .o_gen_clk   ( clk_100hz_stopwatch   ),
                         .i_nco_num   ( 32'd500000            ),
                         .clk         ( clk                   ),
                         .rst_n       ( rst_n                 ));
      

reg         o_sec_clk ;
reg         o_min_clk ;
reg         o_hour_clk ;
reg         o_alarm_sec_clk ;
reg         o_alarm_min_clk ;
reg         o_alarm_hour_clk ;
reg         o_countdowner_sec_clk ;
reg         o_countdowner_min_clk ;
reg         o_countdowner_hour_clk ;
reg         o_stopwatch_fast_sec_clk ;
reg         o_stopwatch_sec_clk ;
reg         o_stopwatch_min_clk ;

always @(*) begin
   case(o_mode)

         MODE_CLOCK : begin
             o_sec_clk = clk_1hz ;
             o_min_clk = i_max_hit_sec ;
             o_hour_clk   = i_max_hit_min ;

             o_alarm_sec_clk = 1'b0 ;
             o_alarm_min_clk = 1'b0 ;
             o_alarm_hour_clk   = 1'b0 ;

             o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
             o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
             o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
             end
      
         MODE_SETUP : begin
            case(o_position)
               POS_SEC : begin
                  o_sec_clk = ~sw2 ;
                  o_min_clk = 1'b0 ;
                  o_hour_clk = 1'b0 ;

                  o_alarm_sec_clk = 1'b0 ;
                  o_alarm_min_clk = 1'b0 ;
                  o_alarm_hour_clk   = 1'b0 ;

                  o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                  end
                  
               POS_MIN : begin
                  o_sec_clk = 1'b0 ;
                  o_min_clk = ~sw2 ;
                  o_hour_clk = 1'b0 ;

                  o_alarm_sec_clk = 1'b0 ;
                  o_alarm_min_clk = 1'b0 ;
                  o_alarm_hour_clk   = 1'b0 ;

                  o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                  end
                  
               POS_HOUR : begin
                  o_sec_clk = 1'b0 ;
                  o_min_clk = 1'b0 ;
                  o_hour_clk = ~sw2 ;

                  o_alarm_sec_clk = 1'b0 ;
                  o_alarm_min_clk = 1'b0 ;
                  o_alarm_hour_clk   = 1'b0 ;

                  o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                  end
            endcase
         end // close MODE_SETUP
         
         MODE_ALARM : begin
            case(o_position)
               POS_SEC : begin
                  o_sec_clk = clk_1hz ;
                  o_min_clk = i_max_hit_sec ;
                  o_hour_clk = i_max_hit_min ;

                  o_alarm_sec_clk = ~sw2 ;
                  o_alarm_min_clk = 1'b0 ;
                  o_alarm_hour_clk   = 1'b0 ;

                  o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                  end
                  
               POS_MIN : begin
                  o_sec_clk = clk_1hz ;
                  o_min_clk = i_max_hit_sec ;
                  o_hour_clk = i_max_hit_min ;

                  o_alarm_sec_clk = 1'b0 ;
                  o_alarm_min_clk = ~sw2 ;
                  o_alarm_hour_clk   = 1'b0 ;

                  o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min );
                  end
                  
               POS_HOUR : begin
                  o_sec_clk = clk_1hz ;
                  o_min_clk = i_max_hit_sec ;
                  o_hour_clk = i_max_hit_min ;

                  o_alarm_sec_clk = 1'b0 ;
                  o_alarm_min_clk = 1'b0 ;
                  o_alarm_hour_clk   = ~sw2 ;

                  o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ; 
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                  end
            endcase
         end //  MODE_ALARM close
         
         MODE_COUNTDOWN : begin
            if (o_countdowner_en == 1'b0) begin
               case(o_position)
                  POS_SEC : begin
                     o_sec_clk = clk_1hz ;
                     o_min_clk = i_max_hit_sec ;
                     o_hour_clk = i_max_hit_min ;

                     o_alarm_sec_clk = 1'b0 ;
                     o_alarm_min_clk = 1'b0 ;
                     o_alarm_hour_clk   = 1'b0 ;

                     o_countdowner_sec_clk = ~sw2 ;
                     o_countdowner_min_clk = 1'b0 ;
                     o_countdowner_hour_clk = 1'b0 ;
                     end
                     
                  POS_MIN : begin
                     o_sec_clk = clk_1hz ;
                     o_min_clk = i_max_hit_sec ;
                     o_hour_clk = i_max_hit_min ;

                     o_alarm_sec_clk = 1'b0 ;
                     o_alarm_min_clk = 1'b0 ;
                     o_alarm_hour_clk   = 1'b0 ; 

                     o_countdowner_sec_clk = 1'b0 ;
                     o_countdowner_min_clk = ~sw2 ;
                     o_countdowner_hour_clk = 1'b0 ;
                     end
                     
                  POS_HOUR : begin
                     o_sec_clk = clk_1hz ;
                     o_min_clk = i_max_hit_sec ;
                     o_hour_clk = i_max_hit_min ;

                     o_alarm_sec_clk = 1'b0 ;
                     o_alarm_min_clk = 1'b0 ;
                     o_alarm_hour_clk   = 1'b0 ;

                     o_countdowner_sec_clk = 1'b0 ;
                     o_countdowner_min_clk = 1'b0 ;
                     o_countdowner_hour_clk = ~sw2 ;
                     end
               default: begin
                     o_sec_clk = 1'b0 ;
                     o_min_clk = 1'b0 ;
                     o_hour_clk = 1'b0 ;

                     o_alarm_sec_clk = 1'b0 ;
                     o_alarm_min_clk = 1'b0 ;                   
                     o_alarm_hour_clk = 1'b0 ;
 
                     o_countdowner_sec_clk = 1'b0 ;
                     o_countdowner_min_clk = 1'b0 ;
                     o_countdowner_hour_clk = 1'b0 ;
                  end 
               endcase   // close case(o_position) 
   
            end else begin //about if
               case(o_position)
                  POS_SEC : begin
                     o_sec_clk = clk_1hz ;
                     o_min_clk = i_max_hit_sec ;
                     o_hour_clk = i_max_hit_min ;

                     o_alarm_sec_clk = 1'b0 ;
                     o_alarm_min_clk = 1'b0 ;
                     o_alarm_hour_clk   = 1'b0 ;

                     o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                     o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                     o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                     end
                     
                  POS_MIN : begin
                     o_sec_clk = clk_1hz ;
                     o_min_clk = i_max_hit_sec ;
                     o_hour_clk = i_max_hit_min ;

                     o_alarm_sec_clk = 1'b0 ;
                     o_alarm_min_clk = 1'b0 ;
                     o_alarm_hour_clk   = 1'b0 ;

                     o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                     o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                     o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                     end
                  POS_HOUR : begin
                     o_sec_clk = clk_1hz ;
                     o_min_clk = i_max_hit_sec ;
                     o_hour_clk = i_max_hit_min ;

                     o_alarm_sec_clk = 1'b0 ;
                     o_alarm_min_clk = 1'b0 ;
                     o_alarm_hour_clk   = 1'b0 ;

                     o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
                     o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
                     o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
                     end
               endcase
            end
         end   // close MODE_COUNTDOWN
         
         MODE_STOPWATCH : begin
         if(stopwatch_en == 1'b1) begin
         
            o_sec_clk = clk_1hz ;
            o_min_clk = i_max_hit_sec ;
            o_hour_clk   = i_max_hit_min ;

            o_alarm_sec_clk = 1'b0 ; 
            o_alarm_min_clk = 1'b0 ;
            o_alarm_hour_clk   = 1'b0 ;

            o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
            o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
            o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
            
            o_stopwatch_fast_sec_clk  =  clk_100hz_stopwatch ;
            o_stopwatch_sec_clk  =  i_max_hit_stopwatch_fast_sec ;
            o_stopwatch_min_clk  = i_max_hit_stopwatch_sec ; 
            
         end else begin
            o_sec_clk = clk_1hz ;
            o_min_clk = i_max_hit_sec ;
            o_hour_clk   = i_max_hit_min ;

            o_alarm_sec_clk = 1'b0 ;
            o_alarm_min_clk = 1'b0 ;
            o_alarm_hour_clk   = 1'b0 ;

            o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
            o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
            o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;
            
            o_stopwatch_fast_sec_clk =  1'b0 ;
            o_stopwatch_sec_clk  =  1'b0 ;
            o_stopwatch_min_clk  =  1'b0 ;
         end
         
         
         
         /*
         //
               case(o_position )
                  
                  POS_MIN :begin
                  o_stopwatch_fast_sec_clk       =    clk_100hz_stopwatch;
                  o_stopwatch_sec_clk       =    i_max_hit_stopwatch_fast_sec;
                  o_stopwatch_min_clk      =    i_max_hit_stopwatch_sec;
                  
                  o_alarm_sec_clk    = 1'b0;
                  o_alarm_min_clk    = 1'b0;
                  o_alarm_hour_clk  = 1'b0;

                  o_countdowner_sec_clk= (o_countdowner_en&clk_1hz);
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec );
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min );
                  end
               
                  POS_HOUR : begin
                  o_stopwatch_fast_sec_clk    =    1'b0;
                  o_stopwatch_sec_clk          =    1'b0;
                  o_stopwatch_min_clk         =    1'b0;
                  
                  o_alarm_sec_clk    = 1'b0;
                  o_alarm_min_clk    = 1'b0;
                  o_alarm_hour_clk  = 1'b0;
                  
                  o_countdowner_sec_clk= (o_countdowner_en&clk_1hz);
                  o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec );
                  o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min );
                  end 
                  */
                  
            end// close MODE_STOPWATCH
         MODE_WORLD_CHINA : begin
            o_sec_clk = clk_1hz ;
            o_min_clk = i_max_hit_sec ;
            o_hour_clk   = i_max_hit_min ;

            o_alarm_sec_clk = 1'b0 ;
            o_alarm_min_clk = 1'b0 ;
            o_alarm_hour_clk  = 1'b0 ;

            o_countdowner_sec_clk = (o_countdowner_en&clk_1hz) ;
            o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec ) ;
            o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min ) ;

            o_stopwatch_fast_sec_clk  = 1'b0 ;
            o_stopwatch_sec_clk  = 1'b0 ;
            o_stopwatch_min_clk  = 1'b0 ;

            end
         MODE_WORLD_ENGLAND : begin
            o_sec_clk = clk_1hz; 
            o_min_clk = i_max_hit_sec ; 
            o_hour_clk  = i_max_hit_min ;          
            
            o_alarm_sec_clk = 1'b0 ;
            o_alarm_min_clk = 1'b0 ;
            o_alarm_hour_clk   = 1'b0 ;

            o_countdowner_sec_clk = (o_countdowner_en&clk_1hz);
            o_countdowner_min_clk = (o_countdowner_en & i_max_hit_countdowner_sec );
            o_countdowner_hour_clk = (o_countdowner_en & i_max_hit_countdowner_min );

            o_stopwatch_fast_sec_clk = 1'b0 ;
            o_stopwatch_sec_clk  = 1'b0 ;
            o_stopwatch_min_clk  = 1'b0 ; 

            end
      default: begin //about case o_mode
         o_sec_clk = 1'b0 ;
         o_min_clk = 1'b0 ;
         o_hour_clk = 1'b0 ;

             o_alarm_sec_clk = 1'b0 ;
         o_alarm_min_clk = 1'b0 ;
         o_alarm_hour_clk = 1'b0 ;

         o_countdowner_sec_clk = 1'b0 ; 
         o_countdowner_min_clk = 1'b0 ;
         o_countdowner_hour_clk = 1'b0 ;

         o_stopwatch_fast_sec_clk  = 1'b0 ;
         o_stopwatch_sec_clk   = 1'b0 ;
         o_stopwatch_min_clk   = 1'b0 ;
         end
   endcase //close case o_mode
 end //close always
endmodule

//   --------------------------------------------------
//   HMS(Hour:Min:Sec) Counter
//   --------------------------------------------------
module   hourminsec(
                    o_sec,
                    o_min,
                    o_hour,
                    o_max_hit_sec,
                    o_max_hit_min,
                    o_max_hit_hour,
                    o_alarm,
                    o_max_hit_countdowner_sec,
                    o_max_hit_countdowner_min,
                    o_max_hit_countdowner_hour,
                    o_countdowner_buzz_en   ,
                    o_cntdw_00_stop,
                    o_max_hit_stopwatch_fast_sec,
                    o_max_hit_stopwatch_sec,
                    o_max_hit_stopwatch_min,
                    i_mode,
                    i_position,
                    i_sec_clk,
                    i_min_clk,
                    i_hour_clk,
                    i_alarm_sec_clk,
                    i_alarm_min_clk,
                    i_alarm_hour_clk,      
                    i_alarm_rst_n,
                    i_countdowner_en   ,
                    i_countdowner_alarm_en   ,
                    i_countdowner_reset,
                    i_countdowner_sec_clk,
                    i_countdowner_min_clk,
                    i_countdowner_hour_clk,
                    i_stopwatch_fast_sec_clk,
                    i_stopwatch_sec_clk ,
                    i_stopwatch_min_clk,
                    i_stopwatch_rst_n,
                    i_alarm_en,
                    clk,
                    rst_n);

output   [6:0]   o_sec      ;
output   [6:0]   o_min      ;
output   [6:0]   o_hour ;
output           o_max_hit_sec   ;
output           o_max_hit_min   ;
output           o_max_hit_hour   ;
output           o_alarm      ;
  
output           o_cntdw_00_stop   ;

output           o_max_hit_countdowner_sec   ;
output           o_max_hit_countdowner_min   ;
output           o_max_hit_countdowner_hour   ;
output           o_countdowner_buzz_en      ;
output           o_max_hit_stopwatch_fast_sec         ;
output           o_max_hit_stopwatch_sec         ;
output           o_max_hit_stopwatch_min      ;


input    [2:0]   i_mode ;
input    [1:0]   i_position ;
input            i_sec_clk ;
input            i_min_clk ;
input            i_hour_clk ;

input            i_alarm_rst_n ;
input            i_alarm_sec_clk ;
input            i_alarm_min_clk ;
input            i_alarm_hour_clk ;

input            i_countdowner_en ;
input            i_countdowner_alarm_en ;
input            i_countdowner_reset ;
input            i_countdowner_sec_clk ;
input            i_countdowner_min_clk ;
input            i_countdowner_hour_clk ;

input            i_stopwatch_fast_sec_clk ;
input            i_stopwatch_sec_clk ;
input            i_stopwatch_min_clk ;
input            i_stopwatch_rst_n ;

input            i_alarm_en ;
input            clk ;
input            rst_n ;

parameter   MODE_CLOCK   = 3'b000 ;
parameter   MODE_SETUP   = 3'b001 ;
parameter   MODE_ALARM   = 3'b010 ;
parameter   MODE_COUNTDOWN = 3'b011 ;
parameter   MODE_STOPWATCH  = 3'b100 ;
parameter   MODE_WORLD_CHINA  = 3'b101 ;
parameter   MODE_WORLD_ENGLAND  = 3'b110 ;

parameter   TIME_GAP_CHINA  = 5'd01 ;
parameter   TIME_GAP_ENGLAND  = 5'd9 ;

parameter   POS_SEC  = 2'b00 ;
parameter   POS_MIN  = 2'b01 ;
parameter   POS_HOUR = 2'b10 ;

//   MODE_CLOCK
wire   [6:0]   sec ;
wire           o_max_hit_sec ;

hms_cnt      u_hms_cnt_sec(
                           .o_hms_cnt      ( sec           ),
                           .o_max_hit      ( o_max_hit_sec ),
                           .i_max_cnt      ( 6'd59         ),
                           .clk            ( i_sec_clk     ),
                           .rst_n          ( rst_n         ));

wire   [6:0]   min ;
wire           o_max_hit_min ;
hms_cnt      u_hms_cnt_min(
                           .o_hms_cnt      ( min           ),
                           .o_max_hit      ( o_max_hit_min ),
                           .i_max_cnt      ( 6'd59         ),
                           .clk            ( i_min_clk     ),
                           .rst_n          ( rst_n         ));

wire   [6:0]   hour ;
wire           o_max_hit_hour ;

hms_cnt      u_hms_cnt_hour(
                            .o_hms_cnt     ( hour           ),
                            .o_max_hit     ( o_max_hit_hour ),
                            .i_max_cnt     ( 5'd23          ),
                            .clk           ( i_hour_clk     ),
                            .rst_n         ( rst_n          ));      //??? ?????.

//   MODE_ALARM
wire   [6:0]   alarm_sec ;

hms_cnt      u_hms_cnt_alarm_sec(
                                 .o_hms_cnt      ( alarm_sec       ),
                                 .o_max_hit      (                 ),
                                 .i_max_cnt      ( 6'd59           ),
                                 .clk            ( i_alarm_sec_clk ),
                                 .rst_n          ( i_alarm_rst_n   ));

wire   [6:0]   alarm_min ;

hms_cnt      u_hms_cnt_alarm_min(
                                 .o_hms_cnt      ( alarm_min       ),
                                 .o_max_hit      (                 ),
                                 .i_max_cnt      ( 6'd59           ),
                                 .clk            ( i_alarm_min_clk ),
                                 .rst_n          ( i_alarm_rst_n  ));

wire   [6:0]   alarm_hour ;

hms_cnt      u_hms_cnt_alarm_hour(
                                  .o_hms_cnt     ( alarm_hour       ),
                                  .o_max_hit     (                  ),
                                  .i_max_cnt     ( 5'd23            ),
                                  .clk           ( i_alarm_hour_clk ),
                                  .rst_n         ( i_alarm_rst_n    ));

//   MODE_COUNTDOWN

/*---------------------------------------------
----------------------------------------------*/

wire            min_circle_en ;
wire            sec_circle_en ;
wire            cntdw_00_stop ;

wire    [4:0]   countdown_hour ;
wire            o_max_hit_countdown_hour ;
wire    [5:0]   countdown_min ;
wire            o_max_hit_countdowner_min ;
wire    [5:0]   countdown_sec ;
wire            o_max_hit_countdowner_sec ;

//assign countdown_hour = 0;
//assign countdown_min = 0;




hms_cntdw      u_hms_cnt_countdowner_hour(
                                          .o_hms_cnt             ( countdown_hour             ),
                                          .o_max_hit             ( o_max_hit_countdowner_hour ),
                                          .o_circle_en           ( min_circle_en              ),
                                          .i_countdowner_en      ( i_countdowner_en           ),
                                          .i_circle_en           ( 1'b0                       ),
                                          .i_max_cnt             ( 5'd23                      ),
                                          .i_countdowner_reset   ( i_countdowner_reset        ),
                                          .clk                   ( i_countdowner_hour_clk     ),
                                          .rst_n                 ( rst_n                      ));


hms_cntdw      u_hms_cnt_countdown_min(
                                       .o_hms_cnt                ( countdown_min             ),
                                       .o_max_hit                ( o_max_hit_countdowner_min ),
                                       .o_circle_en              ( sec_circle_en             ),
                                       .i_countdowner_en         ( i_countdowner_en          ),
                                       .i_circle_en              ( min_circle_en             ),
                                       .i_max_cnt                ( 6'd59                     ),
                                       .i_countdowner_reset      ( i_countdowner_reset       ),
                                       .clk                      ( i_countdowner_min_clk     ),
                                       .rst_n                    ( rst_n                     ));

  
hms_cntdw      u_hms_cnt_countdown_sec(
                                       .o_hms_cnt                ( countdown_sec             ),
                                       .o_max_hit                ( o_max_hit_countdowner_sec ),
                                       .o_circle_en              ( o_cntdw_00_stop           ),
                                       .i_countdowner_en         ( i_countdowner_en          ),
                                       .i_circle_en              ( sec_circle_en             ),
                                       .i_max_cnt                ( 6'd59                     ),
                                       .i_countdowner_reset      ( i_countdowner_reset       ),
                                       .clk                      ( i_countdowner_sec_clk     ),
                                       .rst_n                    ( rst_n                     ));

//   MODE_STOPWATCH      
wire   [6:0]    stopwatch_fast_sec ;
wire            o_max_hit_stopwatch_fast_sec ;

hms_stopwatch     u_hms_cnt_stopwatch_fast_sec(
                                               .o_hms_cnt             ( stopwatch_fast_sec           ),
                                               .o_max_hit             ( o_max_hit_stopwatch_fast_sec ),
                                               .i_max_cnt             ( 7'd99                        ),
                                               .clk                   ( i_stopwatch_fast_sec_clk     ),
                                               .rst_n                 ( rst_n                        ),
                                               .i_stopwatch_rst_n     ( i_stopwatch_rst_n            ));

wire   [6:0]   stopwatch_sec ;
wire           o_max_hit_stopwatch_sec ;

hms_stopwatch      u_hms_cnt_stopwatch_sec(
                                           .o_hms_cnt              ( stopwatch_sec           ),
                                           .o_max_hit              ( o_max_hit_stopwatch_sec ),
                                           .i_max_cnt              ( 6'd59                   ),
                                           .clk                    ( i_stopwatch_sec_clk     ),
                                           .rst_n                  ( rst_n                   ),
                                           .i_stopwatch_rst_n      ( i_stopwatch_rst_n       ));
      
wire   [6:0]    stopwatch_min ;
wire            o_max_hit_stopwatch_min ;

hms_stopwatch      u_hms_cnt_stopwatch_min(
                                           .o_hms_cnt              ( stopwatch_min           ),
                                           .o_max_hit              ( o_max_hit_stopwatch_min ),
                                           .i_max_cnt              ( 6'd59                   ),
                                           .clk                    ( i_stopwatch_min_clk     ),
                                           .rst_n                  ( rst_n                   ),
                                           .i_stopwatch_rst_n      ( i_stopwatch_rst_n       ));            
  

reg   [6:0]     o_sec ;
reg   [6:0]     o_min ;
reg   [6:0]     o_hour ;


always @ (*) begin
   case(i_mode)
      MODE_CLOCK:    begin
         o_sec  = sec ;
         o_min  = min ;
         o_hour = hour ;
      end
      MODE_SETUP:   begin
         o_sec   = sec ;
         o_min   = min ;
         o_hour  = hour ;
      end
      MODE_ALARM:   begin
         o_sec   = alarm_sec ;
         o_min   = alarm_min ;
         o_hour  = alarm_hour ;
      end
      MODE_COUNTDOWN:   begin
         o_sec   = countdown_sec ;
         o_min   = countdown_min ;
         o_hour  = countdown_hour ;
      end
      MODE_STOPWATCH: begin
         o_sec    =    stopwatch_fast_sec ;
         o_min    =    stopwatch_sec ;
         o_hour   =    stopwatch_min ;
      end 
      MODE_WORLD_CHINA: begin
         o_sec    =    sec ; 
         o_min    =    min ;
         o_hour   =    ((hour+TIME_GAP_CHINA+24)%24) ;
      end   
      MODE_WORLD_ENGLAND: begin
         o_sec    =    sec ;
         o_min    =    min ;
         o_hour   =    ((hour+TIME_GAP_ENGLAND+24)%24) ;
      end   
   endcase
end

reg        o_alarm ;
always @ (posedge clk or negedge rst_n) begin
   if (rst_n == 1'b0) begin
      o_alarm <= 1'b0; 
   end else begin
      if( (sec == alarm_sec) && (min == alarm_min) && (hour == alarm_hour)) begin
         o_alarm <= 1'b1 & i_alarm_en ;
      end else begin
         o_alarm <= o_alarm & i_alarm_en ;
      end
   end
end


reg	o_countdowner_buzz_en	;

always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_countdowner_buzz_en  <= 1'b0 ;
	end else begin
		if(i_countdowner_en ==1'b1) begin
			if( (countdown_sec == 0) && (countdown_min == 0) && (countdown_hour == 0)) begin
				o_countdowner_buzz_en  <= 1'b1 & i_countdowner_alarm_en ;
			end else begin
				o_countdowner_buzz_en  <= o_countdowner_buzz_en & i_countdowner_alarm_en ;
			end
		end else begin
			o_countdowner_buzz_en  <= o_countdowner_buzz_en & i_countdowner_alarm_en ;
		end
	end
end

endmodule

module   buzz_reset_n(  
		o_buzz_rst_n,
		rst_n,
		i_buzz_en);

output		o_buzz_rst_n	;

input		rst_n 		;
input		i_buzz_en 	;

assign		o_buzz_rst_n = rst_n + (~i_buzz_en) ;

endmodule

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



module   top(
             o_seg_enb,
             o_seg_dp,
             o_seg,
             o_alarm,
             i_sw0,
             i_sw1,
             i_sw2,
             i_sw3,
             i_sw4,
             i_sw5,
             i_sw6,
             i_sw7,
             i_sw10,
             i_sw9,
             clk,
             rst_n); 

output   [5:0]   o_seg_enb ;
output           o_seg_dp ;
output   [6:0]   o_seg ;
output           o_alarm ;

input		 i_sw0 ;
input            i_sw1 ;
input            i_sw2 ;
input            i_sw3 ;
input            i_sw4 ;
input            i_sw5 ;
input            i_sw6 ;
input            i_sw7 ;
input            i_sw10 ;
input            i_sw9 ;
input            clk ;
input            rst_n  ;

wire     [2:0]   o_mode ;
wire     [1:0]   o_position ;

wire             o_min_clk ;
wire             o_sec_clk ;
wire             o_hour_clk ;

wire             o_max_hit_sec ;
wire             o_max_hit_min ;
wire             o_max_hit_hour ;

wire             o_alarm_en ;
wire             o_alarm_min_clk ;
wire             o_alarm_sec_clk ;
wire             o_alarm_hour_clk ;

wire             o_countdowner_sec_clk ;
wire             o_countdowner_min_clk ;
wire             o_countdowner_hour_clk ; 

wire             o_max_hit_countdowner_sec ;
wire             o_max_hit_countdowner_min ;
wire             o_max_hit_countdowner_hour ;

wire             o_countdowner_en ;
wire             o_countdowner_alarm_en; 
wire             o_countdowner_reset ;
wire             o_cntdw_00_stop ;

wire             o_stopwatch_rst_n ;
wire             o_alarm_rst_n ;




controller  u_controller(
                         .o_mode                          ( o_mode                       ),
                         .o_position                      ( o_position                   ),
                         .o_sec_clk                       ( o_sec_clk                    ),
                         .o_min_clk                       ( o_min_clk                    ),
                         .o_hour_clk                      ( o_hour_clk                   ), 
                         .o_alarm_en                      ( o_alarm_en                   ),
                         .o_alarm_sec_clk                 ( o_alarm_sec_clk              ),
                         .o_alarm_min_clk                 ( o_alarm_min_clk              ),
                         .o_alarm_hour_clk                ( o_alarm_hour_clk             ),
                         .o_alarm_rst_n                   ( o_alarm_rst_n                ),
                         .o_countdowner_sec_clk           ( o_countdowner_sec_clk        ),
                         .o_countdowner_min_clk           ( o_countdowner_min_clk        ),
                         .o_countdowner_hour_clk          ( o_countdowner_hour_clk       ),
                         .o_countdowner_en                ( o_countdowner_en             ),
                         .o_countdowner_alarm_en          ( o_countdowner_alarm_en       ),
                         .o_countdowner_reset             ( o_countdowner_reset          ),
                         .o_stopwatch_rst_n               ( o_stopwatch_rst_n            ),
                         .o_stopwatch_fast_sec_clk        ( o_stopwatch_fast_sec_clk     ),
                         .o_stopwatch_sec_clk             ( o_stopwatch_sec_clk          ),
                         .o_stopwatch_min_clk             ( o_stopwatch_min_clk          ),
                         .i_max_hit_sec                   ( o_max_hit_sec                ),
                         .i_max_hit_min                   ( o_max_hit_min                ),
                         .i_max_hit_hour                  ( o_max_hit_hour               ),
                         .i_max_hit_countdowner_sec       ( o_max_hit_countdowner_sec    ),
                         .i_max_hit_countdowner_min       ( o_max_hit_countdowner_min    ),
                         .i_max_hit_countdowner_hour      ( o_max_hit_countdowner_hour   ),  
                         .i_cntdw_00_stop                 ( o_cntdw_00_stop              ),
                         .i_max_hit_stopwatch_fast_sec    ( o_max_hit_stopwatch_fast_sec ),
                         .i_max_hit_stopwatch_sec         ( o_max_hit_stopwatch_sec      ),
                         .i_max_hit_stopwatch_min         ( o_max_hit_stopwatch_min      ),
                         .i_sw0                           ( i_sw0                        ),
                         .i_sw1                           ( i_sw1                        ),
                         .i_sw2                           ( i_sw2                        ),
                         .i_sw3                           ( i_sw3                        ),
                         .i_sw4                           ( i_sw4                        ),
                         .i_sw5                           ( i_sw5                        ),
                         .i_sw6                           ( i_sw6                        ),
                         .i_sw7                           ( i_sw7                        ),
                         .i_sw9                           ( i_sw9                        ),
                         .i_sw10                          ( i_sw10                       ),
                         .clk                             ( clk                          ),
                         .rst_n                           ( rst_n                        ));




wire   [6:0]  o_min ;
wire   [6:0]  o_sec ;
wire   [6:0]  o_hour ;

wire          o_alarm_sinho ;
wire          o_countdowner_buzz_en ;



wire   [6:0]  o_stopwatch_fast_sec ;  
wire   [6:0]  o_stopwatch_sec ; 
wire   [6:0]  o_stopwatch_min ;            


hourminsec    u_hourminsec(
                           .o_min                             ( o_min                        ),
                           .o_sec                             ( o_sec                        ),
                           .o_hour                            ( o_hour                       ),
                           .o_max_hit_min                     ( o_max_hit_min                ),
                           .o_max_hit_sec                     ( o_max_hit_sec                ),
                           .o_max_hit_hour                    ( o_max_hit_hour               ),
                           .o_alarm                           ( o_alarm_sinho                ),
                           .o_max_hit_countdowner_sec         ( o_max_hit_countdowner_sec    ),
                           .o_max_hit_countdowner_min         ( o_max_hit_countdowner_min    ),
                           .o_max_hit_countdowner_hour        ( o_max_hit_countdowner_hour   ),
                           .o_countdowner_buzz_en             ( o_countdowner_buzz_en        ),
                           .o_cntdw_00_stop                   ( o_cntdw_00_stop              ),
                           .o_max_hit_stopwatch_fast_sec      ( o_max_hit_stopwatch_fast_sec ),
                           .o_max_hit_stopwatch_sec           ( o_max_hit_stopwatch_sec      ),
                           .o_max_hit_stopwatch_min           ( o_max_hit_stopwatch_min      ),
                           .i_mode                            ( o_mode                       ),
                           .i_position                        ( o_position                   ),
                           .i_min_clk                         ( o_min_clk                    ),
                           .i_sec_clk                         ( o_sec_clk                    ),
                           .i_hour_clk                        ( o_hour_clk                   ),
                           .i_alarm_en                        ( o_alarm_en                   ),
                           .i_alarm_min_clk                   ( o_alarm_min_clk              ),
                           .i_alarm_sec_clk                   ( o_alarm_sec_clk              ),
                           .i_alarm_hour_clk                  ( o_alarm_hour_clk             ),
                           .i_alarm_rst_n                     ( o_alarm_rst_n                ),
                           .i_countdowner_en                  ( o_countdowner_en             ),
                           .i_countdowner_alarm_en            ( o_countdowner_alarm_en       ),
                           .i_countdowner_reset               ( o_countdowner_reset          ),                 
                           .i_countdowner_sec_clk             ( o_countdowner_sec_clk        ),
                           .i_countdowner_min_clk             ( o_countdowner_min_clk        ),
                           .i_countdowner_hour_clk            ( o_countdowner_hour_clk       ),
                           .i_stopwatch_rst_n                 ( o_stopwatch_rst_n            ),
                           .i_stopwatch_fast_sec_clk          ( o_stopwatch_fast_sec_clk     ),
                           .i_stopwatch_sec_clk               ( o_stopwatch_sec_clk          ),
                           .i_stopwatch_min_clk               ( o_stopwatch_min_clk          ),
                           .clk                               ( clk                          ),
                           .rst_n                             ( rst_n                        ));
                      

wire   [3:0]  o_left0 ;
wire   [3:0]  o_right0 ;

double_fig_sep u0_dfs (
                        .o_left         ( o_left0    ),
                        .o_right        ( o_right0   ),
                        .i_double_fig   ( o_sec      ));

wire   [3:0]  o_left1 ;
wire   [3:0]  o_right1 ;

double_fig_sep u1_dfs (
                        .o_left         ( o_left1    ),
                        .o_right        ( o_right1   ),
                        .i_double_fig   ( o_min      ));

//?????////////////////////////////////////////////////////////

wire   [3:0]  o_left2 ;
wire   [3:0]  o_right2 ;

double_fig_sep u2_dfs (
                        .o_left         ( o_left2   ),
                        .o_right        ( o_right2  ),
                        .i_double_fig   ( o_hour    ));

///////////////////////////////////////////////////////////////////


wire   [6:0]  o_seg0 ;

fnd_dec u0_fnd_dec (
                    .o_seg      ( o_seg0  ),
                    .i_num      ( o_left0 ));

wire   [6:0]  o_seg1 ;

fnd_dec u1_fnd_dec (
                    .o_seg      ( o_seg1   ),
                    .i_num      ( o_right0 ));

wire   [6:0]  o_seg2 ;

fnd_dec u2_fnd_dec (
                    .o_seg      ( o_seg2  ),
                    .i_num      ( o_left1 ));

wire   [6:0]  o_seg3 ;

fnd_dec u3_fnd_dec (
                    .o_seg      ( o_seg3   ),
                    .i_num      ( o_right1 ));

wire   [6:0]  o_seg4 ;

fnd_dec u4_fnd_dec (
                    .o_seg      ( o_seg4  ),
                    .i_num      ( o_left2 ));

wire   [6:0]  o_seg5 ;

fnd_dec u5_fnd_dec (
                    .o_seg      ( o_seg5  ),
                    .i_num      ( o_right2 ));

//////////////////////////////////////////////////////////////////


wire   [6:0]   o_seg           ;
wire           o_seg_dp        ;
wire   [5:0]   o_seg_enb       ;
wire   [41:0]  i_six_digit_seg ;

assign i_six_digit_seg = {o_seg4, o_seg5, o_seg2, o_seg3, o_seg0, o_seg1 };





led_disp u_led_disp (
                      .o_seg            (  o_seg           ),
                      .o_seg_dp         (  o_seg_dp        ),
                      .o_seg_enb        (  o_seg_enb       ),
                      .i_six_digit_seg  ( i_six_digit_seg  ),
                      .i_mode           ( o_mode           ),
                      .clk              ( clk              ),
                      .rst_n            ( rst_n            ),
                      .i_position       ( o_position       ));


buzz	u_buzz(
		.o_buzz			(	o_alarm			),
		.i_buzz_en		(	o_alarm_sinho		),
		.i_countdowner_buzz_en	(	o_countdowner_buzz_en	),
		.clk			(	clk			),
		.rst_n			(	rst_n			));


endmodule
