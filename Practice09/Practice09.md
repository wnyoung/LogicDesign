
# Lab 09
##실습 내용
### **7-Segment Display Decoder ( 개별)**
#### **Submodule 1**
: 0~9의 값을 갖는 4bit 입력 신호를 받아 7bit FND segment 값 출력
#### **Submodule 2**
: 0~59의 값을 갖는 6bit 입력 신호를 받아 십의 자리 수와 일의 자리 수를 각각 4bit 으로 출력
#### **Top Module**
:저번 시간에 만든 second counter 및 Submodule 1/2 를 이용하여 실습 장비의 LED 에 맞는 Display Module 설계
### FPGA실습( 팀)
: 6개의 LED 중 가장 오른쪽 2 개의 LED 에 1 초간격으로 0~59 까지 증가하는 Counter 값 Display

: NCO(Numerical Controlled Oscillator)입력 바꿔서 4 초 간격으로 증가하는 코드 테스트


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
: IR리모컨에서 입력받는  i_ir_rxb을 반전시켜 ir_rx로 부름

```verilog
//		1M Clock = 1 us Reference Time
wire		clk_1M				;
nco		u_nco(
		.o_gen_clk	( clk_1M	),
		.i_nco_num	( 32'd50	),
		.clk		( clk		),
		.rst_n		( rst_n		));
```
: 4.5ms를 위해 1M Clock을 nco로 만든다.

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
: seq_rx는 2bit을 저장하는 reg변수로 seq_rx[0]는 이전 비트를  seq_rx[1]은 현재 비트를 저장한다. 따라서 ir_rx의 변화를 감지하는 역할을 수행한다.


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
: seq_rx로 ir_rx를 감지하여 cnt_l과 cnt_h를 증가시킨다. clk_1M마다 seq_rx을 통해 ir_rx가 1이되면 cnt_h를 증가시키고 ir_rx가 0이되면 cnt_l을 증가시킨다.


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


![](https://github.com/wnyoung/LogicDesign/blob/master/Practice09/FPGA%20%EC%82%AC%EC%A7%84.jpg?raw=true)



<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyMTEzMTQxNV19
-->
