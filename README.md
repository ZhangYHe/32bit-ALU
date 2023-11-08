# 32bit-ALU

2023 北京理工大学 计算机组成与体系结构 课程大作业

## 实验目的

1. 了解ALU原理

2. 学习vivado使用方法

3. 学习Verilog HDL语言

## 实验内容

1. 设计并实现一个32位ALU

2. 支持至少8种运算，自行选择

3. 输出5个标志符号：SF（符号位），CF（进位标志），ZF（零标志），OF（溢出标志）和PF
    （奇偶标志）

4. 支持左右移位操作

5. 可支持至少两种舍入操作

## 实验环境

使用vivado设计32位ALU并进行仿真，vivado版本号为2019.2。使用Verilog语言进行代码的编写。使用Visual
Studio code作为代码编辑器。操作系统为windows 10。

## 实验过程及步骤

### 框架设计

在本实验中，设计并实现一个32为ALU。使用Verilog语言进行结构化描述。该ALU实现32位数的有符号数加法、有符号数减法、无符号数加法、无符号数减法、按位与、按位或、按位非、按位异或、按位或非、算数右移、逻辑右移、逻辑左移、无符号数比较、有符号数比较、7种舍入操作共21种运算。输出SF、CF、PF、ZF、OF五个标志位。

将32位ALU集成在一个模块中，模块输入为2个32位运算的操作数，1个11位的操作码；模块输出为1个32位的运算结果，5个标志位，分别为SF、CF、PF、ZF、OF。使用case语句根据操作符选择对应的运算过程。

32位ALU模块输入输出代码如下所示。

    module alu_32bit(
    op,input_a,input_b,
    CF,OF,ZF,SF,PF,out
    );
    input [31:0] input_a,input_b;
    input [10:0] op;
    output reg[31:0] out;
    output reg CF,OF,ZF,SF,PF;


### 有符号数加法

对于两个32位有符号数的加法，在verilog中直接进行加法运算即可得到结果。若结果为0，则ZF标志位为1。若两个同符号的数相加结果符号相反则为溢出，OF标志位为1。SF标志位和结果最高位数值相同。对结果所有位进行异或操作，并最后进行取反，即可得到PF标志位的数值。结果中1的个数为偶数时PF为1，反之为0。

有符号数加法部分代码如下所示。

    begin
     out=input_a+input_b;
     OF=((input_a[31]==input_b[31])&&(~out[31]==input_a[31]))?1:0;
     ZF=(out==0)?1:0;
     CF=0;
     SF=out[31];
     // 1的个数为偶数，PF=1
     PF=~(^out[31:0]);
    end

### 有符号数减法

对于两个32位有符号数的减法，在verilog中直接进行减法运算即可得到结果。若两个操作数相同，减法结果为0，则ZF标志位为1。若正数减负数结果为负数，或是负数减正数结果为正数，则为溢出，OF标志位为1。SF、PF标志位判断方式同上。

有符号数减法部分代码如下所示。

    begin
     out=input_a-input_b;
     OF=((input_a[31]==0&&input_b[31]==1&&out[31]==1)||(input_a[31]==1&&input_b[31]==0&&out[31]==0))?1:0;
     ZF=(input_a==input_b)?1:0;
     CF=0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 无符号数加法

对于两个32位无符号数的加法，在verilog中直接进行加法运算，将运算结果拆分为32位和1位。这个32位结果为运算结果，最高的1位为CF标志位。若结果为0，则ZF标志位为1。SF、PF标志位判断方式同上。

无符号数加法部分代码如下所示。

    begin
     {CF,out}=input_a+input_b;
     ZF=(out==0)?1:0;
     OF=0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 无符号数减法

对于两个32位无符号数的减法，计算方式和无符号数加法相似，将运算结果看作一个33位的数据，最高位为CF标志位，其余32位为运算结果。若两个操作数相同，减法结果为0，则ZF标志位为1。SF、PF标志位判断方式同上。

无符号数减法部分代码如下所示。

    begin
     {CF,out}=input_a-input_b;
     ZF=(out==0)?1:0;
     OF=0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 按位与

对于两个32位无符号数的按位与运算，在verilog中只需进行&运算即可。对于逻辑运算，CF、OF标志位均为0，ZF、SF、PF标志位判断方式同上。

按位与运算部分代码如下所示。

    begin
     out=input_a&input_b;
     ZF=(out==0)?1:0;
     CF=0;
     OF=0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 按位或

对于两个32位无符号数的按位或运算，在verilog中只需进行∣运算即可。对于逻辑运算，CF、OF标志位均为0，ZF、SF、PF标志位判断方式同上。

按位或运算部分代码如下所示。

    begin
     out=input_a|input_b;
     ZF=(out==0)?1:0;
     CF=0;
     OF=0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 按位异或、按位或非

由于篇幅有限，按位异或、按位或非的过程不再一一列举，5个标志位的判断方式和其他逻辑运算相同。

### 有符号数比较

对于两个32位有符号数的比较运算。若两个操作数符号相反，可以直接得出比较结果。若符号相同，在verilog中使用\<运算符判断，若第一个操作数小于第二个操作数，结果为1，反之结果为0。标志位判断方式同上。

有符号数比较运算部分代码如下所示。

    begin                        
     if(input_a[31]==1&&input_b[31]==0)
     out=1;
     else if(input_a[31]==0&&input_b[31]==1)
     out=0;
     else 
     out=(input_a<input_b)?1:0;
     OF=out; 
     ZF=(out==0)?1:0;
     CF=0;   
     SF=out[31];
     PF=~(^out[31:0]);           
    end

### 无符号数比较

对于两个32位无符号数的比较运算，计算过程与有符号数比较相似，仅去掉判断操作数符号是否相反的步骤。

### 算数右移

对于算数右移运算，将第一个操作数向右移动第二个操作数大小的位数，左侧空余的位使用原符号位进行补齐。CF标志位为最后一个移除的数，即第\[inputb-1\]位。OF、ZF、SF、PF标志位判断方式同上。

算数右移运算部分代码如下所示。

    begin
     out=($signed(input_a))>>>input_b;
     CF=input_a[input_b-1];
     OF=0;
     ZF=(out==0)?1:0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 逻辑右移

对于逻辑右移运算，运算过程与算数右移类似。区别在于逻辑右移使用0填充左侧空余的位数。OF、ZF、SF、PF标志位判断方式同上。

逻辑右移运算部分代码如下所示。

    begin
     out=input_a>>input_b;
     CF=input_a[input_b-1];
     OF=0;
     ZF=(out==0)?1:0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 逻辑左移

对于逻辑左移运算，运算过程逻辑左移类似。区别在于逻辑左移使用0填充右侧空余的位数。OF、ZF、SF、PF标志位判断方式同上。

逻辑左移运算部分代码如下所示。

    begin   
     {CF,out}=input_a<<input_b;
     OF=0;
     ZF=(out==0)?1:0;
     SF=out[31];
     PF=~(^out[31:0]);
    end

### 舍入

对于舍入运算，通过第二个操作数选择舍入位数。使用case语句块跳转到对应位置进行运算。将第一个操作数和mask值进行按位与运算，进行舍入操作。支持四位、八位、十二位、十六位、二十位、二十四位、二十八位舍入操作。CF、OF、ZF、SF、PF标志位判断方式同上。

舍入运算部分代码如下所示。

    begin
     case(input_b)
     32'b0000_0000_0000_0000_0000_0000_0000_1000:
      begin
      out=~(input_a&32'b1111_1111_1111_1111_1111_1111_1111_0000);
      SF=out[31];
      CF=0;
      OF=0;
      ZF=(out==0)?1:0;
      PF=~(^out[31:0]);
      end
     32'b0000_0000_0000_0000_0000_0000_1000_0000:
      begin
      out=~(input_a&32'b1111_1111_1111_1111_1111_1111_0000_0000);
      SF=out[31];
      CF=0;
      OF=0;
      ZF=(out==0)?1:0;
      PF=~(^out[31:0]);
      end
     32'b0000_0000_0000_0000_0000_1000_0000_0000:
      begin
      out=~(input_a&32'b1111_1111_1111_1111_1111_0000_0000_0000);
      SF=out[31];
      CF=0;
      OF=0;
      ZF=(out==0)?1:0;
      PF=~(^out[31:0]);
      end
     32'b0000_0000_0000_0000_1000_0000_0000_0000:
      begin
      out=~(input_a&32'b1111_1111_1111_1111_0000_0000_0000_0000);
      SF=out[31];
      CF=0;
      OF=0;
      ZF=(out==0)?1:0;
      PF=~(^out[31:0]);
      end
     32'b0000_0000_0000_1000_0000_0000_0000_0000:
      begin
      out=~(input_a&32'b1111_1111_1111_0000_0000_0000_0000_0000);
      SF=out[31];
      CF=0;
      OF=0;
      ZF=(out==0)?1:0;
      PF=~(^out[31:0]);
      end
     32'b0000_0000_1000_0000_0000_0000_0000_0000:
      begin
      out=~(input_a&32'b1111_1111_0000_0000_0000_0000_0000_0000);
      SF=out[31];
      CF=0;
      OF=0;
      ZF=(out==0)?1:0;
      PF=~(^out[31:0]);
      end
     32'b0000_1000_0000_0000_0000_0000_0000_0000:
      begin
      out=~(input_a&32'b1111_0000_0000_0000_0000_0000_0000_0000);
      SF=out[31];
      CF=0;
      OF=0;
      ZF=(out==0)?1:0;
      PF=~(^out[31:0]);
      end
    endcase

## 仿真测试

### testbench

编写testbench进行仿真测试。遍历所有运算操作，对同一个运算使用多组操作数进行测试。以ns为时间尺度进行仿真测试。

testbench部分代码如下所示。

    module testbench(

    );
    reg [10:0] op;
    reg [31:0] input_a,input_b;
    wire [31:0] out;
    wire CF,OF,ZF,SF,PF;
    alu_32bit alu_32bit(op,input_a,input_b,CF,OF,ZF,SF,PF,out);
    initial
     begin
     //add
     op=11'b00000100000;        
     input_a=32'hf2340000;
     input_b=32'h80000000;
     #20  input_a=32'h7fffffff;
     input_b=32'h70000001;
     #20  input_a=32'h7fffffff;
     input_b=32'hf0000001;
     #20  input_a=32'hffffffff;
     input_b=32'h00000001;
     //addu          
     #20  op=11'b00000100001;   
     input_a=32'hf2340000;
     input_b=32'h80000000;
     #20  input_a=32'h7fffffff;
     input_b=32'h70000001;
     #20  input_a=32'hffffffff;
     input_b=32'h00000001;
     //sub    
     #20  op=11'b00000100010;        
     input_a=32'h72340000;
     input_b=32'h60000000;
     #20  input_a=32'h7fffffff;
     input_b=32'hf0000001;
     #20  input_a=32'hf00fffff;
     input_b=32'h7ffffff1;
     #20  input_a=32'hffffffff;
     input_b=32'hffffffff;
     #20  input_a=32'hf0000000;
     input_b=32'h0fffffff; 
     //subu
     #20  op=11'b00000100011;        
     input_a=32'h72340000;
     input_b=32'h60000000;
     #20  input_a=32'h7fffffff;
     input_b=32'hf0000001;
     #20  input_a=32'hffffffff;
     input_b=32'hffffffff;
     #20  input_a=32'hf0000000;
     input_b=32'h0fffffff; 
     //and
     #20  op=11'b00000100100;        
     input_a=32'h72340000;
     input_b=32'h60000000;
     #20  input_a=32'h7fffffff;
     input_b=32'h00000000; 
     //or
     #20  op=11'b00000100101;        
     input_a=32'h00000000;
     input_b=32'h00000000;
     #20  input_a=32'h7fffffff;
     input_b=32'hf0000001;
     //xor
     #20  op=11'b00000100110;        
     input_a=32'ha0000000;
     input_b=32'h50000000;
     #20  input_a=32'h7fffffff;
     input_b=32'hf0000001;
     //nor
     #20  op=11'b00000100111;        
     input_a=32'h123451ff;
     input_b=32'h60000000;
     #20  input_a=32'h7fffffff;
     input_b=32'hf0000001;
     //slt
     #20  op=11'b00000101010;        
     input_a=32'h72340000;
     input_b=32'hf0000000;
     #20  input_a=32'h7000000f;
     input_b=32'h7f000001;
     #20  input_a=32'hf0001231;
     input_b=32'h7ac34545;
     //sltu
     #20  op=11'b00000101011;        
     input_a=32'h72340000;
     input_b=32'hf0000000;
     #20  input_a=32'h7000000f;
     input_b=32'h7f000001;
     #20  input_a=32'hf0001231;
     input_b=32'h7ac34545;
     //shl
     #20  op=11'b00000000100;
     input_a=32'hffffffff;
     input_b=32'd5;
     //shr
     #20  op=11'b00000000110;
     input_a=32'hffffffff;
     input_b=32'd5;
     //sar
     #20  op=11'b00000000111;
     input_a=32'hffffffff;
     input_b=32'd3;
     #20  input_a=32'h0fffffff;
     input_b=32'd5;
     //truncate
     #20  op=11'b00000101100;
     input_a=32'hffffffff;
     input_b=32'b0000_0000_0000_0000_0000_0000_0000_1000;
     #20 input_a=32'hffffffff;
     input_b=32'b0000_0000_0000_0000_0000_0000_1000_0000;
     #20 input_a=32'hffffffff;
     input_b=32'b0000_0000_0000_0000_0000_1000_0000_0000;
     #20 input_a=32'hffffffff;
     input_b=32'b0000_0000_0000_0000_1000_0000_0000_0000;
     #20 input_a=32'hffffffff;
     input_b=32'b0000_0000_0000_1000_0000_0000_0000_0000;
     #20 input_a=32'hffffffff;
     input_b=32'b0000_0000_1000_0000_0000_0000_0000_0000;
     #20 input_a=32'hffffffff;
     input_b=32'b0000_1000_0000_0000_0000_0000_0000_0000;
     end
    endmodule
