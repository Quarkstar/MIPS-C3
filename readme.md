# P6 支持MIPS-C3流水线处理器设计

## 1.DATAPATH 模块

### 1.1 IF

#### 1.1.1 PC（程序计数器）

|    信号     |  方向  | 功能描述 |
| :---------: | :----: | :------: |
|     clk     | input  | 时钟信号 |
|    reset    | input  | 重置信号 |
|     en      | input  | 使能信号 |
| pcin[31:0]  | output |  输入pc  |
| pcout[31:0] | output |  输出pc  |

- pc寄存器
- 初始化为0x0000_3000

#### 1.1.2 PCMUX（pc输入选择器）

|      信号       |  方向  | 功能描述 |
| :-------------: | :----: | :------: |
|  pcplus4[31:0]  | input  |   PC+4   |
| pcbranchf[31:0] | input  |  跳转PC  |
| pcchangef[31:0] | input  | 选择信号 |
|   npcin[31:0]   | output |  输出pc  |

#### 1.1.3 IMEM

|    信号     |  方向  | 功能描述 |
| :---------: | :----: | :------: |
| addr[13:2]  | input  | 输入地址 |
| instr[31:0] | output | 输出指令 |

- rom 容量为 32bit*4096
- 从code.txt中读取指令文件
- 输入pc值，输出指令
- $ romaddr =  pc - 0x00003000$

### 1.2 ID

#### 1.2.1 GRF（通用寄存器文件）

|      信号       |  方向  | 功能描述  |
| :-------------: | :----: | :-------: |
|       clk       | input  | 时钟信号  |
|      reset      | input  | 重置信号  |
|    regwrite     | input  | 使能信号  |
|   addr1[4:0]    | input  | 输入地址1 |
|   addr2[4:0]    | input  | 输入地址2 |
|  writereg[4:0]  | input  | 写入地址  |
| writedata[31:0] | input  | 写入数据  |
|    pc[31:0]     | input  |  pc输出   |
|   instr[31:0]   | input  | 指令输出  |
| readdata1[31:0] | output | 输出数据1 |
| readdata2[31:0] | output | 输出数据2 |

- 读出addr1 addr2数据并输出
- 在clk信号上跳沿，将数据写入writereg
- 采用同步清零方式

#### 1.2.2 NPC（跳转pc产生模块）

|    信号     |  方向  |    功能描述    |
| :---------: | :----: | :------------: |
|    jump     | input  |    跳转信号    |
|  jrfamily   | input  |    jr类信号    |
|     beq     | input  |    相等跳转    |
|     bne     | input  |    不等跳转    |
|    bltz     | input  |   小于零跳转   |
|    bgtz     | input  |   大于零跳转   |
|    blez     | input  | 小于等于零跳转 |
|    bgez     | input  | 大于等于零跳转 |
|    eqaul    | input  |    相等信号    |
|     ltz     | input  |   小于零信号   |
|     gtz     | input  |   大于零信号   |
|     lez     | input  | 小于等于零信号 |
|     gez     | input  | 大于等于零信号 |
|  imm[31:0]  | input  |  拓展后立即数  |
| instr[31:0] | input  |      指令      |
| read1[31:0] | input  |    GRF[rs]     |
|  pc[31:0]   | input  |       pc       |
|  npc[31:0]  | output |    下一个pc    |

- 根据控制信号输出下一个pc值
- 这里将判断信号和指令信号都引入模块进行判断
- #这里设计有些复杂 下一版本可以将GRF[rt]引入NPC，在NPC内实现判断，并输出跳转与跳转控制信号

#### 1.2.3 EXT（立即数拓展）

|    信号    |  方向  |    功能描述     |
| :--------: | :----: | :-------------: |
| extop[1:0] | input  | ext功能选择信号 |
|  in[15:0]  | input  |      输入       |
| out[31:0]  | output |      输出       |

- 三种拓展方式  零拓展 、符号拓展、加载到高位

#### 1.2.4 MFRSD（ID级rs重定向）

|      信号       |  方向  |    功能描述     |
| :-------------: | :----: | :-------------: |
| tempread1[31:0] | input  | 当前读出GRF[rs] |
| pcplus8e[31:0]  | input  |    EXE级pc+8    |
|  aluoutm[31:0]  | input  |   MEM级aluout   |
|  resultw[31:0]  | input  | WB级写回result  |
|    frsd[1:0]    | input  |    选择信号     |
|   read1[31:0]   | output |    最终输出     |

#### 1.2.4 MFRTD（ID级rt重定向）

|      信号       |  方向  |    功能描述     |
| :-------------: | :----: | :-------------: |
| tempread2[31:0] | input  | 当前读出GRF[rt] |
| pcplus8e[31:0]  | input  |    EXE级pc+8    |
|  aluoutm[31:0]  | input  |   MEM级aluout   |
|  resultw[31:0]  | input  | WB级写回result  |
|    frtd[1:0]    | input  |    选择信号     |
|   read2[31:0]   | output |    最终输出     |

### 1.3 EXE

#### 1.3.1 ALU

|    信号    |  方向  |    功能描述     |
| :--------: | :----: | :-------------: |
|  a[31:0]   | input  |     GRF[rs]     |
|  b[31:0]   | input  |     GRF[rt]     |
|   c[4:0]   | input  | sa instr[10:6]  |
| aluop[3:0] | input  | alu功能选择信号 |
| out[31:0]  | output |     alu输出     |

- 运算单元 支持add,sub,and,or,xor,nor,slt,sll,sllv,srlv,sra,srl,srav等操作

#### 1.3.2 MULDIV

|       信号       |  方向  |     功能描述     |
| :--------------: | :----: | :--------------: |
|     a[31:0]      | input  |     GRF[rs]      |
|     b[31:0]      | input  |     GRF[rt]      |
|       clk        | input  |     时钟信号     |
|      reset       | input  |     重置信号     |
|       mult       | input  |       mult       |
|      multu       | input  |      multu       |
|       div        | input  |       div        |
|       divu       | input  |       divu       |
|       mfhi       | input  |       mfhi       |
|       mflo       | input  |       mflo       |
|       mthi       | input  |       mthi       |
|       mtlo       | input  |       mtlo       |
|      start       | output | 乘除运算开始信号 |
|       busy       | output | 乘除模块阻塞信号 |
| multdivout[31:0] | output |   乘除模块输出   |

- 乘除模块，实现乘法与除法运算。其中乘法运算需要5个时钟周期，除法运算需要10个时钟周期
- 内置两个寄存器HI,LO
- #在这里为了实现功能上的分离，将控制器译码结果引入muldiv模块，略显繁琐

#### 1.3.3 MFRSE（EXE级rs重定向）

|     信号      |  方向  |    功能描述     |
| :-----------: | :----: | :-------------: |
|  read1[31:0]  | input  | 当前读出GRF[rs] |
| aluoutm[31:0] | input  |   MEM级aluout   |
| resultw[31:0] | input  | WB级写回result  |
|   frse[1:0]   | input  |    选择信号     |
| aluinae[31:0] | output |    最终输出     |

#### 1.3.4 MFRTE（EXE级rt重定向）

|       信号        |  方向  |    功能描述     |
| :---------------: | :----: | :-------------: |
|    read2[31:0]    | input  | 当前读出GRF[rt] |
|   aluoutm[31:0]   | input  |   MEM级aluout   |
|   resultw[31:0]   | input  | WB级写回result  |
|     frte[1:0]     | input  |    选择信号     |
| tempaluinbe[31:0] | output |    最终输出     |

#### 1.3.5 ALUMUX（alu的b接口输入选择）

|       信号        |  方向  |    功能描述     |
| :---------------: | :----: | :-------------: |
| tempaluinbe[31:0] | input  | 当前读出GRF[rt] |
|     imm[31:0]     | input  |     立即数      |
|      alusrc       | input  |    选择信号     |
|   aluinbe[31:0]   | output |    最终输出     |

#### 1.3.6 ALUOUTMUX（alu输出结果选择）

|       信号        |  方向  |    功能描述    |
| :---------------: | :----: | :------------: |
| tempaluoute[31:0] | input  |    alu输出     |
|  pcplus8e[31:0]   | input  |      pc+8      |
| multdivoute[31:0] | input  |  乘除模块输出  |
|  aluoutsel[1:0]   | input  | aluout选择信号 |
|   aluoute[31:0]   | output |  alu最终输出   |

### 1.4 MEM

#### 1.4.1 DMEM

|      信号       |  方向  | 功能描述   |
| :-------------: | :----: | ---------- |
|       clk       | input  | 时钟信号   |
|      reset      | input  | 重置信号   |
|     memread     | input  | 读使能信号 |
|    memwrite     | input  | 写使能信号 |
|       sw        | input  | sw         |
|       sh        | input  | sh         |
|       sb        | input  | sb         |
|   addr[31:0]    | input  | 输入地址   |
| writedata[31:0] | input  | 写入数据   |
|    pc[31:0]     | input  | pc         |
| readdata[31:0]  | output | 读出数据   |

- ram 容量32bit*4096
- memread有效时，将addr对应的数据读出
- 当clk处于上升沿且memwrite有效，将writedata写入ram
- 同步清零
- sw sh sb的处理内置到DMEM中

#### 1.4.2 MFRTM（M级rt重定向）

|        信号         |  方向  |   功能描述   |
| :-----------------: | :----: | :----------: |
| tempwritedata[31:0] | input  | 当前读出数据 |
|    resultw[31:0]    | input  |  WB级result  |
|        frtm         | input  |  重定向选择  |
|   writedata[31:0]   | output |   最终输出   |

### 1.5 WB

#### 1.5.1 LOADEXT

|        信号         |  方向  |   功能描述   |
| :-----------------: | :----: | :----------: |
|         lw          | input  |      lw      |
|         lb          | input  |      lb      |
|         lbu         | input  |     lbu      |
|         lh          | input  |      lh      |
|         lhu         | input  |     lhu      |
|    byteaddr[1:0]    | input  |  地址低两位  |
|   readdata[31:0]    | input  | 当前读出数据 |
| finalreaddata[31:0] | output | 最终读出数据 |

- load出数据之后的处理，包括加载字，加载半字并拓展，加载字节并拓展
- loadext放在wb有利于加快时钟频率

#### 1.5.2 wirtedatamux（写数据选择）

|         信号         |  方向  |  功能描述  |
| :------------------: | :----: | :--------: |
|    aluoutw[31:0]     | input  |  alu输出   |
| finalreaddataw[31:0] | input  |  dmem输出  |
|       memtoreg       | input  | 写数据选择 |
|   tempresult[31:0]   | output |  最终输出  |

#### 1.5.3 pcplus8mux（写数据选择）

|       信号       |  方向  | 功能描述 |
| :--------------: | :----: | :------: |
| tempresult[31:0] | input  |  写数据  |
|  pcplus8[31:0]   | input  |   pc+8   |
|     pctoreg      | input  |  pc选择  |
|   result[31:0]   | output | 最终输出 |

- #上述两个mux可以合并 但考虑意义不同将其分开
- #在本级中隐含了一个选择器，即写入寄存器地址选择 由regdst信号控制，分别写入rs、rt、$ra

## 2. controller

### 2.1 生成逻辑

由opcode与function字段将指令译码（有些指令需要instr其他字段才能完全判断）

### 2.2 分类逻辑

| 类          | 指令                                    |
| ----------- | --------------------------------------- |
| rrfamily    | Rtype-{nop,mdfamily,jr,jalr} mfhi mflo  |
| rifamily    | ori lui addi addiu andi xori slti sltiu |
| loadfamily  | lw lh lhu lb lbu                        |
| storefamily | sw sh sb                                |
| jalfamily   | jal                                     |
| jrfamily    | jalr jr                                 |
| jalrfamily  | jalr                                    |
| bfamily     | beq bne bltz bgtz blez bgez             |
| mdfamily    | mult multu div divu mfhi mflo mthi mtlo |

### 2.3 控制逻辑

| 控制信号  | 表达式                                                       |
| --------- | ------------------------------------------------------------ |
| jump      | j \| jal                                                     |
| regdst    | {jal  , Rtype \| jalr}                                       |
| memtoreg  | loadfamily                                                   |
| pctoreg   | jal \| jalr                                                  |
| alusrc    | rifamily \| loadfamily \|storefamily                         |
| aluoutsel | {mfhi \| mflo, jal \| jalr}                                  |
| regwrite  | jal \| jalr \| rrfamily \| rifamily \| loadfamily            |
| memread   | loadfamily                                                   |
| memwrite  | storefamily                                                  |
| extop     | {lui, loadfamily \| storefamily \| addi \| addiu \| slti \| sltiu } |

- 这种设计方式介于detecor与planner之间，是对指令进行了简单的归类，在下一版中将尝试完全的detector
- 这样的方式不容易添加不在现有分类中的指令，但添加现有分类的指令比较简单

## 3. Hazard 

### 3.1 stall

#### 3.1.1 bfamily D

| 类         | 流水级 | NEED  | WRITE |
| ---------- | ------ | ----- | ----- |
| rrfamily   | EXE    | RS RT | RD    |
| rifamily   | EXE    | RS RT | RT    |
| loadfamily | EXE    | RS RT | RT    |
| loadfamily | MEM    | RS RT | RT    |

#### 3.1.2 rrfamily D

| 类         | 流水级 | NEED  | WRITE |
| ---------- | ------ | ----- | ----- |
| loadfamily | EXE    | RS RT | RT    |

#### 3.1.3 rifamily D

| 类         | 流水级 | NEED | WRITE |
| ---------- | ------ | ---- | ----- |
| loadfamily | EXE    | RS   | RT    |

#### 3.1.4 loadfamily D

| 类         | 流水级 | NEED | WRITE |
| ---------- | ------ | ---- | ----- |
| loadfamily | EXE    | RS   | RT    |

#### 3.1.5 swfamily D(rs)

| 类         | 流水级 | NEED | WRITE |
| ---------- | ------ | ---- | ----- |
| loadfamily | EXE    | RS   | RT    |

#### 3.1.6 jrfamily D

| 类         | 流水级 | NEED | WRITE |
| ---------- | ------ | ---- | ----- |
| rrfamily   | EXE    | RS   | RD    |
| rifamily   | EXE    | RS   | RT    |
| loadfamily | EXE    | RS   | RT    |
| loadfamily | MEM    | RS   | RT    |

#### 3.1.7 mdfamily D

| 类       | 流水级 | 阻塞信号        |
| -------- | ------ | --------------- |
| mdfamily | EXE    | (start \| busy) |

### 3.2 forward

**<u>!!! 注意 $0不用重定向</u>**

#### 3.2.1 forward rs D (bfamily | jrfamily)

| 类         | 流水级 | WRITE | FORWARD DATA |
| ---------- | ------ | ----- | ------------ |
| jalfamily  | EXE    | $ra   | pcplus8e     |
| jalrfamily | EXE    | RD    | pcplus8e     |
| rrfamily   | MEM    | RD    | aluoutm      |
| rifamily   | MEM    | RT    | aluoutm      |
| jalfamily  | MEM    | $ra   | aluoutm      |
| jalrfamily | MEM    | RD    | aluoutm      |
| rrfamily   | WB     | RD    | resultw      |
| rifamily   | WB     | RT    | resultw      |
| loadfamily | WB     | RT    | resultw      |
| jalfamily  | WB     | $ra   | resultw      |
| jalrfamily | WB     | RD    | resultw      |


#### 3.2.2 forward rt D (bfamily)

| 类         | 流水级 | WRITE | FORWARD DATA |
| ---------- | ------ | ----- | ------------ |
| jalfamily  | EXE    | $ra   | pcplus8e     |
| jalrfamily | EXE    | RD    | pcplus8e     |
| rrfamily   | MEM    | RD    | aluoutm      |
| rifamily   | MEM    | RT    | aluoutm      |
| jalfamily  | MEM    | $ra   | aluoutm      |
| jalrfamily | MEM    | RD    | aluoutm      |
| rrfamily   | WB     | RD    | resultw      |
| rifamily   | WB     | RT    | resultw      |
| loadfamily | WB     | RT    | resultw      |
| jalfamily  | WB     | $ra   | resultw      |
| jalrfamily | WB     | RD    | resultw      |

#### 3.2.3 forward rs E (rrfamily | rifamily | loadfamily | storefamily | mdfamily)

| 类         | 流水级 | WRITE | FORWARD DATA |
| ---------- | ------ | ----- | ------------ |
| rrfamily   | MEM    | RD    | aluoutm      |
| rifamily   | MEM    | RT    | aluoutm      |
| jalfamily  | MEM    | $ra   | aluoutm      |
| jalrfamily | MEM    | RD    | aluoutm      |
| rrfamily   | WB     | RD    | resultw      |
| rifamily   | WB     | RT    | resultw      |
| loadfamily | WB     | RT    | resultw      |
| jalfamily  | WB     | $ra   | resultw      |
| jalrfamily | WB     | RD    | resultw      |

#### 3.2.4 forward rt E (rrfamily | storefamily | mdfamily)

| 类         | 流水级 | WRITE | FORWARD DATA |
| ---------- | ------ | ----- | ------------ |
| rrfamily   | MEM    | RD    | aluoutm      |
| rifamily   | MEM    | RT    | aluoutm      |
| jalfamily  | MEM    | $ra   | aluoutm      |
| jalrfamily | MEM    | RD    | aluoutm      |
| rrfamily   | WB     | RD    | resultw      |
| rifamily   | WB     | RT    | resultw      |
| loadfamily | WB     | RT    | resultw      |
| jalfamily  | WB     | $ra   | resultw      |
| jalrfamily | WB     | RD    | resultw      |

#### 3.2.5 forward rt W (storefamily)

| 类         | 流水级 | WRITE | FORWARD DATA |
| ---------- | ------ | ----- | ------------ |
| rrfamily   | WB     | RD    | resultw      |
| rifamily   | WB     | RT    | resultw      |
| loadfamily | WB     | RT    | resultw      |
| jalfamily  | WB     | $ra   | resultw      |
| jalrfamily | WB     | RD    | resultw      |

## 4. 总结

感觉流水线的设计逻辑还是很清晰的，不过需要注意细节，避免犯打错字母的小错误。

在下一个版本中，希望可以完全的detector，即分出那些指令在什么时候需要或者写哪个寄存器。这样新添加指令时可以不对冲突处理单元做出改动。

另一点希望在下个版本使用集中式译码，减少硬件资源消耗。

自己因为犯了太多的小错误fail了太多次，有点难受，（T_T）

不过寒假可以继续P7设计，继续努力吧。希望明天上机可以有个好运气

Keep fighting！