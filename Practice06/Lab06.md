
# Lab 06
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

##퀴즈
###아래 코드 일부를 수정하여 다음을 구하시오
```verilog
wire [41:0] six_digit_seg
assign six_digit_seg = { 4{7'b0000000}, seg_left , seg_right}
```
> Q1 - 고정 LED ( 왼쪽 4 개 ) AAAA 출력
: `AA_AA_00`, `AA_AA_01`, `AA_AA_02`, …순으로 LED 변경
`Please fill up your source`
> Q2 - 고정 LED 없이 2 개의 LED 단위로 1 초 Counter 값 표시
: `00_00_00`, `01_01_01`, `02_02_02`, …순으로 LED 변경
`Please fill up your source`
##결과
### **Top Module의 DUT/ TestBench Code 및 Waveform 검증**
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice06/fnd_dec.JPG)
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice06/top_nco_disp.JPG)
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice06/tb.JPG)
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice06/wave.JPG)
![](https://github.com/wnyoung/LogicDesign/blob/master/Practice06/genclock%26nco_cnt.JPG)
### **FPGA동작 사진 (3 개 일반 , Q1, Q2)**
`Please fill up your source`
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyMTEzMTQxNV19
-->
