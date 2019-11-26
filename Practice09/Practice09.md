
# Lab 09

##결과
### **FPGA 동작 사진**
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/FPGA%20%EC%82%AC%EC%A7%84.jpg?raw=true)

### **코드 설명과 wave 설명**
```verilog
module	ir_rx(	
		o_data,
		i_ir_rxb,
		clk,
		rst_n);
```
:ir_rx 모듈의 기능
: IR리모컨에서 i_ir_rxb을 입력으로 받아 data영역의 32bit를 만들어 o_data로 출력한다.

```verilog
wire		ir_rx		;
assign		ir_rx = ~i_ir_rxb;
```
: IR리모컨에서 입력받는  i_ir_rxb을 반전시켜 ir_rx에 assign

```verilog
//		1M Clock = 1 us Reference Time
wire		clk_1M				;
nco		u_nco(
		.o_gen_clk	( clk_1M	),
		.i_nco_num	( 32'd50	),
		.clk		( clk		),
		.rst_n		( rst_n		));
```
: 4.5ms등 ms에서 소수점 단위를 위해 1ms보다 작은 단위인 1us단위의 1M Clock을 nco 모듈로 만든다.

```verilog
reg	[1:0]	seq_rx				;
always @(posedge clk_1M or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		seq_rx <= 2'b00;
	end else begin
		seq_rx <= {seq_rx[0], ir_rx};
	end
end
```
: seq_rx는 2bit을 저장하는 reg타입 변수로 seq_rx[0]는 이전 ir_rx값을 seq_rx[1]은 현재 ir_rx값을 저장한다. 따라서 ir_rx의 변화를 감지하는 역할을 수행한다.


```verilog
//		Count Signal Polarity (High & Low)
reg	[15:0]	cnt_h		;
reg	[15:0]	cnt_l		;
always @(posedge clk_1M or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_h <= 16'd0;
		cnt_l <= 16'd0;
	end else begin
		case(seq_rx)
			2'b00	: cnt_l <= cnt_l + 1;
			2'b01	: begin
				cnt_l <= 16'd0;
				cnt_h <= 16'd0;
			end
			2'b11	: cnt_h <= cnt_h + 1;
		endcase
	end
end
```
: seq_rx로 ir_rx를 감지하여 cnt_l과 cnt_h를 통해 0과 1이 얼마나 입력되었는지를 센다. clk_1M마다 seq_rx을 통해 ir_rx가 1이되면 cnt_h를 증가시키고 ir_rx가 0이되면 cnt_l을 증가시킨다.


```verilog
//		State Machine
reg	[1:0]	state		;
reg	[5:0]	cnt32		;
always @(posedge clk_1M or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		state <= IDLE;
		cnt32 <= 6'd0;
	end else begin
		case (state)
			IDLE: begin
				state <= LEADCODE;
				cnt32 <= 6'd0;
			end
			LEADCODE: begin
				if (cnt_h >= 8500 && cnt_l >= 4000) begin
					state <= DATACODE;
				end else begin
					state <= LEADCODE;
				end
			end
			DATACODE: begin
				if (seq_rx == 2'b01) begin
					cnt32 <= cnt32 + 1;
				end else begin
					cnt32 <= cnt32;
				end
				if (cnt32 >= 6'd32 && cnt_l >= 1000) begin
					state <= COMPLETE;
				end else begin
					state <= DATACODE;
				end
			end
			COMPLETE: state <= IDLE;
		endcase
	end
end
```
: state machine을 구현한 부분으로 IDLE, LEADCODE, DATACODE, COMPLETE의 네가지 상태가 있다.
IDLE은 기본상태로 바로 LEADCODE상태로 넘어가는 부분이다. 
LEADCODE상태는 leader code가 들어왔는지 확인하는 상태이다.
leader code는 1이 9ms, 0이 4.5ms이 들어와야 하는 조건이 있으므로 cnt_h >= 8500 && cnt_l >= 4000이면 leader code가 들어왔다고 판단하여 DATACODE상태로 넘어간다.
DATACODE상태는 32bit의 데이터를 받아들이는 상태이다. 
cnt32는 seq_rx == 2'b01조건을 만족하면 cnt32를 1씩 증가시켜 cnt32가 현재 몇비트의 데이터비트를 받아들이고 있는지를 저장하는 변수이다. 
cnt32 >= 6'd32 && cnt_l >= 1000되면 COMPLETE상태로 넘어가는 역할을 수행한다.
cnt_l >= 1000조건은 마지막 32bit에서 cnt_l가 1000이 넘어가면 충분히 0과 1의 판단을 할 수 있으므로 이 조건을 덧붙여 불필요한 시간을 줄일 수 있다.

```verilog
//		32bit Custom & Data Code
reg	[31:0]	data		;
reg	[31:0]	o_data		;
always @(posedge clk_1M or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		data <= 32'd0;
	end else begin
		case (state)
			DATACODE: begin
				if (cnt_l >= 1000) begin
					data[32-cnt32] <= 1'b1;
				end else begin
					data[32-cnt32] <= 1'b0;
				end
			end
			COMPLETE: o_data <= data;
		endcase
	end
end
```
: 이 부분은 DATACODE 상태에서 data를 저장하고 COMPLETE상태가 되면 32bit가 다 저장되었으므로 그 data를 o_data에 넘겨주는 부분이다.
DATACODE에서 cnt_l >= 1000이면 1이므로 data[32-cnt32] <= 1'b1; 코드로  32bit data변수의 data32-cnt32에 해당하는 data비트영역에 1을 저정한다. 
cnt_l >= 1000이 아니면 0이므로 data[32-cnt32] <= 1'b0; 코드로  32bit data변수의 data32-cnt32에 해당하는 data비트영역에 0을 저장한다. 


![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/rxb-rx%EB%B0%98%EB%8C%80.JPG?raw=true)
:rx를 반전시켜 rxb로 부른다.


![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/rx%EC%99%80%20seq_rx%20%EA%B4%80%EA%B3%84.JPG?raw=true)
:seq_rx는 rx의 변화를 감지하는 역할을 한다.


![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/1m%20clk%EB%A7%88%EB%8B%A4%20seq_rx%EA%B0%80%2000%EC%9D%B4%EB%AF%80%EB%A1%9C%20cnt_l%EC%9D%B4%20%EC%A6%9D%EA%B0%80.JPG?raw=true)
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/seq_rx%EA%B0%80%2001%EC%9D%B4%EB%AF%80%EB%A1%9C%20cnt_l%EA%B3%BC%20cnt_h%EA%B0%80%200%EC%9C%BC%EB%A1%9C%20%EC%B4%88%EA%B8%B0%ED%99%94&%201m%20clk%EB%A7%88%EB%8B%A4%20eq_rx%EA%B0%80%2011%EC%9D%B4%EB%AF%80%EB%A1%9C%20cnt_h%EA%B0%80%201%EC%94%A9%20%EC%A6%9D%EA%B0%80.JPG?raw=true)
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/seq_rx%EA%B0%80%2001%EC%9D%B4%EB%AF%80%EB%A1%9C%20cnt_l%EA%B3%BC%20cnt_h%EA%B0%80%200%EC%9C%BC%EB%A1%9C%20%EC%B4%88%EA%B8%B0%ED%99%94.JPG?raw=true)
:1m clk마다 seq_rx==00이면 cnt_l이 증가, seq_rx==01이면 cnt_l, cnt_h초기화, seq_rx==11이면 cnt_h증가 


![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/state%EA%B0%80%2001%EC%97%90%EC%84%9C%2010%EC%9C%BC%EB%A1%9C%20%EB%B3%80%ED%95%A8.JPG?raw=true)
:reader code가 들어와서 state가 01에서 10으로 변함


![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/state%EA%B0%80%2010%EC%9D%B4%EA%B3%A0%20seq_rx11%EC%9D%B4%20%EB%90%98%EB%A9%B4%20%EC%99%84%EB%B2%BD%ED%95%9C%20%ED%95%9C%20%EB%B9%84%ED%8A%B8%EB%A5%BC%20%EB%B0%9B%EC%9D%80%EA%B2%83%EC%9D%B4%EB%AF%80%EB%A1%9C%20cnt_32%EC%A6%9D%EA%B0%80.JPG?raw=true)
:state가 10이고 seq_rx11이 되면 완벽한 한 비트를 받은것이므로 cnt_32 1 증가



![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/cnt_l%EC%9D%B4%201000%EB%84%98%EC%9C%BC%EB%A9%B4%20data%5B32-cnt_32%5D%EC%97%90%20%ED%95%B4%EB%8B%B9%EC%8B%9C%EA%B8%B0%EC%97%90%20%EC%9E%85%EB%A0%A5%EB%90%9C%20%EB%B9%84%ED%8A%B8%20%EC%A0%80%EC%9E%A5.JPG?raw=true)
:cnt_l이 1000넘으면 data[32-cnt_32]에 해당시기에 입력된 비트 저장


![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/state%EA%B0%80%2010%EC%97%90%EC%84%9C%2011%EC%9D%B4%20%EB%90%98%EB%A9%B4%20data%EA%B0%80%20o_data%EB%A1%9C%20%EB%84%98%EC%96%B4%EA%B0%90.JPG?raw=true)
:state가 10에서 11이 되면 data가 o_data로 넘어감


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyMTEzMTQxNV19
-->
