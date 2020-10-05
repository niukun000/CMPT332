
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	addi	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	c0478793          	addi	a5,a5,-1020 # 80005c60 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e0c78793          	addi	a5,a5,-500 # 80000eb2 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	addi	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	af8080e7          	jalr	-1288(ra) # 80000c04 <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305b63          	blez	s3,8000016a <consolewrite+0x7e>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	40a080e7          	jalr	1034(ra) # 80002530 <either_copyin>
    8000012e:	01550c63          	beq	a0,s5,80000146 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	7aa080e7          	jalr	1962(ra) # 800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
  }
  release(&cons.lock);
    80000146:	00011517          	auipc	a0,0x11
    8000014a:	6ea50513          	addi	a0,a0,1770 # 80011830 <cons>
    8000014e:	00001097          	auipc	ra,0x1
    80000152:	b6a080e7          	jalr	-1174(ra) # 80000cb8 <release>

  return i;
}
    80000156:	854a                	mv	a0,s2
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	7942                	ld	s2,48(sp)
    80000160:	79a2                	ld	s3,40(sp)
    80000162:	7a02                	ld	s4,32(sp)
    80000164:	6ae2                	ld	s5,24(sp)
    80000166:	6161                	addi	sp,sp,80
    80000168:	8082                	ret
  for(i = 0; i < n; i++){
    8000016a:	4901                	li	s2,0
    8000016c:	bfe9                	j	80000146 <consolewrite+0x5a>

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	7119                	addi	sp,sp,-128
    80000170:	fc86                	sd	ra,120(sp)
    80000172:	f8a2                	sd	s0,112(sp)
    80000174:	f4a6                	sd	s1,104(sp)
    80000176:	f0ca                	sd	s2,96(sp)
    80000178:	ecce                	sd	s3,88(sp)
    8000017a:	e8d2                	sd	s4,80(sp)
    8000017c:	e4d6                	sd	s5,72(sp)
    8000017e:	e0da                	sd	s6,64(sp)
    80000180:	fc5e                	sd	s7,56(sp)
    80000182:	f862                	sd	s8,48(sp)
    80000184:	f466                	sd	s9,40(sp)
    80000186:	f06a                	sd	s10,32(sp)
    80000188:	ec6e                	sd	s11,24(sp)
    8000018a:	0100                	addi	s0,sp,128
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8aae                	mv	s5,a1
    80000190:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000196:	00011517          	auipc	a0,0x11
    8000019a:	69a50513          	addi	a0,a0,1690 # 80011830 <cons>
    8000019e:	00001097          	auipc	ra,0x1
    800001a2:	a66080e7          	jalr	-1434(ra) # 80000c04 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a6:	00011497          	auipc	s1,0x11
    800001aa:	68a48493          	addi	s1,s1,1674 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ae:	89a6                	mv	s3,s1
    800001b0:	00011917          	auipc	s2,0x11
    800001b4:	71890913          	addi	s2,s2,1816 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001bc:	4da9                	li	s11,10
  while(n > 0){
    800001be:	07405863          	blez	s4,8000022e <consoleread+0xc0>
    while(cons.r == cons.w){
    800001c2:	0984a783          	lw	a5,152(s1)
    800001c6:	09c4a703          	lw	a4,156(s1)
    800001ca:	02f71463          	bne	a4,a5,800001f2 <consoleread+0x84>
      if(myproc()->killed){
    800001ce:	00002097          	auipc	ra,0x2
    800001d2:	8c4080e7          	jalr	-1852(ra) # 80001a92 <myproc>
    800001d6:	591c                	lw	a5,48(a0)
    800001d8:	e7b5                	bnez	a5,80000244 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800001da:	85ce                	mv	a1,s3
    800001dc:	854a                	mv	a0,s2
    800001de:	00002097          	auipc	ra,0x2
    800001e2:	09c080e7          	jalr	156(ra) # 8000227a <sleep>
    while(cons.r == cons.w){
    800001e6:	0984a783          	lw	a5,152(s1)
    800001ea:	09c4a703          	lw	a4,156(s1)
    800001ee:	fef700e3          	beq	a4,a5,800001ce <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f2:	0017871b          	addiw	a4,a5,1
    800001f6:	08e4ac23          	sw	a4,152(s1)
    800001fa:	07f7f713          	andi	a4,a5,127
    800001fe:	9726                	add	a4,a4,s1
    80000200:	01874703          	lbu	a4,24(a4)
    80000204:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000208:	079c0663          	beq	s8,s9,80000274 <consoleread+0x106>
    cbuf = c;
    8000020c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	f8f40613          	addi	a2,s0,-113
    80000216:	85d6                	mv	a1,s5
    80000218:	855a                	mv	a0,s6
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	2c0080e7          	jalr	704(ra) # 800024da <either_copyout>
    80000222:	01a50663          	beq	a0,s10,8000022e <consoleread+0xc0>
    dst++;
    80000226:	0a85                	addi	s5,s5,1
    --n;
    80000228:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000022a:	f9bc1ae3          	bne	s8,s11,800001be <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022e:	00011517          	auipc	a0,0x11
    80000232:	60250513          	addi	a0,a0,1538 # 80011830 <cons>
    80000236:	00001097          	auipc	ra,0x1
    8000023a:	a82080e7          	jalr	-1406(ra) # 80000cb8 <release>

  return target - n;
    8000023e:	414b853b          	subw	a0,s7,s4
    80000242:	a811                	j	80000256 <consoleread+0xe8>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	5ec50513          	addi	a0,a0,1516 # 80011830 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	a6c080e7          	jalr	-1428(ra) # 80000cb8 <release>
        return -1;
    80000254:	557d                	li	a0,-1
}
    80000256:	70e6                	ld	ra,120(sp)
    80000258:	7446                	ld	s0,112(sp)
    8000025a:	74a6                	ld	s1,104(sp)
    8000025c:	7906                	ld	s2,96(sp)
    8000025e:	69e6                	ld	s3,88(sp)
    80000260:	6a46                	ld	s4,80(sp)
    80000262:	6aa6                	ld	s5,72(sp)
    80000264:	6b06                	ld	s6,64(sp)
    80000266:	7be2                	ld	s7,56(sp)
    80000268:	7c42                	ld	s8,48(sp)
    8000026a:	7ca2                	ld	s9,40(sp)
    8000026c:	7d02                	ld	s10,32(sp)
    8000026e:	6de2                	ld	s11,24(sp)
    80000270:	6109                	addi	sp,sp,128
    80000272:	8082                	ret
      if(n < target){
    80000274:	000a071b          	sext.w	a4,s4
    80000278:	fb777be3          	bgeu	a4,s7,8000022e <consoleread+0xc0>
        cons.r--;
    8000027c:	00011717          	auipc	a4,0x11
    80000280:	64f72623          	sw	a5,1612(a4) # 800118c8 <cons+0x98>
    80000284:	b76d                	j	8000022e <consoleread+0xc0>

0000000080000286 <consputc>:
  if(panicked){
    80000286:	00009797          	auipc	a5,0x9
    8000028a:	d7a7a783          	lw	a5,-646(a5) # 80009000 <panicked>
    8000028e:	c391                	beqz	a5,80000292 <consputc+0xc>
    for(;;)
    80000290:	a001                	j	80000290 <consputc+0xa>
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e406                	sd	ra,8(sp)
    80000296:	e022                	sd	s0,0(sp)
    80000298:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000029a:	10000793          	li	a5,256
    8000029e:	00f50a63          	beq	a0,a5,800002b2 <consputc+0x2c>
    uartputc_sync(c);
    800002a2:	00000097          	auipc	ra,0x0
    800002a6:	564080e7          	jalr	1380(ra) # 80000806 <uartputc_sync>
}
    800002aa:	60a2                	ld	ra,8(sp)
    800002ac:	6402                	ld	s0,0(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	552080e7          	jalr	1362(ra) # 80000806 <uartputc_sync>
    800002bc:	02000513          	li	a0,32
    800002c0:	00000097          	auipc	ra,0x0
    800002c4:	546080e7          	jalr	1350(ra) # 80000806 <uartputc_sync>
    800002c8:	4521                	li	a0,8
    800002ca:	00000097          	auipc	ra,0x0
    800002ce:	53c080e7          	jalr	1340(ra) # 80000806 <uartputc_sync>
    800002d2:	bfe1                	j	800002aa <consputc+0x24>

00000000800002d4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d4:	1101                	addi	sp,sp,-32
    800002d6:	ec06                	sd	ra,24(sp)
    800002d8:	e822                	sd	s0,16(sp)
    800002da:	e426                	sd	s1,8(sp)
    800002dc:	e04a                	sd	s2,0(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00011517          	auipc	a0,0x11
    800002e6:	54e50513          	addi	a0,a0,1358 # 80011830 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	91a080e7          	jalr	-1766(ra) # 80000c04 <acquire>

  switch(c){
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48663          	beq	s1,a5,800003a0 <consoleintr+0xcc>
    800002f8:	0297ca63          	blt	a5,s1,8000032c <consoleintr+0x58>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48763          	beq	s1,a5,800003ec <consoleintr+0x118>
    80000302:	47c1                	li	a5,16
    80000304:	10f49a63          	bne	s1,a5,80000418 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	27e080e7          	jalr	638(ra) # 80002586 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000310:	00011517          	auipc	a0,0x11
    80000314:	52050513          	addi	a0,a0,1312 # 80011830 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	9a0080e7          	jalr	-1632(ra) # 80000cb8 <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6902                	ld	s2,0(sp)
    80000328:	6105                	addi	sp,sp,32
    8000032a:	8082                	ret
  switch(c){
    8000032c:	07f00793          	li	a5,127
    80000330:	0af48e63          	beq	s1,a5,800003ec <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000334:	00011717          	auipc	a4,0x11
    80000338:	4fc70713          	addi	a4,a4,1276 # 80011830 <cons>
    8000033c:	0a072783          	lw	a5,160(a4)
    80000340:	09872703          	lw	a4,152(a4)
    80000344:	9f99                	subw	a5,a5,a4
    80000346:	07f00713          	li	a4,127
    8000034a:	fcf763e3          	bltu	a4,a5,80000310 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000034e:	47b5                	li	a5,13
    80000350:	0cf48763          	beq	s1,a5,8000041e <consoleintr+0x14a>
      consputc(c);
    80000354:	8526                	mv	a0,s1
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	f30080e7          	jalr	-208(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000035e:	00011797          	auipc	a5,0x11
    80000362:	4d278793          	addi	a5,a5,1234 # 80011830 <cons>
    80000366:	0a07a703          	lw	a4,160(a5)
    8000036a:	0017069b          	addiw	a3,a4,1
    8000036e:	0006861b          	sext.w	a2,a3
    80000372:	0ad7a023          	sw	a3,160(a5)
    80000376:	07f77713          	andi	a4,a4,127
    8000037a:	97ba                	add	a5,a5,a4
    8000037c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000380:	47a9                	li	a5,10
    80000382:	0cf48563          	beq	s1,a5,8000044c <consoleintr+0x178>
    80000386:	4791                	li	a5,4
    80000388:	0cf48263          	beq	s1,a5,8000044c <consoleintr+0x178>
    8000038c:	00011797          	auipc	a5,0x11
    80000390:	53c7a783          	lw	a5,1340(a5) # 800118c8 <cons+0x98>
    80000394:	0807879b          	addiw	a5,a5,128
    80000398:	f6f61ce3          	bne	a2,a5,80000310 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000039c:	863e                	mv	a2,a5
    8000039e:	a07d                	j	8000044c <consoleintr+0x178>
    while(cons.e != cons.w &&
    800003a0:	00011717          	auipc	a4,0x11
    800003a4:	49070713          	addi	a4,a4,1168 # 80011830 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b0:	00011497          	auipc	s1,0x11
    800003b4:	48048493          	addi	s1,s1,1152 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	f4f70be3          	beq	a4,a5,80000310 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	f52703e3          	beq	a4,s2,80000310 <consoleintr+0x3c>
      cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	eb0080e7          	jalr	-336(ra) # 80000286 <consputc>
    while(cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xea>
    800003ea:	b71d                	j	80000310 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003ec:	00011717          	auipc	a4,0x11
    800003f0:	44470713          	addi	a4,a4,1092 # 80011830 <cons>
    800003f4:	0a072783          	lw	a5,160(a4)
    800003f8:	09c72703          	lw	a4,156(a4)
    800003fc:	f0f70ae3          	beq	a4,a5,80000310 <consoleintr+0x3c>
      cons.e--;
    80000400:	37fd                	addiw	a5,a5,-1
    80000402:	00011717          	auipc	a4,0x11
    80000406:	4cf72723          	sw	a5,1230(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    8000040a:	10000513          	li	a0,256
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	e78080e7          	jalr	-392(ra) # 80000286 <consputc>
    80000416:	bded                	j	80000310 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000418:	ee048ce3          	beqz	s1,80000310 <consoleintr+0x3c>
    8000041c:	bf21                	j	80000334 <consoleintr+0x60>
      consputc(c);
    8000041e:	4529                	li	a0,10
    80000420:	00000097          	auipc	ra,0x0
    80000424:	e66080e7          	jalr	-410(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000428:	00011797          	auipc	a5,0x11
    8000042c:	40878793          	addi	a5,a5,1032 # 80011830 <cons>
    80000430:	0a07a703          	lw	a4,160(a5)
    80000434:	0017069b          	addiw	a3,a4,1
    80000438:	0006861b          	sext.w	a2,a3
    8000043c:	0ad7a023          	sw	a3,160(a5)
    80000440:	07f77713          	andi	a4,a4,127
    80000444:	97ba                	add	a5,a5,a4
    80000446:	4729                	li	a4,10
    80000448:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000044c:	00011797          	auipc	a5,0x11
    80000450:	48c7a023          	sw	a2,1152(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000454:	00011517          	auipc	a0,0x11
    80000458:	47450513          	addi	a0,a0,1140 # 800118c8 <cons+0x98>
    8000045c:	00002097          	auipc	ra,0x2
    80000460:	fa4080e7          	jalr	-92(ra) # 80002400 <wakeup>
    80000464:	b575                	j	80000310 <consoleintr+0x3c>

0000000080000466 <consoleinit>:

void
consoleinit(void)
{
    80000466:	1141                	addi	sp,sp,-16
    80000468:	e406                	sd	ra,8(sp)
    8000046a:	e022                	sd	s0,0(sp)
    8000046c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000046e:	00008597          	auipc	a1,0x8
    80000472:	ba258593          	addi	a1,a1,-1118 # 80008010 <etext+0x10>
    80000476:	00011517          	auipc	a0,0x11
    8000047a:	3ba50513          	addi	a0,a0,954 # 80011830 <cons>
    8000047e:	00000097          	auipc	ra,0x0
    80000482:	6f6080e7          	jalr	1782(ra) # 80000b74 <initlock>

  uartinit();
    80000486:	00000097          	auipc	ra,0x0
    8000048a:	330080e7          	jalr	816(ra) # 800007b6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000048e:	00021797          	auipc	a5,0x21
    80000492:	72278793          	addi	a5,a5,1826 # 80021bb0 <devsw>
    80000496:	00000717          	auipc	a4,0x0
    8000049a:	cd870713          	addi	a4,a4,-808 # 8000016e <consoleread>
    8000049e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	c4c70713          	addi	a4,a4,-948 # 800000ec <consolewrite>
    800004a8:	ef98                	sd	a4,24(a5)
}
    800004aa:	60a2                	ld	ra,8(sp)
    800004ac:	6402                	ld	s0,0(sp)
    800004ae:	0141                	addi	sp,sp,16
    800004b0:	8082                	ret

00000000800004b2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004b2:	7179                	addi	sp,sp,-48
    800004b4:	f406                	sd	ra,40(sp)
    800004b6:	f022                	sd	s0,32(sp)
    800004b8:	ec26                	sd	s1,24(sp)
    800004ba:	e84a                	sd	s2,16(sp)
    800004bc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004be:	c219                	beqz	a2,800004c4 <printint+0x12>
    800004c0:	08054663          	bltz	a0,8000054c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004c4:	2501                	sext.w	a0,a0
    800004c6:	4881                	li	a7,0
    800004c8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004cc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004ce:	2581                	sext.w	a1,a1
    800004d0:	00008617          	auipc	a2,0x8
    800004d4:	b7060613          	addi	a2,a2,-1168 # 80008040 <digits>
    800004d8:	883a                	mv	a6,a4
    800004da:	2705                	addiw	a4,a4,1
    800004dc:	02b577bb          	remuw	a5,a0,a1
    800004e0:	1782                	slli	a5,a5,0x20
    800004e2:	9381                	srli	a5,a5,0x20
    800004e4:	97b2                	add	a5,a5,a2
    800004e6:	0007c783          	lbu	a5,0(a5)
    800004ea:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004ee:	0005079b          	sext.w	a5,a0
    800004f2:	02b5553b          	divuw	a0,a0,a1
    800004f6:	0685                	addi	a3,a3,1
    800004f8:	feb7f0e3          	bgeu	a5,a1,800004d8 <printint+0x26>

  if(sign)
    800004fc:	00088b63          	beqz	a7,80000512 <printint+0x60>
    buf[i++] = '-';
    80000500:	fe040793          	addi	a5,s0,-32
    80000504:	973e                	add	a4,a4,a5
    80000506:	02d00793          	li	a5,45
    8000050a:	fef70823          	sb	a5,-16(a4)
    8000050e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000512:	02e05763          	blez	a4,80000540 <printint+0x8e>
    80000516:	fd040793          	addi	a5,s0,-48
    8000051a:	00e784b3          	add	s1,a5,a4
    8000051e:	fff78913          	addi	s2,a5,-1
    80000522:	993a                	add	s2,s2,a4
    80000524:	377d                	addiw	a4,a4,-1
    80000526:	1702                	slli	a4,a4,0x20
    80000528:	9301                	srli	a4,a4,0x20
    8000052a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000052e:	fff4c503          	lbu	a0,-1(s1)
    80000532:	00000097          	auipc	ra,0x0
    80000536:	d54080e7          	jalr	-684(ra) # 80000286 <consputc>
  while(--i >= 0)
    8000053a:	14fd                	addi	s1,s1,-1
    8000053c:	ff2499e3          	bne	s1,s2,8000052e <printint+0x7c>
}
    80000540:	70a2                	ld	ra,40(sp)
    80000542:	7402                	ld	s0,32(sp)
    80000544:	64e2                	ld	s1,24(sp)
    80000546:	6942                	ld	s2,16(sp)
    80000548:	6145                	addi	sp,sp,48
    8000054a:	8082                	ret
    x = -xx;
    8000054c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000550:	4885                	li	a7,1
    x = -xx;
    80000552:	bf9d                	j	800004c8 <printint+0x16>

0000000080000554 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000554:	1101                	addi	sp,sp,-32
    80000556:	ec06                	sd	ra,24(sp)
    80000558:	e822                	sd	s0,16(sp)
    8000055a:	e426                	sd	s1,8(sp)
    8000055c:	1000                	addi	s0,sp,32
    8000055e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000560:	00011797          	auipc	a5,0x11
    80000564:	3807a823          	sw	zero,912(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    80000568:	00008517          	auipc	a0,0x8
    8000056c:	ab050513          	addi	a0,a0,-1360 # 80008018 <etext+0x18>
    80000570:	00000097          	auipc	ra,0x0
    80000574:	02e080e7          	jalr	46(ra) # 8000059e <printf>
  printf(s);
    80000578:	8526                	mv	a0,s1
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	024080e7          	jalr	36(ra) # 8000059e <printf>
  printf("\n");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	b4650513          	addi	a0,a0,-1210 # 800080c8 <digits+0x88>
    8000058a:	00000097          	auipc	ra,0x0
    8000058e:	014080e7          	jalr	20(ra) # 8000059e <printf>
  panicked = 1; // freeze other CPUs
    80000592:	4785                	li	a5,1
    80000594:	00009717          	auipc	a4,0x9
    80000598:	a6f72623          	sw	a5,-1428(a4) # 80009000 <panicked>
  for(;;)
    8000059c:	a001                	j	8000059c <panic+0x48>

000000008000059e <printf>:
{
    8000059e:	7131                	addi	sp,sp,-192
    800005a0:	fc86                	sd	ra,120(sp)
    800005a2:	f8a2                	sd	s0,112(sp)
    800005a4:	f4a6                	sd	s1,104(sp)
    800005a6:	f0ca                	sd	s2,96(sp)
    800005a8:	ecce                	sd	s3,88(sp)
    800005aa:	e8d2                	sd	s4,80(sp)
    800005ac:	e4d6                	sd	s5,72(sp)
    800005ae:	e0da                	sd	s6,64(sp)
    800005b0:	fc5e                	sd	s7,56(sp)
    800005b2:	f862                	sd	s8,48(sp)
    800005b4:	f466                	sd	s9,40(sp)
    800005b6:	f06a                	sd	s10,32(sp)
    800005b8:	ec6e                	sd	s11,24(sp)
    800005ba:	0100                	addi	s0,sp,128
    800005bc:	8a2a                	mv	s4,a0
    800005be:	e40c                	sd	a1,8(s0)
    800005c0:	e810                	sd	a2,16(s0)
    800005c2:	ec14                	sd	a3,24(s0)
    800005c4:	f018                	sd	a4,32(s0)
    800005c6:	f41c                	sd	a5,40(s0)
    800005c8:	03043823          	sd	a6,48(s0)
    800005cc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005d0:	00011d97          	auipc	s11,0x11
    800005d4:	320dad83          	lw	s11,800(s11) # 800118f0 <pr+0x18>
  if(locking)
    800005d8:	020d9b63          	bnez	s11,8000060e <printf+0x70>
  if (fmt == 0)
    800005dc:	040a0263          	beqz	s4,80000620 <printf+0x82>
  va_start(ap, fmt);
    800005e0:	00840793          	addi	a5,s0,8
    800005e4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e8:	000a4503          	lbu	a0,0(s4)
    800005ec:	16050263          	beqz	a0,80000750 <printf+0x1b2>
    800005f0:	4481                	li	s1,0
    if(c != '%'){
    800005f2:	02500a93          	li	s5,37
    switch(c){
    800005f6:	07000b13          	li	s6,112
  consputc('x');
    800005fa:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005fc:	00008b97          	auipc	s7,0x8
    80000600:	a44b8b93          	addi	s7,s7,-1468 # 80008040 <digits>
    switch(c){
    80000604:	07300c93          	li	s9,115
    80000608:	06400c13          	li	s8,100
    8000060c:	a82d                	j	80000646 <printf+0xa8>
    acquire(&pr.lock);
    8000060e:	00011517          	auipc	a0,0x11
    80000612:	2ca50513          	addi	a0,a0,714 # 800118d8 <pr>
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	5ee080e7          	jalr	1518(ra) # 80000c04 <acquire>
    8000061e:	bf7d                	j	800005dc <printf+0x3e>
    panic("null fmt");
    80000620:	00008517          	auipc	a0,0x8
    80000624:	a0850513          	addi	a0,a0,-1528 # 80008028 <etext+0x28>
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	f2c080e7          	jalr	-212(ra) # 80000554 <panic>
      consputc(c);
    80000630:	00000097          	auipc	ra,0x0
    80000634:	c56080e7          	jalr	-938(ra) # 80000286 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000638:	2485                	addiw	s1,s1,1
    8000063a:	009a07b3          	add	a5,s4,s1
    8000063e:	0007c503          	lbu	a0,0(a5)
    80000642:	10050763          	beqz	a0,80000750 <printf+0x1b2>
    if(c != '%'){
    80000646:	ff5515e3          	bne	a0,s5,80000630 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000064a:	2485                	addiw	s1,s1,1
    8000064c:	009a07b3          	add	a5,s4,s1
    80000650:	0007c783          	lbu	a5,0(a5)
    80000654:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000658:	cfe5                	beqz	a5,80000750 <printf+0x1b2>
    switch(c){
    8000065a:	05678a63          	beq	a5,s6,800006ae <printf+0x110>
    8000065e:	02fb7663          	bgeu	s6,a5,8000068a <printf+0xec>
    80000662:	09978963          	beq	a5,s9,800006f4 <printf+0x156>
    80000666:	07800713          	li	a4,120
    8000066a:	0ce79863          	bne	a5,a4,8000073a <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4605                	li	a2,1
    8000067c:	85ea                	mv	a1,s10
    8000067e:	4388                	lw	a0,0(a5)
    80000680:	00000097          	auipc	ra,0x0
    80000684:	e32080e7          	jalr	-462(ra) # 800004b2 <printint>
      break;
    80000688:	bf45                	j	80000638 <printf+0x9a>
    switch(c){
    8000068a:	0b578263          	beq	a5,s5,8000072e <printf+0x190>
    8000068e:	0b879663          	bne	a5,s8,8000073a <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4605                	li	a2,1
    800006a0:	45a9                	li	a1,10
    800006a2:	4388                	lw	a0,0(a5)
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	e0e080e7          	jalr	-498(ra) # 800004b2 <printint>
      break;
    800006ac:	b771                	j	80000638 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006ae:	f8843783          	ld	a5,-120(s0)
    800006b2:	00878713          	addi	a4,a5,8
    800006b6:	f8e43423          	sd	a4,-120(s0)
    800006ba:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006be:	03000513          	li	a0,48
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	bc4080e7          	jalr	-1084(ra) # 80000286 <consputc>
  consputc('x');
    800006ca:	07800513          	li	a0,120
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bb8080e7          	jalr	-1096(ra) # 80000286 <consputc>
    800006d6:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d8:	03c9d793          	srli	a5,s3,0x3c
    800006dc:	97de                	add	a5,a5,s7
    800006de:	0007c503          	lbu	a0,0(a5)
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	ba4080e7          	jalr	-1116(ra) # 80000286 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ea:	0992                	slli	s3,s3,0x4
    800006ec:	397d                	addiw	s2,s2,-1
    800006ee:	fe0915e3          	bnez	s2,800006d8 <printf+0x13a>
    800006f2:	b799                	j	80000638 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	addi	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	0007b903          	ld	s2,0(a5)
    80000704:	00090e63          	beqz	s2,80000720 <printf+0x182>
      for(; *s; s++)
    80000708:	00094503          	lbu	a0,0(s2)
    8000070c:	d515                	beqz	a0,80000638 <printf+0x9a>
        consputc(*s);
    8000070e:	00000097          	auipc	ra,0x0
    80000712:	b78080e7          	jalr	-1160(ra) # 80000286 <consputc>
      for(; *s; s++)
    80000716:	0905                	addi	s2,s2,1
    80000718:	00094503          	lbu	a0,0(s2)
    8000071c:	f96d                	bnez	a0,8000070e <printf+0x170>
    8000071e:	bf29                	j	80000638 <printf+0x9a>
        s = "(null)";
    80000720:	00008917          	auipc	s2,0x8
    80000724:	90090913          	addi	s2,s2,-1792 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000728:	02800513          	li	a0,40
    8000072c:	b7cd                	j	8000070e <printf+0x170>
      consputc('%');
    8000072e:	8556                	mv	a0,s5
    80000730:	00000097          	auipc	ra,0x0
    80000734:	b56080e7          	jalr	-1194(ra) # 80000286 <consputc>
      break;
    80000738:	b701                	j	80000638 <printf+0x9a>
      consputc('%');
    8000073a:	8556                	mv	a0,s5
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	b4a080e7          	jalr	-1206(ra) # 80000286 <consputc>
      consputc(c);
    80000744:	854a                	mv	a0,s2
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	b40080e7          	jalr	-1216(ra) # 80000286 <consputc>
      break;
    8000074e:	b5ed                	j	80000638 <printf+0x9a>
  if(locking)
    80000750:	020d9163          	bnez	s11,80000772 <printf+0x1d4>
}
    80000754:	70e6                	ld	ra,120(sp)
    80000756:	7446                	ld	s0,112(sp)
    80000758:	74a6                	ld	s1,104(sp)
    8000075a:	7906                	ld	s2,96(sp)
    8000075c:	69e6                	ld	s3,88(sp)
    8000075e:	6a46                	ld	s4,80(sp)
    80000760:	6aa6                	ld	s5,72(sp)
    80000762:	6b06                	ld	s6,64(sp)
    80000764:	7be2                	ld	s7,56(sp)
    80000766:	7c42                	ld	s8,48(sp)
    80000768:	7ca2                	ld	s9,40(sp)
    8000076a:	7d02                	ld	s10,32(sp)
    8000076c:	6de2                	ld	s11,24(sp)
    8000076e:	6129                	addi	sp,sp,192
    80000770:	8082                	ret
    release(&pr.lock);
    80000772:	00011517          	auipc	a0,0x11
    80000776:	16650513          	addi	a0,a0,358 # 800118d8 <pr>
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	53e080e7          	jalr	1342(ra) # 80000cb8 <release>
}
    80000782:	bfc9                	j	80000754 <printf+0x1b6>

0000000080000784 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000784:	1101                	addi	sp,sp,-32
    80000786:	ec06                	sd	ra,24(sp)
    80000788:	e822                	sd	s0,16(sp)
    8000078a:	e426                	sd	s1,8(sp)
    8000078c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000078e:	00011497          	auipc	s1,0x11
    80000792:	14a48493          	addi	s1,s1,330 # 800118d8 <pr>
    80000796:	00008597          	auipc	a1,0x8
    8000079a:	8a258593          	addi	a1,a1,-1886 # 80008038 <etext+0x38>
    8000079e:	8526                	mv	a0,s1
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	3d4080e7          	jalr	980(ra) # 80000b74 <initlock>
  pr.locking = 1;
    800007a8:	4785                	li	a5,1
    800007aa:	cc9c                	sw	a5,24(s1)
}
    800007ac:	60e2                	ld	ra,24(sp)
    800007ae:	6442                	ld	s0,16(sp)
    800007b0:	64a2                	ld	s1,8(sp)
    800007b2:	6105                	addi	sp,sp,32
    800007b4:	8082                	ret

00000000800007b6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007b6:	1141                	addi	sp,sp,-16
    800007b8:	e406                	sd	ra,8(sp)
    800007ba:	e022                	sd	s0,0(sp)
    800007bc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007be:	100007b7          	lui	a5,0x10000
    800007c2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007c6:	f8000713          	li	a4,-128
    800007ca:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ce:	470d                	li	a4,3
    800007d0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007d4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007d8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007dc:	469d                	li	a3,7
    800007de:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007e2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007e6:	00008597          	auipc	a1,0x8
    800007ea:	87258593          	addi	a1,a1,-1934 # 80008058 <digits+0x18>
    800007ee:	00011517          	auipc	a0,0x11
    800007f2:	10a50513          	addi	a0,a0,266 # 800118f8 <uart_tx_lock>
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	37e080e7          	jalr	894(ra) # 80000b74 <initlock>
}
    800007fe:	60a2                	ld	ra,8(sp)
    80000800:	6402                	ld	s0,0(sp)
    80000802:	0141                	addi	sp,sp,16
    80000804:	8082                	ret

0000000080000806 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000806:	1101                	addi	sp,sp,-32
    80000808:	ec06                	sd	ra,24(sp)
    8000080a:	e822                	sd	s0,16(sp)
    8000080c:	e426                	sd	s1,8(sp)
    8000080e:	1000                	addi	s0,sp,32
    80000810:	84aa                	mv	s1,a0
  push_off();
    80000812:	00000097          	auipc	ra,0x0
    80000816:	3a6080e7          	jalr	934(ra) # 80000bb8 <push_off>

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000081a:	10000737          	lui	a4,0x10000
    8000081e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000822:	0ff7f793          	andi	a5,a5,255
    80000826:	0207f793          	andi	a5,a5,32
    8000082a:	dbf5                	beqz	a5,8000081e <uartputc_sync+0x18>
    ;
  WriteReg(THR, c);
    8000082c:	0ff4f493          	andi	s1,s1,255
    80000830:	100007b7          	lui	a5,0x10000
    80000834:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	420080e7          	jalr	1056(ra) # 80000c58 <pop_off>
}
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084a:	00008797          	auipc	a5,0x8
    8000084e:	7ba7a783          	lw	a5,1978(a5) # 80009004 <uart_tx_r>
    80000852:	00008717          	auipc	a4,0x8
    80000856:	7b672703          	lw	a4,1974(a4) # 80009008 <uart_tx_w>
    8000085a:	08f70263          	beq	a4,a5,800008de <uartstart+0x94>
{
    8000085e:	7139                	addi	sp,sp,-64
    80000860:	fc06                	sd	ra,56(sp)
    80000862:	f822                	sd	s0,48(sp)
    80000864:	f426                	sd	s1,40(sp)
    80000866:	f04a                	sd	s2,32(sp)
    80000868:	ec4e                	sd	s3,24(sp)
    8000086a:	e852                	sd	s4,16(sp)
    8000086c:	e456                	sd	s5,8(sp)
    8000086e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000870:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    80000874:	00011a17          	auipc	s4,0x11
    80000878:	084a0a13          	addi	s4,s4,132 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000087c:	00008497          	auipc	s1,0x8
    80000880:	78848493          	addi	s1,s1,1928 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000884:	00008997          	auipc	s3,0x8
    80000888:	78498993          	addi	s3,s3,1924 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000088c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000890:	0ff77713          	andi	a4,a4,255
    80000894:	02077713          	andi	a4,a4,32
    80000898:	cb15                	beqz	a4,800008cc <uartstart+0x82>
    int c = uart_tx_buf[uart_tx_r];
    8000089a:	00fa0733          	add	a4,s4,a5
    8000089e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008a2:	2785                	addiw	a5,a5,1
    800008a4:	41f7d71b          	sraiw	a4,a5,0x1f
    800008a8:	01b7571b          	srliw	a4,a4,0x1b
    800008ac:	9fb9                	addw	a5,a5,a4
    800008ae:	8bfd                	andi	a5,a5,31
    800008b0:	9f99                	subw	a5,a5,a4
    800008b2:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008b4:	8526                	mv	a0,s1
    800008b6:	00002097          	auipc	ra,0x2
    800008ba:	b4a080e7          	jalr	-1206(ra) # 80002400 <wakeup>
    
    WriteReg(THR, c);
    800008be:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008c2:	409c                	lw	a5,0(s1)
    800008c4:	0009a703          	lw	a4,0(s3)
    800008c8:	fcf712e3          	bne	a4,a5,8000088c <uartstart+0x42>
  }
}
    800008cc:	70e2                	ld	ra,56(sp)
    800008ce:	7442                	ld	s0,48(sp)
    800008d0:	74a2                	ld	s1,40(sp)
    800008d2:	7902                	ld	s2,32(sp)
    800008d4:	69e2                	ld	s3,24(sp)
    800008d6:	6a42                	ld	s4,16(sp)
    800008d8:	6aa2                	ld	s5,8(sp)
    800008da:	6121                	addi	sp,sp,64
    800008dc:	8082                	ret
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    800008f2:	00011517          	auipc	a0,0x11
    800008f6:	00650513          	addi	a0,a0,6 # 800118f8 <uart_tx_lock>
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	30a080e7          	jalr	778(ra) # 80000c04 <acquire>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000902:	00008697          	auipc	a3,0x8
    80000906:	7066a683          	lw	a3,1798(a3) # 80009008 <uart_tx_w>
    8000090a:	0016871b          	addiw	a4,a3,1
    8000090e:	41f7579b          	sraiw	a5,a4,0x1f
    80000912:	01b7d61b          	srliw	a2,a5,0x1b
    80000916:	00c707bb          	addw	a5,a4,a2
    8000091a:	8bfd                	andi	a5,a5,31
    8000091c:	9f91                	subw	a5,a5,a2
    8000091e:	00008717          	auipc	a4,0x8
    80000922:	6e672703          	lw	a4,1766(a4) # 80009004 <uart_tx_r>
    80000926:	04f71363          	bne	a4,a5,8000096c <uartputc+0x8c>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000092a:	00011a17          	auipc	s4,0x11
    8000092e:	fcea0a13          	addi	s4,s4,-50 # 800118f8 <uart_tx_lock>
    80000932:	00008917          	auipc	s2,0x8
    80000936:	6d290913          	addi	s2,s2,1746 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000093a:	00008997          	auipc	s3,0x8
    8000093e:	6ce98993          	addi	s3,s3,1742 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000942:	85d2                	mv	a1,s4
    80000944:	854a                	mv	a0,s2
    80000946:	00002097          	auipc	ra,0x2
    8000094a:	934080e7          	jalr	-1740(ra) # 8000227a <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000094e:	0009a683          	lw	a3,0(s3)
    80000952:	0016879b          	addiw	a5,a3,1
    80000956:	41f7d71b          	sraiw	a4,a5,0x1f
    8000095a:	01b7571b          	srliw	a4,a4,0x1b
    8000095e:	9fb9                	addw	a5,a5,a4
    80000960:	8bfd                	andi	a5,a5,31
    80000962:	9f99                	subw	a5,a5,a4
    80000964:	00092703          	lw	a4,0(s2)
    80000968:	fcf70de3          	beq	a4,a5,80000942 <uartputc+0x62>
      uart_tx_buf[uart_tx_w] = c;
    8000096c:	00011917          	auipc	s2,0x11
    80000970:	f8c90913          	addi	s2,s2,-116 # 800118f8 <uart_tx_lock>
    80000974:	96ca                	add	a3,a3,s2
    80000976:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    8000097a:	00008717          	auipc	a4,0x8
    8000097e:	68f72723          	sw	a5,1678(a4) # 80009008 <uart_tx_w>
      uartstart();
    80000982:	00000097          	auipc	ra,0x0
    80000986:	ec8080e7          	jalr	-312(ra) # 8000084a <uartstart>
      release(&uart_tx_lock);
    8000098a:	854a                	mv	a0,s2
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	32c080e7          	jalr	812(ra) # 80000cb8 <release>
}
    80000994:	70a2                	ld	ra,40(sp)
    80000996:	7402                	ld	s0,32(sp)
    80000998:	64e2                	ld	s1,24(sp)
    8000099a:	6942                	ld	s2,16(sp)
    8000099c:	69a2                	ld	s3,8(sp)
    8000099e:	6a02                	ld	s4,0(sp)
    800009a0:	6145                	addi	sp,sp,48
    800009a2:	8082                	ret

00000000800009a4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009a4:	1141                	addi	sp,sp,-16
    800009a6:	e422                	sd	s0,8(sp)
    800009a8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009aa:	100007b7          	lui	a5,0x10000
    800009ae:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009b2:	8b85                	andi	a5,a5,1
    800009b4:	cb81                	beqz	a5,800009c4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800009b6:	100007b7          	lui	a5,0x10000
    800009ba:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009be:	6422                	ld	s0,8(sp)
    800009c0:	0141                	addi	sp,sp,16
    800009c2:	8082                	ret
    return -1;
    800009c4:	557d                	li	a0,-1
    800009c6:	bfe5                	j	800009be <uartgetc+0x1a>

00000000800009c8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009c8:	1101                	addi	sp,sp,-32
    800009ca:	ec06                	sd	ra,24(sp)
    800009cc:	e822                	sd	s0,16(sp)
    800009ce:	e426                	sd	s1,8(sp)
    800009d0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009d2:	54fd                	li	s1,-1
    int c = uartgetc();
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	fd0080e7          	jalr	-48(ra) # 800009a4 <uartgetc>
    if(c == -1)
    800009dc:	00950763          	beq	a0,s1,800009ea <uartintr+0x22>
      break;
    consoleintr(c);
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	8f4080e7          	jalr	-1804(ra) # 800002d4 <consoleintr>
  while(1){
    800009e8:	b7f5                	j	800009d4 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ea:	00011497          	auipc	s1,0x11
    800009ee:	f0e48493          	addi	s1,s1,-242 # 800118f8 <uart_tx_lock>
    800009f2:	8526                	mv	a0,s1
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	210080e7          	jalr	528(ra) # 80000c04 <acquire>
  uartstart();
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	e4e080e7          	jalr	-434(ra) # 8000084a <uartstart>
  release(&uart_tx_lock);
    80000a04:	8526                	mv	a0,s1
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	2b2080e7          	jalr	690(ra) # 80000cb8 <release>
}
    80000a0e:	60e2                	ld	ra,24(sp)
    80000a10:	6442                	ld	s0,16(sp)
    80000a12:	64a2                	ld	s1,8(sp)
    80000a14:	6105                	addi	sp,sp,32
    80000a16:	8082                	ret

0000000080000a18 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	e04a                	sd	s2,0(sp)
    80000a22:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a24:	03451793          	slli	a5,a0,0x34
    80000a28:	ebb9                	bnez	a5,80000a7e <kfree+0x66>
    80000a2a:	84aa                	mv	s1,a0
    80000a2c:	00025797          	auipc	a5,0x25
    80000a30:	5d478793          	addi	a5,a5,1492 # 80026000 <end>
    80000a34:	04f56563          	bltu	a0,a5,80000a7e <kfree+0x66>
    80000a38:	47c5                	li	a5,17
    80000a3a:	07ee                	slli	a5,a5,0x1b
    80000a3c:	04f57163          	bgeu	a0,a5,80000a7e <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a40:	6605                	lui	a2,0x1
    80000a42:	4585                	li	a1,1
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	2bc080e7          	jalr	700(ra) # 80000d00 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a4c:	00011917          	auipc	s2,0x11
    80000a50:	ee490913          	addi	s2,s2,-284 # 80011930 <kmem>
    80000a54:	854a                	mv	a0,s2
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	1ae080e7          	jalr	430(ra) # 80000c04 <acquire>
  r->next = kmem.freelist;
    80000a5e:	01893783          	ld	a5,24(s2)
    80000a62:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a64:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a68:	854a                	mv	a0,s2
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	24e080e7          	jalr	590(ra) # 80000cb8 <release>
}
    80000a72:	60e2                	ld	ra,24(sp)
    80000a74:	6442                	ld	s0,16(sp)
    80000a76:	64a2                	ld	s1,8(sp)
    80000a78:	6902                	ld	s2,0(sp)
    80000a7a:	6105                	addi	sp,sp,32
    80000a7c:	8082                	ret
    panic("kfree");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	5e250513          	addi	a0,a0,1506 # 80008060 <digits+0x20>
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	ace080e7          	jalr	-1330(ra) # 80000554 <panic>

0000000080000a8e <freerange>:
{
    80000a8e:	7179                	addi	sp,sp,-48
    80000a90:	f406                	sd	ra,40(sp)
    80000a92:	f022                	sd	s0,32(sp)
    80000a94:	ec26                	sd	s1,24(sp)
    80000a96:	e84a                	sd	s2,16(sp)
    80000a98:	e44e                	sd	s3,8(sp)
    80000a9a:	e052                	sd	s4,0(sp)
    80000a9c:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a9e:	6785                	lui	a5,0x1
    80000aa0:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000aa4:	94aa                	add	s1,s1,a0
    80000aa6:	757d                	lui	a0,0xfffff
    80000aa8:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aaa:	94be                	add	s1,s1,a5
    80000aac:	0095ee63          	bltu	a1,s1,80000ac8 <freerange+0x3a>
    80000ab0:	892e                	mv	s2,a1
    kfree(p);
    80000ab2:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab4:	6985                	lui	s3,0x1
    kfree(p);
    80000ab6:	01448533          	add	a0,s1,s4
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	f5e080e7          	jalr	-162(ra) # 80000a18 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac2:	94ce                	add	s1,s1,s3
    80000ac4:	fe9979e3          	bgeu	s2,s1,80000ab6 <freerange+0x28>
}
    80000ac8:	70a2                	ld	ra,40(sp)
    80000aca:	7402                	ld	s0,32(sp)
    80000acc:	64e2                	ld	s1,24(sp)
    80000ace:	6942                	ld	s2,16(sp)
    80000ad0:	69a2                	ld	s3,8(sp)
    80000ad2:	6a02                	ld	s4,0(sp)
    80000ad4:	6145                	addi	sp,sp,48
    80000ad6:	8082                	ret

0000000080000ad8 <kinit>:
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ae0:	00007597          	auipc	a1,0x7
    80000ae4:	58858593          	addi	a1,a1,1416 # 80008068 <digits+0x28>
    80000ae8:	00011517          	auipc	a0,0x11
    80000aec:	e4850513          	addi	a0,a0,-440 # 80011930 <kmem>
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	084080e7          	jalr	132(ra) # 80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000af8:	45c5                	li	a1,17
    80000afa:	05ee                	slli	a1,a1,0x1b
    80000afc:	00025517          	auipc	a0,0x25
    80000b00:	50450513          	addi	a0,a0,1284 # 80026000 <end>
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	f8a080e7          	jalr	-118(ra) # 80000a8e <freerange>
}
    80000b0c:	60a2                	ld	ra,8(sp)
    80000b0e:	6402                	ld	s0,0(sp)
    80000b10:	0141                	addi	sp,sp,16
    80000b12:	8082                	ret

0000000080000b14 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b14:	1101                	addi	sp,sp,-32
    80000b16:	ec06                	sd	ra,24(sp)
    80000b18:	e822                	sd	s0,16(sp)
    80000b1a:	e426                	sd	s1,8(sp)
    80000b1c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b1e:	00011497          	auipc	s1,0x11
    80000b22:	e1248493          	addi	s1,s1,-494 # 80011930 <kmem>
    80000b26:	8526                	mv	a0,s1
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	0dc080e7          	jalr	220(ra) # 80000c04 <acquire>
  r = kmem.freelist;
    80000b30:	6c84                	ld	s1,24(s1)
  if(r)
    80000b32:	c885                	beqz	s1,80000b62 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b34:	609c                	ld	a5,0(s1)
    80000b36:	00011517          	auipc	a0,0x11
    80000b3a:	dfa50513          	addi	a0,a0,-518 # 80011930 <kmem>
    80000b3e:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b40:	00000097          	auipc	ra,0x0
    80000b44:	178080e7          	jalr	376(ra) # 80000cb8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b48:	6605                	lui	a2,0x1
    80000b4a:	4595                	li	a1,5
    80000b4c:	8526                	mv	a0,s1
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	1b2080e7          	jalr	434(ra) # 80000d00 <memset>
  return (void*)r;
}
    80000b56:	8526                	mv	a0,s1
    80000b58:	60e2                	ld	ra,24(sp)
    80000b5a:	6442                	ld	s0,16(sp)
    80000b5c:	64a2                	ld	s1,8(sp)
    80000b5e:	6105                	addi	sp,sp,32
    80000b60:	8082                	ret
  release(&kmem.lock);
    80000b62:	00011517          	auipc	a0,0x11
    80000b66:	dce50513          	addi	a0,a0,-562 # 80011930 <kmem>
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	14e080e7          	jalr	334(ra) # 80000cb8 <release>
  if(r)
    80000b72:	b7d5                	j	80000b56 <kalloc+0x42>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	00001097          	auipc	ra,0x1
    80000ba2:	ed8080e7          	jalr	-296(ra) # 80001a76 <mycpu>
    80000ba6:	40a48533          	sub	a0,s1,a0
    80000baa:	00153513          	seqz	a0,a0
}
    80000bae:	60e2                	ld	ra,24(sp)
    80000bb0:	6442                	ld	s0,16(sp)
    80000bb2:	64a2                	ld	s1,8(sp)
    80000bb4:	6105                	addi	sp,sp,32
    80000bb6:	8082                	ret

0000000080000bb8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb8:	1101                	addi	sp,sp,-32
    80000bba:	ec06                	sd	ra,24(sp)
    80000bbc:	e822                	sd	s0,16(sp)
    80000bbe:	e426                	sd	s1,8(sp)
    80000bc0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc2:	100024f3          	csrr	s1,sstatus
    80000bc6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bca:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bcc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bd0:	00001097          	auipc	ra,0x1
    80000bd4:	ea6080e7          	jalr	-346(ra) # 80001a76 <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	cf89                	beqz	a5,80000bf4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bdc:	00001097          	auipc	ra,0x1
    80000be0:	e9a080e7          	jalr	-358(ra) # 80001a76 <mycpu>
    80000be4:	5d3c                	lw	a5,120(a0)
    80000be6:	2785                	addiw	a5,a5,1
    80000be8:	dd3c                	sw	a5,120(a0)
}
    80000bea:	60e2                	ld	ra,24(sp)
    80000bec:	6442                	ld	s0,16(sp)
    80000bee:	64a2                	ld	s1,8(sp)
    80000bf0:	6105                	addi	sp,sp,32
    80000bf2:	8082                	ret
    mycpu()->intena = old;
    80000bf4:	00001097          	auipc	ra,0x1
    80000bf8:	e82080e7          	jalr	-382(ra) # 80001a76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bfc:	8085                	srli	s1,s1,0x1
    80000bfe:	8885                	andi	s1,s1,1
    80000c00:	dd64                	sw	s1,124(a0)
    80000c02:	bfe9                	j	80000bdc <push_off+0x24>

0000000080000c04 <acquire>:
{
    80000c04:	1101                	addi	sp,sp,-32
    80000c06:	ec06                	sd	ra,24(sp)
    80000c08:	e822                	sd	s0,16(sp)
    80000c0a:	e426                	sd	s1,8(sp)
    80000c0c:	1000                	addi	s0,sp,32
    80000c0e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c10:	00000097          	auipc	ra,0x0
    80000c14:	fa8080e7          	jalr	-88(ra) # 80000bb8 <push_off>
  if(holding(lk))
    80000c18:	8526                	mv	a0,s1
    80000c1a:	00000097          	auipc	ra,0x0
    80000c1e:	f70080e7          	jalr	-144(ra) # 80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c22:	4705                	li	a4,1
  if(holding(lk))
    80000c24:	e115                	bnez	a0,80000c48 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c26:	87ba                	mv	a5,a4
    80000c28:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c2c:	2781                	sext.w	a5,a5
    80000c2e:	ffe5                	bnez	a5,80000c26 <acquire+0x22>
  __sync_synchronize();
    80000c30:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c34:	00001097          	auipc	ra,0x1
    80000c38:	e42080e7          	jalr	-446(ra) # 80001a76 <mycpu>
    80000c3c:	e888                	sd	a0,16(s1)
}
    80000c3e:	60e2                	ld	ra,24(sp)
    80000c40:	6442                	ld	s0,16(sp)
    80000c42:	64a2                	ld	s1,8(sp)
    80000c44:	6105                	addi	sp,sp,32
    80000c46:	8082                	ret
    panic("acquire");
    80000c48:	00007517          	auipc	a0,0x7
    80000c4c:	42850513          	addi	a0,a0,1064 # 80008070 <digits+0x30>
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	904080e7          	jalr	-1788(ra) # 80000554 <panic>

0000000080000c58 <pop_off>:

void
pop_off(void)
{
    80000c58:	1141                	addi	sp,sp,-16
    80000c5a:	e406                	sd	ra,8(sp)
    80000c5c:	e022                	sd	s0,0(sp)
    80000c5e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c60:	00001097          	auipc	ra,0x1
    80000c64:	e16080e7          	jalr	-490(ra) # 80001a76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c68:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c6c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c6e:	e78d                	bnez	a5,80000c98 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c70:	5d3c                	lw	a5,120(a0)
    80000c72:	02f05b63          	blez	a5,80000ca8 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c76:	37fd                	addiw	a5,a5,-1
    80000c78:	0007871b          	sext.w	a4,a5
    80000c7c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c7e:	eb09                	bnez	a4,80000c90 <pop_off+0x38>
    80000c80:	5d7c                	lw	a5,124(a0)
    80000c82:	c799                	beqz	a5,80000c90 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c8c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c90:	60a2                	ld	ra,8(sp)
    80000c92:	6402                	ld	s0,0(sp)
    80000c94:	0141                	addi	sp,sp,16
    80000c96:	8082                	ret
    panic("pop_off - interruptible");
    80000c98:	00007517          	auipc	a0,0x7
    80000c9c:	3e050513          	addi	a0,a0,992 # 80008078 <digits+0x38>
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	8b4080e7          	jalr	-1868(ra) # 80000554 <panic>
    panic("pop_off");
    80000ca8:	00007517          	auipc	a0,0x7
    80000cac:	3e850513          	addi	a0,a0,1000 # 80008090 <digits+0x50>
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	8a4080e7          	jalr	-1884(ra) # 80000554 <panic>

0000000080000cb8 <release>:
{
    80000cb8:	1101                	addi	sp,sp,-32
    80000cba:	ec06                	sd	ra,24(sp)
    80000cbc:	e822                	sd	s0,16(sp)
    80000cbe:	e426                	sd	s1,8(sp)
    80000cc0:	1000                	addi	s0,sp,32
    80000cc2:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	ec6080e7          	jalr	-314(ra) # 80000b8a <holding>
    80000ccc:	c115                	beqz	a0,80000cf0 <release+0x38>
  lk->cpu = 0;
    80000cce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cd6:	0f50000f          	fence	iorw,ow
    80000cda:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	f7a080e7          	jalr	-134(ra) # 80000c58 <pop_off>
}
    80000ce6:	60e2                	ld	ra,24(sp)
    80000ce8:	6442                	ld	s0,16(sp)
    80000cea:	64a2                	ld	s1,8(sp)
    80000cec:	6105                	addi	sp,sp,32
    80000cee:	8082                	ret
    panic("release");
    80000cf0:	00007517          	auipc	a0,0x7
    80000cf4:	3a850513          	addi	a0,a0,936 # 80008098 <digits+0x58>
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	85c080e7          	jalr	-1956(ra) # 80000554 <panic>

0000000080000d00 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d00:	1141                	addi	sp,sp,-16
    80000d02:	e422                	sd	s0,8(sp)
    80000d04:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d06:	ce09                	beqz	a2,80000d20 <memset+0x20>
    80000d08:	87aa                	mv	a5,a0
    80000d0a:	fff6071b          	addiw	a4,a2,-1
    80000d0e:	1702                	slli	a4,a4,0x20
    80000d10:	9301                	srli	a4,a4,0x20
    80000d12:	0705                	addi	a4,a4,1
    80000d14:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d16:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d1a:	0785                	addi	a5,a5,1
    80000d1c:	fee79de3          	bne	a5,a4,80000d16 <memset+0x16>
  }
  return dst;
}
    80000d20:	6422                	ld	s0,8(sp)
    80000d22:	0141                	addi	sp,sp,16
    80000d24:	8082                	ret

0000000080000d26 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e422                	sd	s0,8(sp)
    80000d2a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d2c:	ca05                	beqz	a2,80000d5c <memcmp+0x36>
    80000d2e:	fff6069b          	addiw	a3,a2,-1
    80000d32:	1682                	slli	a3,a3,0x20
    80000d34:	9281                	srli	a3,a3,0x20
    80000d36:	0685                	addi	a3,a3,1
    80000d38:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d3a:	00054783          	lbu	a5,0(a0)
    80000d3e:	0005c703          	lbu	a4,0(a1)
    80000d42:	00e79863          	bne	a5,a4,80000d52 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d46:	0505                	addi	a0,a0,1
    80000d48:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d4a:	fed518e3          	bne	a0,a3,80000d3a <memcmp+0x14>
  }

  return 0;
    80000d4e:	4501                	li	a0,0
    80000d50:	a019                	j	80000d56 <memcmp+0x30>
      return *s1 - *s2;
    80000d52:	40e7853b          	subw	a0,a5,a4
}
    80000d56:	6422                	ld	s0,8(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret
  return 0;
    80000d5c:	4501                	li	a0,0
    80000d5e:	bfe5                	j	80000d56 <memcmp+0x30>

0000000080000d60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d60:	1141                	addi	sp,sp,-16
    80000d62:	e422                	sd	s0,8(sp)
    80000d64:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d66:	02a5e563          	bltu	a1,a0,80000d90 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d6a:	fff6069b          	addiw	a3,a2,-1
    80000d6e:	ce11                	beqz	a2,80000d8a <memmove+0x2a>
    80000d70:	1682                	slli	a3,a3,0x20
    80000d72:	9281                	srli	a3,a3,0x20
    80000d74:	0685                	addi	a3,a3,1
    80000d76:	96ae                	add	a3,a3,a1
    80000d78:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d7a:	0585                	addi	a1,a1,1
    80000d7c:	0785                	addi	a5,a5,1
    80000d7e:	fff5c703          	lbu	a4,-1(a1)
    80000d82:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d86:	fed59ae3          	bne	a1,a3,80000d7a <memmove+0x1a>

  return dst;
}
    80000d8a:	6422                	ld	s0,8(sp)
    80000d8c:	0141                	addi	sp,sp,16
    80000d8e:	8082                	ret
  if(s < d && s + n > d){
    80000d90:	02061713          	slli	a4,a2,0x20
    80000d94:	9301                	srli	a4,a4,0x20
    80000d96:	00e587b3          	add	a5,a1,a4
    80000d9a:	fcf578e3          	bgeu	a0,a5,80000d6a <memmove+0xa>
    d += n;
    80000d9e:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000da0:	fff6069b          	addiw	a3,a2,-1
    80000da4:	d27d                	beqz	a2,80000d8a <memmove+0x2a>
    80000da6:	02069613          	slli	a2,a3,0x20
    80000daa:	9201                	srli	a2,a2,0x20
    80000dac:	fff64613          	not	a2,a2
    80000db0:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000db2:	17fd                	addi	a5,a5,-1
    80000db4:	177d                	addi	a4,a4,-1
    80000db6:	0007c683          	lbu	a3,0(a5)
    80000dba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000dbe:	fec79ae3          	bne	a5,a2,80000db2 <memmove+0x52>
    80000dc2:	b7e1                	j	80000d8a <memmove+0x2a>

0000000080000dc4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dc4:	1141                	addi	sp,sp,-16
    80000dc6:	e406                	sd	ra,8(sp)
    80000dc8:	e022                	sd	s0,0(sp)
    80000dca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dcc:	00000097          	auipc	ra,0x0
    80000dd0:	f94080e7          	jalr	-108(ra) # 80000d60 <memmove>
}
    80000dd4:	60a2                	ld	ra,8(sp)
    80000dd6:	6402                	ld	s0,0(sp)
    80000dd8:	0141                	addi	sp,sp,16
    80000dda:	8082                	ret

0000000080000ddc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000ddc:	1141                	addi	sp,sp,-16
    80000dde:	e422                	sd	s0,8(sp)
    80000de0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000de2:	ce11                	beqz	a2,80000dfe <strncmp+0x22>
    80000de4:	00054783          	lbu	a5,0(a0)
    80000de8:	cf89                	beqz	a5,80000e02 <strncmp+0x26>
    80000dea:	0005c703          	lbu	a4,0(a1)
    80000dee:	00f71a63          	bne	a4,a5,80000e02 <strncmp+0x26>
    n--, p++, q++;
    80000df2:	367d                	addiw	a2,a2,-1
    80000df4:	0505                	addi	a0,a0,1
    80000df6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000df8:	f675                	bnez	a2,80000de4 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dfa:	4501                	li	a0,0
    80000dfc:	a809                	j	80000e0e <strncmp+0x32>
    80000dfe:	4501                	li	a0,0
    80000e00:	a039                	j	80000e0e <strncmp+0x32>
  if(n == 0)
    80000e02:	ca09                	beqz	a2,80000e14 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e04:	00054503          	lbu	a0,0(a0)
    80000e08:	0005c783          	lbu	a5,0(a1)
    80000e0c:	9d1d                	subw	a0,a0,a5
}
    80000e0e:	6422                	ld	s0,8(sp)
    80000e10:	0141                	addi	sp,sp,16
    80000e12:	8082                	ret
    return 0;
    80000e14:	4501                	li	a0,0
    80000e16:	bfe5                	j	80000e0e <strncmp+0x32>

0000000080000e18 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e1e:	872a                	mv	a4,a0
    80000e20:	8832                	mv	a6,a2
    80000e22:	367d                	addiw	a2,a2,-1
    80000e24:	01005963          	blez	a6,80000e36 <strncpy+0x1e>
    80000e28:	0705                	addi	a4,a4,1
    80000e2a:	0005c783          	lbu	a5,0(a1)
    80000e2e:	fef70fa3          	sb	a5,-1(a4)
    80000e32:	0585                	addi	a1,a1,1
    80000e34:	f7f5                	bnez	a5,80000e20 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e36:	86ba                	mv	a3,a4
    80000e38:	00c05c63          	blez	a2,80000e50 <strncpy+0x38>
    *s++ = 0;
    80000e3c:	0685                	addi	a3,a3,1
    80000e3e:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e42:	fff6c793          	not	a5,a3
    80000e46:	9fb9                	addw	a5,a5,a4
    80000e48:	010787bb          	addw	a5,a5,a6
    80000e4c:	fef048e3          	bgtz	a5,80000e3c <strncpy+0x24>
  return os;
}
    80000e50:	6422                	ld	s0,8(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret

0000000080000e56 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e56:	1141                	addi	sp,sp,-16
    80000e58:	e422                	sd	s0,8(sp)
    80000e5a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e5c:	02c05363          	blez	a2,80000e82 <safestrcpy+0x2c>
    80000e60:	fff6069b          	addiw	a3,a2,-1
    80000e64:	1682                	slli	a3,a3,0x20
    80000e66:	9281                	srli	a3,a3,0x20
    80000e68:	96ae                	add	a3,a3,a1
    80000e6a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e6c:	00d58963          	beq	a1,a3,80000e7e <safestrcpy+0x28>
    80000e70:	0585                	addi	a1,a1,1
    80000e72:	0785                	addi	a5,a5,1
    80000e74:	fff5c703          	lbu	a4,-1(a1)
    80000e78:	fee78fa3          	sb	a4,-1(a5)
    80000e7c:	fb65                	bnez	a4,80000e6c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e7e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e82:	6422                	ld	s0,8(sp)
    80000e84:	0141                	addi	sp,sp,16
    80000e86:	8082                	ret

0000000080000e88 <strlen>:

int
strlen(const char *s)
{
    80000e88:	1141                	addi	sp,sp,-16
    80000e8a:	e422                	sd	s0,8(sp)
    80000e8c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e8e:	00054783          	lbu	a5,0(a0)
    80000e92:	cf91                	beqz	a5,80000eae <strlen+0x26>
    80000e94:	0505                	addi	a0,a0,1
    80000e96:	87aa                	mv	a5,a0
    80000e98:	4685                	li	a3,1
    80000e9a:	9e89                	subw	a3,a3,a0
    80000e9c:	00f6853b          	addw	a0,a3,a5
    80000ea0:	0785                	addi	a5,a5,1
    80000ea2:	fff7c703          	lbu	a4,-1(a5)
    80000ea6:	fb7d                	bnez	a4,80000e9c <strlen+0x14>
    ;
  return n;
}
    80000ea8:	6422                	ld	s0,8(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eae:	4501                	li	a0,0
    80000eb0:	bfe5                	j	80000ea8 <strlen+0x20>

0000000080000eb2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eb2:	1141                	addi	sp,sp,-16
    80000eb4:	e406                	sd	ra,8(sp)
    80000eb6:	e022                	sd	s0,0(sp)
    80000eb8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eba:	00001097          	auipc	ra,0x1
    80000ebe:	bac080e7          	jalr	-1108(ra) # 80001a66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ec2:	00008717          	auipc	a4,0x8
    80000ec6:	14a70713          	addi	a4,a4,330 # 8000900c <started>
  if(cpuid() == 0){
    80000eca:	c139                	beqz	a0,80000f10 <main+0x5e>
    while(started == 0)
    80000ecc:	431c                	lw	a5,0(a4)
    80000ece:	2781                	sext.w	a5,a5
    80000ed0:	dff5                	beqz	a5,80000ecc <main+0x1a>
      ;
    __sync_synchronize();
    80000ed2:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	b90080e7          	jalr	-1136(ra) # 80001a66 <cpuid>
    80000ede:	85aa                	mv	a1,a0
    80000ee0:	00007517          	auipc	a0,0x7
    80000ee4:	1d850513          	addi	a0,a0,472 # 800080b8 <digits+0x78>
    80000ee8:	fffff097          	auipc	ra,0xfffff
    80000eec:	6b6080e7          	jalr	1718(ra) # 8000059e <printf>
    kvminithart();    // turn on paging
    80000ef0:	00000097          	auipc	ra,0x0
    80000ef4:	0d8080e7          	jalr	216(ra) # 80000fc8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ef8:	00002097          	auipc	ra,0x2
    80000efc:	802080e7          	jalr	-2046(ra) # 800026fa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	da0080e7          	jalr	-608(ra) # 80005ca0 <plicinithart>
  }

  scheduler();        
    80000f08:	00001097          	auipc	ra,0x1
    80000f0c:	0b6080e7          	jalr	182(ra) # 80001fbe <scheduler>
    consoleinit();
    80000f10:	fffff097          	auipc	ra,0xfffff
    80000f14:	556080e7          	jalr	1366(ra) # 80000466 <consoleinit>
    printfinit();
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	86c080e7          	jalr	-1940(ra) # 80000784 <printfinit>
    printf("\n");
    80000f20:	00007517          	auipc	a0,0x7
    80000f24:	1a850513          	addi	a0,a0,424 # 800080c8 <digits+0x88>
    80000f28:	fffff097          	auipc	ra,0xfffff
    80000f2c:	676080e7          	jalr	1654(ra) # 8000059e <printf>
    printf("xv6 kernel is booting\n");
    80000f30:	00007517          	auipc	a0,0x7
    80000f34:	17050513          	addi	a0,a0,368 # 800080a0 <digits+0x60>
    80000f38:	fffff097          	auipc	ra,0xfffff
    80000f3c:	666080e7          	jalr	1638(ra) # 8000059e <printf>
    printf("\n");
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	18850513          	addi	a0,a0,392 # 800080c8 <digits+0x88>
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	656080e7          	jalr	1622(ra) # 8000059e <printf>
    kinit();         // physical page allocator
    80000f50:	00000097          	auipc	ra,0x0
    80000f54:	b88080e7          	jalr	-1144(ra) # 80000ad8 <kinit>
    kvminit();       // create kernel page table
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	2a0080e7          	jalr	672(ra) # 800011f8 <kvminit>
    kvminithart();   // turn on paging
    80000f60:	00000097          	auipc	ra,0x0
    80000f64:	068080e7          	jalr	104(ra) # 80000fc8 <kvminithart>
    procinit();      // process table
    80000f68:	00001097          	auipc	ra,0x1
    80000f6c:	a2e080e7          	jalr	-1490(ra) # 80001996 <procinit>
    trapinit();      // trap vectors
    80000f70:	00001097          	auipc	ra,0x1
    80000f74:	762080e7          	jalr	1890(ra) # 800026d2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	782080e7          	jalr	1922(ra) # 800026fa <trapinithart>
    plicinit();      // set up interrupt controller
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	d0a080e7          	jalr	-758(ra) # 80005c8a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f88:	00005097          	auipc	ra,0x5
    80000f8c:	d18080e7          	jalr	-744(ra) # 80005ca0 <plicinithart>
    binit();         // buffer cache
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	ebe080e7          	jalr	-322(ra) # 80002e4e <binit>
    iinit();         // inode cache
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	54e080e7          	jalr	1358(ra) # 800034e6 <iinit>
    fileinit();      // file table
    80000fa0:	00003097          	auipc	ra,0x3
    80000fa4:	4e8080e7          	jalr	1256(ra) # 80004488 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	e00080e7          	jalr	-512(ra) # 80005da8 <virtio_disk_init>
    userinit();      // first user process
    80000fb0:	00001097          	auipc	ra,0x1
    80000fb4:	da8080e7          	jalr	-600(ra) # 80001d58 <userinit>
    __sync_synchronize();
    80000fb8:	0ff0000f          	fence
    started = 1;
    80000fbc:	4785                	li	a5,1
    80000fbe:	00008717          	auipc	a4,0x8
    80000fc2:	04f72723          	sw	a5,78(a4) # 8000900c <started>
    80000fc6:	b789                	j	80000f08 <main+0x56>

0000000080000fc8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fc8:	1141                	addi	sp,sp,-16
    80000fca:	e422                	sd	s0,8(sp)
    80000fcc:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fce:	00008797          	auipc	a5,0x8
    80000fd2:	0427b783          	ld	a5,66(a5) # 80009010 <kernel_pagetable>
    80000fd6:	83b1                	srli	a5,a5,0xc
    80000fd8:	577d                	li	a4,-1
    80000fda:	177e                	slli	a4,a4,0x3f
    80000fdc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fde:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fe2:	12000073          	sfence.vma
  sfence_vma();
}
    80000fe6:	6422                	ld	s0,8(sp)
    80000fe8:	0141                	addi	sp,sp,16
    80000fea:	8082                	ret

0000000080000fec <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fec:	7139                	addi	sp,sp,-64
    80000fee:	fc06                	sd	ra,56(sp)
    80000ff0:	f822                	sd	s0,48(sp)
    80000ff2:	f426                	sd	s1,40(sp)
    80000ff4:	f04a                	sd	s2,32(sp)
    80000ff6:	ec4e                	sd	s3,24(sp)
    80000ff8:	e852                	sd	s4,16(sp)
    80000ffa:	e456                	sd	s5,8(sp)
    80000ffc:	e05a                	sd	s6,0(sp)
    80000ffe:	0080                	addi	s0,sp,64
    80001000:	84aa                	mv	s1,a0
    80001002:	89ae                	mv	s3,a1
    80001004:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001006:	57fd                	li	a5,-1
    80001008:	83e9                	srli	a5,a5,0x1a
    8000100a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000100c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000100e:	04b7f263          	bgeu	a5,a1,80001052 <walk+0x66>
    panic("walk");
    80001012:	00007517          	auipc	a0,0x7
    80001016:	0be50513          	addi	a0,a0,190 # 800080d0 <digits+0x90>
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	53a080e7          	jalr	1338(ra) # 80000554 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001022:	060a8663          	beqz	s5,8000108e <walk+0xa2>
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	aee080e7          	jalr	-1298(ra) # 80000b14 <kalloc>
    8000102e:	84aa                	mv	s1,a0
    80001030:	c529                	beqz	a0,8000107a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001032:	6605                	lui	a2,0x1
    80001034:	4581                	li	a1,0
    80001036:	00000097          	auipc	ra,0x0
    8000103a:	cca080e7          	jalr	-822(ra) # 80000d00 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000103e:	00c4d793          	srli	a5,s1,0xc
    80001042:	07aa                	slli	a5,a5,0xa
    80001044:	0017e793          	ori	a5,a5,1
    80001048:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000104c:	3a5d                	addiw	s4,s4,-9
    8000104e:	036a0063          	beq	s4,s6,8000106e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001052:	0149d933          	srl	s2,s3,s4
    80001056:	1ff97913          	andi	s2,s2,511
    8000105a:	090e                	slli	s2,s2,0x3
    8000105c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000105e:	00093483          	ld	s1,0(s2)
    80001062:	0014f793          	andi	a5,s1,1
    80001066:	dfd5                	beqz	a5,80001022 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001068:	80a9                	srli	s1,s1,0xa
    8000106a:	04b2                	slli	s1,s1,0xc
    8000106c:	b7c5                	j	8000104c <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000106e:	00c9d513          	srli	a0,s3,0xc
    80001072:	1ff57513          	andi	a0,a0,511
    80001076:	050e                	slli	a0,a0,0x3
    80001078:	9526                	add	a0,a0,s1
}
    8000107a:	70e2                	ld	ra,56(sp)
    8000107c:	7442                	ld	s0,48(sp)
    8000107e:	74a2                	ld	s1,40(sp)
    80001080:	7902                	ld	s2,32(sp)
    80001082:	69e2                	ld	s3,24(sp)
    80001084:	6a42                	ld	s4,16(sp)
    80001086:	6aa2                	ld	s5,8(sp)
    80001088:	6b02                	ld	s6,0(sp)
    8000108a:	6121                	addi	sp,sp,64
    8000108c:	8082                	ret
        return 0;
    8000108e:	4501                	li	a0,0
    80001090:	b7ed                	j	8000107a <walk+0x8e>

0000000080001092 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001092:	57fd                	li	a5,-1
    80001094:	83e9                	srli	a5,a5,0x1a
    80001096:	00b7f463          	bgeu	a5,a1,8000109e <walkaddr+0xc>
    return 0;
    8000109a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000109c:	8082                	ret
{
    8000109e:	1141                	addi	sp,sp,-16
    800010a0:	e406                	sd	ra,8(sp)
    800010a2:	e022                	sd	s0,0(sp)
    800010a4:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010a6:	4601                	li	a2,0
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	f44080e7          	jalr	-188(ra) # 80000fec <walk>
  if(pte == 0)
    800010b0:	c105                	beqz	a0,800010d0 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010b2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010b4:	0117f693          	andi	a3,a5,17
    800010b8:	4745                	li	a4,17
    return 0;
    800010ba:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010bc:	00e68663          	beq	a3,a4,800010c8 <walkaddr+0x36>
}
    800010c0:	60a2                	ld	ra,8(sp)
    800010c2:	6402                	ld	s0,0(sp)
    800010c4:	0141                	addi	sp,sp,16
    800010c6:	8082                	ret
  pa = PTE2PA(*pte);
    800010c8:	00a7d513          	srli	a0,a5,0xa
    800010cc:	0532                	slli	a0,a0,0xc
  return pa;
    800010ce:	bfcd                	j	800010c0 <walkaddr+0x2e>
    return 0;
    800010d0:	4501                	li	a0,0
    800010d2:	b7fd                	j	800010c0 <walkaddr+0x2e>

00000000800010d4 <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    800010d4:	1101                	addi	sp,sp,-32
    800010d6:	ec06                	sd	ra,24(sp)
    800010d8:	e822                	sd	s0,16(sp)
    800010da:	e426                	sd	s1,8(sp)
    800010dc:	1000                	addi	s0,sp,32
    800010de:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800010e0:	03451493          	slli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    800010e4:	4601                	li	a2,0
    800010e6:	00008517          	auipc	a0,0x8
    800010ea:	f2a53503          	ld	a0,-214(a0) # 80009010 <kernel_pagetable>
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	efe080e7          	jalr	-258(ra) # 80000fec <walk>
  if(pte == 0)
    800010f6:	cd11                	beqz	a0,80001112 <kvmpa+0x3e>
    800010f8:	90d1                	srli	s1,s1,0x34
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    800010fa:	6108                	ld	a0,0(a0)
    800010fc:	00157793          	andi	a5,a0,1
    80001100:	c38d                	beqz	a5,80001122 <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    80001102:	8129                	srli	a0,a0,0xa
    80001104:	0532                	slli	a0,a0,0xc
  return pa+off;
}
    80001106:	9526                	add	a0,a0,s1
    80001108:	60e2                	ld	ra,24(sp)
    8000110a:	6442                	ld	s0,16(sp)
    8000110c:	64a2                	ld	s1,8(sp)
    8000110e:	6105                	addi	sp,sp,32
    80001110:	8082                	ret
    panic("kvmpa");
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fc650513          	addi	a0,a0,-58 # 800080d8 <digits+0x98>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	43a080e7          	jalr	1082(ra) # 80000554 <panic>
    panic("kvmpa");
    80001122:	00007517          	auipc	a0,0x7
    80001126:	fb650513          	addi	a0,a0,-74 # 800080d8 <digits+0x98>
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	42a080e7          	jalr	1066(ra) # 80000554 <panic>

0000000080001132 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001132:	715d                	addi	sp,sp,-80
    80001134:	e486                	sd	ra,72(sp)
    80001136:	e0a2                	sd	s0,64(sp)
    80001138:	fc26                	sd	s1,56(sp)
    8000113a:	f84a                	sd	s2,48(sp)
    8000113c:	f44e                	sd	s3,40(sp)
    8000113e:	f052                	sd	s4,32(sp)
    80001140:	ec56                	sd	s5,24(sp)
    80001142:	e85a                	sd	s6,16(sp)
    80001144:	e45e                	sd	s7,8(sp)
    80001146:	0880                	addi	s0,sp,80
    80001148:	8aaa                	mv	s5,a0
    8000114a:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    8000114c:	777d                	lui	a4,0xfffff
    8000114e:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001152:	167d                	addi	a2,a2,-1
    80001154:	00b609b3          	add	s3,a2,a1
    80001158:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000115c:	893e                	mv	s2,a5
    8000115e:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001162:	6b85                	lui	s7,0x1
    80001164:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001168:	4605                	li	a2,1
    8000116a:	85ca                	mv	a1,s2
    8000116c:	8556                	mv	a0,s5
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	e7e080e7          	jalr	-386(ra) # 80000fec <walk>
    80001176:	c51d                	beqz	a0,800011a4 <mappages+0x72>
    if(*pte & PTE_V)
    80001178:	611c                	ld	a5,0(a0)
    8000117a:	8b85                	andi	a5,a5,1
    8000117c:	ef81                	bnez	a5,80001194 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000117e:	80b1                	srli	s1,s1,0xc
    80001180:	04aa                	slli	s1,s1,0xa
    80001182:	0164e4b3          	or	s1,s1,s6
    80001186:	0014e493          	ori	s1,s1,1
    8000118a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000118c:	03390863          	beq	s2,s3,800011bc <mappages+0x8a>
    a += PGSIZE;
    80001190:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001192:	bfc9                	j	80001164 <mappages+0x32>
      panic("remap");
    80001194:	00007517          	auipc	a0,0x7
    80001198:	f4c50513          	addi	a0,a0,-180 # 800080e0 <digits+0xa0>
    8000119c:	fffff097          	auipc	ra,0xfffff
    800011a0:	3b8080e7          	jalr	952(ra) # 80000554 <panic>
      return -1;
    800011a4:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011a6:	60a6                	ld	ra,72(sp)
    800011a8:	6406                	ld	s0,64(sp)
    800011aa:	74e2                	ld	s1,56(sp)
    800011ac:	7942                	ld	s2,48(sp)
    800011ae:	79a2                	ld	s3,40(sp)
    800011b0:	7a02                	ld	s4,32(sp)
    800011b2:	6ae2                	ld	s5,24(sp)
    800011b4:	6b42                	ld	s6,16(sp)
    800011b6:	6ba2                	ld	s7,8(sp)
    800011b8:	6161                	addi	sp,sp,80
    800011ba:	8082                	ret
  return 0;
    800011bc:	4501                	li	a0,0
    800011be:	b7e5                	j	800011a6 <mappages+0x74>

00000000800011c0 <kvmmap>:
{
    800011c0:	1141                	addi	sp,sp,-16
    800011c2:	e406                	sd	ra,8(sp)
    800011c4:	e022                	sd	s0,0(sp)
    800011c6:	0800                	addi	s0,sp,16
    800011c8:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800011ca:	86ae                	mv	a3,a1
    800011cc:	85aa                	mv	a1,a0
    800011ce:	00008517          	auipc	a0,0x8
    800011d2:	e4253503          	ld	a0,-446(a0) # 80009010 <kernel_pagetable>
    800011d6:	00000097          	auipc	ra,0x0
    800011da:	f5c080e7          	jalr	-164(ra) # 80001132 <mappages>
    800011de:	e509                	bnez	a0,800011e8 <kvmmap+0x28>
}
    800011e0:	60a2                	ld	ra,8(sp)
    800011e2:	6402                	ld	s0,0(sp)
    800011e4:	0141                	addi	sp,sp,16
    800011e6:	8082                	ret
    panic("kvmmap");
    800011e8:	00007517          	auipc	a0,0x7
    800011ec:	f0050513          	addi	a0,a0,-256 # 800080e8 <digits+0xa8>
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	364080e7          	jalr	868(ra) # 80000554 <panic>

00000000800011f8 <kvminit>:
{
    800011f8:	1101                	addi	sp,sp,-32
    800011fa:	ec06                	sd	ra,24(sp)
    800011fc:	e822                	sd	s0,16(sp)
    800011fe:	e426                	sd	s1,8(sp)
    80001200:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001202:	00000097          	auipc	ra,0x0
    80001206:	912080e7          	jalr	-1774(ra) # 80000b14 <kalloc>
    8000120a:	00008797          	auipc	a5,0x8
    8000120e:	e0a7b323          	sd	a0,-506(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001212:	6605                	lui	a2,0x1
    80001214:	4581                	li	a1,0
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	aea080e7          	jalr	-1302(ra) # 80000d00 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000121e:	4699                	li	a3,6
    80001220:	6605                	lui	a2,0x1
    80001222:	100005b7          	lui	a1,0x10000
    80001226:	10000537          	lui	a0,0x10000
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	f96080e7          	jalr	-106(ra) # 800011c0 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001232:	4699                	li	a3,6
    80001234:	6605                	lui	a2,0x1
    80001236:	100015b7          	lui	a1,0x10001
    8000123a:	10001537          	lui	a0,0x10001
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	f82080e7          	jalr	-126(ra) # 800011c0 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001246:	4699                	li	a3,6
    80001248:	6641                	lui	a2,0x10
    8000124a:	020005b7          	lui	a1,0x2000
    8000124e:	02000537          	lui	a0,0x2000
    80001252:	00000097          	auipc	ra,0x0
    80001256:	f6e080e7          	jalr	-146(ra) # 800011c0 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000125a:	4699                	li	a3,6
    8000125c:	00400637          	lui	a2,0x400
    80001260:	0c0005b7          	lui	a1,0xc000
    80001264:	0c000537          	lui	a0,0xc000
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	f58080e7          	jalr	-168(ra) # 800011c0 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001270:	00007497          	auipc	s1,0x7
    80001274:	d9048493          	addi	s1,s1,-624 # 80008000 <etext>
    80001278:	46a9                	li	a3,10
    8000127a:	80007617          	auipc	a2,0x80007
    8000127e:	d8660613          	addi	a2,a2,-634 # 8000 <_entry-0x7fff8000>
    80001282:	4585                	li	a1,1
    80001284:	05fe                	slli	a1,a1,0x1f
    80001286:	852e                	mv	a0,a1
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	f38080e7          	jalr	-200(ra) # 800011c0 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001290:	4699                	li	a3,6
    80001292:	4645                	li	a2,17
    80001294:	066e                	slli	a2,a2,0x1b
    80001296:	8e05                	sub	a2,a2,s1
    80001298:	85a6                	mv	a1,s1
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	f24080e7          	jalr	-220(ra) # 800011c0 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012a4:	46a9                	li	a3,10
    800012a6:	6605                	lui	a2,0x1
    800012a8:	00006597          	auipc	a1,0x6
    800012ac:	d5858593          	addi	a1,a1,-680 # 80007000 <_trampoline>
    800012b0:	04000537          	lui	a0,0x4000
    800012b4:	157d                	addi	a0,a0,-1
    800012b6:	0532                	slli	a0,a0,0xc
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	f08080e7          	jalr	-248(ra) # 800011c0 <kvmmap>
}
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6105                	addi	sp,sp,32
    800012c8:	8082                	ret

00000000800012ca <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012ca:	715d                	addi	sp,sp,-80
    800012cc:	e486                	sd	ra,72(sp)
    800012ce:	e0a2                	sd	s0,64(sp)
    800012d0:	fc26                	sd	s1,56(sp)
    800012d2:	f84a                	sd	s2,48(sp)
    800012d4:	f44e                	sd	s3,40(sp)
    800012d6:	f052                	sd	s4,32(sp)
    800012d8:	ec56                	sd	s5,24(sp)
    800012da:	e85a                	sd	s6,16(sp)
    800012dc:	e45e                	sd	s7,8(sp)
    800012de:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012e0:	03459793          	slli	a5,a1,0x34
    800012e4:	e795                	bnez	a5,80001310 <uvmunmap+0x46>
    800012e6:	8a2a                	mv	s4,a0
    800012e8:	892e                	mv	s2,a1
    800012ea:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ec:	0632                	slli	a2,a2,0xc
    800012ee:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012f2:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012f4:	6b05                	lui	s6,0x1
    800012f6:	0735e863          	bltu	a1,s3,80001366 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012fa:	60a6                	ld	ra,72(sp)
    800012fc:	6406                	ld	s0,64(sp)
    800012fe:	74e2                	ld	s1,56(sp)
    80001300:	7942                	ld	s2,48(sp)
    80001302:	79a2                	ld	s3,40(sp)
    80001304:	7a02                	ld	s4,32(sp)
    80001306:	6ae2                	ld	s5,24(sp)
    80001308:	6b42                	ld	s6,16(sp)
    8000130a:	6ba2                	ld	s7,8(sp)
    8000130c:	6161                	addi	sp,sp,80
    8000130e:	8082                	ret
    panic("uvmunmap: not aligned");
    80001310:	00007517          	auipc	a0,0x7
    80001314:	de050513          	addi	a0,a0,-544 # 800080f0 <digits+0xb0>
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	23c080e7          	jalr	572(ra) # 80000554 <panic>
      panic("uvmunmap: walk");
    80001320:	00007517          	auipc	a0,0x7
    80001324:	de850513          	addi	a0,a0,-536 # 80008108 <digits+0xc8>
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	22c080e7          	jalr	556(ra) # 80000554 <panic>
      panic("uvmunmap: not mapped");
    80001330:	00007517          	auipc	a0,0x7
    80001334:	de850513          	addi	a0,a0,-536 # 80008118 <digits+0xd8>
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	21c080e7          	jalr	540(ra) # 80000554 <panic>
      panic("uvmunmap: not a leaf");
    80001340:	00007517          	auipc	a0,0x7
    80001344:	df050513          	addi	a0,a0,-528 # 80008130 <digits+0xf0>
    80001348:	fffff097          	auipc	ra,0xfffff
    8000134c:	20c080e7          	jalr	524(ra) # 80000554 <panic>
      uint64 pa = PTE2PA(*pte);
    80001350:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001352:	0532                	slli	a0,a0,0xc
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	6c4080e7          	jalr	1732(ra) # 80000a18 <kfree>
    *pte = 0;
    8000135c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001360:	995a                	add	s2,s2,s6
    80001362:	f9397ce3          	bgeu	s2,s3,800012fa <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001366:	4601                	li	a2,0
    80001368:	85ca                	mv	a1,s2
    8000136a:	8552                	mv	a0,s4
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	c80080e7          	jalr	-896(ra) # 80000fec <walk>
    80001374:	84aa                	mv	s1,a0
    80001376:	d54d                	beqz	a0,80001320 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001378:	6108                	ld	a0,0(a0)
    8000137a:	00157793          	andi	a5,a0,1
    8000137e:	dbcd                	beqz	a5,80001330 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001380:	3ff57793          	andi	a5,a0,1023
    80001384:	fb778ee3          	beq	a5,s7,80001340 <uvmunmap+0x76>
    if(do_free){
    80001388:	fc0a8ae3          	beqz	s5,8000135c <uvmunmap+0x92>
    8000138c:	b7d1                	j	80001350 <uvmunmap+0x86>

000000008000138e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000138e:	1101                	addi	sp,sp,-32
    80001390:	ec06                	sd	ra,24(sp)
    80001392:	e822                	sd	s0,16(sp)
    80001394:	e426                	sd	s1,8(sp)
    80001396:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	77c080e7          	jalr	1916(ra) # 80000b14 <kalloc>
    800013a0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013a2:	c519                	beqz	a0,800013b0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013a4:	6605                	lui	a2,0x1
    800013a6:	4581                	li	a1,0
    800013a8:	00000097          	auipc	ra,0x0
    800013ac:	958080e7          	jalr	-1704(ra) # 80000d00 <memset>
  return pagetable;
}
    800013b0:	8526                	mv	a0,s1
    800013b2:	60e2                	ld	ra,24(sp)
    800013b4:	6442                	ld	s0,16(sp)
    800013b6:	64a2                	ld	s1,8(sp)
    800013b8:	6105                	addi	sp,sp,32
    800013ba:	8082                	ret

00000000800013bc <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013bc:	7179                	addi	sp,sp,-48
    800013be:	f406                	sd	ra,40(sp)
    800013c0:	f022                	sd	s0,32(sp)
    800013c2:	ec26                	sd	s1,24(sp)
    800013c4:	e84a                	sd	s2,16(sp)
    800013c6:	e44e                	sd	s3,8(sp)
    800013c8:	e052                	sd	s4,0(sp)
    800013ca:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013cc:	6785                	lui	a5,0x1
    800013ce:	04f67863          	bgeu	a2,a5,8000141e <uvminit+0x62>
    800013d2:	8a2a                	mv	s4,a0
    800013d4:	89ae                	mv	s3,a1
    800013d6:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013d8:	fffff097          	auipc	ra,0xfffff
    800013dc:	73c080e7          	jalr	1852(ra) # 80000b14 <kalloc>
    800013e0:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013e2:	6605                	lui	a2,0x1
    800013e4:	4581                	li	a1,0
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	91a080e7          	jalr	-1766(ra) # 80000d00 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013ee:	4779                	li	a4,30
    800013f0:	86ca                	mv	a3,s2
    800013f2:	6605                	lui	a2,0x1
    800013f4:	4581                	li	a1,0
    800013f6:	8552                	mv	a0,s4
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	d3a080e7          	jalr	-710(ra) # 80001132 <mappages>
  memmove(mem, src, sz);
    80001400:	8626                	mv	a2,s1
    80001402:	85ce                	mv	a1,s3
    80001404:	854a                	mv	a0,s2
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	95a080e7          	jalr	-1702(ra) # 80000d60 <memmove>
}
    8000140e:	70a2                	ld	ra,40(sp)
    80001410:	7402                	ld	s0,32(sp)
    80001412:	64e2                	ld	s1,24(sp)
    80001414:	6942                	ld	s2,16(sp)
    80001416:	69a2                	ld	s3,8(sp)
    80001418:	6a02                	ld	s4,0(sp)
    8000141a:	6145                	addi	sp,sp,48
    8000141c:	8082                	ret
    panic("inituvm: more than a page");
    8000141e:	00007517          	auipc	a0,0x7
    80001422:	d2a50513          	addi	a0,a0,-726 # 80008148 <digits+0x108>
    80001426:	fffff097          	auipc	ra,0xfffff
    8000142a:	12e080e7          	jalr	302(ra) # 80000554 <panic>

000000008000142e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000142e:	1101                	addi	sp,sp,-32
    80001430:	ec06                	sd	ra,24(sp)
    80001432:	e822                	sd	s0,16(sp)
    80001434:	e426                	sd	s1,8(sp)
    80001436:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001438:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000143a:	00b67d63          	bgeu	a2,a1,80001454 <uvmdealloc+0x26>
    8000143e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001440:	6785                	lui	a5,0x1
    80001442:	17fd                	addi	a5,a5,-1
    80001444:	00f60733          	add	a4,a2,a5
    80001448:	767d                	lui	a2,0xfffff
    8000144a:	8f71                	and	a4,a4,a2
    8000144c:	97ae                	add	a5,a5,a1
    8000144e:	8ff1                	and	a5,a5,a2
    80001450:	00f76863          	bltu	a4,a5,80001460 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001454:	8526                	mv	a0,s1
    80001456:	60e2                	ld	ra,24(sp)
    80001458:	6442                	ld	s0,16(sp)
    8000145a:	64a2                	ld	s1,8(sp)
    8000145c:	6105                	addi	sp,sp,32
    8000145e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001460:	8f99                	sub	a5,a5,a4
    80001462:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001464:	4685                	li	a3,1
    80001466:	0007861b          	sext.w	a2,a5
    8000146a:	85ba                	mv	a1,a4
    8000146c:	00000097          	auipc	ra,0x0
    80001470:	e5e080e7          	jalr	-418(ra) # 800012ca <uvmunmap>
    80001474:	b7c5                	j	80001454 <uvmdealloc+0x26>

0000000080001476 <uvmalloc>:
  if(newsz < oldsz)
    80001476:	0ab66163          	bltu	a2,a1,80001518 <uvmalloc+0xa2>
{
    8000147a:	7139                	addi	sp,sp,-64
    8000147c:	fc06                	sd	ra,56(sp)
    8000147e:	f822                	sd	s0,48(sp)
    80001480:	f426                	sd	s1,40(sp)
    80001482:	f04a                	sd	s2,32(sp)
    80001484:	ec4e                	sd	s3,24(sp)
    80001486:	e852                	sd	s4,16(sp)
    80001488:	e456                	sd	s5,8(sp)
    8000148a:	0080                	addi	s0,sp,64
    8000148c:	8aaa                	mv	s5,a0
    8000148e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001490:	6985                	lui	s3,0x1
    80001492:	19fd                	addi	s3,s3,-1
    80001494:	95ce                	add	a1,a1,s3
    80001496:	79fd                	lui	s3,0xfffff
    80001498:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000149c:	08c9f063          	bgeu	s3,a2,8000151c <uvmalloc+0xa6>
    800014a0:	894e                	mv	s2,s3
    mem = kalloc();
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	672080e7          	jalr	1650(ra) # 80000b14 <kalloc>
    800014aa:	84aa                	mv	s1,a0
    if(mem == 0){
    800014ac:	c51d                	beqz	a0,800014da <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014ae:	6605                	lui	a2,0x1
    800014b0:	4581                	li	a1,0
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	84e080e7          	jalr	-1970(ra) # 80000d00 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014ba:	4779                	li	a4,30
    800014bc:	86a6                	mv	a3,s1
    800014be:	6605                	lui	a2,0x1
    800014c0:	85ca                	mv	a1,s2
    800014c2:	8556                	mv	a0,s5
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	c6e080e7          	jalr	-914(ra) # 80001132 <mappages>
    800014cc:	e905                	bnez	a0,800014fc <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014ce:	6785                	lui	a5,0x1
    800014d0:	993e                	add	s2,s2,a5
    800014d2:	fd4968e3          	bltu	s2,s4,800014a2 <uvmalloc+0x2c>
  return newsz;
    800014d6:	8552                	mv	a0,s4
    800014d8:	a809                	j	800014ea <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014da:	864e                	mv	a2,s3
    800014dc:	85ca                	mv	a1,s2
    800014de:	8556                	mv	a0,s5
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f4e080e7          	jalr	-178(ra) # 8000142e <uvmdealloc>
      return 0;
    800014e8:	4501                	li	a0,0
}
    800014ea:	70e2                	ld	ra,56(sp)
    800014ec:	7442                	ld	s0,48(sp)
    800014ee:	74a2                	ld	s1,40(sp)
    800014f0:	7902                	ld	s2,32(sp)
    800014f2:	69e2                	ld	s3,24(sp)
    800014f4:	6a42                	ld	s4,16(sp)
    800014f6:	6aa2                	ld	s5,8(sp)
    800014f8:	6121                	addi	sp,sp,64
    800014fa:	8082                	ret
      kfree(mem);
    800014fc:	8526                	mv	a0,s1
    800014fe:	fffff097          	auipc	ra,0xfffff
    80001502:	51a080e7          	jalr	1306(ra) # 80000a18 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001506:	864e                	mv	a2,s3
    80001508:	85ca                	mv	a1,s2
    8000150a:	8556                	mv	a0,s5
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	f22080e7          	jalr	-222(ra) # 8000142e <uvmdealloc>
      return 0;
    80001514:	4501                	li	a0,0
    80001516:	bfd1                	j	800014ea <uvmalloc+0x74>
    return oldsz;
    80001518:	852e                	mv	a0,a1
}
    8000151a:	8082                	ret
  return newsz;
    8000151c:	8532                	mv	a0,a2
    8000151e:	b7f1                	j	800014ea <uvmalloc+0x74>

0000000080001520 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001520:	7179                	addi	sp,sp,-48
    80001522:	f406                	sd	ra,40(sp)
    80001524:	f022                	sd	s0,32(sp)
    80001526:	ec26                	sd	s1,24(sp)
    80001528:	e84a                	sd	s2,16(sp)
    8000152a:	e44e                	sd	s3,8(sp)
    8000152c:	e052                	sd	s4,0(sp)
    8000152e:	1800                	addi	s0,sp,48
    80001530:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001532:	84aa                	mv	s1,a0
    80001534:	6905                	lui	s2,0x1
    80001536:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001538:	4985                	li	s3,1
    8000153a:	a821                	j	80001552 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000153c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000153e:	0532                	slli	a0,a0,0xc
    80001540:	00000097          	auipc	ra,0x0
    80001544:	fe0080e7          	jalr	-32(ra) # 80001520 <freewalk>
      pagetable[i] = 0;
    80001548:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000154c:	04a1                	addi	s1,s1,8
    8000154e:	03248163          	beq	s1,s2,80001570 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001552:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001554:	00f57793          	andi	a5,a0,15
    80001558:	ff3782e3          	beq	a5,s3,8000153c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000155c:	8905                	andi	a0,a0,1
    8000155e:	d57d                	beqz	a0,8000154c <freewalk+0x2c>
      panic("freewalk: leaf");
    80001560:	00007517          	auipc	a0,0x7
    80001564:	c0850513          	addi	a0,a0,-1016 # 80008168 <digits+0x128>
    80001568:	fffff097          	auipc	ra,0xfffff
    8000156c:	fec080e7          	jalr	-20(ra) # 80000554 <panic>
    }
  }
  kfree((void*)pagetable);
    80001570:	8552                	mv	a0,s4
    80001572:	fffff097          	auipc	ra,0xfffff
    80001576:	4a6080e7          	jalr	1190(ra) # 80000a18 <kfree>
}
    8000157a:	70a2                	ld	ra,40(sp)
    8000157c:	7402                	ld	s0,32(sp)
    8000157e:	64e2                	ld	s1,24(sp)
    80001580:	6942                	ld	s2,16(sp)
    80001582:	69a2                	ld	s3,8(sp)
    80001584:	6a02                	ld	s4,0(sp)
    80001586:	6145                	addi	sp,sp,48
    80001588:	8082                	ret

000000008000158a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000158a:	1101                	addi	sp,sp,-32
    8000158c:	ec06                	sd	ra,24(sp)
    8000158e:	e822                	sd	s0,16(sp)
    80001590:	e426                	sd	s1,8(sp)
    80001592:	1000                	addi	s0,sp,32
    80001594:	84aa                	mv	s1,a0
  if(sz > 0)
    80001596:	e999                	bnez	a1,800015ac <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001598:	8526                	mv	a0,s1
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	f86080e7          	jalr	-122(ra) # 80001520 <freewalk>
}
    800015a2:	60e2                	ld	ra,24(sp)
    800015a4:	6442                	ld	s0,16(sp)
    800015a6:	64a2                	ld	s1,8(sp)
    800015a8:	6105                	addi	sp,sp,32
    800015aa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015ac:	6605                	lui	a2,0x1
    800015ae:	167d                	addi	a2,a2,-1
    800015b0:	962e                	add	a2,a2,a1
    800015b2:	4685                	li	a3,1
    800015b4:	8231                	srli	a2,a2,0xc
    800015b6:	4581                	li	a1,0
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	d12080e7          	jalr	-750(ra) # 800012ca <uvmunmap>
    800015c0:	bfe1                	j	80001598 <uvmfree+0xe>

00000000800015c2 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015c2:	c679                	beqz	a2,80001690 <uvmcopy+0xce>
{
    800015c4:	715d                	addi	sp,sp,-80
    800015c6:	e486                	sd	ra,72(sp)
    800015c8:	e0a2                	sd	s0,64(sp)
    800015ca:	fc26                	sd	s1,56(sp)
    800015cc:	f84a                	sd	s2,48(sp)
    800015ce:	f44e                	sd	s3,40(sp)
    800015d0:	f052                	sd	s4,32(sp)
    800015d2:	ec56                	sd	s5,24(sp)
    800015d4:	e85a                	sd	s6,16(sp)
    800015d6:	e45e                	sd	s7,8(sp)
    800015d8:	0880                	addi	s0,sp,80
    800015da:	8b2a                	mv	s6,a0
    800015dc:	8aae                	mv	s5,a1
    800015de:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015e0:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015e2:	4601                	li	a2,0
    800015e4:	85ce                	mv	a1,s3
    800015e6:	855a                	mv	a0,s6
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	a04080e7          	jalr	-1532(ra) # 80000fec <walk>
    800015f0:	c531                	beqz	a0,8000163c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015f2:	6118                	ld	a4,0(a0)
    800015f4:	00177793          	andi	a5,a4,1
    800015f8:	cbb1                	beqz	a5,8000164c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015fa:	00a75593          	srli	a1,a4,0xa
    800015fe:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001602:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001606:	fffff097          	auipc	ra,0xfffff
    8000160a:	50e080e7          	jalr	1294(ra) # 80000b14 <kalloc>
    8000160e:	892a                	mv	s2,a0
    80001610:	c939                	beqz	a0,80001666 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001612:	6605                	lui	a2,0x1
    80001614:	85de                	mv	a1,s7
    80001616:	fffff097          	auipc	ra,0xfffff
    8000161a:	74a080e7          	jalr	1866(ra) # 80000d60 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000161e:	8726                	mv	a4,s1
    80001620:	86ca                	mv	a3,s2
    80001622:	6605                	lui	a2,0x1
    80001624:	85ce                	mv	a1,s3
    80001626:	8556                	mv	a0,s5
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	b0a080e7          	jalr	-1270(ra) # 80001132 <mappages>
    80001630:	e515                	bnez	a0,8000165c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001632:	6785                	lui	a5,0x1
    80001634:	99be                	add	s3,s3,a5
    80001636:	fb49e6e3          	bltu	s3,s4,800015e2 <uvmcopy+0x20>
    8000163a:	a081                	j	8000167a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    8000163c:	00007517          	auipc	a0,0x7
    80001640:	b3c50513          	addi	a0,a0,-1220 # 80008178 <digits+0x138>
    80001644:	fffff097          	auipc	ra,0xfffff
    80001648:	f10080e7          	jalr	-240(ra) # 80000554 <panic>
      panic("uvmcopy: page not present");
    8000164c:	00007517          	auipc	a0,0x7
    80001650:	b4c50513          	addi	a0,a0,-1204 # 80008198 <digits+0x158>
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	f00080e7          	jalr	-256(ra) # 80000554 <panic>
      kfree(mem);
    8000165c:	854a                	mv	a0,s2
    8000165e:	fffff097          	auipc	ra,0xfffff
    80001662:	3ba080e7          	jalr	954(ra) # 80000a18 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001666:	4685                	li	a3,1
    80001668:	00c9d613          	srli	a2,s3,0xc
    8000166c:	4581                	li	a1,0
    8000166e:	8556                	mv	a0,s5
    80001670:	00000097          	auipc	ra,0x0
    80001674:	c5a080e7          	jalr	-934(ra) # 800012ca <uvmunmap>
  return -1;
    80001678:	557d                	li	a0,-1
}
    8000167a:	60a6                	ld	ra,72(sp)
    8000167c:	6406                	ld	s0,64(sp)
    8000167e:	74e2                	ld	s1,56(sp)
    80001680:	7942                	ld	s2,48(sp)
    80001682:	79a2                	ld	s3,40(sp)
    80001684:	7a02                	ld	s4,32(sp)
    80001686:	6ae2                	ld	s5,24(sp)
    80001688:	6b42                	ld	s6,16(sp)
    8000168a:	6ba2                	ld	s7,8(sp)
    8000168c:	6161                	addi	sp,sp,80
    8000168e:	8082                	ret
  return 0;
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret

0000000080001694 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001694:	1141                	addi	sp,sp,-16
    80001696:	e406                	sd	ra,8(sp)
    80001698:	e022                	sd	s0,0(sp)
    8000169a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000169c:	4601                	li	a2,0
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	94e080e7          	jalr	-1714(ra) # 80000fec <walk>
  if(pte == 0)
    800016a6:	c901                	beqz	a0,800016b6 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016a8:	611c                	ld	a5,0(a0)
    800016aa:	9bbd                	andi	a5,a5,-17
    800016ac:	e11c                	sd	a5,0(a0)
}
    800016ae:	60a2                	ld	ra,8(sp)
    800016b0:	6402                	ld	s0,0(sp)
    800016b2:	0141                	addi	sp,sp,16
    800016b4:	8082                	ret
    panic("uvmclear");
    800016b6:	00007517          	auipc	a0,0x7
    800016ba:	b0250513          	addi	a0,a0,-1278 # 800081b8 <digits+0x178>
    800016be:	fffff097          	auipc	ra,0xfffff
    800016c2:	e96080e7          	jalr	-362(ra) # 80000554 <panic>

00000000800016c6 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016c6:	c6bd                	beqz	a3,80001734 <copyout+0x6e>
{
    800016c8:	715d                	addi	sp,sp,-80
    800016ca:	e486                	sd	ra,72(sp)
    800016cc:	e0a2                	sd	s0,64(sp)
    800016ce:	fc26                	sd	s1,56(sp)
    800016d0:	f84a                	sd	s2,48(sp)
    800016d2:	f44e                	sd	s3,40(sp)
    800016d4:	f052                	sd	s4,32(sp)
    800016d6:	ec56                	sd	s5,24(sp)
    800016d8:	e85a                	sd	s6,16(sp)
    800016da:	e45e                	sd	s7,8(sp)
    800016dc:	e062                	sd	s8,0(sp)
    800016de:	0880                	addi	s0,sp,80
    800016e0:	8b2a                	mv	s6,a0
    800016e2:	8c2e                	mv	s8,a1
    800016e4:	8a32                	mv	s4,a2
    800016e6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016e8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016ea:	6a85                	lui	s5,0x1
    800016ec:	a015                	j	80001710 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016ee:	9562                	add	a0,a0,s8
    800016f0:	0004861b          	sext.w	a2,s1
    800016f4:	85d2                	mv	a1,s4
    800016f6:	41250533          	sub	a0,a0,s2
    800016fa:	fffff097          	auipc	ra,0xfffff
    800016fe:	666080e7          	jalr	1638(ra) # 80000d60 <memmove>

    len -= n;
    80001702:	409989b3          	sub	s3,s3,s1
    src += n;
    80001706:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001708:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000170c:	02098263          	beqz	s3,80001730 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001710:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001714:	85ca                	mv	a1,s2
    80001716:	855a                	mv	a0,s6
    80001718:	00000097          	auipc	ra,0x0
    8000171c:	97a080e7          	jalr	-1670(ra) # 80001092 <walkaddr>
    if(pa0 == 0)
    80001720:	cd01                	beqz	a0,80001738 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001722:	418904b3          	sub	s1,s2,s8
    80001726:	94d6                	add	s1,s1,s5
    if(n > len)
    80001728:	fc99f3e3          	bgeu	s3,s1,800016ee <copyout+0x28>
    8000172c:	84ce                	mv	s1,s3
    8000172e:	b7c1                	j	800016ee <copyout+0x28>
  }
  return 0;
    80001730:	4501                	li	a0,0
    80001732:	a021                	j	8000173a <copyout+0x74>
    80001734:	4501                	li	a0,0
}
    80001736:	8082                	ret
      return -1;
    80001738:	557d                	li	a0,-1
}
    8000173a:	60a6                	ld	ra,72(sp)
    8000173c:	6406                	ld	s0,64(sp)
    8000173e:	74e2                	ld	s1,56(sp)
    80001740:	7942                	ld	s2,48(sp)
    80001742:	79a2                	ld	s3,40(sp)
    80001744:	7a02                	ld	s4,32(sp)
    80001746:	6ae2                	ld	s5,24(sp)
    80001748:	6b42                	ld	s6,16(sp)
    8000174a:	6ba2                	ld	s7,8(sp)
    8000174c:	6c02                	ld	s8,0(sp)
    8000174e:	6161                	addi	sp,sp,80
    80001750:	8082                	ret

0000000080001752 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001752:	c6bd                	beqz	a3,800017c0 <copyin+0x6e>
{
    80001754:	715d                	addi	sp,sp,-80
    80001756:	e486                	sd	ra,72(sp)
    80001758:	e0a2                	sd	s0,64(sp)
    8000175a:	fc26                	sd	s1,56(sp)
    8000175c:	f84a                	sd	s2,48(sp)
    8000175e:	f44e                	sd	s3,40(sp)
    80001760:	f052                	sd	s4,32(sp)
    80001762:	ec56                	sd	s5,24(sp)
    80001764:	e85a                	sd	s6,16(sp)
    80001766:	e45e                	sd	s7,8(sp)
    80001768:	e062                	sd	s8,0(sp)
    8000176a:	0880                	addi	s0,sp,80
    8000176c:	8b2a                	mv	s6,a0
    8000176e:	8a2e                	mv	s4,a1
    80001770:	8c32                	mv	s8,a2
    80001772:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001774:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001776:	6a85                	lui	s5,0x1
    80001778:	a015                	j	8000179c <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000177a:	9562                	add	a0,a0,s8
    8000177c:	0004861b          	sext.w	a2,s1
    80001780:	412505b3          	sub	a1,a0,s2
    80001784:	8552                	mv	a0,s4
    80001786:	fffff097          	auipc	ra,0xfffff
    8000178a:	5da080e7          	jalr	1498(ra) # 80000d60 <memmove>

    len -= n;
    8000178e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001792:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001794:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001798:	02098263          	beqz	s3,800017bc <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    8000179c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017a0:	85ca                	mv	a1,s2
    800017a2:	855a                	mv	a0,s6
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	8ee080e7          	jalr	-1810(ra) # 80001092 <walkaddr>
    if(pa0 == 0)
    800017ac:	cd01                	beqz	a0,800017c4 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    800017ae:	418904b3          	sub	s1,s2,s8
    800017b2:	94d6                	add	s1,s1,s5
    if(n > len)
    800017b4:	fc99f3e3          	bgeu	s3,s1,8000177a <copyin+0x28>
    800017b8:	84ce                	mv	s1,s3
    800017ba:	b7c1                	j	8000177a <copyin+0x28>
  }
  return 0;
    800017bc:	4501                	li	a0,0
    800017be:	a021                	j	800017c6 <copyin+0x74>
    800017c0:	4501                	li	a0,0
}
    800017c2:	8082                	ret
      return -1;
    800017c4:	557d                	li	a0,-1
}
    800017c6:	60a6                	ld	ra,72(sp)
    800017c8:	6406                	ld	s0,64(sp)
    800017ca:	74e2                	ld	s1,56(sp)
    800017cc:	7942                	ld	s2,48(sp)
    800017ce:	79a2                	ld	s3,40(sp)
    800017d0:	7a02                	ld	s4,32(sp)
    800017d2:	6ae2                	ld	s5,24(sp)
    800017d4:	6b42                	ld	s6,16(sp)
    800017d6:	6ba2                	ld	s7,8(sp)
    800017d8:	6c02                	ld	s8,0(sp)
    800017da:	6161                	addi	sp,sp,80
    800017dc:	8082                	ret

00000000800017de <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017de:	c6c5                	beqz	a3,80001886 <copyinstr+0xa8>
{
    800017e0:	715d                	addi	sp,sp,-80
    800017e2:	e486                	sd	ra,72(sp)
    800017e4:	e0a2                	sd	s0,64(sp)
    800017e6:	fc26                	sd	s1,56(sp)
    800017e8:	f84a                	sd	s2,48(sp)
    800017ea:	f44e                	sd	s3,40(sp)
    800017ec:	f052                	sd	s4,32(sp)
    800017ee:	ec56                	sd	s5,24(sp)
    800017f0:	e85a                	sd	s6,16(sp)
    800017f2:	e45e                	sd	s7,8(sp)
    800017f4:	0880                	addi	s0,sp,80
    800017f6:	8a2a                	mv	s4,a0
    800017f8:	8b2e                	mv	s6,a1
    800017fa:	8bb2                	mv	s7,a2
    800017fc:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017fe:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001800:	6985                	lui	s3,0x1
    80001802:	a035                	j	8000182e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001804:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001808:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000180a:	0017b793          	seqz	a5,a5
    8000180e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001812:	60a6                	ld	ra,72(sp)
    80001814:	6406                	ld	s0,64(sp)
    80001816:	74e2                	ld	s1,56(sp)
    80001818:	7942                	ld	s2,48(sp)
    8000181a:	79a2                	ld	s3,40(sp)
    8000181c:	7a02                	ld	s4,32(sp)
    8000181e:	6ae2                	ld	s5,24(sp)
    80001820:	6b42                	ld	s6,16(sp)
    80001822:	6ba2                	ld	s7,8(sp)
    80001824:	6161                	addi	sp,sp,80
    80001826:	8082                	ret
    srcva = va0 + PGSIZE;
    80001828:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000182c:	c8a9                	beqz	s1,8000187e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    8000182e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001832:	85ca                	mv	a1,s2
    80001834:	8552                	mv	a0,s4
    80001836:	00000097          	auipc	ra,0x0
    8000183a:	85c080e7          	jalr	-1956(ra) # 80001092 <walkaddr>
    if(pa0 == 0)
    8000183e:	c131                	beqz	a0,80001882 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001840:	41790833          	sub	a6,s2,s7
    80001844:	984e                	add	a6,a6,s3
    if(n > max)
    80001846:	0104f363          	bgeu	s1,a6,8000184c <copyinstr+0x6e>
    8000184a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000184c:	955e                	add	a0,a0,s7
    8000184e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001852:	fc080be3          	beqz	a6,80001828 <copyinstr+0x4a>
    80001856:	985a                	add	a6,a6,s6
    80001858:	87da                	mv	a5,s6
      if(*p == '\0'){
    8000185a:	41650633          	sub	a2,a0,s6
    8000185e:	14fd                	addi	s1,s1,-1
    80001860:	9b26                	add	s6,s6,s1
    80001862:	00f60733          	add	a4,a2,a5
    80001866:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    8000186a:	df49                	beqz	a4,80001804 <copyinstr+0x26>
        *dst = *p;
    8000186c:	00e78023          	sb	a4,0(a5)
      --max;
    80001870:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001874:	0785                	addi	a5,a5,1
    while(n > 0){
    80001876:	ff0796e3          	bne	a5,a6,80001862 <copyinstr+0x84>
      dst++;
    8000187a:	8b42                	mv	s6,a6
    8000187c:	b775                	j	80001828 <copyinstr+0x4a>
    8000187e:	4781                	li	a5,0
    80001880:	b769                	j	8000180a <copyinstr+0x2c>
      return -1;
    80001882:	557d                	li	a0,-1
    80001884:	b779                	j	80001812 <copyinstr+0x34>
  int got_null = 0;
    80001886:	4781                	li	a5,0
  if(got_null){
    80001888:	0017b793          	seqz	a5,a5
    8000188c:	40f00533          	neg	a0,a5
}
    80001890:	8082                	ret

0000000080001892 <uvmmaptf>:

// Maps a trap frame and returns it's virtual address
uint64
uvmmaptf(pagetable_t pagetable, void *pa)
{
    80001892:	7139                	addi	sp,sp,-64
    80001894:	fc06                	sd	ra,56(sp)
    80001896:	f822                	sd	s0,48(sp)
    80001898:	f426                	sd	s1,40(sp)
    8000189a:	f04a                	sd	s2,32(sp)
    8000189c:	ec4e                	sd	s3,24(sp)
    8000189e:	e852                	sd	s4,16(sp)
    800018a0:	e456                	sd	s5,8(sp)
    800018a2:	0080                	addi	s0,sp,64
    800018a4:	8a2a                	mv	s4,a0
    800018a6:	84ae                	mv	s1,a1
  for (uint64 va = TRAPFRAME_TOP; va > TRAPFRAME_BOT; va -= PGSIZE) {
    800018a8:	02000937          	lui	s2,0x2000
    800018ac:	197d                	addi	s2,s2,-1
    800018ae:	0936                	slli	s2,s2,0xd
    800018b0:	7afd                	lui	s5,0xfffff
    800018b2:	020007b7          	lui	a5,0x2000
    800018b6:	fdf78793          	addi	a5,a5,-33 # 1ffffdf <_entry-0x7e000021>
    800018ba:	00d79993          	slli	s3,a5,0xd
    pte_t *pte = walk(pagetable, va, 1);
    800018be:	4605                	li	a2,1
    800018c0:	85ca                	mv	a1,s2
    800018c2:	8552                	mv	a0,s4
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	728080e7          	jalr	1832(ra) # 80000fec <walk>
    if(pte == 0)
    800018cc:	c11d                	beqz	a0,800018f2 <uvmmaptf+0x60>
      panic("uvmmaptf: out memory");
    if((*pte & PTE_V))
    800018ce:	611c                	ld	a5,0(a0)
    800018d0:	8b85                	andi	a5,a5,1
    800018d2:	eb85                	bnez	a5,80001902 <uvmmaptf+0x70>
      continue;
    *pte = PA2PTE(pa) | PTE_R | PTE_W | PTE_V;
    800018d4:	80b1                	srli	s1,s1,0xc
    800018d6:	04aa                	slli	s1,s1,0xa
    800018d8:	0074e493          	ori	s1,s1,7
    800018dc:	e104                	sd	s1,0(a0)
    return va;
  }
  return 0;
}
    800018de:	854a                	mv	a0,s2
    800018e0:	70e2                	ld	ra,56(sp)
    800018e2:	7442                	ld	s0,48(sp)
    800018e4:	74a2                	ld	s1,40(sp)
    800018e6:	7902                	ld	s2,32(sp)
    800018e8:	69e2                	ld	s3,24(sp)
    800018ea:	6a42                	ld	s4,16(sp)
    800018ec:	6aa2                	ld	s5,8(sp)
    800018ee:	6121                	addi	sp,sp,64
    800018f0:	8082                	ret
      panic("uvmmaptf: out memory");
    800018f2:	00007517          	auipc	a0,0x7
    800018f6:	8d650513          	addi	a0,a0,-1834 # 800081c8 <digits+0x188>
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	c5a080e7          	jalr	-934(ra) # 80000554 <panic>
  for (uint64 va = TRAPFRAME_TOP; va > TRAPFRAME_BOT; va -= PGSIZE) {
    80001902:	9956                	add	s2,s2,s5
    80001904:	fb391de3          	bne	s2,s3,800018be <uvmmaptf+0x2c>
  return 0;
    80001908:	4901                	li	s2,0
    8000190a:	bfd1                	j	800018de <uvmmaptf+0x4c>

000000008000190c <uvmunmaptf>:

// Unmaps a trap frame
void
uvmunmaptf(pagetable_t pagetable, uint64 va)
{
    8000190c:	1141                	addi	sp,sp,-16
    8000190e:	e406                	sd	ra,8(sp)
    80001910:	e022                	sd	s0,0(sp)
    80001912:	0800                	addi	s0,sp,16
  pte_t *pte;
  if (va <= TRAPFRAME_BOT || TRAPFRAME_TOP < va)
    80001914:	00006797          	auipc	a5,0x6
    80001918:	6ec7b783          	ld	a5,1772(a5) # 80008000 <etext>
    8000191c:	97ae                	add	a5,a5,a1
    8000191e:	00040737          	lui	a4,0x40
    80001922:	02e7f063          	bgeu	a5,a4,80001942 <uvmunmaptf+0x36>
    panic("uvmunmaptf: out of bounds");
  pte = walk(pagetable, PGROUNDDOWN(va), 0);
    80001926:	4601                	li	a2,0
    80001928:	77fd                	lui	a5,0xfffff
    8000192a:	8dfd                	and	a1,a1,a5
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	6c0080e7          	jalr	1728(ra) # 80000fec <walk>
  if(pte)
    80001934:	c119                	beqz	a0,8000193a <uvmunmaptf+0x2e>
    *pte = 0;
    80001936:	00053023          	sd	zero,0(a0)
}
    8000193a:	60a2                	ld	ra,8(sp)
    8000193c:	6402                	ld	s0,0(sp)
    8000193e:	0141                	addi	sp,sp,16
    80001940:	8082                	ret
    panic("uvmunmaptf: out of bounds");
    80001942:	00007517          	auipc	a0,0x7
    80001946:	89e50513          	addi	a0,a0,-1890 # 800081e0 <digits+0x1a0>
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	c0a080e7          	jalr	-1014(ra) # 80000554 <panic>

0000000080001952 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001952:	1101                	addi	sp,sp,-32
    80001954:	ec06                	sd	ra,24(sp)
    80001956:	e822                	sd	s0,16(sp)
    80001958:	e426                	sd	s1,8(sp)
    8000195a:	1000                	addi	s0,sp,32
    8000195c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	22c080e7          	jalr	556(ra) # 80000b8a <holding>
    80001966:	c909                	beqz	a0,80001978 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001968:	749c                	ld	a5,40(s1)
    8000196a:	00978f63          	beq	a5,s1,80001988 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    8000196e:	60e2                	ld	ra,24(sp)
    80001970:	6442                	ld	s0,16(sp)
    80001972:	64a2                	ld	s1,8(sp)
    80001974:	6105                	addi	sp,sp,32
    80001976:	8082                	ret
    panic("wakeup1");
    80001978:	00007517          	auipc	a0,0x7
    8000197c:	88850513          	addi	a0,a0,-1912 # 80008200 <digits+0x1c0>
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	bd4080e7          	jalr	-1068(ra) # 80000554 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001988:	4c98                	lw	a4,24(s1)
    8000198a:	4785                	li	a5,1
    8000198c:	fef711e3          	bne	a4,a5,8000196e <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001990:	4789                	li	a5,2
    80001992:	cc9c                	sw	a5,24(s1)
}
    80001994:	bfe9                	j	8000196e <wakeup1+0x1c>

0000000080001996 <procinit>:
{
    80001996:	715d                	addi	sp,sp,-80
    80001998:	e486                	sd	ra,72(sp)
    8000199a:	e0a2                	sd	s0,64(sp)
    8000199c:	fc26                	sd	s1,56(sp)
    8000199e:	f84a                	sd	s2,48(sp)
    800019a0:	f44e                	sd	s3,40(sp)
    800019a2:	f052                	sd	s4,32(sp)
    800019a4:	ec56                	sd	s5,24(sp)
    800019a6:	e85a                	sd	s6,16(sp)
    800019a8:	e45e                	sd	s7,8(sp)
    800019aa:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    800019ac:	00007597          	auipc	a1,0x7
    800019b0:	85c58593          	addi	a1,a1,-1956 # 80008208 <digits+0x1c8>
    800019b4:	00010517          	auipc	a0,0x10
    800019b8:	f9c50513          	addi	a0,a0,-100 # 80011950 <pid_lock>
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	1b8080e7          	jalr	440(ra) # 80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019c4:	00010917          	auipc	s2,0x10
    800019c8:	3a490913          	addi	s2,s2,932 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    800019cc:	00007b97          	auipc	s7,0x7
    800019d0:	844b8b93          	addi	s7,s7,-1980 # 80008210 <digits+0x1d0>
      uint64 va = KSTACK((int) (p - proc));
    800019d4:	8b4a                	mv	s6,s2
    800019d6:	00006a97          	auipc	s5,0x6
    800019da:	632a8a93          	addi	s5,s5,1586 # 80008008 <etext+0x8>
    800019de:	040009b7          	lui	s3,0x4000
    800019e2:	19fd                	addi	s3,s3,-1
    800019e4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019e6:	00016a17          	auipc	s4,0x16
    800019ea:	f82a0a13          	addi	s4,s4,-126 # 80017968 <tickslock>
      initlock(&p->lock, "proc");
    800019ee:	85de                	mv	a1,s7
    800019f0:	854a                	mv	a0,s2
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	182080e7          	jalr	386(ra) # 80000b74 <initlock>
      char *pa = kalloc();
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	11a080e7          	jalr	282(ra) # 80000b14 <kalloc>
    80001a02:	85aa                	mv	a1,a0
      if(pa == 0)
    80001a04:	c929                	beqz	a0,80001a56 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    80001a06:	416904b3          	sub	s1,s2,s6
    80001a0a:	8491                	srai	s1,s1,0x4
    80001a0c:	000ab783          	ld	a5,0(s5)
    80001a10:	02f484b3          	mul	s1,s1,a5
    80001a14:	2485                	addiw	s1,s1,1
    80001a16:	00d4949b          	slliw	s1,s1,0xd
    80001a1a:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a1e:	4699                	li	a3,6
    80001a20:	6605                	lui	a2,0x1
    80001a22:	8526                	mv	a0,s1
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	79c080e7          	jalr	1948(ra) # 800011c0 <kvmmap>
      p->kstack = va;
    80001a2c:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a30:	17090913          	addi	s2,s2,368
    80001a34:	fb491de3          	bne	s2,s4,800019ee <procinit+0x58>
  kvminithart();
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	590080e7          	jalr	1424(ra) # 80000fc8 <kvminithart>
}
    80001a40:	60a6                	ld	ra,72(sp)
    80001a42:	6406                	ld	s0,64(sp)
    80001a44:	74e2                	ld	s1,56(sp)
    80001a46:	7942                	ld	s2,48(sp)
    80001a48:	79a2                	ld	s3,40(sp)
    80001a4a:	7a02                	ld	s4,32(sp)
    80001a4c:	6ae2                	ld	s5,24(sp)
    80001a4e:	6b42                	ld	s6,16(sp)
    80001a50:	6ba2                	ld	s7,8(sp)
    80001a52:	6161                	addi	sp,sp,80
    80001a54:	8082                	ret
        panic("kalloc");
    80001a56:	00006517          	auipc	a0,0x6
    80001a5a:	7c250513          	addi	a0,a0,1986 # 80008218 <digits+0x1d8>
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	af6080e7          	jalr	-1290(ra) # 80000554 <panic>

0000000080001a66 <cpuid>:
{
    80001a66:	1141                	addi	sp,sp,-16
    80001a68:	e422                	sd	s0,8(sp)
    80001a6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a6c:	8512                	mv	a0,tp
}
    80001a6e:	2501                	sext.w	a0,a0
    80001a70:	6422                	ld	s0,8(sp)
    80001a72:	0141                	addi	sp,sp,16
    80001a74:	8082                	ret

0000000080001a76 <mycpu>:
mycpu(void) {
    80001a76:	1141                	addi	sp,sp,-16
    80001a78:	e422                	sd	s0,8(sp)
    80001a7a:	0800                	addi	s0,sp,16
    80001a7c:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a7e:	2781                	sext.w	a5,a5
    80001a80:	079e                	slli	a5,a5,0x7
}
    80001a82:	00010517          	auipc	a0,0x10
    80001a86:	ee650513          	addi	a0,a0,-282 # 80011968 <cpus>
    80001a8a:	953e                	add	a0,a0,a5
    80001a8c:	6422                	ld	s0,8(sp)
    80001a8e:	0141                	addi	sp,sp,16
    80001a90:	8082                	ret

0000000080001a92 <myproc>:
myproc(void) {
    80001a92:	1101                	addi	sp,sp,-32
    80001a94:	ec06                	sd	ra,24(sp)
    80001a96:	e822                	sd	s0,16(sp)
    80001a98:	e426                	sd	s1,8(sp)
    80001a9a:	1000                	addi	s0,sp,32
  push_off();
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	11c080e7          	jalr	284(ra) # 80000bb8 <push_off>
    80001aa4:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001aa6:	2781                	sext.w	a5,a5
    80001aa8:	079e                	slli	a5,a5,0x7
    80001aaa:	00010717          	auipc	a4,0x10
    80001aae:	ea670713          	addi	a4,a4,-346 # 80011950 <pid_lock>
    80001ab2:	97ba                	add	a5,a5,a4
    80001ab4:	6f84                	ld	s1,24(a5)
  pop_off();
    80001ab6:	fffff097          	auipc	ra,0xfffff
    80001aba:	1a2080e7          	jalr	418(ra) # 80000c58 <pop_off>
}
    80001abe:	8526                	mv	a0,s1
    80001ac0:	60e2                	ld	ra,24(sp)
    80001ac2:	6442                	ld	s0,16(sp)
    80001ac4:	64a2                	ld	s1,8(sp)
    80001ac6:	6105                	addi	sp,sp,32
    80001ac8:	8082                	ret

0000000080001aca <forkret>:
{
    80001aca:	1141                	addi	sp,sp,-16
    80001acc:	e406                	sd	ra,8(sp)
    80001ace:	e022                	sd	s0,0(sp)
    80001ad0:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001ad2:	00000097          	auipc	ra,0x0
    80001ad6:	fc0080e7          	jalr	-64(ra) # 80001a92 <myproc>
    80001ada:	fffff097          	auipc	ra,0xfffff
    80001ade:	1de080e7          	jalr	478(ra) # 80000cb8 <release>
  if (first) {
    80001ae2:	00007797          	auipc	a5,0x7
    80001ae6:	d8e7a783          	lw	a5,-626(a5) # 80008870 <first.1674>
    80001aea:	eb89                	bnez	a5,80001afc <forkret+0x32>
  usertrapret();
    80001aec:	00001097          	auipc	ra,0x1
    80001af0:	c26080e7          	jalr	-986(ra) # 80002712 <usertrapret>
}
    80001af4:	60a2                	ld	ra,8(sp)
    80001af6:	6402                	ld	s0,0(sp)
    80001af8:	0141                	addi	sp,sp,16
    80001afa:	8082                	ret
    first = 0;
    80001afc:	00007797          	auipc	a5,0x7
    80001b00:	d607aa23          	sw	zero,-652(a5) # 80008870 <first.1674>
    fsinit(ROOTDEV);
    80001b04:	4505                	li	a0,1
    80001b06:	00002097          	auipc	ra,0x2
    80001b0a:	960080e7          	jalr	-1696(ra) # 80003466 <fsinit>
    80001b0e:	bff9                	j	80001aec <forkret+0x22>

0000000080001b10 <allocpid>:
allocpid() {
    80001b10:	1101                	addi	sp,sp,-32
    80001b12:	ec06                	sd	ra,24(sp)
    80001b14:	e822                	sd	s0,16(sp)
    80001b16:	e426                	sd	s1,8(sp)
    80001b18:	e04a                	sd	s2,0(sp)
    80001b1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b1c:	00010917          	auipc	s2,0x10
    80001b20:	e3490913          	addi	s2,s2,-460 # 80011950 <pid_lock>
    80001b24:	854a                	mv	a0,s2
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	0de080e7          	jalr	222(ra) # 80000c04 <acquire>
  pid = nextpid;
    80001b2e:	00007797          	auipc	a5,0x7
    80001b32:	d4678793          	addi	a5,a5,-698 # 80008874 <nextpid>
    80001b36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b38:	0014871b          	addiw	a4,s1,1
    80001b3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b3e:	854a                	mv	a0,s2
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	178080e7          	jalr	376(ra) # 80000cb8 <release>
}
    80001b48:	8526                	mv	a0,s1
    80001b4a:	60e2                	ld	ra,24(sp)
    80001b4c:	6442                	ld	s0,16(sp)
    80001b4e:	64a2                	ld	s1,8(sp)
    80001b50:	6902                	ld	s2,0(sp)
    80001b52:	6105                	addi	sp,sp,32
    80001b54:	8082                	ret

0000000080001b56 <proc_pagetable>:
{
    80001b56:	1101                	addi	sp,sp,-32
    80001b58:	ec06                	sd	ra,24(sp)
    80001b5a:	e822                	sd	s0,16(sp)
    80001b5c:	e426                	sd	s1,8(sp)
    80001b5e:	e04a                	sd	s2,0(sp)
    80001b60:	1000                	addi	s0,sp,32
    80001b62:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b64:	00000097          	auipc	ra,0x0
    80001b68:	82a080e7          	jalr	-2006(ra) # 8000138e <uvmcreate>
    80001b6c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b6e:	c91d                	beqz	a0,80001ba4 <proc_pagetable+0x4e>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b70:	4729                	li	a4,10
    80001b72:	00005697          	auipc	a3,0x5
    80001b76:	48e68693          	addi	a3,a3,1166 # 80007000 <_trampoline>
    80001b7a:	6605                	lui	a2,0x1
    80001b7c:	040005b7          	lui	a1,0x4000
    80001b80:	15fd                	addi	a1,a1,-1
    80001b82:	05b2                	slli	a1,a1,0xc
    80001b84:	fffff097          	auipc	ra,0xfffff
    80001b88:	5ae080e7          	jalr	1454(ra) # 80001132 <mappages>
    80001b8c:	02054363          	bltz	a0,80001bb2 <proc_pagetable+0x5c>
  p->v_trapframe = uvmmaptf(pagetable, p->trapframe);
    80001b90:	05893583          	ld	a1,88(s2)
    80001b94:	8526                	mv	a0,s1
    80001b96:	00000097          	auipc	ra,0x0
    80001b9a:	cfc080e7          	jalr	-772(ra) # 80001892 <uvmmaptf>
    80001b9e:	06a93023          	sd	a0,96(s2)
  if (p->v_trapframe == 0)
    80001ba2:	c105                	beqz	a0,80001bc2 <proc_pagetable+0x6c>
}
    80001ba4:	8526                	mv	a0,s1
    80001ba6:	60e2                	ld	ra,24(sp)
    80001ba8:	6442                	ld	s0,16(sp)
    80001baa:	64a2                	ld	s1,8(sp)
    80001bac:	6902                	ld	s2,0(sp)
    80001bae:	6105                	addi	sp,sp,32
    80001bb0:	8082                	ret
    uvmfree(pagetable, 0);
    80001bb2:	4581                	li	a1,0
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	00000097          	auipc	ra,0x0
    80001bba:	9d4080e7          	jalr	-1580(ra) # 8000158a <uvmfree>
    return 0;
    80001bbe:	4481                	li	s1,0
    80001bc0:	b7d5                	j	80001ba4 <proc_pagetable+0x4e>
    panic("proc_pagetable: first trapframe");
    80001bc2:	00006517          	auipc	a0,0x6
    80001bc6:	65e50513          	addi	a0,a0,1630 # 80008220 <digits+0x1e0>
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	98a080e7          	jalr	-1654(ra) # 80000554 <panic>

0000000080001bd2 <proc_freepagetable>:
{
    80001bd2:	7139                	addi	sp,sp,-64
    80001bd4:	fc06                	sd	ra,56(sp)
    80001bd6:	f822                	sd	s0,48(sp)
    80001bd8:	f426                	sd	s1,40(sp)
    80001bda:	f04a                	sd	s2,32(sp)
    80001bdc:	ec4e                	sd	s3,24(sp)
    80001bde:	e852                	sd	s4,16(sp)
    80001be0:	e456                	sd	s5,8(sp)
    80001be2:	0080                	addi	s0,sp,64
    80001be4:	89aa                	mv	s3,a0
    80001be6:	8aae                	mv	s5,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001be8:	4681                	li	a3,0
    80001bea:	4605                	li	a2,1
    80001bec:	040005b7          	lui	a1,0x4000
    80001bf0:	15fd                	addi	a1,a1,-1
    80001bf2:	05b2                	slli	a1,a1,0xc
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	6d6080e7          	jalr	1750(ra) # 800012ca <uvmunmap>
  for (uint64 vtf = TRAPFRAME_TOP; vtf > TRAPFRAME_BOT; vtf -= PGSIZE)
    80001bfc:	020004b7          	lui	s1,0x2000
    80001c00:	14fd                	addi	s1,s1,-1
    80001c02:	04b6                	slli	s1,s1,0xd
    80001c04:	7a7d                	lui	s4,0xfffff
    80001c06:	02000937          	lui	s2,0x2000
    80001c0a:	fdf90913          	addi	s2,s2,-33 # 1ffffdf <_entry-0x7e000021>
    80001c0e:	0936                	slli	s2,s2,0xd
    uvmunmaptf(pagetable, vtf);
    80001c10:	85a6                	mv	a1,s1
    80001c12:	854e                	mv	a0,s3
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	cf8080e7          	jalr	-776(ra) # 8000190c <uvmunmaptf>
  for (uint64 vtf = TRAPFRAME_TOP; vtf > TRAPFRAME_BOT; vtf -= PGSIZE)
    80001c1c:	94d2                	add	s1,s1,s4
    80001c1e:	ff2499e3          	bne	s1,s2,80001c10 <proc_freepagetable+0x3e>
  uvmfree(pagetable, sz);
    80001c22:	85d6                	mv	a1,s5
    80001c24:	854e                	mv	a0,s3
    80001c26:	00000097          	auipc	ra,0x0
    80001c2a:	964080e7          	jalr	-1692(ra) # 8000158a <uvmfree>
}
    80001c2e:	70e2                	ld	ra,56(sp)
    80001c30:	7442                	ld	s0,48(sp)
    80001c32:	74a2                	ld	s1,40(sp)
    80001c34:	7902                	ld	s2,32(sp)
    80001c36:	69e2                	ld	s3,24(sp)
    80001c38:	6a42                	ld	s4,16(sp)
    80001c3a:	6aa2                	ld	s5,8(sp)
    80001c3c:	6121                	addi	sp,sp,64
    80001c3e:	8082                	ret

0000000080001c40 <freeproc>:
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	1000                	addi	s0,sp,32
    80001c4a:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c4c:	6d28                	ld	a0,88(a0)
    80001c4e:	c509                	beqz	a0,80001c58 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	dc8080e7          	jalr	-568(ra) # 80000a18 <kfree>
  p->trapframe = 0;
    80001c58:	0404bc23          	sd	zero,88(s1) # 2000058 <_entry-0x7dffffa8>
  if(p->pagetable)
    80001c5c:	68a8                	ld	a0,80(s1)
    80001c5e:	c511                	beqz	a0,80001c6a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c60:	64ac                	ld	a1,72(s1)
    80001c62:	00000097          	auipc	ra,0x0
    80001c66:	f70080e7          	jalr	-144(ra) # 80001bd2 <proc_freepagetable>
  p->pagetable = 0;
    80001c6a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c6e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c72:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c76:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c7a:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001c7e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c82:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c86:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c8a:	0004ac23          	sw	zero,24(s1)
}
    80001c8e:	60e2                	ld	ra,24(sp)
    80001c90:	6442                	ld	s0,16(sp)
    80001c92:	64a2                	ld	s1,8(sp)
    80001c94:	6105                	addi	sp,sp,32
    80001c96:	8082                	ret

0000000080001c98 <allocproc>:
{
    80001c98:	1101                	addi	sp,sp,-32
    80001c9a:	ec06                	sd	ra,24(sp)
    80001c9c:	e822                	sd	s0,16(sp)
    80001c9e:	e426                	sd	s1,8(sp)
    80001ca0:	e04a                	sd	s2,0(sp)
    80001ca2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ca4:	00010497          	auipc	s1,0x10
    80001ca8:	0c448493          	addi	s1,s1,196 # 80011d68 <proc>
    80001cac:	00016917          	auipc	s2,0x16
    80001cb0:	cbc90913          	addi	s2,s2,-836 # 80017968 <tickslock>
    acquire(&p->lock);
    80001cb4:	8526                	mv	a0,s1
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	f4e080e7          	jalr	-178(ra) # 80000c04 <acquire>
    if(p->state == UNUSED) {
    80001cbe:	4c9c                	lw	a5,24(s1)
    80001cc0:	cf81                	beqz	a5,80001cd8 <allocproc+0x40>
      release(&p->lock);
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	ff4080e7          	jalr	-12(ra) # 80000cb8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ccc:	17048493          	addi	s1,s1,368
    80001cd0:	ff2492e3          	bne	s1,s2,80001cb4 <allocproc+0x1c>
  return 0;
    80001cd4:	4481                	li	s1,0
    80001cd6:	a0b9                	j	80001d24 <allocproc+0x8c>
  p->pid = allocpid();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	e38080e7          	jalr	-456(ra) # 80001b10 <allocpid>
    80001ce0:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	e32080e7          	jalr	-462(ra) # 80000b14 <kalloc>
    80001cea:	892a                	mv	s2,a0
    80001cec:	eca8                	sd	a0,88(s1)
    80001cee:	c131                	beqz	a0,80001d32 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001cf0:	8526                	mv	a0,s1
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	e64080e7          	jalr	-412(ra) # 80001b56 <proc_pagetable>
    80001cfa:	892a                	mv	s2,a0
    80001cfc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cfe:	c129                	beqz	a0,80001d40 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001d00:	07000613          	li	a2,112
    80001d04:	4581                	li	a1,0
    80001d06:	06848513          	addi	a0,s1,104
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	ff6080e7          	jalr	-10(ra) # 80000d00 <memset>
  p->context.ra = (uint64)forkret;
    80001d12:	00000797          	auipc	a5,0x0
    80001d16:	db878793          	addi	a5,a5,-584 # 80001aca <forkret>
    80001d1a:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d1c:	60bc                	ld	a5,64(s1)
    80001d1e:	6705                	lui	a4,0x1
    80001d20:	97ba                	add	a5,a5,a4
    80001d22:	f8bc                	sd	a5,112(s1)
}
    80001d24:	8526                	mv	a0,s1
    80001d26:	60e2                	ld	ra,24(sp)
    80001d28:	6442                	ld	s0,16(sp)
    80001d2a:	64a2                	ld	s1,8(sp)
    80001d2c:	6902                	ld	s2,0(sp)
    80001d2e:	6105                	addi	sp,sp,32
    80001d30:	8082                	ret
    release(&p->lock);
    80001d32:	8526                	mv	a0,s1
    80001d34:	fffff097          	auipc	ra,0xfffff
    80001d38:	f84080e7          	jalr	-124(ra) # 80000cb8 <release>
    return 0;
    80001d3c:	84ca                	mv	s1,s2
    80001d3e:	b7dd                	j	80001d24 <allocproc+0x8c>
    freeproc(p);
    80001d40:	8526                	mv	a0,s1
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	efe080e7          	jalr	-258(ra) # 80001c40 <freeproc>
    release(&p->lock);
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	fffff097          	auipc	ra,0xfffff
    80001d50:	f6c080e7          	jalr	-148(ra) # 80000cb8 <release>
    return 0;
    80001d54:	84ca                	mv	s1,s2
    80001d56:	b7f9                	j	80001d24 <allocproc+0x8c>

0000000080001d58 <userinit>:
{
    80001d58:	1101                	addi	sp,sp,-32
    80001d5a:	ec06                	sd	ra,24(sp)
    80001d5c:	e822                	sd	s0,16(sp)
    80001d5e:	e426                	sd	s1,8(sp)
    80001d60:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d62:	00000097          	auipc	ra,0x0
    80001d66:	f36080e7          	jalr	-202(ra) # 80001c98 <allocproc>
    80001d6a:	84aa                	mv	s1,a0
  initproc = p;
    80001d6c:	00007797          	auipc	a5,0x7
    80001d70:	2aa7b623          	sd	a0,684(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d74:	03400613          	li	a2,52
    80001d78:	00007597          	auipc	a1,0x7
    80001d7c:	b0858593          	addi	a1,a1,-1272 # 80008880 <initcode>
    80001d80:	6928                	ld	a0,80(a0)
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	63a080e7          	jalr	1594(ra) # 800013bc <uvminit>
  p->sz = PGSIZE;
    80001d8a:	6785                	lui	a5,0x1
    80001d8c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d8e:	6cb8                	ld	a4,88(s1)
    80001d90:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d94:	6cb8                	ld	a4,88(s1)
    80001d96:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d98:	4641                	li	a2,16
    80001d9a:	00006597          	auipc	a1,0x6
    80001d9e:	4a658593          	addi	a1,a1,1190 # 80008240 <digits+0x200>
    80001da2:	16048513          	addi	a0,s1,352
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	0b0080e7          	jalr	176(ra) # 80000e56 <safestrcpy>
  p->cwd = namei("/");
    80001dae:	00006517          	auipc	a0,0x6
    80001db2:	4a250513          	addi	a0,a0,1186 # 80008250 <digits+0x210>
    80001db6:	00002097          	auipc	ra,0x2
    80001dba:	0d8080e7          	jalr	216(ra) # 80003e8e <namei>
    80001dbe:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001dc2:	4789                	li	a5,2
    80001dc4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001dc6:	8526                	mv	a0,s1
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	ef0080e7          	jalr	-272(ra) # 80000cb8 <release>
}
    80001dd0:	60e2                	ld	ra,24(sp)
    80001dd2:	6442                	ld	s0,16(sp)
    80001dd4:	64a2                	ld	s1,8(sp)
    80001dd6:	6105                	addi	sp,sp,32
    80001dd8:	8082                	ret

0000000080001dda <growproc>:
{
    80001dda:	1101                	addi	sp,sp,-32
    80001ddc:	ec06                	sd	ra,24(sp)
    80001dde:	e822                	sd	s0,16(sp)
    80001de0:	e426                	sd	s1,8(sp)
    80001de2:	e04a                	sd	s2,0(sp)
    80001de4:	1000                	addi	s0,sp,32
    80001de6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001de8:	00000097          	auipc	ra,0x0
    80001dec:	caa080e7          	jalr	-854(ra) # 80001a92 <myproc>
    80001df0:	892a                	mv	s2,a0
  sz = p->sz;
    80001df2:	652c                	ld	a1,72(a0)
    80001df4:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001df8:	00904f63          	bgtz	s1,80001e16 <growproc+0x3c>
  } else if(n < 0){
    80001dfc:	0204cc63          	bltz	s1,80001e34 <growproc+0x5a>
  p->sz = sz;
    80001e00:	1602                	slli	a2,a2,0x20
    80001e02:	9201                	srli	a2,a2,0x20
    80001e04:	04c93423          	sd	a2,72(s2)
  return 0;
    80001e08:	4501                	li	a0,0
}
    80001e0a:	60e2                	ld	ra,24(sp)
    80001e0c:	6442                	ld	s0,16(sp)
    80001e0e:	64a2                	ld	s1,8(sp)
    80001e10:	6902                	ld	s2,0(sp)
    80001e12:	6105                	addi	sp,sp,32
    80001e14:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001e16:	9e25                	addw	a2,a2,s1
    80001e18:	1602                	slli	a2,a2,0x20
    80001e1a:	9201                	srli	a2,a2,0x20
    80001e1c:	1582                	slli	a1,a1,0x20
    80001e1e:	9181                	srli	a1,a1,0x20
    80001e20:	6928                	ld	a0,80(a0)
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	654080e7          	jalr	1620(ra) # 80001476 <uvmalloc>
    80001e2a:	0005061b          	sext.w	a2,a0
    80001e2e:	fa69                	bnez	a2,80001e00 <growproc+0x26>
      return -1;
    80001e30:	557d                	li	a0,-1
    80001e32:	bfe1                	j	80001e0a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e34:	9e25                	addw	a2,a2,s1
    80001e36:	1602                	slli	a2,a2,0x20
    80001e38:	9201                	srli	a2,a2,0x20
    80001e3a:	1582                	slli	a1,a1,0x20
    80001e3c:	9181                	srli	a1,a1,0x20
    80001e3e:	6928                	ld	a0,80(a0)
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	5ee080e7          	jalr	1518(ra) # 8000142e <uvmdealloc>
    80001e48:	0005061b          	sext.w	a2,a0
    80001e4c:	bf55                	j	80001e00 <growproc+0x26>

0000000080001e4e <fork>:
{
    80001e4e:	7179                	addi	sp,sp,-48
    80001e50:	f406                	sd	ra,40(sp)
    80001e52:	f022                	sd	s0,32(sp)
    80001e54:	ec26                	sd	s1,24(sp)
    80001e56:	e84a                	sd	s2,16(sp)
    80001e58:	e44e                	sd	s3,8(sp)
    80001e5a:	e052                	sd	s4,0(sp)
    80001e5c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e5e:	00000097          	auipc	ra,0x0
    80001e62:	c34080e7          	jalr	-972(ra) # 80001a92 <myproc>
    80001e66:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	e30080e7          	jalr	-464(ra) # 80001c98 <allocproc>
    80001e70:	c175                	beqz	a0,80001f54 <fork+0x106>
    80001e72:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e74:	04893603          	ld	a2,72(s2)
    80001e78:	692c                	ld	a1,80(a0)
    80001e7a:	05093503          	ld	a0,80(s2)
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	744080e7          	jalr	1860(ra) # 800015c2 <uvmcopy>
    80001e86:	04054863          	bltz	a0,80001ed6 <fork+0x88>
  np->sz = p->sz;
    80001e8a:	04893783          	ld	a5,72(s2)
    80001e8e:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001e92:	0329b023          	sd	s2,32(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e96:	05893683          	ld	a3,88(s2)
    80001e9a:	87b6                	mv	a5,a3
    80001e9c:	0589b703          	ld	a4,88(s3)
    80001ea0:	12068693          	addi	a3,a3,288
    80001ea4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ea8:	6788                	ld	a0,8(a5)
    80001eaa:	6b8c                	ld	a1,16(a5)
    80001eac:	6f90                	ld	a2,24(a5)
    80001eae:	01073023          	sd	a6,0(a4)
    80001eb2:	e708                	sd	a0,8(a4)
    80001eb4:	eb0c                	sd	a1,16(a4)
    80001eb6:	ef10                	sd	a2,24(a4)
    80001eb8:	02078793          	addi	a5,a5,32
    80001ebc:	02070713          	addi	a4,a4,32
    80001ec0:	fed792e3          	bne	a5,a3,80001ea4 <fork+0x56>
  np->trapframe->a0 = 0;
    80001ec4:	0589b783          	ld	a5,88(s3)
    80001ec8:	0607b823          	sd	zero,112(a5)
    80001ecc:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001ed0:	15800a13          	li	s4,344
    80001ed4:	a03d                	j	80001f02 <fork+0xb4>
    freeproc(np);
    80001ed6:	854e                	mv	a0,s3
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	d68080e7          	jalr	-664(ra) # 80001c40 <freeproc>
    release(&np->lock);
    80001ee0:	854e                	mv	a0,s3
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	dd6080e7          	jalr	-554(ra) # 80000cb8 <release>
    return -1;
    80001eea:	54fd                	li	s1,-1
    80001eec:	a899                	j	80001f42 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eee:	00002097          	auipc	ra,0x2
    80001ef2:	62c080e7          	jalr	1580(ra) # 8000451a <filedup>
    80001ef6:	009987b3          	add	a5,s3,s1
    80001efa:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001efc:	04a1                	addi	s1,s1,8
    80001efe:	01448763          	beq	s1,s4,80001f0c <fork+0xbe>
    if(p->ofile[i])
    80001f02:	009907b3          	add	a5,s2,s1
    80001f06:	6388                	ld	a0,0(a5)
    80001f08:	f17d                	bnez	a0,80001eee <fork+0xa0>
    80001f0a:	bfcd                	j	80001efc <fork+0xae>
  np->cwd = idup(p->cwd);
    80001f0c:	15893503          	ld	a0,344(s2)
    80001f10:	00001097          	auipc	ra,0x1
    80001f14:	790080e7          	jalr	1936(ra) # 800036a0 <idup>
    80001f18:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f1c:	4641                	li	a2,16
    80001f1e:	16090593          	addi	a1,s2,352
    80001f22:	16098513          	addi	a0,s3,352
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	f30080e7          	jalr	-208(ra) # 80000e56 <safestrcpy>
  pid = np->pid;
    80001f2e:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001f32:	4789                	li	a5,2
    80001f34:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f38:	854e                	mv	a0,s3
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	d7e080e7          	jalr	-642(ra) # 80000cb8 <release>
}
    80001f42:	8526                	mv	a0,s1
    80001f44:	70a2                	ld	ra,40(sp)
    80001f46:	7402                	ld	s0,32(sp)
    80001f48:	64e2                	ld	s1,24(sp)
    80001f4a:	6942                	ld	s2,16(sp)
    80001f4c:	69a2                	ld	s3,8(sp)
    80001f4e:	6a02                	ld	s4,0(sp)
    80001f50:	6145                	addi	sp,sp,48
    80001f52:	8082                	ret
    return -1;
    80001f54:	54fd                	li	s1,-1
    80001f56:	b7f5                	j	80001f42 <fork+0xf4>

0000000080001f58 <reparent>:
{
    80001f58:	7179                	addi	sp,sp,-48
    80001f5a:	f406                	sd	ra,40(sp)
    80001f5c:	f022                	sd	s0,32(sp)
    80001f5e:	ec26                	sd	s1,24(sp)
    80001f60:	e84a                	sd	s2,16(sp)
    80001f62:	e44e                	sd	s3,8(sp)
    80001f64:	e052                	sd	s4,0(sp)
    80001f66:	1800                	addi	s0,sp,48
    80001f68:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f6a:	00010497          	auipc	s1,0x10
    80001f6e:	dfe48493          	addi	s1,s1,-514 # 80011d68 <proc>
      pp->parent = initproc;
    80001f72:	00007a17          	auipc	s4,0x7
    80001f76:	0a6a0a13          	addi	s4,s4,166 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f7a:	00016997          	auipc	s3,0x16
    80001f7e:	9ee98993          	addi	s3,s3,-1554 # 80017968 <tickslock>
    80001f82:	a029                	j	80001f8c <reparent+0x34>
    80001f84:	17048493          	addi	s1,s1,368
    80001f88:	03348363          	beq	s1,s3,80001fae <reparent+0x56>
    if(pp->parent == p){
    80001f8c:	709c                	ld	a5,32(s1)
    80001f8e:	ff279be3          	bne	a5,s2,80001f84 <reparent+0x2c>
      acquire(&pp->lock);
    80001f92:	8526                	mv	a0,s1
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	c70080e7          	jalr	-912(ra) # 80000c04 <acquire>
      pp->parent = initproc;
    80001f9c:	000a3783          	ld	a5,0(s4)
    80001fa0:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	d14080e7          	jalr	-748(ra) # 80000cb8 <release>
    80001fac:	bfe1                	j	80001f84 <reparent+0x2c>
}
    80001fae:	70a2                	ld	ra,40(sp)
    80001fb0:	7402                	ld	s0,32(sp)
    80001fb2:	64e2                	ld	s1,24(sp)
    80001fb4:	6942                	ld	s2,16(sp)
    80001fb6:	69a2                	ld	s3,8(sp)
    80001fb8:	6a02                	ld	s4,0(sp)
    80001fba:	6145                	addi	sp,sp,48
    80001fbc:	8082                	ret

0000000080001fbe <scheduler>:
{
    80001fbe:	7139                	addi	sp,sp,-64
    80001fc0:	fc06                	sd	ra,56(sp)
    80001fc2:	f822                	sd	s0,48(sp)
    80001fc4:	f426                	sd	s1,40(sp)
    80001fc6:	f04a                	sd	s2,32(sp)
    80001fc8:	ec4e                	sd	s3,24(sp)
    80001fca:	e852                	sd	s4,16(sp)
    80001fcc:	e456                	sd	s5,8(sp)
    80001fce:	e05a                	sd	s6,0(sp)
    80001fd0:	0080                	addi	s0,sp,64
    80001fd2:	8792                	mv	a5,tp
  int id = r_tp();
    80001fd4:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fd6:	00779a93          	slli	s5,a5,0x7
    80001fda:	00010717          	auipc	a4,0x10
    80001fde:	97670713          	addi	a4,a4,-1674 # 80011950 <pid_lock>
    80001fe2:	9756                	add	a4,a4,s5
    80001fe4:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001fe8:	00010717          	auipc	a4,0x10
    80001fec:	98870713          	addi	a4,a4,-1656 # 80011970 <cpus+0x8>
    80001ff0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ff2:	4989                	li	s3,2
        p->state = RUNNING;
    80001ff4:	4b0d                	li	s6,3
        c->proc = p;
    80001ff6:	079e                	slli	a5,a5,0x7
    80001ff8:	00010a17          	auipc	s4,0x10
    80001ffc:	958a0a13          	addi	s4,s4,-1704 # 80011950 <pid_lock>
    80002000:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002002:	00016917          	auipc	s2,0x16
    80002006:	96690913          	addi	s2,s2,-1690 # 80017968 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000200a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000200e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002012:	10079073          	csrw	sstatus,a5
    80002016:	00010497          	auipc	s1,0x10
    8000201a:	d5248493          	addi	s1,s1,-686 # 80011d68 <proc>
    8000201e:	a03d                	j	8000204c <scheduler+0x8e>
        p->state = RUNNING;
    80002020:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002024:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80002028:	06848593          	addi	a1,s1,104
    8000202c:	8556                	mv	a0,s5
    8000202e:	00000097          	auipc	ra,0x0
    80002032:	63a080e7          	jalr	1594(ra) # 80002668 <swtch>
        c->proc = 0;
    80002036:	000a3c23          	sd	zero,24(s4)
      release(&p->lock);
    8000203a:	8526                	mv	a0,s1
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	c7c080e7          	jalr	-900(ra) # 80000cb8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002044:	17048493          	addi	s1,s1,368
    80002048:	fd2481e3          	beq	s1,s2,8000200a <scheduler+0x4c>
      acquire(&p->lock);
    8000204c:	8526                	mv	a0,s1
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	bb6080e7          	jalr	-1098(ra) # 80000c04 <acquire>
      if(p->state == RUNNABLE) {
    80002056:	4c9c                	lw	a5,24(s1)
    80002058:	ff3791e3          	bne	a5,s3,8000203a <scheduler+0x7c>
    8000205c:	b7d1                	j	80002020 <scheduler+0x62>

000000008000205e <sched>:
{
    8000205e:	7179                	addi	sp,sp,-48
    80002060:	f406                	sd	ra,40(sp)
    80002062:	f022                	sd	s0,32(sp)
    80002064:	ec26                	sd	s1,24(sp)
    80002066:	e84a                	sd	s2,16(sp)
    80002068:	e44e                	sd	s3,8(sp)
    8000206a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000206c:	00000097          	auipc	ra,0x0
    80002070:	a26080e7          	jalr	-1498(ra) # 80001a92 <myproc>
    80002074:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	b14080e7          	jalr	-1260(ra) # 80000b8a <holding>
    8000207e:	c93d                	beqz	a0,800020f4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002080:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002082:	2781                	sext.w	a5,a5
    80002084:	079e                	slli	a5,a5,0x7
    80002086:	00010717          	auipc	a4,0x10
    8000208a:	8ca70713          	addi	a4,a4,-1846 # 80011950 <pid_lock>
    8000208e:	97ba                	add	a5,a5,a4
    80002090:	0907a703          	lw	a4,144(a5)
    80002094:	4785                	li	a5,1
    80002096:	06f71763          	bne	a4,a5,80002104 <sched+0xa6>
  if(p->state == RUNNING)
    8000209a:	4c98                	lw	a4,24(s1)
    8000209c:	478d                	li	a5,3
    8000209e:	06f70b63          	beq	a4,a5,80002114 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020a2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020a6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020a8:	efb5                	bnez	a5,80002124 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020aa:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020ac:	00010917          	auipc	s2,0x10
    800020b0:	8a490913          	addi	s2,s2,-1884 # 80011950 <pid_lock>
    800020b4:	2781                	sext.w	a5,a5
    800020b6:	079e                	slli	a5,a5,0x7
    800020b8:	97ca                	add	a5,a5,s2
    800020ba:	0947a983          	lw	s3,148(a5)
    800020be:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020c0:	2781                	sext.w	a5,a5
    800020c2:	079e                	slli	a5,a5,0x7
    800020c4:	00010597          	auipc	a1,0x10
    800020c8:	8ac58593          	addi	a1,a1,-1876 # 80011970 <cpus+0x8>
    800020cc:	95be                	add	a1,a1,a5
    800020ce:	06848513          	addi	a0,s1,104
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	596080e7          	jalr	1430(ra) # 80002668 <swtch>
    800020da:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020dc:	2781                	sext.w	a5,a5
    800020de:	079e                	slli	a5,a5,0x7
    800020e0:	97ca                	add	a5,a5,s2
    800020e2:	0937aa23          	sw	s3,148(a5)
}
    800020e6:	70a2                	ld	ra,40(sp)
    800020e8:	7402                	ld	s0,32(sp)
    800020ea:	64e2                	ld	s1,24(sp)
    800020ec:	6942                	ld	s2,16(sp)
    800020ee:	69a2                	ld	s3,8(sp)
    800020f0:	6145                	addi	sp,sp,48
    800020f2:	8082                	ret
    panic("sched p->lock");
    800020f4:	00006517          	auipc	a0,0x6
    800020f8:	16450513          	addi	a0,a0,356 # 80008258 <digits+0x218>
    800020fc:	ffffe097          	auipc	ra,0xffffe
    80002100:	458080e7          	jalr	1112(ra) # 80000554 <panic>
    panic("sched locks");
    80002104:	00006517          	auipc	a0,0x6
    80002108:	16450513          	addi	a0,a0,356 # 80008268 <digits+0x228>
    8000210c:	ffffe097          	auipc	ra,0xffffe
    80002110:	448080e7          	jalr	1096(ra) # 80000554 <panic>
    panic("sched running");
    80002114:	00006517          	auipc	a0,0x6
    80002118:	16450513          	addi	a0,a0,356 # 80008278 <digits+0x238>
    8000211c:	ffffe097          	auipc	ra,0xffffe
    80002120:	438080e7          	jalr	1080(ra) # 80000554 <panic>
    panic("sched interruptible");
    80002124:	00006517          	auipc	a0,0x6
    80002128:	16450513          	addi	a0,a0,356 # 80008288 <digits+0x248>
    8000212c:	ffffe097          	auipc	ra,0xffffe
    80002130:	428080e7          	jalr	1064(ra) # 80000554 <panic>

0000000080002134 <exit>:
{
    80002134:	7179                	addi	sp,sp,-48
    80002136:	f406                	sd	ra,40(sp)
    80002138:	f022                	sd	s0,32(sp)
    8000213a:	ec26                	sd	s1,24(sp)
    8000213c:	e84a                	sd	s2,16(sp)
    8000213e:	e44e                	sd	s3,8(sp)
    80002140:	e052                	sd	s4,0(sp)
    80002142:	1800                	addi	s0,sp,48
    80002144:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	94c080e7          	jalr	-1716(ra) # 80001a92 <myproc>
    8000214e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002150:	00007797          	auipc	a5,0x7
    80002154:	ec87b783          	ld	a5,-312(a5) # 80009018 <initproc>
    80002158:	0d850493          	addi	s1,a0,216
    8000215c:	15850913          	addi	s2,a0,344
    80002160:	02a79363          	bne	a5,a0,80002186 <exit+0x52>
    panic("init exiting");
    80002164:	00006517          	auipc	a0,0x6
    80002168:	13c50513          	addi	a0,a0,316 # 800082a0 <digits+0x260>
    8000216c:	ffffe097          	auipc	ra,0xffffe
    80002170:	3e8080e7          	jalr	1000(ra) # 80000554 <panic>
      fileclose(f);
    80002174:	00002097          	auipc	ra,0x2
    80002178:	3f8080e7          	jalr	1016(ra) # 8000456c <fileclose>
      p->ofile[fd] = 0;
    8000217c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002180:	04a1                	addi	s1,s1,8
    80002182:	01248563          	beq	s1,s2,8000218c <exit+0x58>
    if(p->ofile[fd]){
    80002186:	6088                	ld	a0,0(s1)
    80002188:	f575                	bnez	a0,80002174 <exit+0x40>
    8000218a:	bfdd                	j	80002180 <exit+0x4c>
  begin_op();
    8000218c:	00002097          	auipc	ra,0x2
    80002190:	f0e080e7          	jalr	-242(ra) # 8000409a <begin_op>
  iput(p->cwd);
    80002194:	1589b503          	ld	a0,344(s3)
    80002198:	00001097          	auipc	ra,0x1
    8000219c:	700080e7          	jalr	1792(ra) # 80003898 <iput>
  end_op();
    800021a0:	00002097          	auipc	ra,0x2
    800021a4:	f7a080e7          	jalr	-134(ra) # 8000411a <end_op>
  p->cwd = 0;
    800021a8:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    800021ac:	00007497          	auipc	s1,0x7
    800021b0:	e6c48493          	addi	s1,s1,-404 # 80009018 <initproc>
    800021b4:	6088                	ld	a0,0(s1)
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	a4e080e7          	jalr	-1458(ra) # 80000c04 <acquire>
  wakeup1(initproc);
    800021be:	6088                	ld	a0,0(s1)
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	792080e7          	jalr	1938(ra) # 80001952 <wakeup1>
  release(&initproc->lock);
    800021c8:	6088                	ld	a0,0(s1)
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	aee080e7          	jalr	-1298(ra) # 80000cb8 <release>
  acquire(&p->lock);
    800021d2:	854e                	mv	a0,s3
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	a30080e7          	jalr	-1488(ra) # 80000c04 <acquire>
  struct proc *original_parent = p->parent;
    800021dc:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800021e0:	854e                	mv	a0,s3
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	ad6080e7          	jalr	-1322(ra) # 80000cb8 <release>
  acquire(&original_parent->lock);
    800021ea:	8526                	mv	a0,s1
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	a18080e7          	jalr	-1512(ra) # 80000c04 <acquire>
  acquire(&p->lock);
    800021f4:	854e                	mv	a0,s3
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	a0e080e7          	jalr	-1522(ra) # 80000c04 <acquire>
  reparent(p);
    800021fe:	854e                	mv	a0,s3
    80002200:	00000097          	auipc	ra,0x0
    80002204:	d58080e7          	jalr	-680(ra) # 80001f58 <reparent>
  wakeup1(original_parent);
    80002208:	8526                	mv	a0,s1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	748080e7          	jalr	1864(ra) # 80001952 <wakeup1>
  p->xstate = status;
    80002212:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002216:	4791                	li	a5,4
    80002218:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000221c:	8526                	mv	a0,s1
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	a9a080e7          	jalr	-1382(ra) # 80000cb8 <release>
  sched();
    80002226:	00000097          	auipc	ra,0x0
    8000222a:	e38080e7          	jalr	-456(ra) # 8000205e <sched>
  panic("zombie exit");
    8000222e:	00006517          	auipc	a0,0x6
    80002232:	08250513          	addi	a0,a0,130 # 800082b0 <digits+0x270>
    80002236:	ffffe097          	auipc	ra,0xffffe
    8000223a:	31e080e7          	jalr	798(ra) # 80000554 <panic>

000000008000223e <yield>:
{
    8000223e:	1101                	addi	sp,sp,-32
    80002240:	ec06                	sd	ra,24(sp)
    80002242:	e822                	sd	s0,16(sp)
    80002244:	e426                	sd	s1,8(sp)
    80002246:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	84a080e7          	jalr	-1974(ra) # 80001a92 <myproc>
    80002250:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	9b2080e7          	jalr	-1614(ra) # 80000c04 <acquire>
  p->state = RUNNABLE;
    8000225a:	4789                	li	a5,2
    8000225c:	cc9c                	sw	a5,24(s1)
  sched();
    8000225e:	00000097          	auipc	ra,0x0
    80002262:	e00080e7          	jalr	-512(ra) # 8000205e <sched>
  release(&p->lock);
    80002266:	8526                	mv	a0,s1
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	a50080e7          	jalr	-1456(ra) # 80000cb8 <release>
}
    80002270:	60e2                	ld	ra,24(sp)
    80002272:	6442                	ld	s0,16(sp)
    80002274:	64a2                	ld	s1,8(sp)
    80002276:	6105                	addi	sp,sp,32
    80002278:	8082                	ret

000000008000227a <sleep>:
{
    8000227a:	7179                	addi	sp,sp,-48
    8000227c:	f406                	sd	ra,40(sp)
    8000227e:	f022                	sd	s0,32(sp)
    80002280:	ec26                	sd	s1,24(sp)
    80002282:	e84a                	sd	s2,16(sp)
    80002284:	e44e                	sd	s3,8(sp)
    80002286:	1800                	addi	s0,sp,48
    80002288:	89aa                	mv	s3,a0
    8000228a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	806080e7          	jalr	-2042(ra) # 80001a92 <myproc>
    80002294:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002296:	05250663          	beq	a0,s2,800022e2 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	96a080e7          	jalr	-1686(ra) # 80000c04 <acquire>
    release(lk);
    800022a2:	854a                	mv	a0,s2
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	a14080e7          	jalr	-1516(ra) # 80000cb8 <release>
  p->chan = chan;
    800022ac:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800022b0:	4785                	li	a5,1
    800022b2:	cc9c                	sw	a5,24(s1)
  sched();
    800022b4:	00000097          	auipc	ra,0x0
    800022b8:	daa080e7          	jalr	-598(ra) # 8000205e <sched>
  p->chan = 0;
    800022bc:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800022c0:	8526                	mv	a0,s1
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	9f6080e7          	jalr	-1546(ra) # 80000cb8 <release>
    acquire(lk);
    800022ca:	854a                	mv	a0,s2
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	938080e7          	jalr	-1736(ra) # 80000c04 <acquire>
}
    800022d4:	70a2                	ld	ra,40(sp)
    800022d6:	7402                	ld	s0,32(sp)
    800022d8:	64e2                	ld	s1,24(sp)
    800022da:	6942                	ld	s2,16(sp)
    800022dc:	69a2                	ld	s3,8(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret
  p->chan = chan;
    800022e2:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800022e6:	4785                	li	a5,1
    800022e8:	cd1c                	sw	a5,24(a0)
  sched();
    800022ea:	00000097          	auipc	ra,0x0
    800022ee:	d74080e7          	jalr	-652(ra) # 8000205e <sched>
  p->chan = 0;
    800022f2:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800022f6:	bff9                	j	800022d4 <sleep+0x5a>

00000000800022f8 <wait>:
{
    800022f8:	715d                	addi	sp,sp,-80
    800022fa:	e486                	sd	ra,72(sp)
    800022fc:	e0a2                	sd	s0,64(sp)
    800022fe:	fc26                	sd	s1,56(sp)
    80002300:	f84a                	sd	s2,48(sp)
    80002302:	f44e                	sd	s3,40(sp)
    80002304:	f052                	sd	s4,32(sp)
    80002306:	ec56                	sd	s5,24(sp)
    80002308:	e85a                	sd	s6,16(sp)
    8000230a:	e45e                	sd	s7,8(sp)
    8000230c:	e062                	sd	s8,0(sp)
    8000230e:	0880                	addi	s0,sp,80
    80002310:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	780080e7          	jalr	1920(ra) # 80001a92 <myproc>
    8000231a:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000231c:	8c2a                	mv	s8,a0
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	8e6080e7          	jalr	-1818(ra) # 80000c04 <acquire>
    havekids = 0;
    80002326:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002328:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    8000232a:	00015997          	auipc	s3,0x15
    8000232e:	63e98993          	addi	s3,s3,1598 # 80017968 <tickslock>
        havekids = 1;
    80002332:	4a85                	li	s5,1
    havekids = 0;
    80002334:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002336:	00010497          	auipc	s1,0x10
    8000233a:	a3248493          	addi	s1,s1,-1486 # 80011d68 <proc>
    8000233e:	a08d                	j	800023a0 <wait+0xa8>
          pid = np->pid;
    80002340:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002344:	000b0e63          	beqz	s6,80002360 <wait+0x68>
    80002348:	4691                	li	a3,4
    8000234a:	03448613          	addi	a2,s1,52
    8000234e:	85da                	mv	a1,s6
    80002350:	05093503          	ld	a0,80(s2)
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	372080e7          	jalr	882(ra) # 800016c6 <copyout>
    8000235c:	02054263          	bltz	a0,80002380 <wait+0x88>
          freeproc(np);
    80002360:	8526                	mv	a0,s1
    80002362:	00000097          	auipc	ra,0x0
    80002366:	8de080e7          	jalr	-1826(ra) # 80001c40 <freeproc>
          release(&np->lock);
    8000236a:	8526                	mv	a0,s1
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	94c080e7          	jalr	-1716(ra) # 80000cb8 <release>
          release(&p->lock);
    80002374:	854a                	mv	a0,s2
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	942080e7          	jalr	-1726(ra) # 80000cb8 <release>
          return pid;
    8000237e:	a8a9                	j	800023d8 <wait+0xe0>
            release(&np->lock);
    80002380:	8526                	mv	a0,s1
    80002382:	fffff097          	auipc	ra,0xfffff
    80002386:	936080e7          	jalr	-1738(ra) # 80000cb8 <release>
            release(&p->lock);
    8000238a:	854a                	mv	a0,s2
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	92c080e7          	jalr	-1748(ra) # 80000cb8 <release>
            return -1;
    80002394:	59fd                	li	s3,-1
    80002396:	a089                	j	800023d8 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002398:	17048493          	addi	s1,s1,368
    8000239c:	03348463          	beq	s1,s3,800023c4 <wait+0xcc>
      if(np->parent == p){
    800023a0:	709c                	ld	a5,32(s1)
    800023a2:	ff279be3          	bne	a5,s2,80002398 <wait+0xa0>
        acquire(&np->lock);
    800023a6:	8526                	mv	a0,s1
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	85c080e7          	jalr	-1956(ra) # 80000c04 <acquire>
        if(np->state == ZOMBIE){
    800023b0:	4c9c                	lw	a5,24(s1)
    800023b2:	f94787e3          	beq	a5,s4,80002340 <wait+0x48>
        release(&np->lock);
    800023b6:	8526                	mv	a0,s1
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	900080e7          	jalr	-1792(ra) # 80000cb8 <release>
        havekids = 1;
    800023c0:	8756                	mv	a4,s5
    800023c2:	bfd9                	j	80002398 <wait+0xa0>
    if(!havekids || p->killed){
    800023c4:	c701                	beqz	a4,800023cc <wait+0xd4>
    800023c6:	03092783          	lw	a5,48(s2)
    800023ca:	c785                	beqz	a5,800023f2 <wait+0xfa>
      release(&p->lock);
    800023cc:	854a                	mv	a0,s2
    800023ce:	fffff097          	auipc	ra,0xfffff
    800023d2:	8ea080e7          	jalr	-1814(ra) # 80000cb8 <release>
      return -1;
    800023d6:	59fd                	li	s3,-1
}
    800023d8:	854e                	mv	a0,s3
    800023da:	60a6                	ld	ra,72(sp)
    800023dc:	6406                	ld	s0,64(sp)
    800023de:	74e2                	ld	s1,56(sp)
    800023e0:	7942                	ld	s2,48(sp)
    800023e2:	79a2                	ld	s3,40(sp)
    800023e4:	7a02                	ld	s4,32(sp)
    800023e6:	6ae2                	ld	s5,24(sp)
    800023e8:	6b42                	ld	s6,16(sp)
    800023ea:	6ba2                	ld	s7,8(sp)
    800023ec:	6c02                	ld	s8,0(sp)
    800023ee:	6161                	addi	sp,sp,80
    800023f0:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023f2:	85e2                	mv	a1,s8
    800023f4:	854a                	mv	a0,s2
    800023f6:	00000097          	auipc	ra,0x0
    800023fa:	e84080e7          	jalr	-380(ra) # 8000227a <sleep>
    havekids = 0;
    800023fe:	bf1d                	j	80002334 <wait+0x3c>

0000000080002400 <wakeup>:
{
    80002400:	7139                	addi	sp,sp,-64
    80002402:	fc06                	sd	ra,56(sp)
    80002404:	f822                	sd	s0,48(sp)
    80002406:	f426                	sd	s1,40(sp)
    80002408:	f04a                	sd	s2,32(sp)
    8000240a:	ec4e                	sd	s3,24(sp)
    8000240c:	e852                	sd	s4,16(sp)
    8000240e:	e456                	sd	s5,8(sp)
    80002410:	0080                	addi	s0,sp,64
    80002412:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002414:	00010497          	auipc	s1,0x10
    80002418:	95448493          	addi	s1,s1,-1708 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000241c:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000241e:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002420:	00015917          	auipc	s2,0x15
    80002424:	54890913          	addi	s2,s2,1352 # 80017968 <tickslock>
    80002428:	a821                	j	80002440 <wakeup+0x40>
      p->state = RUNNABLE;
    8000242a:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    8000242e:	8526                	mv	a0,s1
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	888080e7          	jalr	-1912(ra) # 80000cb8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002438:	17048493          	addi	s1,s1,368
    8000243c:	01248e63          	beq	s1,s2,80002458 <wakeup+0x58>
    acquire(&p->lock);
    80002440:	8526                	mv	a0,s1
    80002442:	ffffe097          	auipc	ra,0xffffe
    80002446:	7c2080e7          	jalr	1986(ra) # 80000c04 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000244a:	4c9c                	lw	a5,24(s1)
    8000244c:	ff3791e3          	bne	a5,s3,8000242e <wakeup+0x2e>
    80002450:	749c                	ld	a5,40(s1)
    80002452:	fd479ee3          	bne	a5,s4,8000242e <wakeup+0x2e>
    80002456:	bfd1                	j	8000242a <wakeup+0x2a>
}
    80002458:	70e2                	ld	ra,56(sp)
    8000245a:	7442                	ld	s0,48(sp)
    8000245c:	74a2                	ld	s1,40(sp)
    8000245e:	7902                	ld	s2,32(sp)
    80002460:	69e2                	ld	s3,24(sp)
    80002462:	6a42                	ld	s4,16(sp)
    80002464:	6aa2                	ld	s5,8(sp)
    80002466:	6121                	addi	sp,sp,64
    80002468:	8082                	ret

000000008000246a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000246a:	7179                	addi	sp,sp,-48
    8000246c:	f406                	sd	ra,40(sp)
    8000246e:	f022                	sd	s0,32(sp)
    80002470:	ec26                	sd	s1,24(sp)
    80002472:	e84a                	sd	s2,16(sp)
    80002474:	e44e                	sd	s3,8(sp)
    80002476:	1800                	addi	s0,sp,48
    80002478:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000247a:	00010497          	auipc	s1,0x10
    8000247e:	8ee48493          	addi	s1,s1,-1810 # 80011d68 <proc>
    80002482:	00015997          	auipc	s3,0x15
    80002486:	4e698993          	addi	s3,s3,1254 # 80017968 <tickslock>
    acquire(&p->lock);
    8000248a:	8526                	mv	a0,s1
    8000248c:	ffffe097          	auipc	ra,0xffffe
    80002490:	778080e7          	jalr	1912(ra) # 80000c04 <acquire>
    if(p->pid == pid){
    80002494:	5c9c                	lw	a5,56(s1)
    80002496:	01278d63          	beq	a5,s2,800024b0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000249a:	8526                	mv	a0,s1
    8000249c:	fffff097          	auipc	ra,0xfffff
    800024a0:	81c080e7          	jalr	-2020(ra) # 80000cb8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024a4:	17048493          	addi	s1,s1,368
    800024a8:	ff3491e3          	bne	s1,s3,8000248a <kill+0x20>
  }
  return -1;
    800024ac:	557d                	li	a0,-1
    800024ae:	a821                	j	800024c6 <kill+0x5c>
      p->killed = 1;
    800024b0:	4785                	li	a5,1
    800024b2:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800024b4:	4c98                	lw	a4,24(s1)
    800024b6:	00f70f63          	beq	a4,a5,800024d4 <kill+0x6a>
      release(&p->lock);
    800024ba:	8526                	mv	a0,s1
    800024bc:	ffffe097          	auipc	ra,0xffffe
    800024c0:	7fc080e7          	jalr	2044(ra) # 80000cb8 <release>
      return 0;
    800024c4:	4501                	li	a0,0
}
    800024c6:	70a2                	ld	ra,40(sp)
    800024c8:	7402                	ld	s0,32(sp)
    800024ca:	64e2                	ld	s1,24(sp)
    800024cc:	6942                	ld	s2,16(sp)
    800024ce:	69a2                	ld	s3,8(sp)
    800024d0:	6145                	addi	sp,sp,48
    800024d2:	8082                	ret
        p->state = RUNNABLE;
    800024d4:	4789                	li	a5,2
    800024d6:	cc9c                	sw	a5,24(s1)
    800024d8:	b7cd                	j	800024ba <kill+0x50>

00000000800024da <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024da:	7179                	addi	sp,sp,-48
    800024dc:	f406                	sd	ra,40(sp)
    800024de:	f022                	sd	s0,32(sp)
    800024e0:	ec26                	sd	s1,24(sp)
    800024e2:	e84a                	sd	s2,16(sp)
    800024e4:	e44e                	sd	s3,8(sp)
    800024e6:	e052                	sd	s4,0(sp)
    800024e8:	1800                	addi	s0,sp,48
    800024ea:	84aa                	mv	s1,a0
    800024ec:	892e                	mv	s2,a1
    800024ee:	89b2                	mv	s3,a2
    800024f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024f2:	fffff097          	auipc	ra,0xfffff
    800024f6:	5a0080e7          	jalr	1440(ra) # 80001a92 <myproc>
  if(user_dst){
    800024fa:	c08d                	beqz	s1,8000251c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024fc:	86d2                	mv	a3,s4
    800024fe:	864e                	mv	a2,s3
    80002500:	85ca                	mv	a1,s2
    80002502:	6928                	ld	a0,80(a0)
    80002504:	fffff097          	auipc	ra,0xfffff
    80002508:	1c2080e7          	jalr	450(ra) # 800016c6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000250c:	70a2                	ld	ra,40(sp)
    8000250e:	7402                	ld	s0,32(sp)
    80002510:	64e2                	ld	s1,24(sp)
    80002512:	6942                	ld	s2,16(sp)
    80002514:	69a2                	ld	s3,8(sp)
    80002516:	6a02                	ld	s4,0(sp)
    80002518:	6145                	addi	sp,sp,48
    8000251a:	8082                	ret
    memmove((char *)dst, src, len);
    8000251c:	000a061b          	sext.w	a2,s4
    80002520:	85ce                	mv	a1,s3
    80002522:	854a                	mv	a0,s2
    80002524:	fffff097          	auipc	ra,0xfffff
    80002528:	83c080e7          	jalr	-1988(ra) # 80000d60 <memmove>
    return 0;
    8000252c:	8526                	mv	a0,s1
    8000252e:	bff9                	j	8000250c <either_copyout+0x32>

0000000080002530 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002530:	7179                	addi	sp,sp,-48
    80002532:	f406                	sd	ra,40(sp)
    80002534:	f022                	sd	s0,32(sp)
    80002536:	ec26                	sd	s1,24(sp)
    80002538:	e84a                	sd	s2,16(sp)
    8000253a:	e44e                	sd	s3,8(sp)
    8000253c:	e052                	sd	s4,0(sp)
    8000253e:	1800                	addi	s0,sp,48
    80002540:	892a                	mv	s2,a0
    80002542:	84ae                	mv	s1,a1
    80002544:	89b2                	mv	s3,a2
    80002546:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002548:	fffff097          	auipc	ra,0xfffff
    8000254c:	54a080e7          	jalr	1354(ra) # 80001a92 <myproc>
  if(user_src){
    80002550:	c08d                	beqz	s1,80002572 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002552:	86d2                	mv	a3,s4
    80002554:	864e                	mv	a2,s3
    80002556:	85ca                	mv	a1,s2
    80002558:	6928                	ld	a0,80(a0)
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	1f8080e7          	jalr	504(ra) # 80001752 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002562:	70a2                	ld	ra,40(sp)
    80002564:	7402                	ld	s0,32(sp)
    80002566:	64e2                	ld	s1,24(sp)
    80002568:	6942                	ld	s2,16(sp)
    8000256a:	69a2                	ld	s3,8(sp)
    8000256c:	6a02                	ld	s4,0(sp)
    8000256e:	6145                	addi	sp,sp,48
    80002570:	8082                	ret
    memmove(dst, (char*)src, len);
    80002572:	000a061b          	sext.w	a2,s4
    80002576:	85ce                	mv	a1,s3
    80002578:	854a                	mv	a0,s2
    8000257a:	ffffe097          	auipc	ra,0xffffe
    8000257e:	7e6080e7          	jalr	2022(ra) # 80000d60 <memmove>
    return 0;
    80002582:	8526                	mv	a0,s1
    80002584:	bff9                	j	80002562 <either_copyin+0x32>

0000000080002586 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002586:	715d                	addi	sp,sp,-80
    80002588:	e486                	sd	ra,72(sp)
    8000258a:	e0a2                	sd	s0,64(sp)
    8000258c:	fc26                	sd	s1,56(sp)
    8000258e:	f84a                	sd	s2,48(sp)
    80002590:	f44e                	sd	s3,40(sp)
    80002592:	f052                	sd	s4,32(sp)
    80002594:	ec56                	sd	s5,24(sp)
    80002596:	e85a                	sd	s6,16(sp)
    80002598:	e45e                	sd	s7,8(sp)
    8000259a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000259c:	00006517          	auipc	a0,0x6
    800025a0:	b2c50513          	addi	a0,a0,-1236 # 800080c8 <digits+0x88>
    800025a4:	ffffe097          	auipc	ra,0xffffe
    800025a8:	ffa080e7          	jalr	-6(ra) # 8000059e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025ac:	00010497          	auipc	s1,0x10
    800025b0:	91c48493          	addi	s1,s1,-1764 # 80011ec8 <proc+0x160>
    800025b4:	00015917          	auipc	s2,0x15
    800025b8:	51490913          	addi	s2,s2,1300 # 80017ac8 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025bc:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800025be:	00006997          	auipc	s3,0x6
    800025c2:	d0298993          	addi	s3,s3,-766 # 800082c0 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    800025c6:	00006a97          	auipc	s5,0x6
    800025ca:	d02a8a93          	addi	s5,s5,-766 # 800082c8 <digits+0x288>
    printf("\n");
    800025ce:	00006a17          	auipc	s4,0x6
    800025d2:	afaa0a13          	addi	s4,s4,-1286 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025d6:	00006b97          	auipc	s7,0x6
    800025da:	d2ab8b93          	addi	s7,s7,-726 # 80008300 <states.1714>
    800025de:	a00d                	j	80002600 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025e0:	ed86a583          	lw	a1,-296(a3)
    800025e4:	8556                	mv	a0,s5
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	fb8080e7          	jalr	-72(ra) # 8000059e <printf>
    printf("\n");
    800025ee:	8552                	mv	a0,s4
    800025f0:	ffffe097          	auipc	ra,0xffffe
    800025f4:	fae080e7          	jalr	-82(ra) # 8000059e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025f8:	17048493          	addi	s1,s1,368
    800025fc:	03248163          	beq	s1,s2,8000261e <procdump+0x98>
    if(p->state == UNUSED)
    80002600:	86a6                	mv	a3,s1
    80002602:	eb84a783          	lw	a5,-328(s1)
    80002606:	dbed                	beqz	a5,800025f8 <procdump+0x72>
      state = "???";
    80002608:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000260a:	fcfb6be3          	bltu	s6,a5,800025e0 <procdump+0x5a>
    8000260e:	1782                	slli	a5,a5,0x20
    80002610:	9381                	srli	a5,a5,0x20
    80002612:	078e                	slli	a5,a5,0x3
    80002614:	97de                	add	a5,a5,s7
    80002616:	6390                	ld	a2,0(a5)
    80002618:	f661                	bnez	a2,800025e0 <procdump+0x5a>
      state = "???";
    8000261a:	864e                	mv	a2,s3
    8000261c:	b7d1                	j	800025e0 <procdump+0x5a>
  }
}
    8000261e:	60a6                	ld	ra,72(sp)
    80002620:	6406                	ld	s0,64(sp)
    80002622:	74e2                	ld	s1,56(sp)
    80002624:	7942                	ld	s2,48(sp)
    80002626:	79a2                	ld	s3,40(sp)
    80002628:	7a02                	ld	s4,32(sp)
    8000262a:	6ae2                	ld	s5,24(sp)
    8000262c:	6b42                	ld	s6,16(sp)
    8000262e:	6ba2                	ld	s7,8(sp)
    80002630:	6161                	addi	sp,sp,80
    80002632:	8082                	ret

0000000080002634 <numprocs>:

int
numprocs(void)
{
    80002634:	1141                	addi	sp,sp,-16
    80002636:	e422                	sd	s0,8(sp)
    80002638:	0800                	addi	s0,sp,16
    struct proc *p;
    int counter = 0;
    8000263a:	4501                	li	a0,0
    for(p = proc; p < &proc[NPROC]; p++){
    8000263c:	0000f797          	auipc	a5,0xf
    80002640:	72c78793          	addi	a5,a5,1836 # 80011d68 <proc>
        if(p->state == RUNNABLE){
    80002644:	4609                	li	a2,2
    for(p = proc; p < &proc[NPROC]; p++){
    80002646:	00015697          	auipc	a3,0x15
    8000264a:	32268693          	addi	a3,a3,802 # 80017968 <tickslock>
    8000264e:	a029                	j	80002658 <numprocs+0x24>
    80002650:	17078793          	addi	a5,a5,368
    80002654:	00d78763          	beq	a5,a3,80002662 <numprocs+0x2e>
        if(p->state == RUNNABLE){
    80002658:	4f98                	lw	a4,24(a5)
    8000265a:	fec71be3          	bne	a4,a2,80002650 <numprocs+0x1c>
            counter++;}
    8000265e:	2505                	addiw	a0,a0,1
    80002660:	bfc5                	j	80002650 <numprocs+0x1c>
            }
        return counter;
}
    80002662:	6422                	ld	s0,8(sp)
    80002664:	0141                	addi	sp,sp,16
    80002666:	8082                	ret

0000000080002668 <swtch>:
    80002668:	00153023          	sd	ra,0(a0)
    8000266c:	00253423          	sd	sp,8(a0)
    80002670:	e900                	sd	s0,16(a0)
    80002672:	ed04                	sd	s1,24(a0)
    80002674:	03253023          	sd	s2,32(a0)
    80002678:	03353423          	sd	s3,40(a0)
    8000267c:	03453823          	sd	s4,48(a0)
    80002680:	03553c23          	sd	s5,56(a0)
    80002684:	05653023          	sd	s6,64(a0)
    80002688:	05753423          	sd	s7,72(a0)
    8000268c:	05853823          	sd	s8,80(a0)
    80002690:	05953c23          	sd	s9,88(a0)
    80002694:	07a53023          	sd	s10,96(a0)
    80002698:	07b53423          	sd	s11,104(a0)
    8000269c:	0005b083          	ld	ra,0(a1)
    800026a0:	0085b103          	ld	sp,8(a1)
    800026a4:	6980                	ld	s0,16(a1)
    800026a6:	6d84                	ld	s1,24(a1)
    800026a8:	0205b903          	ld	s2,32(a1)
    800026ac:	0285b983          	ld	s3,40(a1)
    800026b0:	0305ba03          	ld	s4,48(a1)
    800026b4:	0385ba83          	ld	s5,56(a1)
    800026b8:	0405bb03          	ld	s6,64(a1)
    800026bc:	0485bb83          	ld	s7,72(a1)
    800026c0:	0505bc03          	ld	s8,80(a1)
    800026c4:	0585bc83          	ld	s9,88(a1)
    800026c8:	0605bd03          	ld	s10,96(a1)
    800026cc:	0685bd83          	ld	s11,104(a1)
    800026d0:	8082                	ret

00000000800026d2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026d2:	1141                	addi	sp,sp,-16
    800026d4:	e406                	sd	ra,8(sp)
    800026d6:	e022                	sd	s0,0(sp)
    800026d8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026da:	00006597          	auipc	a1,0x6
    800026de:	c4e58593          	addi	a1,a1,-946 # 80008328 <states.1714+0x28>
    800026e2:	00015517          	auipc	a0,0x15
    800026e6:	28650513          	addi	a0,a0,646 # 80017968 <tickslock>
    800026ea:	ffffe097          	auipc	ra,0xffffe
    800026ee:	48a080e7          	jalr	1162(ra) # 80000b74 <initlock>
}
    800026f2:	60a2                	ld	ra,8(sp)
    800026f4:	6402                	ld	s0,0(sp)
    800026f6:	0141                	addi	sp,sp,16
    800026f8:	8082                	ret

00000000800026fa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026fa:	1141                	addi	sp,sp,-16
    800026fc:	e422                	sd	s0,8(sp)
    800026fe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002700:	00003797          	auipc	a5,0x3
    80002704:	4d078793          	addi	a5,a5,1232 # 80005bd0 <kernelvec>
    80002708:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000270c:	6422                	ld	s0,8(sp)
    8000270e:	0141                	addi	sp,sp,16
    80002710:	8082                	ret

0000000080002712 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002712:	1141                	addi	sp,sp,-16
    80002714:	e406                	sd	ra,8(sp)
    80002716:	e022                	sd	s0,0(sp)
    80002718:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000271a:	fffff097          	auipc	ra,0xfffff
    8000271e:	378080e7          	jalr	888(ra) # 80001a92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002722:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002726:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002728:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000272c:	00005617          	auipc	a2,0x5
    80002730:	8d460613          	addi	a2,a2,-1836 # 80007000 <_trampoline>
    80002734:	00005697          	auipc	a3,0x5
    80002738:	8cc68693          	addi	a3,a3,-1844 # 80007000 <_trampoline>
    8000273c:	8e91                	sub	a3,a3,a2
    8000273e:	040007b7          	lui	a5,0x4000
    80002742:	17fd                	addi	a5,a5,-1
    80002744:	07b2                	slli	a5,a5,0xc
    80002746:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002748:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000274c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000274e:	180026f3          	csrr	a3,satp
    80002752:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002754:	6d38                	ld	a4,88(a0)
    80002756:	6134                	ld	a3,64(a0)
    80002758:	6585                	lui	a1,0x1
    8000275a:	96ae                	add	a3,a3,a1
    8000275c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000275e:	6d38                	ld	a4,88(a0)
    80002760:	00000697          	auipc	a3,0x0
    80002764:	13268693          	addi	a3,a3,306 # 80002892 <usertrap>
    80002768:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000276a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000276c:	8692                	mv	a3,tp
    8000276e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002770:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002774:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002778:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000277c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002780:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002782:	6f18                	ld	a4,24(a4)
    80002784:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002788:	692c                	ld	a1,80(a0)
    8000278a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000278c:	00005717          	auipc	a4,0x5
    80002790:	90470713          	addi	a4,a4,-1788 # 80007090 <userret>
    80002794:	8f11                	sub	a4,a4,a2
    80002796:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(p->v_trapframe, satp);
    80002798:	577d                	li	a4,-1
    8000279a:	177e                	slli	a4,a4,0x3f
    8000279c:	8dd9                	or	a1,a1,a4
    8000279e:	7128                	ld	a0,96(a0)
    800027a0:	9782                	jalr	a5
}
    800027a2:	60a2                	ld	ra,8(sp)
    800027a4:	6402                	ld	s0,0(sp)
    800027a6:	0141                	addi	sp,sp,16
    800027a8:	8082                	ret

00000000800027aa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027aa:	1101                	addi	sp,sp,-32
    800027ac:	ec06                	sd	ra,24(sp)
    800027ae:	e822                	sd	s0,16(sp)
    800027b0:	e426                	sd	s1,8(sp)
    800027b2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027b4:	00015497          	auipc	s1,0x15
    800027b8:	1b448493          	addi	s1,s1,436 # 80017968 <tickslock>
    800027bc:	8526                	mv	a0,s1
    800027be:	ffffe097          	auipc	ra,0xffffe
    800027c2:	446080e7          	jalr	1094(ra) # 80000c04 <acquire>
  ticks++;
    800027c6:	00007517          	auipc	a0,0x7
    800027ca:	85a50513          	addi	a0,a0,-1958 # 80009020 <ticks>
    800027ce:	411c                	lw	a5,0(a0)
    800027d0:	2785                	addiw	a5,a5,1
    800027d2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	c2c080e7          	jalr	-980(ra) # 80002400 <wakeup>
  release(&tickslock);
    800027dc:	8526                	mv	a0,s1
    800027de:	ffffe097          	auipc	ra,0xffffe
    800027e2:	4da080e7          	jalr	1242(ra) # 80000cb8 <release>
}
    800027e6:	60e2                	ld	ra,24(sp)
    800027e8:	6442                	ld	s0,16(sp)
    800027ea:	64a2                	ld	s1,8(sp)
    800027ec:	6105                	addi	sp,sp,32
    800027ee:	8082                	ret

00000000800027f0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800027f0:	1101                	addi	sp,sp,-32
    800027f2:	ec06                	sd	ra,24(sp)
    800027f4:	e822                	sd	s0,16(sp)
    800027f6:	e426                	sd	s1,8(sp)
    800027f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027fa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027fe:	00074d63          	bltz	a4,80002818 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002802:	57fd                	li	a5,-1
    80002804:	17fe                	slli	a5,a5,0x3f
    80002806:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002808:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000280a:	06f70363          	beq	a4,a5,80002870 <devintr+0x80>
  }
}
    8000280e:	60e2                	ld	ra,24(sp)
    80002810:	6442                	ld	s0,16(sp)
    80002812:	64a2                	ld	s1,8(sp)
    80002814:	6105                	addi	sp,sp,32
    80002816:	8082                	ret
     (scause & 0xff) == 9){
    80002818:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000281c:	46a5                	li	a3,9
    8000281e:	fed792e3          	bne	a5,a3,80002802 <devintr+0x12>
    int irq = plic_claim();
    80002822:	00003097          	auipc	ra,0x3
    80002826:	4b6080e7          	jalr	1206(ra) # 80005cd8 <plic_claim>
    8000282a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000282c:	47a9                	li	a5,10
    8000282e:	02f50763          	beq	a0,a5,8000285c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002832:	4785                	li	a5,1
    80002834:	02f50963          	beq	a0,a5,80002866 <devintr+0x76>
    return 1;
    80002838:	4505                	li	a0,1
    } else if(irq){
    8000283a:	d8f1                	beqz	s1,8000280e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000283c:	85a6                	mv	a1,s1
    8000283e:	00006517          	auipc	a0,0x6
    80002842:	af250513          	addi	a0,a0,-1294 # 80008330 <states.1714+0x30>
    80002846:	ffffe097          	auipc	ra,0xffffe
    8000284a:	d58080e7          	jalr	-680(ra) # 8000059e <printf>
      plic_complete(irq);
    8000284e:	8526                	mv	a0,s1
    80002850:	00003097          	auipc	ra,0x3
    80002854:	4ac080e7          	jalr	1196(ra) # 80005cfc <plic_complete>
    return 1;
    80002858:	4505                	li	a0,1
    8000285a:	bf55                	j	8000280e <devintr+0x1e>
      uartintr();
    8000285c:	ffffe097          	auipc	ra,0xffffe
    80002860:	16c080e7          	jalr	364(ra) # 800009c8 <uartintr>
    80002864:	b7ed                	j	8000284e <devintr+0x5e>
      virtio_disk_intr();
    80002866:	00004097          	auipc	ra,0x4
    8000286a:	926080e7          	jalr	-1754(ra) # 8000618c <virtio_disk_intr>
    8000286e:	b7c5                	j	8000284e <devintr+0x5e>
    if(cpuid() == 0){
    80002870:	fffff097          	auipc	ra,0xfffff
    80002874:	1f6080e7          	jalr	502(ra) # 80001a66 <cpuid>
    80002878:	c901                	beqz	a0,80002888 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000287a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000287e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002880:	14479073          	csrw	sip,a5
    return 2;
    80002884:	4509                	li	a0,2
    80002886:	b761                	j	8000280e <devintr+0x1e>
      clockintr();
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	f22080e7          	jalr	-222(ra) # 800027aa <clockintr>
    80002890:	b7ed                	j	8000287a <devintr+0x8a>

0000000080002892 <usertrap>:
{
    80002892:	1101                	addi	sp,sp,-32
    80002894:	ec06                	sd	ra,24(sp)
    80002896:	e822                	sd	s0,16(sp)
    80002898:	e426                	sd	s1,8(sp)
    8000289a:	e04a                	sd	s2,0(sp)
    8000289c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000289e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800028a2:	1007f793          	andi	a5,a5,256
    800028a6:	e3ad                	bnez	a5,80002908 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a8:	00003797          	auipc	a5,0x3
    800028ac:	32878793          	addi	a5,a5,808 # 80005bd0 <kernelvec>
    800028b0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028b4:	fffff097          	auipc	ra,0xfffff
    800028b8:	1de080e7          	jalr	478(ra) # 80001a92 <myproc>
    800028bc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028be:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028c0:	14102773          	csrr	a4,sepc
    800028c4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028c6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028ca:	47a1                	li	a5,8
    800028cc:	04f71c63          	bne	a4,a5,80002924 <usertrap+0x92>
    if(p->killed)
    800028d0:	591c                	lw	a5,48(a0)
    800028d2:	e3b9                	bnez	a5,80002918 <usertrap+0x86>
    p->trapframe->epc += 4;
    800028d4:	6cb8                	ld	a4,88(s1)
    800028d6:	6f1c                	ld	a5,24(a4)
    800028d8:	0791                	addi	a5,a5,4
    800028da:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028dc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028e0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028e4:	10079073          	csrw	sstatus,a5
    syscall();
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	2e0080e7          	jalr	736(ra) # 80002bc8 <syscall>
  if(p->killed)
    800028f0:	589c                	lw	a5,48(s1)
    800028f2:	ebc1                	bnez	a5,80002982 <usertrap+0xf0>
  usertrapret();
    800028f4:	00000097          	auipc	ra,0x0
    800028f8:	e1e080e7          	jalr	-482(ra) # 80002712 <usertrapret>
}
    800028fc:	60e2                	ld	ra,24(sp)
    800028fe:	6442                	ld	s0,16(sp)
    80002900:	64a2                	ld	s1,8(sp)
    80002902:	6902                	ld	s2,0(sp)
    80002904:	6105                	addi	sp,sp,32
    80002906:	8082                	ret
    panic("usertrap: not from user mode");
    80002908:	00006517          	auipc	a0,0x6
    8000290c:	a4850513          	addi	a0,a0,-1464 # 80008350 <states.1714+0x50>
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	c44080e7          	jalr	-956(ra) # 80000554 <panic>
      exit(-1);
    80002918:	557d                	li	a0,-1
    8000291a:	00000097          	auipc	ra,0x0
    8000291e:	81a080e7          	jalr	-2022(ra) # 80002134 <exit>
    80002922:	bf4d                	j	800028d4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002924:	00000097          	auipc	ra,0x0
    80002928:	ecc080e7          	jalr	-308(ra) # 800027f0 <devintr>
    8000292c:	892a                	mv	s2,a0
    8000292e:	c501                	beqz	a0,80002936 <usertrap+0xa4>
  if(p->killed)
    80002930:	589c                	lw	a5,48(s1)
    80002932:	c3a1                	beqz	a5,80002972 <usertrap+0xe0>
    80002934:	a815                	j	80002968 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002936:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000293a:	5c90                	lw	a2,56(s1)
    8000293c:	00006517          	auipc	a0,0x6
    80002940:	a3450513          	addi	a0,a0,-1484 # 80008370 <states.1714+0x70>
    80002944:	ffffe097          	auipc	ra,0xffffe
    80002948:	c5a080e7          	jalr	-934(ra) # 8000059e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000294c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002950:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002954:	00006517          	auipc	a0,0x6
    80002958:	a4c50513          	addi	a0,a0,-1460 # 800083a0 <states.1714+0xa0>
    8000295c:	ffffe097          	auipc	ra,0xffffe
    80002960:	c42080e7          	jalr	-958(ra) # 8000059e <printf>
    p->killed = 1;
    80002964:	4785                	li	a5,1
    80002966:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002968:	557d                	li	a0,-1
    8000296a:	fffff097          	auipc	ra,0xfffff
    8000296e:	7ca080e7          	jalr	1994(ra) # 80002134 <exit>
  if(which_dev == 2)
    80002972:	4789                	li	a5,2
    80002974:	f8f910e3          	bne	s2,a5,800028f4 <usertrap+0x62>
    yield();
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	8c6080e7          	jalr	-1850(ra) # 8000223e <yield>
    80002980:	bf95                	j	800028f4 <usertrap+0x62>
  int which_dev = 0;
    80002982:	4901                	li	s2,0
    80002984:	b7d5                	j	80002968 <usertrap+0xd6>

0000000080002986 <kerneltrap>:
{
    80002986:	7179                	addi	sp,sp,-48
    80002988:	f406                	sd	ra,40(sp)
    8000298a:	f022                	sd	s0,32(sp)
    8000298c:	ec26                	sd	s1,24(sp)
    8000298e:	e84a                	sd	s2,16(sp)
    80002990:	e44e                	sd	s3,8(sp)
    80002992:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002994:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002998:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000299c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029a0:	1004f793          	andi	a5,s1,256
    800029a4:	cb85                	beqz	a5,800029d4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029aa:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029ac:	ef85                	bnez	a5,800029e4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	e42080e7          	jalr	-446(ra) # 800027f0 <devintr>
    800029b6:	cd1d                	beqz	a0,800029f4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029b8:	4789                	li	a5,2
    800029ba:	06f50a63          	beq	a0,a5,80002a2e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029be:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029c2:	10049073          	csrw	sstatus,s1
}
    800029c6:	70a2                	ld	ra,40(sp)
    800029c8:	7402                	ld	s0,32(sp)
    800029ca:	64e2                	ld	s1,24(sp)
    800029cc:	6942                	ld	s2,16(sp)
    800029ce:	69a2                	ld	s3,8(sp)
    800029d0:	6145                	addi	sp,sp,48
    800029d2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029d4:	00006517          	auipc	a0,0x6
    800029d8:	9ec50513          	addi	a0,a0,-1556 # 800083c0 <states.1714+0xc0>
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	b78080e7          	jalr	-1160(ra) # 80000554 <panic>
    panic("kerneltrap: interrupts enabled");
    800029e4:	00006517          	auipc	a0,0x6
    800029e8:	a0450513          	addi	a0,a0,-1532 # 800083e8 <states.1714+0xe8>
    800029ec:	ffffe097          	auipc	ra,0xffffe
    800029f0:	b68080e7          	jalr	-1176(ra) # 80000554 <panic>
    printf("scause %p\n", scause);
    800029f4:	85ce                	mv	a1,s3
    800029f6:	00006517          	auipc	a0,0x6
    800029fa:	a1250513          	addi	a0,a0,-1518 # 80008408 <states.1714+0x108>
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	ba0080e7          	jalr	-1120(ra) # 8000059e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a06:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a0a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	a0a50513          	addi	a0,a0,-1526 # 80008418 <states.1714+0x118>
    80002a16:	ffffe097          	auipc	ra,0xffffe
    80002a1a:	b88080e7          	jalr	-1144(ra) # 8000059e <printf>
    panic("kerneltrap");
    80002a1e:	00006517          	auipc	a0,0x6
    80002a22:	a1250513          	addi	a0,a0,-1518 # 80008430 <states.1714+0x130>
    80002a26:	ffffe097          	auipc	ra,0xffffe
    80002a2a:	b2e080e7          	jalr	-1234(ra) # 80000554 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a2e:	fffff097          	auipc	ra,0xfffff
    80002a32:	064080e7          	jalr	100(ra) # 80001a92 <myproc>
    80002a36:	d541                	beqz	a0,800029be <kerneltrap+0x38>
    80002a38:	fffff097          	auipc	ra,0xfffff
    80002a3c:	05a080e7          	jalr	90(ra) # 80001a92 <myproc>
    80002a40:	4d18                	lw	a4,24(a0)
    80002a42:	478d                	li	a5,3
    80002a44:	f6f71de3          	bne	a4,a5,800029be <kerneltrap+0x38>
    yield();
    80002a48:	fffff097          	auipc	ra,0xfffff
    80002a4c:	7f6080e7          	jalr	2038(ra) # 8000223e <yield>
    80002a50:	b7bd                	j	800029be <kerneltrap+0x38>

0000000080002a52 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a52:	1101                	addi	sp,sp,-32
    80002a54:	ec06                	sd	ra,24(sp)
    80002a56:	e822                	sd	s0,16(sp)
    80002a58:	e426                	sd	s1,8(sp)
    80002a5a:	1000                	addi	s0,sp,32
    80002a5c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a5e:	fffff097          	auipc	ra,0xfffff
    80002a62:	034080e7          	jalr	52(ra) # 80001a92 <myproc>
  switch (n) {
    80002a66:	4795                	li	a5,5
    80002a68:	0497e163          	bltu	a5,s1,80002aaa <argraw+0x58>
    80002a6c:	048a                	slli	s1,s1,0x2
    80002a6e:	00006717          	auipc	a4,0x6
    80002a72:	9fa70713          	addi	a4,a4,-1542 # 80008468 <states.1714+0x168>
    80002a76:	94ba                	add	s1,s1,a4
    80002a78:	409c                	lw	a5,0(s1)
    80002a7a:	97ba                	add	a5,a5,a4
    80002a7c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a7e:	6d3c                	ld	a5,88(a0)
    80002a80:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a82:	60e2                	ld	ra,24(sp)
    80002a84:	6442                	ld	s0,16(sp)
    80002a86:	64a2                	ld	s1,8(sp)
    80002a88:	6105                	addi	sp,sp,32
    80002a8a:	8082                	ret
    return p->trapframe->a1;
    80002a8c:	6d3c                	ld	a5,88(a0)
    80002a8e:	7fa8                	ld	a0,120(a5)
    80002a90:	bfcd                	j	80002a82 <argraw+0x30>
    return p->trapframe->a2;
    80002a92:	6d3c                	ld	a5,88(a0)
    80002a94:	63c8                	ld	a0,128(a5)
    80002a96:	b7f5                	j	80002a82 <argraw+0x30>
    return p->trapframe->a3;
    80002a98:	6d3c                	ld	a5,88(a0)
    80002a9a:	67c8                	ld	a0,136(a5)
    80002a9c:	b7dd                	j	80002a82 <argraw+0x30>
    return p->trapframe->a4;
    80002a9e:	6d3c                	ld	a5,88(a0)
    80002aa0:	6bc8                	ld	a0,144(a5)
    80002aa2:	b7c5                	j	80002a82 <argraw+0x30>
    return p->trapframe->a5;
    80002aa4:	6d3c                	ld	a5,88(a0)
    80002aa6:	6fc8                	ld	a0,152(a5)
    80002aa8:	bfe9                	j	80002a82 <argraw+0x30>
  panic("argraw");
    80002aaa:	00006517          	auipc	a0,0x6
    80002aae:	99650513          	addi	a0,a0,-1642 # 80008440 <states.1714+0x140>
    80002ab2:	ffffe097          	auipc	ra,0xffffe
    80002ab6:	aa2080e7          	jalr	-1374(ra) # 80000554 <panic>

0000000080002aba <fetchaddr>:
{
    80002aba:	1101                	addi	sp,sp,-32
    80002abc:	ec06                	sd	ra,24(sp)
    80002abe:	e822                	sd	s0,16(sp)
    80002ac0:	e426                	sd	s1,8(sp)
    80002ac2:	e04a                	sd	s2,0(sp)
    80002ac4:	1000                	addi	s0,sp,32
    80002ac6:	84aa                	mv	s1,a0
    80002ac8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002aca:	fffff097          	auipc	ra,0xfffff
    80002ace:	fc8080e7          	jalr	-56(ra) # 80001a92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002ad2:	653c                	ld	a5,72(a0)
    80002ad4:	02f4f863          	bgeu	s1,a5,80002b04 <fetchaddr+0x4a>
    80002ad8:	00848713          	addi	a4,s1,8
    80002adc:	02e7e663          	bltu	a5,a4,80002b08 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ae0:	46a1                	li	a3,8
    80002ae2:	8626                	mv	a2,s1
    80002ae4:	85ca                	mv	a1,s2
    80002ae6:	6928                	ld	a0,80(a0)
    80002ae8:	fffff097          	auipc	ra,0xfffff
    80002aec:	c6a080e7          	jalr	-918(ra) # 80001752 <copyin>
    80002af0:	00a03533          	snez	a0,a0
    80002af4:	40a00533          	neg	a0,a0
}
    80002af8:	60e2                	ld	ra,24(sp)
    80002afa:	6442                	ld	s0,16(sp)
    80002afc:	64a2                	ld	s1,8(sp)
    80002afe:	6902                	ld	s2,0(sp)
    80002b00:	6105                	addi	sp,sp,32
    80002b02:	8082                	ret
    return -1;
    80002b04:	557d                	li	a0,-1
    80002b06:	bfcd                	j	80002af8 <fetchaddr+0x3e>
    80002b08:	557d                	li	a0,-1
    80002b0a:	b7fd                	j	80002af8 <fetchaddr+0x3e>

0000000080002b0c <fetchstr>:
{
    80002b0c:	7179                	addi	sp,sp,-48
    80002b0e:	f406                	sd	ra,40(sp)
    80002b10:	f022                	sd	s0,32(sp)
    80002b12:	ec26                	sd	s1,24(sp)
    80002b14:	e84a                	sd	s2,16(sp)
    80002b16:	e44e                	sd	s3,8(sp)
    80002b18:	1800                	addi	s0,sp,48
    80002b1a:	892a                	mv	s2,a0
    80002b1c:	84ae                	mv	s1,a1
    80002b1e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b20:	fffff097          	auipc	ra,0xfffff
    80002b24:	f72080e7          	jalr	-142(ra) # 80001a92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002b28:	86ce                	mv	a3,s3
    80002b2a:	864a                	mv	a2,s2
    80002b2c:	85a6                	mv	a1,s1
    80002b2e:	6928                	ld	a0,80(a0)
    80002b30:	fffff097          	auipc	ra,0xfffff
    80002b34:	cae080e7          	jalr	-850(ra) # 800017de <copyinstr>
  if(err < 0)
    80002b38:	00054763          	bltz	a0,80002b46 <fetchstr+0x3a>
  return strlen(buf);
    80002b3c:	8526                	mv	a0,s1
    80002b3e:	ffffe097          	auipc	ra,0xffffe
    80002b42:	34a080e7          	jalr	842(ra) # 80000e88 <strlen>
}
    80002b46:	70a2                	ld	ra,40(sp)
    80002b48:	7402                	ld	s0,32(sp)
    80002b4a:	64e2                	ld	s1,24(sp)
    80002b4c:	6942                	ld	s2,16(sp)
    80002b4e:	69a2                	ld	s3,8(sp)
    80002b50:	6145                	addi	sp,sp,48
    80002b52:	8082                	ret

0000000080002b54 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b54:	1101                	addi	sp,sp,-32
    80002b56:	ec06                	sd	ra,24(sp)
    80002b58:	e822                	sd	s0,16(sp)
    80002b5a:	e426                	sd	s1,8(sp)
    80002b5c:	1000                	addi	s0,sp,32
    80002b5e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	ef2080e7          	jalr	-270(ra) # 80002a52 <argraw>
    80002b68:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b6a:	4501                	li	a0,0
    80002b6c:	60e2                	ld	ra,24(sp)
    80002b6e:	6442                	ld	s0,16(sp)
    80002b70:	64a2                	ld	s1,8(sp)
    80002b72:	6105                	addi	sp,sp,32
    80002b74:	8082                	ret

0000000080002b76 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b76:	1101                	addi	sp,sp,-32
    80002b78:	ec06                	sd	ra,24(sp)
    80002b7a:	e822                	sd	s0,16(sp)
    80002b7c:	e426                	sd	s1,8(sp)
    80002b7e:	1000                	addi	s0,sp,32
    80002b80:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	ed0080e7          	jalr	-304(ra) # 80002a52 <argraw>
    80002b8a:	e088                	sd	a0,0(s1)
  return 0;
}
    80002b8c:	4501                	li	a0,0
    80002b8e:	60e2                	ld	ra,24(sp)
    80002b90:	6442                	ld	s0,16(sp)
    80002b92:	64a2                	ld	s1,8(sp)
    80002b94:	6105                	addi	sp,sp,32
    80002b96:	8082                	ret

0000000080002b98 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b98:	1101                	addi	sp,sp,-32
    80002b9a:	ec06                	sd	ra,24(sp)
    80002b9c:	e822                	sd	s0,16(sp)
    80002b9e:	e426                	sd	s1,8(sp)
    80002ba0:	e04a                	sd	s2,0(sp)
    80002ba2:	1000                	addi	s0,sp,32
    80002ba4:	84ae                	mv	s1,a1
    80002ba6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	eaa080e7          	jalr	-342(ra) # 80002a52 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002bb0:	864a                	mv	a2,s2
    80002bb2:	85a6                	mv	a1,s1
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	f58080e7          	jalr	-168(ra) # 80002b0c <fetchstr>
}
    80002bbc:	60e2                	ld	ra,24(sp)
    80002bbe:	6442                	ld	s0,16(sp)
    80002bc0:	64a2                	ld	s1,8(sp)
    80002bc2:	6902                	ld	s2,0(sp)
    80002bc4:	6105                	addi	sp,sp,32
    80002bc6:	8082                	ret

0000000080002bc8 <syscall>:
[SYS_numprocs] sys_numprocs,
};

void
syscall(void)
{
    80002bc8:	1101                	addi	sp,sp,-32
    80002bca:	ec06                	sd	ra,24(sp)
    80002bcc:	e822                	sd	s0,16(sp)
    80002bce:	e426                	sd	s1,8(sp)
    80002bd0:	e04a                	sd	s2,0(sp)
    80002bd2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bd4:	fffff097          	auipc	ra,0xfffff
    80002bd8:	ebe080e7          	jalr	-322(ra) # 80001a92 <myproc>
    80002bdc:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002bde:	05853903          	ld	s2,88(a0)
    80002be2:	0a893783          	ld	a5,168(s2)
    80002be6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002bea:	37fd                	addiw	a5,a5,-1
    80002bec:	4755                	li	a4,21
    80002bee:	00f76f63          	bltu	a4,a5,80002c0c <syscall+0x44>
    80002bf2:	00369713          	slli	a4,a3,0x3
    80002bf6:	00006797          	auipc	a5,0x6
    80002bfa:	88a78793          	addi	a5,a5,-1910 # 80008480 <syscalls>
    80002bfe:	97ba                	add	a5,a5,a4
    80002c00:	639c                	ld	a5,0(a5)
    80002c02:	c789                	beqz	a5,80002c0c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002c04:	9782                	jalr	a5
    80002c06:	06a93823          	sd	a0,112(s2)
    80002c0a:	a839                	j	80002c28 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c0c:	16048613          	addi	a2,s1,352
    80002c10:	5c8c                	lw	a1,56(s1)
    80002c12:	00006517          	auipc	a0,0x6
    80002c16:	83650513          	addi	a0,a0,-1994 # 80008448 <states.1714+0x148>
    80002c1a:	ffffe097          	auipc	ra,0xffffe
    80002c1e:	984080e7          	jalr	-1660(ra) # 8000059e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c22:	6cbc                	ld	a5,88(s1)
    80002c24:	577d                	li	a4,-1
    80002c26:	fbb8                	sd	a4,112(a5)
  }
}
    80002c28:	60e2                	ld	ra,24(sp)
    80002c2a:	6442                	ld	s0,16(sp)
    80002c2c:	64a2                	ld	s1,8(sp)
    80002c2e:	6902                	ld	s2,0(sp)
    80002c30:	6105                	addi	sp,sp,32
    80002c32:	8082                	ret

0000000080002c34 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c34:	1101                	addi	sp,sp,-32
    80002c36:	ec06                	sd	ra,24(sp)
    80002c38:	e822                	sd	s0,16(sp)
    80002c3a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c3c:	fec40593          	addi	a1,s0,-20
    80002c40:	4501                	li	a0,0
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	f12080e7          	jalr	-238(ra) # 80002b54 <argint>
    return -1;
    80002c4a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c4c:	00054963          	bltz	a0,80002c5e <sys_exit+0x2a>
  exit(n);
    80002c50:	fec42503          	lw	a0,-20(s0)
    80002c54:	fffff097          	auipc	ra,0xfffff
    80002c58:	4e0080e7          	jalr	1248(ra) # 80002134 <exit>
  return 0;  // not reached
    80002c5c:	4781                	li	a5,0
}
    80002c5e:	853e                	mv	a0,a5
    80002c60:	60e2                	ld	ra,24(sp)
    80002c62:	6442                	ld	s0,16(sp)
    80002c64:	6105                	addi	sp,sp,32
    80002c66:	8082                	ret

0000000080002c68 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c68:	1141                	addi	sp,sp,-16
    80002c6a:	e406                	sd	ra,8(sp)
    80002c6c:	e022                	sd	s0,0(sp)
    80002c6e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c70:	fffff097          	auipc	ra,0xfffff
    80002c74:	e22080e7          	jalr	-478(ra) # 80001a92 <myproc>
}
    80002c78:	5d08                	lw	a0,56(a0)
    80002c7a:	60a2                	ld	ra,8(sp)
    80002c7c:	6402                	ld	s0,0(sp)
    80002c7e:	0141                	addi	sp,sp,16
    80002c80:	8082                	ret

0000000080002c82 <sys_fork>:

uint64
sys_fork(void)
{
    80002c82:	1141                	addi	sp,sp,-16
    80002c84:	e406                	sd	ra,8(sp)
    80002c86:	e022                	sd	s0,0(sp)
    80002c88:	0800                	addi	s0,sp,16
  return fork();
    80002c8a:	fffff097          	auipc	ra,0xfffff
    80002c8e:	1c4080e7          	jalr	452(ra) # 80001e4e <fork>
}
    80002c92:	60a2                	ld	ra,8(sp)
    80002c94:	6402                	ld	s0,0(sp)
    80002c96:	0141                	addi	sp,sp,16
    80002c98:	8082                	ret

0000000080002c9a <sys_wait>:

uint64
sys_wait(void)
{
    80002c9a:	1101                	addi	sp,sp,-32
    80002c9c:	ec06                	sd	ra,24(sp)
    80002c9e:	e822                	sd	s0,16(sp)
    80002ca0:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002ca2:	fe840593          	addi	a1,s0,-24
    80002ca6:	4501                	li	a0,0
    80002ca8:	00000097          	auipc	ra,0x0
    80002cac:	ece080e7          	jalr	-306(ra) # 80002b76 <argaddr>
    80002cb0:	87aa                	mv	a5,a0
    return -1;
    80002cb2:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002cb4:	0007c863          	bltz	a5,80002cc4 <sys_wait+0x2a>
  return wait(p);
    80002cb8:	fe843503          	ld	a0,-24(s0)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	63c080e7          	jalr	1596(ra) # 800022f8 <wait>
}
    80002cc4:	60e2                	ld	ra,24(sp)
    80002cc6:	6442                	ld	s0,16(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret

0000000080002ccc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002ccc:	7179                	addi	sp,sp,-48
    80002cce:	f406                	sd	ra,40(sp)
    80002cd0:	f022                	sd	s0,32(sp)
    80002cd2:	ec26                	sd	s1,24(sp)
    80002cd4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002cd6:	fdc40593          	addi	a1,s0,-36
    80002cda:	4501                	li	a0,0
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	e78080e7          	jalr	-392(ra) # 80002b54 <argint>
    80002ce4:	87aa                	mv	a5,a0
    return -1;
    80002ce6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002ce8:	0207c063          	bltz	a5,80002d08 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002cec:	fffff097          	auipc	ra,0xfffff
    80002cf0:	da6080e7          	jalr	-602(ra) # 80001a92 <myproc>
    80002cf4:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002cf6:	fdc42503          	lw	a0,-36(s0)
    80002cfa:	fffff097          	auipc	ra,0xfffff
    80002cfe:	0e0080e7          	jalr	224(ra) # 80001dda <growproc>
    80002d02:	00054863          	bltz	a0,80002d12 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002d06:	8526                	mv	a0,s1
}
    80002d08:	70a2                	ld	ra,40(sp)
    80002d0a:	7402                	ld	s0,32(sp)
    80002d0c:	64e2                	ld	s1,24(sp)
    80002d0e:	6145                	addi	sp,sp,48
    80002d10:	8082                	ret
    return -1;
    80002d12:	557d                	li	a0,-1
    80002d14:	bfd5                	j	80002d08 <sys_sbrk+0x3c>

0000000080002d16 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d16:	7139                	addi	sp,sp,-64
    80002d18:	fc06                	sd	ra,56(sp)
    80002d1a:	f822                	sd	s0,48(sp)
    80002d1c:	f426                	sd	s1,40(sp)
    80002d1e:	f04a                	sd	s2,32(sp)
    80002d20:	ec4e                	sd	s3,24(sp)
    80002d22:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d24:	fcc40593          	addi	a1,s0,-52
    80002d28:	4501                	li	a0,0
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	e2a080e7          	jalr	-470(ra) # 80002b54 <argint>
    return -1;
    80002d32:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d34:	06054563          	bltz	a0,80002d9e <sys_sleep+0x88>
  acquire(&tickslock);
    80002d38:	00015517          	auipc	a0,0x15
    80002d3c:	c3050513          	addi	a0,a0,-976 # 80017968 <tickslock>
    80002d40:	ffffe097          	auipc	ra,0xffffe
    80002d44:	ec4080e7          	jalr	-316(ra) # 80000c04 <acquire>
  ticks0 = ticks;
    80002d48:	00006917          	auipc	s2,0x6
    80002d4c:	2d892903          	lw	s2,728(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002d50:	fcc42783          	lw	a5,-52(s0)
    80002d54:	cf85                	beqz	a5,80002d8c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d56:	00015997          	auipc	s3,0x15
    80002d5a:	c1298993          	addi	s3,s3,-1006 # 80017968 <tickslock>
    80002d5e:	00006497          	auipc	s1,0x6
    80002d62:	2c248493          	addi	s1,s1,706 # 80009020 <ticks>
    if(myproc()->killed){
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	d2c080e7          	jalr	-724(ra) # 80001a92 <myproc>
    80002d6e:	591c                	lw	a5,48(a0)
    80002d70:	ef9d                	bnez	a5,80002dae <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002d72:	85ce                	mv	a1,s3
    80002d74:	8526                	mv	a0,s1
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	504080e7          	jalr	1284(ra) # 8000227a <sleep>
  while(ticks - ticks0 < n){
    80002d7e:	409c                	lw	a5,0(s1)
    80002d80:	412787bb          	subw	a5,a5,s2
    80002d84:	fcc42703          	lw	a4,-52(s0)
    80002d88:	fce7efe3          	bltu	a5,a4,80002d66 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002d8c:	00015517          	auipc	a0,0x15
    80002d90:	bdc50513          	addi	a0,a0,-1060 # 80017968 <tickslock>
    80002d94:	ffffe097          	auipc	ra,0xffffe
    80002d98:	f24080e7          	jalr	-220(ra) # 80000cb8 <release>
  return 0;
    80002d9c:	4781                	li	a5,0
}
    80002d9e:	853e                	mv	a0,a5
    80002da0:	70e2                	ld	ra,56(sp)
    80002da2:	7442                	ld	s0,48(sp)
    80002da4:	74a2                	ld	s1,40(sp)
    80002da6:	7902                	ld	s2,32(sp)
    80002da8:	69e2                	ld	s3,24(sp)
    80002daa:	6121                	addi	sp,sp,64
    80002dac:	8082                	ret
      release(&tickslock);
    80002dae:	00015517          	auipc	a0,0x15
    80002db2:	bba50513          	addi	a0,a0,-1094 # 80017968 <tickslock>
    80002db6:	ffffe097          	auipc	ra,0xffffe
    80002dba:	f02080e7          	jalr	-254(ra) # 80000cb8 <release>
      return -1;
    80002dbe:	57fd                	li	a5,-1
    80002dc0:	bff9                	j	80002d9e <sys_sleep+0x88>

0000000080002dc2 <sys_kill>:

uint64
sys_kill(void)
{
    80002dc2:	1101                	addi	sp,sp,-32
    80002dc4:	ec06                	sd	ra,24(sp)
    80002dc6:	e822                	sd	s0,16(sp)
    80002dc8:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002dca:	fec40593          	addi	a1,s0,-20
    80002dce:	4501                	li	a0,0
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	d84080e7          	jalr	-636(ra) # 80002b54 <argint>
    80002dd8:	87aa                	mv	a5,a0
    return -1;
    80002dda:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002ddc:	0007c863          	bltz	a5,80002dec <sys_kill+0x2a>
  return kill(pid);
    80002de0:	fec42503          	lw	a0,-20(s0)
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	686080e7          	jalr	1670(ra) # 8000246a <kill>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret

0000000080002df4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002df4:	1101                	addi	sp,sp,-32
    80002df6:	ec06                	sd	ra,24(sp)
    80002df8:	e822                	sd	s0,16(sp)
    80002dfa:	e426                	sd	s1,8(sp)
    80002dfc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dfe:	00015517          	auipc	a0,0x15
    80002e02:	b6a50513          	addi	a0,a0,-1174 # 80017968 <tickslock>
    80002e06:	ffffe097          	auipc	ra,0xffffe
    80002e0a:	dfe080e7          	jalr	-514(ra) # 80000c04 <acquire>
  xticks = ticks;
    80002e0e:	00006497          	auipc	s1,0x6
    80002e12:	2124a483          	lw	s1,530(s1) # 80009020 <ticks>
  release(&tickslock);
    80002e16:	00015517          	auipc	a0,0x15
    80002e1a:	b5250513          	addi	a0,a0,-1198 # 80017968 <tickslock>
    80002e1e:	ffffe097          	auipc	ra,0xffffe
    80002e22:	e9a080e7          	jalr	-358(ra) # 80000cb8 <release>
  return xticks;
}
    80002e26:	02049513          	slli	a0,s1,0x20
    80002e2a:	9101                	srli	a0,a0,0x20
    80002e2c:	60e2                	ld	ra,24(sp)
    80002e2e:	6442                	ld	s0,16(sp)
    80002e30:	64a2                	ld	s1,8(sp)
    80002e32:	6105                	addi	sp,sp,32
    80002e34:	8082                	ret

0000000080002e36 <sys_numprocs>:

uint64
sys_numprocs(void)
{return numprocs();
    80002e36:	1141                	addi	sp,sp,-16
    80002e38:	e406                	sd	ra,8(sp)
    80002e3a:	e022                	sd	s0,0(sp)
    80002e3c:	0800                	addi	s0,sp,16
    80002e3e:	fffff097          	auipc	ra,0xfffff
    80002e42:	7f6080e7          	jalr	2038(ra) # 80002634 <numprocs>
}
    80002e46:	60a2                	ld	ra,8(sp)
    80002e48:	6402                	ld	s0,0(sp)
    80002e4a:	0141                	addi	sp,sp,16
    80002e4c:	8082                	ret

0000000080002e4e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e4e:	7179                	addi	sp,sp,-48
    80002e50:	f406                	sd	ra,40(sp)
    80002e52:	f022                	sd	s0,32(sp)
    80002e54:	ec26                	sd	s1,24(sp)
    80002e56:	e84a                	sd	s2,16(sp)
    80002e58:	e44e                	sd	s3,8(sp)
    80002e5a:	e052                	sd	s4,0(sp)
    80002e5c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e5e:	00005597          	auipc	a1,0x5
    80002e62:	6da58593          	addi	a1,a1,1754 # 80008538 <syscalls+0xb8>
    80002e66:	00015517          	auipc	a0,0x15
    80002e6a:	b1a50513          	addi	a0,a0,-1254 # 80017980 <bcache>
    80002e6e:	ffffe097          	auipc	ra,0xffffe
    80002e72:	d06080e7          	jalr	-762(ra) # 80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e76:	0001d797          	auipc	a5,0x1d
    80002e7a:	b0a78793          	addi	a5,a5,-1270 # 8001f980 <bcache+0x8000>
    80002e7e:	0001d717          	auipc	a4,0x1d
    80002e82:	d6a70713          	addi	a4,a4,-662 # 8001fbe8 <bcache+0x8268>
    80002e86:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e8a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e8e:	00015497          	auipc	s1,0x15
    80002e92:	b0a48493          	addi	s1,s1,-1270 # 80017998 <bcache+0x18>
    b->next = bcache.head.next;
    80002e96:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e98:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e9a:	00005a17          	auipc	s4,0x5
    80002e9e:	6a6a0a13          	addi	s4,s4,1702 # 80008540 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002ea2:	2b893783          	ld	a5,696(s2)
    80002ea6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002ea8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002eac:	85d2                	mv	a1,s4
    80002eae:	01048513          	addi	a0,s1,16
    80002eb2:	00001097          	auipc	ra,0x1
    80002eb6:	4ac080e7          	jalr	1196(ra) # 8000435e <initsleeplock>
    bcache.head.next->prev = b;
    80002eba:	2b893783          	ld	a5,696(s2)
    80002ebe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ec0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ec4:	45848493          	addi	s1,s1,1112
    80002ec8:	fd349de3          	bne	s1,s3,80002ea2 <binit+0x54>
  }
}
    80002ecc:	70a2                	ld	ra,40(sp)
    80002ece:	7402                	ld	s0,32(sp)
    80002ed0:	64e2                	ld	s1,24(sp)
    80002ed2:	6942                	ld	s2,16(sp)
    80002ed4:	69a2                	ld	s3,8(sp)
    80002ed6:	6a02                	ld	s4,0(sp)
    80002ed8:	6145                	addi	sp,sp,48
    80002eda:	8082                	ret

0000000080002edc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002edc:	7179                	addi	sp,sp,-48
    80002ede:	f406                	sd	ra,40(sp)
    80002ee0:	f022                	sd	s0,32(sp)
    80002ee2:	ec26                	sd	s1,24(sp)
    80002ee4:	e84a                	sd	s2,16(sp)
    80002ee6:	e44e                	sd	s3,8(sp)
    80002ee8:	1800                	addi	s0,sp,48
    80002eea:	89aa                	mv	s3,a0
    80002eec:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002eee:	00015517          	auipc	a0,0x15
    80002ef2:	a9250513          	addi	a0,a0,-1390 # 80017980 <bcache>
    80002ef6:	ffffe097          	auipc	ra,0xffffe
    80002efa:	d0e080e7          	jalr	-754(ra) # 80000c04 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002efe:	0001d497          	auipc	s1,0x1d
    80002f02:	d3a4b483          	ld	s1,-710(s1) # 8001fc38 <bcache+0x82b8>
    80002f06:	0001d797          	auipc	a5,0x1d
    80002f0a:	ce278793          	addi	a5,a5,-798 # 8001fbe8 <bcache+0x8268>
    80002f0e:	02f48f63          	beq	s1,a5,80002f4c <bread+0x70>
    80002f12:	873e                	mv	a4,a5
    80002f14:	a021                	j	80002f1c <bread+0x40>
    80002f16:	68a4                	ld	s1,80(s1)
    80002f18:	02e48a63          	beq	s1,a4,80002f4c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f1c:	449c                	lw	a5,8(s1)
    80002f1e:	ff379ce3          	bne	a5,s3,80002f16 <bread+0x3a>
    80002f22:	44dc                	lw	a5,12(s1)
    80002f24:	ff2799e3          	bne	a5,s2,80002f16 <bread+0x3a>
      b->refcnt++;
    80002f28:	40bc                	lw	a5,64(s1)
    80002f2a:	2785                	addiw	a5,a5,1
    80002f2c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f2e:	00015517          	auipc	a0,0x15
    80002f32:	a5250513          	addi	a0,a0,-1454 # 80017980 <bcache>
    80002f36:	ffffe097          	auipc	ra,0xffffe
    80002f3a:	d82080e7          	jalr	-638(ra) # 80000cb8 <release>
      acquiresleep(&b->lock);
    80002f3e:	01048513          	addi	a0,s1,16
    80002f42:	00001097          	auipc	ra,0x1
    80002f46:	456080e7          	jalr	1110(ra) # 80004398 <acquiresleep>
      return b;
    80002f4a:	a8b9                	j	80002fa8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f4c:	0001d497          	auipc	s1,0x1d
    80002f50:	ce44b483          	ld	s1,-796(s1) # 8001fc30 <bcache+0x82b0>
    80002f54:	0001d797          	auipc	a5,0x1d
    80002f58:	c9478793          	addi	a5,a5,-876 # 8001fbe8 <bcache+0x8268>
    80002f5c:	00f48863          	beq	s1,a5,80002f6c <bread+0x90>
    80002f60:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f62:	40bc                	lw	a5,64(s1)
    80002f64:	cf81                	beqz	a5,80002f7c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f66:	64a4                	ld	s1,72(s1)
    80002f68:	fee49de3          	bne	s1,a4,80002f62 <bread+0x86>
  panic("bget: no buffers");
    80002f6c:	00005517          	auipc	a0,0x5
    80002f70:	5dc50513          	addi	a0,a0,1500 # 80008548 <syscalls+0xc8>
    80002f74:	ffffd097          	auipc	ra,0xffffd
    80002f78:	5e0080e7          	jalr	1504(ra) # 80000554 <panic>
      b->dev = dev;
    80002f7c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002f80:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002f84:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f88:	4785                	li	a5,1
    80002f8a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f8c:	00015517          	auipc	a0,0x15
    80002f90:	9f450513          	addi	a0,a0,-1548 # 80017980 <bcache>
    80002f94:	ffffe097          	auipc	ra,0xffffe
    80002f98:	d24080e7          	jalr	-732(ra) # 80000cb8 <release>
      acquiresleep(&b->lock);
    80002f9c:	01048513          	addi	a0,s1,16
    80002fa0:	00001097          	auipc	ra,0x1
    80002fa4:	3f8080e7          	jalr	1016(ra) # 80004398 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002fa8:	409c                	lw	a5,0(s1)
    80002faa:	cb89                	beqz	a5,80002fbc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fac:	8526                	mv	a0,s1
    80002fae:	70a2                	ld	ra,40(sp)
    80002fb0:	7402                	ld	s0,32(sp)
    80002fb2:	64e2                	ld	s1,24(sp)
    80002fb4:	6942                	ld	s2,16(sp)
    80002fb6:	69a2                	ld	s3,8(sp)
    80002fb8:	6145                	addi	sp,sp,48
    80002fba:	8082                	ret
    virtio_disk_rw(b, 0);
    80002fbc:	4581                	li	a1,0
    80002fbe:	8526                	mv	a0,s1
    80002fc0:	00003097          	auipc	ra,0x3
    80002fc4:	f2c080e7          	jalr	-212(ra) # 80005eec <virtio_disk_rw>
    b->valid = 1;
    80002fc8:	4785                	li	a5,1
    80002fca:	c09c                	sw	a5,0(s1)
  return b;
    80002fcc:	b7c5                	j	80002fac <bread+0xd0>

0000000080002fce <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fce:	1101                	addi	sp,sp,-32
    80002fd0:	ec06                	sd	ra,24(sp)
    80002fd2:	e822                	sd	s0,16(sp)
    80002fd4:	e426                	sd	s1,8(sp)
    80002fd6:	1000                	addi	s0,sp,32
    80002fd8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fda:	0541                	addi	a0,a0,16
    80002fdc:	00001097          	auipc	ra,0x1
    80002fe0:	456080e7          	jalr	1110(ra) # 80004432 <holdingsleep>
    80002fe4:	cd01                	beqz	a0,80002ffc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002fe6:	4585                	li	a1,1
    80002fe8:	8526                	mv	a0,s1
    80002fea:	00003097          	auipc	ra,0x3
    80002fee:	f02080e7          	jalr	-254(ra) # 80005eec <virtio_disk_rw>
}
    80002ff2:	60e2                	ld	ra,24(sp)
    80002ff4:	6442                	ld	s0,16(sp)
    80002ff6:	64a2                	ld	s1,8(sp)
    80002ff8:	6105                	addi	sp,sp,32
    80002ffa:	8082                	ret
    panic("bwrite");
    80002ffc:	00005517          	auipc	a0,0x5
    80003000:	56450513          	addi	a0,a0,1380 # 80008560 <syscalls+0xe0>
    80003004:	ffffd097          	auipc	ra,0xffffd
    80003008:	550080e7          	jalr	1360(ra) # 80000554 <panic>

000000008000300c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000300c:	1101                	addi	sp,sp,-32
    8000300e:	ec06                	sd	ra,24(sp)
    80003010:	e822                	sd	s0,16(sp)
    80003012:	e426                	sd	s1,8(sp)
    80003014:	e04a                	sd	s2,0(sp)
    80003016:	1000                	addi	s0,sp,32
    80003018:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000301a:	01050913          	addi	s2,a0,16
    8000301e:	854a                	mv	a0,s2
    80003020:	00001097          	auipc	ra,0x1
    80003024:	412080e7          	jalr	1042(ra) # 80004432 <holdingsleep>
    80003028:	c92d                	beqz	a0,8000309a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000302a:	854a                	mv	a0,s2
    8000302c:	00001097          	auipc	ra,0x1
    80003030:	3c2080e7          	jalr	962(ra) # 800043ee <releasesleep>

  acquire(&bcache.lock);
    80003034:	00015517          	auipc	a0,0x15
    80003038:	94c50513          	addi	a0,a0,-1716 # 80017980 <bcache>
    8000303c:	ffffe097          	auipc	ra,0xffffe
    80003040:	bc8080e7          	jalr	-1080(ra) # 80000c04 <acquire>
  b->refcnt--;
    80003044:	40bc                	lw	a5,64(s1)
    80003046:	37fd                	addiw	a5,a5,-1
    80003048:	0007871b          	sext.w	a4,a5
    8000304c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000304e:	eb05                	bnez	a4,8000307e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003050:	68bc                	ld	a5,80(s1)
    80003052:	64b8                	ld	a4,72(s1)
    80003054:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003056:	64bc                	ld	a5,72(s1)
    80003058:	68b8                	ld	a4,80(s1)
    8000305a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000305c:	0001d797          	auipc	a5,0x1d
    80003060:	92478793          	addi	a5,a5,-1756 # 8001f980 <bcache+0x8000>
    80003064:	2b87b703          	ld	a4,696(a5)
    80003068:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000306a:	0001d717          	auipc	a4,0x1d
    8000306e:	b7e70713          	addi	a4,a4,-1154 # 8001fbe8 <bcache+0x8268>
    80003072:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003074:	2b87b703          	ld	a4,696(a5)
    80003078:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000307a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000307e:	00015517          	auipc	a0,0x15
    80003082:	90250513          	addi	a0,a0,-1790 # 80017980 <bcache>
    80003086:	ffffe097          	auipc	ra,0xffffe
    8000308a:	c32080e7          	jalr	-974(ra) # 80000cb8 <release>
}
    8000308e:	60e2                	ld	ra,24(sp)
    80003090:	6442                	ld	s0,16(sp)
    80003092:	64a2                	ld	s1,8(sp)
    80003094:	6902                	ld	s2,0(sp)
    80003096:	6105                	addi	sp,sp,32
    80003098:	8082                	ret
    panic("brelse");
    8000309a:	00005517          	auipc	a0,0x5
    8000309e:	4ce50513          	addi	a0,a0,1230 # 80008568 <syscalls+0xe8>
    800030a2:	ffffd097          	auipc	ra,0xffffd
    800030a6:	4b2080e7          	jalr	1202(ra) # 80000554 <panic>

00000000800030aa <bpin>:

void
bpin(struct buf *b) {
    800030aa:	1101                	addi	sp,sp,-32
    800030ac:	ec06                	sd	ra,24(sp)
    800030ae:	e822                	sd	s0,16(sp)
    800030b0:	e426                	sd	s1,8(sp)
    800030b2:	1000                	addi	s0,sp,32
    800030b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030b6:	00015517          	auipc	a0,0x15
    800030ba:	8ca50513          	addi	a0,a0,-1846 # 80017980 <bcache>
    800030be:	ffffe097          	auipc	ra,0xffffe
    800030c2:	b46080e7          	jalr	-1210(ra) # 80000c04 <acquire>
  b->refcnt++;
    800030c6:	40bc                	lw	a5,64(s1)
    800030c8:	2785                	addiw	a5,a5,1
    800030ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030cc:	00015517          	auipc	a0,0x15
    800030d0:	8b450513          	addi	a0,a0,-1868 # 80017980 <bcache>
    800030d4:	ffffe097          	auipc	ra,0xffffe
    800030d8:	be4080e7          	jalr	-1052(ra) # 80000cb8 <release>
}
    800030dc:	60e2                	ld	ra,24(sp)
    800030de:	6442                	ld	s0,16(sp)
    800030e0:	64a2                	ld	s1,8(sp)
    800030e2:	6105                	addi	sp,sp,32
    800030e4:	8082                	ret

00000000800030e6 <bunpin>:

void
bunpin(struct buf *b) {
    800030e6:	1101                	addi	sp,sp,-32
    800030e8:	ec06                	sd	ra,24(sp)
    800030ea:	e822                	sd	s0,16(sp)
    800030ec:	e426                	sd	s1,8(sp)
    800030ee:	1000                	addi	s0,sp,32
    800030f0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030f2:	00015517          	auipc	a0,0x15
    800030f6:	88e50513          	addi	a0,a0,-1906 # 80017980 <bcache>
    800030fa:	ffffe097          	auipc	ra,0xffffe
    800030fe:	b0a080e7          	jalr	-1270(ra) # 80000c04 <acquire>
  b->refcnt--;
    80003102:	40bc                	lw	a5,64(s1)
    80003104:	37fd                	addiw	a5,a5,-1
    80003106:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003108:	00015517          	auipc	a0,0x15
    8000310c:	87850513          	addi	a0,a0,-1928 # 80017980 <bcache>
    80003110:	ffffe097          	auipc	ra,0xffffe
    80003114:	ba8080e7          	jalr	-1112(ra) # 80000cb8 <release>
}
    80003118:	60e2                	ld	ra,24(sp)
    8000311a:	6442                	ld	s0,16(sp)
    8000311c:	64a2                	ld	s1,8(sp)
    8000311e:	6105                	addi	sp,sp,32
    80003120:	8082                	ret

0000000080003122 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003122:	1101                	addi	sp,sp,-32
    80003124:	ec06                	sd	ra,24(sp)
    80003126:	e822                	sd	s0,16(sp)
    80003128:	e426                	sd	s1,8(sp)
    8000312a:	e04a                	sd	s2,0(sp)
    8000312c:	1000                	addi	s0,sp,32
    8000312e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003130:	00d5d59b          	srliw	a1,a1,0xd
    80003134:	0001d797          	auipc	a5,0x1d
    80003138:	f287a783          	lw	a5,-216(a5) # 8002005c <sb+0x1c>
    8000313c:	9dbd                	addw	a1,a1,a5
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	d9e080e7          	jalr	-610(ra) # 80002edc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003146:	0074f713          	andi	a4,s1,7
    8000314a:	4785                	li	a5,1
    8000314c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003150:	14ce                	slli	s1,s1,0x33
    80003152:	90d9                	srli	s1,s1,0x36
    80003154:	00950733          	add	a4,a0,s1
    80003158:	05874703          	lbu	a4,88(a4)
    8000315c:	00e7f6b3          	and	a3,a5,a4
    80003160:	c69d                	beqz	a3,8000318e <bfree+0x6c>
    80003162:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003164:	94aa                	add	s1,s1,a0
    80003166:	fff7c793          	not	a5,a5
    8000316a:	8ff9                	and	a5,a5,a4
    8000316c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003170:	00001097          	auipc	ra,0x1
    80003174:	100080e7          	jalr	256(ra) # 80004270 <log_write>
  brelse(bp);
    80003178:	854a                	mv	a0,s2
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	e92080e7          	jalr	-366(ra) # 8000300c <brelse>
}
    80003182:	60e2                	ld	ra,24(sp)
    80003184:	6442                	ld	s0,16(sp)
    80003186:	64a2                	ld	s1,8(sp)
    80003188:	6902                	ld	s2,0(sp)
    8000318a:	6105                	addi	sp,sp,32
    8000318c:	8082                	ret
    panic("freeing free block");
    8000318e:	00005517          	auipc	a0,0x5
    80003192:	3e250513          	addi	a0,a0,994 # 80008570 <syscalls+0xf0>
    80003196:	ffffd097          	auipc	ra,0xffffd
    8000319a:	3be080e7          	jalr	958(ra) # 80000554 <panic>

000000008000319e <balloc>:
{
    8000319e:	711d                	addi	sp,sp,-96
    800031a0:	ec86                	sd	ra,88(sp)
    800031a2:	e8a2                	sd	s0,80(sp)
    800031a4:	e4a6                	sd	s1,72(sp)
    800031a6:	e0ca                	sd	s2,64(sp)
    800031a8:	fc4e                	sd	s3,56(sp)
    800031aa:	f852                	sd	s4,48(sp)
    800031ac:	f456                	sd	s5,40(sp)
    800031ae:	f05a                	sd	s6,32(sp)
    800031b0:	ec5e                	sd	s7,24(sp)
    800031b2:	e862                	sd	s8,16(sp)
    800031b4:	e466                	sd	s9,8(sp)
    800031b6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800031b8:	0001d797          	auipc	a5,0x1d
    800031bc:	e8c7a783          	lw	a5,-372(a5) # 80020044 <sb+0x4>
    800031c0:	cbd1                	beqz	a5,80003254 <balloc+0xb6>
    800031c2:	8baa                	mv	s7,a0
    800031c4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031c6:	0001db17          	auipc	s6,0x1d
    800031ca:	e7ab0b13          	addi	s6,s6,-390 # 80020040 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031ce:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800031d0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031d2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031d4:	6c89                	lui	s9,0x2
    800031d6:	a831                	j	800031f2 <balloc+0x54>
    brelse(bp);
    800031d8:	854a                	mv	a0,s2
    800031da:	00000097          	auipc	ra,0x0
    800031de:	e32080e7          	jalr	-462(ra) # 8000300c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800031e2:	015c87bb          	addw	a5,s9,s5
    800031e6:	00078a9b          	sext.w	s5,a5
    800031ea:	004b2703          	lw	a4,4(s6)
    800031ee:	06eaf363          	bgeu	s5,a4,80003254 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800031f2:	41fad79b          	sraiw	a5,s5,0x1f
    800031f6:	0137d79b          	srliw	a5,a5,0x13
    800031fa:	015787bb          	addw	a5,a5,s5
    800031fe:	40d7d79b          	sraiw	a5,a5,0xd
    80003202:	01cb2583          	lw	a1,28(s6)
    80003206:	9dbd                	addw	a1,a1,a5
    80003208:	855e                	mv	a0,s7
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	cd2080e7          	jalr	-814(ra) # 80002edc <bread>
    80003212:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003214:	004b2503          	lw	a0,4(s6)
    80003218:	000a849b          	sext.w	s1,s5
    8000321c:	8662                	mv	a2,s8
    8000321e:	faa4fde3          	bgeu	s1,a0,800031d8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80003222:	41f6579b          	sraiw	a5,a2,0x1f
    80003226:	01d7d69b          	srliw	a3,a5,0x1d
    8000322a:	00c6873b          	addw	a4,a3,a2
    8000322e:	00777793          	andi	a5,a4,7
    80003232:	9f95                	subw	a5,a5,a3
    80003234:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003238:	4037571b          	sraiw	a4,a4,0x3
    8000323c:	00e906b3          	add	a3,s2,a4
    80003240:	0586c683          	lbu	a3,88(a3)
    80003244:	00d7f5b3          	and	a1,a5,a3
    80003248:	cd91                	beqz	a1,80003264 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000324a:	2605                	addiw	a2,a2,1
    8000324c:	2485                	addiw	s1,s1,1
    8000324e:	fd4618e3          	bne	a2,s4,8000321e <balloc+0x80>
    80003252:	b759                	j	800031d8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003254:	00005517          	auipc	a0,0x5
    80003258:	33450513          	addi	a0,a0,820 # 80008588 <syscalls+0x108>
    8000325c:	ffffd097          	auipc	ra,0xffffd
    80003260:	2f8080e7          	jalr	760(ra) # 80000554 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003264:	974a                	add	a4,a4,s2
    80003266:	8fd5                	or	a5,a5,a3
    80003268:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000326c:	854a                	mv	a0,s2
    8000326e:	00001097          	auipc	ra,0x1
    80003272:	002080e7          	jalr	2(ra) # 80004270 <log_write>
        brelse(bp);
    80003276:	854a                	mv	a0,s2
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	d94080e7          	jalr	-620(ra) # 8000300c <brelse>
  bp = bread(dev, bno);
    80003280:	85a6                	mv	a1,s1
    80003282:	855e                	mv	a0,s7
    80003284:	00000097          	auipc	ra,0x0
    80003288:	c58080e7          	jalr	-936(ra) # 80002edc <bread>
    8000328c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000328e:	40000613          	li	a2,1024
    80003292:	4581                	li	a1,0
    80003294:	05850513          	addi	a0,a0,88
    80003298:	ffffe097          	auipc	ra,0xffffe
    8000329c:	a68080e7          	jalr	-1432(ra) # 80000d00 <memset>
  log_write(bp);
    800032a0:	854a                	mv	a0,s2
    800032a2:	00001097          	auipc	ra,0x1
    800032a6:	fce080e7          	jalr	-50(ra) # 80004270 <log_write>
  brelse(bp);
    800032aa:	854a                	mv	a0,s2
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	d60080e7          	jalr	-672(ra) # 8000300c <brelse>
}
    800032b4:	8526                	mv	a0,s1
    800032b6:	60e6                	ld	ra,88(sp)
    800032b8:	6446                	ld	s0,80(sp)
    800032ba:	64a6                	ld	s1,72(sp)
    800032bc:	6906                	ld	s2,64(sp)
    800032be:	79e2                	ld	s3,56(sp)
    800032c0:	7a42                	ld	s4,48(sp)
    800032c2:	7aa2                	ld	s5,40(sp)
    800032c4:	7b02                	ld	s6,32(sp)
    800032c6:	6be2                	ld	s7,24(sp)
    800032c8:	6c42                	ld	s8,16(sp)
    800032ca:	6ca2                	ld	s9,8(sp)
    800032cc:	6125                	addi	sp,sp,96
    800032ce:	8082                	ret

00000000800032d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800032d0:	7179                	addi	sp,sp,-48
    800032d2:	f406                	sd	ra,40(sp)
    800032d4:	f022                	sd	s0,32(sp)
    800032d6:	ec26                	sd	s1,24(sp)
    800032d8:	e84a                	sd	s2,16(sp)
    800032da:	e44e                	sd	s3,8(sp)
    800032dc:	e052                	sd	s4,0(sp)
    800032de:	1800                	addi	s0,sp,48
    800032e0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800032e2:	47ad                	li	a5,11
    800032e4:	04b7fe63          	bgeu	a5,a1,80003340 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800032e8:	ff45849b          	addiw	s1,a1,-12
    800032ec:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800032f0:	0ff00793          	li	a5,255
    800032f4:	0ae7e363          	bltu	a5,a4,8000339a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800032f8:	08052583          	lw	a1,128(a0)
    800032fc:	c5ad                	beqz	a1,80003366 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800032fe:	00092503          	lw	a0,0(s2)
    80003302:	00000097          	auipc	ra,0x0
    80003306:	bda080e7          	jalr	-1062(ra) # 80002edc <bread>
    8000330a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000330c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003310:	02049593          	slli	a1,s1,0x20
    80003314:	9181                	srli	a1,a1,0x20
    80003316:	058a                	slli	a1,a1,0x2
    80003318:	00b784b3          	add	s1,a5,a1
    8000331c:	0004a983          	lw	s3,0(s1)
    80003320:	04098d63          	beqz	s3,8000337a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003324:	8552                	mv	a0,s4
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	ce6080e7          	jalr	-794(ra) # 8000300c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000332e:	854e                	mv	a0,s3
    80003330:	70a2                	ld	ra,40(sp)
    80003332:	7402                	ld	s0,32(sp)
    80003334:	64e2                	ld	s1,24(sp)
    80003336:	6942                	ld	s2,16(sp)
    80003338:	69a2                	ld	s3,8(sp)
    8000333a:	6a02                	ld	s4,0(sp)
    8000333c:	6145                	addi	sp,sp,48
    8000333e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003340:	02059493          	slli	s1,a1,0x20
    80003344:	9081                	srli	s1,s1,0x20
    80003346:	048a                	slli	s1,s1,0x2
    80003348:	94aa                	add	s1,s1,a0
    8000334a:	0504a983          	lw	s3,80(s1)
    8000334e:	fe0990e3          	bnez	s3,8000332e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003352:	4108                	lw	a0,0(a0)
    80003354:	00000097          	auipc	ra,0x0
    80003358:	e4a080e7          	jalr	-438(ra) # 8000319e <balloc>
    8000335c:	0005099b          	sext.w	s3,a0
    80003360:	0534a823          	sw	s3,80(s1)
    80003364:	b7e9                	j	8000332e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003366:	4108                	lw	a0,0(a0)
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	e36080e7          	jalr	-458(ra) # 8000319e <balloc>
    80003370:	0005059b          	sext.w	a1,a0
    80003374:	08b92023          	sw	a1,128(s2)
    80003378:	b759                	j	800032fe <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000337a:	00092503          	lw	a0,0(s2)
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	e20080e7          	jalr	-480(ra) # 8000319e <balloc>
    80003386:	0005099b          	sext.w	s3,a0
    8000338a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000338e:	8552                	mv	a0,s4
    80003390:	00001097          	auipc	ra,0x1
    80003394:	ee0080e7          	jalr	-288(ra) # 80004270 <log_write>
    80003398:	b771                	j	80003324 <bmap+0x54>
  panic("bmap: out of range");
    8000339a:	00005517          	auipc	a0,0x5
    8000339e:	20650513          	addi	a0,a0,518 # 800085a0 <syscalls+0x120>
    800033a2:	ffffd097          	auipc	ra,0xffffd
    800033a6:	1b2080e7          	jalr	434(ra) # 80000554 <panic>

00000000800033aa <iget>:
{
    800033aa:	7179                	addi	sp,sp,-48
    800033ac:	f406                	sd	ra,40(sp)
    800033ae:	f022                	sd	s0,32(sp)
    800033b0:	ec26                	sd	s1,24(sp)
    800033b2:	e84a                	sd	s2,16(sp)
    800033b4:	e44e                	sd	s3,8(sp)
    800033b6:	e052                	sd	s4,0(sp)
    800033b8:	1800                	addi	s0,sp,48
    800033ba:	89aa                	mv	s3,a0
    800033bc:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800033be:	0001d517          	auipc	a0,0x1d
    800033c2:	ca250513          	addi	a0,a0,-862 # 80020060 <icache>
    800033c6:	ffffe097          	auipc	ra,0xffffe
    800033ca:	83e080e7          	jalr	-1986(ra) # 80000c04 <acquire>
  empty = 0;
    800033ce:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033d0:	0001d497          	auipc	s1,0x1d
    800033d4:	ca848493          	addi	s1,s1,-856 # 80020078 <icache+0x18>
    800033d8:	0001e697          	auipc	a3,0x1e
    800033dc:	73068693          	addi	a3,a3,1840 # 80021b08 <log>
    800033e0:	a039                	j	800033ee <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033e2:	02090b63          	beqz	s2,80003418 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033e6:	08848493          	addi	s1,s1,136
    800033ea:	02d48a63          	beq	s1,a3,8000341e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800033ee:	449c                	lw	a5,8(s1)
    800033f0:	fef059e3          	blez	a5,800033e2 <iget+0x38>
    800033f4:	4098                	lw	a4,0(s1)
    800033f6:	ff3716e3          	bne	a4,s3,800033e2 <iget+0x38>
    800033fa:	40d8                	lw	a4,4(s1)
    800033fc:	ff4713e3          	bne	a4,s4,800033e2 <iget+0x38>
      ip->ref++;
    80003400:	2785                	addiw	a5,a5,1
    80003402:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003404:	0001d517          	auipc	a0,0x1d
    80003408:	c5c50513          	addi	a0,a0,-932 # 80020060 <icache>
    8000340c:	ffffe097          	auipc	ra,0xffffe
    80003410:	8ac080e7          	jalr	-1876(ra) # 80000cb8 <release>
      return ip;
    80003414:	8926                	mv	s2,s1
    80003416:	a03d                	j	80003444 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003418:	f7f9                	bnez	a5,800033e6 <iget+0x3c>
    8000341a:	8926                	mv	s2,s1
    8000341c:	b7e9                	j	800033e6 <iget+0x3c>
  if(empty == 0)
    8000341e:	02090c63          	beqz	s2,80003456 <iget+0xac>
  ip->dev = dev;
    80003422:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003426:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000342a:	4785                	li	a5,1
    8000342c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003430:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003434:	0001d517          	auipc	a0,0x1d
    80003438:	c2c50513          	addi	a0,a0,-980 # 80020060 <icache>
    8000343c:	ffffe097          	auipc	ra,0xffffe
    80003440:	87c080e7          	jalr	-1924(ra) # 80000cb8 <release>
}
    80003444:	854a                	mv	a0,s2
    80003446:	70a2                	ld	ra,40(sp)
    80003448:	7402                	ld	s0,32(sp)
    8000344a:	64e2                	ld	s1,24(sp)
    8000344c:	6942                	ld	s2,16(sp)
    8000344e:	69a2                	ld	s3,8(sp)
    80003450:	6a02                	ld	s4,0(sp)
    80003452:	6145                	addi	sp,sp,48
    80003454:	8082                	ret
    panic("iget: no inodes");
    80003456:	00005517          	auipc	a0,0x5
    8000345a:	16250513          	addi	a0,a0,354 # 800085b8 <syscalls+0x138>
    8000345e:	ffffd097          	auipc	ra,0xffffd
    80003462:	0f6080e7          	jalr	246(ra) # 80000554 <panic>

0000000080003466 <fsinit>:
fsinit(int dev) {
    80003466:	7179                	addi	sp,sp,-48
    80003468:	f406                	sd	ra,40(sp)
    8000346a:	f022                	sd	s0,32(sp)
    8000346c:	ec26                	sd	s1,24(sp)
    8000346e:	e84a                	sd	s2,16(sp)
    80003470:	e44e                	sd	s3,8(sp)
    80003472:	1800                	addi	s0,sp,48
    80003474:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003476:	4585                	li	a1,1
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	a64080e7          	jalr	-1436(ra) # 80002edc <bread>
    80003480:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003482:	0001d997          	auipc	s3,0x1d
    80003486:	bbe98993          	addi	s3,s3,-1090 # 80020040 <sb>
    8000348a:	02000613          	li	a2,32
    8000348e:	05850593          	addi	a1,a0,88
    80003492:	854e                	mv	a0,s3
    80003494:	ffffe097          	auipc	ra,0xffffe
    80003498:	8cc080e7          	jalr	-1844(ra) # 80000d60 <memmove>
  brelse(bp);
    8000349c:	8526                	mv	a0,s1
    8000349e:	00000097          	auipc	ra,0x0
    800034a2:	b6e080e7          	jalr	-1170(ra) # 8000300c <brelse>
  if(sb.magic != FSMAGIC)
    800034a6:	0009a703          	lw	a4,0(s3)
    800034aa:	102037b7          	lui	a5,0x10203
    800034ae:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800034b2:	02f71263          	bne	a4,a5,800034d6 <fsinit+0x70>
  initlog(dev, &sb);
    800034b6:	0001d597          	auipc	a1,0x1d
    800034ba:	b8a58593          	addi	a1,a1,-1142 # 80020040 <sb>
    800034be:	854a                	mv	a0,s2
    800034c0:	00001097          	auipc	ra,0x1
    800034c4:	b38080e7          	jalr	-1224(ra) # 80003ff8 <initlog>
}
    800034c8:	70a2                	ld	ra,40(sp)
    800034ca:	7402                	ld	s0,32(sp)
    800034cc:	64e2                	ld	s1,24(sp)
    800034ce:	6942                	ld	s2,16(sp)
    800034d0:	69a2                	ld	s3,8(sp)
    800034d2:	6145                	addi	sp,sp,48
    800034d4:	8082                	ret
    panic("invalid file system");
    800034d6:	00005517          	auipc	a0,0x5
    800034da:	0f250513          	addi	a0,a0,242 # 800085c8 <syscalls+0x148>
    800034de:	ffffd097          	auipc	ra,0xffffd
    800034e2:	076080e7          	jalr	118(ra) # 80000554 <panic>

00000000800034e6 <iinit>:
{
    800034e6:	7179                	addi	sp,sp,-48
    800034e8:	f406                	sd	ra,40(sp)
    800034ea:	f022                	sd	s0,32(sp)
    800034ec:	ec26                	sd	s1,24(sp)
    800034ee:	e84a                	sd	s2,16(sp)
    800034f0:	e44e                	sd	s3,8(sp)
    800034f2:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800034f4:	00005597          	auipc	a1,0x5
    800034f8:	0ec58593          	addi	a1,a1,236 # 800085e0 <syscalls+0x160>
    800034fc:	0001d517          	auipc	a0,0x1d
    80003500:	b6450513          	addi	a0,a0,-1180 # 80020060 <icache>
    80003504:	ffffd097          	auipc	ra,0xffffd
    80003508:	670080e7          	jalr	1648(ra) # 80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000350c:	0001d497          	auipc	s1,0x1d
    80003510:	b7c48493          	addi	s1,s1,-1156 # 80020088 <icache+0x28>
    80003514:	0001e997          	auipc	s3,0x1e
    80003518:	60498993          	addi	s3,s3,1540 # 80021b18 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000351c:	00005917          	auipc	s2,0x5
    80003520:	0cc90913          	addi	s2,s2,204 # 800085e8 <syscalls+0x168>
    80003524:	85ca                	mv	a1,s2
    80003526:	8526                	mv	a0,s1
    80003528:	00001097          	auipc	ra,0x1
    8000352c:	e36080e7          	jalr	-458(ra) # 8000435e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003530:	08848493          	addi	s1,s1,136
    80003534:	ff3498e3          	bne	s1,s3,80003524 <iinit+0x3e>
}
    80003538:	70a2                	ld	ra,40(sp)
    8000353a:	7402                	ld	s0,32(sp)
    8000353c:	64e2                	ld	s1,24(sp)
    8000353e:	6942                	ld	s2,16(sp)
    80003540:	69a2                	ld	s3,8(sp)
    80003542:	6145                	addi	sp,sp,48
    80003544:	8082                	ret

0000000080003546 <ialloc>:
{
    80003546:	715d                	addi	sp,sp,-80
    80003548:	e486                	sd	ra,72(sp)
    8000354a:	e0a2                	sd	s0,64(sp)
    8000354c:	fc26                	sd	s1,56(sp)
    8000354e:	f84a                	sd	s2,48(sp)
    80003550:	f44e                	sd	s3,40(sp)
    80003552:	f052                	sd	s4,32(sp)
    80003554:	ec56                	sd	s5,24(sp)
    80003556:	e85a                	sd	s6,16(sp)
    80003558:	e45e                	sd	s7,8(sp)
    8000355a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000355c:	0001d717          	auipc	a4,0x1d
    80003560:	af072703          	lw	a4,-1296(a4) # 8002004c <sb+0xc>
    80003564:	4785                	li	a5,1
    80003566:	04e7fa63          	bgeu	a5,a4,800035ba <ialloc+0x74>
    8000356a:	8aaa                	mv	s5,a0
    8000356c:	8bae                	mv	s7,a1
    8000356e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003570:	0001da17          	auipc	s4,0x1d
    80003574:	ad0a0a13          	addi	s4,s4,-1328 # 80020040 <sb>
    80003578:	00048b1b          	sext.w	s6,s1
    8000357c:	0044d593          	srli	a1,s1,0x4
    80003580:	018a2783          	lw	a5,24(s4)
    80003584:	9dbd                	addw	a1,a1,a5
    80003586:	8556                	mv	a0,s5
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	954080e7          	jalr	-1708(ra) # 80002edc <bread>
    80003590:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003592:	05850993          	addi	s3,a0,88
    80003596:	00f4f793          	andi	a5,s1,15
    8000359a:	079a                	slli	a5,a5,0x6
    8000359c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000359e:	00099783          	lh	a5,0(s3)
    800035a2:	c785                	beqz	a5,800035ca <ialloc+0x84>
    brelse(bp);
    800035a4:	00000097          	auipc	ra,0x0
    800035a8:	a68080e7          	jalr	-1432(ra) # 8000300c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035ac:	0485                	addi	s1,s1,1
    800035ae:	00ca2703          	lw	a4,12(s4)
    800035b2:	0004879b          	sext.w	a5,s1
    800035b6:	fce7e1e3          	bltu	a5,a4,80003578 <ialloc+0x32>
  panic("ialloc: no inodes");
    800035ba:	00005517          	auipc	a0,0x5
    800035be:	03650513          	addi	a0,a0,54 # 800085f0 <syscalls+0x170>
    800035c2:	ffffd097          	auipc	ra,0xffffd
    800035c6:	f92080e7          	jalr	-110(ra) # 80000554 <panic>
      memset(dip, 0, sizeof(*dip));
    800035ca:	04000613          	li	a2,64
    800035ce:	4581                	li	a1,0
    800035d0:	854e                	mv	a0,s3
    800035d2:	ffffd097          	auipc	ra,0xffffd
    800035d6:	72e080e7          	jalr	1838(ra) # 80000d00 <memset>
      dip->type = type;
    800035da:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800035de:	854a                	mv	a0,s2
    800035e0:	00001097          	auipc	ra,0x1
    800035e4:	c90080e7          	jalr	-880(ra) # 80004270 <log_write>
      brelse(bp);
    800035e8:	854a                	mv	a0,s2
    800035ea:	00000097          	auipc	ra,0x0
    800035ee:	a22080e7          	jalr	-1502(ra) # 8000300c <brelse>
      return iget(dev, inum);
    800035f2:	85da                	mv	a1,s6
    800035f4:	8556                	mv	a0,s5
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	db4080e7          	jalr	-588(ra) # 800033aa <iget>
}
    800035fe:	60a6                	ld	ra,72(sp)
    80003600:	6406                	ld	s0,64(sp)
    80003602:	74e2                	ld	s1,56(sp)
    80003604:	7942                	ld	s2,48(sp)
    80003606:	79a2                	ld	s3,40(sp)
    80003608:	7a02                	ld	s4,32(sp)
    8000360a:	6ae2                	ld	s5,24(sp)
    8000360c:	6b42                	ld	s6,16(sp)
    8000360e:	6ba2                	ld	s7,8(sp)
    80003610:	6161                	addi	sp,sp,80
    80003612:	8082                	ret

0000000080003614 <iupdate>:
{
    80003614:	1101                	addi	sp,sp,-32
    80003616:	ec06                	sd	ra,24(sp)
    80003618:	e822                	sd	s0,16(sp)
    8000361a:	e426                	sd	s1,8(sp)
    8000361c:	e04a                	sd	s2,0(sp)
    8000361e:	1000                	addi	s0,sp,32
    80003620:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003622:	415c                	lw	a5,4(a0)
    80003624:	0047d79b          	srliw	a5,a5,0x4
    80003628:	0001d597          	auipc	a1,0x1d
    8000362c:	a305a583          	lw	a1,-1488(a1) # 80020058 <sb+0x18>
    80003630:	9dbd                	addw	a1,a1,a5
    80003632:	4108                	lw	a0,0(a0)
    80003634:	00000097          	auipc	ra,0x0
    80003638:	8a8080e7          	jalr	-1880(ra) # 80002edc <bread>
    8000363c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000363e:	05850793          	addi	a5,a0,88
    80003642:	40c8                	lw	a0,4(s1)
    80003644:	893d                	andi	a0,a0,15
    80003646:	051a                	slli	a0,a0,0x6
    80003648:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000364a:	04449703          	lh	a4,68(s1)
    8000364e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003652:	04649703          	lh	a4,70(s1)
    80003656:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000365a:	04849703          	lh	a4,72(s1)
    8000365e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003662:	04a49703          	lh	a4,74(s1)
    80003666:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000366a:	44f8                	lw	a4,76(s1)
    8000366c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000366e:	03400613          	li	a2,52
    80003672:	05048593          	addi	a1,s1,80
    80003676:	0531                	addi	a0,a0,12
    80003678:	ffffd097          	auipc	ra,0xffffd
    8000367c:	6e8080e7          	jalr	1768(ra) # 80000d60 <memmove>
  log_write(bp);
    80003680:	854a                	mv	a0,s2
    80003682:	00001097          	auipc	ra,0x1
    80003686:	bee080e7          	jalr	-1042(ra) # 80004270 <log_write>
  brelse(bp);
    8000368a:	854a                	mv	a0,s2
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	980080e7          	jalr	-1664(ra) # 8000300c <brelse>
}
    80003694:	60e2                	ld	ra,24(sp)
    80003696:	6442                	ld	s0,16(sp)
    80003698:	64a2                	ld	s1,8(sp)
    8000369a:	6902                	ld	s2,0(sp)
    8000369c:	6105                	addi	sp,sp,32
    8000369e:	8082                	ret

00000000800036a0 <idup>:
{
    800036a0:	1101                	addi	sp,sp,-32
    800036a2:	ec06                	sd	ra,24(sp)
    800036a4:	e822                	sd	s0,16(sp)
    800036a6:	e426                	sd	s1,8(sp)
    800036a8:	1000                	addi	s0,sp,32
    800036aa:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800036ac:	0001d517          	auipc	a0,0x1d
    800036b0:	9b450513          	addi	a0,a0,-1612 # 80020060 <icache>
    800036b4:	ffffd097          	auipc	ra,0xffffd
    800036b8:	550080e7          	jalr	1360(ra) # 80000c04 <acquire>
  ip->ref++;
    800036bc:	449c                	lw	a5,8(s1)
    800036be:	2785                	addiw	a5,a5,1
    800036c0:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800036c2:	0001d517          	auipc	a0,0x1d
    800036c6:	99e50513          	addi	a0,a0,-1634 # 80020060 <icache>
    800036ca:	ffffd097          	auipc	ra,0xffffd
    800036ce:	5ee080e7          	jalr	1518(ra) # 80000cb8 <release>
}
    800036d2:	8526                	mv	a0,s1
    800036d4:	60e2                	ld	ra,24(sp)
    800036d6:	6442                	ld	s0,16(sp)
    800036d8:	64a2                	ld	s1,8(sp)
    800036da:	6105                	addi	sp,sp,32
    800036dc:	8082                	ret

00000000800036de <ilock>:
{
    800036de:	1101                	addi	sp,sp,-32
    800036e0:	ec06                	sd	ra,24(sp)
    800036e2:	e822                	sd	s0,16(sp)
    800036e4:	e426                	sd	s1,8(sp)
    800036e6:	e04a                	sd	s2,0(sp)
    800036e8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036ea:	c115                	beqz	a0,8000370e <ilock+0x30>
    800036ec:	84aa                	mv	s1,a0
    800036ee:	451c                	lw	a5,8(a0)
    800036f0:	00f05f63          	blez	a5,8000370e <ilock+0x30>
  acquiresleep(&ip->lock);
    800036f4:	0541                	addi	a0,a0,16
    800036f6:	00001097          	auipc	ra,0x1
    800036fa:	ca2080e7          	jalr	-862(ra) # 80004398 <acquiresleep>
  if(ip->valid == 0){
    800036fe:	40bc                	lw	a5,64(s1)
    80003700:	cf99                	beqz	a5,8000371e <ilock+0x40>
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	64a2                	ld	s1,8(sp)
    80003708:	6902                	ld	s2,0(sp)
    8000370a:	6105                	addi	sp,sp,32
    8000370c:	8082                	ret
    panic("ilock");
    8000370e:	00005517          	auipc	a0,0x5
    80003712:	efa50513          	addi	a0,a0,-262 # 80008608 <syscalls+0x188>
    80003716:	ffffd097          	auipc	ra,0xffffd
    8000371a:	e3e080e7          	jalr	-450(ra) # 80000554 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000371e:	40dc                	lw	a5,4(s1)
    80003720:	0047d79b          	srliw	a5,a5,0x4
    80003724:	0001d597          	auipc	a1,0x1d
    80003728:	9345a583          	lw	a1,-1740(a1) # 80020058 <sb+0x18>
    8000372c:	9dbd                	addw	a1,a1,a5
    8000372e:	4088                	lw	a0,0(s1)
    80003730:	fffff097          	auipc	ra,0xfffff
    80003734:	7ac080e7          	jalr	1964(ra) # 80002edc <bread>
    80003738:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000373a:	05850593          	addi	a1,a0,88
    8000373e:	40dc                	lw	a5,4(s1)
    80003740:	8bbd                	andi	a5,a5,15
    80003742:	079a                	slli	a5,a5,0x6
    80003744:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003746:	00059783          	lh	a5,0(a1)
    8000374a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000374e:	00259783          	lh	a5,2(a1)
    80003752:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003756:	00459783          	lh	a5,4(a1)
    8000375a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000375e:	00659783          	lh	a5,6(a1)
    80003762:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003766:	459c                	lw	a5,8(a1)
    80003768:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000376a:	03400613          	li	a2,52
    8000376e:	05b1                	addi	a1,a1,12
    80003770:	05048513          	addi	a0,s1,80
    80003774:	ffffd097          	auipc	ra,0xffffd
    80003778:	5ec080e7          	jalr	1516(ra) # 80000d60 <memmove>
    brelse(bp);
    8000377c:	854a                	mv	a0,s2
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	88e080e7          	jalr	-1906(ra) # 8000300c <brelse>
    ip->valid = 1;
    80003786:	4785                	li	a5,1
    80003788:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000378a:	04449783          	lh	a5,68(s1)
    8000378e:	fbb5                	bnez	a5,80003702 <ilock+0x24>
      panic("ilock: no type");
    80003790:	00005517          	auipc	a0,0x5
    80003794:	e8050513          	addi	a0,a0,-384 # 80008610 <syscalls+0x190>
    80003798:	ffffd097          	auipc	ra,0xffffd
    8000379c:	dbc080e7          	jalr	-580(ra) # 80000554 <panic>

00000000800037a0 <iunlock>:
{
    800037a0:	1101                	addi	sp,sp,-32
    800037a2:	ec06                	sd	ra,24(sp)
    800037a4:	e822                	sd	s0,16(sp)
    800037a6:	e426                	sd	s1,8(sp)
    800037a8:	e04a                	sd	s2,0(sp)
    800037aa:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037ac:	c905                	beqz	a0,800037dc <iunlock+0x3c>
    800037ae:	84aa                	mv	s1,a0
    800037b0:	01050913          	addi	s2,a0,16
    800037b4:	854a                	mv	a0,s2
    800037b6:	00001097          	auipc	ra,0x1
    800037ba:	c7c080e7          	jalr	-900(ra) # 80004432 <holdingsleep>
    800037be:	cd19                	beqz	a0,800037dc <iunlock+0x3c>
    800037c0:	449c                	lw	a5,8(s1)
    800037c2:	00f05d63          	blez	a5,800037dc <iunlock+0x3c>
  releasesleep(&ip->lock);
    800037c6:	854a                	mv	a0,s2
    800037c8:	00001097          	auipc	ra,0x1
    800037cc:	c26080e7          	jalr	-986(ra) # 800043ee <releasesleep>
}
    800037d0:	60e2                	ld	ra,24(sp)
    800037d2:	6442                	ld	s0,16(sp)
    800037d4:	64a2                	ld	s1,8(sp)
    800037d6:	6902                	ld	s2,0(sp)
    800037d8:	6105                	addi	sp,sp,32
    800037da:	8082                	ret
    panic("iunlock");
    800037dc:	00005517          	auipc	a0,0x5
    800037e0:	e4450513          	addi	a0,a0,-444 # 80008620 <syscalls+0x1a0>
    800037e4:	ffffd097          	auipc	ra,0xffffd
    800037e8:	d70080e7          	jalr	-656(ra) # 80000554 <panic>

00000000800037ec <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800037ec:	7179                	addi	sp,sp,-48
    800037ee:	f406                	sd	ra,40(sp)
    800037f0:	f022                	sd	s0,32(sp)
    800037f2:	ec26                	sd	s1,24(sp)
    800037f4:	e84a                	sd	s2,16(sp)
    800037f6:	e44e                	sd	s3,8(sp)
    800037f8:	e052                	sd	s4,0(sp)
    800037fa:	1800                	addi	s0,sp,48
    800037fc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800037fe:	05050493          	addi	s1,a0,80
    80003802:	08050913          	addi	s2,a0,128
    80003806:	a021                	j	8000380e <itrunc+0x22>
    80003808:	0491                	addi	s1,s1,4
    8000380a:	01248d63          	beq	s1,s2,80003824 <itrunc+0x38>
    if(ip->addrs[i]){
    8000380e:	408c                	lw	a1,0(s1)
    80003810:	dde5                	beqz	a1,80003808 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003812:	0009a503          	lw	a0,0(s3)
    80003816:	00000097          	auipc	ra,0x0
    8000381a:	90c080e7          	jalr	-1780(ra) # 80003122 <bfree>
      ip->addrs[i] = 0;
    8000381e:	0004a023          	sw	zero,0(s1)
    80003822:	b7dd                	j	80003808 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003824:	0809a583          	lw	a1,128(s3)
    80003828:	e185                	bnez	a1,80003848 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000382a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000382e:	854e                	mv	a0,s3
    80003830:	00000097          	auipc	ra,0x0
    80003834:	de4080e7          	jalr	-540(ra) # 80003614 <iupdate>
}
    80003838:	70a2                	ld	ra,40(sp)
    8000383a:	7402                	ld	s0,32(sp)
    8000383c:	64e2                	ld	s1,24(sp)
    8000383e:	6942                	ld	s2,16(sp)
    80003840:	69a2                	ld	s3,8(sp)
    80003842:	6a02                	ld	s4,0(sp)
    80003844:	6145                	addi	sp,sp,48
    80003846:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003848:	0009a503          	lw	a0,0(s3)
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	690080e7          	jalr	1680(ra) # 80002edc <bread>
    80003854:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003856:	05850493          	addi	s1,a0,88
    8000385a:	45850913          	addi	s2,a0,1112
    8000385e:	a811                	j	80003872 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003860:	0009a503          	lw	a0,0(s3)
    80003864:	00000097          	auipc	ra,0x0
    80003868:	8be080e7          	jalr	-1858(ra) # 80003122 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000386c:	0491                	addi	s1,s1,4
    8000386e:	01248563          	beq	s1,s2,80003878 <itrunc+0x8c>
      if(a[j])
    80003872:	408c                	lw	a1,0(s1)
    80003874:	dde5                	beqz	a1,8000386c <itrunc+0x80>
    80003876:	b7ed                	j	80003860 <itrunc+0x74>
    brelse(bp);
    80003878:	8552                	mv	a0,s4
    8000387a:	fffff097          	auipc	ra,0xfffff
    8000387e:	792080e7          	jalr	1938(ra) # 8000300c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003882:	0809a583          	lw	a1,128(s3)
    80003886:	0009a503          	lw	a0,0(s3)
    8000388a:	00000097          	auipc	ra,0x0
    8000388e:	898080e7          	jalr	-1896(ra) # 80003122 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003892:	0809a023          	sw	zero,128(s3)
    80003896:	bf51                	j	8000382a <itrunc+0x3e>

0000000080003898 <iput>:
{
    80003898:	1101                	addi	sp,sp,-32
    8000389a:	ec06                	sd	ra,24(sp)
    8000389c:	e822                	sd	s0,16(sp)
    8000389e:	e426                	sd	s1,8(sp)
    800038a0:	e04a                	sd	s2,0(sp)
    800038a2:	1000                	addi	s0,sp,32
    800038a4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800038a6:	0001c517          	auipc	a0,0x1c
    800038aa:	7ba50513          	addi	a0,a0,1978 # 80020060 <icache>
    800038ae:	ffffd097          	auipc	ra,0xffffd
    800038b2:	356080e7          	jalr	854(ra) # 80000c04 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038b6:	4498                	lw	a4,8(s1)
    800038b8:	4785                	li	a5,1
    800038ba:	02f70363          	beq	a4,a5,800038e0 <iput+0x48>
  ip->ref--;
    800038be:	449c                	lw	a5,8(s1)
    800038c0:	37fd                	addiw	a5,a5,-1
    800038c2:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800038c4:	0001c517          	auipc	a0,0x1c
    800038c8:	79c50513          	addi	a0,a0,1948 # 80020060 <icache>
    800038cc:	ffffd097          	auipc	ra,0xffffd
    800038d0:	3ec080e7          	jalr	1004(ra) # 80000cb8 <release>
}
    800038d4:	60e2                	ld	ra,24(sp)
    800038d6:	6442                	ld	s0,16(sp)
    800038d8:	64a2                	ld	s1,8(sp)
    800038da:	6902                	ld	s2,0(sp)
    800038dc:	6105                	addi	sp,sp,32
    800038de:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038e0:	40bc                	lw	a5,64(s1)
    800038e2:	dff1                	beqz	a5,800038be <iput+0x26>
    800038e4:	04a49783          	lh	a5,74(s1)
    800038e8:	fbf9                	bnez	a5,800038be <iput+0x26>
    acquiresleep(&ip->lock);
    800038ea:	01048913          	addi	s2,s1,16
    800038ee:	854a                	mv	a0,s2
    800038f0:	00001097          	auipc	ra,0x1
    800038f4:	aa8080e7          	jalr	-1368(ra) # 80004398 <acquiresleep>
    release(&icache.lock);
    800038f8:	0001c517          	auipc	a0,0x1c
    800038fc:	76850513          	addi	a0,a0,1896 # 80020060 <icache>
    80003900:	ffffd097          	auipc	ra,0xffffd
    80003904:	3b8080e7          	jalr	952(ra) # 80000cb8 <release>
    itrunc(ip);
    80003908:	8526                	mv	a0,s1
    8000390a:	00000097          	auipc	ra,0x0
    8000390e:	ee2080e7          	jalr	-286(ra) # 800037ec <itrunc>
    ip->type = 0;
    80003912:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003916:	8526                	mv	a0,s1
    80003918:	00000097          	auipc	ra,0x0
    8000391c:	cfc080e7          	jalr	-772(ra) # 80003614 <iupdate>
    ip->valid = 0;
    80003920:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003924:	854a                	mv	a0,s2
    80003926:	00001097          	auipc	ra,0x1
    8000392a:	ac8080e7          	jalr	-1336(ra) # 800043ee <releasesleep>
    acquire(&icache.lock);
    8000392e:	0001c517          	auipc	a0,0x1c
    80003932:	73250513          	addi	a0,a0,1842 # 80020060 <icache>
    80003936:	ffffd097          	auipc	ra,0xffffd
    8000393a:	2ce080e7          	jalr	718(ra) # 80000c04 <acquire>
    8000393e:	b741                	j	800038be <iput+0x26>

0000000080003940 <iunlockput>:
{
    80003940:	1101                	addi	sp,sp,-32
    80003942:	ec06                	sd	ra,24(sp)
    80003944:	e822                	sd	s0,16(sp)
    80003946:	e426                	sd	s1,8(sp)
    80003948:	1000                	addi	s0,sp,32
    8000394a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000394c:	00000097          	auipc	ra,0x0
    80003950:	e54080e7          	jalr	-428(ra) # 800037a0 <iunlock>
  iput(ip);
    80003954:	8526                	mv	a0,s1
    80003956:	00000097          	auipc	ra,0x0
    8000395a:	f42080e7          	jalr	-190(ra) # 80003898 <iput>
}
    8000395e:	60e2                	ld	ra,24(sp)
    80003960:	6442                	ld	s0,16(sp)
    80003962:	64a2                	ld	s1,8(sp)
    80003964:	6105                	addi	sp,sp,32
    80003966:	8082                	ret

0000000080003968 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003968:	1141                	addi	sp,sp,-16
    8000396a:	e422                	sd	s0,8(sp)
    8000396c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000396e:	411c                	lw	a5,0(a0)
    80003970:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003972:	415c                	lw	a5,4(a0)
    80003974:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003976:	04451783          	lh	a5,68(a0)
    8000397a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000397e:	04a51783          	lh	a5,74(a0)
    80003982:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003986:	04c56783          	lwu	a5,76(a0)
    8000398a:	e99c                	sd	a5,16(a1)
}
    8000398c:	6422                	ld	s0,8(sp)
    8000398e:	0141                	addi	sp,sp,16
    80003990:	8082                	ret

0000000080003992 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003992:	457c                	lw	a5,76(a0)
    80003994:	0ed7e863          	bltu	a5,a3,80003a84 <readi+0xf2>
{
    80003998:	7159                	addi	sp,sp,-112
    8000399a:	f486                	sd	ra,104(sp)
    8000399c:	f0a2                	sd	s0,96(sp)
    8000399e:	eca6                	sd	s1,88(sp)
    800039a0:	e8ca                	sd	s2,80(sp)
    800039a2:	e4ce                	sd	s3,72(sp)
    800039a4:	e0d2                	sd	s4,64(sp)
    800039a6:	fc56                	sd	s5,56(sp)
    800039a8:	f85a                	sd	s6,48(sp)
    800039aa:	f45e                	sd	s7,40(sp)
    800039ac:	f062                	sd	s8,32(sp)
    800039ae:	ec66                	sd	s9,24(sp)
    800039b0:	e86a                	sd	s10,16(sp)
    800039b2:	e46e                	sd	s11,8(sp)
    800039b4:	1880                	addi	s0,sp,112
    800039b6:	8baa                	mv	s7,a0
    800039b8:	8c2e                	mv	s8,a1
    800039ba:	8ab2                	mv	s5,a2
    800039bc:	84b6                	mv	s1,a3
    800039be:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039c0:	9f35                	addw	a4,a4,a3
    return 0;
    800039c2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800039c4:	08d76f63          	bltu	a4,a3,80003a62 <readi+0xd0>
  if(off + n > ip->size)
    800039c8:	00e7f463          	bgeu	a5,a4,800039d0 <readi+0x3e>
    n = ip->size - off;
    800039cc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039d0:	0a0b0863          	beqz	s6,80003a80 <readi+0xee>
    800039d4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039d6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039da:	5cfd                	li	s9,-1
    800039dc:	a82d                	j	80003a16 <readi+0x84>
    800039de:	020a1d93          	slli	s11,s4,0x20
    800039e2:	020ddd93          	srli	s11,s11,0x20
    800039e6:	05890613          	addi	a2,s2,88
    800039ea:	86ee                	mv	a3,s11
    800039ec:	963a                	add	a2,a2,a4
    800039ee:	85d6                	mv	a1,s5
    800039f0:	8562                	mv	a0,s8
    800039f2:	fffff097          	auipc	ra,0xfffff
    800039f6:	ae8080e7          	jalr	-1304(ra) # 800024da <either_copyout>
    800039fa:	05950d63          	beq	a0,s9,80003a54 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    800039fe:	854a                	mv	a0,s2
    80003a00:	fffff097          	auipc	ra,0xfffff
    80003a04:	60c080e7          	jalr	1548(ra) # 8000300c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a08:	013a09bb          	addw	s3,s4,s3
    80003a0c:	009a04bb          	addw	s1,s4,s1
    80003a10:	9aee                	add	s5,s5,s11
    80003a12:	0569f663          	bgeu	s3,s6,80003a5e <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a16:	000ba903          	lw	s2,0(s7)
    80003a1a:	00a4d59b          	srliw	a1,s1,0xa
    80003a1e:	855e                	mv	a0,s7
    80003a20:	00000097          	auipc	ra,0x0
    80003a24:	8b0080e7          	jalr	-1872(ra) # 800032d0 <bmap>
    80003a28:	0005059b          	sext.w	a1,a0
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	fffff097          	auipc	ra,0xfffff
    80003a32:	4ae080e7          	jalr	1198(ra) # 80002edc <bread>
    80003a36:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a38:	3ff4f713          	andi	a4,s1,1023
    80003a3c:	40ed07bb          	subw	a5,s10,a4
    80003a40:	413b06bb          	subw	a3,s6,s3
    80003a44:	8a3e                	mv	s4,a5
    80003a46:	2781                	sext.w	a5,a5
    80003a48:	0006861b          	sext.w	a2,a3
    80003a4c:	f8f679e3          	bgeu	a2,a5,800039de <readi+0x4c>
    80003a50:	8a36                	mv	s4,a3
    80003a52:	b771                	j	800039de <readi+0x4c>
      brelse(bp);
    80003a54:	854a                	mv	a0,s2
    80003a56:	fffff097          	auipc	ra,0xfffff
    80003a5a:	5b6080e7          	jalr	1462(ra) # 8000300c <brelse>
  }
  return tot;
    80003a5e:	0009851b          	sext.w	a0,s3
}
    80003a62:	70a6                	ld	ra,104(sp)
    80003a64:	7406                	ld	s0,96(sp)
    80003a66:	64e6                	ld	s1,88(sp)
    80003a68:	6946                	ld	s2,80(sp)
    80003a6a:	69a6                	ld	s3,72(sp)
    80003a6c:	6a06                	ld	s4,64(sp)
    80003a6e:	7ae2                	ld	s5,56(sp)
    80003a70:	7b42                	ld	s6,48(sp)
    80003a72:	7ba2                	ld	s7,40(sp)
    80003a74:	7c02                	ld	s8,32(sp)
    80003a76:	6ce2                	ld	s9,24(sp)
    80003a78:	6d42                	ld	s10,16(sp)
    80003a7a:	6da2                	ld	s11,8(sp)
    80003a7c:	6165                	addi	sp,sp,112
    80003a7e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a80:	89da                	mv	s3,s6
    80003a82:	bff1                	j	80003a5e <readi+0xcc>
    return 0;
    80003a84:	4501                	li	a0,0
}
    80003a86:	8082                	ret

0000000080003a88 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a88:	457c                	lw	a5,76(a0)
    80003a8a:	10d7e663          	bltu	a5,a3,80003b96 <writei+0x10e>
{
    80003a8e:	7159                	addi	sp,sp,-112
    80003a90:	f486                	sd	ra,104(sp)
    80003a92:	f0a2                	sd	s0,96(sp)
    80003a94:	eca6                	sd	s1,88(sp)
    80003a96:	e8ca                	sd	s2,80(sp)
    80003a98:	e4ce                	sd	s3,72(sp)
    80003a9a:	e0d2                	sd	s4,64(sp)
    80003a9c:	fc56                	sd	s5,56(sp)
    80003a9e:	f85a                	sd	s6,48(sp)
    80003aa0:	f45e                	sd	s7,40(sp)
    80003aa2:	f062                	sd	s8,32(sp)
    80003aa4:	ec66                	sd	s9,24(sp)
    80003aa6:	e86a                	sd	s10,16(sp)
    80003aa8:	e46e                	sd	s11,8(sp)
    80003aaa:	1880                	addi	s0,sp,112
    80003aac:	8baa                	mv	s7,a0
    80003aae:	8c2e                	mv	s8,a1
    80003ab0:	8ab2                	mv	s5,a2
    80003ab2:	8936                	mv	s2,a3
    80003ab4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ab6:	00e687bb          	addw	a5,a3,a4
    80003aba:	0ed7e063          	bltu	a5,a3,80003b9a <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003abe:	00043737          	lui	a4,0x43
    80003ac2:	0cf76e63          	bltu	a4,a5,80003b9e <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ac6:	0a0b0763          	beqz	s6,80003b74 <writei+0xec>
    80003aca:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003acc:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ad0:	5cfd                	li	s9,-1
    80003ad2:	a091                	j	80003b16 <writei+0x8e>
    80003ad4:	02099d93          	slli	s11,s3,0x20
    80003ad8:	020ddd93          	srli	s11,s11,0x20
    80003adc:	05848513          	addi	a0,s1,88
    80003ae0:	86ee                	mv	a3,s11
    80003ae2:	8656                	mv	a2,s5
    80003ae4:	85e2                	mv	a1,s8
    80003ae6:	953a                	add	a0,a0,a4
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	a48080e7          	jalr	-1464(ra) # 80002530 <either_copyin>
    80003af0:	07950263          	beq	a0,s9,80003b54 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003af4:	8526                	mv	a0,s1
    80003af6:	00000097          	auipc	ra,0x0
    80003afa:	77a080e7          	jalr	1914(ra) # 80004270 <log_write>
    brelse(bp);
    80003afe:	8526                	mv	a0,s1
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	50c080e7          	jalr	1292(ra) # 8000300c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b08:	01498a3b          	addw	s4,s3,s4
    80003b0c:	0129893b          	addw	s2,s3,s2
    80003b10:	9aee                	add	s5,s5,s11
    80003b12:	056a7663          	bgeu	s4,s6,80003b5e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b16:	000ba483          	lw	s1,0(s7)
    80003b1a:	00a9559b          	srliw	a1,s2,0xa
    80003b1e:	855e                	mv	a0,s7
    80003b20:	fffff097          	auipc	ra,0xfffff
    80003b24:	7b0080e7          	jalr	1968(ra) # 800032d0 <bmap>
    80003b28:	0005059b          	sext.w	a1,a0
    80003b2c:	8526                	mv	a0,s1
    80003b2e:	fffff097          	auipc	ra,0xfffff
    80003b32:	3ae080e7          	jalr	942(ra) # 80002edc <bread>
    80003b36:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b38:	3ff97713          	andi	a4,s2,1023
    80003b3c:	40ed07bb          	subw	a5,s10,a4
    80003b40:	414b06bb          	subw	a3,s6,s4
    80003b44:	89be                	mv	s3,a5
    80003b46:	2781                	sext.w	a5,a5
    80003b48:	0006861b          	sext.w	a2,a3
    80003b4c:	f8f674e3          	bgeu	a2,a5,80003ad4 <writei+0x4c>
    80003b50:	89b6                	mv	s3,a3
    80003b52:	b749                	j	80003ad4 <writei+0x4c>
      brelse(bp);
    80003b54:	8526                	mv	a0,s1
    80003b56:	fffff097          	auipc	ra,0xfffff
    80003b5a:	4b6080e7          	jalr	1206(ra) # 8000300c <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003b5e:	04cba783          	lw	a5,76(s7)
    80003b62:	0127f463          	bgeu	a5,s2,80003b6a <writei+0xe2>
      ip->size = off;
    80003b66:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003b6a:	855e                	mv	a0,s7
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	aa8080e7          	jalr	-1368(ra) # 80003614 <iupdate>
  }

  return n;
    80003b74:	000b051b          	sext.w	a0,s6
}
    80003b78:	70a6                	ld	ra,104(sp)
    80003b7a:	7406                	ld	s0,96(sp)
    80003b7c:	64e6                	ld	s1,88(sp)
    80003b7e:	6946                	ld	s2,80(sp)
    80003b80:	69a6                	ld	s3,72(sp)
    80003b82:	6a06                	ld	s4,64(sp)
    80003b84:	7ae2                	ld	s5,56(sp)
    80003b86:	7b42                	ld	s6,48(sp)
    80003b88:	7ba2                	ld	s7,40(sp)
    80003b8a:	7c02                	ld	s8,32(sp)
    80003b8c:	6ce2                	ld	s9,24(sp)
    80003b8e:	6d42                	ld	s10,16(sp)
    80003b90:	6da2                	ld	s11,8(sp)
    80003b92:	6165                	addi	sp,sp,112
    80003b94:	8082                	ret
    return -1;
    80003b96:	557d                	li	a0,-1
}
    80003b98:	8082                	ret
    return -1;
    80003b9a:	557d                	li	a0,-1
    80003b9c:	bff1                	j	80003b78 <writei+0xf0>
    return -1;
    80003b9e:	557d                	li	a0,-1
    80003ba0:	bfe1                	j	80003b78 <writei+0xf0>

0000000080003ba2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ba2:	1141                	addi	sp,sp,-16
    80003ba4:	e406                	sd	ra,8(sp)
    80003ba6:	e022                	sd	s0,0(sp)
    80003ba8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003baa:	4639                	li	a2,14
    80003bac:	ffffd097          	auipc	ra,0xffffd
    80003bb0:	230080e7          	jalr	560(ra) # 80000ddc <strncmp>
}
    80003bb4:	60a2                	ld	ra,8(sp)
    80003bb6:	6402                	ld	s0,0(sp)
    80003bb8:	0141                	addi	sp,sp,16
    80003bba:	8082                	ret

0000000080003bbc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003bbc:	7139                	addi	sp,sp,-64
    80003bbe:	fc06                	sd	ra,56(sp)
    80003bc0:	f822                	sd	s0,48(sp)
    80003bc2:	f426                	sd	s1,40(sp)
    80003bc4:	f04a                	sd	s2,32(sp)
    80003bc6:	ec4e                	sd	s3,24(sp)
    80003bc8:	e852                	sd	s4,16(sp)
    80003bca:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003bcc:	04451703          	lh	a4,68(a0)
    80003bd0:	4785                	li	a5,1
    80003bd2:	00f71a63          	bne	a4,a5,80003be6 <dirlookup+0x2a>
    80003bd6:	892a                	mv	s2,a0
    80003bd8:	89ae                	mv	s3,a1
    80003bda:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bdc:	457c                	lw	a5,76(a0)
    80003bde:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003be0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003be2:	e79d                	bnez	a5,80003c10 <dirlookup+0x54>
    80003be4:	a8a5                	j	80003c5c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003be6:	00005517          	auipc	a0,0x5
    80003bea:	a4250513          	addi	a0,a0,-1470 # 80008628 <syscalls+0x1a8>
    80003bee:	ffffd097          	auipc	ra,0xffffd
    80003bf2:	966080e7          	jalr	-1690(ra) # 80000554 <panic>
      panic("dirlookup read");
    80003bf6:	00005517          	auipc	a0,0x5
    80003bfa:	a4a50513          	addi	a0,a0,-1462 # 80008640 <syscalls+0x1c0>
    80003bfe:	ffffd097          	auipc	ra,0xffffd
    80003c02:	956080e7          	jalr	-1706(ra) # 80000554 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c06:	24c1                	addiw	s1,s1,16
    80003c08:	04c92783          	lw	a5,76(s2)
    80003c0c:	04f4f763          	bgeu	s1,a5,80003c5a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c10:	4741                	li	a4,16
    80003c12:	86a6                	mv	a3,s1
    80003c14:	fc040613          	addi	a2,s0,-64
    80003c18:	4581                	li	a1,0
    80003c1a:	854a                	mv	a0,s2
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	d76080e7          	jalr	-650(ra) # 80003992 <readi>
    80003c24:	47c1                	li	a5,16
    80003c26:	fcf518e3          	bne	a0,a5,80003bf6 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c2a:	fc045783          	lhu	a5,-64(s0)
    80003c2e:	dfe1                	beqz	a5,80003c06 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c30:	fc240593          	addi	a1,s0,-62
    80003c34:	854e                	mv	a0,s3
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	f6c080e7          	jalr	-148(ra) # 80003ba2 <namecmp>
    80003c3e:	f561                	bnez	a0,80003c06 <dirlookup+0x4a>
      if(poff)
    80003c40:	000a0463          	beqz	s4,80003c48 <dirlookup+0x8c>
        *poff = off;
    80003c44:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c48:	fc045583          	lhu	a1,-64(s0)
    80003c4c:	00092503          	lw	a0,0(s2)
    80003c50:	fffff097          	auipc	ra,0xfffff
    80003c54:	75a080e7          	jalr	1882(ra) # 800033aa <iget>
    80003c58:	a011                	j	80003c5c <dirlookup+0xa0>
  return 0;
    80003c5a:	4501                	li	a0,0
}
    80003c5c:	70e2                	ld	ra,56(sp)
    80003c5e:	7442                	ld	s0,48(sp)
    80003c60:	74a2                	ld	s1,40(sp)
    80003c62:	7902                	ld	s2,32(sp)
    80003c64:	69e2                	ld	s3,24(sp)
    80003c66:	6a42                	ld	s4,16(sp)
    80003c68:	6121                	addi	sp,sp,64
    80003c6a:	8082                	ret

0000000080003c6c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c6c:	711d                	addi	sp,sp,-96
    80003c6e:	ec86                	sd	ra,88(sp)
    80003c70:	e8a2                	sd	s0,80(sp)
    80003c72:	e4a6                	sd	s1,72(sp)
    80003c74:	e0ca                	sd	s2,64(sp)
    80003c76:	fc4e                	sd	s3,56(sp)
    80003c78:	f852                	sd	s4,48(sp)
    80003c7a:	f456                	sd	s5,40(sp)
    80003c7c:	f05a                	sd	s6,32(sp)
    80003c7e:	ec5e                	sd	s7,24(sp)
    80003c80:	e862                	sd	s8,16(sp)
    80003c82:	e466                	sd	s9,8(sp)
    80003c84:	1080                	addi	s0,sp,96
    80003c86:	84aa                	mv	s1,a0
    80003c88:	8b2e                	mv	s6,a1
    80003c8a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003c8c:	00054703          	lbu	a4,0(a0)
    80003c90:	02f00793          	li	a5,47
    80003c94:	02f70363          	beq	a4,a5,80003cba <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003c98:	ffffe097          	auipc	ra,0xffffe
    80003c9c:	dfa080e7          	jalr	-518(ra) # 80001a92 <myproc>
    80003ca0:	15853503          	ld	a0,344(a0)
    80003ca4:	00000097          	auipc	ra,0x0
    80003ca8:	9fc080e7          	jalr	-1540(ra) # 800036a0 <idup>
    80003cac:	89aa                	mv	s3,a0
  while(*path == '/')
    80003cae:	02f00913          	li	s2,47
  len = path - s;
    80003cb2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003cb4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003cb6:	4c05                	li	s8,1
    80003cb8:	a865                	j	80003d70 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003cba:	4585                	li	a1,1
    80003cbc:	4505                	li	a0,1
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	6ec080e7          	jalr	1772(ra) # 800033aa <iget>
    80003cc6:	89aa                	mv	s3,a0
    80003cc8:	b7dd                	j	80003cae <namex+0x42>
      iunlockput(ip);
    80003cca:	854e                	mv	a0,s3
    80003ccc:	00000097          	auipc	ra,0x0
    80003cd0:	c74080e7          	jalr	-908(ra) # 80003940 <iunlockput>
      return 0;
    80003cd4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003cd6:	854e                	mv	a0,s3
    80003cd8:	60e6                	ld	ra,88(sp)
    80003cda:	6446                	ld	s0,80(sp)
    80003cdc:	64a6                	ld	s1,72(sp)
    80003cde:	6906                	ld	s2,64(sp)
    80003ce0:	79e2                	ld	s3,56(sp)
    80003ce2:	7a42                	ld	s4,48(sp)
    80003ce4:	7aa2                	ld	s5,40(sp)
    80003ce6:	7b02                	ld	s6,32(sp)
    80003ce8:	6be2                	ld	s7,24(sp)
    80003cea:	6c42                	ld	s8,16(sp)
    80003cec:	6ca2                	ld	s9,8(sp)
    80003cee:	6125                	addi	sp,sp,96
    80003cf0:	8082                	ret
      iunlock(ip);
    80003cf2:	854e                	mv	a0,s3
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	aac080e7          	jalr	-1364(ra) # 800037a0 <iunlock>
      return ip;
    80003cfc:	bfe9                	j	80003cd6 <namex+0x6a>
      iunlockput(ip);
    80003cfe:	854e                	mv	a0,s3
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	c40080e7          	jalr	-960(ra) # 80003940 <iunlockput>
      return 0;
    80003d08:	89d2                	mv	s3,s4
    80003d0a:	b7f1                	j	80003cd6 <namex+0x6a>
  len = path - s;
    80003d0c:	40b48633          	sub	a2,s1,a1
    80003d10:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003d14:	094cd463          	bge	s9,s4,80003d9c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d18:	4639                	li	a2,14
    80003d1a:	8556                	mv	a0,s5
    80003d1c:	ffffd097          	auipc	ra,0xffffd
    80003d20:	044080e7          	jalr	68(ra) # 80000d60 <memmove>
  while(*path == '/')
    80003d24:	0004c783          	lbu	a5,0(s1)
    80003d28:	01279763          	bne	a5,s2,80003d36 <namex+0xca>
    path++;
    80003d2c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d2e:	0004c783          	lbu	a5,0(s1)
    80003d32:	ff278de3          	beq	a5,s2,80003d2c <namex+0xc0>
    ilock(ip);
    80003d36:	854e                	mv	a0,s3
    80003d38:	00000097          	auipc	ra,0x0
    80003d3c:	9a6080e7          	jalr	-1626(ra) # 800036de <ilock>
    if(ip->type != T_DIR){
    80003d40:	04499783          	lh	a5,68(s3)
    80003d44:	f98793e3          	bne	a5,s8,80003cca <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003d48:	000b0563          	beqz	s6,80003d52 <namex+0xe6>
    80003d4c:	0004c783          	lbu	a5,0(s1)
    80003d50:	d3cd                	beqz	a5,80003cf2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d52:	865e                	mv	a2,s7
    80003d54:	85d6                	mv	a1,s5
    80003d56:	854e                	mv	a0,s3
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	e64080e7          	jalr	-412(ra) # 80003bbc <dirlookup>
    80003d60:	8a2a                	mv	s4,a0
    80003d62:	dd51                	beqz	a0,80003cfe <namex+0x92>
    iunlockput(ip);
    80003d64:	854e                	mv	a0,s3
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	bda080e7          	jalr	-1062(ra) # 80003940 <iunlockput>
    ip = next;
    80003d6e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003d70:	0004c783          	lbu	a5,0(s1)
    80003d74:	05279763          	bne	a5,s2,80003dc2 <namex+0x156>
    path++;
    80003d78:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d7a:	0004c783          	lbu	a5,0(s1)
    80003d7e:	ff278de3          	beq	a5,s2,80003d78 <namex+0x10c>
  if(*path == 0)
    80003d82:	c79d                	beqz	a5,80003db0 <namex+0x144>
    path++;
    80003d84:	85a6                	mv	a1,s1
  len = path - s;
    80003d86:	8a5e                	mv	s4,s7
    80003d88:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003d8a:	01278963          	beq	a5,s2,80003d9c <namex+0x130>
    80003d8e:	dfbd                	beqz	a5,80003d0c <namex+0xa0>
    path++;
    80003d90:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003d92:	0004c783          	lbu	a5,0(s1)
    80003d96:	ff279ce3          	bne	a5,s2,80003d8e <namex+0x122>
    80003d9a:	bf8d                	j	80003d0c <namex+0xa0>
    memmove(name, s, len);
    80003d9c:	2601                	sext.w	a2,a2
    80003d9e:	8556                	mv	a0,s5
    80003da0:	ffffd097          	auipc	ra,0xffffd
    80003da4:	fc0080e7          	jalr	-64(ra) # 80000d60 <memmove>
    name[len] = 0;
    80003da8:	9a56                	add	s4,s4,s5
    80003daa:	000a0023          	sb	zero,0(s4)
    80003dae:	bf9d                	j	80003d24 <namex+0xb8>
  if(nameiparent){
    80003db0:	f20b03e3          	beqz	s6,80003cd6 <namex+0x6a>
    iput(ip);
    80003db4:	854e                	mv	a0,s3
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	ae2080e7          	jalr	-1310(ra) # 80003898 <iput>
    return 0;
    80003dbe:	4981                	li	s3,0
    80003dc0:	bf19                	j	80003cd6 <namex+0x6a>
  if(*path == 0)
    80003dc2:	d7fd                	beqz	a5,80003db0 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003dc4:	0004c783          	lbu	a5,0(s1)
    80003dc8:	85a6                	mv	a1,s1
    80003dca:	b7d1                	j	80003d8e <namex+0x122>

0000000080003dcc <dirlink>:
{
    80003dcc:	7139                	addi	sp,sp,-64
    80003dce:	fc06                	sd	ra,56(sp)
    80003dd0:	f822                	sd	s0,48(sp)
    80003dd2:	f426                	sd	s1,40(sp)
    80003dd4:	f04a                	sd	s2,32(sp)
    80003dd6:	ec4e                	sd	s3,24(sp)
    80003dd8:	e852                	sd	s4,16(sp)
    80003dda:	0080                	addi	s0,sp,64
    80003ddc:	892a                	mv	s2,a0
    80003dde:	8a2e                	mv	s4,a1
    80003de0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003de2:	4601                	li	a2,0
    80003de4:	00000097          	auipc	ra,0x0
    80003de8:	dd8080e7          	jalr	-552(ra) # 80003bbc <dirlookup>
    80003dec:	e93d                	bnez	a0,80003e62 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003dee:	04c92483          	lw	s1,76(s2)
    80003df2:	c49d                	beqz	s1,80003e20 <dirlink+0x54>
    80003df4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003df6:	4741                	li	a4,16
    80003df8:	86a6                	mv	a3,s1
    80003dfa:	fc040613          	addi	a2,s0,-64
    80003dfe:	4581                	li	a1,0
    80003e00:	854a                	mv	a0,s2
    80003e02:	00000097          	auipc	ra,0x0
    80003e06:	b90080e7          	jalr	-1136(ra) # 80003992 <readi>
    80003e0a:	47c1                	li	a5,16
    80003e0c:	06f51163          	bne	a0,a5,80003e6e <dirlink+0xa2>
    if(de.inum == 0)
    80003e10:	fc045783          	lhu	a5,-64(s0)
    80003e14:	c791                	beqz	a5,80003e20 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e16:	24c1                	addiw	s1,s1,16
    80003e18:	04c92783          	lw	a5,76(s2)
    80003e1c:	fcf4ede3          	bltu	s1,a5,80003df6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e20:	4639                	li	a2,14
    80003e22:	85d2                	mv	a1,s4
    80003e24:	fc240513          	addi	a0,s0,-62
    80003e28:	ffffd097          	auipc	ra,0xffffd
    80003e2c:	ff0080e7          	jalr	-16(ra) # 80000e18 <strncpy>
  de.inum = inum;
    80003e30:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e34:	4741                	li	a4,16
    80003e36:	86a6                	mv	a3,s1
    80003e38:	fc040613          	addi	a2,s0,-64
    80003e3c:	4581                	li	a1,0
    80003e3e:	854a                	mv	a0,s2
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	c48080e7          	jalr	-952(ra) # 80003a88 <writei>
    80003e48:	872a                	mv	a4,a0
    80003e4a:	47c1                	li	a5,16
  return 0;
    80003e4c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e4e:	02f71863          	bne	a4,a5,80003e7e <dirlink+0xb2>
}
    80003e52:	70e2                	ld	ra,56(sp)
    80003e54:	7442                	ld	s0,48(sp)
    80003e56:	74a2                	ld	s1,40(sp)
    80003e58:	7902                	ld	s2,32(sp)
    80003e5a:	69e2                	ld	s3,24(sp)
    80003e5c:	6a42                	ld	s4,16(sp)
    80003e5e:	6121                	addi	sp,sp,64
    80003e60:	8082                	ret
    iput(ip);
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	a36080e7          	jalr	-1482(ra) # 80003898 <iput>
    return -1;
    80003e6a:	557d                	li	a0,-1
    80003e6c:	b7dd                	j	80003e52 <dirlink+0x86>
      panic("dirlink read");
    80003e6e:	00004517          	auipc	a0,0x4
    80003e72:	7e250513          	addi	a0,a0,2018 # 80008650 <syscalls+0x1d0>
    80003e76:	ffffc097          	auipc	ra,0xffffc
    80003e7a:	6de080e7          	jalr	1758(ra) # 80000554 <panic>
    panic("dirlink");
    80003e7e:	00005517          	auipc	a0,0x5
    80003e82:	8f250513          	addi	a0,a0,-1806 # 80008770 <syscalls+0x2f0>
    80003e86:	ffffc097          	auipc	ra,0xffffc
    80003e8a:	6ce080e7          	jalr	1742(ra) # 80000554 <panic>

0000000080003e8e <namei>:

struct inode*
namei(char *path)
{
    80003e8e:	1101                	addi	sp,sp,-32
    80003e90:	ec06                	sd	ra,24(sp)
    80003e92:	e822                	sd	s0,16(sp)
    80003e94:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003e96:	fe040613          	addi	a2,s0,-32
    80003e9a:	4581                	li	a1,0
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	dd0080e7          	jalr	-560(ra) # 80003c6c <namex>
}
    80003ea4:	60e2                	ld	ra,24(sp)
    80003ea6:	6442                	ld	s0,16(sp)
    80003ea8:	6105                	addi	sp,sp,32
    80003eaa:	8082                	ret

0000000080003eac <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003eac:	1141                	addi	sp,sp,-16
    80003eae:	e406                	sd	ra,8(sp)
    80003eb0:	e022                	sd	s0,0(sp)
    80003eb2:	0800                	addi	s0,sp,16
    80003eb4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003eb6:	4585                	li	a1,1
    80003eb8:	00000097          	auipc	ra,0x0
    80003ebc:	db4080e7          	jalr	-588(ra) # 80003c6c <namex>
}
    80003ec0:	60a2                	ld	ra,8(sp)
    80003ec2:	6402                	ld	s0,0(sp)
    80003ec4:	0141                	addi	sp,sp,16
    80003ec6:	8082                	ret

0000000080003ec8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003ec8:	1101                	addi	sp,sp,-32
    80003eca:	ec06                	sd	ra,24(sp)
    80003ecc:	e822                	sd	s0,16(sp)
    80003ece:	e426                	sd	s1,8(sp)
    80003ed0:	e04a                	sd	s2,0(sp)
    80003ed2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003ed4:	0001e917          	auipc	s2,0x1e
    80003ed8:	c3490913          	addi	s2,s2,-972 # 80021b08 <log>
    80003edc:	01892583          	lw	a1,24(s2)
    80003ee0:	02892503          	lw	a0,40(s2)
    80003ee4:	fffff097          	auipc	ra,0xfffff
    80003ee8:	ff8080e7          	jalr	-8(ra) # 80002edc <bread>
    80003eec:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003eee:	02c92683          	lw	a3,44(s2)
    80003ef2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ef4:	02d05763          	blez	a3,80003f22 <write_head+0x5a>
    80003ef8:	0001e797          	auipc	a5,0x1e
    80003efc:	c4078793          	addi	a5,a5,-960 # 80021b38 <log+0x30>
    80003f00:	05c50713          	addi	a4,a0,92
    80003f04:	36fd                	addiw	a3,a3,-1
    80003f06:	1682                	slli	a3,a3,0x20
    80003f08:	9281                	srli	a3,a3,0x20
    80003f0a:	068a                	slli	a3,a3,0x2
    80003f0c:	0001e617          	auipc	a2,0x1e
    80003f10:	c3060613          	addi	a2,a2,-976 # 80021b3c <log+0x34>
    80003f14:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f16:	4390                	lw	a2,0(a5)
    80003f18:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f1a:	0791                	addi	a5,a5,4
    80003f1c:	0711                	addi	a4,a4,4
    80003f1e:	fed79ce3          	bne	a5,a3,80003f16 <write_head+0x4e>
  }
  bwrite(buf);
    80003f22:	8526                	mv	a0,s1
    80003f24:	fffff097          	auipc	ra,0xfffff
    80003f28:	0aa080e7          	jalr	170(ra) # 80002fce <bwrite>
  brelse(buf);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	fffff097          	auipc	ra,0xfffff
    80003f32:	0de080e7          	jalr	222(ra) # 8000300c <brelse>
}
    80003f36:	60e2                	ld	ra,24(sp)
    80003f38:	6442                	ld	s0,16(sp)
    80003f3a:	64a2                	ld	s1,8(sp)
    80003f3c:	6902                	ld	s2,0(sp)
    80003f3e:	6105                	addi	sp,sp,32
    80003f40:	8082                	ret

0000000080003f42 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f42:	0001e797          	auipc	a5,0x1e
    80003f46:	bf27a783          	lw	a5,-1038(a5) # 80021b34 <log+0x2c>
    80003f4a:	0af05663          	blez	a5,80003ff6 <install_trans+0xb4>
{
    80003f4e:	7139                	addi	sp,sp,-64
    80003f50:	fc06                	sd	ra,56(sp)
    80003f52:	f822                	sd	s0,48(sp)
    80003f54:	f426                	sd	s1,40(sp)
    80003f56:	f04a                	sd	s2,32(sp)
    80003f58:	ec4e                	sd	s3,24(sp)
    80003f5a:	e852                	sd	s4,16(sp)
    80003f5c:	e456                	sd	s5,8(sp)
    80003f5e:	0080                	addi	s0,sp,64
    80003f60:	0001ea97          	auipc	s5,0x1e
    80003f64:	bd8a8a93          	addi	s5,s5,-1064 # 80021b38 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f68:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f6a:	0001e997          	auipc	s3,0x1e
    80003f6e:	b9e98993          	addi	s3,s3,-1122 # 80021b08 <log>
    80003f72:	0189a583          	lw	a1,24(s3)
    80003f76:	014585bb          	addw	a1,a1,s4
    80003f7a:	2585                	addiw	a1,a1,1
    80003f7c:	0289a503          	lw	a0,40(s3)
    80003f80:	fffff097          	auipc	ra,0xfffff
    80003f84:	f5c080e7          	jalr	-164(ra) # 80002edc <bread>
    80003f88:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003f8a:	000aa583          	lw	a1,0(s5)
    80003f8e:	0289a503          	lw	a0,40(s3)
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	f4a080e7          	jalr	-182(ra) # 80002edc <bread>
    80003f9a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003f9c:	40000613          	li	a2,1024
    80003fa0:	05890593          	addi	a1,s2,88
    80003fa4:	05850513          	addi	a0,a0,88
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	db8080e7          	jalr	-584(ra) # 80000d60 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	01c080e7          	jalr	28(ra) # 80002fce <bwrite>
    bunpin(dbuf);
    80003fba:	8526                	mv	a0,s1
    80003fbc:	fffff097          	auipc	ra,0xfffff
    80003fc0:	12a080e7          	jalr	298(ra) # 800030e6 <bunpin>
    brelse(lbuf);
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	fffff097          	auipc	ra,0xfffff
    80003fca:	046080e7          	jalr	70(ra) # 8000300c <brelse>
    brelse(dbuf);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	fffff097          	auipc	ra,0xfffff
    80003fd4:	03c080e7          	jalr	60(ra) # 8000300c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fd8:	2a05                	addiw	s4,s4,1
    80003fda:	0a91                	addi	s5,s5,4
    80003fdc:	02c9a783          	lw	a5,44(s3)
    80003fe0:	f8fa49e3          	blt	s4,a5,80003f72 <install_trans+0x30>
}
    80003fe4:	70e2                	ld	ra,56(sp)
    80003fe6:	7442                	ld	s0,48(sp)
    80003fe8:	74a2                	ld	s1,40(sp)
    80003fea:	7902                	ld	s2,32(sp)
    80003fec:	69e2                	ld	s3,24(sp)
    80003fee:	6a42                	ld	s4,16(sp)
    80003ff0:	6aa2                	ld	s5,8(sp)
    80003ff2:	6121                	addi	sp,sp,64
    80003ff4:	8082                	ret
    80003ff6:	8082                	ret

0000000080003ff8 <initlog>:
{
    80003ff8:	7179                	addi	sp,sp,-48
    80003ffa:	f406                	sd	ra,40(sp)
    80003ffc:	f022                	sd	s0,32(sp)
    80003ffe:	ec26                	sd	s1,24(sp)
    80004000:	e84a                	sd	s2,16(sp)
    80004002:	e44e                	sd	s3,8(sp)
    80004004:	1800                	addi	s0,sp,48
    80004006:	892a                	mv	s2,a0
    80004008:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000400a:	0001e497          	auipc	s1,0x1e
    8000400e:	afe48493          	addi	s1,s1,-1282 # 80021b08 <log>
    80004012:	00004597          	auipc	a1,0x4
    80004016:	64e58593          	addi	a1,a1,1614 # 80008660 <syscalls+0x1e0>
    8000401a:	8526                	mv	a0,s1
    8000401c:	ffffd097          	auipc	ra,0xffffd
    80004020:	b58080e7          	jalr	-1192(ra) # 80000b74 <initlock>
  log.start = sb->logstart;
    80004024:	0149a583          	lw	a1,20(s3)
    80004028:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000402a:	0109a783          	lw	a5,16(s3)
    8000402e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004030:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004034:	854a                	mv	a0,s2
    80004036:	fffff097          	auipc	ra,0xfffff
    8000403a:	ea6080e7          	jalr	-346(ra) # 80002edc <bread>
  log.lh.n = lh->n;
    8000403e:	4d3c                	lw	a5,88(a0)
    80004040:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004042:	02f05563          	blez	a5,8000406c <initlog+0x74>
    80004046:	05c50713          	addi	a4,a0,92
    8000404a:	0001e697          	auipc	a3,0x1e
    8000404e:	aee68693          	addi	a3,a3,-1298 # 80021b38 <log+0x30>
    80004052:	37fd                	addiw	a5,a5,-1
    80004054:	1782                	slli	a5,a5,0x20
    80004056:	9381                	srli	a5,a5,0x20
    80004058:	078a                	slli	a5,a5,0x2
    8000405a:	06050613          	addi	a2,a0,96
    8000405e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80004060:	4310                	lw	a2,0(a4)
    80004062:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80004064:	0711                	addi	a4,a4,4
    80004066:	0691                	addi	a3,a3,4
    80004068:	fef71ce3          	bne	a4,a5,80004060 <initlog+0x68>
  brelse(buf);
    8000406c:	fffff097          	auipc	ra,0xfffff
    80004070:	fa0080e7          	jalr	-96(ra) # 8000300c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80004074:	00000097          	auipc	ra,0x0
    80004078:	ece080e7          	jalr	-306(ra) # 80003f42 <install_trans>
  log.lh.n = 0;
    8000407c:	0001e797          	auipc	a5,0x1e
    80004080:	aa07ac23          	sw	zero,-1352(a5) # 80021b34 <log+0x2c>
  write_head(); // clear the log
    80004084:	00000097          	auipc	ra,0x0
    80004088:	e44080e7          	jalr	-444(ra) # 80003ec8 <write_head>
}
    8000408c:	70a2                	ld	ra,40(sp)
    8000408e:	7402                	ld	s0,32(sp)
    80004090:	64e2                	ld	s1,24(sp)
    80004092:	6942                	ld	s2,16(sp)
    80004094:	69a2                	ld	s3,8(sp)
    80004096:	6145                	addi	sp,sp,48
    80004098:	8082                	ret

000000008000409a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000409a:	1101                	addi	sp,sp,-32
    8000409c:	ec06                	sd	ra,24(sp)
    8000409e:	e822                	sd	s0,16(sp)
    800040a0:	e426                	sd	s1,8(sp)
    800040a2:	e04a                	sd	s2,0(sp)
    800040a4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040a6:	0001e517          	auipc	a0,0x1e
    800040aa:	a6250513          	addi	a0,a0,-1438 # 80021b08 <log>
    800040ae:	ffffd097          	auipc	ra,0xffffd
    800040b2:	b56080e7          	jalr	-1194(ra) # 80000c04 <acquire>
  while(1){
    if(log.committing){
    800040b6:	0001e497          	auipc	s1,0x1e
    800040ba:	a5248493          	addi	s1,s1,-1454 # 80021b08 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040be:	4979                	li	s2,30
    800040c0:	a039                	j	800040ce <begin_op+0x34>
      sleep(&log, &log.lock);
    800040c2:	85a6                	mv	a1,s1
    800040c4:	8526                	mv	a0,s1
    800040c6:	ffffe097          	auipc	ra,0xffffe
    800040ca:	1b4080e7          	jalr	436(ra) # 8000227a <sleep>
    if(log.committing){
    800040ce:	50dc                	lw	a5,36(s1)
    800040d0:	fbed                	bnez	a5,800040c2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040d2:	509c                	lw	a5,32(s1)
    800040d4:	0017871b          	addiw	a4,a5,1
    800040d8:	0007069b          	sext.w	a3,a4
    800040dc:	0027179b          	slliw	a5,a4,0x2
    800040e0:	9fb9                	addw	a5,a5,a4
    800040e2:	0017979b          	slliw	a5,a5,0x1
    800040e6:	54d8                	lw	a4,44(s1)
    800040e8:	9fb9                	addw	a5,a5,a4
    800040ea:	00f95963          	bge	s2,a5,800040fc <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800040ee:	85a6                	mv	a1,s1
    800040f0:	8526                	mv	a0,s1
    800040f2:	ffffe097          	auipc	ra,0xffffe
    800040f6:	188080e7          	jalr	392(ra) # 8000227a <sleep>
    800040fa:	bfd1                	j	800040ce <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800040fc:	0001e517          	auipc	a0,0x1e
    80004100:	a0c50513          	addi	a0,a0,-1524 # 80021b08 <log>
    80004104:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	bb2080e7          	jalr	-1102(ra) # 80000cb8 <release>
      break;
    }
  }
}
    8000410e:	60e2                	ld	ra,24(sp)
    80004110:	6442                	ld	s0,16(sp)
    80004112:	64a2                	ld	s1,8(sp)
    80004114:	6902                	ld	s2,0(sp)
    80004116:	6105                	addi	sp,sp,32
    80004118:	8082                	ret

000000008000411a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000411a:	7139                	addi	sp,sp,-64
    8000411c:	fc06                	sd	ra,56(sp)
    8000411e:	f822                	sd	s0,48(sp)
    80004120:	f426                	sd	s1,40(sp)
    80004122:	f04a                	sd	s2,32(sp)
    80004124:	ec4e                	sd	s3,24(sp)
    80004126:	e852                	sd	s4,16(sp)
    80004128:	e456                	sd	s5,8(sp)
    8000412a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000412c:	0001e497          	auipc	s1,0x1e
    80004130:	9dc48493          	addi	s1,s1,-1572 # 80021b08 <log>
    80004134:	8526                	mv	a0,s1
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	ace080e7          	jalr	-1330(ra) # 80000c04 <acquire>
  log.outstanding -= 1;
    8000413e:	509c                	lw	a5,32(s1)
    80004140:	37fd                	addiw	a5,a5,-1
    80004142:	0007891b          	sext.w	s2,a5
    80004146:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004148:	50dc                	lw	a5,36(s1)
    8000414a:	efb9                	bnez	a5,800041a8 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000414c:	06091663          	bnez	s2,800041b8 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80004150:	0001e497          	auipc	s1,0x1e
    80004154:	9b848493          	addi	s1,s1,-1608 # 80021b08 <log>
    80004158:	4785                	li	a5,1
    8000415a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000415c:	8526                	mv	a0,s1
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	b5a080e7          	jalr	-1190(ra) # 80000cb8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004166:	54dc                	lw	a5,44(s1)
    80004168:	06f04763          	bgtz	a5,800041d6 <end_op+0xbc>
    acquire(&log.lock);
    8000416c:	0001e497          	auipc	s1,0x1e
    80004170:	99c48493          	addi	s1,s1,-1636 # 80021b08 <log>
    80004174:	8526                	mv	a0,s1
    80004176:	ffffd097          	auipc	ra,0xffffd
    8000417a:	a8e080e7          	jalr	-1394(ra) # 80000c04 <acquire>
    log.committing = 0;
    8000417e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004182:	8526                	mv	a0,s1
    80004184:	ffffe097          	auipc	ra,0xffffe
    80004188:	27c080e7          	jalr	636(ra) # 80002400 <wakeup>
    release(&log.lock);
    8000418c:	8526                	mv	a0,s1
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	b2a080e7          	jalr	-1238(ra) # 80000cb8 <release>
}
    80004196:	70e2                	ld	ra,56(sp)
    80004198:	7442                	ld	s0,48(sp)
    8000419a:	74a2                	ld	s1,40(sp)
    8000419c:	7902                	ld	s2,32(sp)
    8000419e:	69e2                	ld	s3,24(sp)
    800041a0:	6a42                	ld	s4,16(sp)
    800041a2:	6aa2                	ld	s5,8(sp)
    800041a4:	6121                	addi	sp,sp,64
    800041a6:	8082                	ret
    panic("log.committing");
    800041a8:	00004517          	auipc	a0,0x4
    800041ac:	4c050513          	addi	a0,a0,1216 # 80008668 <syscalls+0x1e8>
    800041b0:	ffffc097          	auipc	ra,0xffffc
    800041b4:	3a4080e7          	jalr	932(ra) # 80000554 <panic>
    wakeup(&log);
    800041b8:	0001e497          	auipc	s1,0x1e
    800041bc:	95048493          	addi	s1,s1,-1712 # 80021b08 <log>
    800041c0:	8526                	mv	a0,s1
    800041c2:	ffffe097          	auipc	ra,0xffffe
    800041c6:	23e080e7          	jalr	574(ra) # 80002400 <wakeup>
  release(&log.lock);
    800041ca:	8526                	mv	a0,s1
    800041cc:	ffffd097          	auipc	ra,0xffffd
    800041d0:	aec080e7          	jalr	-1300(ra) # 80000cb8 <release>
  if(do_commit){
    800041d4:	b7c9                	j	80004196 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041d6:	0001ea97          	auipc	s5,0x1e
    800041da:	962a8a93          	addi	s5,s5,-1694 # 80021b38 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041de:	0001ea17          	auipc	s4,0x1e
    800041e2:	92aa0a13          	addi	s4,s4,-1750 # 80021b08 <log>
    800041e6:	018a2583          	lw	a1,24(s4)
    800041ea:	012585bb          	addw	a1,a1,s2
    800041ee:	2585                	addiw	a1,a1,1
    800041f0:	028a2503          	lw	a0,40(s4)
    800041f4:	fffff097          	auipc	ra,0xfffff
    800041f8:	ce8080e7          	jalr	-792(ra) # 80002edc <bread>
    800041fc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800041fe:	000aa583          	lw	a1,0(s5)
    80004202:	028a2503          	lw	a0,40(s4)
    80004206:	fffff097          	auipc	ra,0xfffff
    8000420a:	cd6080e7          	jalr	-810(ra) # 80002edc <bread>
    8000420e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004210:	40000613          	li	a2,1024
    80004214:	05850593          	addi	a1,a0,88
    80004218:	05848513          	addi	a0,s1,88
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	b44080e7          	jalr	-1212(ra) # 80000d60 <memmove>
    bwrite(to);  // write the log
    80004224:	8526                	mv	a0,s1
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	da8080e7          	jalr	-600(ra) # 80002fce <bwrite>
    brelse(from);
    8000422e:	854e                	mv	a0,s3
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	ddc080e7          	jalr	-548(ra) # 8000300c <brelse>
    brelse(to);
    80004238:	8526                	mv	a0,s1
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	dd2080e7          	jalr	-558(ra) # 8000300c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004242:	2905                	addiw	s2,s2,1
    80004244:	0a91                	addi	s5,s5,4
    80004246:	02ca2783          	lw	a5,44(s4)
    8000424a:	f8f94ee3          	blt	s2,a5,800041e6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000424e:	00000097          	auipc	ra,0x0
    80004252:	c7a080e7          	jalr	-902(ra) # 80003ec8 <write_head>
    install_trans(); // Now install writes to home locations
    80004256:	00000097          	auipc	ra,0x0
    8000425a:	cec080e7          	jalr	-788(ra) # 80003f42 <install_trans>
    log.lh.n = 0;
    8000425e:	0001e797          	auipc	a5,0x1e
    80004262:	8c07ab23          	sw	zero,-1834(a5) # 80021b34 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004266:	00000097          	auipc	ra,0x0
    8000426a:	c62080e7          	jalr	-926(ra) # 80003ec8 <write_head>
    8000426e:	bdfd                	j	8000416c <end_op+0x52>

0000000080004270 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004270:	1101                	addi	sp,sp,-32
    80004272:	ec06                	sd	ra,24(sp)
    80004274:	e822                	sd	s0,16(sp)
    80004276:	e426                	sd	s1,8(sp)
    80004278:	e04a                	sd	s2,0(sp)
    8000427a:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000427c:	0001e717          	auipc	a4,0x1e
    80004280:	8b872703          	lw	a4,-1864(a4) # 80021b34 <log+0x2c>
    80004284:	47f5                	li	a5,29
    80004286:	08e7c063          	blt	a5,a4,80004306 <log_write+0x96>
    8000428a:	84aa                	mv	s1,a0
    8000428c:	0001e797          	auipc	a5,0x1e
    80004290:	8987a783          	lw	a5,-1896(a5) # 80021b24 <log+0x1c>
    80004294:	37fd                	addiw	a5,a5,-1
    80004296:	06f75863          	bge	a4,a5,80004306 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000429a:	0001e797          	auipc	a5,0x1e
    8000429e:	88e7a783          	lw	a5,-1906(a5) # 80021b28 <log+0x20>
    800042a2:	06f05a63          	blez	a5,80004316 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800042a6:	0001e917          	auipc	s2,0x1e
    800042aa:	86290913          	addi	s2,s2,-1950 # 80021b08 <log>
    800042ae:	854a                	mv	a0,s2
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	954080e7          	jalr	-1708(ra) # 80000c04 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800042b8:	02c92603          	lw	a2,44(s2)
    800042bc:	06c05563          	blez	a2,80004326 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800042c0:	44cc                	lw	a1,12(s1)
    800042c2:	0001e717          	auipc	a4,0x1e
    800042c6:	87670713          	addi	a4,a4,-1930 # 80021b38 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800042ca:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800042cc:	4314                	lw	a3,0(a4)
    800042ce:	04b68d63          	beq	a3,a1,80004328 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800042d2:	2785                	addiw	a5,a5,1
    800042d4:	0711                	addi	a4,a4,4
    800042d6:	fec79be3          	bne	a5,a2,800042cc <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800042da:	0621                	addi	a2,a2,8
    800042dc:	060a                	slli	a2,a2,0x2
    800042de:	0001e797          	auipc	a5,0x1e
    800042e2:	82a78793          	addi	a5,a5,-2006 # 80021b08 <log>
    800042e6:	963e                	add	a2,a2,a5
    800042e8:	44dc                	lw	a5,12(s1)
    800042ea:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042ec:	8526                	mv	a0,s1
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	dbc080e7          	jalr	-580(ra) # 800030aa <bpin>
    log.lh.n++;
    800042f6:	0001e717          	auipc	a4,0x1e
    800042fa:	81270713          	addi	a4,a4,-2030 # 80021b08 <log>
    800042fe:	575c                	lw	a5,44(a4)
    80004300:	2785                	addiw	a5,a5,1
    80004302:	d75c                	sw	a5,44(a4)
    80004304:	a83d                	j	80004342 <log_write+0xd2>
    panic("too big a transaction");
    80004306:	00004517          	auipc	a0,0x4
    8000430a:	37250513          	addi	a0,a0,882 # 80008678 <syscalls+0x1f8>
    8000430e:	ffffc097          	auipc	ra,0xffffc
    80004312:	246080e7          	jalr	582(ra) # 80000554 <panic>
    panic("log_write outside of trans");
    80004316:	00004517          	auipc	a0,0x4
    8000431a:	37a50513          	addi	a0,a0,890 # 80008690 <syscalls+0x210>
    8000431e:	ffffc097          	auipc	ra,0xffffc
    80004322:	236080e7          	jalr	566(ra) # 80000554 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004326:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004328:	00878713          	addi	a4,a5,8
    8000432c:	00271693          	slli	a3,a4,0x2
    80004330:	0001d717          	auipc	a4,0x1d
    80004334:	7d870713          	addi	a4,a4,2008 # 80021b08 <log>
    80004338:	9736                	add	a4,a4,a3
    8000433a:	44d4                	lw	a3,12(s1)
    8000433c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000433e:	faf607e3          	beq	a2,a5,800042ec <log_write+0x7c>
  }
  release(&log.lock);
    80004342:	0001d517          	auipc	a0,0x1d
    80004346:	7c650513          	addi	a0,a0,1990 # 80021b08 <log>
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	96e080e7          	jalr	-1682(ra) # 80000cb8 <release>
}
    80004352:	60e2                	ld	ra,24(sp)
    80004354:	6442                	ld	s0,16(sp)
    80004356:	64a2                	ld	s1,8(sp)
    80004358:	6902                	ld	s2,0(sp)
    8000435a:	6105                	addi	sp,sp,32
    8000435c:	8082                	ret

000000008000435e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000435e:	1101                	addi	sp,sp,-32
    80004360:	ec06                	sd	ra,24(sp)
    80004362:	e822                	sd	s0,16(sp)
    80004364:	e426                	sd	s1,8(sp)
    80004366:	e04a                	sd	s2,0(sp)
    80004368:	1000                	addi	s0,sp,32
    8000436a:	84aa                	mv	s1,a0
    8000436c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000436e:	00004597          	auipc	a1,0x4
    80004372:	34258593          	addi	a1,a1,834 # 800086b0 <syscalls+0x230>
    80004376:	0521                	addi	a0,a0,8
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	7fc080e7          	jalr	2044(ra) # 80000b74 <initlock>
  lk->name = name;
    80004380:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004384:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004388:	0204a423          	sw	zero,40(s1)
}
    8000438c:	60e2                	ld	ra,24(sp)
    8000438e:	6442                	ld	s0,16(sp)
    80004390:	64a2                	ld	s1,8(sp)
    80004392:	6902                	ld	s2,0(sp)
    80004394:	6105                	addi	sp,sp,32
    80004396:	8082                	ret

0000000080004398 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004398:	1101                	addi	sp,sp,-32
    8000439a:	ec06                	sd	ra,24(sp)
    8000439c:	e822                	sd	s0,16(sp)
    8000439e:	e426                	sd	s1,8(sp)
    800043a0:	e04a                	sd	s2,0(sp)
    800043a2:	1000                	addi	s0,sp,32
    800043a4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043a6:	00850913          	addi	s2,a0,8
    800043aa:	854a                	mv	a0,s2
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	858080e7          	jalr	-1960(ra) # 80000c04 <acquire>
  while (lk->locked) {
    800043b4:	409c                	lw	a5,0(s1)
    800043b6:	cb89                	beqz	a5,800043c8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800043b8:	85ca                	mv	a1,s2
    800043ba:	8526                	mv	a0,s1
    800043bc:	ffffe097          	auipc	ra,0xffffe
    800043c0:	ebe080e7          	jalr	-322(ra) # 8000227a <sleep>
  while (lk->locked) {
    800043c4:	409c                	lw	a5,0(s1)
    800043c6:	fbed                	bnez	a5,800043b8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800043c8:	4785                	li	a5,1
    800043ca:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800043cc:	ffffd097          	auipc	ra,0xffffd
    800043d0:	6c6080e7          	jalr	1734(ra) # 80001a92 <myproc>
    800043d4:	5d1c                	lw	a5,56(a0)
    800043d6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800043d8:	854a                	mv	a0,s2
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	8de080e7          	jalr	-1826(ra) # 80000cb8 <release>
}
    800043e2:	60e2                	ld	ra,24(sp)
    800043e4:	6442                	ld	s0,16(sp)
    800043e6:	64a2                	ld	s1,8(sp)
    800043e8:	6902                	ld	s2,0(sp)
    800043ea:	6105                	addi	sp,sp,32
    800043ec:	8082                	ret

00000000800043ee <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043ee:	1101                	addi	sp,sp,-32
    800043f0:	ec06                	sd	ra,24(sp)
    800043f2:	e822                	sd	s0,16(sp)
    800043f4:	e426                	sd	s1,8(sp)
    800043f6:	e04a                	sd	s2,0(sp)
    800043f8:	1000                	addi	s0,sp,32
    800043fa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043fc:	00850913          	addi	s2,a0,8
    80004400:	854a                	mv	a0,s2
    80004402:	ffffd097          	auipc	ra,0xffffd
    80004406:	802080e7          	jalr	-2046(ra) # 80000c04 <acquire>
  lk->locked = 0;
    8000440a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000440e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004412:	8526                	mv	a0,s1
    80004414:	ffffe097          	auipc	ra,0xffffe
    80004418:	fec080e7          	jalr	-20(ra) # 80002400 <wakeup>
  release(&lk->lk);
    8000441c:	854a                	mv	a0,s2
    8000441e:	ffffd097          	auipc	ra,0xffffd
    80004422:	89a080e7          	jalr	-1894(ra) # 80000cb8 <release>
}
    80004426:	60e2                	ld	ra,24(sp)
    80004428:	6442                	ld	s0,16(sp)
    8000442a:	64a2                	ld	s1,8(sp)
    8000442c:	6902                	ld	s2,0(sp)
    8000442e:	6105                	addi	sp,sp,32
    80004430:	8082                	ret

0000000080004432 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004432:	7179                	addi	sp,sp,-48
    80004434:	f406                	sd	ra,40(sp)
    80004436:	f022                	sd	s0,32(sp)
    80004438:	ec26                	sd	s1,24(sp)
    8000443a:	e84a                	sd	s2,16(sp)
    8000443c:	e44e                	sd	s3,8(sp)
    8000443e:	1800                	addi	s0,sp,48
    80004440:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004442:	00850913          	addi	s2,a0,8
    80004446:	854a                	mv	a0,s2
    80004448:	ffffc097          	auipc	ra,0xffffc
    8000444c:	7bc080e7          	jalr	1980(ra) # 80000c04 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004450:	409c                	lw	a5,0(s1)
    80004452:	ef99                	bnez	a5,80004470 <holdingsleep+0x3e>
    80004454:	4481                	li	s1,0
  release(&lk->lk);
    80004456:	854a                	mv	a0,s2
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	860080e7          	jalr	-1952(ra) # 80000cb8 <release>
  return r;
}
    80004460:	8526                	mv	a0,s1
    80004462:	70a2                	ld	ra,40(sp)
    80004464:	7402                	ld	s0,32(sp)
    80004466:	64e2                	ld	s1,24(sp)
    80004468:	6942                	ld	s2,16(sp)
    8000446a:	69a2                	ld	s3,8(sp)
    8000446c:	6145                	addi	sp,sp,48
    8000446e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004470:	0284a983          	lw	s3,40(s1)
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	61e080e7          	jalr	1566(ra) # 80001a92 <myproc>
    8000447c:	5d04                	lw	s1,56(a0)
    8000447e:	413484b3          	sub	s1,s1,s3
    80004482:	0014b493          	seqz	s1,s1
    80004486:	bfc1                	j	80004456 <holdingsleep+0x24>

0000000080004488 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004488:	1141                	addi	sp,sp,-16
    8000448a:	e406                	sd	ra,8(sp)
    8000448c:	e022                	sd	s0,0(sp)
    8000448e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004490:	00004597          	auipc	a1,0x4
    80004494:	23058593          	addi	a1,a1,560 # 800086c0 <syscalls+0x240>
    80004498:	0001d517          	auipc	a0,0x1d
    8000449c:	7b850513          	addi	a0,a0,1976 # 80021c50 <ftable>
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	6d4080e7          	jalr	1748(ra) # 80000b74 <initlock>
}
    800044a8:	60a2                	ld	ra,8(sp)
    800044aa:	6402                	ld	s0,0(sp)
    800044ac:	0141                	addi	sp,sp,16
    800044ae:	8082                	ret

00000000800044b0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800044b0:	1101                	addi	sp,sp,-32
    800044b2:	ec06                	sd	ra,24(sp)
    800044b4:	e822                	sd	s0,16(sp)
    800044b6:	e426                	sd	s1,8(sp)
    800044b8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800044ba:	0001d517          	auipc	a0,0x1d
    800044be:	79650513          	addi	a0,a0,1942 # 80021c50 <ftable>
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	742080e7          	jalr	1858(ra) # 80000c04 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044ca:	0001d497          	auipc	s1,0x1d
    800044ce:	79e48493          	addi	s1,s1,1950 # 80021c68 <ftable+0x18>
    800044d2:	0001e717          	auipc	a4,0x1e
    800044d6:	73670713          	addi	a4,a4,1846 # 80022c08 <ftable+0xfb8>
    if(f->ref == 0){
    800044da:	40dc                	lw	a5,4(s1)
    800044dc:	cf99                	beqz	a5,800044fa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044de:	02848493          	addi	s1,s1,40
    800044e2:	fee49ce3          	bne	s1,a4,800044da <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800044e6:	0001d517          	auipc	a0,0x1d
    800044ea:	76a50513          	addi	a0,a0,1898 # 80021c50 <ftable>
    800044ee:	ffffc097          	auipc	ra,0xffffc
    800044f2:	7ca080e7          	jalr	1994(ra) # 80000cb8 <release>
  return 0;
    800044f6:	4481                	li	s1,0
    800044f8:	a819                	j	8000450e <filealloc+0x5e>
      f->ref = 1;
    800044fa:	4785                	li	a5,1
    800044fc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800044fe:	0001d517          	auipc	a0,0x1d
    80004502:	75250513          	addi	a0,a0,1874 # 80021c50 <ftable>
    80004506:	ffffc097          	auipc	ra,0xffffc
    8000450a:	7b2080e7          	jalr	1970(ra) # 80000cb8 <release>
}
    8000450e:	8526                	mv	a0,s1
    80004510:	60e2                	ld	ra,24(sp)
    80004512:	6442                	ld	s0,16(sp)
    80004514:	64a2                	ld	s1,8(sp)
    80004516:	6105                	addi	sp,sp,32
    80004518:	8082                	ret

000000008000451a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000451a:	1101                	addi	sp,sp,-32
    8000451c:	ec06                	sd	ra,24(sp)
    8000451e:	e822                	sd	s0,16(sp)
    80004520:	e426                	sd	s1,8(sp)
    80004522:	1000                	addi	s0,sp,32
    80004524:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004526:	0001d517          	auipc	a0,0x1d
    8000452a:	72a50513          	addi	a0,a0,1834 # 80021c50 <ftable>
    8000452e:	ffffc097          	auipc	ra,0xffffc
    80004532:	6d6080e7          	jalr	1750(ra) # 80000c04 <acquire>
  if(f->ref < 1)
    80004536:	40dc                	lw	a5,4(s1)
    80004538:	02f05263          	blez	a5,8000455c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000453c:	2785                	addiw	a5,a5,1
    8000453e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004540:	0001d517          	auipc	a0,0x1d
    80004544:	71050513          	addi	a0,a0,1808 # 80021c50 <ftable>
    80004548:	ffffc097          	auipc	ra,0xffffc
    8000454c:	770080e7          	jalr	1904(ra) # 80000cb8 <release>
  return f;
}
    80004550:	8526                	mv	a0,s1
    80004552:	60e2                	ld	ra,24(sp)
    80004554:	6442                	ld	s0,16(sp)
    80004556:	64a2                	ld	s1,8(sp)
    80004558:	6105                	addi	sp,sp,32
    8000455a:	8082                	ret
    panic("filedup");
    8000455c:	00004517          	auipc	a0,0x4
    80004560:	16c50513          	addi	a0,a0,364 # 800086c8 <syscalls+0x248>
    80004564:	ffffc097          	auipc	ra,0xffffc
    80004568:	ff0080e7          	jalr	-16(ra) # 80000554 <panic>

000000008000456c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000456c:	7139                	addi	sp,sp,-64
    8000456e:	fc06                	sd	ra,56(sp)
    80004570:	f822                	sd	s0,48(sp)
    80004572:	f426                	sd	s1,40(sp)
    80004574:	f04a                	sd	s2,32(sp)
    80004576:	ec4e                	sd	s3,24(sp)
    80004578:	e852                	sd	s4,16(sp)
    8000457a:	e456                	sd	s5,8(sp)
    8000457c:	0080                	addi	s0,sp,64
    8000457e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004580:	0001d517          	auipc	a0,0x1d
    80004584:	6d050513          	addi	a0,a0,1744 # 80021c50 <ftable>
    80004588:	ffffc097          	auipc	ra,0xffffc
    8000458c:	67c080e7          	jalr	1660(ra) # 80000c04 <acquire>
  if(f->ref < 1)
    80004590:	40dc                	lw	a5,4(s1)
    80004592:	06f05163          	blez	a5,800045f4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004596:	37fd                	addiw	a5,a5,-1
    80004598:	0007871b          	sext.w	a4,a5
    8000459c:	c0dc                	sw	a5,4(s1)
    8000459e:	06e04363          	bgtz	a4,80004604 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800045a2:	0004a903          	lw	s2,0(s1)
    800045a6:	0094ca83          	lbu	s5,9(s1)
    800045aa:	0104ba03          	ld	s4,16(s1)
    800045ae:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800045b2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800045b6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800045ba:	0001d517          	auipc	a0,0x1d
    800045be:	69650513          	addi	a0,a0,1686 # 80021c50 <ftable>
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	6f6080e7          	jalr	1782(ra) # 80000cb8 <release>

  if(ff.type == FD_PIPE){
    800045ca:	4785                	li	a5,1
    800045cc:	04f90d63          	beq	s2,a5,80004626 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800045d0:	3979                	addiw	s2,s2,-2
    800045d2:	4785                	li	a5,1
    800045d4:	0527e063          	bltu	a5,s2,80004614 <fileclose+0xa8>
    begin_op();
    800045d8:	00000097          	auipc	ra,0x0
    800045dc:	ac2080e7          	jalr	-1342(ra) # 8000409a <begin_op>
    iput(ff.ip);
    800045e0:	854e                	mv	a0,s3
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	2b6080e7          	jalr	694(ra) # 80003898 <iput>
    end_op();
    800045ea:	00000097          	auipc	ra,0x0
    800045ee:	b30080e7          	jalr	-1232(ra) # 8000411a <end_op>
    800045f2:	a00d                	j	80004614 <fileclose+0xa8>
    panic("fileclose");
    800045f4:	00004517          	auipc	a0,0x4
    800045f8:	0dc50513          	addi	a0,a0,220 # 800086d0 <syscalls+0x250>
    800045fc:	ffffc097          	auipc	ra,0xffffc
    80004600:	f58080e7          	jalr	-168(ra) # 80000554 <panic>
    release(&ftable.lock);
    80004604:	0001d517          	auipc	a0,0x1d
    80004608:	64c50513          	addi	a0,a0,1612 # 80021c50 <ftable>
    8000460c:	ffffc097          	auipc	ra,0xffffc
    80004610:	6ac080e7          	jalr	1708(ra) # 80000cb8 <release>
  }
}
    80004614:	70e2                	ld	ra,56(sp)
    80004616:	7442                	ld	s0,48(sp)
    80004618:	74a2                	ld	s1,40(sp)
    8000461a:	7902                	ld	s2,32(sp)
    8000461c:	69e2                	ld	s3,24(sp)
    8000461e:	6a42                	ld	s4,16(sp)
    80004620:	6aa2                	ld	s5,8(sp)
    80004622:	6121                	addi	sp,sp,64
    80004624:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004626:	85d6                	mv	a1,s5
    80004628:	8552                	mv	a0,s4
    8000462a:	00000097          	auipc	ra,0x0
    8000462e:	372080e7          	jalr	882(ra) # 8000499c <pipeclose>
    80004632:	b7cd                	j	80004614 <fileclose+0xa8>

0000000080004634 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004634:	715d                	addi	sp,sp,-80
    80004636:	e486                	sd	ra,72(sp)
    80004638:	e0a2                	sd	s0,64(sp)
    8000463a:	fc26                	sd	s1,56(sp)
    8000463c:	f84a                	sd	s2,48(sp)
    8000463e:	f44e                	sd	s3,40(sp)
    80004640:	0880                	addi	s0,sp,80
    80004642:	84aa                	mv	s1,a0
    80004644:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004646:	ffffd097          	auipc	ra,0xffffd
    8000464a:	44c080e7          	jalr	1100(ra) # 80001a92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000464e:	409c                	lw	a5,0(s1)
    80004650:	37f9                	addiw	a5,a5,-2
    80004652:	4705                	li	a4,1
    80004654:	04f76763          	bltu	a4,a5,800046a2 <filestat+0x6e>
    80004658:	892a                	mv	s2,a0
    ilock(f->ip);
    8000465a:	6c88                	ld	a0,24(s1)
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	082080e7          	jalr	130(ra) # 800036de <ilock>
    stati(f->ip, &st);
    80004664:	fb840593          	addi	a1,s0,-72
    80004668:	6c88                	ld	a0,24(s1)
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	2fe080e7          	jalr	766(ra) # 80003968 <stati>
    iunlock(f->ip);
    80004672:	6c88                	ld	a0,24(s1)
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	12c080e7          	jalr	300(ra) # 800037a0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000467c:	46e1                	li	a3,24
    8000467e:	fb840613          	addi	a2,s0,-72
    80004682:	85ce                	mv	a1,s3
    80004684:	05093503          	ld	a0,80(s2)
    80004688:	ffffd097          	auipc	ra,0xffffd
    8000468c:	03e080e7          	jalr	62(ra) # 800016c6 <copyout>
    80004690:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004694:	60a6                	ld	ra,72(sp)
    80004696:	6406                	ld	s0,64(sp)
    80004698:	74e2                	ld	s1,56(sp)
    8000469a:	7942                	ld	s2,48(sp)
    8000469c:	79a2                	ld	s3,40(sp)
    8000469e:	6161                	addi	sp,sp,80
    800046a0:	8082                	ret
  return -1;
    800046a2:	557d                	li	a0,-1
    800046a4:	bfc5                	j	80004694 <filestat+0x60>

00000000800046a6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800046a6:	7179                	addi	sp,sp,-48
    800046a8:	f406                	sd	ra,40(sp)
    800046aa:	f022                	sd	s0,32(sp)
    800046ac:	ec26                	sd	s1,24(sp)
    800046ae:	e84a                	sd	s2,16(sp)
    800046b0:	e44e                	sd	s3,8(sp)
    800046b2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800046b4:	00854783          	lbu	a5,8(a0)
    800046b8:	c3d5                	beqz	a5,8000475c <fileread+0xb6>
    800046ba:	84aa                	mv	s1,a0
    800046bc:	89ae                	mv	s3,a1
    800046be:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800046c0:	411c                	lw	a5,0(a0)
    800046c2:	4705                	li	a4,1
    800046c4:	04e78963          	beq	a5,a4,80004716 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046c8:	470d                	li	a4,3
    800046ca:	04e78d63          	beq	a5,a4,80004724 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800046ce:	4709                	li	a4,2
    800046d0:	06e79e63          	bne	a5,a4,8000474c <fileread+0xa6>
    ilock(f->ip);
    800046d4:	6d08                	ld	a0,24(a0)
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	008080e7          	jalr	8(ra) # 800036de <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800046de:	874a                	mv	a4,s2
    800046e0:	5094                	lw	a3,32(s1)
    800046e2:	864e                	mv	a2,s3
    800046e4:	4585                	li	a1,1
    800046e6:	6c88                	ld	a0,24(s1)
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	2aa080e7          	jalr	682(ra) # 80003992 <readi>
    800046f0:	892a                	mv	s2,a0
    800046f2:	00a05563          	blez	a0,800046fc <fileread+0x56>
      f->off += r;
    800046f6:	509c                	lw	a5,32(s1)
    800046f8:	9fa9                	addw	a5,a5,a0
    800046fa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800046fc:	6c88                	ld	a0,24(s1)
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	0a2080e7          	jalr	162(ra) # 800037a0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004706:	854a                	mv	a0,s2
    80004708:	70a2                	ld	ra,40(sp)
    8000470a:	7402                	ld	s0,32(sp)
    8000470c:	64e2                	ld	s1,24(sp)
    8000470e:	6942                	ld	s2,16(sp)
    80004710:	69a2                	ld	s3,8(sp)
    80004712:	6145                	addi	sp,sp,48
    80004714:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004716:	6908                	ld	a0,16(a0)
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	418080e7          	jalr	1048(ra) # 80004b30 <piperead>
    80004720:	892a                	mv	s2,a0
    80004722:	b7d5                	j	80004706 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004724:	02451783          	lh	a5,36(a0)
    80004728:	03079693          	slli	a3,a5,0x30
    8000472c:	92c1                	srli	a3,a3,0x30
    8000472e:	4725                	li	a4,9
    80004730:	02d76863          	bltu	a4,a3,80004760 <fileread+0xba>
    80004734:	0792                	slli	a5,a5,0x4
    80004736:	0001d717          	auipc	a4,0x1d
    8000473a:	47a70713          	addi	a4,a4,1146 # 80021bb0 <devsw>
    8000473e:	97ba                	add	a5,a5,a4
    80004740:	639c                	ld	a5,0(a5)
    80004742:	c38d                	beqz	a5,80004764 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004744:	4505                	li	a0,1
    80004746:	9782                	jalr	a5
    80004748:	892a                	mv	s2,a0
    8000474a:	bf75                	j	80004706 <fileread+0x60>
    panic("fileread");
    8000474c:	00004517          	auipc	a0,0x4
    80004750:	f9450513          	addi	a0,a0,-108 # 800086e0 <syscalls+0x260>
    80004754:	ffffc097          	auipc	ra,0xffffc
    80004758:	e00080e7          	jalr	-512(ra) # 80000554 <panic>
    return -1;
    8000475c:	597d                	li	s2,-1
    8000475e:	b765                	j	80004706 <fileread+0x60>
      return -1;
    80004760:	597d                	li	s2,-1
    80004762:	b755                	j	80004706 <fileread+0x60>
    80004764:	597d                	li	s2,-1
    80004766:	b745                	j	80004706 <fileread+0x60>

0000000080004768 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004768:	00954783          	lbu	a5,9(a0)
    8000476c:	14078563          	beqz	a5,800048b6 <filewrite+0x14e>
{
    80004770:	715d                	addi	sp,sp,-80
    80004772:	e486                	sd	ra,72(sp)
    80004774:	e0a2                	sd	s0,64(sp)
    80004776:	fc26                	sd	s1,56(sp)
    80004778:	f84a                	sd	s2,48(sp)
    8000477a:	f44e                	sd	s3,40(sp)
    8000477c:	f052                	sd	s4,32(sp)
    8000477e:	ec56                	sd	s5,24(sp)
    80004780:	e85a                	sd	s6,16(sp)
    80004782:	e45e                	sd	s7,8(sp)
    80004784:	e062                	sd	s8,0(sp)
    80004786:	0880                	addi	s0,sp,80
    80004788:	892a                	mv	s2,a0
    8000478a:	8aae                	mv	s5,a1
    8000478c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000478e:	411c                	lw	a5,0(a0)
    80004790:	4705                	li	a4,1
    80004792:	02e78263          	beq	a5,a4,800047b6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004796:	470d                	li	a4,3
    80004798:	02e78563          	beq	a5,a4,800047c2 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000479c:	4709                	li	a4,2
    8000479e:	10e79463          	bne	a5,a4,800048a6 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800047a2:	0ec05e63          	blez	a2,8000489e <filewrite+0x136>
    int i = 0;
    800047a6:	4981                	li	s3,0
    800047a8:	6b05                	lui	s6,0x1
    800047aa:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800047ae:	6b85                	lui	s7,0x1
    800047b0:	c00b8b9b          	addiw	s7,s7,-1024
    800047b4:	a851                	j	80004848 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800047b6:	6908                	ld	a0,16(a0)
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	254080e7          	jalr	596(ra) # 80004a0c <pipewrite>
    800047c0:	a85d                	j	80004876 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800047c2:	02451783          	lh	a5,36(a0)
    800047c6:	03079693          	slli	a3,a5,0x30
    800047ca:	92c1                	srli	a3,a3,0x30
    800047cc:	4725                	li	a4,9
    800047ce:	0ed76663          	bltu	a4,a3,800048ba <filewrite+0x152>
    800047d2:	0792                	slli	a5,a5,0x4
    800047d4:	0001d717          	auipc	a4,0x1d
    800047d8:	3dc70713          	addi	a4,a4,988 # 80021bb0 <devsw>
    800047dc:	97ba                	add	a5,a5,a4
    800047de:	679c                	ld	a5,8(a5)
    800047e0:	cff9                	beqz	a5,800048be <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    800047e2:	4505                	li	a0,1
    800047e4:	9782                	jalr	a5
    800047e6:	a841                	j	80004876 <filewrite+0x10e>
    800047e8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	8ae080e7          	jalr	-1874(ra) # 8000409a <begin_op>
      ilock(f->ip);
    800047f4:	01893503          	ld	a0,24(s2)
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	ee6080e7          	jalr	-282(ra) # 800036de <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004800:	8762                	mv	a4,s8
    80004802:	02092683          	lw	a3,32(s2)
    80004806:	01598633          	add	a2,s3,s5
    8000480a:	4585                	li	a1,1
    8000480c:	01893503          	ld	a0,24(s2)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	278080e7          	jalr	632(ra) # 80003a88 <writei>
    80004818:	84aa                	mv	s1,a0
    8000481a:	02a05f63          	blez	a0,80004858 <filewrite+0xf0>
        f->off += r;
    8000481e:	02092783          	lw	a5,32(s2)
    80004822:	9fa9                	addw	a5,a5,a0
    80004824:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004828:	01893503          	ld	a0,24(s2)
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	f74080e7          	jalr	-140(ra) # 800037a0 <iunlock>
      end_op();
    80004834:	00000097          	auipc	ra,0x0
    80004838:	8e6080e7          	jalr	-1818(ra) # 8000411a <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000483c:	049c1963          	bne	s8,s1,8000488e <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004840:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004844:	0349d663          	bge	s3,s4,80004870 <filewrite+0x108>
      int n1 = n - i;
    80004848:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000484c:	84be                	mv	s1,a5
    8000484e:	2781                	sext.w	a5,a5
    80004850:	f8fb5ce3          	bge	s6,a5,800047e8 <filewrite+0x80>
    80004854:	84de                	mv	s1,s7
    80004856:	bf49                	j	800047e8 <filewrite+0x80>
      iunlock(f->ip);
    80004858:	01893503          	ld	a0,24(s2)
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	f44080e7          	jalr	-188(ra) # 800037a0 <iunlock>
      end_op();
    80004864:	00000097          	auipc	ra,0x0
    80004868:	8b6080e7          	jalr	-1866(ra) # 8000411a <end_op>
      if(r < 0)
    8000486c:	fc04d8e3          	bgez	s1,8000483c <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004870:	8552                	mv	a0,s4
    80004872:	033a1863          	bne	s4,s3,800048a2 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004876:	60a6                	ld	ra,72(sp)
    80004878:	6406                	ld	s0,64(sp)
    8000487a:	74e2                	ld	s1,56(sp)
    8000487c:	7942                	ld	s2,48(sp)
    8000487e:	79a2                	ld	s3,40(sp)
    80004880:	7a02                	ld	s4,32(sp)
    80004882:	6ae2                	ld	s5,24(sp)
    80004884:	6b42                	ld	s6,16(sp)
    80004886:	6ba2                	ld	s7,8(sp)
    80004888:	6c02                	ld	s8,0(sp)
    8000488a:	6161                	addi	sp,sp,80
    8000488c:	8082                	ret
        panic("short filewrite");
    8000488e:	00004517          	auipc	a0,0x4
    80004892:	e6250513          	addi	a0,a0,-414 # 800086f0 <syscalls+0x270>
    80004896:	ffffc097          	auipc	ra,0xffffc
    8000489a:	cbe080e7          	jalr	-834(ra) # 80000554 <panic>
    int i = 0;
    8000489e:	4981                	li	s3,0
    800048a0:	bfc1                	j	80004870 <filewrite+0x108>
    ret = (i == n ? n : -1);
    800048a2:	557d                	li	a0,-1
    800048a4:	bfc9                	j	80004876 <filewrite+0x10e>
    panic("filewrite");
    800048a6:	00004517          	auipc	a0,0x4
    800048aa:	e5a50513          	addi	a0,a0,-422 # 80008700 <syscalls+0x280>
    800048ae:	ffffc097          	auipc	ra,0xffffc
    800048b2:	ca6080e7          	jalr	-858(ra) # 80000554 <panic>
    return -1;
    800048b6:	557d                	li	a0,-1
}
    800048b8:	8082                	ret
      return -1;
    800048ba:	557d                	li	a0,-1
    800048bc:	bf6d                	j	80004876 <filewrite+0x10e>
    800048be:	557d                	li	a0,-1
    800048c0:	bf5d                	j	80004876 <filewrite+0x10e>

00000000800048c2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800048c2:	7179                	addi	sp,sp,-48
    800048c4:	f406                	sd	ra,40(sp)
    800048c6:	f022                	sd	s0,32(sp)
    800048c8:	ec26                	sd	s1,24(sp)
    800048ca:	e84a                	sd	s2,16(sp)
    800048cc:	e44e                	sd	s3,8(sp)
    800048ce:	e052                	sd	s4,0(sp)
    800048d0:	1800                	addi	s0,sp,48
    800048d2:	84aa                	mv	s1,a0
    800048d4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800048d6:	0005b023          	sd	zero,0(a1)
    800048da:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800048de:	00000097          	auipc	ra,0x0
    800048e2:	bd2080e7          	jalr	-1070(ra) # 800044b0 <filealloc>
    800048e6:	e088                	sd	a0,0(s1)
    800048e8:	c551                	beqz	a0,80004974 <pipealloc+0xb2>
    800048ea:	00000097          	auipc	ra,0x0
    800048ee:	bc6080e7          	jalr	-1082(ra) # 800044b0 <filealloc>
    800048f2:	00aa3023          	sd	a0,0(s4)
    800048f6:	c92d                	beqz	a0,80004968 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	21c080e7          	jalr	540(ra) # 80000b14 <kalloc>
    80004900:	892a                	mv	s2,a0
    80004902:	c125                	beqz	a0,80004962 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004904:	4985                	li	s3,1
    80004906:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000490a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000490e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004912:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004916:	00004597          	auipc	a1,0x4
    8000491a:	dfa58593          	addi	a1,a1,-518 # 80008710 <syscalls+0x290>
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	256080e7          	jalr	598(ra) # 80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    80004926:	609c                	ld	a5,0(s1)
    80004928:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000492c:	609c                	ld	a5,0(s1)
    8000492e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004932:	609c                	ld	a5,0(s1)
    80004934:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004938:	609c                	ld	a5,0(s1)
    8000493a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000493e:	000a3783          	ld	a5,0(s4)
    80004942:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004946:	000a3783          	ld	a5,0(s4)
    8000494a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000494e:	000a3783          	ld	a5,0(s4)
    80004952:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004956:	000a3783          	ld	a5,0(s4)
    8000495a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000495e:	4501                	li	a0,0
    80004960:	a025                	j	80004988 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004962:	6088                	ld	a0,0(s1)
    80004964:	e501                	bnez	a0,8000496c <pipealloc+0xaa>
    80004966:	a039                	j	80004974 <pipealloc+0xb2>
    80004968:	6088                	ld	a0,0(s1)
    8000496a:	c51d                	beqz	a0,80004998 <pipealloc+0xd6>
    fileclose(*f0);
    8000496c:	00000097          	auipc	ra,0x0
    80004970:	c00080e7          	jalr	-1024(ra) # 8000456c <fileclose>
  if(*f1)
    80004974:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004978:	557d                	li	a0,-1
  if(*f1)
    8000497a:	c799                	beqz	a5,80004988 <pipealloc+0xc6>
    fileclose(*f1);
    8000497c:	853e                	mv	a0,a5
    8000497e:	00000097          	auipc	ra,0x0
    80004982:	bee080e7          	jalr	-1042(ra) # 8000456c <fileclose>
  return -1;
    80004986:	557d                	li	a0,-1
}
    80004988:	70a2                	ld	ra,40(sp)
    8000498a:	7402                	ld	s0,32(sp)
    8000498c:	64e2                	ld	s1,24(sp)
    8000498e:	6942                	ld	s2,16(sp)
    80004990:	69a2                	ld	s3,8(sp)
    80004992:	6a02                	ld	s4,0(sp)
    80004994:	6145                	addi	sp,sp,48
    80004996:	8082                	ret
  return -1;
    80004998:	557d                	li	a0,-1
    8000499a:	b7fd                	j	80004988 <pipealloc+0xc6>

000000008000499c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000499c:	1101                	addi	sp,sp,-32
    8000499e:	ec06                	sd	ra,24(sp)
    800049a0:	e822                	sd	s0,16(sp)
    800049a2:	e426                	sd	s1,8(sp)
    800049a4:	e04a                	sd	s2,0(sp)
    800049a6:	1000                	addi	s0,sp,32
    800049a8:	84aa                	mv	s1,a0
    800049aa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049ac:	ffffc097          	auipc	ra,0xffffc
    800049b0:	258080e7          	jalr	600(ra) # 80000c04 <acquire>
  if(writable){
    800049b4:	02090d63          	beqz	s2,800049ee <pipeclose+0x52>
    pi->writeopen = 0;
    800049b8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800049bc:	21848513          	addi	a0,s1,536
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	a40080e7          	jalr	-1472(ra) # 80002400 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800049c8:	2204b783          	ld	a5,544(s1)
    800049cc:	eb95                	bnez	a5,80004a00 <pipeclose+0x64>
    release(&pi->lock);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffc097          	auipc	ra,0xffffc
    800049d4:	2e8080e7          	jalr	744(ra) # 80000cb8 <release>
    kfree((char*)pi);
    800049d8:	8526                	mv	a0,s1
    800049da:	ffffc097          	auipc	ra,0xffffc
    800049de:	03e080e7          	jalr	62(ra) # 80000a18 <kfree>
  } else
    release(&pi->lock);
}
    800049e2:	60e2                	ld	ra,24(sp)
    800049e4:	6442                	ld	s0,16(sp)
    800049e6:	64a2                	ld	s1,8(sp)
    800049e8:	6902                	ld	s2,0(sp)
    800049ea:	6105                	addi	sp,sp,32
    800049ec:	8082                	ret
    pi->readopen = 0;
    800049ee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800049f2:	21c48513          	addi	a0,s1,540
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	a0a080e7          	jalr	-1526(ra) # 80002400 <wakeup>
    800049fe:	b7e9                	j	800049c8 <pipeclose+0x2c>
    release(&pi->lock);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffc097          	auipc	ra,0xffffc
    80004a06:	2b6080e7          	jalr	694(ra) # 80000cb8 <release>
}
    80004a0a:	bfe1                	j	800049e2 <pipeclose+0x46>

0000000080004a0c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a0c:	7119                	addi	sp,sp,-128
    80004a0e:	fc86                	sd	ra,120(sp)
    80004a10:	f8a2                	sd	s0,112(sp)
    80004a12:	f4a6                	sd	s1,104(sp)
    80004a14:	f0ca                	sd	s2,96(sp)
    80004a16:	ecce                	sd	s3,88(sp)
    80004a18:	e8d2                	sd	s4,80(sp)
    80004a1a:	e4d6                	sd	s5,72(sp)
    80004a1c:	e0da                	sd	s6,64(sp)
    80004a1e:	fc5e                	sd	s7,56(sp)
    80004a20:	f862                	sd	s8,48(sp)
    80004a22:	f466                	sd	s9,40(sp)
    80004a24:	f06a                	sd	s10,32(sp)
    80004a26:	ec6e                	sd	s11,24(sp)
    80004a28:	0100                	addi	s0,sp,128
    80004a2a:	84aa                	mv	s1,a0
    80004a2c:	8cae                	mv	s9,a1
    80004a2e:	8b32                	mv	s6,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004a30:	ffffd097          	auipc	ra,0xffffd
    80004a34:	062080e7          	jalr	98(ra) # 80001a92 <myproc>
    80004a38:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffc097          	auipc	ra,0xffffc
    80004a40:	1c8080e7          	jalr	456(ra) # 80000c04 <acquire>
  for(i = 0; i < n; i++){
    80004a44:	0d605963          	blez	s6,80004b16 <pipewrite+0x10a>
    80004a48:	89a6                	mv	s3,s1
    80004a4a:	3b7d                	addiw	s6,s6,-1
    80004a4c:	1b02                	slli	s6,s6,0x20
    80004a4e:	020b5b13          	srli	s6,s6,0x20
    80004a52:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004a54:	21848a93          	addi	s5,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a58:	21c48a13          	addi	s4,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a5c:	5dfd                	li	s11,-1
    80004a5e:	000b8d1b          	sext.w	s10,s7
    80004a62:	8c6a                	mv	s8,s10
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a64:	2184a783          	lw	a5,536(s1)
    80004a68:	21c4a703          	lw	a4,540(s1)
    80004a6c:	2007879b          	addiw	a5,a5,512
    80004a70:	02f71b63          	bne	a4,a5,80004aa6 <pipewrite+0x9a>
      if(pi->readopen == 0 || pr->killed){
    80004a74:	2204a783          	lw	a5,544(s1)
    80004a78:	cbad                	beqz	a5,80004aea <pipewrite+0xde>
    80004a7a:	03092783          	lw	a5,48(s2)
    80004a7e:	e7b5                	bnez	a5,80004aea <pipewrite+0xde>
      wakeup(&pi->nread);
    80004a80:	8556                	mv	a0,s5
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	97e080e7          	jalr	-1666(ra) # 80002400 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004a8a:	85ce                	mv	a1,s3
    80004a8c:	8552                	mv	a0,s4
    80004a8e:	ffffd097          	auipc	ra,0xffffd
    80004a92:	7ec080e7          	jalr	2028(ra) # 8000227a <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a96:	2184a783          	lw	a5,536(s1)
    80004a9a:	21c4a703          	lw	a4,540(s1)
    80004a9e:	2007879b          	addiw	a5,a5,512
    80004aa2:	fcf709e3          	beq	a4,a5,80004a74 <pipewrite+0x68>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004aa6:	4685                	li	a3,1
    80004aa8:	019b8633          	add	a2,s7,s9
    80004aac:	f8f40593          	addi	a1,s0,-113
    80004ab0:	05093503          	ld	a0,80(s2)
    80004ab4:	ffffd097          	auipc	ra,0xffffd
    80004ab8:	c9e080e7          	jalr	-866(ra) # 80001752 <copyin>
    80004abc:	05b50e63          	beq	a0,s11,80004b18 <pipewrite+0x10c>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ac0:	21c4a783          	lw	a5,540(s1)
    80004ac4:	0017871b          	addiw	a4,a5,1
    80004ac8:	20e4ae23          	sw	a4,540(s1)
    80004acc:	1ff7f793          	andi	a5,a5,511
    80004ad0:	97a6                	add	a5,a5,s1
    80004ad2:	f8f44703          	lbu	a4,-113(s0)
    80004ad6:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004ada:	001d0c1b          	addiw	s8,s10,1
    80004ade:	001b8793          	addi	a5,s7,1 # 1001 <_entry-0x7fffefff>
    80004ae2:	036b8b63          	beq	s7,s6,80004b18 <pipewrite+0x10c>
    80004ae6:	8bbe                	mv	s7,a5
    80004ae8:	bf9d                	j	80004a5e <pipewrite+0x52>
        release(&pi->lock);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffc097          	auipc	ra,0xffffc
    80004af0:	1cc080e7          	jalr	460(ra) # 80000cb8 <release>
        return -1;
    80004af4:	5c7d                	li	s8,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return i;
}
    80004af6:	8562                	mv	a0,s8
    80004af8:	70e6                	ld	ra,120(sp)
    80004afa:	7446                	ld	s0,112(sp)
    80004afc:	74a6                	ld	s1,104(sp)
    80004afe:	7906                	ld	s2,96(sp)
    80004b00:	69e6                	ld	s3,88(sp)
    80004b02:	6a46                	ld	s4,80(sp)
    80004b04:	6aa6                	ld	s5,72(sp)
    80004b06:	6b06                	ld	s6,64(sp)
    80004b08:	7be2                	ld	s7,56(sp)
    80004b0a:	7c42                	ld	s8,48(sp)
    80004b0c:	7ca2                	ld	s9,40(sp)
    80004b0e:	7d02                	ld	s10,32(sp)
    80004b10:	6de2                	ld	s11,24(sp)
    80004b12:	6109                	addi	sp,sp,128
    80004b14:	8082                	ret
  for(i = 0; i < n; i++){
    80004b16:	4c01                	li	s8,0
  wakeup(&pi->nread);
    80004b18:	21848513          	addi	a0,s1,536
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	8e4080e7          	jalr	-1820(ra) # 80002400 <wakeup>
  release(&pi->lock);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffc097          	auipc	ra,0xffffc
    80004b2a:	192080e7          	jalr	402(ra) # 80000cb8 <release>
  return i;
    80004b2e:	b7e1                	j	80004af6 <pipewrite+0xea>

0000000080004b30 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b30:	715d                	addi	sp,sp,-80
    80004b32:	e486                	sd	ra,72(sp)
    80004b34:	e0a2                	sd	s0,64(sp)
    80004b36:	fc26                	sd	s1,56(sp)
    80004b38:	f84a                	sd	s2,48(sp)
    80004b3a:	f44e                	sd	s3,40(sp)
    80004b3c:	f052                	sd	s4,32(sp)
    80004b3e:	ec56                	sd	s5,24(sp)
    80004b40:	e85a                	sd	s6,16(sp)
    80004b42:	0880                	addi	s0,sp,80
    80004b44:	84aa                	mv	s1,a0
    80004b46:	892e                	mv	s2,a1
    80004b48:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b4a:	ffffd097          	auipc	ra,0xffffd
    80004b4e:	f48080e7          	jalr	-184(ra) # 80001a92 <myproc>
    80004b52:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b54:	8b26                	mv	s6,s1
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	0ac080e7          	jalr	172(ra) # 80000c04 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b60:	2184a703          	lw	a4,536(s1)
    80004b64:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b68:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b6c:	02f71463          	bne	a4,a5,80004b94 <piperead+0x64>
    80004b70:	2244a783          	lw	a5,548(s1)
    80004b74:	c385                	beqz	a5,80004b94 <piperead+0x64>
    if(pr->killed){
    80004b76:	030a2783          	lw	a5,48(s4)
    80004b7a:	ebc1                	bnez	a5,80004c0a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b7c:	85da                	mv	a1,s6
    80004b7e:	854e                	mv	a0,s3
    80004b80:	ffffd097          	auipc	ra,0xffffd
    80004b84:	6fa080e7          	jalr	1786(ra) # 8000227a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b88:	2184a703          	lw	a4,536(s1)
    80004b8c:	21c4a783          	lw	a5,540(s1)
    80004b90:	fef700e3          	beq	a4,a5,80004b70 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b94:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b96:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b98:	05505363          	blez	s5,80004bde <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004b9c:	2184a783          	lw	a5,536(s1)
    80004ba0:	21c4a703          	lw	a4,540(s1)
    80004ba4:	02f70d63          	beq	a4,a5,80004bde <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ba8:	0017871b          	addiw	a4,a5,1
    80004bac:	20e4ac23          	sw	a4,536(s1)
    80004bb0:	1ff7f793          	andi	a5,a5,511
    80004bb4:	97a6                	add	a5,a5,s1
    80004bb6:	0187c783          	lbu	a5,24(a5)
    80004bba:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bbe:	4685                	li	a3,1
    80004bc0:	fbf40613          	addi	a2,s0,-65
    80004bc4:	85ca                	mv	a1,s2
    80004bc6:	050a3503          	ld	a0,80(s4)
    80004bca:	ffffd097          	auipc	ra,0xffffd
    80004bce:	afc080e7          	jalr	-1284(ra) # 800016c6 <copyout>
    80004bd2:	01650663          	beq	a0,s6,80004bde <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bd6:	2985                	addiw	s3,s3,1
    80004bd8:	0905                	addi	s2,s2,1
    80004bda:	fd3a91e3          	bne	s5,s3,80004b9c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004bde:	21c48513          	addi	a0,s1,540
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	81e080e7          	jalr	-2018(ra) # 80002400 <wakeup>
  release(&pi->lock);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffc097          	auipc	ra,0xffffc
    80004bf0:	0cc080e7          	jalr	204(ra) # 80000cb8 <release>
  return i;
}
    80004bf4:	854e                	mv	a0,s3
    80004bf6:	60a6                	ld	ra,72(sp)
    80004bf8:	6406                	ld	s0,64(sp)
    80004bfa:	74e2                	ld	s1,56(sp)
    80004bfc:	7942                	ld	s2,48(sp)
    80004bfe:	79a2                	ld	s3,40(sp)
    80004c00:	7a02                	ld	s4,32(sp)
    80004c02:	6ae2                	ld	s5,24(sp)
    80004c04:	6b42                	ld	s6,16(sp)
    80004c06:	6161                	addi	sp,sp,80
    80004c08:	8082                	ret
      release(&pi->lock);
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffc097          	auipc	ra,0xffffc
    80004c10:	0ac080e7          	jalr	172(ra) # 80000cb8 <release>
      return -1;
    80004c14:	59fd                	li	s3,-1
    80004c16:	bff9                	j	80004bf4 <piperead+0xc4>

0000000080004c18 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c18:	df010113          	addi	sp,sp,-528
    80004c1c:	20113423          	sd	ra,520(sp)
    80004c20:	20813023          	sd	s0,512(sp)
    80004c24:	ffa6                	sd	s1,504(sp)
    80004c26:	fbca                	sd	s2,496(sp)
    80004c28:	f7ce                	sd	s3,488(sp)
    80004c2a:	f3d2                	sd	s4,480(sp)
    80004c2c:	efd6                	sd	s5,472(sp)
    80004c2e:	ebda                	sd	s6,464(sp)
    80004c30:	e7de                	sd	s7,456(sp)
    80004c32:	e3e2                	sd	s8,448(sp)
    80004c34:	ff66                	sd	s9,440(sp)
    80004c36:	fb6a                	sd	s10,432(sp)
    80004c38:	f76e                	sd	s11,424(sp)
    80004c3a:	0c00                	addi	s0,sp,528
    80004c3c:	84aa                	mv	s1,a0
    80004c3e:	dea43c23          	sd	a0,-520(s0)
    80004c42:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c46:	ffffd097          	auipc	ra,0xffffd
    80004c4a:	e4c080e7          	jalr	-436(ra) # 80001a92 <myproc>
    80004c4e:	892a                	mv	s2,a0

  begin_op();
    80004c50:	fffff097          	auipc	ra,0xfffff
    80004c54:	44a080e7          	jalr	1098(ra) # 8000409a <begin_op>

  if((ip = namei(path)) == 0){
    80004c58:	8526                	mv	a0,s1
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	234080e7          	jalr	564(ra) # 80003e8e <namei>
    80004c62:	c92d                	beqz	a0,80004cd4 <exec+0xbc>
    80004c64:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	a78080e7          	jalr	-1416(ra) # 800036de <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c6e:	04000713          	li	a4,64
    80004c72:	4681                	li	a3,0
    80004c74:	e4840613          	addi	a2,s0,-440
    80004c78:	4581                	li	a1,0
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	d16080e7          	jalr	-746(ra) # 80003992 <readi>
    80004c84:	04000793          	li	a5,64
    80004c88:	00f51a63          	bne	a0,a5,80004c9c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c8c:	e4842703          	lw	a4,-440(s0)
    80004c90:	464c47b7          	lui	a5,0x464c4
    80004c94:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c98:	04f70463          	beq	a4,a5,80004ce0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	ca2080e7          	jalr	-862(ra) # 80003940 <iunlockput>
    end_op();
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	474080e7          	jalr	1140(ra) # 8000411a <end_op>
  }
  return -1;
    80004cae:	557d                	li	a0,-1
}
    80004cb0:	20813083          	ld	ra,520(sp)
    80004cb4:	20013403          	ld	s0,512(sp)
    80004cb8:	74fe                	ld	s1,504(sp)
    80004cba:	795e                	ld	s2,496(sp)
    80004cbc:	79be                	ld	s3,488(sp)
    80004cbe:	7a1e                	ld	s4,480(sp)
    80004cc0:	6afe                	ld	s5,472(sp)
    80004cc2:	6b5e                	ld	s6,464(sp)
    80004cc4:	6bbe                	ld	s7,456(sp)
    80004cc6:	6c1e                	ld	s8,448(sp)
    80004cc8:	7cfa                	ld	s9,440(sp)
    80004cca:	7d5a                	ld	s10,432(sp)
    80004ccc:	7dba                	ld	s11,424(sp)
    80004cce:	21010113          	addi	sp,sp,528
    80004cd2:	8082                	ret
    end_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	446080e7          	jalr	1094(ra) # 8000411a <end_op>
    return -1;
    80004cdc:	557d                	li	a0,-1
    80004cde:	bfc9                	j	80004cb0 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004ce0:	854a                	mv	a0,s2
    80004ce2:	ffffd097          	auipc	ra,0xffffd
    80004ce6:	e74080e7          	jalr	-396(ra) # 80001b56 <proc_pagetable>
    80004cea:	8baa                	mv	s7,a0
    80004cec:	d945                	beqz	a0,80004c9c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cee:	e6842983          	lw	s3,-408(s0)
    80004cf2:	e8045783          	lhu	a5,-384(s0)
    80004cf6:	c7ad                	beqz	a5,80004d60 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004cf8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cfa:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004cfc:	6c85                	lui	s9,0x1
    80004cfe:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004d02:	def43823          	sd	a5,-528(s0)
    80004d06:	a42d                	j	80004f30 <exec+0x318>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d08:	00004517          	auipc	a0,0x4
    80004d0c:	a1050513          	addi	a0,a0,-1520 # 80008718 <syscalls+0x298>
    80004d10:	ffffc097          	auipc	ra,0xffffc
    80004d14:	844080e7          	jalr	-1980(ra) # 80000554 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d18:	8756                	mv	a4,s5
    80004d1a:	012d86bb          	addw	a3,s11,s2
    80004d1e:	4581                	li	a1,0
    80004d20:	8526                	mv	a0,s1
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	c70080e7          	jalr	-912(ra) # 80003992 <readi>
    80004d2a:	2501                	sext.w	a0,a0
    80004d2c:	1aaa9963          	bne	s5,a0,80004ede <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004d30:	6785                	lui	a5,0x1
    80004d32:	0127893b          	addw	s2,a5,s2
    80004d36:	77fd                	lui	a5,0xfffff
    80004d38:	01478a3b          	addw	s4,a5,s4
    80004d3c:	1f897163          	bgeu	s2,s8,80004f1e <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004d40:	02091593          	slli	a1,s2,0x20
    80004d44:	9181                	srli	a1,a1,0x20
    80004d46:	95ea                	add	a1,a1,s10
    80004d48:	855e                	mv	a0,s7
    80004d4a:	ffffc097          	auipc	ra,0xffffc
    80004d4e:	348080e7          	jalr	840(ra) # 80001092 <walkaddr>
    80004d52:	862a                	mv	a2,a0
    if(pa == 0)
    80004d54:	d955                	beqz	a0,80004d08 <exec+0xf0>
      n = PGSIZE;
    80004d56:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004d58:	fd9a70e3          	bgeu	s4,s9,80004d18 <exec+0x100>
      n = sz - i;
    80004d5c:	8ad2                	mv	s5,s4
    80004d5e:	bf6d                	j	80004d18 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d60:	4901                	li	s2,0
  iunlockput(ip);
    80004d62:	8526                	mv	a0,s1
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	bdc080e7          	jalr	-1060(ra) # 80003940 <iunlockput>
  end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	3ae080e7          	jalr	942(ra) # 8000411a <end_op>
  p = myproc();
    80004d74:	ffffd097          	auipc	ra,0xffffd
    80004d78:	d1e080e7          	jalr	-738(ra) # 80001a92 <myproc>
    80004d7c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004d7e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004d82:	6785                	lui	a5,0x1
    80004d84:	17fd                	addi	a5,a5,-1
    80004d86:	993e                	add	s2,s2,a5
    80004d88:	757d                	lui	a0,0xfffff
    80004d8a:	00a977b3          	and	a5,s2,a0
    80004d8e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004d92:	6609                	lui	a2,0x2
    80004d94:	963e                	add	a2,a2,a5
    80004d96:	85be                	mv	a1,a5
    80004d98:	855e                	mv	a0,s7
    80004d9a:	ffffc097          	auipc	ra,0xffffc
    80004d9e:	6dc080e7          	jalr	1756(ra) # 80001476 <uvmalloc>
    80004da2:	8b2a                	mv	s6,a0
  ip = 0;
    80004da4:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004da6:	12050c63          	beqz	a0,80004ede <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004daa:	75f9                	lui	a1,0xffffe
    80004dac:	95aa                	add	a1,a1,a0
    80004dae:	855e                	mv	a0,s7
    80004db0:	ffffd097          	auipc	ra,0xffffd
    80004db4:	8e4080e7          	jalr	-1820(ra) # 80001694 <uvmclear>
  stackbase = sp - PGSIZE;
    80004db8:	7c7d                	lui	s8,0xfffff
    80004dba:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004dbc:	e0043783          	ld	a5,-512(s0)
    80004dc0:	6388                	ld	a0,0(a5)
    80004dc2:	c535                	beqz	a0,80004e2e <exec+0x216>
    80004dc4:	e8840993          	addi	s3,s0,-376
    80004dc8:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004dcc:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004dce:	ffffc097          	auipc	ra,0xffffc
    80004dd2:	0ba080e7          	jalr	186(ra) # 80000e88 <strlen>
    80004dd6:	2505                	addiw	a0,a0,1
    80004dd8:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ddc:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004de0:	13896363          	bltu	s2,s8,80004f06 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004de4:	e0043d83          	ld	s11,-512(s0)
    80004de8:	000dba03          	ld	s4,0(s11)
    80004dec:	8552                	mv	a0,s4
    80004dee:	ffffc097          	auipc	ra,0xffffc
    80004df2:	09a080e7          	jalr	154(ra) # 80000e88 <strlen>
    80004df6:	0015069b          	addiw	a3,a0,1
    80004dfa:	8652                	mv	a2,s4
    80004dfc:	85ca                	mv	a1,s2
    80004dfe:	855e                	mv	a0,s7
    80004e00:	ffffd097          	auipc	ra,0xffffd
    80004e04:	8c6080e7          	jalr	-1850(ra) # 800016c6 <copyout>
    80004e08:	10054363          	bltz	a0,80004f0e <exec+0x2f6>
    ustack[argc] = sp;
    80004e0c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e10:	0485                	addi	s1,s1,1
    80004e12:	008d8793          	addi	a5,s11,8
    80004e16:	e0f43023          	sd	a5,-512(s0)
    80004e1a:	008db503          	ld	a0,8(s11)
    80004e1e:	c911                	beqz	a0,80004e32 <exec+0x21a>
    if(argc >= MAXARG)
    80004e20:	09a1                	addi	s3,s3,8
    80004e22:	fb3c96e3          	bne	s9,s3,80004dce <exec+0x1b6>
  sz = sz1;
    80004e26:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004e2a:	4481                	li	s1,0
    80004e2c:	a84d                	j	80004ede <exec+0x2c6>
  sp = sz;
    80004e2e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004e30:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e32:	00349793          	slli	a5,s1,0x3
    80004e36:	f9040713          	addi	a4,s0,-112
    80004e3a:	97ba                	add	a5,a5,a4
    80004e3c:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80004e40:	00148693          	addi	a3,s1,1
    80004e44:	068e                	slli	a3,a3,0x3
    80004e46:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e4a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004e4e:	01897663          	bgeu	s2,s8,80004e5a <exec+0x242>
  sz = sz1;
    80004e52:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004e56:	4481                	li	s1,0
    80004e58:	a059                	j	80004ede <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e5a:	e8840613          	addi	a2,s0,-376
    80004e5e:	85ca                	mv	a1,s2
    80004e60:	855e                	mv	a0,s7
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	864080e7          	jalr	-1948(ra) # 800016c6 <copyout>
    80004e6a:	0a054663          	bltz	a0,80004f16 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004e6e:	058ab783          	ld	a5,88(s5)
    80004e72:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004e76:	df843783          	ld	a5,-520(s0)
    80004e7a:	0007c703          	lbu	a4,0(a5)
    80004e7e:	cf11                	beqz	a4,80004e9a <exec+0x282>
    80004e80:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004e82:	02f00693          	li	a3,47
    80004e86:	a029                	j	80004e90 <exec+0x278>
  for(last=s=path; *s; s++)
    80004e88:	0785                	addi	a5,a5,1
    80004e8a:	fff7c703          	lbu	a4,-1(a5)
    80004e8e:	c711                	beqz	a4,80004e9a <exec+0x282>
    if(*s == '/')
    80004e90:	fed71ce3          	bne	a4,a3,80004e88 <exec+0x270>
      last = s+1;
    80004e94:	def43c23          	sd	a5,-520(s0)
    80004e98:	bfc5                	j	80004e88 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e9a:	4641                	li	a2,16
    80004e9c:	df843583          	ld	a1,-520(s0)
    80004ea0:	160a8513          	addi	a0,s5,352
    80004ea4:	ffffc097          	auipc	ra,0xffffc
    80004ea8:	fb2080e7          	jalr	-78(ra) # 80000e56 <safestrcpy>
  oldpagetable = p->pagetable;
    80004eac:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004eb0:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004eb4:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004eb8:	058ab783          	ld	a5,88(s5)
    80004ebc:	e6043703          	ld	a4,-416(s0)
    80004ec0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004ec2:	058ab783          	ld	a5,88(s5)
    80004ec6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004eca:	85ea                	mv	a1,s10
    80004ecc:	ffffd097          	auipc	ra,0xffffd
    80004ed0:	d06080e7          	jalr	-762(ra) # 80001bd2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004ed4:	0004851b          	sext.w	a0,s1
    80004ed8:	bbe1                	j	80004cb0 <exec+0x98>
    80004eda:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004ede:	e0843583          	ld	a1,-504(s0)
    80004ee2:	855e                	mv	a0,s7
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	cee080e7          	jalr	-786(ra) # 80001bd2 <proc_freepagetable>
  if(ip){
    80004eec:	da0498e3          	bnez	s1,80004c9c <exec+0x84>
  return -1;
    80004ef0:	557d                	li	a0,-1
    80004ef2:	bb7d                	j	80004cb0 <exec+0x98>
    80004ef4:	e1243423          	sd	s2,-504(s0)
    80004ef8:	b7dd                	j	80004ede <exec+0x2c6>
    80004efa:	e1243423          	sd	s2,-504(s0)
    80004efe:	b7c5                	j	80004ede <exec+0x2c6>
    80004f00:	e1243423          	sd	s2,-504(s0)
    80004f04:	bfe9                	j	80004ede <exec+0x2c6>
  sz = sz1;
    80004f06:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f0a:	4481                	li	s1,0
    80004f0c:	bfc9                	j	80004ede <exec+0x2c6>
  sz = sz1;
    80004f0e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f12:	4481                	li	s1,0
    80004f14:	b7e9                	j	80004ede <exec+0x2c6>
  sz = sz1;
    80004f16:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f1a:	4481                	li	s1,0
    80004f1c:	b7c9                	j	80004ede <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f1e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f22:	2b05                	addiw	s6,s6,1
    80004f24:	0389899b          	addiw	s3,s3,56
    80004f28:	e8045783          	lhu	a5,-384(s0)
    80004f2c:	e2fb5be3          	bge	s6,a5,80004d62 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f30:	2981                	sext.w	s3,s3
    80004f32:	03800713          	li	a4,56
    80004f36:	86ce                	mv	a3,s3
    80004f38:	e1040613          	addi	a2,s0,-496
    80004f3c:	4581                	li	a1,0
    80004f3e:	8526                	mv	a0,s1
    80004f40:	fffff097          	auipc	ra,0xfffff
    80004f44:	a52080e7          	jalr	-1454(ra) # 80003992 <readi>
    80004f48:	03800793          	li	a5,56
    80004f4c:	f8f517e3          	bne	a0,a5,80004eda <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004f50:	e1042783          	lw	a5,-496(s0)
    80004f54:	4705                	li	a4,1
    80004f56:	fce796e3          	bne	a5,a4,80004f22 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004f5a:	e3843603          	ld	a2,-456(s0)
    80004f5e:	e3043783          	ld	a5,-464(s0)
    80004f62:	f8f669e3          	bltu	a2,a5,80004ef4 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004f66:	e2043783          	ld	a5,-480(s0)
    80004f6a:	963e                	add	a2,a2,a5
    80004f6c:	f8f667e3          	bltu	a2,a5,80004efa <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f70:	85ca                	mv	a1,s2
    80004f72:	855e                	mv	a0,s7
    80004f74:	ffffc097          	auipc	ra,0xffffc
    80004f78:	502080e7          	jalr	1282(ra) # 80001476 <uvmalloc>
    80004f7c:	e0a43423          	sd	a0,-504(s0)
    80004f80:	d141                	beqz	a0,80004f00 <exec+0x2e8>
    if(ph.vaddr % PGSIZE != 0)
    80004f82:	e2043d03          	ld	s10,-480(s0)
    80004f86:	df043783          	ld	a5,-528(s0)
    80004f8a:	00fd77b3          	and	a5,s10,a5
    80004f8e:	fba1                	bnez	a5,80004ede <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f90:	e1842d83          	lw	s11,-488(s0)
    80004f94:	e3042c03          	lw	s8,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f98:	f80c03e3          	beqz	s8,80004f1e <exec+0x306>
    80004f9c:	8a62                	mv	s4,s8
    80004f9e:	4901                	li	s2,0
    80004fa0:	b345                	j	80004d40 <exec+0x128>

0000000080004fa2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004fa2:	7179                	addi	sp,sp,-48
    80004fa4:	f406                	sd	ra,40(sp)
    80004fa6:	f022                	sd	s0,32(sp)
    80004fa8:	ec26                	sd	s1,24(sp)
    80004faa:	e84a                	sd	s2,16(sp)
    80004fac:	1800                	addi	s0,sp,48
    80004fae:	892e                	mv	s2,a1
    80004fb0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004fb2:	fdc40593          	addi	a1,s0,-36
    80004fb6:	ffffe097          	auipc	ra,0xffffe
    80004fba:	b9e080e7          	jalr	-1122(ra) # 80002b54 <argint>
    80004fbe:	04054063          	bltz	a0,80004ffe <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004fc2:	fdc42703          	lw	a4,-36(s0)
    80004fc6:	47bd                	li	a5,15
    80004fc8:	02e7ed63          	bltu	a5,a4,80005002 <argfd+0x60>
    80004fcc:	ffffd097          	auipc	ra,0xffffd
    80004fd0:	ac6080e7          	jalr	-1338(ra) # 80001a92 <myproc>
    80004fd4:	fdc42703          	lw	a4,-36(s0)
    80004fd8:	01a70793          	addi	a5,a4,26
    80004fdc:	078e                	slli	a5,a5,0x3
    80004fde:	953e                	add	a0,a0,a5
    80004fe0:	651c                	ld	a5,8(a0)
    80004fe2:	c395                	beqz	a5,80005006 <argfd+0x64>
    return -1;
  if(pfd)
    80004fe4:	00090463          	beqz	s2,80004fec <argfd+0x4a>
    *pfd = fd;
    80004fe8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004fec:	4501                	li	a0,0
  if(pf)
    80004fee:	c091                	beqz	s1,80004ff2 <argfd+0x50>
    *pf = f;
    80004ff0:	e09c                	sd	a5,0(s1)
}
    80004ff2:	70a2                	ld	ra,40(sp)
    80004ff4:	7402                	ld	s0,32(sp)
    80004ff6:	64e2                	ld	s1,24(sp)
    80004ff8:	6942                	ld	s2,16(sp)
    80004ffa:	6145                	addi	sp,sp,48
    80004ffc:	8082                	ret
    return -1;
    80004ffe:	557d                	li	a0,-1
    80005000:	bfcd                	j	80004ff2 <argfd+0x50>
    return -1;
    80005002:	557d                	li	a0,-1
    80005004:	b7fd                	j	80004ff2 <argfd+0x50>
    80005006:	557d                	li	a0,-1
    80005008:	b7ed                	j	80004ff2 <argfd+0x50>

000000008000500a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000500a:	1101                	addi	sp,sp,-32
    8000500c:	ec06                	sd	ra,24(sp)
    8000500e:	e822                	sd	s0,16(sp)
    80005010:	e426                	sd	s1,8(sp)
    80005012:	1000                	addi	s0,sp,32
    80005014:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005016:	ffffd097          	auipc	ra,0xffffd
    8000501a:	a7c080e7          	jalr	-1412(ra) # 80001a92 <myproc>
    8000501e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005020:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd90d8>
    80005024:	4501                	li	a0,0
    80005026:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005028:	6398                	ld	a4,0(a5)
    8000502a:	cb19                	beqz	a4,80005040 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000502c:	2505                	addiw	a0,a0,1
    8000502e:	07a1                	addi	a5,a5,8
    80005030:	fed51ce3          	bne	a0,a3,80005028 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005034:	557d                	li	a0,-1
}
    80005036:	60e2                	ld	ra,24(sp)
    80005038:	6442                	ld	s0,16(sp)
    8000503a:	64a2                	ld	s1,8(sp)
    8000503c:	6105                	addi	sp,sp,32
    8000503e:	8082                	ret
      p->ofile[fd] = f;
    80005040:	01a50793          	addi	a5,a0,26
    80005044:	078e                	slli	a5,a5,0x3
    80005046:	963e                	add	a2,a2,a5
    80005048:	e604                	sd	s1,8(a2)
      return fd;
    8000504a:	b7f5                	j	80005036 <fdalloc+0x2c>

000000008000504c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000504c:	715d                	addi	sp,sp,-80
    8000504e:	e486                	sd	ra,72(sp)
    80005050:	e0a2                	sd	s0,64(sp)
    80005052:	fc26                	sd	s1,56(sp)
    80005054:	f84a                	sd	s2,48(sp)
    80005056:	f44e                	sd	s3,40(sp)
    80005058:	f052                	sd	s4,32(sp)
    8000505a:	ec56                	sd	s5,24(sp)
    8000505c:	0880                	addi	s0,sp,80
    8000505e:	89ae                	mv	s3,a1
    80005060:	8ab2                	mv	s5,a2
    80005062:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005064:	fb040593          	addi	a1,s0,-80
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	e44080e7          	jalr	-444(ra) # 80003eac <nameiparent>
    80005070:	892a                	mv	s2,a0
    80005072:	12050e63          	beqz	a0,800051ae <create+0x162>
    return 0;

  ilock(dp);
    80005076:	ffffe097          	auipc	ra,0xffffe
    8000507a:	668080e7          	jalr	1640(ra) # 800036de <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000507e:	4601                	li	a2,0
    80005080:	fb040593          	addi	a1,s0,-80
    80005084:	854a                	mv	a0,s2
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	b36080e7          	jalr	-1226(ra) # 80003bbc <dirlookup>
    8000508e:	84aa                	mv	s1,a0
    80005090:	c921                	beqz	a0,800050e0 <create+0x94>
    iunlockput(dp);
    80005092:	854a                	mv	a0,s2
    80005094:	fffff097          	auipc	ra,0xfffff
    80005098:	8ac080e7          	jalr	-1876(ra) # 80003940 <iunlockput>
    ilock(ip);
    8000509c:	8526                	mv	a0,s1
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	640080e7          	jalr	1600(ra) # 800036de <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800050a6:	2981                	sext.w	s3,s3
    800050a8:	4789                	li	a5,2
    800050aa:	02f99463          	bne	s3,a5,800050d2 <create+0x86>
    800050ae:	0444d783          	lhu	a5,68(s1)
    800050b2:	37f9                	addiw	a5,a5,-2
    800050b4:	17c2                	slli	a5,a5,0x30
    800050b6:	93c1                	srli	a5,a5,0x30
    800050b8:	4705                	li	a4,1
    800050ba:	00f76c63          	bltu	a4,a5,800050d2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800050be:	8526                	mv	a0,s1
    800050c0:	60a6                	ld	ra,72(sp)
    800050c2:	6406                	ld	s0,64(sp)
    800050c4:	74e2                	ld	s1,56(sp)
    800050c6:	7942                	ld	s2,48(sp)
    800050c8:	79a2                	ld	s3,40(sp)
    800050ca:	7a02                	ld	s4,32(sp)
    800050cc:	6ae2                	ld	s5,24(sp)
    800050ce:	6161                	addi	sp,sp,80
    800050d0:	8082                	ret
    iunlockput(ip);
    800050d2:	8526                	mv	a0,s1
    800050d4:	fffff097          	auipc	ra,0xfffff
    800050d8:	86c080e7          	jalr	-1940(ra) # 80003940 <iunlockput>
    return 0;
    800050dc:	4481                	li	s1,0
    800050de:	b7c5                	j	800050be <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800050e0:	85ce                	mv	a1,s3
    800050e2:	00092503          	lw	a0,0(s2)
    800050e6:	ffffe097          	auipc	ra,0xffffe
    800050ea:	460080e7          	jalr	1120(ra) # 80003546 <ialloc>
    800050ee:	84aa                	mv	s1,a0
    800050f0:	c521                	beqz	a0,80005138 <create+0xec>
  ilock(ip);
    800050f2:	ffffe097          	auipc	ra,0xffffe
    800050f6:	5ec080e7          	jalr	1516(ra) # 800036de <ilock>
  ip->major = major;
    800050fa:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800050fe:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005102:	4a05                	li	s4,1
    80005104:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005108:	8526                	mv	a0,s1
    8000510a:	ffffe097          	auipc	ra,0xffffe
    8000510e:	50a080e7          	jalr	1290(ra) # 80003614 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005112:	2981                	sext.w	s3,s3
    80005114:	03498a63          	beq	s3,s4,80005148 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005118:	40d0                	lw	a2,4(s1)
    8000511a:	fb040593          	addi	a1,s0,-80
    8000511e:	854a                	mv	a0,s2
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	cac080e7          	jalr	-852(ra) # 80003dcc <dirlink>
    80005128:	06054b63          	bltz	a0,8000519e <create+0x152>
  iunlockput(dp);
    8000512c:	854a                	mv	a0,s2
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	812080e7          	jalr	-2030(ra) # 80003940 <iunlockput>
  return ip;
    80005136:	b761                	j	800050be <create+0x72>
    panic("create: ialloc");
    80005138:	00003517          	auipc	a0,0x3
    8000513c:	60050513          	addi	a0,a0,1536 # 80008738 <syscalls+0x2b8>
    80005140:	ffffb097          	auipc	ra,0xffffb
    80005144:	414080e7          	jalr	1044(ra) # 80000554 <panic>
    dp->nlink++;  // for ".."
    80005148:	04a95783          	lhu	a5,74(s2)
    8000514c:	2785                	addiw	a5,a5,1
    8000514e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005152:	854a                	mv	a0,s2
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	4c0080e7          	jalr	1216(ra) # 80003614 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000515c:	40d0                	lw	a2,4(s1)
    8000515e:	00003597          	auipc	a1,0x3
    80005162:	5ea58593          	addi	a1,a1,1514 # 80008748 <syscalls+0x2c8>
    80005166:	8526                	mv	a0,s1
    80005168:	fffff097          	auipc	ra,0xfffff
    8000516c:	c64080e7          	jalr	-924(ra) # 80003dcc <dirlink>
    80005170:	00054f63          	bltz	a0,8000518e <create+0x142>
    80005174:	00492603          	lw	a2,4(s2)
    80005178:	00003597          	auipc	a1,0x3
    8000517c:	5d858593          	addi	a1,a1,1496 # 80008750 <syscalls+0x2d0>
    80005180:	8526                	mv	a0,s1
    80005182:	fffff097          	auipc	ra,0xfffff
    80005186:	c4a080e7          	jalr	-950(ra) # 80003dcc <dirlink>
    8000518a:	f80557e3          	bgez	a0,80005118 <create+0xcc>
      panic("create dots");
    8000518e:	00003517          	auipc	a0,0x3
    80005192:	5ca50513          	addi	a0,a0,1482 # 80008758 <syscalls+0x2d8>
    80005196:	ffffb097          	auipc	ra,0xffffb
    8000519a:	3be080e7          	jalr	958(ra) # 80000554 <panic>
    panic("create: dirlink");
    8000519e:	00003517          	auipc	a0,0x3
    800051a2:	5ca50513          	addi	a0,a0,1482 # 80008768 <syscalls+0x2e8>
    800051a6:	ffffb097          	auipc	ra,0xffffb
    800051aa:	3ae080e7          	jalr	942(ra) # 80000554 <panic>
    return 0;
    800051ae:	84aa                	mv	s1,a0
    800051b0:	b739                	j	800050be <create+0x72>

00000000800051b2 <sys_dup>:
{
    800051b2:	7179                	addi	sp,sp,-48
    800051b4:	f406                	sd	ra,40(sp)
    800051b6:	f022                	sd	s0,32(sp)
    800051b8:	ec26                	sd	s1,24(sp)
    800051ba:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800051bc:	fd840613          	addi	a2,s0,-40
    800051c0:	4581                	li	a1,0
    800051c2:	4501                	li	a0,0
    800051c4:	00000097          	auipc	ra,0x0
    800051c8:	dde080e7          	jalr	-546(ra) # 80004fa2 <argfd>
    return -1;
    800051cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800051ce:	02054363          	bltz	a0,800051f4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800051d2:	fd843503          	ld	a0,-40(s0)
    800051d6:	00000097          	auipc	ra,0x0
    800051da:	e34080e7          	jalr	-460(ra) # 8000500a <fdalloc>
    800051de:	84aa                	mv	s1,a0
    return -1;
    800051e0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800051e2:	00054963          	bltz	a0,800051f4 <sys_dup+0x42>
  filedup(f);
    800051e6:	fd843503          	ld	a0,-40(s0)
    800051ea:	fffff097          	auipc	ra,0xfffff
    800051ee:	330080e7          	jalr	816(ra) # 8000451a <filedup>
  return fd;
    800051f2:	87a6                	mv	a5,s1
}
    800051f4:	853e                	mv	a0,a5
    800051f6:	70a2                	ld	ra,40(sp)
    800051f8:	7402                	ld	s0,32(sp)
    800051fa:	64e2                	ld	s1,24(sp)
    800051fc:	6145                	addi	sp,sp,48
    800051fe:	8082                	ret

0000000080005200 <sys_read>:
{
    80005200:	7179                	addi	sp,sp,-48
    80005202:	f406                	sd	ra,40(sp)
    80005204:	f022                	sd	s0,32(sp)
    80005206:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005208:	fe840613          	addi	a2,s0,-24
    8000520c:	4581                	li	a1,0
    8000520e:	4501                	li	a0,0
    80005210:	00000097          	auipc	ra,0x0
    80005214:	d92080e7          	jalr	-622(ra) # 80004fa2 <argfd>
    return -1;
    80005218:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000521a:	04054163          	bltz	a0,8000525c <sys_read+0x5c>
    8000521e:	fe440593          	addi	a1,s0,-28
    80005222:	4509                	li	a0,2
    80005224:	ffffe097          	auipc	ra,0xffffe
    80005228:	930080e7          	jalr	-1744(ra) # 80002b54 <argint>
    return -1;
    8000522c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000522e:	02054763          	bltz	a0,8000525c <sys_read+0x5c>
    80005232:	fd840593          	addi	a1,s0,-40
    80005236:	4505                	li	a0,1
    80005238:	ffffe097          	auipc	ra,0xffffe
    8000523c:	93e080e7          	jalr	-1730(ra) # 80002b76 <argaddr>
    return -1;
    80005240:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005242:	00054d63          	bltz	a0,8000525c <sys_read+0x5c>
  return fileread(f, p, n);
    80005246:	fe442603          	lw	a2,-28(s0)
    8000524a:	fd843583          	ld	a1,-40(s0)
    8000524e:	fe843503          	ld	a0,-24(s0)
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	454080e7          	jalr	1108(ra) # 800046a6 <fileread>
    8000525a:	87aa                	mv	a5,a0
}
    8000525c:	853e                	mv	a0,a5
    8000525e:	70a2                	ld	ra,40(sp)
    80005260:	7402                	ld	s0,32(sp)
    80005262:	6145                	addi	sp,sp,48
    80005264:	8082                	ret

0000000080005266 <sys_write>:
{
    80005266:	7179                	addi	sp,sp,-48
    80005268:	f406                	sd	ra,40(sp)
    8000526a:	f022                	sd	s0,32(sp)
    8000526c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000526e:	fe840613          	addi	a2,s0,-24
    80005272:	4581                	li	a1,0
    80005274:	4501                	li	a0,0
    80005276:	00000097          	auipc	ra,0x0
    8000527a:	d2c080e7          	jalr	-724(ra) # 80004fa2 <argfd>
    return -1;
    8000527e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005280:	04054163          	bltz	a0,800052c2 <sys_write+0x5c>
    80005284:	fe440593          	addi	a1,s0,-28
    80005288:	4509                	li	a0,2
    8000528a:	ffffe097          	auipc	ra,0xffffe
    8000528e:	8ca080e7          	jalr	-1846(ra) # 80002b54 <argint>
    return -1;
    80005292:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005294:	02054763          	bltz	a0,800052c2 <sys_write+0x5c>
    80005298:	fd840593          	addi	a1,s0,-40
    8000529c:	4505                	li	a0,1
    8000529e:	ffffe097          	auipc	ra,0xffffe
    800052a2:	8d8080e7          	jalr	-1832(ra) # 80002b76 <argaddr>
    return -1;
    800052a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052a8:	00054d63          	bltz	a0,800052c2 <sys_write+0x5c>
  return filewrite(f, p, n);
    800052ac:	fe442603          	lw	a2,-28(s0)
    800052b0:	fd843583          	ld	a1,-40(s0)
    800052b4:	fe843503          	ld	a0,-24(s0)
    800052b8:	fffff097          	auipc	ra,0xfffff
    800052bc:	4b0080e7          	jalr	1200(ra) # 80004768 <filewrite>
    800052c0:	87aa                	mv	a5,a0
}
    800052c2:	853e                	mv	a0,a5
    800052c4:	70a2                	ld	ra,40(sp)
    800052c6:	7402                	ld	s0,32(sp)
    800052c8:	6145                	addi	sp,sp,48
    800052ca:	8082                	ret

00000000800052cc <sys_close>:
{
    800052cc:	1101                	addi	sp,sp,-32
    800052ce:	ec06                	sd	ra,24(sp)
    800052d0:	e822                	sd	s0,16(sp)
    800052d2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800052d4:	fe040613          	addi	a2,s0,-32
    800052d8:	fec40593          	addi	a1,s0,-20
    800052dc:	4501                	li	a0,0
    800052de:	00000097          	auipc	ra,0x0
    800052e2:	cc4080e7          	jalr	-828(ra) # 80004fa2 <argfd>
    return -1;
    800052e6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800052e8:	02054463          	bltz	a0,80005310 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800052ec:	ffffc097          	auipc	ra,0xffffc
    800052f0:	7a6080e7          	jalr	1958(ra) # 80001a92 <myproc>
    800052f4:	fec42783          	lw	a5,-20(s0)
    800052f8:	07e9                	addi	a5,a5,26
    800052fa:	078e                	slli	a5,a5,0x3
    800052fc:	97aa                	add	a5,a5,a0
    800052fe:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80005302:	fe043503          	ld	a0,-32(s0)
    80005306:	fffff097          	auipc	ra,0xfffff
    8000530a:	266080e7          	jalr	614(ra) # 8000456c <fileclose>
  return 0;
    8000530e:	4781                	li	a5,0
}
    80005310:	853e                	mv	a0,a5
    80005312:	60e2                	ld	ra,24(sp)
    80005314:	6442                	ld	s0,16(sp)
    80005316:	6105                	addi	sp,sp,32
    80005318:	8082                	ret

000000008000531a <sys_fstat>:
{
    8000531a:	1101                	addi	sp,sp,-32
    8000531c:	ec06                	sd	ra,24(sp)
    8000531e:	e822                	sd	s0,16(sp)
    80005320:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005322:	fe840613          	addi	a2,s0,-24
    80005326:	4581                	li	a1,0
    80005328:	4501                	li	a0,0
    8000532a:	00000097          	auipc	ra,0x0
    8000532e:	c78080e7          	jalr	-904(ra) # 80004fa2 <argfd>
    return -1;
    80005332:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005334:	02054563          	bltz	a0,8000535e <sys_fstat+0x44>
    80005338:	fe040593          	addi	a1,s0,-32
    8000533c:	4505                	li	a0,1
    8000533e:	ffffe097          	auipc	ra,0xffffe
    80005342:	838080e7          	jalr	-1992(ra) # 80002b76 <argaddr>
    return -1;
    80005346:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005348:	00054b63          	bltz	a0,8000535e <sys_fstat+0x44>
  return filestat(f, st);
    8000534c:	fe043583          	ld	a1,-32(s0)
    80005350:	fe843503          	ld	a0,-24(s0)
    80005354:	fffff097          	auipc	ra,0xfffff
    80005358:	2e0080e7          	jalr	736(ra) # 80004634 <filestat>
    8000535c:	87aa                	mv	a5,a0
}
    8000535e:	853e                	mv	a0,a5
    80005360:	60e2                	ld	ra,24(sp)
    80005362:	6442                	ld	s0,16(sp)
    80005364:	6105                	addi	sp,sp,32
    80005366:	8082                	ret

0000000080005368 <sys_link>:
{
    80005368:	7169                	addi	sp,sp,-304
    8000536a:	f606                	sd	ra,296(sp)
    8000536c:	f222                	sd	s0,288(sp)
    8000536e:	ee26                	sd	s1,280(sp)
    80005370:	ea4a                	sd	s2,272(sp)
    80005372:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005374:	08000613          	li	a2,128
    80005378:	ed040593          	addi	a1,s0,-304
    8000537c:	4501                	li	a0,0
    8000537e:	ffffe097          	auipc	ra,0xffffe
    80005382:	81a080e7          	jalr	-2022(ra) # 80002b98 <argstr>
    return -1;
    80005386:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005388:	10054e63          	bltz	a0,800054a4 <sys_link+0x13c>
    8000538c:	08000613          	li	a2,128
    80005390:	f5040593          	addi	a1,s0,-176
    80005394:	4505                	li	a0,1
    80005396:	ffffe097          	auipc	ra,0xffffe
    8000539a:	802080e7          	jalr	-2046(ra) # 80002b98 <argstr>
    return -1;
    8000539e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053a0:	10054263          	bltz	a0,800054a4 <sys_link+0x13c>
  begin_op();
    800053a4:	fffff097          	auipc	ra,0xfffff
    800053a8:	cf6080e7          	jalr	-778(ra) # 8000409a <begin_op>
  if((ip = namei(old)) == 0){
    800053ac:	ed040513          	addi	a0,s0,-304
    800053b0:	fffff097          	auipc	ra,0xfffff
    800053b4:	ade080e7          	jalr	-1314(ra) # 80003e8e <namei>
    800053b8:	84aa                	mv	s1,a0
    800053ba:	c551                	beqz	a0,80005446 <sys_link+0xde>
  ilock(ip);
    800053bc:	ffffe097          	auipc	ra,0xffffe
    800053c0:	322080e7          	jalr	802(ra) # 800036de <ilock>
  if(ip->type == T_DIR){
    800053c4:	04449703          	lh	a4,68(s1)
    800053c8:	4785                	li	a5,1
    800053ca:	08f70463          	beq	a4,a5,80005452 <sys_link+0xea>
  ip->nlink++;
    800053ce:	04a4d783          	lhu	a5,74(s1)
    800053d2:	2785                	addiw	a5,a5,1
    800053d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053d8:	8526                	mv	a0,s1
    800053da:	ffffe097          	auipc	ra,0xffffe
    800053de:	23a080e7          	jalr	570(ra) # 80003614 <iupdate>
  iunlock(ip);
    800053e2:	8526                	mv	a0,s1
    800053e4:	ffffe097          	auipc	ra,0xffffe
    800053e8:	3bc080e7          	jalr	956(ra) # 800037a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800053ec:	fd040593          	addi	a1,s0,-48
    800053f0:	f5040513          	addi	a0,s0,-176
    800053f4:	fffff097          	auipc	ra,0xfffff
    800053f8:	ab8080e7          	jalr	-1352(ra) # 80003eac <nameiparent>
    800053fc:	892a                	mv	s2,a0
    800053fe:	c935                	beqz	a0,80005472 <sys_link+0x10a>
  ilock(dp);
    80005400:	ffffe097          	auipc	ra,0xffffe
    80005404:	2de080e7          	jalr	734(ra) # 800036de <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005408:	00092703          	lw	a4,0(s2)
    8000540c:	409c                	lw	a5,0(s1)
    8000540e:	04f71d63          	bne	a4,a5,80005468 <sys_link+0x100>
    80005412:	40d0                	lw	a2,4(s1)
    80005414:	fd040593          	addi	a1,s0,-48
    80005418:	854a                	mv	a0,s2
    8000541a:	fffff097          	auipc	ra,0xfffff
    8000541e:	9b2080e7          	jalr	-1614(ra) # 80003dcc <dirlink>
    80005422:	04054363          	bltz	a0,80005468 <sys_link+0x100>
  iunlockput(dp);
    80005426:	854a                	mv	a0,s2
    80005428:	ffffe097          	auipc	ra,0xffffe
    8000542c:	518080e7          	jalr	1304(ra) # 80003940 <iunlockput>
  iput(ip);
    80005430:	8526                	mv	a0,s1
    80005432:	ffffe097          	auipc	ra,0xffffe
    80005436:	466080e7          	jalr	1126(ra) # 80003898 <iput>
  end_op();
    8000543a:	fffff097          	auipc	ra,0xfffff
    8000543e:	ce0080e7          	jalr	-800(ra) # 8000411a <end_op>
  return 0;
    80005442:	4781                	li	a5,0
    80005444:	a085                	j	800054a4 <sys_link+0x13c>
    end_op();
    80005446:	fffff097          	auipc	ra,0xfffff
    8000544a:	cd4080e7          	jalr	-812(ra) # 8000411a <end_op>
    return -1;
    8000544e:	57fd                	li	a5,-1
    80005450:	a891                	j	800054a4 <sys_link+0x13c>
    iunlockput(ip);
    80005452:	8526                	mv	a0,s1
    80005454:	ffffe097          	auipc	ra,0xffffe
    80005458:	4ec080e7          	jalr	1260(ra) # 80003940 <iunlockput>
    end_op();
    8000545c:	fffff097          	auipc	ra,0xfffff
    80005460:	cbe080e7          	jalr	-834(ra) # 8000411a <end_op>
    return -1;
    80005464:	57fd                	li	a5,-1
    80005466:	a83d                	j	800054a4 <sys_link+0x13c>
    iunlockput(dp);
    80005468:	854a                	mv	a0,s2
    8000546a:	ffffe097          	auipc	ra,0xffffe
    8000546e:	4d6080e7          	jalr	1238(ra) # 80003940 <iunlockput>
  ilock(ip);
    80005472:	8526                	mv	a0,s1
    80005474:	ffffe097          	auipc	ra,0xffffe
    80005478:	26a080e7          	jalr	618(ra) # 800036de <ilock>
  ip->nlink--;
    8000547c:	04a4d783          	lhu	a5,74(s1)
    80005480:	37fd                	addiw	a5,a5,-1
    80005482:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005486:	8526                	mv	a0,s1
    80005488:	ffffe097          	auipc	ra,0xffffe
    8000548c:	18c080e7          	jalr	396(ra) # 80003614 <iupdate>
  iunlockput(ip);
    80005490:	8526                	mv	a0,s1
    80005492:	ffffe097          	auipc	ra,0xffffe
    80005496:	4ae080e7          	jalr	1198(ra) # 80003940 <iunlockput>
  end_op();
    8000549a:	fffff097          	auipc	ra,0xfffff
    8000549e:	c80080e7          	jalr	-896(ra) # 8000411a <end_op>
  return -1;
    800054a2:	57fd                	li	a5,-1
}
    800054a4:	853e                	mv	a0,a5
    800054a6:	70b2                	ld	ra,296(sp)
    800054a8:	7412                	ld	s0,288(sp)
    800054aa:	64f2                	ld	s1,280(sp)
    800054ac:	6952                	ld	s2,272(sp)
    800054ae:	6155                	addi	sp,sp,304
    800054b0:	8082                	ret

00000000800054b2 <sys_unlink>:
{
    800054b2:	7151                	addi	sp,sp,-240
    800054b4:	f586                	sd	ra,232(sp)
    800054b6:	f1a2                	sd	s0,224(sp)
    800054b8:	eda6                	sd	s1,216(sp)
    800054ba:	e9ca                	sd	s2,208(sp)
    800054bc:	e5ce                	sd	s3,200(sp)
    800054be:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800054c0:	08000613          	li	a2,128
    800054c4:	f3040593          	addi	a1,s0,-208
    800054c8:	4501                	li	a0,0
    800054ca:	ffffd097          	auipc	ra,0xffffd
    800054ce:	6ce080e7          	jalr	1742(ra) # 80002b98 <argstr>
    800054d2:	18054163          	bltz	a0,80005654 <sys_unlink+0x1a2>
  begin_op();
    800054d6:	fffff097          	auipc	ra,0xfffff
    800054da:	bc4080e7          	jalr	-1084(ra) # 8000409a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800054de:	fb040593          	addi	a1,s0,-80
    800054e2:	f3040513          	addi	a0,s0,-208
    800054e6:	fffff097          	auipc	ra,0xfffff
    800054ea:	9c6080e7          	jalr	-1594(ra) # 80003eac <nameiparent>
    800054ee:	84aa                	mv	s1,a0
    800054f0:	c979                	beqz	a0,800055c6 <sys_unlink+0x114>
  ilock(dp);
    800054f2:	ffffe097          	auipc	ra,0xffffe
    800054f6:	1ec080e7          	jalr	492(ra) # 800036de <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800054fa:	00003597          	auipc	a1,0x3
    800054fe:	24e58593          	addi	a1,a1,590 # 80008748 <syscalls+0x2c8>
    80005502:	fb040513          	addi	a0,s0,-80
    80005506:	ffffe097          	auipc	ra,0xffffe
    8000550a:	69c080e7          	jalr	1692(ra) # 80003ba2 <namecmp>
    8000550e:	14050a63          	beqz	a0,80005662 <sys_unlink+0x1b0>
    80005512:	00003597          	auipc	a1,0x3
    80005516:	23e58593          	addi	a1,a1,574 # 80008750 <syscalls+0x2d0>
    8000551a:	fb040513          	addi	a0,s0,-80
    8000551e:	ffffe097          	auipc	ra,0xffffe
    80005522:	684080e7          	jalr	1668(ra) # 80003ba2 <namecmp>
    80005526:	12050e63          	beqz	a0,80005662 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000552a:	f2c40613          	addi	a2,s0,-212
    8000552e:	fb040593          	addi	a1,s0,-80
    80005532:	8526                	mv	a0,s1
    80005534:	ffffe097          	auipc	ra,0xffffe
    80005538:	688080e7          	jalr	1672(ra) # 80003bbc <dirlookup>
    8000553c:	892a                	mv	s2,a0
    8000553e:	12050263          	beqz	a0,80005662 <sys_unlink+0x1b0>
  ilock(ip);
    80005542:	ffffe097          	auipc	ra,0xffffe
    80005546:	19c080e7          	jalr	412(ra) # 800036de <ilock>
  if(ip->nlink < 1)
    8000554a:	04a91783          	lh	a5,74(s2)
    8000554e:	08f05263          	blez	a5,800055d2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005552:	04491703          	lh	a4,68(s2)
    80005556:	4785                	li	a5,1
    80005558:	08f70563          	beq	a4,a5,800055e2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000555c:	4641                	li	a2,16
    8000555e:	4581                	li	a1,0
    80005560:	fc040513          	addi	a0,s0,-64
    80005564:	ffffb097          	auipc	ra,0xffffb
    80005568:	79c080e7          	jalr	1948(ra) # 80000d00 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000556c:	4741                	li	a4,16
    8000556e:	f2c42683          	lw	a3,-212(s0)
    80005572:	fc040613          	addi	a2,s0,-64
    80005576:	4581                	li	a1,0
    80005578:	8526                	mv	a0,s1
    8000557a:	ffffe097          	auipc	ra,0xffffe
    8000557e:	50e080e7          	jalr	1294(ra) # 80003a88 <writei>
    80005582:	47c1                	li	a5,16
    80005584:	0af51563          	bne	a0,a5,8000562e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005588:	04491703          	lh	a4,68(s2)
    8000558c:	4785                	li	a5,1
    8000558e:	0af70863          	beq	a4,a5,8000563e <sys_unlink+0x18c>
  iunlockput(dp);
    80005592:	8526                	mv	a0,s1
    80005594:	ffffe097          	auipc	ra,0xffffe
    80005598:	3ac080e7          	jalr	940(ra) # 80003940 <iunlockput>
  ip->nlink--;
    8000559c:	04a95783          	lhu	a5,74(s2)
    800055a0:	37fd                	addiw	a5,a5,-1
    800055a2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800055a6:	854a                	mv	a0,s2
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	06c080e7          	jalr	108(ra) # 80003614 <iupdate>
  iunlockput(ip);
    800055b0:	854a                	mv	a0,s2
    800055b2:	ffffe097          	auipc	ra,0xffffe
    800055b6:	38e080e7          	jalr	910(ra) # 80003940 <iunlockput>
  end_op();
    800055ba:	fffff097          	auipc	ra,0xfffff
    800055be:	b60080e7          	jalr	-1184(ra) # 8000411a <end_op>
  return 0;
    800055c2:	4501                	li	a0,0
    800055c4:	a84d                	j	80005676 <sys_unlink+0x1c4>
    end_op();
    800055c6:	fffff097          	auipc	ra,0xfffff
    800055ca:	b54080e7          	jalr	-1196(ra) # 8000411a <end_op>
    return -1;
    800055ce:	557d                	li	a0,-1
    800055d0:	a05d                	j	80005676 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	1a650513          	addi	a0,a0,422 # 80008778 <syscalls+0x2f8>
    800055da:	ffffb097          	auipc	ra,0xffffb
    800055de:	f7a080e7          	jalr	-134(ra) # 80000554 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055e2:	04c92703          	lw	a4,76(s2)
    800055e6:	02000793          	li	a5,32
    800055ea:	f6e7f9e3          	bgeu	a5,a4,8000555c <sys_unlink+0xaa>
    800055ee:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055f2:	4741                	li	a4,16
    800055f4:	86ce                	mv	a3,s3
    800055f6:	f1840613          	addi	a2,s0,-232
    800055fa:	4581                	li	a1,0
    800055fc:	854a                	mv	a0,s2
    800055fe:	ffffe097          	auipc	ra,0xffffe
    80005602:	394080e7          	jalr	916(ra) # 80003992 <readi>
    80005606:	47c1                	li	a5,16
    80005608:	00f51b63          	bne	a0,a5,8000561e <sys_unlink+0x16c>
    if(de.inum != 0)
    8000560c:	f1845783          	lhu	a5,-232(s0)
    80005610:	e7a1                	bnez	a5,80005658 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005612:	29c1                	addiw	s3,s3,16
    80005614:	04c92783          	lw	a5,76(s2)
    80005618:	fcf9ede3          	bltu	s3,a5,800055f2 <sys_unlink+0x140>
    8000561c:	b781                	j	8000555c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000561e:	00003517          	auipc	a0,0x3
    80005622:	17250513          	addi	a0,a0,370 # 80008790 <syscalls+0x310>
    80005626:	ffffb097          	auipc	ra,0xffffb
    8000562a:	f2e080e7          	jalr	-210(ra) # 80000554 <panic>
    panic("unlink: writei");
    8000562e:	00003517          	auipc	a0,0x3
    80005632:	17a50513          	addi	a0,a0,378 # 800087a8 <syscalls+0x328>
    80005636:	ffffb097          	auipc	ra,0xffffb
    8000563a:	f1e080e7          	jalr	-226(ra) # 80000554 <panic>
    dp->nlink--;
    8000563e:	04a4d783          	lhu	a5,74(s1)
    80005642:	37fd                	addiw	a5,a5,-1
    80005644:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005648:	8526                	mv	a0,s1
    8000564a:	ffffe097          	auipc	ra,0xffffe
    8000564e:	fca080e7          	jalr	-54(ra) # 80003614 <iupdate>
    80005652:	b781                	j	80005592 <sys_unlink+0xe0>
    return -1;
    80005654:	557d                	li	a0,-1
    80005656:	a005                	j	80005676 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005658:	854a                	mv	a0,s2
    8000565a:	ffffe097          	auipc	ra,0xffffe
    8000565e:	2e6080e7          	jalr	742(ra) # 80003940 <iunlockput>
  iunlockput(dp);
    80005662:	8526                	mv	a0,s1
    80005664:	ffffe097          	auipc	ra,0xffffe
    80005668:	2dc080e7          	jalr	732(ra) # 80003940 <iunlockput>
  end_op();
    8000566c:	fffff097          	auipc	ra,0xfffff
    80005670:	aae080e7          	jalr	-1362(ra) # 8000411a <end_op>
  return -1;
    80005674:	557d                	li	a0,-1
}
    80005676:	70ae                	ld	ra,232(sp)
    80005678:	740e                	ld	s0,224(sp)
    8000567a:	64ee                	ld	s1,216(sp)
    8000567c:	694e                	ld	s2,208(sp)
    8000567e:	69ae                	ld	s3,200(sp)
    80005680:	616d                	addi	sp,sp,240
    80005682:	8082                	ret

0000000080005684 <sys_open>:

uint64
sys_open(void)
{
    80005684:	7131                	addi	sp,sp,-192
    80005686:	fd06                	sd	ra,184(sp)
    80005688:	f922                	sd	s0,176(sp)
    8000568a:	f526                	sd	s1,168(sp)
    8000568c:	f14a                	sd	s2,160(sp)
    8000568e:	ed4e                	sd	s3,152(sp)
    80005690:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005692:	08000613          	li	a2,128
    80005696:	f5040593          	addi	a1,s0,-176
    8000569a:	4501                	li	a0,0
    8000569c:	ffffd097          	auipc	ra,0xffffd
    800056a0:	4fc080e7          	jalr	1276(ra) # 80002b98 <argstr>
    return -1;
    800056a4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800056a6:	0c054163          	bltz	a0,80005768 <sys_open+0xe4>
    800056aa:	f4c40593          	addi	a1,s0,-180
    800056ae:	4505                	li	a0,1
    800056b0:	ffffd097          	auipc	ra,0xffffd
    800056b4:	4a4080e7          	jalr	1188(ra) # 80002b54 <argint>
    800056b8:	0a054863          	bltz	a0,80005768 <sys_open+0xe4>

  begin_op();
    800056bc:	fffff097          	auipc	ra,0xfffff
    800056c0:	9de080e7          	jalr	-1570(ra) # 8000409a <begin_op>

  if(omode & O_CREATE){
    800056c4:	f4c42783          	lw	a5,-180(s0)
    800056c8:	2007f793          	andi	a5,a5,512
    800056cc:	cbdd                	beqz	a5,80005782 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800056ce:	4681                	li	a3,0
    800056d0:	4601                	li	a2,0
    800056d2:	4589                	li	a1,2
    800056d4:	f5040513          	addi	a0,s0,-176
    800056d8:	00000097          	auipc	ra,0x0
    800056dc:	974080e7          	jalr	-1676(ra) # 8000504c <create>
    800056e0:	892a                	mv	s2,a0
    if(ip == 0){
    800056e2:	c959                	beqz	a0,80005778 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800056e4:	04491703          	lh	a4,68(s2)
    800056e8:	478d                	li	a5,3
    800056ea:	00f71763          	bne	a4,a5,800056f8 <sys_open+0x74>
    800056ee:	04695703          	lhu	a4,70(s2)
    800056f2:	47a5                	li	a5,9
    800056f4:	0ce7ec63          	bltu	a5,a4,800057cc <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800056f8:	fffff097          	auipc	ra,0xfffff
    800056fc:	db8080e7          	jalr	-584(ra) # 800044b0 <filealloc>
    80005700:	89aa                	mv	s3,a0
    80005702:	10050263          	beqz	a0,80005806 <sys_open+0x182>
    80005706:	00000097          	auipc	ra,0x0
    8000570a:	904080e7          	jalr	-1788(ra) # 8000500a <fdalloc>
    8000570e:	84aa                	mv	s1,a0
    80005710:	0e054663          	bltz	a0,800057fc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005714:	04491703          	lh	a4,68(s2)
    80005718:	478d                	li	a5,3
    8000571a:	0cf70463          	beq	a4,a5,800057e2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000571e:	4789                	li	a5,2
    80005720:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005724:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005728:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000572c:	f4c42783          	lw	a5,-180(s0)
    80005730:	0017c713          	xori	a4,a5,1
    80005734:	8b05                	andi	a4,a4,1
    80005736:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000573a:	0037f713          	andi	a4,a5,3
    8000573e:	00e03733          	snez	a4,a4
    80005742:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005746:	4007f793          	andi	a5,a5,1024
    8000574a:	c791                	beqz	a5,80005756 <sys_open+0xd2>
    8000574c:	04491703          	lh	a4,68(s2)
    80005750:	4789                	li	a5,2
    80005752:	08f70f63          	beq	a4,a5,800057f0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005756:	854a                	mv	a0,s2
    80005758:	ffffe097          	auipc	ra,0xffffe
    8000575c:	048080e7          	jalr	72(ra) # 800037a0 <iunlock>
  end_op();
    80005760:	fffff097          	auipc	ra,0xfffff
    80005764:	9ba080e7          	jalr	-1606(ra) # 8000411a <end_op>

  return fd;
}
    80005768:	8526                	mv	a0,s1
    8000576a:	70ea                	ld	ra,184(sp)
    8000576c:	744a                	ld	s0,176(sp)
    8000576e:	74aa                	ld	s1,168(sp)
    80005770:	790a                	ld	s2,160(sp)
    80005772:	69ea                	ld	s3,152(sp)
    80005774:	6129                	addi	sp,sp,192
    80005776:	8082                	ret
      end_op();
    80005778:	fffff097          	auipc	ra,0xfffff
    8000577c:	9a2080e7          	jalr	-1630(ra) # 8000411a <end_op>
      return -1;
    80005780:	b7e5                	j	80005768 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005782:	f5040513          	addi	a0,s0,-176
    80005786:	ffffe097          	auipc	ra,0xffffe
    8000578a:	708080e7          	jalr	1800(ra) # 80003e8e <namei>
    8000578e:	892a                	mv	s2,a0
    80005790:	c905                	beqz	a0,800057c0 <sys_open+0x13c>
    ilock(ip);
    80005792:	ffffe097          	auipc	ra,0xffffe
    80005796:	f4c080e7          	jalr	-180(ra) # 800036de <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000579a:	04491703          	lh	a4,68(s2)
    8000579e:	4785                	li	a5,1
    800057a0:	f4f712e3          	bne	a4,a5,800056e4 <sys_open+0x60>
    800057a4:	f4c42783          	lw	a5,-180(s0)
    800057a8:	dba1                	beqz	a5,800056f8 <sys_open+0x74>
      iunlockput(ip);
    800057aa:	854a                	mv	a0,s2
    800057ac:	ffffe097          	auipc	ra,0xffffe
    800057b0:	194080e7          	jalr	404(ra) # 80003940 <iunlockput>
      end_op();
    800057b4:	fffff097          	auipc	ra,0xfffff
    800057b8:	966080e7          	jalr	-1690(ra) # 8000411a <end_op>
      return -1;
    800057bc:	54fd                	li	s1,-1
    800057be:	b76d                	j	80005768 <sys_open+0xe4>
      end_op();
    800057c0:	fffff097          	auipc	ra,0xfffff
    800057c4:	95a080e7          	jalr	-1702(ra) # 8000411a <end_op>
      return -1;
    800057c8:	54fd                	li	s1,-1
    800057ca:	bf79                	j	80005768 <sys_open+0xe4>
    iunlockput(ip);
    800057cc:	854a                	mv	a0,s2
    800057ce:	ffffe097          	auipc	ra,0xffffe
    800057d2:	172080e7          	jalr	370(ra) # 80003940 <iunlockput>
    end_op();
    800057d6:	fffff097          	auipc	ra,0xfffff
    800057da:	944080e7          	jalr	-1724(ra) # 8000411a <end_op>
    return -1;
    800057de:	54fd                	li	s1,-1
    800057e0:	b761                	j	80005768 <sys_open+0xe4>
    f->type = FD_DEVICE;
    800057e2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800057e6:	04691783          	lh	a5,70(s2)
    800057ea:	02f99223          	sh	a5,36(s3)
    800057ee:	bf2d                	j	80005728 <sys_open+0xa4>
    itrunc(ip);
    800057f0:	854a                	mv	a0,s2
    800057f2:	ffffe097          	auipc	ra,0xffffe
    800057f6:	ffa080e7          	jalr	-6(ra) # 800037ec <itrunc>
    800057fa:	bfb1                	j	80005756 <sys_open+0xd2>
      fileclose(f);
    800057fc:	854e                	mv	a0,s3
    800057fe:	fffff097          	auipc	ra,0xfffff
    80005802:	d6e080e7          	jalr	-658(ra) # 8000456c <fileclose>
    iunlockput(ip);
    80005806:	854a                	mv	a0,s2
    80005808:	ffffe097          	auipc	ra,0xffffe
    8000580c:	138080e7          	jalr	312(ra) # 80003940 <iunlockput>
    end_op();
    80005810:	fffff097          	auipc	ra,0xfffff
    80005814:	90a080e7          	jalr	-1782(ra) # 8000411a <end_op>
    return -1;
    80005818:	54fd                	li	s1,-1
    8000581a:	b7b9                	j	80005768 <sys_open+0xe4>

000000008000581c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000581c:	7175                	addi	sp,sp,-144
    8000581e:	e506                	sd	ra,136(sp)
    80005820:	e122                	sd	s0,128(sp)
    80005822:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005824:	fffff097          	auipc	ra,0xfffff
    80005828:	876080e7          	jalr	-1930(ra) # 8000409a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000582c:	08000613          	li	a2,128
    80005830:	f7040593          	addi	a1,s0,-144
    80005834:	4501                	li	a0,0
    80005836:	ffffd097          	auipc	ra,0xffffd
    8000583a:	362080e7          	jalr	866(ra) # 80002b98 <argstr>
    8000583e:	02054963          	bltz	a0,80005870 <sys_mkdir+0x54>
    80005842:	4681                	li	a3,0
    80005844:	4601                	li	a2,0
    80005846:	4585                	li	a1,1
    80005848:	f7040513          	addi	a0,s0,-144
    8000584c:	00000097          	auipc	ra,0x0
    80005850:	800080e7          	jalr	-2048(ra) # 8000504c <create>
    80005854:	cd11                	beqz	a0,80005870 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	0ea080e7          	jalr	234(ra) # 80003940 <iunlockput>
  end_op();
    8000585e:	fffff097          	auipc	ra,0xfffff
    80005862:	8bc080e7          	jalr	-1860(ra) # 8000411a <end_op>
  return 0;
    80005866:	4501                	li	a0,0
}
    80005868:	60aa                	ld	ra,136(sp)
    8000586a:	640a                	ld	s0,128(sp)
    8000586c:	6149                	addi	sp,sp,144
    8000586e:	8082                	ret
    end_op();
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	8aa080e7          	jalr	-1878(ra) # 8000411a <end_op>
    return -1;
    80005878:	557d                	li	a0,-1
    8000587a:	b7fd                	j	80005868 <sys_mkdir+0x4c>

000000008000587c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000587c:	7135                	addi	sp,sp,-160
    8000587e:	ed06                	sd	ra,152(sp)
    80005880:	e922                	sd	s0,144(sp)
    80005882:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005884:	fffff097          	auipc	ra,0xfffff
    80005888:	816080e7          	jalr	-2026(ra) # 8000409a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000588c:	08000613          	li	a2,128
    80005890:	f7040593          	addi	a1,s0,-144
    80005894:	4501                	li	a0,0
    80005896:	ffffd097          	auipc	ra,0xffffd
    8000589a:	302080e7          	jalr	770(ra) # 80002b98 <argstr>
    8000589e:	04054a63          	bltz	a0,800058f2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800058a2:	f6c40593          	addi	a1,s0,-148
    800058a6:	4505                	li	a0,1
    800058a8:	ffffd097          	auipc	ra,0xffffd
    800058ac:	2ac080e7          	jalr	684(ra) # 80002b54 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800058b0:	04054163          	bltz	a0,800058f2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800058b4:	f6840593          	addi	a1,s0,-152
    800058b8:	4509                	li	a0,2
    800058ba:	ffffd097          	auipc	ra,0xffffd
    800058be:	29a080e7          	jalr	666(ra) # 80002b54 <argint>
     argint(1, &major) < 0 ||
    800058c2:	02054863          	bltz	a0,800058f2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800058c6:	f6841683          	lh	a3,-152(s0)
    800058ca:	f6c41603          	lh	a2,-148(s0)
    800058ce:	458d                	li	a1,3
    800058d0:	f7040513          	addi	a0,s0,-144
    800058d4:	fffff097          	auipc	ra,0xfffff
    800058d8:	778080e7          	jalr	1912(ra) # 8000504c <create>
     argint(2, &minor) < 0 ||
    800058dc:	c919                	beqz	a0,800058f2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058de:	ffffe097          	auipc	ra,0xffffe
    800058e2:	062080e7          	jalr	98(ra) # 80003940 <iunlockput>
  end_op();
    800058e6:	fffff097          	auipc	ra,0xfffff
    800058ea:	834080e7          	jalr	-1996(ra) # 8000411a <end_op>
  return 0;
    800058ee:	4501                	li	a0,0
    800058f0:	a031                	j	800058fc <sys_mknod+0x80>
    end_op();
    800058f2:	fffff097          	auipc	ra,0xfffff
    800058f6:	828080e7          	jalr	-2008(ra) # 8000411a <end_op>
    return -1;
    800058fa:	557d                	li	a0,-1
}
    800058fc:	60ea                	ld	ra,152(sp)
    800058fe:	644a                	ld	s0,144(sp)
    80005900:	610d                	addi	sp,sp,160
    80005902:	8082                	ret

0000000080005904 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005904:	7135                	addi	sp,sp,-160
    80005906:	ed06                	sd	ra,152(sp)
    80005908:	e922                	sd	s0,144(sp)
    8000590a:	e526                	sd	s1,136(sp)
    8000590c:	e14a                	sd	s2,128(sp)
    8000590e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005910:	ffffc097          	auipc	ra,0xffffc
    80005914:	182080e7          	jalr	386(ra) # 80001a92 <myproc>
    80005918:	892a                	mv	s2,a0
  
  begin_op();
    8000591a:	ffffe097          	auipc	ra,0xffffe
    8000591e:	780080e7          	jalr	1920(ra) # 8000409a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005922:	08000613          	li	a2,128
    80005926:	f6040593          	addi	a1,s0,-160
    8000592a:	4501                	li	a0,0
    8000592c:	ffffd097          	auipc	ra,0xffffd
    80005930:	26c080e7          	jalr	620(ra) # 80002b98 <argstr>
    80005934:	04054b63          	bltz	a0,8000598a <sys_chdir+0x86>
    80005938:	f6040513          	addi	a0,s0,-160
    8000593c:	ffffe097          	auipc	ra,0xffffe
    80005940:	552080e7          	jalr	1362(ra) # 80003e8e <namei>
    80005944:	84aa                	mv	s1,a0
    80005946:	c131                	beqz	a0,8000598a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005948:	ffffe097          	auipc	ra,0xffffe
    8000594c:	d96080e7          	jalr	-618(ra) # 800036de <ilock>
  if(ip->type != T_DIR){
    80005950:	04449703          	lh	a4,68(s1)
    80005954:	4785                	li	a5,1
    80005956:	04f71063          	bne	a4,a5,80005996 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000595a:	8526                	mv	a0,s1
    8000595c:	ffffe097          	auipc	ra,0xffffe
    80005960:	e44080e7          	jalr	-444(ra) # 800037a0 <iunlock>
  iput(p->cwd);
    80005964:	15893503          	ld	a0,344(s2)
    80005968:	ffffe097          	auipc	ra,0xffffe
    8000596c:	f30080e7          	jalr	-208(ra) # 80003898 <iput>
  end_op();
    80005970:	ffffe097          	auipc	ra,0xffffe
    80005974:	7aa080e7          	jalr	1962(ra) # 8000411a <end_op>
  p->cwd = ip;
    80005978:	14993c23          	sd	s1,344(s2)
  return 0;
    8000597c:	4501                	li	a0,0
}
    8000597e:	60ea                	ld	ra,152(sp)
    80005980:	644a                	ld	s0,144(sp)
    80005982:	64aa                	ld	s1,136(sp)
    80005984:	690a                	ld	s2,128(sp)
    80005986:	610d                	addi	sp,sp,160
    80005988:	8082                	ret
    end_op();
    8000598a:	ffffe097          	auipc	ra,0xffffe
    8000598e:	790080e7          	jalr	1936(ra) # 8000411a <end_op>
    return -1;
    80005992:	557d                	li	a0,-1
    80005994:	b7ed                	j	8000597e <sys_chdir+0x7a>
    iunlockput(ip);
    80005996:	8526                	mv	a0,s1
    80005998:	ffffe097          	auipc	ra,0xffffe
    8000599c:	fa8080e7          	jalr	-88(ra) # 80003940 <iunlockput>
    end_op();
    800059a0:	ffffe097          	auipc	ra,0xffffe
    800059a4:	77a080e7          	jalr	1914(ra) # 8000411a <end_op>
    return -1;
    800059a8:	557d                	li	a0,-1
    800059aa:	bfd1                	j	8000597e <sys_chdir+0x7a>

00000000800059ac <sys_exec>:

uint64
sys_exec(void)
{
    800059ac:	7145                	addi	sp,sp,-464
    800059ae:	e786                	sd	ra,456(sp)
    800059b0:	e3a2                	sd	s0,448(sp)
    800059b2:	ff26                	sd	s1,440(sp)
    800059b4:	fb4a                	sd	s2,432(sp)
    800059b6:	f74e                	sd	s3,424(sp)
    800059b8:	f352                	sd	s4,416(sp)
    800059ba:	ef56                	sd	s5,408(sp)
    800059bc:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800059be:	08000613          	li	a2,128
    800059c2:	f4040593          	addi	a1,s0,-192
    800059c6:	4501                	li	a0,0
    800059c8:	ffffd097          	auipc	ra,0xffffd
    800059cc:	1d0080e7          	jalr	464(ra) # 80002b98 <argstr>
    return -1;
    800059d0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800059d2:	0c054a63          	bltz	a0,80005aa6 <sys_exec+0xfa>
    800059d6:	e3840593          	addi	a1,s0,-456
    800059da:	4505                	li	a0,1
    800059dc:	ffffd097          	auipc	ra,0xffffd
    800059e0:	19a080e7          	jalr	410(ra) # 80002b76 <argaddr>
    800059e4:	0c054163          	bltz	a0,80005aa6 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800059e8:	10000613          	li	a2,256
    800059ec:	4581                	li	a1,0
    800059ee:	e4040513          	addi	a0,s0,-448
    800059f2:	ffffb097          	auipc	ra,0xffffb
    800059f6:	30e080e7          	jalr	782(ra) # 80000d00 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800059fa:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800059fe:	89a6                	mv	s3,s1
    80005a00:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a02:	02000a13          	li	s4,32
    80005a06:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a0a:	00391513          	slli	a0,s2,0x3
    80005a0e:	e3040593          	addi	a1,s0,-464
    80005a12:	e3843783          	ld	a5,-456(s0)
    80005a16:	953e                	add	a0,a0,a5
    80005a18:	ffffd097          	auipc	ra,0xffffd
    80005a1c:	0a2080e7          	jalr	162(ra) # 80002aba <fetchaddr>
    80005a20:	02054a63          	bltz	a0,80005a54 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005a24:	e3043783          	ld	a5,-464(s0)
    80005a28:	c3b9                	beqz	a5,80005a6e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a2a:	ffffb097          	auipc	ra,0xffffb
    80005a2e:	0ea080e7          	jalr	234(ra) # 80000b14 <kalloc>
    80005a32:	85aa                	mv	a1,a0
    80005a34:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a38:	cd11                	beqz	a0,80005a54 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a3a:	6605                	lui	a2,0x1
    80005a3c:	e3043503          	ld	a0,-464(s0)
    80005a40:	ffffd097          	auipc	ra,0xffffd
    80005a44:	0cc080e7          	jalr	204(ra) # 80002b0c <fetchstr>
    80005a48:	00054663          	bltz	a0,80005a54 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005a4c:	0905                	addi	s2,s2,1
    80005a4e:	09a1                	addi	s3,s3,8
    80005a50:	fb491be3          	bne	s2,s4,80005a06 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a54:	10048913          	addi	s2,s1,256
    80005a58:	6088                	ld	a0,0(s1)
    80005a5a:	c529                	beqz	a0,80005aa4 <sys_exec+0xf8>
    kfree(argv[i]);
    80005a5c:	ffffb097          	auipc	ra,0xffffb
    80005a60:	fbc080e7          	jalr	-68(ra) # 80000a18 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a64:	04a1                	addi	s1,s1,8
    80005a66:	ff2499e3          	bne	s1,s2,80005a58 <sys_exec+0xac>
  return -1;
    80005a6a:	597d                	li	s2,-1
    80005a6c:	a82d                	j	80005aa6 <sys_exec+0xfa>
      argv[i] = 0;
    80005a6e:	0a8e                	slli	s5,s5,0x3
    80005a70:	fc040793          	addi	a5,s0,-64
    80005a74:	9abe                	add	s5,s5,a5
    80005a76:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005a7a:	e4040593          	addi	a1,s0,-448
    80005a7e:	f4040513          	addi	a0,s0,-192
    80005a82:	fffff097          	auipc	ra,0xfffff
    80005a86:	196080e7          	jalr	406(ra) # 80004c18 <exec>
    80005a8a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a8c:	10048993          	addi	s3,s1,256
    80005a90:	6088                	ld	a0,0(s1)
    80005a92:	c911                	beqz	a0,80005aa6 <sys_exec+0xfa>
    kfree(argv[i]);
    80005a94:	ffffb097          	auipc	ra,0xffffb
    80005a98:	f84080e7          	jalr	-124(ra) # 80000a18 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a9c:	04a1                	addi	s1,s1,8
    80005a9e:	ff3499e3          	bne	s1,s3,80005a90 <sys_exec+0xe4>
    80005aa2:	a011                	j	80005aa6 <sys_exec+0xfa>
  return -1;
    80005aa4:	597d                	li	s2,-1
}
    80005aa6:	854a                	mv	a0,s2
    80005aa8:	60be                	ld	ra,456(sp)
    80005aaa:	641e                	ld	s0,448(sp)
    80005aac:	74fa                	ld	s1,440(sp)
    80005aae:	795a                	ld	s2,432(sp)
    80005ab0:	79ba                	ld	s3,424(sp)
    80005ab2:	7a1a                	ld	s4,416(sp)
    80005ab4:	6afa                	ld	s5,408(sp)
    80005ab6:	6179                	addi	sp,sp,464
    80005ab8:	8082                	ret

0000000080005aba <sys_pipe>:

uint64
sys_pipe(void)
{
    80005aba:	7139                	addi	sp,sp,-64
    80005abc:	fc06                	sd	ra,56(sp)
    80005abe:	f822                	sd	s0,48(sp)
    80005ac0:	f426                	sd	s1,40(sp)
    80005ac2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ac4:	ffffc097          	auipc	ra,0xffffc
    80005ac8:	fce080e7          	jalr	-50(ra) # 80001a92 <myproc>
    80005acc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005ace:	fd840593          	addi	a1,s0,-40
    80005ad2:	4501                	li	a0,0
    80005ad4:	ffffd097          	auipc	ra,0xffffd
    80005ad8:	0a2080e7          	jalr	162(ra) # 80002b76 <argaddr>
    return -1;
    80005adc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005ade:	0e054063          	bltz	a0,80005bbe <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005ae2:	fc840593          	addi	a1,s0,-56
    80005ae6:	fd040513          	addi	a0,s0,-48
    80005aea:	fffff097          	auipc	ra,0xfffff
    80005aee:	dd8080e7          	jalr	-552(ra) # 800048c2 <pipealloc>
    return -1;
    80005af2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005af4:	0c054563          	bltz	a0,80005bbe <sys_pipe+0x104>
  fd0 = -1;
    80005af8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005afc:	fd043503          	ld	a0,-48(s0)
    80005b00:	fffff097          	auipc	ra,0xfffff
    80005b04:	50a080e7          	jalr	1290(ra) # 8000500a <fdalloc>
    80005b08:	fca42223          	sw	a0,-60(s0)
    80005b0c:	08054c63          	bltz	a0,80005ba4 <sys_pipe+0xea>
    80005b10:	fc843503          	ld	a0,-56(s0)
    80005b14:	fffff097          	auipc	ra,0xfffff
    80005b18:	4f6080e7          	jalr	1270(ra) # 8000500a <fdalloc>
    80005b1c:	fca42023          	sw	a0,-64(s0)
    80005b20:	06054863          	bltz	a0,80005b90 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b24:	4691                	li	a3,4
    80005b26:	fc440613          	addi	a2,s0,-60
    80005b2a:	fd843583          	ld	a1,-40(s0)
    80005b2e:	68a8                	ld	a0,80(s1)
    80005b30:	ffffc097          	auipc	ra,0xffffc
    80005b34:	b96080e7          	jalr	-1130(ra) # 800016c6 <copyout>
    80005b38:	02054063          	bltz	a0,80005b58 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b3c:	4691                	li	a3,4
    80005b3e:	fc040613          	addi	a2,s0,-64
    80005b42:	fd843583          	ld	a1,-40(s0)
    80005b46:	0591                	addi	a1,a1,4
    80005b48:	68a8                	ld	a0,80(s1)
    80005b4a:	ffffc097          	auipc	ra,0xffffc
    80005b4e:	b7c080e7          	jalr	-1156(ra) # 800016c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b52:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b54:	06055563          	bgez	a0,80005bbe <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005b58:	fc442783          	lw	a5,-60(s0)
    80005b5c:	07e9                	addi	a5,a5,26
    80005b5e:	078e                	slli	a5,a5,0x3
    80005b60:	97a6                	add	a5,a5,s1
    80005b62:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005b66:	fc042503          	lw	a0,-64(s0)
    80005b6a:	0569                	addi	a0,a0,26
    80005b6c:	050e                	slli	a0,a0,0x3
    80005b6e:	9526                	add	a0,a0,s1
    80005b70:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005b74:	fd043503          	ld	a0,-48(s0)
    80005b78:	fffff097          	auipc	ra,0xfffff
    80005b7c:	9f4080e7          	jalr	-1548(ra) # 8000456c <fileclose>
    fileclose(wf);
    80005b80:	fc843503          	ld	a0,-56(s0)
    80005b84:	fffff097          	auipc	ra,0xfffff
    80005b88:	9e8080e7          	jalr	-1560(ra) # 8000456c <fileclose>
    return -1;
    80005b8c:	57fd                	li	a5,-1
    80005b8e:	a805                	j	80005bbe <sys_pipe+0x104>
    if(fd0 >= 0)
    80005b90:	fc442783          	lw	a5,-60(s0)
    80005b94:	0007c863          	bltz	a5,80005ba4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005b98:	01a78513          	addi	a0,a5,26
    80005b9c:	050e                	slli	a0,a0,0x3
    80005b9e:	9526                	add	a0,a0,s1
    80005ba0:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005ba4:	fd043503          	ld	a0,-48(s0)
    80005ba8:	fffff097          	auipc	ra,0xfffff
    80005bac:	9c4080e7          	jalr	-1596(ra) # 8000456c <fileclose>
    fileclose(wf);
    80005bb0:	fc843503          	ld	a0,-56(s0)
    80005bb4:	fffff097          	auipc	ra,0xfffff
    80005bb8:	9b8080e7          	jalr	-1608(ra) # 8000456c <fileclose>
    return -1;
    80005bbc:	57fd                	li	a5,-1
}
    80005bbe:	853e                	mv	a0,a5
    80005bc0:	70e2                	ld	ra,56(sp)
    80005bc2:	7442                	ld	s0,48(sp)
    80005bc4:	74a2                	ld	s1,40(sp)
    80005bc6:	6121                	addi	sp,sp,64
    80005bc8:	8082                	ret
    80005bca:	0000                	unimp
    80005bcc:	0000                	unimp
	...

0000000080005bd0 <kernelvec>:
    80005bd0:	7111                	addi	sp,sp,-256
    80005bd2:	e006                	sd	ra,0(sp)
    80005bd4:	e40a                	sd	sp,8(sp)
    80005bd6:	e80e                	sd	gp,16(sp)
    80005bd8:	ec12                	sd	tp,24(sp)
    80005bda:	f016                	sd	t0,32(sp)
    80005bdc:	f41a                	sd	t1,40(sp)
    80005bde:	f81e                	sd	t2,48(sp)
    80005be0:	fc22                	sd	s0,56(sp)
    80005be2:	e0a6                	sd	s1,64(sp)
    80005be4:	e4aa                	sd	a0,72(sp)
    80005be6:	e8ae                	sd	a1,80(sp)
    80005be8:	ecb2                	sd	a2,88(sp)
    80005bea:	f0b6                	sd	a3,96(sp)
    80005bec:	f4ba                	sd	a4,104(sp)
    80005bee:	f8be                	sd	a5,112(sp)
    80005bf0:	fcc2                	sd	a6,120(sp)
    80005bf2:	e146                	sd	a7,128(sp)
    80005bf4:	e54a                	sd	s2,136(sp)
    80005bf6:	e94e                	sd	s3,144(sp)
    80005bf8:	ed52                	sd	s4,152(sp)
    80005bfa:	f156                	sd	s5,160(sp)
    80005bfc:	f55a                	sd	s6,168(sp)
    80005bfe:	f95e                	sd	s7,176(sp)
    80005c00:	fd62                	sd	s8,184(sp)
    80005c02:	e1e6                	sd	s9,192(sp)
    80005c04:	e5ea                	sd	s10,200(sp)
    80005c06:	e9ee                	sd	s11,208(sp)
    80005c08:	edf2                	sd	t3,216(sp)
    80005c0a:	f1f6                	sd	t4,224(sp)
    80005c0c:	f5fa                	sd	t5,232(sp)
    80005c0e:	f9fe                	sd	t6,240(sp)
    80005c10:	d77fc0ef          	jal	ra,80002986 <kerneltrap>
    80005c14:	6082                	ld	ra,0(sp)
    80005c16:	6122                	ld	sp,8(sp)
    80005c18:	61c2                	ld	gp,16(sp)
    80005c1a:	7282                	ld	t0,32(sp)
    80005c1c:	7322                	ld	t1,40(sp)
    80005c1e:	73c2                	ld	t2,48(sp)
    80005c20:	7462                	ld	s0,56(sp)
    80005c22:	6486                	ld	s1,64(sp)
    80005c24:	6526                	ld	a0,72(sp)
    80005c26:	65c6                	ld	a1,80(sp)
    80005c28:	6666                	ld	a2,88(sp)
    80005c2a:	7686                	ld	a3,96(sp)
    80005c2c:	7726                	ld	a4,104(sp)
    80005c2e:	77c6                	ld	a5,112(sp)
    80005c30:	7866                	ld	a6,120(sp)
    80005c32:	688a                	ld	a7,128(sp)
    80005c34:	692a                	ld	s2,136(sp)
    80005c36:	69ca                	ld	s3,144(sp)
    80005c38:	6a6a                	ld	s4,152(sp)
    80005c3a:	7a8a                	ld	s5,160(sp)
    80005c3c:	7b2a                	ld	s6,168(sp)
    80005c3e:	7bca                	ld	s7,176(sp)
    80005c40:	7c6a                	ld	s8,184(sp)
    80005c42:	6c8e                	ld	s9,192(sp)
    80005c44:	6d2e                	ld	s10,200(sp)
    80005c46:	6dce                	ld	s11,208(sp)
    80005c48:	6e6e                	ld	t3,216(sp)
    80005c4a:	7e8e                	ld	t4,224(sp)
    80005c4c:	7f2e                	ld	t5,232(sp)
    80005c4e:	7fce                	ld	t6,240(sp)
    80005c50:	6111                	addi	sp,sp,256
    80005c52:	10200073          	sret
    80005c56:	00000013          	nop
    80005c5a:	00000013          	nop
    80005c5e:	0001                	nop

0000000080005c60 <timervec>:
    80005c60:	34051573          	csrrw	a0,mscratch,a0
    80005c64:	e10c                	sd	a1,0(a0)
    80005c66:	e510                	sd	a2,8(a0)
    80005c68:	e914                	sd	a3,16(a0)
    80005c6a:	710c                	ld	a1,32(a0)
    80005c6c:	7510                	ld	a2,40(a0)
    80005c6e:	6194                	ld	a3,0(a1)
    80005c70:	96b2                	add	a3,a3,a2
    80005c72:	e194                	sd	a3,0(a1)
    80005c74:	4589                	li	a1,2
    80005c76:	14459073          	csrw	sip,a1
    80005c7a:	6914                	ld	a3,16(a0)
    80005c7c:	6510                	ld	a2,8(a0)
    80005c7e:	610c                	ld	a1,0(a0)
    80005c80:	34051573          	csrrw	a0,mscratch,a0
    80005c84:	30200073          	mret
	...

0000000080005c8a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c8a:	1141                	addi	sp,sp,-16
    80005c8c:	e422                	sd	s0,8(sp)
    80005c8e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c90:	0c0007b7          	lui	a5,0xc000
    80005c94:	4705                	li	a4,1
    80005c96:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c98:	c3d8                	sw	a4,4(a5)
}
    80005c9a:	6422                	ld	s0,8(sp)
    80005c9c:	0141                	addi	sp,sp,16
    80005c9e:	8082                	ret

0000000080005ca0 <plicinithart>:

void
plicinithart(void)
{
    80005ca0:	1141                	addi	sp,sp,-16
    80005ca2:	e406                	sd	ra,8(sp)
    80005ca4:	e022                	sd	s0,0(sp)
    80005ca6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005ca8:	ffffc097          	auipc	ra,0xffffc
    80005cac:	dbe080e7          	jalr	-578(ra) # 80001a66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005cb0:	0085171b          	slliw	a4,a0,0x8
    80005cb4:	0c0027b7          	lui	a5,0xc002
    80005cb8:	97ba                	add	a5,a5,a4
    80005cba:	40200713          	li	a4,1026
    80005cbe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005cc2:	00d5151b          	slliw	a0,a0,0xd
    80005cc6:	0c2017b7          	lui	a5,0xc201
    80005cca:	953e                	add	a0,a0,a5
    80005ccc:	00052023          	sw	zero,0(a0)
}
    80005cd0:	60a2                	ld	ra,8(sp)
    80005cd2:	6402                	ld	s0,0(sp)
    80005cd4:	0141                	addi	sp,sp,16
    80005cd6:	8082                	ret

0000000080005cd8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005cd8:	1141                	addi	sp,sp,-16
    80005cda:	e406                	sd	ra,8(sp)
    80005cdc:	e022                	sd	s0,0(sp)
    80005cde:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005ce0:	ffffc097          	auipc	ra,0xffffc
    80005ce4:	d86080e7          	jalr	-634(ra) # 80001a66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005ce8:	00d5179b          	slliw	a5,a0,0xd
    80005cec:	0c201537          	lui	a0,0xc201
    80005cf0:	953e                	add	a0,a0,a5
  return irq;
}
    80005cf2:	4148                	lw	a0,4(a0)
    80005cf4:	60a2                	ld	ra,8(sp)
    80005cf6:	6402                	ld	s0,0(sp)
    80005cf8:	0141                	addi	sp,sp,16
    80005cfa:	8082                	ret

0000000080005cfc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005cfc:	1101                	addi	sp,sp,-32
    80005cfe:	ec06                	sd	ra,24(sp)
    80005d00:	e822                	sd	s0,16(sp)
    80005d02:	e426                	sd	s1,8(sp)
    80005d04:	1000                	addi	s0,sp,32
    80005d06:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d08:	ffffc097          	auipc	ra,0xffffc
    80005d0c:	d5e080e7          	jalr	-674(ra) # 80001a66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d10:	00d5151b          	slliw	a0,a0,0xd
    80005d14:	0c2017b7          	lui	a5,0xc201
    80005d18:	97aa                	add	a5,a5,a0
    80005d1a:	c3c4                	sw	s1,4(a5)
}
    80005d1c:	60e2                	ld	ra,24(sp)
    80005d1e:	6442                	ld	s0,16(sp)
    80005d20:	64a2                	ld	s1,8(sp)
    80005d22:	6105                	addi	sp,sp,32
    80005d24:	8082                	ret

0000000080005d26 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d26:	1141                	addi	sp,sp,-16
    80005d28:	e406                	sd	ra,8(sp)
    80005d2a:	e022                	sd	s0,0(sp)
    80005d2c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d2e:	479d                	li	a5,7
    80005d30:	04a7cc63          	blt	a5,a0,80005d88 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005d34:	0001d797          	auipc	a5,0x1d
    80005d38:	2cc78793          	addi	a5,a5,716 # 80023000 <disk>
    80005d3c:	00a78733          	add	a4,a5,a0
    80005d40:	6789                	lui	a5,0x2
    80005d42:	97ba                	add	a5,a5,a4
    80005d44:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005d48:	eba1                	bnez	a5,80005d98 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005d4a:	00451713          	slli	a4,a0,0x4
    80005d4e:	0001f797          	auipc	a5,0x1f
    80005d52:	2b27b783          	ld	a5,690(a5) # 80025000 <disk+0x2000>
    80005d56:	97ba                	add	a5,a5,a4
    80005d58:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005d5c:	0001d797          	auipc	a5,0x1d
    80005d60:	2a478793          	addi	a5,a5,676 # 80023000 <disk>
    80005d64:	97aa                	add	a5,a5,a0
    80005d66:	6509                	lui	a0,0x2
    80005d68:	953e                	add	a0,a0,a5
    80005d6a:	4785                	li	a5,1
    80005d6c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005d70:	0001f517          	auipc	a0,0x1f
    80005d74:	2a850513          	addi	a0,a0,680 # 80025018 <disk+0x2018>
    80005d78:	ffffc097          	auipc	ra,0xffffc
    80005d7c:	688080e7          	jalr	1672(ra) # 80002400 <wakeup>
}
    80005d80:	60a2                	ld	ra,8(sp)
    80005d82:	6402                	ld	s0,0(sp)
    80005d84:	0141                	addi	sp,sp,16
    80005d86:	8082                	ret
    panic("virtio_disk_intr 1");
    80005d88:	00003517          	auipc	a0,0x3
    80005d8c:	a3050513          	addi	a0,a0,-1488 # 800087b8 <syscalls+0x338>
    80005d90:	ffffa097          	auipc	ra,0xffffa
    80005d94:	7c4080e7          	jalr	1988(ra) # 80000554 <panic>
    panic("virtio_disk_intr 2");
    80005d98:	00003517          	auipc	a0,0x3
    80005d9c:	a3850513          	addi	a0,a0,-1480 # 800087d0 <syscalls+0x350>
    80005da0:	ffffa097          	auipc	ra,0xffffa
    80005da4:	7b4080e7          	jalr	1972(ra) # 80000554 <panic>

0000000080005da8 <virtio_disk_init>:
{
    80005da8:	1101                	addi	sp,sp,-32
    80005daa:	ec06                	sd	ra,24(sp)
    80005dac:	e822                	sd	s0,16(sp)
    80005dae:	e426                	sd	s1,8(sp)
    80005db0:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005db2:	00003597          	auipc	a1,0x3
    80005db6:	a3658593          	addi	a1,a1,-1482 # 800087e8 <syscalls+0x368>
    80005dba:	0001f517          	auipc	a0,0x1f
    80005dbe:	2ee50513          	addi	a0,a0,750 # 800250a8 <disk+0x20a8>
    80005dc2:	ffffb097          	auipc	ra,0xffffb
    80005dc6:	db2080e7          	jalr	-590(ra) # 80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dca:	100017b7          	lui	a5,0x10001
    80005dce:	4398                	lw	a4,0(a5)
    80005dd0:	2701                	sext.w	a4,a4
    80005dd2:	747277b7          	lui	a5,0x74727
    80005dd6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005dda:	0ef71163          	bne	a4,a5,80005ebc <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005dde:	100017b7          	lui	a5,0x10001
    80005de2:	43dc                	lw	a5,4(a5)
    80005de4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005de6:	4705                	li	a4,1
    80005de8:	0ce79a63          	bne	a5,a4,80005ebc <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dec:	100017b7          	lui	a5,0x10001
    80005df0:	479c                	lw	a5,8(a5)
    80005df2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005df4:	4709                	li	a4,2
    80005df6:	0ce79363          	bne	a5,a4,80005ebc <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005dfa:	100017b7          	lui	a5,0x10001
    80005dfe:	47d8                	lw	a4,12(a5)
    80005e00:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e02:	554d47b7          	lui	a5,0x554d4
    80005e06:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e0a:	0af71963          	bne	a4,a5,80005ebc <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e0e:	100017b7          	lui	a5,0x10001
    80005e12:	4705                	li	a4,1
    80005e14:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e16:	470d                	li	a4,3
    80005e18:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e1a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e1c:	c7ffe737          	lui	a4,0xc7ffe
    80005e20:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005e24:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e26:	2701                	sext.w	a4,a4
    80005e28:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e2a:	472d                	li	a4,11
    80005e2c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e2e:	473d                	li	a4,15
    80005e30:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005e32:	6705                	lui	a4,0x1
    80005e34:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e36:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e3a:	5bdc                	lw	a5,52(a5)
    80005e3c:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e3e:	c7d9                	beqz	a5,80005ecc <virtio_disk_init+0x124>
  if(max < NUM)
    80005e40:	471d                	li	a4,7
    80005e42:	08f77d63          	bgeu	a4,a5,80005edc <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e46:	100014b7          	lui	s1,0x10001
    80005e4a:	47a1                	li	a5,8
    80005e4c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005e4e:	6609                	lui	a2,0x2
    80005e50:	4581                	li	a1,0
    80005e52:	0001d517          	auipc	a0,0x1d
    80005e56:	1ae50513          	addi	a0,a0,430 # 80023000 <disk>
    80005e5a:	ffffb097          	auipc	ra,0xffffb
    80005e5e:	ea6080e7          	jalr	-346(ra) # 80000d00 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005e62:	0001d717          	auipc	a4,0x1d
    80005e66:	19e70713          	addi	a4,a4,414 # 80023000 <disk>
    80005e6a:	00c75793          	srli	a5,a4,0xc
    80005e6e:	2781                	sext.w	a5,a5
    80005e70:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005e72:	0001f797          	auipc	a5,0x1f
    80005e76:	18e78793          	addi	a5,a5,398 # 80025000 <disk+0x2000>
    80005e7a:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005e7c:	0001d717          	auipc	a4,0x1d
    80005e80:	20470713          	addi	a4,a4,516 # 80023080 <disk+0x80>
    80005e84:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005e86:	0001e717          	auipc	a4,0x1e
    80005e8a:	17a70713          	addi	a4,a4,378 # 80024000 <disk+0x1000>
    80005e8e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005e90:	4705                	li	a4,1
    80005e92:	00e78c23          	sb	a4,24(a5)
    80005e96:	00e78ca3          	sb	a4,25(a5)
    80005e9a:	00e78d23          	sb	a4,26(a5)
    80005e9e:	00e78da3          	sb	a4,27(a5)
    80005ea2:	00e78e23          	sb	a4,28(a5)
    80005ea6:	00e78ea3          	sb	a4,29(a5)
    80005eaa:	00e78f23          	sb	a4,30(a5)
    80005eae:	00e78fa3          	sb	a4,31(a5)
}
    80005eb2:	60e2                	ld	ra,24(sp)
    80005eb4:	6442                	ld	s0,16(sp)
    80005eb6:	64a2                	ld	s1,8(sp)
    80005eb8:	6105                	addi	sp,sp,32
    80005eba:	8082                	ret
    panic("could not find virtio disk");
    80005ebc:	00003517          	auipc	a0,0x3
    80005ec0:	93c50513          	addi	a0,a0,-1732 # 800087f8 <syscalls+0x378>
    80005ec4:	ffffa097          	auipc	ra,0xffffa
    80005ec8:	690080e7          	jalr	1680(ra) # 80000554 <panic>
    panic("virtio disk has no queue 0");
    80005ecc:	00003517          	auipc	a0,0x3
    80005ed0:	94c50513          	addi	a0,a0,-1716 # 80008818 <syscalls+0x398>
    80005ed4:	ffffa097          	auipc	ra,0xffffa
    80005ed8:	680080e7          	jalr	1664(ra) # 80000554 <panic>
    panic("virtio disk max queue too short");
    80005edc:	00003517          	auipc	a0,0x3
    80005ee0:	95c50513          	addi	a0,a0,-1700 # 80008838 <syscalls+0x3b8>
    80005ee4:	ffffa097          	auipc	ra,0xffffa
    80005ee8:	670080e7          	jalr	1648(ra) # 80000554 <panic>

0000000080005eec <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005eec:	7119                	addi	sp,sp,-128
    80005eee:	fc86                	sd	ra,120(sp)
    80005ef0:	f8a2                	sd	s0,112(sp)
    80005ef2:	f4a6                	sd	s1,104(sp)
    80005ef4:	f0ca                	sd	s2,96(sp)
    80005ef6:	ecce                	sd	s3,88(sp)
    80005ef8:	e8d2                	sd	s4,80(sp)
    80005efa:	e4d6                	sd	s5,72(sp)
    80005efc:	e0da                	sd	s6,64(sp)
    80005efe:	fc5e                	sd	s7,56(sp)
    80005f00:	f862                	sd	s8,48(sp)
    80005f02:	f466                	sd	s9,40(sp)
    80005f04:	f06a                	sd	s10,32(sp)
    80005f06:	0100                	addi	s0,sp,128
    80005f08:	892a                	mv	s2,a0
    80005f0a:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f0c:	00c52c83          	lw	s9,12(a0)
    80005f10:	001c9c9b          	slliw	s9,s9,0x1
    80005f14:	1c82                	slli	s9,s9,0x20
    80005f16:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005f1a:	0001f517          	auipc	a0,0x1f
    80005f1e:	18e50513          	addi	a0,a0,398 # 800250a8 <disk+0x20a8>
    80005f22:	ffffb097          	auipc	ra,0xffffb
    80005f26:	ce2080e7          	jalr	-798(ra) # 80000c04 <acquire>
  for(int i = 0; i < 3; i++){
    80005f2a:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005f2c:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005f2e:	0001db97          	auipc	s7,0x1d
    80005f32:	0d2b8b93          	addi	s7,s7,210 # 80023000 <disk>
    80005f36:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005f38:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005f3a:	8a4e                	mv	s4,s3
    80005f3c:	a051                	j	80005fc0 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005f3e:	00fb86b3          	add	a3,s7,a5
    80005f42:	96da                	add	a3,a3,s6
    80005f44:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005f48:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005f4a:	0207c563          	bltz	a5,80005f74 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005f4e:	2485                	addiw	s1,s1,1
    80005f50:	0711                	addi	a4,a4,4
    80005f52:	1b548863          	beq	s1,s5,80006102 <virtio_disk_rw+0x216>
    idx[i] = alloc_desc();
    80005f56:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005f58:	0001f697          	auipc	a3,0x1f
    80005f5c:	0c068693          	addi	a3,a3,192 # 80025018 <disk+0x2018>
    80005f60:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005f62:	0006c583          	lbu	a1,0(a3)
    80005f66:	fde1                	bnez	a1,80005f3e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005f68:	2785                	addiw	a5,a5,1
    80005f6a:	0685                	addi	a3,a3,1
    80005f6c:	ff879be3          	bne	a5,s8,80005f62 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005f70:	57fd                	li	a5,-1
    80005f72:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005f74:	02905a63          	blez	s1,80005fa8 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005f78:	f9042503          	lw	a0,-112(s0)
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	daa080e7          	jalr	-598(ra) # 80005d26 <free_desc>
      for(int j = 0; j < i; j++)
    80005f84:	4785                	li	a5,1
    80005f86:	0297d163          	bge	a5,s1,80005fa8 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005f8a:	f9442503          	lw	a0,-108(s0)
    80005f8e:	00000097          	auipc	ra,0x0
    80005f92:	d98080e7          	jalr	-616(ra) # 80005d26 <free_desc>
      for(int j = 0; j < i; j++)
    80005f96:	4789                	li	a5,2
    80005f98:	0097d863          	bge	a5,s1,80005fa8 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005f9c:	f9842503          	lw	a0,-104(s0)
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	d86080e7          	jalr	-634(ra) # 80005d26 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005fa8:	0001f597          	auipc	a1,0x1f
    80005fac:	10058593          	addi	a1,a1,256 # 800250a8 <disk+0x20a8>
    80005fb0:	0001f517          	auipc	a0,0x1f
    80005fb4:	06850513          	addi	a0,a0,104 # 80025018 <disk+0x2018>
    80005fb8:	ffffc097          	auipc	ra,0xffffc
    80005fbc:	2c2080e7          	jalr	706(ra) # 8000227a <sleep>
  for(int i = 0; i < 3; i++){
    80005fc0:	f9040713          	addi	a4,s0,-112
    80005fc4:	84ce                	mv	s1,s3
    80005fc6:	bf41                	j	80005f56 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005fc8:	0001f717          	auipc	a4,0x1f
    80005fcc:	03873703          	ld	a4,56(a4) # 80025000 <disk+0x2000>
    80005fd0:	973e                	add	a4,a4,a5
    80005fd2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005fd6:	0001d517          	auipc	a0,0x1d
    80005fda:	02a50513          	addi	a0,a0,42 # 80023000 <disk>
    80005fde:	0001f717          	auipc	a4,0x1f
    80005fe2:	02270713          	addi	a4,a4,34 # 80025000 <disk+0x2000>
    80005fe6:	6310                	ld	a2,0(a4)
    80005fe8:	963e                	add	a2,a2,a5
    80005fea:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005fee:	0015e593          	ori	a1,a1,1
    80005ff2:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005ff6:	f9842683          	lw	a3,-104(s0)
    80005ffa:	6310                	ld	a2,0(a4)
    80005ffc:	97b2                	add	a5,a5,a2
    80005ffe:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80006002:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80006006:	0612                	slli	a2,a2,0x4
    80006008:	962a                	add	a2,a2,a0
    8000600a:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000600e:	00469793          	slli	a5,a3,0x4
    80006012:	630c                	ld	a1,0(a4)
    80006014:	95be                	add	a1,a1,a5
    80006016:	6689                	lui	a3,0x2
    80006018:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    8000601c:	96ce                	add	a3,a3,s3
    8000601e:	96aa                	add	a3,a3,a0
    80006020:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80006022:	6314                	ld	a3,0(a4)
    80006024:	96be                	add	a3,a3,a5
    80006026:	4585                	li	a1,1
    80006028:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000602a:	6314                	ld	a3,0(a4)
    8000602c:	96be                	add	a3,a3,a5
    8000602e:	4509                	li	a0,2
    80006030:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80006034:	6314                	ld	a3,0(a4)
    80006036:	97b6                	add	a5,a5,a3
    80006038:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000603c:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006040:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80006044:	6714                	ld	a3,8(a4)
    80006046:	0026d783          	lhu	a5,2(a3)
    8000604a:	8b9d                	andi	a5,a5,7
    8000604c:	0789                	addi	a5,a5,2
    8000604e:	0786                	slli	a5,a5,0x1
    80006050:	97b6                	add	a5,a5,a3
    80006052:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80006056:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000605a:	6718                	ld	a4,8(a4)
    8000605c:	00275783          	lhu	a5,2(a4)
    80006060:	2785                	addiw	a5,a5,1
    80006062:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006066:	100017b7          	lui	a5,0x10001
    8000606a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000606e:	00492783          	lw	a5,4(s2)
    80006072:	02b79163          	bne	a5,a1,80006094 <virtio_disk_rw+0x1a8>
    sleep(b, &disk.vdisk_lock);
    80006076:	0001f997          	auipc	s3,0x1f
    8000607a:	03298993          	addi	s3,s3,50 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    8000607e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006080:	85ce                	mv	a1,s3
    80006082:	854a                	mv	a0,s2
    80006084:	ffffc097          	auipc	ra,0xffffc
    80006088:	1f6080e7          	jalr	502(ra) # 8000227a <sleep>
  while(b->disk == 1) {
    8000608c:	00492783          	lw	a5,4(s2)
    80006090:	fe9788e3          	beq	a5,s1,80006080 <virtio_disk_rw+0x194>
  }

  disk.info[idx[0]].b = 0;
    80006094:	f9042483          	lw	s1,-112(s0)
    80006098:	20048793          	addi	a5,s1,512
    8000609c:	00479713          	slli	a4,a5,0x4
    800060a0:	0001d797          	auipc	a5,0x1d
    800060a4:	f6078793          	addi	a5,a5,-160 # 80023000 <disk>
    800060a8:	97ba                	add	a5,a5,a4
    800060aa:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800060ae:	0001f917          	auipc	s2,0x1f
    800060b2:	f5290913          	addi	s2,s2,-174 # 80025000 <disk+0x2000>
    free_desc(i);
    800060b6:	8526                	mv	a0,s1
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	c6e080e7          	jalr	-914(ra) # 80005d26 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800060c0:	0492                	slli	s1,s1,0x4
    800060c2:	00093783          	ld	a5,0(s2)
    800060c6:	94be                	add	s1,s1,a5
    800060c8:	00c4d783          	lhu	a5,12(s1)
    800060cc:	8b85                	andi	a5,a5,1
    800060ce:	c781                	beqz	a5,800060d6 <virtio_disk_rw+0x1ea>
      i = disk.desc[i].next;
    800060d0:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    800060d4:	b7cd                	j	800060b6 <virtio_disk_rw+0x1ca>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800060d6:	0001f517          	auipc	a0,0x1f
    800060da:	fd250513          	addi	a0,a0,-46 # 800250a8 <disk+0x20a8>
    800060de:	ffffb097          	auipc	ra,0xffffb
    800060e2:	bda080e7          	jalr	-1062(ra) # 80000cb8 <release>
}
    800060e6:	70e6                	ld	ra,120(sp)
    800060e8:	7446                	ld	s0,112(sp)
    800060ea:	74a6                	ld	s1,104(sp)
    800060ec:	7906                	ld	s2,96(sp)
    800060ee:	69e6                	ld	s3,88(sp)
    800060f0:	6a46                	ld	s4,80(sp)
    800060f2:	6aa6                	ld	s5,72(sp)
    800060f4:	6b06                	ld	s6,64(sp)
    800060f6:	7be2                	ld	s7,56(sp)
    800060f8:	7c42                	ld	s8,48(sp)
    800060fa:	7ca2                	ld	s9,40(sp)
    800060fc:	7d02                	ld	s10,32(sp)
    800060fe:	6109                	addi	sp,sp,128
    80006100:	8082                	ret
  if(write)
    80006102:	01a037b3          	snez	a5,s10
    80006106:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    8000610a:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    8000610e:	f9943423          	sd	s9,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006112:	f9042483          	lw	s1,-112(s0)
    80006116:	00449993          	slli	s3,s1,0x4
    8000611a:	0001fa17          	auipc	s4,0x1f
    8000611e:	ee6a0a13          	addi	s4,s4,-282 # 80025000 <disk+0x2000>
    80006122:	000a3a83          	ld	s5,0(s4)
    80006126:	9ace                	add	s5,s5,s3
    80006128:	f8040513          	addi	a0,s0,-128
    8000612c:	ffffb097          	auipc	ra,0xffffb
    80006130:	fa8080e7          	jalr	-88(ra) # 800010d4 <kvmpa>
    80006134:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006138:	000a3783          	ld	a5,0(s4)
    8000613c:	97ce                	add	a5,a5,s3
    8000613e:	4741                	li	a4,16
    80006140:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006142:	000a3783          	ld	a5,0(s4)
    80006146:	97ce                	add	a5,a5,s3
    80006148:	4705                	li	a4,1
    8000614a:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000614e:	f9442783          	lw	a5,-108(s0)
    80006152:	000a3703          	ld	a4,0(s4)
    80006156:	974e                	add	a4,a4,s3
    80006158:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000615c:	0792                	slli	a5,a5,0x4
    8000615e:	000a3703          	ld	a4,0(s4)
    80006162:	973e                	add	a4,a4,a5
    80006164:	05890693          	addi	a3,s2,88
    80006168:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000616a:	000a3703          	ld	a4,0(s4)
    8000616e:	973e                	add	a4,a4,a5
    80006170:	40000693          	li	a3,1024
    80006174:	c714                	sw	a3,8(a4)
  if(write)
    80006176:	e40d19e3          	bnez	s10,80005fc8 <virtio_disk_rw+0xdc>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000617a:	0001f717          	auipc	a4,0x1f
    8000617e:	e8673703          	ld	a4,-378(a4) # 80025000 <disk+0x2000>
    80006182:	973e                	add	a4,a4,a5
    80006184:	4689                	li	a3,2
    80006186:	00d71623          	sh	a3,12(a4)
    8000618a:	b5b1                	j	80005fd6 <virtio_disk_rw+0xea>

000000008000618c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000618c:	1101                	addi	sp,sp,-32
    8000618e:	ec06                	sd	ra,24(sp)
    80006190:	e822                	sd	s0,16(sp)
    80006192:	e426                	sd	s1,8(sp)
    80006194:	e04a                	sd	s2,0(sp)
    80006196:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006198:	0001f517          	auipc	a0,0x1f
    8000619c:	f1050513          	addi	a0,a0,-240 # 800250a8 <disk+0x20a8>
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	a64080e7          	jalr	-1436(ra) # 80000c04 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800061a8:	0001f717          	auipc	a4,0x1f
    800061ac:	e5870713          	addi	a4,a4,-424 # 80025000 <disk+0x2000>
    800061b0:	02075783          	lhu	a5,32(a4)
    800061b4:	6b18                	ld	a4,16(a4)
    800061b6:	00275683          	lhu	a3,2(a4)
    800061ba:	8ebd                	xor	a3,a3,a5
    800061bc:	8a9d                	andi	a3,a3,7
    800061be:	cab9                	beqz	a3,80006214 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    800061c0:	0001d917          	auipc	s2,0x1d
    800061c4:	e4090913          	addi	s2,s2,-448 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800061c8:	0001f497          	auipc	s1,0x1f
    800061cc:	e3848493          	addi	s1,s1,-456 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    800061d0:	078e                	slli	a5,a5,0x3
    800061d2:	97ba                	add	a5,a5,a4
    800061d4:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    800061d6:	20078713          	addi	a4,a5,512
    800061da:	0712                	slli	a4,a4,0x4
    800061dc:	974a                	add	a4,a4,s2
    800061de:	03074703          	lbu	a4,48(a4)
    800061e2:	ef21                	bnez	a4,8000623a <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800061e4:	20078793          	addi	a5,a5,512
    800061e8:	0792                	slli	a5,a5,0x4
    800061ea:	97ca                	add	a5,a5,s2
    800061ec:	7798                	ld	a4,40(a5)
    800061ee:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800061f2:	7788                	ld	a0,40(a5)
    800061f4:	ffffc097          	auipc	ra,0xffffc
    800061f8:	20c080e7          	jalr	524(ra) # 80002400 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800061fc:	0204d783          	lhu	a5,32(s1)
    80006200:	2785                	addiw	a5,a5,1
    80006202:	8b9d                	andi	a5,a5,7
    80006204:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006208:	6898                	ld	a4,16(s1)
    8000620a:	00275683          	lhu	a3,2(a4)
    8000620e:	8a9d                	andi	a3,a3,7
    80006210:	fcf690e3          	bne	a3,a5,800061d0 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006214:	10001737          	lui	a4,0x10001
    80006218:	533c                	lw	a5,96(a4)
    8000621a:	8b8d                	andi	a5,a5,3
    8000621c:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    8000621e:	0001f517          	auipc	a0,0x1f
    80006222:	e8a50513          	addi	a0,a0,-374 # 800250a8 <disk+0x20a8>
    80006226:	ffffb097          	auipc	ra,0xffffb
    8000622a:	a92080e7          	jalr	-1390(ra) # 80000cb8 <release>
}
    8000622e:	60e2                	ld	ra,24(sp)
    80006230:	6442                	ld	s0,16(sp)
    80006232:	64a2                	ld	s1,8(sp)
    80006234:	6902                	ld	s2,0(sp)
    80006236:	6105                	addi	sp,sp,32
    80006238:	8082                	ret
      panic("virtio_disk_intr status");
    8000623a:	00002517          	auipc	a0,0x2
    8000623e:	61e50513          	addi	a0,a0,1566 # 80008858 <syscalls+0x3d8>
    80006242:	ffffa097          	auipc	ra,0xffffa
    80006246:	312080e7          	jalr	786(ra) # 80000554 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
