//   --------------------------------------------------
//   HMS(Hour:Min:Sec) CountDown
/*
1. start/stop
2. reset
3. alarm on/off
4. 00:00:00

*/
//hms_cntdw 인스턴스들 순서 바꾸기!!!!!!!!!!!!!!!!!!!!!!
//   --------------------------------------------------
module	hms_cntdw(
			o_hms_cnt,
			o_max_hit,
			o_circle_en,
			i_circle_en,
			i_countdowner_reset,
			i_countdowner_en,
			i_max_cnt,
			clk,
			rst_n);

output	[5:0]		o_hms_cnt;
output			o_max_hit;
output			o_circle_en;
input			i_circle_en;
input			i_countdowner_reset;
input			i_countdowner_en;
input	[5:0]		i_max_cnt;
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