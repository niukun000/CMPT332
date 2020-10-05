
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d4ec>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x2376>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd6bb>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	5d850513          	addi	a0,a0,1496 # 1638 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	e20080e7          	jalr	-480(ra) # eb0 <sbrk>
      98:	8a2a                	mv	s4,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	2b650513          	addi	a0,a0,694 # 1350 <malloc+0xea>
      a2:	00001097          	auipc	ra,0x1
      a6:	dee080e7          	jalr	-530(ra) # e90 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	2a650513          	addi	a0,a0,678 # 1350 <malloc+0xea>
      b2:	00001097          	auipc	ra,0x1
      b6:	de6080e7          	jalr	-538(ra) # e98 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	29c50513          	addi	a0,a0,668 # 1358 <malloc+0xf2>
      c4:	00001097          	auipc	ra,0x1
      c8:	0e4080e7          	jalr	228(ra) # 11a8 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d5a080e7          	jalr	-678(ra) # e28 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	29a50513          	addi	a0,a0,666 # 1370 <malloc+0x10a>
      de:	00001097          	auipc	ra,0x1
      e2:	dba080e7          	jalr	-582(ra) # e98 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	29a98993          	addi	s3,s3,666 # 1380 <malloc+0x11a>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	28898993          	addi	s3,s3,648 # 1378 <malloc+0x112>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	597d                	li	s2,-1
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
      sbrk(6011);
      fc:	6a85                	lui	s5,0x1
      fe:	77ba8a93          	addi	s5,s5,1915 # 177b <buf.1233+0x133>
     102:	a825                	j	13a <go+0xc2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     104:	20200593          	li	a1,514
     108:	00001517          	auipc	a0,0x1
     10c:	28050513          	addi	a0,a0,640 # 1388 <malloc+0x122>
     110:	00001097          	auipc	ra,0x1
     114:	d58080e7          	jalr	-680(ra) # e68 <open>
     118:	00001097          	auipc	ra,0x1
     11c:	d38080e7          	jalr	-712(ra) # e50 <close>
    iters++;
     120:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     122:	1f400793          	li	a5,500
     126:	02f4f7b3          	remu	a5,s1,a5
     12a:	eb81                	bnez	a5,13a <go+0xc2>
      write(1, which_child?"B":"A", 1);
     12c:	4605                	li	a2,1
     12e:	85ce                	mv	a1,s3
     130:	4505                	li	a0,1
     132:	00001097          	auipc	ra,0x1
     136:	d16080e7          	jalr	-746(ra) # e48 <write>
    int what = rand() % 23;
     13a:	00000097          	auipc	ra,0x0
     13e:	f1e080e7          	jalr	-226(ra) # 58 <rand>
     142:	47dd                	li	a5,23
     144:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     148:	4785                	li	a5,1
     14a:	faf50de3          	beq	a0,a5,104 <go+0x8c>
    } else if(what == 2){
     14e:	4789                	li	a5,2
     150:	16f50e63          	beq	a0,a5,2cc <go+0x254>
    } else if(what == 3){
     154:	478d                	li	a5,3
     156:	18f50a63          	beq	a0,a5,2ea <go+0x272>
    } else if(what == 4){
     15a:	4791                	li	a5,4
     15c:	1af50063          	beq	a0,a5,2fc <go+0x284>
    } else if(what == 5){
     160:	4795                	li	a5,5
     162:	1ef50463          	beq	a0,a5,34a <go+0x2d2>
    } else if(what == 6){
     166:	4799                	li	a5,6
     168:	20f50263          	beq	a0,a5,36c <go+0x2f4>
    } else if(what == 7){
     16c:	479d                	li	a5,7
     16e:	22f50063          	beq	a0,a5,38e <go+0x316>
    } else if(what == 8){
     172:	47a1                	li	a5,8
     174:	22f50963          	beq	a0,a5,3a6 <go+0x32e>
    } else if(what == 9){
     178:	47a5                	li	a5,9
     17a:	24f50263          	beq	a0,a5,3be <go+0x346>
    } else if(what == 10){
     17e:	47a9                	li	a5,10
     180:	26f50e63          	beq	a0,a5,3fc <go+0x384>
    } else if(what == 11){
     184:	47ad                	li	a5,11
     186:	2af50a63          	beq	a0,a5,43a <go+0x3c2>
    } else if(what == 12){
     18a:	47b1                	li	a5,12
     18c:	2cf50c63          	beq	a0,a5,464 <go+0x3ec>
    } else if(what == 13){
     190:	47b5                	li	a5,13
     192:	2ef50e63          	beq	a0,a5,48e <go+0x416>
    } else if(what == 14){
     196:	47b9                	li	a5,14
     198:	32f50963          	beq	a0,a5,4ca <go+0x452>
    } else if(what == 15){
     19c:	47bd                	li	a5,15
     19e:	36f50d63          	beq	a0,a5,518 <go+0x4a0>
    } else if(what == 16){
     1a2:	47c1                	li	a5,16
     1a4:	38f50063          	beq	a0,a5,524 <go+0x4ac>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1a8:	47c5                	li	a5,17
     1aa:	3af50063          	beq	a0,a5,54a <go+0x4d2>
        printf("chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     1ae:	47c9                	li	a5,18
     1b0:	42f50663          	beq	a0,a5,5dc <go+0x564>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b4:	47cd                	li	a5,19
     1b6:	46f50a63          	beq	a0,a5,62a <go+0x5b2>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1ba:	47d1                	li	a5,20
     1bc:	54f50b63          	beq	a0,a5,712 <go+0x69a>
      } else if(pid < 0){
        printf("fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c0:	47d5                	li	a5,21
     1c2:	5ef50963          	beq	a0,a5,7b4 <go+0x73c>
        printf("fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c6:	47d9                	li	a5,22
     1c8:	f4f51ce3          	bne	a0,a5,120 <go+0xa8>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1cc:	f9840513          	addi	a0,s0,-104
     1d0:	00001097          	auipc	ra,0x1
     1d4:	c68080e7          	jalr	-920(ra) # e38 <pipe>
     1d8:	6e054263          	bltz	a0,8bc <go+0x844>
        fprintf(2, "pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1dc:	fa040513          	addi	a0,s0,-96
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c58080e7          	jalr	-936(ra) # e38 <pipe>
     1e8:	6e054863          	bltz	a0,8d8 <go+0x860>
        fprintf(2, "pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ec:	00001097          	auipc	ra,0x1
     1f0:	c34080e7          	jalr	-972(ra) # e20 <fork>
      if(pid1 == 0){
     1f4:	70050063          	beqz	a0,8f4 <go+0x87c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1f8:	7a054863          	bltz	a0,9a8 <go+0x930>
        fprintf(2, "fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fc:	00001097          	auipc	ra,0x1
     200:	c24080e7          	jalr	-988(ra) # e20 <fork>
      if(pid2 == 0){
     204:	7c050063          	beqz	a0,9c4 <go+0x94c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     208:	08054ce3          	bltz	a0,aa0 <go+0xa28>
        fprintf(2, "fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20c:	f9842503          	lw	a0,-104(s0)
     210:	00001097          	auipc	ra,0x1
     214:	c40080e7          	jalr	-960(ra) # e50 <close>
      close(aa[1]);
     218:	f9c42503          	lw	a0,-100(s0)
     21c:	00001097          	auipc	ra,0x1
     220:	c34080e7          	jalr	-972(ra) # e50 <close>
      close(bb[1]);
     224:	fa442503          	lw	a0,-92(s0)
     228:	00001097          	auipc	ra,0x1
     22c:	c28080e7          	jalr	-984(ra) # e50 <close>
      char buf[3] = { 0, 0, 0 };
     230:	f8041823          	sh	zero,-112(s0)
     234:	f8040923          	sb	zero,-110(s0)
      read(bb[0], buf+0, 1);
     238:	4605                	li	a2,1
     23a:	f9040593          	addi	a1,s0,-112
     23e:	fa042503          	lw	a0,-96(s0)
     242:	00001097          	auipc	ra,0x1
     246:	bfe080e7          	jalr	-1026(ra) # e40 <read>
      read(bb[0], buf+1, 1);
     24a:	4605                	li	a2,1
     24c:	f9140593          	addi	a1,s0,-111
     250:	fa042503          	lw	a0,-96(s0)
     254:	00001097          	auipc	ra,0x1
     258:	bec080e7          	jalr	-1044(ra) # e40 <read>
      close(bb[0]);
     25c:	fa042503          	lw	a0,-96(s0)
     260:	00001097          	auipc	ra,0x1
     264:	bf0080e7          	jalr	-1040(ra) # e50 <close>
      int st1, st2;
      wait(&st1);
     268:	f9440513          	addi	a0,s0,-108
     26c:	00001097          	auipc	ra,0x1
     270:	bc4080e7          	jalr	-1084(ra) # e30 <wait>
      wait(&st2);
     274:	fa840513          	addi	a0,s0,-88
     278:	00001097          	auipc	ra,0x1
     27c:	bb8080e7          	jalr	-1096(ra) # e30 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi") != 0){
     280:	f9442783          	lw	a5,-108(s0)
     284:	fa842703          	lw	a4,-88(s0)
     288:	8fd9                	or	a5,a5,a4
     28a:	2781                	sext.w	a5,a5
     28c:	ef89                	bnez	a5,2a6 <go+0x22e>
     28e:	00001597          	auipc	a1,0x1
     292:	31258593          	addi	a1,a1,786 # 15a0 <malloc+0x33a>
     296:	f9040513          	addi	a0,s0,-112
     29a:	00001097          	auipc	ra,0x1
     29e:	934080e7          	jalr	-1740(ra) # bce <strcmp>
     2a2:	e6050fe3          	beqz	a0,120 <go+0xa8>
        printf("exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2a6:	f9040693          	addi	a3,s0,-112
     2aa:	fa842603          	lw	a2,-88(s0)
     2ae:	f9442583          	lw	a1,-108(s0)
     2b2:	00001517          	auipc	a0,0x1
     2b6:	33e50513          	addi	a0,a0,830 # 15f0 <malloc+0x38a>
     2ba:	00001097          	auipc	ra,0x1
     2be:	eee080e7          	jalr	-274(ra) # 11a8 <printf>
        exit(1);
     2c2:	4505                	li	a0,1
     2c4:	00001097          	auipc	ra,0x1
     2c8:	b64080e7          	jalr	-1180(ra) # e28 <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2cc:	20200593          	li	a1,514
     2d0:	00001517          	auipc	a0,0x1
     2d4:	0c850513          	addi	a0,a0,200 # 1398 <malloc+0x132>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	b90080e7          	jalr	-1136(ra) # e68 <open>
     2e0:	00001097          	auipc	ra,0x1
     2e4:	b70080e7          	jalr	-1168(ra) # e50 <close>
     2e8:	bd25                	j	120 <go+0xa8>
      unlink("grindir/../a");
     2ea:	00001517          	auipc	a0,0x1
     2ee:	09e50513          	addi	a0,a0,158 # 1388 <malloc+0x122>
     2f2:	00001097          	auipc	ra,0x1
     2f6:	b86080e7          	jalr	-1146(ra) # e78 <unlink>
     2fa:	b51d                	j	120 <go+0xa8>
      if(chdir("grindir") != 0){
     2fc:	00001517          	auipc	a0,0x1
     300:	05450513          	addi	a0,a0,84 # 1350 <malloc+0xea>
     304:	00001097          	auipc	ra,0x1
     308:	b94080e7          	jalr	-1132(ra) # e98 <chdir>
     30c:	e115                	bnez	a0,330 <go+0x2b8>
      unlink("../b");
     30e:	00001517          	auipc	a0,0x1
     312:	0a250513          	addi	a0,a0,162 # 13b0 <malloc+0x14a>
     316:	00001097          	auipc	ra,0x1
     31a:	b62080e7          	jalr	-1182(ra) # e78 <unlink>
      chdir("/");
     31e:	00001517          	auipc	a0,0x1
     322:	05250513          	addi	a0,a0,82 # 1370 <malloc+0x10a>
     326:	00001097          	auipc	ra,0x1
     32a:	b72080e7          	jalr	-1166(ra) # e98 <chdir>
     32e:	bbcd                	j	120 <go+0xa8>
        printf("chdir grindir failed\n");
     330:	00001517          	auipc	a0,0x1
     334:	02850513          	addi	a0,a0,40 # 1358 <malloc+0xf2>
     338:	00001097          	auipc	ra,0x1
     33c:	e70080e7          	jalr	-400(ra) # 11a8 <printf>
        exit(1);
     340:	4505                	li	a0,1
     342:	00001097          	auipc	ra,0x1
     346:	ae6080e7          	jalr	-1306(ra) # e28 <exit>
      close(fd);
     34a:	854a                	mv	a0,s2
     34c:	00001097          	auipc	ra,0x1
     350:	b04080e7          	jalr	-1276(ra) # e50 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     354:	20200593          	li	a1,514
     358:	00001517          	auipc	a0,0x1
     35c:	06050513          	addi	a0,a0,96 # 13b8 <malloc+0x152>
     360:	00001097          	auipc	ra,0x1
     364:	b08080e7          	jalr	-1272(ra) # e68 <open>
     368:	892a                	mv	s2,a0
     36a:	bb5d                	j	120 <go+0xa8>
      close(fd);
     36c:	854a                	mv	a0,s2
     36e:	00001097          	auipc	ra,0x1
     372:	ae2080e7          	jalr	-1310(ra) # e50 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     376:	20200593          	li	a1,514
     37a:	00001517          	auipc	a0,0x1
     37e:	04e50513          	addi	a0,a0,78 # 13c8 <malloc+0x162>
     382:	00001097          	auipc	ra,0x1
     386:	ae6080e7          	jalr	-1306(ra) # e68 <open>
     38a:	892a                	mv	s2,a0
     38c:	bb51                	j	120 <go+0xa8>
      write(fd, buf, sizeof(buf));
     38e:	3e700613          	li	a2,999
     392:	00001597          	auipc	a1,0x1
     396:	2b658593          	addi	a1,a1,694 # 1648 <buf.1233>
     39a:	854a                	mv	a0,s2
     39c:	00001097          	auipc	ra,0x1
     3a0:	aac080e7          	jalr	-1364(ra) # e48 <write>
     3a4:	bbb5                	j	120 <go+0xa8>
      read(fd, buf, sizeof(buf));
     3a6:	3e700613          	li	a2,999
     3aa:	00001597          	auipc	a1,0x1
     3ae:	29e58593          	addi	a1,a1,670 # 1648 <buf.1233>
     3b2:	854a                	mv	a0,s2
     3b4:	00001097          	auipc	ra,0x1
     3b8:	a8c080e7          	jalr	-1396(ra) # e40 <read>
     3bc:	b395                	j	120 <go+0xa8>
      mkdir("grindir/../a");
     3be:	00001517          	auipc	a0,0x1
     3c2:	fca50513          	addi	a0,a0,-54 # 1388 <malloc+0x122>
     3c6:	00001097          	auipc	ra,0x1
     3ca:	aca080e7          	jalr	-1334(ra) # e90 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3ce:	20200593          	li	a1,514
     3d2:	00001517          	auipc	a0,0x1
     3d6:	00e50513          	addi	a0,a0,14 # 13e0 <malloc+0x17a>
     3da:	00001097          	auipc	ra,0x1
     3de:	a8e080e7          	jalr	-1394(ra) # e68 <open>
     3e2:	00001097          	auipc	ra,0x1
     3e6:	a6e080e7          	jalr	-1426(ra) # e50 <close>
      unlink("a/a");
     3ea:	00001517          	auipc	a0,0x1
     3ee:	00650513          	addi	a0,a0,6 # 13f0 <malloc+0x18a>
     3f2:	00001097          	auipc	ra,0x1
     3f6:	a86080e7          	jalr	-1402(ra) # e78 <unlink>
     3fa:	b31d                	j	120 <go+0xa8>
      mkdir("/../b");
     3fc:	00001517          	auipc	a0,0x1
     400:	ffc50513          	addi	a0,a0,-4 # 13f8 <malloc+0x192>
     404:	00001097          	auipc	ra,0x1
     408:	a8c080e7          	jalr	-1396(ra) # e90 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     40c:	20200593          	li	a1,514
     410:	00001517          	auipc	a0,0x1
     414:	ff050513          	addi	a0,a0,-16 # 1400 <malloc+0x19a>
     418:	00001097          	auipc	ra,0x1
     41c:	a50080e7          	jalr	-1456(ra) # e68 <open>
     420:	00001097          	auipc	ra,0x1
     424:	a30080e7          	jalr	-1488(ra) # e50 <close>
      unlink("b/b");
     428:	00001517          	auipc	a0,0x1
     42c:	fe850513          	addi	a0,a0,-24 # 1410 <malloc+0x1aa>
     430:	00001097          	auipc	ra,0x1
     434:	a48080e7          	jalr	-1464(ra) # e78 <unlink>
     438:	b1e5                	j	120 <go+0xa8>
      unlink("b");
     43a:	00001517          	auipc	a0,0x1
     43e:	f9e50513          	addi	a0,a0,-98 # 13d8 <malloc+0x172>
     442:	00001097          	auipc	ra,0x1
     446:	a36080e7          	jalr	-1482(ra) # e78 <unlink>
      link("../grindir/./../a", "../b");
     44a:	00001597          	auipc	a1,0x1
     44e:	f6658593          	addi	a1,a1,-154 # 13b0 <malloc+0x14a>
     452:	00001517          	auipc	a0,0x1
     456:	fc650513          	addi	a0,a0,-58 # 1418 <malloc+0x1b2>
     45a:	00001097          	auipc	ra,0x1
     45e:	a2e080e7          	jalr	-1490(ra) # e88 <link>
     462:	b97d                	j	120 <go+0xa8>
      unlink("../grindir/../a");
     464:	00001517          	auipc	a0,0x1
     468:	fcc50513          	addi	a0,a0,-52 # 1430 <malloc+0x1ca>
     46c:	00001097          	auipc	ra,0x1
     470:	a0c080e7          	jalr	-1524(ra) # e78 <unlink>
      link(".././b", "/grindir/../a");
     474:	00001597          	auipc	a1,0x1
     478:	f4458593          	addi	a1,a1,-188 # 13b8 <malloc+0x152>
     47c:	00001517          	auipc	a0,0x1
     480:	fc450513          	addi	a0,a0,-60 # 1440 <malloc+0x1da>
     484:	00001097          	auipc	ra,0x1
     488:	a04080e7          	jalr	-1532(ra) # e88 <link>
     48c:	b951                	j	120 <go+0xa8>
      int pid = fork();
     48e:	00001097          	auipc	ra,0x1
     492:	992080e7          	jalr	-1646(ra) # e20 <fork>
      if(pid == 0){
     496:	c909                	beqz	a0,4a8 <go+0x430>
      } else if(pid < 0){
     498:	00054c63          	bltz	a0,4b0 <go+0x438>
      wait(0);
     49c:	4501                	li	a0,0
     49e:	00001097          	auipc	ra,0x1
     4a2:	992080e7          	jalr	-1646(ra) # e30 <wait>
     4a6:	b9ad                	j	120 <go+0xa8>
        exit(0);
     4a8:	00001097          	auipc	ra,0x1
     4ac:	980080e7          	jalr	-1664(ra) # e28 <exit>
        printf("grind: fork failed\n");
     4b0:	00001517          	auipc	a0,0x1
     4b4:	f9850513          	addi	a0,a0,-104 # 1448 <malloc+0x1e2>
     4b8:	00001097          	auipc	ra,0x1
     4bc:	cf0080e7          	jalr	-784(ra) # 11a8 <printf>
        exit(1);
     4c0:	4505                	li	a0,1
     4c2:	00001097          	auipc	ra,0x1
     4c6:	966080e7          	jalr	-1690(ra) # e28 <exit>
      int pid = fork();
     4ca:	00001097          	auipc	ra,0x1
     4ce:	956080e7          	jalr	-1706(ra) # e20 <fork>
      if(pid == 0){
     4d2:	c909                	beqz	a0,4e4 <go+0x46c>
      } else if(pid < 0){
     4d4:	02054563          	bltz	a0,4fe <go+0x486>
      wait(0);
     4d8:	4501                	li	a0,0
     4da:	00001097          	auipc	ra,0x1
     4de:	956080e7          	jalr	-1706(ra) # e30 <wait>
     4e2:	b93d                	j	120 <go+0xa8>
        fork();
     4e4:	00001097          	auipc	ra,0x1
     4e8:	93c080e7          	jalr	-1732(ra) # e20 <fork>
        fork();
     4ec:	00001097          	auipc	ra,0x1
     4f0:	934080e7          	jalr	-1740(ra) # e20 <fork>
        exit(0);
     4f4:	4501                	li	a0,0
     4f6:	00001097          	auipc	ra,0x1
     4fa:	932080e7          	jalr	-1742(ra) # e28 <exit>
        printf("grind: fork failed\n");
     4fe:	00001517          	auipc	a0,0x1
     502:	f4a50513          	addi	a0,a0,-182 # 1448 <malloc+0x1e2>
     506:	00001097          	auipc	ra,0x1
     50a:	ca2080e7          	jalr	-862(ra) # 11a8 <printf>
        exit(1);
     50e:	4505                	li	a0,1
     510:	00001097          	auipc	ra,0x1
     514:	918080e7          	jalr	-1768(ra) # e28 <exit>
      sbrk(6011);
     518:	8556                	mv	a0,s5
     51a:	00001097          	auipc	ra,0x1
     51e:	996080e7          	jalr	-1642(ra) # eb0 <sbrk>
     522:	befd                	j	120 <go+0xa8>
      if(sbrk(0) > break0)
     524:	4501                	li	a0,0
     526:	00001097          	auipc	ra,0x1
     52a:	98a080e7          	jalr	-1654(ra) # eb0 <sbrk>
     52e:	beaa79e3          	bgeu	s4,a0,120 <go+0xa8>
        sbrk(-(sbrk(0) - break0));
     532:	4501                	li	a0,0
     534:	00001097          	auipc	ra,0x1
     538:	97c080e7          	jalr	-1668(ra) # eb0 <sbrk>
     53c:	40aa053b          	subw	a0,s4,a0
     540:	00001097          	auipc	ra,0x1
     544:	970080e7          	jalr	-1680(ra) # eb0 <sbrk>
     548:	bee1                	j	120 <go+0xa8>
      int pid = fork();
     54a:	00001097          	auipc	ra,0x1
     54e:	8d6080e7          	jalr	-1834(ra) # e20 <fork>
     552:	8b2a                	mv	s6,a0
      if(pid == 0){
     554:	c51d                	beqz	a0,582 <go+0x50a>
      } else if(pid < 0){
     556:	04054963          	bltz	a0,5a8 <go+0x530>
      if(chdir("../grindir/..") != 0){
     55a:	00001517          	auipc	a0,0x1
     55e:	f0650513          	addi	a0,a0,-250 # 1460 <malloc+0x1fa>
     562:	00001097          	auipc	ra,0x1
     566:	936080e7          	jalr	-1738(ra) # e98 <chdir>
     56a:	ed21                	bnez	a0,5c2 <go+0x54a>
      kill(pid);
     56c:	855a                	mv	a0,s6
     56e:	00001097          	auipc	ra,0x1
     572:	8ea080e7          	jalr	-1814(ra) # e58 <kill>
      wait(0);
     576:	4501                	li	a0,0
     578:	00001097          	auipc	ra,0x1
     57c:	8b8080e7          	jalr	-1864(ra) # e30 <wait>
     580:	b645                	j	120 <go+0xa8>
        close(open("a", O_CREATE|O_RDWR));
     582:	20200593          	li	a1,514
     586:	00001517          	auipc	a0,0x1
     58a:	ea250513          	addi	a0,a0,-350 # 1428 <malloc+0x1c2>
     58e:	00001097          	auipc	ra,0x1
     592:	8da080e7          	jalr	-1830(ra) # e68 <open>
     596:	00001097          	auipc	ra,0x1
     59a:	8ba080e7          	jalr	-1862(ra) # e50 <close>
        exit(0);
     59e:	4501                	li	a0,0
     5a0:	00001097          	auipc	ra,0x1
     5a4:	888080e7          	jalr	-1912(ra) # e28 <exit>
        printf("grind: fork failed\n");
     5a8:	00001517          	auipc	a0,0x1
     5ac:	ea050513          	addi	a0,a0,-352 # 1448 <malloc+0x1e2>
     5b0:	00001097          	auipc	ra,0x1
     5b4:	bf8080e7          	jalr	-1032(ra) # 11a8 <printf>
        exit(1);
     5b8:	4505                	li	a0,1
     5ba:	00001097          	auipc	ra,0x1
     5be:	86e080e7          	jalr	-1938(ra) # e28 <exit>
        printf("chdir failed\n");
     5c2:	00001517          	auipc	a0,0x1
     5c6:	eae50513          	addi	a0,a0,-338 # 1470 <malloc+0x20a>
     5ca:	00001097          	auipc	ra,0x1
     5ce:	bde080e7          	jalr	-1058(ra) # 11a8 <printf>
        exit(1);
     5d2:	4505                	li	a0,1
     5d4:	00001097          	auipc	ra,0x1
     5d8:	854080e7          	jalr	-1964(ra) # e28 <exit>
      int pid = fork();
     5dc:	00001097          	auipc	ra,0x1
     5e0:	844080e7          	jalr	-1980(ra) # e20 <fork>
      if(pid == 0){
     5e4:	c909                	beqz	a0,5f6 <go+0x57e>
      } else if(pid < 0){
     5e6:	02054563          	bltz	a0,610 <go+0x598>
      wait(0);
     5ea:	4501                	li	a0,0
     5ec:	00001097          	auipc	ra,0x1
     5f0:	844080e7          	jalr	-1980(ra) # e30 <wait>
     5f4:	b635                	j	120 <go+0xa8>
        kill(getpid());
     5f6:	00001097          	auipc	ra,0x1
     5fa:	8b2080e7          	jalr	-1870(ra) # ea8 <getpid>
     5fe:	00001097          	auipc	ra,0x1
     602:	85a080e7          	jalr	-1958(ra) # e58 <kill>
        exit(0);
     606:	4501                	li	a0,0
     608:	00001097          	auipc	ra,0x1
     60c:	820080e7          	jalr	-2016(ra) # e28 <exit>
        printf("grind: fork failed\n");
     610:	00001517          	auipc	a0,0x1
     614:	e3850513          	addi	a0,a0,-456 # 1448 <malloc+0x1e2>
     618:	00001097          	auipc	ra,0x1
     61c:	b90080e7          	jalr	-1136(ra) # 11a8 <printf>
        exit(1);
     620:	4505                	li	a0,1
     622:	00001097          	auipc	ra,0x1
     626:	806080e7          	jalr	-2042(ra) # e28 <exit>
      if(pipe(fds) < 0){
     62a:	fa840513          	addi	a0,s0,-88
     62e:	00001097          	auipc	ra,0x1
     632:	80a080e7          	jalr	-2038(ra) # e38 <pipe>
     636:	02054b63          	bltz	a0,66c <go+0x5f4>
      int pid = fork();
     63a:	00000097          	auipc	ra,0x0
     63e:	7e6080e7          	jalr	2022(ra) # e20 <fork>
      if(pid == 0){
     642:	c131                	beqz	a0,686 <go+0x60e>
      } else if(pid < 0){
     644:	0a054a63          	bltz	a0,6f8 <go+0x680>
      close(fds[0]);
     648:	fa842503          	lw	a0,-88(s0)
     64c:	00001097          	auipc	ra,0x1
     650:	804080e7          	jalr	-2044(ra) # e50 <close>
      close(fds[1]);
     654:	fac42503          	lw	a0,-84(s0)
     658:	00000097          	auipc	ra,0x0
     65c:	7f8080e7          	jalr	2040(ra) # e50 <close>
      wait(0);
     660:	4501                	li	a0,0
     662:	00000097          	auipc	ra,0x0
     666:	7ce080e7          	jalr	1998(ra) # e30 <wait>
     66a:	bc5d                	j	120 <go+0xa8>
        printf("grind: pipe failed\n");
     66c:	00001517          	auipc	a0,0x1
     670:	e1450513          	addi	a0,a0,-492 # 1480 <malloc+0x21a>
     674:	00001097          	auipc	ra,0x1
     678:	b34080e7          	jalr	-1228(ra) # 11a8 <printf>
        exit(1);
     67c:	4505                	li	a0,1
     67e:	00000097          	auipc	ra,0x0
     682:	7aa080e7          	jalr	1962(ra) # e28 <exit>
        fork();
     686:	00000097          	auipc	ra,0x0
     68a:	79a080e7          	jalr	1946(ra) # e20 <fork>
        fork();
     68e:	00000097          	auipc	ra,0x0
     692:	792080e7          	jalr	1938(ra) # e20 <fork>
        if(write(fds[1], "x", 1) != 1)
     696:	4605                	li	a2,1
     698:	00001597          	auipc	a1,0x1
     69c:	e0058593          	addi	a1,a1,-512 # 1498 <malloc+0x232>
     6a0:	fac42503          	lw	a0,-84(s0)
     6a4:	00000097          	auipc	ra,0x0
     6a8:	7a4080e7          	jalr	1956(ra) # e48 <write>
     6ac:	4785                	li	a5,1
     6ae:	02f51363          	bne	a0,a5,6d4 <go+0x65c>
        if(read(fds[0], &c, 1) != 1)
     6b2:	4605                	li	a2,1
     6b4:	fa040593          	addi	a1,s0,-96
     6b8:	fa842503          	lw	a0,-88(s0)
     6bc:	00000097          	auipc	ra,0x0
     6c0:	784080e7          	jalr	1924(ra) # e40 <read>
     6c4:	4785                	li	a5,1
     6c6:	02f51063          	bne	a0,a5,6e6 <go+0x66e>
        exit(0);
     6ca:	4501                	li	a0,0
     6cc:	00000097          	auipc	ra,0x0
     6d0:	75c080e7          	jalr	1884(ra) # e28 <exit>
          printf("grind: pipe write failed\n");
     6d4:	00001517          	auipc	a0,0x1
     6d8:	dcc50513          	addi	a0,a0,-564 # 14a0 <malloc+0x23a>
     6dc:	00001097          	auipc	ra,0x1
     6e0:	acc080e7          	jalr	-1332(ra) # 11a8 <printf>
     6e4:	b7f9                	j	6b2 <go+0x63a>
          printf("grind: pipe read failed\n");
     6e6:	00001517          	auipc	a0,0x1
     6ea:	dda50513          	addi	a0,a0,-550 # 14c0 <malloc+0x25a>
     6ee:	00001097          	auipc	ra,0x1
     6f2:	aba080e7          	jalr	-1350(ra) # 11a8 <printf>
     6f6:	bfd1                	j	6ca <go+0x652>
        printf("grind: fork failed\n");
     6f8:	00001517          	auipc	a0,0x1
     6fc:	d5050513          	addi	a0,a0,-688 # 1448 <malloc+0x1e2>
     700:	00001097          	auipc	ra,0x1
     704:	aa8080e7          	jalr	-1368(ra) # 11a8 <printf>
        exit(1);
     708:	4505                	li	a0,1
     70a:	00000097          	auipc	ra,0x0
     70e:	71e080e7          	jalr	1822(ra) # e28 <exit>
      int pid = fork();
     712:	00000097          	auipc	ra,0x0
     716:	70e080e7          	jalr	1806(ra) # e20 <fork>
      if(pid == 0){
     71a:	c909                	beqz	a0,72c <go+0x6b4>
      } else if(pid < 0){
     71c:	06054f63          	bltz	a0,79a <go+0x722>
      wait(0);
     720:	4501                	li	a0,0
     722:	00000097          	auipc	ra,0x0
     726:	70e080e7          	jalr	1806(ra) # e30 <wait>
     72a:	badd                	j	120 <go+0xa8>
        unlink("a");
     72c:	00001517          	auipc	a0,0x1
     730:	cfc50513          	addi	a0,a0,-772 # 1428 <malloc+0x1c2>
     734:	00000097          	auipc	ra,0x0
     738:	744080e7          	jalr	1860(ra) # e78 <unlink>
        mkdir("a");
     73c:	00001517          	auipc	a0,0x1
     740:	cec50513          	addi	a0,a0,-788 # 1428 <malloc+0x1c2>
     744:	00000097          	auipc	ra,0x0
     748:	74c080e7          	jalr	1868(ra) # e90 <mkdir>
        chdir("a");
     74c:	00001517          	auipc	a0,0x1
     750:	cdc50513          	addi	a0,a0,-804 # 1428 <malloc+0x1c2>
     754:	00000097          	auipc	ra,0x0
     758:	744080e7          	jalr	1860(ra) # e98 <chdir>
        unlink("../a");
     75c:	00001517          	auipc	a0,0x1
     760:	c3450513          	addi	a0,a0,-972 # 1390 <malloc+0x12a>
     764:	00000097          	auipc	ra,0x0
     768:	714080e7          	jalr	1812(ra) # e78 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     76c:	20200593          	li	a1,514
     770:	00001517          	auipc	a0,0x1
     774:	d2850513          	addi	a0,a0,-728 # 1498 <malloc+0x232>
     778:	00000097          	auipc	ra,0x0
     77c:	6f0080e7          	jalr	1776(ra) # e68 <open>
        unlink("x");
     780:	00001517          	auipc	a0,0x1
     784:	d1850513          	addi	a0,a0,-744 # 1498 <malloc+0x232>
     788:	00000097          	auipc	ra,0x0
     78c:	6f0080e7          	jalr	1776(ra) # e78 <unlink>
        exit(0);
     790:	4501                	li	a0,0
     792:	00000097          	auipc	ra,0x0
     796:	696080e7          	jalr	1686(ra) # e28 <exit>
        printf("fork failed\n");
     79a:	00001517          	auipc	a0,0x1
     79e:	d4650513          	addi	a0,a0,-698 # 14e0 <malloc+0x27a>
     7a2:	00001097          	auipc	ra,0x1
     7a6:	a06080e7          	jalr	-1530(ra) # 11a8 <printf>
        exit(1);
     7aa:	4505                	li	a0,1
     7ac:	00000097          	auipc	ra,0x0
     7b0:	67c080e7          	jalr	1660(ra) # e28 <exit>
      unlink("c");
     7b4:	00001517          	auipc	a0,0x1
     7b8:	d3c50513          	addi	a0,a0,-708 # 14f0 <malloc+0x28a>
     7bc:	00000097          	auipc	ra,0x0
     7c0:	6bc080e7          	jalr	1724(ra) # e78 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7c4:	20200593          	li	a1,514
     7c8:	00001517          	auipc	a0,0x1
     7cc:	d2850513          	addi	a0,a0,-728 # 14f0 <malloc+0x28a>
     7d0:	00000097          	auipc	ra,0x0
     7d4:	698080e7          	jalr	1688(ra) # e68 <open>
     7d8:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7da:	04054f63          	bltz	a0,838 <go+0x7c0>
      if(write(fd1, "x", 1) != 1){
     7de:	4605                	li	a2,1
     7e0:	00001597          	auipc	a1,0x1
     7e4:	cb858593          	addi	a1,a1,-840 # 1498 <malloc+0x232>
     7e8:	00000097          	auipc	ra,0x0
     7ec:	660080e7          	jalr	1632(ra) # e48 <write>
     7f0:	4785                	li	a5,1
     7f2:	06f51063          	bne	a0,a5,852 <go+0x7da>
      if(fstat(fd1, &st) != 0){
     7f6:	fa840593          	addi	a1,s0,-88
     7fa:	855a                	mv	a0,s6
     7fc:	00000097          	auipc	ra,0x0
     800:	684080e7          	jalr	1668(ra) # e80 <fstat>
     804:	e525                	bnez	a0,86c <go+0x7f4>
      if(st.size != 1){
     806:	fb843583          	ld	a1,-72(s0)
     80a:	4785                	li	a5,1
     80c:	06f59d63          	bne	a1,a5,886 <go+0x80e>
      if(st.ino > 200){
     810:	fac42583          	lw	a1,-84(s0)
     814:	0c800793          	li	a5,200
     818:	08b7e563          	bltu	a5,a1,8a2 <go+0x82a>
      close(fd1);
     81c:	855a                	mv	a0,s6
     81e:	00000097          	auipc	ra,0x0
     822:	632080e7          	jalr	1586(ra) # e50 <close>
      unlink("c");
     826:	00001517          	auipc	a0,0x1
     82a:	cca50513          	addi	a0,a0,-822 # 14f0 <malloc+0x28a>
     82e:	00000097          	auipc	ra,0x0
     832:	64a080e7          	jalr	1610(ra) # e78 <unlink>
     836:	b0ed                	j	120 <go+0xa8>
        printf("create c failed\n");
     838:	00001517          	auipc	a0,0x1
     83c:	cc050513          	addi	a0,a0,-832 # 14f8 <malloc+0x292>
     840:	00001097          	auipc	ra,0x1
     844:	968080e7          	jalr	-1688(ra) # 11a8 <printf>
        exit(1);
     848:	4505                	li	a0,1
     84a:	00000097          	auipc	ra,0x0
     84e:	5de080e7          	jalr	1502(ra) # e28 <exit>
        printf("write c failed\n");
     852:	00001517          	auipc	a0,0x1
     856:	cbe50513          	addi	a0,a0,-834 # 1510 <malloc+0x2aa>
     85a:	00001097          	auipc	ra,0x1
     85e:	94e080e7          	jalr	-1714(ra) # 11a8 <printf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	5c4080e7          	jalr	1476(ra) # e28 <exit>
        printf("fstat failed\n");
     86c:	00001517          	auipc	a0,0x1
     870:	cb450513          	addi	a0,a0,-844 # 1520 <malloc+0x2ba>
     874:	00001097          	auipc	ra,0x1
     878:	934080e7          	jalr	-1740(ra) # 11a8 <printf>
        exit(1);
     87c:	4505                	li	a0,1
     87e:	00000097          	auipc	ra,0x0
     882:	5aa080e7          	jalr	1450(ra) # e28 <exit>
        printf("fstat reports wrong size %d\n", (int)st.size);
     886:	2581                	sext.w	a1,a1
     888:	00001517          	auipc	a0,0x1
     88c:	ca850513          	addi	a0,a0,-856 # 1530 <malloc+0x2ca>
     890:	00001097          	auipc	ra,0x1
     894:	918080e7          	jalr	-1768(ra) # 11a8 <printf>
        exit(1);
     898:	4505                	li	a0,1
     89a:	00000097          	auipc	ra,0x0
     89e:	58e080e7          	jalr	1422(ra) # e28 <exit>
        printf("fstat reports crazy i-number %d\n", st.ino);
     8a2:	00001517          	auipc	a0,0x1
     8a6:	cae50513          	addi	a0,a0,-850 # 1550 <malloc+0x2ea>
     8aa:	00001097          	auipc	ra,0x1
     8ae:	8fe080e7          	jalr	-1794(ra) # 11a8 <printf>
        exit(1);
     8b2:	4505                	li	a0,1
     8b4:	00000097          	auipc	ra,0x0
     8b8:	574080e7          	jalr	1396(ra) # e28 <exit>
        fprintf(2, "pipe failed\n");
     8bc:	00001597          	auipc	a1,0x1
     8c0:	cbc58593          	addi	a1,a1,-836 # 1578 <malloc+0x312>
     8c4:	4509                	li	a0,2
     8c6:	00001097          	auipc	ra,0x1
     8ca:	8b4080e7          	jalr	-1868(ra) # 117a <fprintf>
        exit(1);
     8ce:	4505                	li	a0,1
     8d0:	00000097          	auipc	ra,0x0
     8d4:	558080e7          	jalr	1368(ra) # e28 <exit>
        fprintf(2, "pipe failed\n");
     8d8:	00001597          	auipc	a1,0x1
     8dc:	ca058593          	addi	a1,a1,-864 # 1578 <malloc+0x312>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	898080e7          	jalr	-1896(ra) # 117a <fprintf>
        exit(1);
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	53c080e7          	jalr	1340(ra) # e28 <exit>
        close(bb[0]);
     8f4:	fa042503          	lw	a0,-96(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	558080e7          	jalr	1368(ra) # e50 <close>
        close(bb[1]);
     900:	fa442503          	lw	a0,-92(s0)
     904:	00000097          	auipc	ra,0x0
     908:	54c080e7          	jalr	1356(ra) # e50 <close>
        close(aa[0]);
     90c:	f9842503          	lw	a0,-104(s0)
     910:	00000097          	auipc	ra,0x0
     914:	540080e7          	jalr	1344(ra) # e50 <close>
        close(1);
     918:	4505                	li	a0,1
     91a:	00000097          	auipc	ra,0x0
     91e:	536080e7          	jalr	1334(ra) # e50 <close>
        if(dup(aa[1]) != 1){
     922:	f9c42503          	lw	a0,-100(s0)
     926:	00000097          	auipc	ra,0x0
     92a:	57a080e7          	jalr	1402(ra) # ea0 <dup>
     92e:	4785                	li	a5,1
     930:	02f50063          	beq	a0,a5,950 <go+0x8d8>
          fprintf(2, "dup failed\n");
     934:	00001597          	auipc	a1,0x1
     938:	c5458593          	addi	a1,a1,-940 # 1588 <malloc+0x322>
     93c:	4509                	li	a0,2
     93e:	00001097          	auipc	ra,0x1
     942:	83c080e7          	jalr	-1988(ra) # 117a <fprintf>
          exit(1);
     946:	4505                	li	a0,1
     948:	00000097          	auipc	ra,0x0
     94c:	4e0080e7          	jalr	1248(ra) # e28 <exit>
        close(aa[1]);
     950:	f9c42503          	lw	a0,-100(s0)
     954:	00000097          	auipc	ra,0x0
     958:	4fc080e7          	jalr	1276(ra) # e50 <close>
        char *args[3] = { "echo", "hi", 0 };
     95c:	00001797          	auipc	a5,0x1
     960:	c3c78793          	addi	a5,a5,-964 # 1598 <malloc+0x332>
     964:	faf43423          	sd	a5,-88(s0)
     968:	00001797          	auipc	a5,0x1
     96c:	c3878793          	addi	a5,a5,-968 # 15a0 <malloc+0x33a>
     970:	faf43823          	sd	a5,-80(s0)
     974:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     978:	fa840593          	addi	a1,s0,-88
     97c:	00001517          	auipc	a0,0x1
     980:	c2c50513          	addi	a0,a0,-980 # 15a8 <malloc+0x342>
     984:	00000097          	auipc	ra,0x0
     988:	4dc080e7          	jalr	1244(ra) # e60 <exec>
        fprintf(2, "echo: not found\n");
     98c:	00001597          	auipc	a1,0x1
     990:	c2c58593          	addi	a1,a1,-980 # 15b8 <malloc+0x352>
     994:	4509                	li	a0,2
     996:	00000097          	auipc	ra,0x0
     99a:	7e4080e7          	jalr	2020(ra) # 117a <fprintf>
        exit(2);
     99e:	4509                	li	a0,2
     9a0:	00000097          	auipc	ra,0x0
     9a4:	488080e7          	jalr	1160(ra) # e28 <exit>
        fprintf(2, "fork failed\n");
     9a8:	00001597          	auipc	a1,0x1
     9ac:	b3858593          	addi	a1,a1,-1224 # 14e0 <malloc+0x27a>
     9b0:	4509                	li	a0,2
     9b2:	00000097          	auipc	ra,0x0
     9b6:	7c8080e7          	jalr	1992(ra) # 117a <fprintf>
        exit(3);
     9ba:	450d                	li	a0,3
     9bc:	00000097          	auipc	ra,0x0
     9c0:	46c080e7          	jalr	1132(ra) # e28 <exit>
        close(aa[1]);
     9c4:	f9c42503          	lw	a0,-100(s0)
     9c8:	00000097          	auipc	ra,0x0
     9cc:	488080e7          	jalr	1160(ra) # e50 <close>
        close(bb[0]);
     9d0:	fa042503          	lw	a0,-96(s0)
     9d4:	00000097          	auipc	ra,0x0
     9d8:	47c080e7          	jalr	1148(ra) # e50 <close>
        close(0);
     9dc:	4501                	li	a0,0
     9de:	00000097          	auipc	ra,0x0
     9e2:	472080e7          	jalr	1138(ra) # e50 <close>
        if(dup(aa[0]) != 0){
     9e6:	f9842503          	lw	a0,-104(s0)
     9ea:	00000097          	auipc	ra,0x0
     9ee:	4b6080e7          	jalr	1206(ra) # ea0 <dup>
     9f2:	cd19                	beqz	a0,a10 <go+0x998>
          fprintf(2, "dup failed\n");
     9f4:	00001597          	auipc	a1,0x1
     9f8:	b9458593          	addi	a1,a1,-1132 # 1588 <malloc+0x322>
     9fc:	4509                	li	a0,2
     9fe:	00000097          	auipc	ra,0x0
     a02:	77c080e7          	jalr	1916(ra) # 117a <fprintf>
          exit(4);
     a06:	4511                	li	a0,4
     a08:	00000097          	auipc	ra,0x0
     a0c:	420080e7          	jalr	1056(ra) # e28 <exit>
        close(aa[0]);
     a10:	f9842503          	lw	a0,-104(s0)
     a14:	00000097          	auipc	ra,0x0
     a18:	43c080e7          	jalr	1084(ra) # e50 <close>
        close(1);
     a1c:	4505                	li	a0,1
     a1e:	00000097          	auipc	ra,0x0
     a22:	432080e7          	jalr	1074(ra) # e50 <close>
        if(dup(bb[1]) != 1){
     a26:	fa442503          	lw	a0,-92(s0)
     a2a:	00000097          	auipc	ra,0x0
     a2e:	476080e7          	jalr	1142(ra) # ea0 <dup>
     a32:	4785                	li	a5,1
     a34:	02f50063          	beq	a0,a5,a54 <go+0x9dc>
          fprintf(2, "dup failed\n");
     a38:	00001597          	auipc	a1,0x1
     a3c:	b5058593          	addi	a1,a1,-1200 # 1588 <malloc+0x322>
     a40:	4509                	li	a0,2
     a42:	00000097          	auipc	ra,0x0
     a46:	738080e7          	jalr	1848(ra) # 117a <fprintf>
          exit(5);
     a4a:	4515                	li	a0,5
     a4c:	00000097          	auipc	ra,0x0
     a50:	3dc080e7          	jalr	988(ra) # e28 <exit>
        close(bb[1]);
     a54:	fa442503          	lw	a0,-92(s0)
     a58:	00000097          	auipc	ra,0x0
     a5c:	3f8080e7          	jalr	1016(ra) # e50 <close>
        char *args[2] = { "cat", 0 };
     a60:	00001797          	auipc	a5,0x1
     a64:	b7078793          	addi	a5,a5,-1168 # 15d0 <malloc+0x36a>
     a68:	faf43423          	sd	a5,-88(s0)
     a6c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a70:	fa840593          	addi	a1,s0,-88
     a74:	00001517          	auipc	a0,0x1
     a78:	b6450513          	addi	a0,a0,-1180 # 15d8 <malloc+0x372>
     a7c:	00000097          	auipc	ra,0x0
     a80:	3e4080e7          	jalr	996(ra) # e60 <exec>
        fprintf(2, "cat: not found\n");
     a84:	00001597          	auipc	a1,0x1
     a88:	b5c58593          	addi	a1,a1,-1188 # 15e0 <malloc+0x37a>
     a8c:	4509                	li	a0,2
     a8e:	00000097          	auipc	ra,0x0
     a92:	6ec080e7          	jalr	1772(ra) # 117a <fprintf>
        exit(6);
     a96:	4519                	li	a0,6
     a98:	00000097          	auipc	ra,0x0
     a9c:	390080e7          	jalr	912(ra) # e28 <exit>
        fprintf(2, "fork failed\n");
     aa0:	00001597          	auipc	a1,0x1
     aa4:	a4058593          	addi	a1,a1,-1472 # 14e0 <malloc+0x27a>
     aa8:	4509                	li	a0,2
     aaa:	00000097          	auipc	ra,0x0
     aae:	6d0080e7          	jalr	1744(ra) # 117a <fprintf>
        exit(7);
     ab2:	451d                	li	a0,7
     ab4:	00000097          	auipc	ra,0x0
     ab8:	374080e7          	jalr	884(ra) # e28 <exit>

0000000000000abc <main>:
  }
}

int
main()
{
     abc:	7179                	addi	sp,sp,-48
     abe:	f406                	sd	ra,40(sp)
     ac0:	f022                	sd	s0,32(sp)
     ac2:	ec26                	sd	s1,24(sp)
     ac4:	e84a                	sd	s2,16(sp)
     ac6:	1800                	addi	s0,sp,48
  unlink("a");
     ac8:	00001517          	auipc	a0,0x1
     acc:	96050513          	addi	a0,a0,-1696 # 1428 <malloc+0x1c2>
     ad0:	00000097          	auipc	ra,0x0
     ad4:	3a8080e7          	jalr	936(ra) # e78 <unlink>
  unlink("b");
     ad8:	00001517          	auipc	a0,0x1
     adc:	90050513          	addi	a0,a0,-1792 # 13d8 <malloc+0x172>
     ae0:	00000097          	auipc	ra,0x0
     ae4:	398080e7          	jalr	920(ra) # e78 <unlink>
  
  int pid1 = fork();
     ae8:	00000097          	auipc	ra,0x0
     aec:	338080e7          	jalr	824(ra) # e20 <fork>
  if(pid1 < 0){
     af0:	00054e63          	bltz	a0,b0c <main+0x50>
     af4:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     af6:	e905                	bnez	a0,b26 <main+0x6a>
    rand_next = 31;
     af8:	47fd                	li	a5,31
     afa:	00001717          	auipc	a4,0x1
     afe:	b2f73f23          	sd	a5,-1218(a4) # 1638 <rand_next>
    go(0);
     b02:	4501                	li	a0,0
     b04:	fffff097          	auipc	ra,0xfffff
     b08:	574080e7          	jalr	1396(ra) # 78 <go>
    printf("grind: fork failed\n");
     b0c:	00001517          	auipc	a0,0x1
     b10:	93c50513          	addi	a0,a0,-1732 # 1448 <malloc+0x1e2>
     b14:	00000097          	auipc	ra,0x0
     b18:	694080e7          	jalr	1684(ra) # 11a8 <printf>
    exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00000097          	auipc	ra,0x0
     b22:	30a080e7          	jalr	778(ra) # e28 <exit>
    exit(0);
  }

  int pid2 = fork();
     b26:	00000097          	auipc	ra,0x0
     b2a:	2fa080e7          	jalr	762(ra) # e20 <fork>
     b2e:	892a                	mv	s2,a0
  if(pid2 < 0){
     b30:	00054f63          	bltz	a0,b4e <main+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b34:	e915                	bnez	a0,b68 <main+0xac>
    rand_next = 7177;
     b36:	6789                	lui	a5,0x2
     b38:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x1c9>
     b3c:	00001717          	auipc	a4,0x1
     b40:	aef73e23          	sd	a5,-1284(a4) # 1638 <rand_next>
    go(1);
     b44:	4505                	li	a0,1
     b46:	fffff097          	auipc	ra,0xfffff
     b4a:	532080e7          	jalr	1330(ra) # 78 <go>
    printf("grind: fork failed\n");
     b4e:	00001517          	auipc	a0,0x1
     b52:	8fa50513          	addi	a0,a0,-1798 # 1448 <malloc+0x1e2>
     b56:	00000097          	auipc	ra,0x0
     b5a:	652080e7          	jalr	1618(ra) # 11a8 <printf>
    exit(1);
     b5e:	4505                	li	a0,1
     b60:	00000097          	auipc	ra,0x0
     b64:	2c8080e7          	jalr	712(ra) # e28 <exit>
    exit(0);
  }

  int st1 = -1;
     b68:	57fd                	li	a5,-1
     b6a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b6e:	fdc40513          	addi	a0,s0,-36
     b72:	00000097          	auipc	ra,0x0
     b76:	2be080e7          	jalr	702(ra) # e30 <wait>
  if(st1 != 0){
     b7a:	fdc42783          	lw	a5,-36(s0)
     b7e:	ef99                	bnez	a5,b9c <main+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b80:	57fd                	li	a5,-1
     b82:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b86:	fd840513          	addi	a0,s0,-40
     b8a:	00000097          	auipc	ra,0x0
     b8e:	2a6080e7          	jalr	678(ra) # e30 <wait>

  exit(0);
     b92:	4501                	li	a0,0
     b94:	00000097          	auipc	ra,0x0
     b98:	294080e7          	jalr	660(ra) # e28 <exit>
    kill(pid1);
     b9c:	8526                	mv	a0,s1
     b9e:	00000097          	auipc	ra,0x0
     ba2:	2ba080e7          	jalr	698(ra) # e58 <kill>
    kill(pid2);
     ba6:	854a                	mv	a0,s2
     ba8:	00000097          	auipc	ra,0x0
     bac:	2b0080e7          	jalr	688(ra) # e58 <kill>
     bb0:	bfc1                	j	b80 <main+0xc4>

0000000000000bb2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     bb2:	1141                	addi	sp,sp,-16
     bb4:	e422                	sd	s0,8(sp)
     bb6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bb8:	87aa                	mv	a5,a0
     bba:	0585                	addi	a1,a1,1
     bbc:	0785                	addi	a5,a5,1
     bbe:	fff5c703          	lbu	a4,-1(a1)
     bc2:	fee78fa3          	sb	a4,-1(a5)
     bc6:	fb75                	bnez	a4,bba <strcpy+0x8>
    ;
  return os;
}
     bc8:	6422                	ld	s0,8(sp)
     bca:	0141                	addi	sp,sp,16
     bcc:	8082                	ret

0000000000000bce <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bce:	1141                	addi	sp,sp,-16
     bd0:	e422                	sd	s0,8(sp)
     bd2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bd4:	00054783          	lbu	a5,0(a0)
     bd8:	cb91                	beqz	a5,bec <strcmp+0x1e>
     bda:	0005c703          	lbu	a4,0(a1)
     bde:	00f71763          	bne	a4,a5,bec <strcmp+0x1e>
    p++, q++;
     be2:	0505                	addi	a0,a0,1
     be4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     be6:	00054783          	lbu	a5,0(a0)
     bea:	fbe5                	bnez	a5,bda <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bec:	0005c503          	lbu	a0,0(a1)
}
     bf0:	40a7853b          	subw	a0,a5,a0
     bf4:	6422                	ld	s0,8(sp)
     bf6:	0141                	addi	sp,sp,16
     bf8:	8082                	ret

0000000000000bfa <strlen>:

uint
strlen(const char *s)
{
     bfa:	1141                	addi	sp,sp,-16
     bfc:	e422                	sd	s0,8(sp)
     bfe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c00:	00054783          	lbu	a5,0(a0)
     c04:	cf91                	beqz	a5,c20 <strlen+0x26>
     c06:	0505                	addi	a0,a0,1
     c08:	87aa                	mv	a5,a0
     c0a:	4685                	li	a3,1
     c0c:	9e89                	subw	a3,a3,a0
     c0e:	00f6853b          	addw	a0,a3,a5
     c12:	0785                	addi	a5,a5,1
     c14:	fff7c703          	lbu	a4,-1(a5)
     c18:	fb7d                	bnez	a4,c0e <strlen+0x14>
    ;
  return n;
}
     c1a:	6422                	ld	s0,8(sp)
     c1c:	0141                	addi	sp,sp,16
     c1e:	8082                	ret
  for(n = 0; s[n]; n++)
     c20:	4501                	li	a0,0
     c22:	bfe5                	j	c1a <strlen+0x20>

0000000000000c24 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c24:	1141                	addi	sp,sp,-16
     c26:	e422                	sd	s0,8(sp)
     c28:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c2a:	ce09                	beqz	a2,c44 <memset+0x20>
     c2c:	87aa                	mv	a5,a0
     c2e:	fff6071b          	addiw	a4,a2,-1
     c32:	1702                	slli	a4,a4,0x20
     c34:	9301                	srli	a4,a4,0x20
     c36:	0705                	addi	a4,a4,1
     c38:	972a                	add	a4,a4,a0
    cdst[i] = c;
     c3a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c3e:	0785                	addi	a5,a5,1
     c40:	fee79de3          	bne	a5,a4,c3a <memset+0x16>
  }
  return dst;
}
     c44:	6422                	ld	s0,8(sp)
     c46:	0141                	addi	sp,sp,16
     c48:	8082                	ret

0000000000000c4a <strchr>:

char*
strchr(const char *s, char c)
{
     c4a:	1141                	addi	sp,sp,-16
     c4c:	e422                	sd	s0,8(sp)
     c4e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c50:	00054783          	lbu	a5,0(a0)
     c54:	cb99                	beqz	a5,c6a <strchr+0x20>
    if(*s == c)
     c56:	00f58763          	beq	a1,a5,c64 <strchr+0x1a>
  for(; *s; s++)
     c5a:	0505                	addi	a0,a0,1
     c5c:	00054783          	lbu	a5,0(a0)
     c60:	fbfd                	bnez	a5,c56 <strchr+0xc>
      return (char*)s;
  return 0;
     c62:	4501                	li	a0,0
}
     c64:	6422                	ld	s0,8(sp)
     c66:	0141                	addi	sp,sp,16
     c68:	8082                	ret
  return 0;
     c6a:	4501                	li	a0,0
     c6c:	bfe5                	j	c64 <strchr+0x1a>

0000000000000c6e <gets>:

char*
gets(char *buf, int max)
{
     c6e:	711d                	addi	sp,sp,-96
     c70:	ec86                	sd	ra,88(sp)
     c72:	e8a2                	sd	s0,80(sp)
     c74:	e4a6                	sd	s1,72(sp)
     c76:	e0ca                	sd	s2,64(sp)
     c78:	fc4e                	sd	s3,56(sp)
     c7a:	f852                	sd	s4,48(sp)
     c7c:	f456                	sd	s5,40(sp)
     c7e:	f05a                	sd	s6,32(sp)
     c80:	ec5e                	sd	s7,24(sp)
     c82:	1080                	addi	s0,sp,96
     c84:	8baa                	mv	s7,a0
     c86:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c88:	892a                	mv	s2,a0
     c8a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c8c:	4aa9                	li	s5,10
     c8e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c90:	89a6                	mv	s3,s1
     c92:	2485                	addiw	s1,s1,1
     c94:	0344d863          	bge	s1,s4,cc4 <gets+0x56>
    cc = read(0, &c, 1);
     c98:	4605                	li	a2,1
     c9a:	faf40593          	addi	a1,s0,-81
     c9e:	4501                	li	a0,0
     ca0:	00000097          	auipc	ra,0x0
     ca4:	1a0080e7          	jalr	416(ra) # e40 <read>
    if(cc < 1)
     ca8:	00a05e63          	blez	a0,cc4 <gets+0x56>
    buf[i++] = c;
     cac:	faf44783          	lbu	a5,-81(s0)
     cb0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cb4:	01578763          	beq	a5,s5,cc2 <gets+0x54>
     cb8:	0905                	addi	s2,s2,1
     cba:	fd679be3          	bne	a5,s6,c90 <gets+0x22>
  for(i=0; i+1 < max; ){
     cbe:	89a6                	mv	s3,s1
     cc0:	a011                	j	cc4 <gets+0x56>
     cc2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cc4:	99de                	add	s3,s3,s7
     cc6:	00098023          	sb	zero,0(s3)
  return buf;
}
     cca:	855e                	mv	a0,s7
     ccc:	60e6                	ld	ra,88(sp)
     cce:	6446                	ld	s0,80(sp)
     cd0:	64a6                	ld	s1,72(sp)
     cd2:	6906                	ld	s2,64(sp)
     cd4:	79e2                	ld	s3,56(sp)
     cd6:	7a42                	ld	s4,48(sp)
     cd8:	7aa2                	ld	s5,40(sp)
     cda:	7b02                	ld	s6,32(sp)
     cdc:	6be2                	ld	s7,24(sp)
     cde:	6125                	addi	sp,sp,96
     ce0:	8082                	ret

0000000000000ce2 <stat>:

int
stat(const char *n, struct stat *st)
{
     ce2:	1101                	addi	sp,sp,-32
     ce4:	ec06                	sd	ra,24(sp)
     ce6:	e822                	sd	s0,16(sp)
     ce8:	e426                	sd	s1,8(sp)
     cea:	e04a                	sd	s2,0(sp)
     cec:	1000                	addi	s0,sp,32
     cee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cf0:	4581                	li	a1,0
     cf2:	00000097          	auipc	ra,0x0
     cf6:	176080e7          	jalr	374(ra) # e68 <open>
  if(fd < 0)
     cfa:	02054563          	bltz	a0,d24 <stat+0x42>
     cfe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d00:	85ca                	mv	a1,s2
     d02:	00000097          	auipc	ra,0x0
     d06:	17e080e7          	jalr	382(ra) # e80 <fstat>
     d0a:	892a                	mv	s2,a0
  close(fd);
     d0c:	8526                	mv	a0,s1
     d0e:	00000097          	auipc	ra,0x0
     d12:	142080e7          	jalr	322(ra) # e50 <close>
  return r;
}
     d16:	854a                	mv	a0,s2
     d18:	60e2                	ld	ra,24(sp)
     d1a:	6442                	ld	s0,16(sp)
     d1c:	64a2                	ld	s1,8(sp)
     d1e:	6902                	ld	s2,0(sp)
     d20:	6105                	addi	sp,sp,32
     d22:	8082                	ret
    return -1;
     d24:	597d                	li	s2,-1
     d26:	bfc5                	j	d16 <stat+0x34>

0000000000000d28 <atoi>:

int
atoi(const char *s)
{
     d28:	1141                	addi	sp,sp,-16
     d2a:	e422                	sd	s0,8(sp)
     d2c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d2e:	00054603          	lbu	a2,0(a0)
     d32:	fd06079b          	addiw	a5,a2,-48
     d36:	0ff7f793          	andi	a5,a5,255
     d3a:	4725                	li	a4,9
     d3c:	02f76963          	bltu	a4,a5,d6e <atoi+0x46>
     d40:	86aa                	mv	a3,a0
  n = 0;
     d42:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d44:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d46:	0685                	addi	a3,a3,1
     d48:	0025179b          	slliw	a5,a0,0x2
     d4c:	9fa9                	addw	a5,a5,a0
     d4e:	0017979b          	slliw	a5,a5,0x1
     d52:	9fb1                	addw	a5,a5,a2
     d54:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d58:	0006c603          	lbu	a2,0(a3)
     d5c:	fd06071b          	addiw	a4,a2,-48
     d60:	0ff77713          	andi	a4,a4,255
     d64:	fee5f1e3          	bgeu	a1,a4,d46 <atoi+0x1e>
  return n;
}
     d68:	6422                	ld	s0,8(sp)
     d6a:	0141                	addi	sp,sp,16
     d6c:	8082                	ret
  n = 0;
     d6e:	4501                	li	a0,0
     d70:	bfe5                	j	d68 <atoi+0x40>

0000000000000d72 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d72:	1141                	addi	sp,sp,-16
     d74:	e422                	sd	s0,8(sp)
     d76:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d78:	02b57663          	bgeu	a0,a1,da4 <memmove+0x32>
    while(n-- > 0)
     d7c:	02c05163          	blez	a2,d9e <memmove+0x2c>
     d80:	fff6079b          	addiw	a5,a2,-1
     d84:	1782                	slli	a5,a5,0x20
     d86:	9381                	srli	a5,a5,0x20
     d88:	0785                	addi	a5,a5,1
     d8a:	97aa                	add	a5,a5,a0
  dst = vdst;
     d8c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d8e:	0585                	addi	a1,a1,1
     d90:	0705                	addi	a4,a4,1
     d92:	fff5c683          	lbu	a3,-1(a1)
     d96:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d9a:	fee79ae3          	bne	a5,a4,d8e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d9e:	6422                	ld	s0,8(sp)
     da0:	0141                	addi	sp,sp,16
     da2:	8082                	ret
    dst += n;
     da4:	00c50733          	add	a4,a0,a2
    src += n;
     da8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     daa:	fec05ae3          	blez	a2,d9e <memmove+0x2c>
     dae:	fff6079b          	addiw	a5,a2,-1
     db2:	1782                	slli	a5,a5,0x20
     db4:	9381                	srli	a5,a5,0x20
     db6:	fff7c793          	not	a5,a5
     dba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dbc:	15fd                	addi	a1,a1,-1
     dbe:	177d                	addi	a4,a4,-1
     dc0:	0005c683          	lbu	a3,0(a1)
     dc4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dc8:	fee79ae3          	bne	a5,a4,dbc <memmove+0x4a>
     dcc:	bfc9                	j	d9e <memmove+0x2c>

0000000000000dce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dce:	1141                	addi	sp,sp,-16
     dd0:	e422                	sd	s0,8(sp)
     dd2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dd4:	ca05                	beqz	a2,e04 <memcmp+0x36>
     dd6:	fff6069b          	addiw	a3,a2,-1
     dda:	1682                	slli	a3,a3,0x20
     ddc:	9281                	srli	a3,a3,0x20
     dde:	0685                	addi	a3,a3,1
     de0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     de2:	00054783          	lbu	a5,0(a0)
     de6:	0005c703          	lbu	a4,0(a1)
     dea:	00e79863          	bne	a5,a4,dfa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dee:	0505                	addi	a0,a0,1
    p2++;
     df0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     df2:	fed518e3          	bne	a0,a3,de2 <memcmp+0x14>
  }
  return 0;
     df6:	4501                	li	a0,0
     df8:	a019                	j	dfe <memcmp+0x30>
      return *p1 - *p2;
     dfa:	40e7853b          	subw	a0,a5,a4
}
     dfe:	6422                	ld	s0,8(sp)
     e00:	0141                	addi	sp,sp,16
     e02:	8082                	ret
  return 0;
     e04:	4501                	li	a0,0
     e06:	bfe5                	j	dfe <memcmp+0x30>

0000000000000e08 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e08:	1141                	addi	sp,sp,-16
     e0a:	e406                	sd	ra,8(sp)
     e0c:	e022                	sd	s0,0(sp)
     e0e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e10:	00000097          	auipc	ra,0x0
     e14:	f62080e7          	jalr	-158(ra) # d72 <memmove>
}
     e18:	60a2                	ld	ra,8(sp)
     e1a:	6402                	ld	s0,0(sp)
     e1c:	0141                	addi	sp,sp,16
     e1e:	8082                	ret

0000000000000e20 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e20:	4885                	li	a7,1
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e28:	4889                	li	a7,2
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e30:	488d                	li	a7,3
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e38:	4891                	li	a7,4
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <read>:
.global read
read:
 li a7, SYS_read
     e40:	4895                	li	a7,5
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <write>:
.global write
write:
 li a7, SYS_write
     e48:	48c1                	li	a7,16
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <close>:
.global close
close:
 li a7, SYS_close
     e50:	48d5                	li	a7,21
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e58:	4899                	li	a7,6
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e60:	489d                	li	a7,7
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <open>:
.global open
open:
 li a7, SYS_open
     e68:	48bd                	li	a7,15
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e70:	48c5                	li	a7,17
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e78:	48c9                	li	a7,18
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e80:	48a1                	li	a7,8
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <link>:
.global link
link:
 li a7, SYS_link
     e88:	48cd                	li	a7,19
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e90:	48d1                	li	a7,20
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e98:	48a5                	li	a7,9
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ea0:	48a9                	li	a7,10
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ea8:	48ad                	li	a7,11
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     eb0:	48b1                	li	a7,12
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     eb8:	48b5                	li	a7,13
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ec0:	48b9                	li	a7,14
 ecall
     ec2:	00000073          	ecall
 ret
     ec6:	8082                	ret

0000000000000ec8 <numprocs>:
.global numprocs
numprocs:
 li a7, SYS_numprocs
     ec8:	48d9                	li	a7,22
 ecall
     eca:	00000073          	ecall
 ret
     ece:	8082                	ret

0000000000000ed0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ed0:	1101                	addi	sp,sp,-32
     ed2:	ec06                	sd	ra,24(sp)
     ed4:	e822                	sd	s0,16(sp)
     ed6:	1000                	addi	s0,sp,32
     ed8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     edc:	4605                	li	a2,1
     ede:	fef40593          	addi	a1,s0,-17
     ee2:	00000097          	auipc	ra,0x0
     ee6:	f66080e7          	jalr	-154(ra) # e48 <write>
}
     eea:	60e2                	ld	ra,24(sp)
     eec:	6442                	ld	s0,16(sp)
     eee:	6105                	addi	sp,sp,32
     ef0:	8082                	ret

0000000000000ef2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ef2:	7139                	addi	sp,sp,-64
     ef4:	fc06                	sd	ra,56(sp)
     ef6:	f822                	sd	s0,48(sp)
     ef8:	f426                	sd	s1,40(sp)
     efa:	f04a                	sd	s2,32(sp)
     efc:	ec4e                	sd	s3,24(sp)
     efe:	0080                	addi	s0,sp,64
     f00:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f02:	c299                	beqz	a3,f08 <printint+0x16>
     f04:	0805c863          	bltz	a1,f94 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f08:	2581                	sext.w	a1,a1
  neg = 0;
     f0a:	4881                	li	a7,0
     f0c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f10:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f12:	2601                	sext.w	a2,a2
     f14:	00000517          	auipc	a0,0x0
     f18:	70c50513          	addi	a0,a0,1804 # 1620 <digits>
     f1c:	883a                	mv	a6,a4
     f1e:	2705                	addiw	a4,a4,1
     f20:	02c5f7bb          	remuw	a5,a1,a2
     f24:	1782                	slli	a5,a5,0x20
     f26:	9381                	srli	a5,a5,0x20
     f28:	97aa                	add	a5,a5,a0
     f2a:	0007c783          	lbu	a5,0(a5)
     f2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f32:	0005879b          	sext.w	a5,a1
     f36:	02c5d5bb          	divuw	a1,a1,a2
     f3a:	0685                	addi	a3,a3,1
     f3c:	fec7f0e3          	bgeu	a5,a2,f1c <printint+0x2a>
  if(neg)
     f40:	00088b63          	beqz	a7,f56 <printint+0x64>
    buf[i++] = '-';
     f44:	fd040793          	addi	a5,s0,-48
     f48:	973e                	add	a4,a4,a5
     f4a:	02d00793          	li	a5,45
     f4e:	fef70823          	sb	a5,-16(a4)
     f52:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f56:	02e05863          	blez	a4,f86 <printint+0x94>
     f5a:	fc040793          	addi	a5,s0,-64
     f5e:	00e78933          	add	s2,a5,a4
     f62:	fff78993          	addi	s3,a5,-1
     f66:	99ba                	add	s3,s3,a4
     f68:	377d                	addiw	a4,a4,-1
     f6a:	1702                	slli	a4,a4,0x20
     f6c:	9301                	srli	a4,a4,0x20
     f6e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f72:	fff94583          	lbu	a1,-1(s2)
     f76:	8526                	mv	a0,s1
     f78:	00000097          	auipc	ra,0x0
     f7c:	f58080e7          	jalr	-168(ra) # ed0 <putc>
  while(--i >= 0)
     f80:	197d                	addi	s2,s2,-1
     f82:	ff3918e3          	bne	s2,s3,f72 <printint+0x80>
}
     f86:	70e2                	ld	ra,56(sp)
     f88:	7442                	ld	s0,48(sp)
     f8a:	74a2                	ld	s1,40(sp)
     f8c:	7902                	ld	s2,32(sp)
     f8e:	69e2                	ld	s3,24(sp)
     f90:	6121                	addi	sp,sp,64
     f92:	8082                	ret
    x = -xx;
     f94:	40b005bb          	negw	a1,a1
    neg = 1;
     f98:	4885                	li	a7,1
    x = -xx;
     f9a:	bf8d                	j	f0c <printint+0x1a>

0000000000000f9c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f9c:	7119                	addi	sp,sp,-128
     f9e:	fc86                	sd	ra,120(sp)
     fa0:	f8a2                	sd	s0,112(sp)
     fa2:	f4a6                	sd	s1,104(sp)
     fa4:	f0ca                	sd	s2,96(sp)
     fa6:	ecce                	sd	s3,88(sp)
     fa8:	e8d2                	sd	s4,80(sp)
     faa:	e4d6                	sd	s5,72(sp)
     fac:	e0da                	sd	s6,64(sp)
     fae:	fc5e                	sd	s7,56(sp)
     fb0:	f862                	sd	s8,48(sp)
     fb2:	f466                	sd	s9,40(sp)
     fb4:	f06a                	sd	s10,32(sp)
     fb6:	ec6e                	sd	s11,24(sp)
     fb8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fba:	0005c903          	lbu	s2,0(a1)
     fbe:	18090f63          	beqz	s2,115c <vprintf+0x1c0>
     fc2:	8aaa                	mv	s5,a0
     fc4:	8b32                	mv	s6,a2
     fc6:	00158493          	addi	s1,a1,1
  state = 0;
     fca:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fcc:	02500a13          	li	s4,37
      if(c == 'd'){
     fd0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     fd4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     fd8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     fdc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fe0:	00000b97          	auipc	s7,0x0
     fe4:	640b8b93          	addi	s7,s7,1600 # 1620 <digits>
     fe8:	a839                	j	1006 <vprintf+0x6a>
        putc(fd, c);
     fea:	85ca                	mv	a1,s2
     fec:	8556                	mv	a0,s5
     fee:	00000097          	auipc	ra,0x0
     ff2:	ee2080e7          	jalr	-286(ra) # ed0 <putc>
     ff6:	a019                	j	ffc <vprintf+0x60>
    } else if(state == '%'){
     ff8:	01498f63          	beq	s3,s4,1016 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     ffc:	0485                	addi	s1,s1,1
     ffe:	fff4c903          	lbu	s2,-1(s1)
    1002:	14090d63          	beqz	s2,115c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1006:	0009079b          	sext.w	a5,s2
    if(state == 0){
    100a:	fe0997e3          	bnez	s3,ff8 <vprintf+0x5c>
      if(c == '%'){
    100e:	fd479ee3          	bne	a5,s4,fea <vprintf+0x4e>
        state = '%';
    1012:	89be                	mv	s3,a5
    1014:	b7e5                	j	ffc <vprintf+0x60>
      if(c == 'd'){
    1016:	05878063          	beq	a5,s8,1056 <vprintf+0xba>
      } else if(c == 'l') {
    101a:	05978c63          	beq	a5,s9,1072 <vprintf+0xd6>
      } else if(c == 'x') {
    101e:	07a78863          	beq	a5,s10,108e <vprintf+0xf2>
      } else if(c == 'p') {
    1022:	09b78463          	beq	a5,s11,10aa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1026:	07300713          	li	a4,115
    102a:	0ce78663          	beq	a5,a4,10f6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    102e:	06300713          	li	a4,99
    1032:	0ee78e63          	beq	a5,a4,112e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1036:	11478863          	beq	a5,s4,1146 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    103a:	85d2                	mv	a1,s4
    103c:	8556                	mv	a0,s5
    103e:	00000097          	auipc	ra,0x0
    1042:	e92080e7          	jalr	-366(ra) # ed0 <putc>
        putc(fd, c);
    1046:	85ca                	mv	a1,s2
    1048:	8556                	mv	a0,s5
    104a:	00000097          	auipc	ra,0x0
    104e:	e86080e7          	jalr	-378(ra) # ed0 <putc>
      }
      state = 0;
    1052:	4981                	li	s3,0
    1054:	b765                	j	ffc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1056:	008b0913          	addi	s2,s6,8
    105a:	4685                	li	a3,1
    105c:	4629                	li	a2,10
    105e:	000b2583          	lw	a1,0(s6)
    1062:	8556                	mv	a0,s5
    1064:	00000097          	auipc	ra,0x0
    1068:	e8e080e7          	jalr	-370(ra) # ef2 <printint>
    106c:	8b4a                	mv	s6,s2
      state = 0;
    106e:	4981                	li	s3,0
    1070:	b771                	j	ffc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1072:	008b0913          	addi	s2,s6,8
    1076:	4681                	li	a3,0
    1078:	4629                	li	a2,10
    107a:	000b2583          	lw	a1,0(s6)
    107e:	8556                	mv	a0,s5
    1080:	00000097          	auipc	ra,0x0
    1084:	e72080e7          	jalr	-398(ra) # ef2 <printint>
    1088:	8b4a                	mv	s6,s2
      state = 0;
    108a:	4981                	li	s3,0
    108c:	bf85                	j	ffc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    108e:	008b0913          	addi	s2,s6,8
    1092:	4681                	li	a3,0
    1094:	4641                	li	a2,16
    1096:	000b2583          	lw	a1,0(s6)
    109a:	8556                	mv	a0,s5
    109c:	00000097          	auipc	ra,0x0
    10a0:	e56080e7          	jalr	-426(ra) # ef2 <printint>
    10a4:	8b4a                	mv	s6,s2
      state = 0;
    10a6:	4981                	li	s3,0
    10a8:	bf91                	j	ffc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    10aa:	008b0793          	addi	a5,s6,8
    10ae:	f8f43423          	sd	a5,-120(s0)
    10b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    10b6:	03000593          	li	a1,48
    10ba:	8556                	mv	a0,s5
    10bc:	00000097          	auipc	ra,0x0
    10c0:	e14080e7          	jalr	-492(ra) # ed0 <putc>
  putc(fd, 'x');
    10c4:	85ea                	mv	a1,s10
    10c6:	8556                	mv	a0,s5
    10c8:	00000097          	auipc	ra,0x0
    10cc:	e08080e7          	jalr	-504(ra) # ed0 <putc>
    10d0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10d2:	03c9d793          	srli	a5,s3,0x3c
    10d6:	97de                	add	a5,a5,s7
    10d8:	0007c583          	lbu	a1,0(a5)
    10dc:	8556                	mv	a0,s5
    10de:	00000097          	auipc	ra,0x0
    10e2:	df2080e7          	jalr	-526(ra) # ed0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10e6:	0992                	slli	s3,s3,0x4
    10e8:	397d                	addiw	s2,s2,-1
    10ea:	fe0914e3          	bnez	s2,10d2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    10ee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    10f2:	4981                	li	s3,0
    10f4:	b721                	j	ffc <vprintf+0x60>
        s = va_arg(ap, char*);
    10f6:	008b0993          	addi	s3,s6,8
    10fa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    10fe:	02090163          	beqz	s2,1120 <vprintf+0x184>
        while(*s != 0){
    1102:	00094583          	lbu	a1,0(s2)
    1106:	c9a1                	beqz	a1,1156 <vprintf+0x1ba>
          putc(fd, *s);
    1108:	8556                	mv	a0,s5
    110a:	00000097          	auipc	ra,0x0
    110e:	dc6080e7          	jalr	-570(ra) # ed0 <putc>
          s++;
    1112:	0905                	addi	s2,s2,1
        while(*s != 0){
    1114:	00094583          	lbu	a1,0(s2)
    1118:	f9e5                	bnez	a1,1108 <vprintf+0x16c>
        s = va_arg(ap, char*);
    111a:	8b4e                	mv	s6,s3
      state = 0;
    111c:	4981                	li	s3,0
    111e:	bdf9                	j	ffc <vprintf+0x60>
          s = "(null)";
    1120:	00000917          	auipc	s2,0x0
    1124:	4f890913          	addi	s2,s2,1272 # 1618 <malloc+0x3b2>
        while(*s != 0){
    1128:	02800593          	li	a1,40
    112c:	bff1                	j	1108 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    112e:	008b0913          	addi	s2,s6,8
    1132:	000b4583          	lbu	a1,0(s6)
    1136:	8556                	mv	a0,s5
    1138:	00000097          	auipc	ra,0x0
    113c:	d98080e7          	jalr	-616(ra) # ed0 <putc>
    1140:	8b4a                	mv	s6,s2
      state = 0;
    1142:	4981                	li	s3,0
    1144:	bd65                	j	ffc <vprintf+0x60>
        putc(fd, c);
    1146:	85d2                	mv	a1,s4
    1148:	8556                	mv	a0,s5
    114a:	00000097          	auipc	ra,0x0
    114e:	d86080e7          	jalr	-634(ra) # ed0 <putc>
      state = 0;
    1152:	4981                	li	s3,0
    1154:	b565                	j	ffc <vprintf+0x60>
        s = va_arg(ap, char*);
    1156:	8b4e                	mv	s6,s3
      state = 0;
    1158:	4981                	li	s3,0
    115a:	b54d                	j	ffc <vprintf+0x60>
    }
  }
}
    115c:	70e6                	ld	ra,120(sp)
    115e:	7446                	ld	s0,112(sp)
    1160:	74a6                	ld	s1,104(sp)
    1162:	7906                	ld	s2,96(sp)
    1164:	69e6                	ld	s3,88(sp)
    1166:	6a46                	ld	s4,80(sp)
    1168:	6aa6                	ld	s5,72(sp)
    116a:	6b06                	ld	s6,64(sp)
    116c:	7be2                	ld	s7,56(sp)
    116e:	7c42                	ld	s8,48(sp)
    1170:	7ca2                	ld	s9,40(sp)
    1172:	7d02                	ld	s10,32(sp)
    1174:	6de2                	ld	s11,24(sp)
    1176:	6109                	addi	sp,sp,128
    1178:	8082                	ret

000000000000117a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    117a:	715d                	addi	sp,sp,-80
    117c:	ec06                	sd	ra,24(sp)
    117e:	e822                	sd	s0,16(sp)
    1180:	1000                	addi	s0,sp,32
    1182:	e010                	sd	a2,0(s0)
    1184:	e414                	sd	a3,8(s0)
    1186:	e818                	sd	a4,16(s0)
    1188:	ec1c                	sd	a5,24(s0)
    118a:	03043023          	sd	a6,32(s0)
    118e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1192:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1196:	8622                	mv	a2,s0
    1198:	00000097          	auipc	ra,0x0
    119c:	e04080e7          	jalr	-508(ra) # f9c <vprintf>
}
    11a0:	60e2                	ld	ra,24(sp)
    11a2:	6442                	ld	s0,16(sp)
    11a4:	6161                	addi	sp,sp,80
    11a6:	8082                	ret

00000000000011a8 <printf>:

void
printf(const char *fmt, ...)
{
    11a8:	711d                	addi	sp,sp,-96
    11aa:	ec06                	sd	ra,24(sp)
    11ac:	e822                	sd	s0,16(sp)
    11ae:	1000                	addi	s0,sp,32
    11b0:	e40c                	sd	a1,8(s0)
    11b2:	e810                	sd	a2,16(s0)
    11b4:	ec14                	sd	a3,24(s0)
    11b6:	f018                	sd	a4,32(s0)
    11b8:	f41c                	sd	a5,40(s0)
    11ba:	03043823          	sd	a6,48(s0)
    11be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11c2:	00840613          	addi	a2,s0,8
    11c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11ca:	85aa                	mv	a1,a0
    11cc:	4505                	li	a0,1
    11ce:	00000097          	auipc	ra,0x0
    11d2:	dce080e7          	jalr	-562(ra) # f9c <vprintf>
}
    11d6:	60e2                	ld	ra,24(sp)
    11d8:	6442                	ld	s0,16(sp)
    11da:	6125                	addi	sp,sp,96
    11dc:	8082                	ret

00000000000011de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11de:	1141                	addi	sp,sp,-16
    11e0:	e422                	sd	s0,8(sp)
    11e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e8:	00000797          	auipc	a5,0x0
    11ec:	4587b783          	ld	a5,1112(a5) # 1640 <_edata>
    11f0:	a805                	j	1220 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11f2:	4618                	lw	a4,8(a2)
    11f4:	9db9                	addw	a1,a1,a4
    11f6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11fa:	6398                	ld	a4,0(a5)
    11fc:	6318                	ld	a4,0(a4)
    11fe:	fee53823          	sd	a4,-16(a0)
    1202:	a091                	j	1246 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1204:	ff852703          	lw	a4,-8(a0)
    1208:	9e39                	addw	a2,a2,a4
    120a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    120c:	ff053703          	ld	a4,-16(a0)
    1210:	e398                	sd	a4,0(a5)
    1212:	a099                	j	1258 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1214:	6398                	ld	a4,0(a5)
    1216:	00e7e463          	bltu	a5,a4,121e <free+0x40>
    121a:	00e6ea63          	bltu	a3,a4,122e <free+0x50>
{
    121e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1220:	fed7fae3          	bgeu	a5,a3,1214 <free+0x36>
    1224:	6398                	ld	a4,0(a5)
    1226:	00e6e463          	bltu	a3,a4,122e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    122a:	fee7eae3          	bltu	a5,a4,121e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    122e:	ff852583          	lw	a1,-8(a0)
    1232:	6390                	ld	a2,0(a5)
    1234:	02059713          	slli	a4,a1,0x20
    1238:	9301                	srli	a4,a4,0x20
    123a:	0712                	slli	a4,a4,0x4
    123c:	9736                	add	a4,a4,a3
    123e:	fae60ae3          	beq	a2,a4,11f2 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1242:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1246:	4790                	lw	a2,8(a5)
    1248:	02061713          	slli	a4,a2,0x20
    124c:	9301                	srli	a4,a4,0x20
    124e:	0712                	slli	a4,a4,0x4
    1250:	973e                	add	a4,a4,a5
    1252:	fae689e3          	beq	a3,a4,1204 <free+0x26>
  } else
    p->s.ptr = bp;
    1256:	e394                	sd	a3,0(a5)
  freep = p;
    1258:	00000717          	auipc	a4,0x0
    125c:	3ef73423          	sd	a5,1000(a4) # 1640 <_edata>
}
    1260:	6422                	ld	s0,8(sp)
    1262:	0141                	addi	sp,sp,16
    1264:	8082                	ret

0000000000001266 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1266:	7139                	addi	sp,sp,-64
    1268:	fc06                	sd	ra,56(sp)
    126a:	f822                	sd	s0,48(sp)
    126c:	f426                	sd	s1,40(sp)
    126e:	f04a                	sd	s2,32(sp)
    1270:	ec4e                	sd	s3,24(sp)
    1272:	e852                	sd	s4,16(sp)
    1274:	e456                	sd	s5,8(sp)
    1276:	e05a                	sd	s6,0(sp)
    1278:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    127a:	02051493          	slli	s1,a0,0x20
    127e:	9081                	srli	s1,s1,0x20
    1280:	04bd                	addi	s1,s1,15
    1282:	8091                	srli	s1,s1,0x4
    1284:	0014899b          	addiw	s3,s1,1
    1288:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    128a:	00000517          	auipc	a0,0x0
    128e:	3b653503          	ld	a0,950(a0) # 1640 <_edata>
    1292:	c515                	beqz	a0,12be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1294:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1296:	4798                	lw	a4,8(a5)
    1298:	02977f63          	bgeu	a4,s1,12d6 <malloc+0x70>
    129c:	8a4e                	mv	s4,s3
    129e:	0009871b          	sext.w	a4,s3
    12a2:	6685                	lui	a3,0x1
    12a4:	00d77363          	bgeu	a4,a3,12aa <malloc+0x44>
    12a8:	6a05                	lui	s4,0x1
    12aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12b2:	00000917          	auipc	s2,0x0
    12b6:	38e90913          	addi	s2,s2,910 # 1640 <_edata>
  if(p == (char*)-1)
    12ba:	5afd                	li	s5,-1
    12bc:	a88d                	j	132e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    12be:	00000797          	auipc	a5,0x0
    12c2:	77278793          	addi	a5,a5,1906 # 1a30 <base>
    12c6:	00000717          	auipc	a4,0x0
    12ca:	36f73d23          	sd	a5,890(a4) # 1640 <_edata>
    12ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12d4:	b7e1                	j	129c <malloc+0x36>
      if(p->s.size == nunits)
    12d6:	02e48b63          	beq	s1,a4,130c <malloc+0xa6>
        p->s.size -= nunits;
    12da:	4137073b          	subw	a4,a4,s3
    12de:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12e0:	1702                	slli	a4,a4,0x20
    12e2:	9301                	srli	a4,a4,0x20
    12e4:	0712                	slli	a4,a4,0x4
    12e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12ec:	00000717          	auipc	a4,0x0
    12f0:	34a73a23          	sd	a0,852(a4) # 1640 <_edata>
      return (void*)(p + 1);
    12f4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12f8:	70e2                	ld	ra,56(sp)
    12fa:	7442                	ld	s0,48(sp)
    12fc:	74a2                	ld	s1,40(sp)
    12fe:	7902                	ld	s2,32(sp)
    1300:	69e2                	ld	s3,24(sp)
    1302:	6a42                	ld	s4,16(sp)
    1304:	6aa2                	ld	s5,8(sp)
    1306:	6b02                	ld	s6,0(sp)
    1308:	6121                	addi	sp,sp,64
    130a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    130c:	6398                	ld	a4,0(a5)
    130e:	e118                	sd	a4,0(a0)
    1310:	bff1                	j	12ec <malloc+0x86>
  hp->s.size = nu;
    1312:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1316:	0541                	addi	a0,a0,16
    1318:	00000097          	auipc	ra,0x0
    131c:	ec6080e7          	jalr	-314(ra) # 11de <free>
  return freep;
    1320:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1324:	d971                	beqz	a0,12f8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1326:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1328:	4798                	lw	a4,8(a5)
    132a:	fa9776e3          	bgeu	a4,s1,12d6 <malloc+0x70>
    if(p == freep)
    132e:	00093703          	ld	a4,0(s2)
    1332:	853e                	mv	a0,a5
    1334:	fef719e3          	bne	a4,a5,1326 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1338:	8552                	mv	a0,s4
    133a:	00000097          	auipc	ra,0x0
    133e:	b76080e7          	jalr	-1162(ra) # eb0 <sbrk>
  if(p == (char*)-1)
    1342:	fd5518e3          	bne	a0,s5,1312 <malloc+0xac>
        return 0;
    1346:	4501                	li	a0,0
    1348:	bf45                	j	12f8 <malloc+0x92>
