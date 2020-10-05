
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	278080e7          	jalr	632(ra) # 5288 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	266080e7          	jalr	614(ra) # 5288 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	a3250513          	addi	a0,a0,-1486 # 5a70 <malloc+0x3ea>
      46:	00005097          	auipc	ra,0x5
      4a:	582080e7          	jalr	1410(ra) # 55c8 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	1f8080e7          	jalr	504(ra) # 5248 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	de078793          	addi	a5,a5,-544 # 8e38 <uninit>
      60:	0000b697          	auipc	a3,0xb
      64:	4e868693          	addi	a3,a3,1256 # b548 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	a1050513          	addi	a0,a0,-1520 # 5a90 <malloc+0x40a>
      88:	00005097          	auipc	ra,0x5
      8c:	540080e7          	jalr	1344(ra) # 55c8 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	1b6080e7          	jalr	438(ra) # 5248 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	a0050513          	addi	a0,a0,-1536 # 5aa8 <malloc+0x422>
      b0:	00005097          	auipc	ra,0x5
      b4:	1d8080e7          	jalr	472(ra) # 5288 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	1b4080e7          	jalr	436(ra) # 5270 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	a0250513          	addi	a0,a0,-1534 # 5ac8 <malloc+0x442>
      ce:	00005097          	auipc	ra,0x5
      d2:	1ba080e7          	jalr	442(ra) # 5288 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	9ca50513          	addi	a0,a0,-1590 # 5ab0 <malloc+0x42a>
      ee:	00005097          	auipc	ra,0x5
      f2:	4da080e7          	jalr	1242(ra) # 55c8 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	150080e7          	jalr	336(ra) # 5248 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	9d650513          	addi	a0,a0,-1578 # 5ad8 <malloc+0x452>
     10a:	00005097          	auipc	ra,0x5
     10e:	4be080e7          	jalr	1214(ra) # 55c8 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	134080e7          	jalr	308(ra) # 5248 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	9d450513          	addi	a0,a0,-1580 # 5b00 <malloc+0x47a>
     134:	00005097          	auipc	ra,0x5
     138:	164080e7          	jalr	356(ra) # 5298 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	9c050513          	addi	a0,a0,-1600 # 5b00 <malloc+0x47a>
     148:	00005097          	auipc	ra,0x5
     14c:	140080e7          	jalr	320(ra) # 5288 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	9bc58593          	addi	a1,a1,-1604 # 5b10 <malloc+0x48a>
     15c:	00005097          	auipc	ra,0x5
     160:	10c080e7          	jalr	268(ra) # 5268 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	99850513          	addi	a0,a0,-1640 # 5b00 <malloc+0x47a>
     170:	00005097          	auipc	ra,0x5
     174:	118080e7          	jalr	280(ra) # 5288 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	99c58593          	addi	a1,a1,-1636 # 5b18 <malloc+0x492>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	0e2080e7          	jalr	226(ra) # 5268 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	96c50513          	addi	a0,a0,-1684 # 5b00 <malloc+0x47a>
     19c:	00005097          	auipc	ra,0x5
     1a0:	0fc080e7          	jalr	252(ra) # 5298 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	0ca080e7          	jalr	202(ra) # 5270 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	0c0080e7          	jalr	192(ra) # 5270 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	95650513          	addi	a0,a0,-1706 # 5b20 <malloc+0x49a>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	3f6080e7          	jalr	1014(ra) # 55c8 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	06c080e7          	jalr	108(ra) # 5248 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	e44e                	sd	s3,8(sp)
     1f0:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f2:	00008797          	auipc	a5,0x8
     1f6:	b2e78793          	addi	a5,a5,-1234 # 7d20 <_edata>
     1fa:	06100713          	li	a4,97
     1fe:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     202:	00078123          	sb	zero,2(a5)
     206:	03000493          	li	s1,48
    name[1] = '0' + i;
     20a:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     20c:	06400993          	li	s3,100
    name[1] = '0' + i;
     210:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	854a                	mv	a0,s2
     21a:	00005097          	auipc	ra,0x5
     21e:	06e080e7          	jalr	110(ra) # 5288 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	04e080e7          	jalr	78(ra) # 5270 <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	aec78793          	addi	a5,a5,-1300 # 7d20 <_edata>
     23c:	06100713          	li	a4,97
     240:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     244:	00078123          	sb	zero,2(a5)
     248:	03000493          	li	s1,48
    name[1] = '0' + i;
     24c:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     24e:	06400993          	li	s3,100
    name[1] = '0' + i;
     252:	009900a3          	sb	s1,1(s2)
    unlink(name);
     256:	854a                	mv	a0,s2
     258:	00005097          	auipc	ra,0x5
     25c:	040080e7          	jalr	64(ra) # 5298 <unlink>
  for(i = 0; i < N; i++){
     260:	2485                	addiw	s1,s1,1
     262:	0ff4f493          	andi	s1,s1,255
     266:	ff3496e3          	bne	s1,s3,252 <createtest+0x6e>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	69a2                	ld	s3,8(sp)
     274:	6145                	addi	sp,sp,48
     276:	8082                	ret

0000000000000278 <bigwrite>:
{
     278:	715d                	addi	sp,sp,-80
     27a:	e486                	sd	ra,72(sp)
     27c:	e0a2                	sd	s0,64(sp)
     27e:	fc26                	sd	s1,56(sp)
     280:	f84a                	sd	s2,48(sp)
     282:	f44e                	sd	s3,40(sp)
     284:	f052                	sd	s4,32(sp)
     286:	ec56                	sd	s5,24(sp)
     288:	e85a                	sd	s6,16(sp)
     28a:	e45e                	sd	s7,8(sp)
     28c:	0880                	addi	s0,sp,80
     28e:	8baa                	mv	s7,a0
  unlink("bigwrite");
     290:	00005517          	auipc	a0,0x5
     294:	69050513          	addi	a0,a0,1680 # 5920 <malloc+0x29a>
     298:	00005097          	auipc	ra,0x5
     29c:	000080e7          	jalr	ra # 5298 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00005a97          	auipc	s5,0x5
     2a8:	67ca8a93          	addi	s5,s5,1660 # 5920 <malloc+0x29a>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	29ca0a13          	addi	s4,s4,668 # b548 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x557>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	fc8080e7          	jalr	-56(ra) # 5288 <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	f96080e7          	jalr	-106(ra) # 5268 <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49463          	bne	s1,a0,344 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	f82080e7          	jalr	-126(ra) # 5268 <write>
      if(cc != sz){
     2ee:	04951963          	bne	a0,s1,340 <bigwrite+0xc8>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	f7c080e7          	jalr	-132(ra) # 5270 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	f9a080e7          	jalr	-102(ra) # 5298 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     306:	1d74849b          	addiw	s1,s1,471
     30a:	fb6498e3          	bne	s1,s6,2ba <bigwrite+0x42>
}
     30e:	60a6                	ld	ra,72(sp)
     310:	6406                	ld	s0,64(sp)
     312:	74e2                	ld	s1,56(sp)
     314:	7942                	ld	s2,48(sp)
     316:	79a2                	ld	s3,40(sp)
     318:	7a02                	ld	s4,32(sp)
     31a:	6ae2                	ld	s5,24(sp)
     31c:	6b42                	ld	s6,16(sp)
     31e:	6ba2                	ld	s7,8(sp)
     320:	6161                	addi	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85de                	mv	a1,s7
     326:	00006517          	auipc	a0,0x6
     32a:	82250513          	addi	a0,a0,-2014 # 5b48 <malloc+0x4c2>
     32e:	00005097          	auipc	ra,0x5
     332:	29a080e7          	jalr	666(ra) # 55c8 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	f10080e7          	jalr	-240(ra) # 5248 <exit>
     340:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     342:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     344:	86ce                	mv	a3,s3
     346:	8626                	mv	a2,s1
     348:	85de                	mv	a1,s7
     34a:	00006517          	auipc	a0,0x6
     34e:	81e50513          	addi	a0,a0,-2018 # 5b68 <malloc+0x4e2>
     352:	00005097          	auipc	ra,0x5
     356:	276080e7          	jalr	630(ra) # 55c8 <printf>
        exit(1);
     35a:	4505                	li	a0,1
     35c:	00005097          	auipc	ra,0x5
     360:	eec080e7          	jalr	-276(ra) # 5248 <exit>

0000000000000364 <copyin>:
{
     364:	715d                	addi	sp,sp,-80
     366:	e486                	sd	ra,72(sp)
     368:	e0a2                	sd	s0,64(sp)
     36a:	fc26                	sd	s1,56(sp)
     36c:	f84a                	sd	s2,48(sp)
     36e:	f44e                	sd	s3,40(sp)
     370:	f052                	sd	s4,32(sp)
     372:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     374:	4785                	li	a5,1
     376:	07fe                	slli	a5,a5,0x1f
     378:	fcf43023          	sd	a5,-64(s0)
     37c:	57fd                	li	a5,-1
     37e:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     382:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     386:	00005a17          	auipc	s4,0x5
     38a:	7faa0a13          	addi	s4,s4,2042 # 5b80 <malloc+0x4fa>
    uint64 addr = addrs[ai];
     38e:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     392:	20100593          	li	a1,513
     396:	8552                	mv	a0,s4
     398:	00005097          	auipc	ra,0x5
     39c:	ef0080e7          	jalr	-272(ra) # 5288 <open>
     3a0:	84aa                	mv	s1,a0
    if(fd < 0){
     3a2:	08054863          	bltz	a0,432 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a6:	6609                	lui	a2,0x2
     3a8:	85ce                	mv	a1,s3
     3aa:	00005097          	auipc	ra,0x5
     3ae:	ebe080e7          	jalr	-322(ra) # 5268 <write>
    if(n >= 0){
     3b2:	08055d63          	bgez	a0,44c <copyin+0xe8>
    close(fd);
     3b6:	8526                	mv	a0,s1
     3b8:	00005097          	auipc	ra,0x5
     3bc:	eb8080e7          	jalr	-328(ra) # 5270 <close>
    unlink("copyin1");
     3c0:	8552                	mv	a0,s4
     3c2:	00005097          	auipc	ra,0x5
     3c6:	ed6080e7          	jalr	-298(ra) # 5298 <unlink>
    n = write(1, (char*)addr, 8192);
     3ca:	6609                	lui	a2,0x2
     3cc:	85ce                	mv	a1,s3
     3ce:	4505                	li	a0,1
     3d0:	00005097          	auipc	ra,0x5
     3d4:	e98080e7          	jalr	-360(ra) # 5268 <write>
    if(n > 0){
     3d8:	08a04963          	bgtz	a0,46a <copyin+0x106>
    if(pipe(fds) < 0){
     3dc:	fb840513          	addi	a0,s0,-72
     3e0:	00005097          	auipc	ra,0x5
     3e4:	e78080e7          	jalr	-392(ra) # 5258 <pipe>
     3e8:	0a054063          	bltz	a0,488 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ec:	6609                	lui	a2,0x2
     3ee:	85ce                	mv	a1,s3
     3f0:	fbc42503          	lw	a0,-68(s0)
     3f4:	00005097          	auipc	ra,0x5
     3f8:	e74080e7          	jalr	-396(ra) # 5268 <write>
    if(n > 0){
     3fc:	0aa04363          	bgtz	a0,4a2 <copyin+0x13e>
    close(fds[0]);
     400:	fb842503          	lw	a0,-72(s0)
     404:	00005097          	auipc	ra,0x5
     408:	e6c080e7          	jalr	-404(ra) # 5270 <close>
    close(fds[1]);
     40c:	fbc42503          	lw	a0,-68(s0)
     410:	00005097          	auipc	ra,0x5
     414:	e60080e7          	jalr	-416(ra) # 5270 <close>
  for(int ai = 0; ai < 2; ai++){
     418:	0921                	addi	s2,s2,8
     41a:	fd040793          	addi	a5,s0,-48
     41e:	f6f918e3          	bne	s2,a5,38e <copyin+0x2a>
}
     422:	60a6                	ld	ra,72(sp)
     424:	6406                	ld	s0,64(sp)
     426:	74e2                	ld	s1,56(sp)
     428:	7942                	ld	s2,48(sp)
     42a:	79a2                	ld	s3,40(sp)
     42c:	7a02                	ld	s4,32(sp)
     42e:	6161                	addi	sp,sp,80
     430:	8082                	ret
      printf("open(copyin1) failed\n");
     432:	00005517          	auipc	a0,0x5
     436:	75650513          	addi	a0,a0,1878 # 5b88 <malloc+0x502>
     43a:	00005097          	auipc	ra,0x5
     43e:	18e080e7          	jalr	398(ra) # 55c8 <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00005097          	auipc	ra,0x5
     448:	e04080e7          	jalr	-508(ra) # 5248 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44c:	862a                	mv	a2,a0
     44e:	85ce                	mv	a1,s3
     450:	00005517          	auipc	a0,0x5
     454:	75050513          	addi	a0,a0,1872 # 5ba0 <malloc+0x51a>
     458:	00005097          	auipc	ra,0x5
     45c:	170080e7          	jalr	368(ra) # 55c8 <printf>
      exit(1);
     460:	4505                	li	a0,1
     462:	00005097          	auipc	ra,0x5
     466:	de6080e7          	jalr	-538(ra) # 5248 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     46a:	862a                	mv	a2,a0
     46c:	85ce                	mv	a1,s3
     46e:	00005517          	auipc	a0,0x5
     472:	76250513          	addi	a0,a0,1890 # 5bd0 <malloc+0x54a>
     476:	00005097          	auipc	ra,0x5
     47a:	152080e7          	jalr	338(ra) # 55c8 <printf>
      exit(1);
     47e:	4505                	li	a0,1
     480:	00005097          	auipc	ra,0x5
     484:	dc8080e7          	jalr	-568(ra) # 5248 <exit>
      printf("pipe() failed\n");
     488:	00005517          	auipc	a0,0x5
     48c:	77850513          	addi	a0,a0,1912 # 5c00 <malloc+0x57a>
     490:	00005097          	auipc	ra,0x5
     494:	138080e7          	jalr	312(ra) # 55c8 <printf>
      exit(1);
     498:	4505                	li	a0,1
     49a:	00005097          	auipc	ra,0x5
     49e:	dae080e7          	jalr	-594(ra) # 5248 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a2:	862a                	mv	a2,a0
     4a4:	85ce                	mv	a1,s3
     4a6:	00005517          	auipc	a0,0x5
     4aa:	76a50513          	addi	a0,a0,1898 # 5c10 <malloc+0x58a>
     4ae:	00005097          	auipc	ra,0x5
     4b2:	11a080e7          	jalr	282(ra) # 55c8 <printf>
      exit(1);
     4b6:	4505                	li	a0,1
     4b8:	00005097          	auipc	ra,0x5
     4bc:	d90080e7          	jalr	-624(ra) # 5248 <exit>

00000000000004c0 <copyout>:
{
     4c0:	711d                	addi	sp,sp,-96
     4c2:	ec86                	sd	ra,88(sp)
     4c4:	e8a2                	sd	s0,80(sp)
     4c6:	e4a6                	sd	s1,72(sp)
     4c8:	e0ca                	sd	s2,64(sp)
     4ca:	fc4e                	sd	s3,56(sp)
     4cc:	f852                	sd	s4,48(sp)
     4ce:	f456                	sd	s5,40(sp)
     4d0:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4d2:	4785                	li	a5,1
     4d4:	07fe                	slli	a5,a5,0x1f
     4d6:	faf43823          	sd	a5,-80(s0)
     4da:	57fd                	li	a5,-1
     4dc:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4e0:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4e4:	00005a17          	auipc	s4,0x5
     4e8:	75ca0a13          	addi	s4,s4,1884 # 5c40 <malloc+0x5ba>
    n = write(fds[1], "x", 1);
     4ec:	00005a97          	auipc	s5,0x5
     4f0:	62ca8a93          	addi	s5,s5,1580 # 5b18 <malloc+0x492>
    uint64 addr = addrs[ai];
     4f4:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f8:	4581                	li	a1,0
     4fa:	8552                	mv	a0,s4
     4fc:	00005097          	auipc	ra,0x5
     500:	d8c080e7          	jalr	-628(ra) # 5288 <open>
     504:	84aa                	mv	s1,a0
    if(fd < 0){
     506:	08054663          	bltz	a0,592 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     50a:	6609                	lui	a2,0x2
     50c:	85ce                	mv	a1,s3
     50e:	00005097          	auipc	ra,0x5
     512:	d52080e7          	jalr	-686(ra) # 5260 <read>
    if(n > 0){
     516:	08a04b63          	bgtz	a0,5ac <copyout+0xec>
    close(fd);
     51a:	8526                	mv	a0,s1
     51c:	00005097          	auipc	ra,0x5
     520:	d54080e7          	jalr	-684(ra) # 5270 <close>
    if(pipe(fds) < 0){
     524:	fa840513          	addi	a0,s0,-88
     528:	00005097          	auipc	ra,0x5
     52c:	d30080e7          	jalr	-720(ra) # 5258 <pipe>
     530:	08054d63          	bltz	a0,5ca <copyout+0x10a>
    n = write(fds[1], "x", 1);
     534:	4605                	li	a2,1
     536:	85d6                	mv	a1,s5
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	d2c080e7          	jalr	-724(ra) # 5268 <write>
    if(n != 1){
     544:	4785                	li	a5,1
     546:	08f51f63          	bne	a0,a5,5e4 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     54a:	6609                	lui	a2,0x2
     54c:	85ce                	mv	a1,s3
     54e:	fa842503          	lw	a0,-88(s0)
     552:	00005097          	auipc	ra,0x5
     556:	d0e080e7          	jalr	-754(ra) # 5260 <read>
    if(n > 0){
     55a:	0aa04263          	bgtz	a0,5fe <copyout+0x13e>
    close(fds[0]);
     55e:	fa842503          	lw	a0,-88(s0)
     562:	00005097          	auipc	ra,0x5
     566:	d0e080e7          	jalr	-754(ra) # 5270 <close>
    close(fds[1]);
     56a:	fac42503          	lw	a0,-84(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	d02080e7          	jalr	-766(ra) # 5270 <close>
  for(int ai = 0; ai < 2; ai++){
     576:	0921                	addi	s2,s2,8
     578:	fc040793          	addi	a5,s0,-64
     57c:	f6f91ce3          	bne	s2,a5,4f4 <copyout+0x34>
}
     580:	60e6                	ld	ra,88(sp)
     582:	6446                	ld	s0,80(sp)
     584:	64a6                	ld	s1,72(sp)
     586:	6906                	ld	s2,64(sp)
     588:	79e2                	ld	s3,56(sp)
     58a:	7a42                	ld	s4,48(sp)
     58c:	7aa2                	ld	s5,40(sp)
     58e:	6125                	addi	sp,sp,96
     590:	8082                	ret
      printf("open(README) failed\n");
     592:	00005517          	auipc	a0,0x5
     596:	6b650513          	addi	a0,a0,1718 # 5c48 <malloc+0x5c2>
     59a:	00005097          	auipc	ra,0x5
     59e:	02e080e7          	jalr	46(ra) # 55c8 <printf>
      exit(1);
     5a2:	4505                	li	a0,1
     5a4:	00005097          	auipc	ra,0x5
     5a8:	ca4080e7          	jalr	-860(ra) # 5248 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ac:	862a                	mv	a2,a0
     5ae:	85ce                	mv	a1,s3
     5b0:	00005517          	auipc	a0,0x5
     5b4:	6b050513          	addi	a0,a0,1712 # 5c60 <malloc+0x5da>
     5b8:	00005097          	auipc	ra,0x5
     5bc:	010080e7          	jalr	16(ra) # 55c8 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00005097          	auipc	ra,0x5
     5c6:	c86080e7          	jalr	-890(ra) # 5248 <exit>
      printf("pipe() failed\n");
     5ca:	00005517          	auipc	a0,0x5
     5ce:	63650513          	addi	a0,a0,1590 # 5c00 <malloc+0x57a>
     5d2:	00005097          	auipc	ra,0x5
     5d6:	ff6080e7          	jalr	-10(ra) # 55c8 <printf>
      exit(1);
     5da:	4505                	li	a0,1
     5dc:	00005097          	auipc	ra,0x5
     5e0:	c6c080e7          	jalr	-916(ra) # 5248 <exit>
      printf("pipe write failed\n");
     5e4:	00005517          	auipc	a0,0x5
     5e8:	6ac50513          	addi	a0,a0,1708 # 5c90 <malloc+0x60a>
     5ec:	00005097          	auipc	ra,0x5
     5f0:	fdc080e7          	jalr	-36(ra) # 55c8 <printf>
      exit(1);
     5f4:	4505                	li	a0,1
     5f6:	00005097          	auipc	ra,0x5
     5fa:	c52080e7          	jalr	-942(ra) # 5248 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fe:	862a                	mv	a2,a0
     600:	85ce                	mv	a1,s3
     602:	00005517          	auipc	a0,0x5
     606:	6a650513          	addi	a0,a0,1702 # 5ca8 <malloc+0x622>
     60a:	00005097          	auipc	ra,0x5
     60e:	fbe080e7          	jalr	-66(ra) # 55c8 <printf>
      exit(1);
     612:	4505                	li	a0,1
     614:	00005097          	auipc	ra,0x5
     618:	c34080e7          	jalr	-972(ra) # 5248 <exit>

000000000000061c <truncate1>:
{
     61c:	711d                	addi	sp,sp,-96
     61e:	ec86                	sd	ra,88(sp)
     620:	e8a2                	sd	s0,80(sp)
     622:	e4a6                	sd	s1,72(sp)
     624:	e0ca                	sd	s2,64(sp)
     626:	fc4e                	sd	s3,56(sp)
     628:	f852                	sd	s4,48(sp)
     62a:	f456                	sd	s5,40(sp)
     62c:	1080                	addi	s0,sp,96
     62e:	8aaa                	mv	s5,a0
  unlink("truncfile");
     630:	00005517          	auipc	a0,0x5
     634:	4d050513          	addi	a0,a0,1232 # 5b00 <malloc+0x47a>
     638:	00005097          	auipc	ra,0x5
     63c:	c60080e7          	jalr	-928(ra) # 5298 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     640:	60100593          	li	a1,1537
     644:	00005517          	auipc	a0,0x5
     648:	4bc50513          	addi	a0,a0,1212 # 5b00 <malloc+0x47a>
     64c:	00005097          	auipc	ra,0x5
     650:	c3c080e7          	jalr	-964(ra) # 5288 <open>
     654:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     656:	4611                	li	a2,4
     658:	00005597          	auipc	a1,0x5
     65c:	4b858593          	addi	a1,a1,1208 # 5b10 <malloc+0x48a>
     660:	00005097          	auipc	ra,0x5
     664:	c08080e7          	jalr	-1016(ra) # 5268 <write>
  close(fd1);
     668:	8526                	mv	a0,s1
     66a:	00005097          	auipc	ra,0x5
     66e:	c06080e7          	jalr	-1018(ra) # 5270 <close>
  int fd2 = open("truncfile", O_RDONLY);
     672:	4581                	li	a1,0
     674:	00005517          	auipc	a0,0x5
     678:	48c50513          	addi	a0,a0,1164 # 5b00 <malloc+0x47a>
     67c:	00005097          	auipc	ra,0x5
     680:	c0c080e7          	jalr	-1012(ra) # 5288 <open>
     684:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     686:	02000613          	li	a2,32
     68a:	fa040593          	addi	a1,s0,-96
     68e:	00005097          	auipc	ra,0x5
     692:	bd2080e7          	jalr	-1070(ra) # 5260 <read>
  if(n != 4){
     696:	4791                	li	a5,4
     698:	0cf51e63          	bne	a0,a5,774 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69c:	40100593          	li	a1,1025
     6a0:	00005517          	auipc	a0,0x5
     6a4:	46050513          	addi	a0,a0,1120 # 5b00 <malloc+0x47a>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	be0080e7          	jalr	-1056(ra) # 5288 <open>
     6b0:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b2:	4581                	li	a1,0
     6b4:	00005517          	auipc	a0,0x5
     6b8:	44c50513          	addi	a0,a0,1100 # 5b00 <malloc+0x47a>
     6bc:	00005097          	auipc	ra,0x5
     6c0:	bcc080e7          	jalr	-1076(ra) # 5288 <open>
     6c4:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	00005097          	auipc	ra,0x5
     6d2:	b92080e7          	jalr	-1134(ra) # 5260 <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	ed4d                	bnez	a0,792 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6da:	02000613          	li	a2,32
     6de:	fa040593          	addi	a1,s0,-96
     6e2:	8526                	mv	a0,s1
     6e4:	00005097          	auipc	ra,0x5
     6e8:	b7c080e7          	jalr	-1156(ra) # 5260 <read>
     6ec:	8a2a                	mv	s4,a0
  if(n != 0){
     6ee:	e971                	bnez	a0,7c2 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6f0:	4619                	li	a2,6
     6f2:	00005597          	auipc	a1,0x5
     6f6:	64658593          	addi	a1,a1,1606 # 5d38 <malloc+0x6b2>
     6fa:	854e                	mv	a0,s3
     6fc:	00005097          	auipc	ra,0x5
     700:	b6c080e7          	jalr	-1172(ra) # 5268 <write>
  n = read(fd3, buf, sizeof(buf));
     704:	02000613          	li	a2,32
     708:	fa040593          	addi	a1,s0,-96
     70c:	854a                	mv	a0,s2
     70e:	00005097          	auipc	ra,0x5
     712:	b52080e7          	jalr	-1198(ra) # 5260 <read>
  if(n != 6){
     716:	4799                	li	a5,6
     718:	0cf51d63          	bne	a0,a5,7f2 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71c:	02000613          	li	a2,32
     720:	fa040593          	addi	a1,s0,-96
     724:	8526                	mv	a0,s1
     726:	00005097          	auipc	ra,0x5
     72a:	b3a080e7          	jalr	-1222(ra) # 5260 <read>
  if(n != 2){
     72e:	4789                	li	a5,2
     730:	0ef51063          	bne	a0,a5,810 <truncate1+0x1f4>
  unlink("truncfile");
     734:	00005517          	auipc	a0,0x5
     738:	3cc50513          	addi	a0,a0,972 # 5b00 <malloc+0x47a>
     73c:	00005097          	auipc	ra,0x5
     740:	b5c080e7          	jalr	-1188(ra) # 5298 <unlink>
  close(fd1);
     744:	854e                	mv	a0,s3
     746:	00005097          	auipc	ra,0x5
     74a:	b2a080e7          	jalr	-1238(ra) # 5270 <close>
  close(fd2);
     74e:	8526                	mv	a0,s1
     750:	00005097          	auipc	ra,0x5
     754:	b20080e7          	jalr	-1248(ra) # 5270 <close>
  close(fd3);
     758:	854a                	mv	a0,s2
     75a:	00005097          	auipc	ra,0x5
     75e:	b16080e7          	jalr	-1258(ra) # 5270 <close>
}
     762:	60e6                	ld	ra,88(sp)
     764:	6446                	ld	s0,80(sp)
     766:	64a6                	ld	s1,72(sp)
     768:	6906                	ld	s2,64(sp)
     76a:	79e2                	ld	s3,56(sp)
     76c:	7a42                	ld	s4,48(sp)
     76e:	7aa2                	ld	s5,40(sp)
     770:	6125                	addi	sp,sp,96
     772:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     774:	862a                	mv	a2,a0
     776:	85d6                	mv	a1,s5
     778:	00005517          	auipc	a0,0x5
     77c:	56050513          	addi	a0,a0,1376 # 5cd8 <malloc+0x652>
     780:	00005097          	auipc	ra,0x5
     784:	e48080e7          	jalr	-440(ra) # 55c8 <printf>
    exit(1);
     788:	4505                	li	a0,1
     78a:	00005097          	auipc	ra,0x5
     78e:	abe080e7          	jalr	-1346(ra) # 5248 <exit>
    printf("aaa fd3=%d\n", fd3);
     792:	85ca                	mv	a1,s2
     794:	00005517          	auipc	a0,0x5
     798:	56450513          	addi	a0,a0,1380 # 5cf8 <malloc+0x672>
     79c:	00005097          	auipc	ra,0x5
     7a0:	e2c080e7          	jalr	-468(ra) # 55c8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a4:	8652                	mv	a2,s4
     7a6:	85d6                	mv	a1,s5
     7a8:	00005517          	auipc	a0,0x5
     7ac:	56050513          	addi	a0,a0,1376 # 5d08 <malloc+0x682>
     7b0:	00005097          	auipc	ra,0x5
     7b4:	e18080e7          	jalr	-488(ra) # 55c8 <printf>
    exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00005097          	auipc	ra,0x5
     7be:	a8e080e7          	jalr	-1394(ra) # 5248 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c2:	85a6                	mv	a1,s1
     7c4:	00005517          	auipc	a0,0x5
     7c8:	56450513          	addi	a0,a0,1380 # 5d28 <malloc+0x6a2>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	dfc080e7          	jalr	-516(ra) # 55c8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d4:	8652                	mv	a2,s4
     7d6:	85d6                	mv	a1,s5
     7d8:	00005517          	auipc	a0,0x5
     7dc:	53050513          	addi	a0,a0,1328 # 5d08 <malloc+0x682>
     7e0:	00005097          	auipc	ra,0x5
     7e4:	de8080e7          	jalr	-536(ra) # 55c8 <printf>
    exit(1);
     7e8:	4505                	li	a0,1
     7ea:	00005097          	auipc	ra,0x5
     7ee:	a5e080e7          	jalr	-1442(ra) # 5248 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f2:	862a                	mv	a2,a0
     7f4:	85d6                	mv	a1,s5
     7f6:	00005517          	auipc	a0,0x5
     7fa:	54a50513          	addi	a0,a0,1354 # 5d40 <malloc+0x6ba>
     7fe:	00005097          	auipc	ra,0x5
     802:	dca080e7          	jalr	-566(ra) # 55c8 <printf>
    exit(1);
     806:	4505                	li	a0,1
     808:	00005097          	auipc	ra,0x5
     80c:	a40080e7          	jalr	-1472(ra) # 5248 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     810:	862a                	mv	a2,a0
     812:	85d6                	mv	a1,s5
     814:	00005517          	auipc	a0,0x5
     818:	54c50513          	addi	a0,a0,1356 # 5d60 <malloc+0x6da>
     81c:	00005097          	auipc	ra,0x5
     820:	dac080e7          	jalr	-596(ra) # 55c8 <printf>
    exit(1);
     824:	4505                	li	a0,1
     826:	00005097          	auipc	ra,0x5
     82a:	a22080e7          	jalr	-1502(ra) # 5248 <exit>

000000000000082e <writetest>:
{
     82e:	7139                	addi	sp,sp,-64
     830:	fc06                	sd	ra,56(sp)
     832:	f822                	sd	s0,48(sp)
     834:	f426                	sd	s1,40(sp)
     836:	f04a                	sd	s2,32(sp)
     838:	ec4e                	sd	s3,24(sp)
     83a:	e852                	sd	s4,16(sp)
     83c:	e456                	sd	s5,8(sp)
     83e:	e05a                	sd	s6,0(sp)
     840:	0080                	addi	s0,sp,64
     842:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     844:	20200593          	li	a1,514
     848:	00005517          	auipc	a0,0x5
     84c:	53850513          	addi	a0,a0,1336 # 5d80 <malloc+0x6fa>
     850:	00005097          	auipc	ra,0x5
     854:	a38080e7          	jalr	-1480(ra) # 5288 <open>
  if(fd < 0){
     858:	0a054d63          	bltz	a0,912 <writetest+0xe4>
     85c:	892a                	mv	s2,a0
     85e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	00005997          	auipc	s3,0x5
     864:	54898993          	addi	s3,s3,1352 # 5da8 <malloc+0x722>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     868:	00005a97          	auipc	s5,0x5
     86c:	578a8a93          	addi	s5,s5,1400 # 5de0 <malloc+0x75a>
  for(i = 0; i < N; i++){
     870:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85ce                	mv	a1,s3
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	9ee080e7          	jalr	-1554(ra) # 5268 <write>
     882:	47a9                	li	a5,10
     884:	0af51563          	bne	a0,a5,92e <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     888:	4629                	li	a2,10
     88a:	85d6                	mv	a1,s5
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	9da080e7          	jalr	-1574(ra) # 5268 <write>
     896:	47a9                	li	a5,10
     898:	0af51963          	bne	a0,a5,94a <writetest+0x11c>
  for(i = 0; i < N; i++){
     89c:	2485                	addiw	s1,s1,1
     89e:	fd449be3          	bne	s1,s4,874 <writetest+0x46>
  close(fd);
     8a2:	854a                	mv	a0,s2
     8a4:	00005097          	auipc	ra,0x5
     8a8:	9cc080e7          	jalr	-1588(ra) # 5270 <close>
  fd = open("small", O_RDONLY);
     8ac:	4581                	li	a1,0
     8ae:	00005517          	auipc	a0,0x5
     8b2:	4d250513          	addi	a0,a0,1234 # 5d80 <malloc+0x6fa>
     8b6:	00005097          	auipc	ra,0x5
     8ba:	9d2080e7          	jalr	-1582(ra) # 5288 <open>
     8be:	84aa                	mv	s1,a0
  if(fd < 0){
     8c0:	0a054363          	bltz	a0,966 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c4:	7d000613          	li	a2,2000
     8c8:	0000b597          	auipc	a1,0xb
     8cc:	c8058593          	addi	a1,a1,-896 # b548 <buf>
     8d0:	00005097          	auipc	ra,0x5
     8d4:	990080e7          	jalr	-1648(ra) # 5260 <read>
  if(i != N*SZ*2){
     8d8:	7d000793          	li	a5,2000
     8dc:	0af51363          	bne	a0,a5,982 <writetest+0x154>
  close(fd);
     8e0:	8526                	mv	a0,s1
     8e2:	00005097          	auipc	ra,0x5
     8e6:	98e080e7          	jalr	-1650(ra) # 5270 <close>
  if(unlink("small") < 0){
     8ea:	00005517          	auipc	a0,0x5
     8ee:	49650513          	addi	a0,a0,1174 # 5d80 <malloc+0x6fa>
     8f2:	00005097          	auipc	ra,0x5
     8f6:	9a6080e7          	jalr	-1626(ra) # 5298 <unlink>
     8fa:	0a054263          	bltz	a0,99e <writetest+0x170>
}
     8fe:	70e2                	ld	ra,56(sp)
     900:	7442                	ld	s0,48(sp)
     902:	74a2                	ld	s1,40(sp)
     904:	7902                	ld	s2,32(sp)
     906:	69e2                	ld	s3,24(sp)
     908:	6a42                	ld	s4,16(sp)
     90a:	6aa2                	ld	s5,8(sp)
     90c:	6b02                	ld	s6,0(sp)
     90e:	6121                	addi	sp,sp,64
     910:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     912:	85da                	mv	a1,s6
     914:	00005517          	auipc	a0,0x5
     918:	47450513          	addi	a0,a0,1140 # 5d88 <malloc+0x702>
     91c:	00005097          	auipc	ra,0x5
     920:	cac080e7          	jalr	-852(ra) # 55c8 <printf>
    exit(1);
     924:	4505                	li	a0,1
     926:	00005097          	auipc	ra,0x5
     92a:	922080e7          	jalr	-1758(ra) # 5248 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92e:	85a6                	mv	a1,s1
     930:	00005517          	auipc	a0,0x5
     934:	48850513          	addi	a0,a0,1160 # 5db8 <malloc+0x732>
     938:	00005097          	auipc	ra,0x5
     93c:	c90080e7          	jalr	-880(ra) # 55c8 <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	906080e7          	jalr	-1786(ra) # 5248 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     94a:	85a6                	mv	a1,s1
     94c:	00005517          	auipc	a0,0x5
     950:	4a450513          	addi	a0,a0,1188 # 5df0 <malloc+0x76a>
     954:	00005097          	auipc	ra,0x5
     958:	c74080e7          	jalr	-908(ra) # 55c8 <printf>
      exit(1);
     95c:	4505                	li	a0,1
     95e:	00005097          	auipc	ra,0x5
     962:	8ea080e7          	jalr	-1814(ra) # 5248 <exit>
    printf("%s: error: open small failed!\n", s);
     966:	85da                	mv	a1,s6
     968:	00005517          	auipc	a0,0x5
     96c:	4b050513          	addi	a0,a0,1200 # 5e18 <malloc+0x792>
     970:	00005097          	auipc	ra,0x5
     974:	c58080e7          	jalr	-936(ra) # 55c8 <printf>
    exit(1);
     978:	4505                	li	a0,1
     97a:	00005097          	auipc	ra,0x5
     97e:	8ce080e7          	jalr	-1842(ra) # 5248 <exit>
    printf("%s: read failed\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	4b450513          	addi	a0,a0,1204 # 5e38 <malloc+0x7b2>
     98c:	00005097          	auipc	ra,0x5
     990:	c3c080e7          	jalr	-964(ra) # 55c8 <printf>
    exit(1);
     994:	4505                	li	a0,1
     996:	00005097          	auipc	ra,0x5
     99a:	8b2080e7          	jalr	-1870(ra) # 5248 <exit>
    printf("%s: unlink small failed\n", s);
     99e:	85da                	mv	a1,s6
     9a0:	00005517          	auipc	a0,0x5
     9a4:	4b050513          	addi	a0,a0,1200 # 5e50 <malloc+0x7ca>
     9a8:	00005097          	auipc	ra,0x5
     9ac:	c20080e7          	jalr	-992(ra) # 55c8 <printf>
    exit(1);
     9b0:	4505                	li	a0,1
     9b2:	00005097          	auipc	ra,0x5
     9b6:	896080e7          	jalr	-1898(ra) # 5248 <exit>

00000000000009ba <writebig>:
{
     9ba:	7139                	addi	sp,sp,-64
     9bc:	fc06                	sd	ra,56(sp)
     9be:	f822                	sd	s0,48(sp)
     9c0:	f426                	sd	s1,40(sp)
     9c2:	f04a                	sd	s2,32(sp)
     9c4:	ec4e                	sd	s3,24(sp)
     9c6:	e852                	sd	s4,16(sp)
     9c8:	e456                	sd	s5,8(sp)
     9ca:	0080                	addi	s0,sp,64
     9cc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9ce:	20200593          	li	a1,514
     9d2:	00005517          	auipc	a0,0x5
     9d6:	49e50513          	addi	a0,a0,1182 # 5e70 <malloc+0x7ea>
     9da:	00005097          	auipc	ra,0x5
     9de:	8ae080e7          	jalr	-1874(ra) # 5288 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	b6290913          	addi	s2,s2,-1182 # b548 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054c63          	bltz	a0,a6a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	00005097          	auipc	ra,0x5
     a06:	866080e7          	jalr	-1946(ra) # 5268 <write>
     a0a:	40000793          	li	a5,1024
     a0e:	06f51c63          	bne	a0,a5,a86 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a12:	2485                	addiw	s1,s1,1
     a14:	ff4491e3          	bne	s1,s4,9f6 <writebig+0x3c>
  close(fd);
     a18:	854e                	mv	a0,s3
     a1a:	00005097          	auipc	ra,0x5
     a1e:	856080e7          	jalr	-1962(ra) # 5270 <close>
  fd = open("big", O_RDONLY);
     a22:	4581                	li	a1,0
     a24:	00005517          	auipc	a0,0x5
     a28:	44c50513          	addi	a0,a0,1100 # 5e70 <malloc+0x7ea>
     a2c:	00005097          	auipc	ra,0x5
     a30:	85c080e7          	jalr	-1956(ra) # 5288 <open>
     a34:	89aa                	mv	s3,a0
  n = 0;
     a36:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a38:	0000b917          	auipc	s2,0xb
     a3c:	b1090913          	addi	s2,s2,-1264 # b548 <buf>
  if(fd < 0){
     a40:	06054163          	bltz	a0,aa2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a44:	40000613          	li	a2,1024
     a48:	85ca                	mv	a1,s2
     a4a:	854e                	mv	a0,s3
     a4c:	00005097          	auipc	ra,0x5
     a50:	814080e7          	jalr	-2028(ra) # 5260 <read>
    if(i == 0){
     a54:	c52d                	beqz	a0,abe <writebig+0x104>
    } else if(i != BSIZE){
     a56:	40000793          	li	a5,1024
     a5a:	0af51d63          	bne	a0,a5,b14 <writebig+0x15a>
    if(((int*)buf)[0] != n){
     a5e:	00092603          	lw	a2,0(s2)
     a62:	0c961763          	bne	a2,s1,b30 <writebig+0x176>
    n++;
     a66:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a68:	bff1                	j	a44 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a6a:	85d6                	mv	a1,s5
     a6c:	00005517          	auipc	a0,0x5
     a70:	40c50513          	addi	a0,a0,1036 # 5e78 <malloc+0x7f2>
     a74:	00005097          	auipc	ra,0x5
     a78:	b54080e7          	jalr	-1196(ra) # 55c8 <printf>
    exit(1);
     a7c:	4505                	li	a0,1
     a7e:	00004097          	auipc	ra,0x4
     a82:	7ca080e7          	jalr	1994(ra) # 5248 <exit>
      printf("%s: error: write big file failed\n", i);
     a86:	85a6                	mv	a1,s1
     a88:	00005517          	auipc	a0,0x5
     a8c:	41050513          	addi	a0,a0,1040 # 5e98 <malloc+0x812>
     a90:	00005097          	auipc	ra,0x5
     a94:	b38080e7          	jalr	-1224(ra) # 55c8 <printf>
      exit(1);
     a98:	4505                	li	a0,1
     a9a:	00004097          	auipc	ra,0x4
     a9e:	7ae080e7          	jalr	1966(ra) # 5248 <exit>
    printf("%s: error: open big failed!\n", s);
     aa2:	85d6                	mv	a1,s5
     aa4:	00005517          	auipc	a0,0x5
     aa8:	41c50513          	addi	a0,a0,1052 # 5ec0 <malloc+0x83a>
     aac:	00005097          	auipc	ra,0x5
     ab0:	b1c080e7          	jalr	-1252(ra) # 55c8 <printf>
    exit(1);
     ab4:	4505                	li	a0,1
     ab6:	00004097          	auipc	ra,0x4
     aba:	792080e7          	jalr	1938(ra) # 5248 <exit>
      if(n == MAXFILE - 1){
     abe:	10b00793          	li	a5,267
     ac2:	02f48a63          	beq	s1,a5,af6 <writebig+0x13c>
  close(fd);
     ac6:	854e                	mv	a0,s3
     ac8:	00004097          	auipc	ra,0x4
     acc:	7a8080e7          	jalr	1960(ra) # 5270 <close>
  if(unlink("big") < 0){
     ad0:	00005517          	auipc	a0,0x5
     ad4:	3a050513          	addi	a0,a0,928 # 5e70 <malloc+0x7ea>
     ad8:	00004097          	auipc	ra,0x4
     adc:	7c0080e7          	jalr	1984(ra) # 5298 <unlink>
     ae0:	06054663          	bltz	a0,b4c <writebig+0x192>
}
     ae4:	70e2                	ld	ra,56(sp)
     ae6:	7442                	ld	s0,48(sp)
     ae8:	74a2                	ld	s1,40(sp)
     aea:	7902                	ld	s2,32(sp)
     aec:	69e2                	ld	s3,24(sp)
     aee:	6a42                	ld	s4,16(sp)
     af0:	6aa2                	ld	s5,8(sp)
     af2:	6121                	addi	sp,sp,64
     af4:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     af6:	10b00593          	li	a1,267
     afa:	00005517          	auipc	a0,0x5
     afe:	3e650513          	addi	a0,a0,998 # 5ee0 <malloc+0x85a>
     b02:	00005097          	auipc	ra,0x5
     b06:	ac6080e7          	jalr	-1338(ra) # 55c8 <printf>
        exit(1);
     b0a:	4505                	li	a0,1
     b0c:	00004097          	auipc	ra,0x4
     b10:	73c080e7          	jalr	1852(ra) # 5248 <exit>
      printf("%s: read failed %d\n", i);
     b14:	85aa                	mv	a1,a0
     b16:	00005517          	auipc	a0,0x5
     b1a:	3f250513          	addi	a0,a0,1010 # 5f08 <malloc+0x882>
     b1e:	00005097          	auipc	ra,0x5
     b22:	aaa080e7          	jalr	-1366(ra) # 55c8 <printf>
      exit(1);
     b26:	4505                	li	a0,1
     b28:	00004097          	auipc	ra,0x4
     b2c:	720080e7          	jalr	1824(ra) # 5248 <exit>
      printf("%s: read content of block %d is %d\n",
     b30:	85a6                	mv	a1,s1
     b32:	00005517          	auipc	a0,0x5
     b36:	3ee50513          	addi	a0,a0,1006 # 5f20 <malloc+0x89a>
     b3a:	00005097          	auipc	ra,0x5
     b3e:	a8e080e7          	jalr	-1394(ra) # 55c8 <printf>
      exit(1);
     b42:	4505                	li	a0,1
     b44:	00004097          	auipc	ra,0x4
     b48:	704080e7          	jalr	1796(ra) # 5248 <exit>
    printf("%s: unlink big failed\n", s);
     b4c:	85d6                	mv	a1,s5
     b4e:	00005517          	auipc	a0,0x5
     b52:	3fa50513          	addi	a0,a0,1018 # 5f48 <malloc+0x8c2>
     b56:	00005097          	auipc	ra,0x5
     b5a:	a72080e7          	jalr	-1422(ra) # 55c8 <printf>
    exit(1);
     b5e:	4505                	li	a0,1
     b60:	00004097          	auipc	ra,0x4
     b64:	6e8080e7          	jalr	1768(ra) # 5248 <exit>

0000000000000b68 <unlinkread>:
{
     b68:	7179                	addi	sp,sp,-48
     b6a:	f406                	sd	ra,40(sp)
     b6c:	f022                	sd	s0,32(sp)
     b6e:	ec26                	sd	s1,24(sp)
     b70:	e84a                	sd	s2,16(sp)
     b72:	e44e                	sd	s3,8(sp)
     b74:	1800                	addi	s0,sp,48
     b76:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b78:	20200593          	li	a1,514
     b7c:	00005517          	auipc	a0,0x5
     b80:	d3c50513          	addi	a0,a0,-708 # 58b8 <malloc+0x232>
     b84:	00004097          	auipc	ra,0x4
     b88:	704080e7          	jalr	1796(ra) # 5288 <open>
  if(fd < 0){
     b8c:	0e054563          	bltz	a0,c76 <unlinkread+0x10e>
     b90:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b92:	4615                	li	a2,5
     b94:	00005597          	auipc	a1,0x5
     b98:	3ec58593          	addi	a1,a1,1004 # 5f80 <malloc+0x8fa>
     b9c:	00004097          	auipc	ra,0x4
     ba0:	6cc080e7          	jalr	1740(ra) # 5268 <write>
  close(fd);
     ba4:	8526                	mv	a0,s1
     ba6:	00004097          	auipc	ra,0x4
     baa:	6ca080e7          	jalr	1738(ra) # 5270 <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	d0850513          	addi	a0,a0,-760 # 58b8 <malloc+0x232>
     bb8:	00004097          	auipc	ra,0x4
     bbc:	6d0080e7          	jalr	1744(ra) # 5288 <open>
     bc0:	84aa                	mv	s1,a0
  if(fd < 0){
     bc2:	0c054863          	bltz	a0,c92 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc6:	00005517          	auipc	a0,0x5
     bca:	cf250513          	addi	a0,a0,-782 # 58b8 <malloc+0x232>
     bce:	00004097          	auipc	ra,0x4
     bd2:	6ca080e7          	jalr	1738(ra) # 5298 <unlink>
     bd6:	ed61                	bnez	a0,cae <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd8:	20200593          	li	a1,514
     bdc:	00005517          	auipc	a0,0x5
     be0:	cdc50513          	addi	a0,a0,-804 # 58b8 <malloc+0x232>
     be4:	00004097          	auipc	ra,0x4
     be8:	6a4080e7          	jalr	1700(ra) # 5288 <open>
     bec:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bee:	460d                	li	a2,3
     bf0:	00005597          	auipc	a1,0x5
     bf4:	3d858593          	addi	a1,a1,984 # 5fc8 <malloc+0x942>
     bf8:	00004097          	auipc	ra,0x4
     bfc:	670080e7          	jalr	1648(ra) # 5268 <write>
  close(fd1);
     c00:	854a                	mv	a0,s2
     c02:	00004097          	auipc	ra,0x4
     c06:	66e080e7          	jalr	1646(ra) # 5270 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c0a:	660d                	lui	a2,0x3
     c0c:	0000b597          	auipc	a1,0xb
     c10:	93c58593          	addi	a1,a1,-1732 # b548 <buf>
     c14:	8526                	mv	a0,s1
     c16:	00004097          	auipc	ra,0x4
     c1a:	64a080e7          	jalr	1610(ra) # 5260 <read>
     c1e:	4795                	li	a5,5
     c20:	0af51563          	bne	a0,a5,cca <unlinkread+0x162>
  if(buf[0] != 'h'){
     c24:	0000b717          	auipc	a4,0xb
     c28:	92474703          	lbu	a4,-1756(a4) # b548 <buf>
     c2c:	06800793          	li	a5,104
     c30:	0af71b63          	bne	a4,a5,ce6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c34:	4629                	li	a2,10
     c36:	0000b597          	auipc	a1,0xb
     c3a:	91258593          	addi	a1,a1,-1774 # b548 <buf>
     c3e:	8526                	mv	a0,s1
     c40:	00004097          	auipc	ra,0x4
     c44:	628080e7          	jalr	1576(ra) # 5268 <write>
     c48:	47a9                	li	a5,10
     c4a:	0af51c63          	bne	a0,a5,d02 <unlinkread+0x19a>
  close(fd);
     c4e:	8526                	mv	a0,s1
     c50:	00004097          	auipc	ra,0x4
     c54:	620080e7          	jalr	1568(ra) # 5270 <close>
  unlink("unlinkread");
     c58:	00005517          	auipc	a0,0x5
     c5c:	c6050513          	addi	a0,a0,-928 # 58b8 <malloc+0x232>
     c60:	00004097          	auipc	ra,0x4
     c64:	638080e7          	jalr	1592(ra) # 5298 <unlink>
}
     c68:	70a2                	ld	ra,40(sp)
     c6a:	7402                	ld	s0,32(sp)
     c6c:	64e2                	ld	s1,24(sp)
     c6e:	6942                	ld	s2,16(sp)
     c70:	69a2                	ld	s3,8(sp)
     c72:	6145                	addi	sp,sp,48
     c74:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c76:	85ce                	mv	a1,s3
     c78:	00005517          	auipc	a0,0x5
     c7c:	2e850513          	addi	a0,a0,744 # 5f60 <malloc+0x8da>
     c80:	00005097          	auipc	ra,0x5
     c84:	948080e7          	jalr	-1720(ra) # 55c8 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	00004097          	auipc	ra,0x4
     c8e:	5be080e7          	jalr	1470(ra) # 5248 <exit>
    printf("%s: open unlinkread failed\n", s);
     c92:	85ce                	mv	a1,s3
     c94:	00005517          	auipc	a0,0x5
     c98:	2f450513          	addi	a0,a0,756 # 5f88 <malloc+0x902>
     c9c:	00005097          	auipc	ra,0x5
     ca0:	92c080e7          	jalr	-1748(ra) # 55c8 <printf>
    exit(1);
     ca4:	4505                	li	a0,1
     ca6:	00004097          	auipc	ra,0x4
     caa:	5a2080e7          	jalr	1442(ra) # 5248 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cae:	85ce                	mv	a1,s3
     cb0:	00005517          	auipc	a0,0x5
     cb4:	2f850513          	addi	a0,a0,760 # 5fa8 <malloc+0x922>
     cb8:	00005097          	auipc	ra,0x5
     cbc:	910080e7          	jalr	-1776(ra) # 55c8 <printf>
    exit(1);
     cc0:	4505                	li	a0,1
     cc2:	00004097          	auipc	ra,0x4
     cc6:	586080e7          	jalr	1414(ra) # 5248 <exit>
    printf("%s: unlinkread read failed", s);
     cca:	85ce                	mv	a1,s3
     ccc:	00005517          	auipc	a0,0x5
     cd0:	30450513          	addi	a0,a0,772 # 5fd0 <malloc+0x94a>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	8f4080e7          	jalr	-1804(ra) # 55c8 <printf>
    exit(1);
     cdc:	4505                	li	a0,1
     cde:	00004097          	auipc	ra,0x4
     ce2:	56a080e7          	jalr	1386(ra) # 5248 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce6:	85ce                	mv	a1,s3
     ce8:	00005517          	auipc	a0,0x5
     cec:	30850513          	addi	a0,a0,776 # 5ff0 <malloc+0x96a>
     cf0:	00005097          	auipc	ra,0x5
     cf4:	8d8080e7          	jalr	-1832(ra) # 55c8 <printf>
    exit(1);
     cf8:	4505                	li	a0,1
     cfa:	00004097          	auipc	ra,0x4
     cfe:	54e080e7          	jalr	1358(ra) # 5248 <exit>
    printf("%s: unlinkread write failed\n", s);
     d02:	85ce                	mv	a1,s3
     d04:	00005517          	auipc	a0,0x5
     d08:	30c50513          	addi	a0,a0,780 # 6010 <malloc+0x98a>
     d0c:	00005097          	auipc	ra,0x5
     d10:	8bc080e7          	jalr	-1860(ra) # 55c8 <printf>
    exit(1);
     d14:	4505                	li	a0,1
     d16:	00004097          	auipc	ra,0x4
     d1a:	532080e7          	jalr	1330(ra) # 5248 <exit>

0000000000000d1e <linktest>:
{
     d1e:	1101                	addi	sp,sp,-32
     d20:	ec06                	sd	ra,24(sp)
     d22:	e822                	sd	s0,16(sp)
     d24:	e426                	sd	s1,8(sp)
     d26:	e04a                	sd	s2,0(sp)
     d28:	1000                	addi	s0,sp,32
     d2a:	892a                	mv	s2,a0
  unlink("lf1");
     d2c:	00005517          	auipc	a0,0x5
     d30:	30450513          	addi	a0,a0,772 # 6030 <malloc+0x9aa>
     d34:	00004097          	auipc	ra,0x4
     d38:	564080e7          	jalr	1380(ra) # 5298 <unlink>
  unlink("lf2");
     d3c:	00005517          	auipc	a0,0x5
     d40:	2fc50513          	addi	a0,a0,764 # 6038 <malloc+0x9b2>
     d44:	00004097          	auipc	ra,0x4
     d48:	554080e7          	jalr	1364(ra) # 5298 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4c:	20200593          	li	a1,514
     d50:	00005517          	auipc	a0,0x5
     d54:	2e050513          	addi	a0,a0,736 # 6030 <malloc+0x9aa>
     d58:	00004097          	auipc	ra,0x4
     d5c:	530080e7          	jalr	1328(ra) # 5288 <open>
  if(fd < 0){
     d60:	10054763          	bltz	a0,e6e <linktest+0x150>
     d64:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d66:	4615                	li	a2,5
     d68:	00005597          	auipc	a1,0x5
     d6c:	21858593          	addi	a1,a1,536 # 5f80 <malloc+0x8fa>
     d70:	00004097          	auipc	ra,0x4
     d74:	4f8080e7          	jalr	1272(ra) # 5268 <write>
     d78:	4795                	li	a5,5
     d7a:	10f51863          	bne	a0,a5,e8a <linktest+0x16c>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	00004097          	auipc	ra,0x4
     d84:	4f0080e7          	jalr	1264(ra) # 5270 <close>
  if(link("lf1", "lf2") < 0){
     d88:	00005597          	auipc	a1,0x5
     d8c:	2b058593          	addi	a1,a1,688 # 6038 <malloc+0x9b2>
     d90:	00005517          	auipc	a0,0x5
     d94:	2a050513          	addi	a0,a0,672 # 6030 <malloc+0x9aa>
     d98:	00004097          	auipc	ra,0x4
     d9c:	510080e7          	jalr	1296(ra) # 52a8 <link>
     da0:	10054363          	bltz	a0,ea6 <linktest+0x188>
  unlink("lf1");
     da4:	00005517          	auipc	a0,0x5
     da8:	28c50513          	addi	a0,a0,652 # 6030 <malloc+0x9aa>
     dac:	00004097          	auipc	ra,0x4
     db0:	4ec080e7          	jalr	1260(ra) # 5298 <unlink>
  if(open("lf1", 0) >= 0){
     db4:	4581                	li	a1,0
     db6:	00005517          	auipc	a0,0x5
     dba:	27a50513          	addi	a0,a0,634 # 6030 <malloc+0x9aa>
     dbe:	00004097          	auipc	ra,0x4
     dc2:	4ca080e7          	jalr	1226(ra) # 5288 <open>
     dc6:	0e055e63          	bgez	a0,ec2 <linktest+0x1a4>
  fd = open("lf2", 0);
     dca:	4581                	li	a1,0
     dcc:	00005517          	auipc	a0,0x5
     dd0:	26c50513          	addi	a0,a0,620 # 6038 <malloc+0x9b2>
     dd4:	00004097          	auipc	ra,0x4
     dd8:	4b4080e7          	jalr	1204(ra) # 5288 <open>
     ddc:	84aa                	mv	s1,a0
  if(fd < 0){
     dde:	10054063          	bltz	a0,ede <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000a597          	auipc	a1,0xa
     de8:	76458593          	addi	a1,a1,1892 # b548 <buf>
     dec:	00004097          	auipc	ra,0x4
     df0:	474080e7          	jalr	1140(ra) # 5260 <read>
     df4:	4795                	li	a5,5
     df6:	10f51263          	bne	a0,a5,efa <linktest+0x1dc>
  close(fd);
     dfa:	8526                	mv	a0,s1
     dfc:	00004097          	auipc	ra,0x4
     e00:	474080e7          	jalr	1140(ra) # 5270 <close>
  if(link("lf2", "lf2") >= 0){
     e04:	00005597          	auipc	a1,0x5
     e08:	23458593          	addi	a1,a1,564 # 6038 <malloc+0x9b2>
     e0c:	852e                	mv	a0,a1
     e0e:	00004097          	auipc	ra,0x4
     e12:	49a080e7          	jalr	1178(ra) # 52a8 <link>
     e16:	10055063          	bgez	a0,f16 <linktest+0x1f8>
  unlink("lf2");
     e1a:	00005517          	auipc	a0,0x5
     e1e:	21e50513          	addi	a0,a0,542 # 6038 <malloc+0x9b2>
     e22:	00004097          	auipc	ra,0x4
     e26:	476080e7          	jalr	1142(ra) # 5298 <unlink>
  if(link("lf2", "lf1") >= 0){
     e2a:	00005597          	auipc	a1,0x5
     e2e:	20658593          	addi	a1,a1,518 # 6030 <malloc+0x9aa>
     e32:	00005517          	auipc	a0,0x5
     e36:	20650513          	addi	a0,a0,518 # 6038 <malloc+0x9b2>
     e3a:	00004097          	auipc	ra,0x4
     e3e:	46e080e7          	jalr	1134(ra) # 52a8 <link>
     e42:	0e055863          	bgez	a0,f32 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e46:	00005597          	auipc	a1,0x5
     e4a:	1ea58593          	addi	a1,a1,490 # 6030 <malloc+0x9aa>
     e4e:	00005517          	auipc	a0,0x5
     e52:	2f250513          	addi	a0,a0,754 # 6140 <malloc+0xaba>
     e56:	00004097          	auipc	ra,0x4
     e5a:	452080e7          	jalr	1106(ra) # 52a8 <link>
     e5e:	0e055863          	bgez	a0,f4e <linktest+0x230>
}
     e62:	60e2                	ld	ra,24(sp)
     e64:	6442                	ld	s0,16(sp)
     e66:	64a2                	ld	s1,8(sp)
     e68:	6902                	ld	s2,0(sp)
     e6a:	6105                	addi	sp,sp,32
     e6c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e6e:	85ca                	mv	a1,s2
     e70:	00005517          	auipc	a0,0x5
     e74:	1d050513          	addi	a0,a0,464 # 6040 <malloc+0x9ba>
     e78:	00004097          	auipc	ra,0x4
     e7c:	750080e7          	jalr	1872(ra) # 55c8 <printf>
    exit(1);
     e80:	4505                	li	a0,1
     e82:	00004097          	auipc	ra,0x4
     e86:	3c6080e7          	jalr	966(ra) # 5248 <exit>
    printf("%s: write lf1 failed\n", s);
     e8a:	85ca                	mv	a1,s2
     e8c:	00005517          	auipc	a0,0x5
     e90:	1cc50513          	addi	a0,a0,460 # 6058 <malloc+0x9d2>
     e94:	00004097          	auipc	ra,0x4
     e98:	734080e7          	jalr	1844(ra) # 55c8 <printf>
    exit(1);
     e9c:	4505                	li	a0,1
     e9e:	00004097          	auipc	ra,0x4
     ea2:	3aa080e7          	jalr	938(ra) # 5248 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea6:	85ca                	mv	a1,s2
     ea8:	00005517          	auipc	a0,0x5
     eac:	1c850513          	addi	a0,a0,456 # 6070 <malloc+0x9ea>
     eb0:	00004097          	auipc	ra,0x4
     eb4:	718080e7          	jalr	1816(ra) # 55c8 <printf>
    exit(1);
     eb8:	4505                	li	a0,1
     eba:	00004097          	auipc	ra,0x4
     ebe:	38e080e7          	jalr	910(ra) # 5248 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec2:	85ca                	mv	a1,s2
     ec4:	00005517          	auipc	a0,0x5
     ec8:	1cc50513          	addi	a0,a0,460 # 6090 <malloc+0xa0a>
     ecc:	00004097          	auipc	ra,0x4
     ed0:	6fc080e7          	jalr	1788(ra) # 55c8 <printf>
    exit(1);
     ed4:	4505                	li	a0,1
     ed6:	00004097          	auipc	ra,0x4
     eda:	372080e7          	jalr	882(ra) # 5248 <exit>
    printf("%s: open lf2 failed\n", s);
     ede:	85ca                	mv	a1,s2
     ee0:	00005517          	auipc	a0,0x5
     ee4:	1e050513          	addi	a0,a0,480 # 60c0 <malloc+0xa3a>
     ee8:	00004097          	auipc	ra,0x4
     eec:	6e0080e7          	jalr	1760(ra) # 55c8 <printf>
    exit(1);
     ef0:	4505                	li	a0,1
     ef2:	00004097          	auipc	ra,0x4
     ef6:	356080e7          	jalr	854(ra) # 5248 <exit>
    printf("%s: read lf2 failed\n", s);
     efa:	85ca                	mv	a1,s2
     efc:	00005517          	auipc	a0,0x5
     f00:	1dc50513          	addi	a0,a0,476 # 60d8 <malloc+0xa52>
     f04:	00004097          	auipc	ra,0x4
     f08:	6c4080e7          	jalr	1732(ra) # 55c8 <printf>
    exit(1);
     f0c:	4505                	li	a0,1
     f0e:	00004097          	auipc	ra,0x4
     f12:	33a080e7          	jalr	826(ra) # 5248 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f16:	85ca                	mv	a1,s2
     f18:	00005517          	auipc	a0,0x5
     f1c:	1d850513          	addi	a0,a0,472 # 60f0 <malloc+0xa6a>
     f20:	00004097          	auipc	ra,0x4
     f24:	6a8080e7          	jalr	1704(ra) # 55c8 <printf>
    exit(1);
     f28:	4505                	li	a0,1
     f2a:	00004097          	auipc	ra,0x4
     f2e:	31e080e7          	jalr	798(ra) # 5248 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f32:	85ca                	mv	a1,s2
     f34:	00005517          	auipc	a0,0x5
     f38:	1e450513          	addi	a0,a0,484 # 6118 <malloc+0xa92>
     f3c:	00004097          	auipc	ra,0x4
     f40:	68c080e7          	jalr	1676(ra) # 55c8 <printf>
    exit(1);
     f44:	4505                	li	a0,1
     f46:	00004097          	auipc	ra,0x4
     f4a:	302080e7          	jalr	770(ra) # 5248 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4e:	85ca                	mv	a1,s2
     f50:	00005517          	auipc	a0,0x5
     f54:	1f850513          	addi	a0,a0,504 # 6148 <malloc+0xac2>
     f58:	00004097          	auipc	ra,0x4
     f5c:	670080e7          	jalr	1648(ra) # 55c8 <printf>
    exit(1);
     f60:	4505                	li	a0,1
     f62:	00004097          	auipc	ra,0x4
     f66:	2e6080e7          	jalr	742(ra) # 5248 <exit>

0000000000000f6a <bigdir>:
{
     f6a:	715d                	addi	sp,sp,-80
     f6c:	e486                	sd	ra,72(sp)
     f6e:	e0a2                	sd	s0,64(sp)
     f70:	fc26                	sd	s1,56(sp)
     f72:	f84a                	sd	s2,48(sp)
     f74:	f44e                	sd	s3,40(sp)
     f76:	f052                	sd	s4,32(sp)
     f78:	ec56                	sd	s5,24(sp)
     f7a:	e85a                	sd	s6,16(sp)
     f7c:	0880                	addi	s0,sp,80
     f7e:	89aa                	mv	s3,a0
  unlink("bd");
     f80:	00005517          	auipc	a0,0x5
     f84:	1e850513          	addi	a0,a0,488 # 6168 <malloc+0xae2>
     f88:	00004097          	auipc	ra,0x4
     f8c:	310080e7          	jalr	784(ra) # 5298 <unlink>
  fd = open("bd", O_CREATE);
     f90:	20000593          	li	a1,512
     f94:	00005517          	auipc	a0,0x5
     f98:	1d450513          	addi	a0,a0,468 # 6168 <malloc+0xae2>
     f9c:	00004097          	auipc	ra,0x4
     fa0:	2ec080e7          	jalr	748(ra) # 5288 <open>
  if(fd < 0){
     fa4:	0c054963          	bltz	a0,1076 <bigdir+0x10c>
  close(fd);
     fa8:	00004097          	auipc	ra,0x4
     fac:	2c8080e7          	jalr	712(ra) # 5270 <close>
  for(i = 0; i < N; i++){
     fb0:	4901                	li	s2,0
    name[0] = 'x';
     fb2:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb6:	00005a17          	auipc	s4,0x5
     fba:	1b2a0a13          	addi	s4,s4,434 # 6168 <malloc+0xae2>
  for(i = 0; i < N; i++){
     fbe:	1f400b13          	li	s6,500
    name[0] = 'x';
     fc2:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc6:	41f9579b          	sraiw	a5,s2,0x1f
     fca:	01a7d71b          	srliw	a4,a5,0x1a
     fce:	012707bb          	addw	a5,a4,s2
     fd2:	4067d69b          	sraiw	a3,a5,0x6
     fd6:	0306869b          	addiw	a3,a3,48
     fda:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fde:	03f7f793          	andi	a5,a5,63
     fe2:	9f99                	subw	a5,a5,a4
     fe4:	0307879b          	addiw	a5,a5,48
     fe8:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fec:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     ff0:	fb040593          	addi	a1,s0,-80
     ff4:	8552                	mv	a0,s4
     ff6:	00004097          	auipc	ra,0x4
     ffa:	2b2080e7          	jalr	690(ra) # 52a8 <link>
     ffe:	84aa                	mv	s1,a0
    1000:	e949                	bnez	a0,1092 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1002:	2905                	addiw	s2,s2,1
    1004:	fb691fe3          	bne	s2,s6,fc2 <bigdir+0x58>
  unlink("bd");
    1008:	00005517          	auipc	a0,0x5
    100c:	16050513          	addi	a0,a0,352 # 6168 <malloc+0xae2>
    1010:	00004097          	auipc	ra,0x4
    1014:	288080e7          	jalr	648(ra) # 5298 <unlink>
    name[0] = 'x';
    1018:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    101c:	1f400a13          	li	s4,500
    name[0] = 'x';
    1020:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1024:	41f4d79b          	sraiw	a5,s1,0x1f
    1028:	01a7d71b          	srliw	a4,a5,0x1a
    102c:	009707bb          	addw	a5,a4,s1
    1030:	4067d69b          	sraiw	a3,a5,0x6
    1034:	0306869b          	addiw	a3,a3,48
    1038:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    103c:	03f7f793          	andi	a5,a5,63
    1040:	9f99                	subw	a5,a5,a4
    1042:	0307879b          	addiw	a5,a5,48
    1046:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    104a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    104e:	fb040513          	addi	a0,s0,-80
    1052:	00004097          	auipc	ra,0x4
    1056:	246080e7          	jalr	582(ra) # 5298 <unlink>
    105a:	ed21                	bnez	a0,10b2 <bigdir+0x148>
  for(i = 0; i < N; i++){
    105c:	2485                	addiw	s1,s1,1
    105e:	fd4491e3          	bne	s1,s4,1020 <bigdir+0xb6>
}
    1062:	60a6                	ld	ra,72(sp)
    1064:	6406                	ld	s0,64(sp)
    1066:	74e2                	ld	s1,56(sp)
    1068:	7942                	ld	s2,48(sp)
    106a:	79a2                	ld	s3,40(sp)
    106c:	7a02                	ld	s4,32(sp)
    106e:	6ae2                	ld	s5,24(sp)
    1070:	6b42                	ld	s6,16(sp)
    1072:	6161                	addi	sp,sp,80
    1074:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1076:	85ce                	mv	a1,s3
    1078:	00005517          	auipc	a0,0x5
    107c:	0f850513          	addi	a0,a0,248 # 6170 <malloc+0xaea>
    1080:	00004097          	auipc	ra,0x4
    1084:	548080e7          	jalr	1352(ra) # 55c8 <printf>
    exit(1);
    1088:	4505                	li	a0,1
    108a:	00004097          	auipc	ra,0x4
    108e:	1be080e7          	jalr	446(ra) # 5248 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1092:	fb040613          	addi	a2,s0,-80
    1096:	85ce                	mv	a1,s3
    1098:	00005517          	auipc	a0,0x5
    109c:	0f850513          	addi	a0,a0,248 # 6190 <malloc+0xb0a>
    10a0:	00004097          	auipc	ra,0x4
    10a4:	528080e7          	jalr	1320(ra) # 55c8 <printf>
      exit(1);
    10a8:	4505                	li	a0,1
    10aa:	00004097          	auipc	ra,0x4
    10ae:	19e080e7          	jalr	414(ra) # 5248 <exit>
      printf("%s: bigdir unlink failed", s);
    10b2:	85ce                	mv	a1,s3
    10b4:	00005517          	auipc	a0,0x5
    10b8:	0fc50513          	addi	a0,a0,252 # 61b0 <malloc+0xb2a>
    10bc:	00004097          	auipc	ra,0x4
    10c0:	50c080e7          	jalr	1292(ra) # 55c8 <printf>
      exit(1);
    10c4:	4505                	li	a0,1
    10c6:	00004097          	auipc	ra,0x4
    10ca:	182080e7          	jalr	386(ra) # 5248 <exit>

00000000000010ce <validatetest>:
{
    10ce:	7139                	addi	sp,sp,-64
    10d0:	fc06                	sd	ra,56(sp)
    10d2:	f822                	sd	s0,48(sp)
    10d4:	f426                	sd	s1,40(sp)
    10d6:	f04a                	sd	s2,32(sp)
    10d8:	ec4e                	sd	s3,24(sp)
    10da:	e852                	sd	s4,16(sp)
    10dc:	e456                	sd	s5,8(sp)
    10de:	e05a                	sd	s6,0(sp)
    10e0:	0080                	addi	s0,sp,64
    10e2:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e4:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e6:	00005997          	auipc	s3,0x5
    10ea:	0ea98993          	addi	s3,s3,234 # 61d0 <malloc+0xb4a>
    10ee:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f0:	6a85                	lui	s5,0x1
    10f2:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f6:	85a6                	mv	a1,s1
    10f8:	854e                	mv	a0,s3
    10fa:	00004097          	auipc	ra,0x4
    10fe:	1ae080e7          	jalr	430(ra) # 52a8 <link>
    1102:	01251f63          	bne	a0,s2,1120 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1106:	94d6                	add	s1,s1,s5
    1108:	ff4497e3          	bne	s1,s4,10f6 <validatetest+0x28>
}
    110c:	70e2                	ld	ra,56(sp)
    110e:	7442                	ld	s0,48(sp)
    1110:	74a2                	ld	s1,40(sp)
    1112:	7902                	ld	s2,32(sp)
    1114:	69e2                	ld	s3,24(sp)
    1116:	6a42                	ld	s4,16(sp)
    1118:	6aa2                	ld	s5,8(sp)
    111a:	6b02                	ld	s6,0(sp)
    111c:	6121                	addi	sp,sp,64
    111e:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1120:	85da                	mv	a1,s6
    1122:	00005517          	auipc	a0,0x5
    1126:	0be50513          	addi	a0,a0,190 # 61e0 <malloc+0xb5a>
    112a:	00004097          	auipc	ra,0x4
    112e:	49e080e7          	jalr	1182(ra) # 55c8 <printf>
      exit(1);
    1132:	4505                	li	a0,1
    1134:	00004097          	auipc	ra,0x4
    1138:	114080e7          	jalr	276(ra) # 5248 <exit>

000000000000113c <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    113c:	7179                	addi	sp,sp,-48
    113e:	f406                	sd	ra,40(sp)
    1140:	f022                	sd	s0,32(sp)
    1142:	ec26                	sd	s1,24(sp)
    1144:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1146:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    114a:	00007497          	auipc	s1,0x7
    114e:	bc64b483          	ld	s1,-1082(s1) # 7d10 <__SDATA_BEGIN__>
    1152:	fd840593          	addi	a1,s0,-40
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	128080e7          	jalr	296(ra) # 5280 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1160:	8526                	mv	a0,s1
    1162:	00004097          	auipc	ra,0x4
    1166:	0f6080e7          	jalr	246(ra) # 5258 <pipe>

  exit(0);
    116a:	4501                	li	a0,0
    116c:	00004097          	auipc	ra,0x4
    1170:	0dc080e7          	jalr	220(ra) # 5248 <exit>

0000000000001174 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1174:	7139                	addi	sp,sp,-64
    1176:	fc06                	sd	ra,56(sp)
    1178:	f822                	sd	s0,48(sp)
    117a:	f426                	sd	s1,40(sp)
    117c:	f04a                	sd	s2,32(sp)
    117e:	ec4e                	sd	s3,24(sp)
    1180:	0080                	addi	s0,sp,64
    1182:	64b1                	lui	s1,0xc
    1184:	35048493          	addi	s1,s1,848 # c350 <buf+0xe08>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1188:	597d                	li	s2,-1
    118a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118e:	00005997          	auipc	s3,0x5
    1192:	91a98993          	addi	s3,s3,-1766 # 5aa8 <malloc+0x422>
    argv[0] = (char*)0xffffffff;
    1196:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    119a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119e:	fc040593          	addi	a1,s0,-64
    11a2:	854e                	mv	a0,s3
    11a4:	00004097          	auipc	ra,0x4
    11a8:	0dc080e7          	jalr	220(ra) # 5280 <exec>
  for(int i = 0; i < 50000; i++){
    11ac:	34fd                	addiw	s1,s1,-1
    11ae:	f4e5                	bnez	s1,1196 <badarg+0x22>
  }
  
  exit(0);
    11b0:	4501                	li	a0,0
    11b2:	00004097          	auipc	ra,0x4
    11b6:	096080e7          	jalr	150(ra) # 5248 <exit>

00000000000011ba <copyinstr2>:
{
    11ba:	7155                	addi	sp,sp,-208
    11bc:	e586                	sd	ra,200(sp)
    11be:	e1a2                	sd	s0,192(sp)
    11c0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c2:	f6840793          	addi	a5,s0,-152
    11c6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11ca:	07800713          	li	a4,120
    11ce:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d2:	0785                	addi	a5,a5,1
    11d4:	fed79de3          	bne	a5,a3,11ce <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11dc:	f6840513          	addi	a0,s0,-152
    11e0:	00004097          	auipc	ra,0x4
    11e4:	0b8080e7          	jalr	184(ra) # 5298 <unlink>
  if(ret != -1){
    11e8:	57fd                	li	a5,-1
    11ea:	0ef51063          	bne	a0,a5,12ca <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ee:	20100593          	li	a1,513
    11f2:	f6840513          	addi	a0,s0,-152
    11f6:	00004097          	auipc	ra,0x4
    11fa:	092080e7          	jalr	146(ra) # 5288 <open>
  if(fd != -1){
    11fe:	57fd                	li	a5,-1
    1200:	0ef51563          	bne	a0,a5,12ea <copyinstr2+0x130>
  ret = link(b, b);
    1204:	f6840593          	addi	a1,s0,-152
    1208:	852e                	mv	a0,a1
    120a:	00004097          	auipc	ra,0x4
    120e:	09e080e7          	jalr	158(ra) # 52a8 <link>
  if(ret != -1){
    1212:	57fd                	li	a5,-1
    1214:	0ef51b63          	bne	a0,a5,130a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1218:	00006797          	auipc	a5,0x6
    121c:	07078793          	addi	a5,a5,112 # 7288 <malloc+0x1c02>
    1220:	f4f43c23          	sd	a5,-168(s0)
    1224:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1228:	f5840593          	addi	a1,s0,-168
    122c:	f6840513          	addi	a0,s0,-152
    1230:	00004097          	auipc	ra,0x4
    1234:	050080e7          	jalr	80(ra) # 5280 <exec>
  if(ret != -1){
    1238:	57fd                	li	a5,-1
    123a:	0ef51963          	bne	a0,a5,132c <copyinstr2+0x172>
  int pid = fork();
    123e:	00004097          	auipc	ra,0x4
    1242:	002080e7          	jalr	2(ra) # 5240 <fork>
  if(pid < 0){
    1246:	10054363          	bltz	a0,134c <copyinstr2+0x192>
  if(pid == 0){
    124a:	12051463          	bnez	a0,1372 <copyinstr2+0x1b8>
    124e:	00007797          	auipc	a5,0x7
    1252:	be278793          	addi	a5,a5,-1054 # 7e30 <big.1267>
    1256:	00008697          	auipc	a3,0x8
    125a:	bda68693          	addi	a3,a3,-1062 # 8e30 <__global_pointer$+0x920>
      big[i] = 'x';
    125e:	07800713          	li	a4,120
    1262:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1266:	0785                	addi	a5,a5,1
    1268:	fed79de3          	bne	a5,a3,1262 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126c:	00008797          	auipc	a5,0x8
    1270:	bc078223          	sb	zero,-1084(a5) # 8e30 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1274:	00006797          	auipc	a5,0x6
    1278:	6dc78793          	addi	a5,a5,1756 # 7950 <malloc+0x22ca>
    127c:	6390                	ld	a2,0(a5)
    127e:	6794                	ld	a3,8(a5)
    1280:	6b98                	ld	a4,16(a5)
    1282:	6f9c                	ld	a5,24(a5)
    1284:	f2c43823          	sd	a2,-208(s0)
    1288:	f2d43c23          	sd	a3,-200(s0)
    128c:	f4e43023          	sd	a4,-192(s0)
    1290:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1294:	f3040593          	addi	a1,s0,-208
    1298:	00005517          	auipc	a0,0x5
    129c:	81050513          	addi	a0,a0,-2032 # 5aa8 <malloc+0x422>
    12a0:	00004097          	auipc	ra,0x4
    12a4:	fe0080e7          	jalr	-32(ra) # 5280 <exec>
    if(ret != -1){
    12a8:	57fd                	li	a5,-1
    12aa:	0af50e63          	beq	a0,a5,1366 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ae:	55fd                	li	a1,-1
    12b0:	00005517          	auipc	a0,0x5
    12b4:	fd850513          	addi	a0,a0,-40 # 6288 <malloc+0xc02>
    12b8:	00004097          	auipc	ra,0x4
    12bc:	310080e7          	jalr	784(ra) # 55c8 <printf>
      exit(1);
    12c0:	4505                	li	a0,1
    12c2:	00004097          	auipc	ra,0x4
    12c6:	f86080e7          	jalr	-122(ra) # 5248 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12ca:	862a                	mv	a2,a0
    12cc:	f6840593          	addi	a1,s0,-152
    12d0:	00005517          	auipc	a0,0x5
    12d4:	f3050513          	addi	a0,a0,-208 # 6200 <malloc+0xb7a>
    12d8:	00004097          	auipc	ra,0x4
    12dc:	2f0080e7          	jalr	752(ra) # 55c8 <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00004097          	auipc	ra,0x4
    12e6:	f66080e7          	jalr	-154(ra) # 5248 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12ea:	862a                	mv	a2,a0
    12ec:	f6840593          	addi	a1,s0,-152
    12f0:	00005517          	auipc	a0,0x5
    12f4:	f3050513          	addi	a0,a0,-208 # 6220 <malloc+0xb9a>
    12f8:	00004097          	auipc	ra,0x4
    12fc:	2d0080e7          	jalr	720(ra) # 55c8 <printf>
    exit(1);
    1300:	4505                	li	a0,1
    1302:	00004097          	auipc	ra,0x4
    1306:	f46080e7          	jalr	-186(ra) # 5248 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    130a:	86aa                	mv	a3,a0
    130c:	f6840613          	addi	a2,s0,-152
    1310:	85b2                	mv	a1,a2
    1312:	00005517          	auipc	a0,0x5
    1316:	f2e50513          	addi	a0,a0,-210 # 6240 <malloc+0xbba>
    131a:	00004097          	auipc	ra,0x4
    131e:	2ae080e7          	jalr	686(ra) # 55c8 <printf>
    exit(1);
    1322:	4505                	li	a0,1
    1324:	00004097          	auipc	ra,0x4
    1328:	f24080e7          	jalr	-220(ra) # 5248 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132c:	567d                	li	a2,-1
    132e:	f6840593          	addi	a1,s0,-152
    1332:	00005517          	auipc	a0,0x5
    1336:	f3650513          	addi	a0,a0,-202 # 6268 <malloc+0xbe2>
    133a:	00004097          	auipc	ra,0x4
    133e:	28e080e7          	jalr	654(ra) # 55c8 <printf>
    exit(1);
    1342:	4505                	li	a0,1
    1344:	00004097          	auipc	ra,0x4
    1348:	f04080e7          	jalr	-252(ra) # 5248 <exit>
    printf("fork failed\n");
    134c:	00005517          	auipc	a0,0x5
    1350:	38450513          	addi	a0,a0,900 # 66d0 <malloc+0x104a>
    1354:	00004097          	auipc	ra,0x4
    1358:	274080e7          	jalr	628(ra) # 55c8 <printf>
    exit(1);
    135c:	4505                	li	a0,1
    135e:	00004097          	auipc	ra,0x4
    1362:	eea080e7          	jalr	-278(ra) # 5248 <exit>
    exit(747); // OK
    1366:	2eb00513          	li	a0,747
    136a:	00004097          	auipc	ra,0x4
    136e:	ede080e7          	jalr	-290(ra) # 5248 <exit>
  int st = 0;
    1372:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1376:	f5440513          	addi	a0,s0,-172
    137a:	00004097          	auipc	ra,0x4
    137e:	ed6080e7          	jalr	-298(ra) # 5250 <wait>
  if(st != 747){
    1382:	f5442703          	lw	a4,-172(s0)
    1386:	2eb00793          	li	a5,747
    138a:	00f71663          	bne	a4,a5,1396 <copyinstr2+0x1dc>
}
    138e:	60ae                	ld	ra,200(sp)
    1390:	640e                	ld	s0,192(sp)
    1392:	6169                	addi	sp,sp,208
    1394:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1396:	00005517          	auipc	a0,0x5
    139a:	f1a50513          	addi	a0,a0,-230 # 62b0 <malloc+0xc2a>
    139e:	00004097          	auipc	ra,0x4
    13a2:	22a080e7          	jalr	554(ra) # 55c8 <printf>
    exit(1);
    13a6:	4505                	li	a0,1
    13a8:	00004097          	auipc	ra,0x4
    13ac:	ea0080e7          	jalr	-352(ra) # 5248 <exit>

00000000000013b0 <truncate3>:
{
    13b0:	7159                	addi	sp,sp,-112
    13b2:	f486                	sd	ra,104(sp)
    13b4:	f0a2                	sd	s0,96(sp)
    13b6:	eca6                	sd	s1,88(sp)
    13b8:	e8ca                	sd	s2,80(sp)
    13ba:	e4ce                	sd	s3,72(sp)
    13bc:	e0d2                	sd	s4,64(sp)
    13be:	fc56                	sd	s5,56(sp)
    13c0:	1880                	addi	s0,sp,112
    13c2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13c4:	60100593          	li	a1,1537
    13c8:	00004517          	auipc	a0,0x4
    13cc:	73850513          	addi	a0,a0,1848 # 5b00 <malloc+0x47a>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	eb8080e7          	jalr	-328(ra) # 5288 <open>
    13d8:	00004097          	auipc	ra,0x4
    13dc:	e98080e7          	jalr	-360(ra) # 5270 <close>
  pid = fork();
    13e0:	00004097          	auipc	ra,0x4
    13e4:	e60080e7          	jalr	-416(ra) # 5240 <fork>
  if(pid < 0){
    13e8:	08054063          	bltz	a0,1468 <truncate3+0xb8>
  if(pid == 0){
    13ec:	e969                	bnez	a0,14be <truncate3+0x10e>
    13ee:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f2:	00004a17          	auipc	s4,0x4
    13f6:	70ea0a13          	addi	s4,s4,1806 # 5b00 <malloc+0x47a>
      int n = write(fd, "1234567890", 10);
    13fa:	00005a97          	auipc	s5,0x5
    13fe:	f16a8a93          	addi	s5,s5,-234 # 6310 <malloc+0xc8a>
      int fd = open("truncfile", O_WRONLY);
    1402:	4585                	li	a1,1
    1404:	8552                	mv	a0,s4
    1406:	00004097          	auipc	ra,0x4
    140a:	e82080e7          	jalr	-382(ra) # 5288 <open>
    140e:	84aa                	mv	s1,a0
      if(fd < 0){
    1410:	06054a63          	bltz	a0,1484 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1414:	4629                	li	a2,10
    1416:	85d6                	mv	a1,s5
    1418:	00004097          	auipc	ra,0x4
    141c:	e50080e7          	jalr	-432(ra) # 5268 <write>
      if(n != 10){
    1420:	47a9                	li	a5,10
    1422:	06f51f63          	bne	a0,a5,14a0 <truncate3+0xf0>
      close(fd);
    1426:	8526                	mv	a0,s1
    1428:	00004097          	auipc	ra,0x4
    142c:	e48080e7          	jalr	-440(ra) # 5270 <close>
      fd = open("truncfile", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	8552                	mv	a0,s4
    1434:	00004097          	auipc	ra,0x4
    1438:	e54080e7          	jalr	-428(ra) # 5288 <open>
    143c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143e:	02000613          	li	a2,32
    1442:	f9840593          	addi	a1,s0,-104
    1446:	00004097          	auipc	ra,0x4
    144a:	e1a080e7          	jalr	-486(ra) # 5260 <read>
      close(fd);
    144e:	8526                	mv	a0,s1
    1450:	00004097          	auipc	ra,0x4
    1454:	e20080e7          	jalr	-480(ra) # 5270 <close>
    for(int i = 0; i < 100; i++){
    1458:	39fd                	addiw	s3,s3,-1
    145a:	fa0994e3          	bnez	s3,1402 <truncate3+0x52>
    exit(0);
    145e:	4501                	li	a0,0
    1460:	00004097          	auipc	ra,0x4
    1464:	de8080e7          	jalr	-536(ra) # 5248 <exit>
    printf("%s: fork failed\n", s);
    1468:	85ca                	mv	a1,s2
    146a:	00005517          	auipc	a0,0x5
    146e:	e7650513          	addi	a0,a0,-394 # 62e0 <malloc+0xc5a>
    1472:	00004097          	auipc	ra,0x4
    1476:	156080e7          	jalr	342(ra) # 55c8 <printf>
    exit(1);
    147a:	4505                	li	a0,1
    147c:	00004097          	auipc	ra,0x4
    1480:	dcc080e7          	jalr	-564(ra) # 5248 <exit>
        printf("%s: open failed\n", s);
    1484:	85ca                	mv	a1,s2
    1486:	00005517          	auipc	a0,0x5
    148a:	e7250513          	addi	a0,a0,-398 # 62f8 <malloc+0xc72>
    148e:	00004097          	auipc	ra,0x4
    1492:	13a080e7          	jalr	314(ra) # 55c8 <printf>
        exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	db0080e7          	jalr	-592(ra) # 5248 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14a0:	862a                	mv	a2,a0
    14a2:	85ca                	mv	a1,s2
    14a4:	00005517          	auipc	a0,0x5
    14a8:	e7c50513          	addi	a0,a0,-388 # 6320 <malloc+0xc9a>
    14ac:	00004097          	auipc	ra,0x4
    14b0:	11c080e7          	jalr	284(ra) # 55c8 <printf>
        exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00004097          	auipc	ra,0x4
    14ba:	d92080e7          	jalr	-622(ra) # 5248 <exit>
    14be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c2:	00004a17          	auipc	s4,0x4
    14c6:	63ea0a13          	addi	s4,s4,1598 # 5b00 <malloc+0x47a>
    int n = write(fd, "xxx", 3);
    14ca:	00005a97          	auipc	s5,0x5
    14ce:	e76a8a93          	addi	s5,s5,-394 # 6340 <malloc+0xcba>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d2:	60100593          	li	a1,1537
    14d6:	8552                	mv	a0,s4
    14d8:	00004097          	auipc	ra,0x4
    14dc:	db0080e7          	jalr	-592(ra) # 5288 <open>
    14e0:	84aa                	mv	s1,a0
    if(fd < 0){
    14e2:	04054763          	bltz	a0,1530 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e6:	460d                	li	a2,3
    14e8:	85d6                	mv	a1,s5
    14ea:	00004097          	auipc	ra,0x4
    14ee:	d7e080e7          	jalr	-642(ra) # 5268 <write>
    if(n != 3){
    14f2:	478d                	li	a5,3
    14f4:	04f51c63          	bne	a0,a5,154c <truncate3+0x19c>
    close(fd);
    14f8:	8526                	mv	a0,s1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	d76080e7          	jalr	-650(ra) # 5270 <close>
  for(int i = 0; i < 150; i++){
    1502:	39fd                	addiw	s3,s3,-1
    1504:	fc0997e3          	bnez	s3,14d2 <truncate3+0x122>
  wait(&xstatus);
    1508:	fbc40513          	addi	a0,s0,-68
    150c:	00004097          	auipc	ra,0x4
    1510:	d44080e7          	jalr	-700(ra) # 5250 <wait>
  unlink("truncfile");
    1514:	00004517          	auipc	a0,0x4
    1518:	5ec50513          	addi	a0,a0,1516 # 5b00 <malloc+0x47a>
    151c:	00004097          	auipc	ra,0x4
    1520:	d7c080e7          	jalr	-644(ra) # 5298 <unlink>
  exit(xstatus);
    1524:	fbc42503          	lw	a0,-68(s0)
    1528:	00004097          	auipc	ra,0x4
    152c:	d20080e7          	jalr	-736(ra) # 5248 <exit>
      printf("%s: open failed\n", s);
    1530:	85ca                	mv	a1,s2
    1532:	00005517          	auipc	a0,0x5
    1536:	dc650513          	addi	a0,a0,-570 # 62f8 <malloc+0xc72>
    153a:	00004097          	auipc	ra,0x4
    153e:	08e080e7          	jalr	142(ra) # 55c8 <printf>
      exit(1);
    1542:	4505                	li	a0,1
    1544:	00004097          	auipc	ra,0x4
    1548:	d04080e7          	jalr	-764(ra) # 5248 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154c:	862a                	mv	a2,a0
    154e:	85ca                	mv	a1,s2
    1550:	00005517          	auipc	a0,0x5
    1554:	df850513          	addi	a0,a0,-520 # 6348 <malloc+0xcc2>
    1558:	00004097          	auipc	ra,0x4
    155c:	070080e7          	jalr	112(ra) # 55c8 <printf>
      exit(1);
    1560:	4505                	li	a0,1
    1562:	00004097          	auipc	ra,0x4
    1566:	ce6080e7          	jalr	-794(ra) # 5248 <exit>

000000000000156a <exectest>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	0880                	addi	s0,sp,80
    1576:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1578:	00004797          	auipc	a5,0x4
    157c:	53078793          	addi	a5,a5,1328 # 5aa8 <malloc+0x422>
    1580:	fcf43023          	sd	a5,-64(s0)
    1584:	00005797          	auipc	a5,0x5
    1588:	de478793          	addi	a5,a5,-540 # 6368 <malloc+0xce2>
    158c:	fcf43423          	sd	a5,-56(s0)
    1590:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1594:	00005517          	auipc	a0,0x5
    1598:	ddc50513          	addi	a0,a0,-548 # 6370 <malloc+0xcea>
    159c:	00004097          	auipc	ra,0x4
    15a0:	cfc080e7          	jalr	-772(ra) # 5298 <unlink>
  pid = fork();
    15a4:	00004097          	auipc	ra,0x4
    15a8:	c9c080e7          	jalr	-868(ra) # 5240 <fork>
  if(pid < 0) {
    15ac:	04054663          	bltz	a0,15f8 <exectest+0x8e>
    15b0:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b2:	e959                	bnez	a0,1648 <exectest+0xde>
    close(1);
    15b4:	4505                	li	a0,1
    15b6:	00004097          	auipc	ra,0x4
    15ba:	cba080e7          	jalr	-838(ra) # 5270 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15be:	20100593          	li	a1,513
    15c2:	00005517          	auipc	a0,0x5
    15c6:	dae50513          	addi	a0,a0,-594 # 6370 <malloc+0xcea>
    15ca:	00004097          	auipc	ra,0x4
    15ce:	cbe080e7          	jalr	-834(ra) # 5288 <open>
    if(fd < 0) {
    15d2:	04054163          	bltz	a0,1614 <exectest+0xaa>
    if(fd != 1) {
    15d6:	4785                	li	a5,1
    15d8:	04f50c63          	beq	a0,a5,1630 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15dc:	85ca                	mv	a1,s2
    15de:	00005517          	auipc	a0,0x5
    15e2:	db250513          	addi	a0,a0,-590 # 6390 <malloc+0xd0a>
    15e6:	00004097          	auipc	ra,0x4
    15ea:	fe2080e7          	jalr	-30(ra) # 55c8 <printf>
      exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00004097          	auipc	ra,0x4
    15f4:	c58080e7          	jalr	-936(ra) # 5248 <exit>
     printf("%s: fork failed\n", s);
    15f8:	85ca                	mv	a1,s2
    15fa:	00005517          	auipc	a0,0x5
    15fe:	ce650513          	addi	a0,a0,-794 # 62e0 <malloc+0xc5a>
    1602:	00004097          	auipc	ra,0x4
    1606:	fc6080e7          	jalr	-58(ra) # 55c8 <printf>
     exit(1);
    160a:	4505                	li	a0,1
    160c:	00004097          	auipc	ra,0x4
    1610:	c3c080e7          	jalr	-964(ra) # 5248 <exit>
      printf("%s: create failed\n", s);
    1614:	85ca                	mv	a1,s2
    1616:	00005517          	auipc	a0,0x5
    161a:	d6250513          	addi	a0,a0,-670 # 6378 <malloc+0xcf2>
    161e:	00004097          	auipc	ra,0x4
    1622:	faa080e7          	jalr	-86(ra) # 55c8 <printf>
      exit(1);
    1626:	4505                	li	a0,1
    1628:	00004097          	auipc	ra,0x4
    162c:	c20080e7          	jalr	-992(ra) # 5248 <exit>
    if(exec("echo", echoargv) < 0){
    1630:	fc040593          	addi	a1,s0,-64
    1634:	00004517          	auipc	a0,0x4
    1638:	47450513          	addi	a0,a0,1140 # 5aa8 <malloc+0x422>
    163c:	00004097          	auipc	ra,0x4
    1640:	c44080e7          	jalr	-956(ra) # 5280 <exec>
    1644:	02054163          	bltz	a0,1666 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1648:	fdc40513          	addi	a0,s0,-36
    164c:	00004097          	auipc	ra,0x4
    1650:	c04080e7          	jalr	-1020(ra) # 5250 <wait>
    1654:	02951763          	bne	a0,s1,1682 <exectest+0x118>
  if(xstatus != 0)
    1658:	fdc42503          	lw	a0,-36(s0)
    165c:	cd0d                	beqz	a0,1696 <exectest+0x12c>
    exit(xstatus);
    165e:	00004097          	auipc	ra,0x4
    1662:	bea080e7          	jalr	-1046(ra) # 5248 <exit>
      printf("%s: exec echo failed\n", s);
    1666:	85ca                	mv	a1,s2
    1668:	00005517          	auipc	a0,0x5
    166c:	d3850513          	addi	a0,a0,-712 # 63a0 <malloc+0xd1a>
    1670:	00004097          	auipc	ra,0x4
    1674:	f58080e7          	jalr	-168(ra) # 55c8 <printf>
      exit(1);
    1678:	4505                	li	a0,1
    167a:	00004097          	auipc	ra,0x4
    167e:	bce080e7          	jalr	-1074(ra) # 5248 <exit>
    printf("%s: wait failed!\n", s);
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	d3450513          	addi	a0,a0,-716 # 63b8 <malloc+0xd32>
    168c:	00004097          	auipc	ra,0x4
    1690:	f3c080e7          	jalr	-196(ra) # 55c8 <printf>
    1694:	b7d1                	j	1658 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1696:	4581                	li	a1,0
    1698:	00005517          	auipc	a0,0x5
    169c:	cd850513          	addi	a0,a0,-808 # 6370 <malloc+0xcea>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	be8080e7          	jalr	-1048(ra) # 5288 <open>
  if(fd < 0) {
    16a8:	02054a63          	bltz	a0,16dc <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16ac:	4609                	li	a2,2
    16ae:	fb840593          	addi	a1,s0,-72
    16b2:	00004097          	auipc	ra,0x4
    16b6:	bae080e7          	jalr	-1106(ra) # 5260 <read>
    16ba:	4789                	li	a5,2
    16bc:	02f50e63          	beq	a0,a5,16f8 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16c0:	85ca                	mv	a1,s2
    16c2:	00004517          	auipc	a0,0x4
    16c6:	77650513          	addi	a0,a0,1910 # 5e38 <malloc+0x7b2>
    16ca:	00004097          	auipc	ra,0x4
    16ce:	efe080e7          	jalr	-258(ra) # 55c8 <printf>
    exit(1);
    16d2:	4505                	li	a0,1
    16d4:	00004097          	auipc	ra,0x4
    16d8:	b74080e7          	jalr	-1164(ra) # 5248 <exit>
    printf("%s: open failed\n", s);
    16dc:	85ca                	mv	a1,s2
    16de:	00005517          	auipc	a0,0x5
    16e2:	c1a50513          	addi	a0,a0,-998 # 62f8 <malloc+0xc72>
    16e6:	00004097          	auipc	ra,0x4
    16ea:	ee2080e7          	jalr	-286(ra) # 55c8 <printf>
    exit(1);
    16ee:	4505                	li	a0,1
    16f0:	00004097          	auipc	ra,0x4
    16f4:	b58080e7          	jalr	-1192(ra) # 5248 <exit>
  unlink("echo-ok");
    16f8:	00005517          	auipc	a0,0x5
    16fc:	c7850513          	addi	a0,a0,-904 # 6370 <malloc+0xcea>
    1700:	00004097          	auipc	ra,0x4
    1704:	b98080e7          	jalr	-1128(ra) # 5298 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1708:	fb844703          	lbu	a4,-72(s0)
    170c:	04f00793          	li	a5,79
    1710:	00f71863          	bne	a4,a5,1720 <exectest+0x1b6>
    1714:	fb944703          	lbu	a4,-71(s0)
    1718:	04b00793          	li	a5,75
    171c:	02f70063          	beq	a4,a5,173c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1720:	85ca                	mv	a1,s2
    1722:	00005517          	auipc	a0,0x5
    1726:	cae50513          	addi	a0,a0,-850 # 63d0 <malloc+0xd4a>
    172a:	00004097          	auipc	ra,0x4
    172e:	e9e080e7          	jalr	-354(ra) # 55c8 <printf>
    exit(1);
    1732:	4505                	li	a0,1
    1734:	00004097          	auipc	ra,0x4
    1738:	b14080e7          	jalr	-1260(ra) # 5248 <exit>
    exit(0);
    173c:	4501                	li	a0,0
    173e:	00004097          	auipc	ra,0x4
    1742:	b0a080e7          	jalr	-1270(ra) # 5248 <exit>

0000000000001746 <pipe1>:
{
    1746:	711d                	addi	sp,sp,-96
    1748:	ec86                	sd	ra,88(sp)
    174a:	e8a2                	sd	s0,80(sp)
    174c:	e4a6                	sd	s1,72(sp)
    174e:	e0ca                	sd	s2,64(sp)
    1750:	fc4e                	sd	s3,56(sp)
    1752:	f852                	sd	s4,48(sp)
    1754:	f456                	sd	s5,40(sp)
    1756:	f05a                	sd	s6,32(sp)
    1758:	ec5e                	sd	s7,24(sp)
    175a:	1080                	addi	s0,sp,96
    175c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    175e:	fa840513          	addi	a0,s0,-88
    1762:	00004097          	auipc	ra,0x4
    1766:	af6080e7          	jalr	-1290(ra) # 5258 <pipe>
    176a:	ed25                	bnez	a0,17e2 <pipe1+0x9c>
    176c:	84aa                	mv	s1,a0
  pid = fork();
    176e:	00004097          	auipc	ra,0x4
    1772:	ad2080e7          	jalr	-1326(ra) # 5240 <fork>
    1776:	8a2a                	mv	s4,a0
  if(pid == 0){
    1778:	c159                	beqz	a0,17fe <pipe1+0xb8>
  } else if(pid > 0){
    177a:	16a05e63          	blez	a0,18f6 <pipe1+0x1b0>
    close(fds[1]);
    177e:	fac42503          	lw	a0,-84(s0)
    1782:	00004097          	auipc	ra,0x4
    1786:	aee080e7          	jalr	-1298(ra) # 5270 <close>
    total = 0;
    178a:	8a26                	mv	s4,s1
    cc = 1;
    178c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	0000aa97          	auipc	s5,0xa
    1792:	dbaa8a93          	addi	s5,s5,-582 # b548 <buf>
      if(cc > sizeof(buf))
    1796:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1798:	864e                	mv	a2,s3
    179a:	85d6                	mv	a1,s5
    179c:	fa842503          	lw	a0,-88(s0)
    17a0:	00004097          	auipc	ra,0x4
    17a4:	ac0080e7          	jalr	-1344(ra) # 5260 <read>
    17a8:	10a05263          	blez	a0,18ac <pipe1+0x166>
      for(i = 0; i < n; i++){
    17ac:	0000a717          	auipc	a4,0xa
    17b0:	d9c70713          	addi	a4,a4,-612 # b548 <buf>
    17b4:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b8:	00074683          	lbu	a3,0(a4)
    17bc:	0ff4f793          	andi	a5,s1,255
    17c0:	2485                	addiw	s1,s1,1
    17c2:	0cf69163          	bne	a3,a5,1884 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17c6:	0705                	addi	a4,a4,1
    17c8:	fec498e3          	bne	s1,a2,17b8 <pipe1+0x72>
      total += n;
    17cc:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17d0:	0019979b          	slliw	a5,s3,0x1
    17d4:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d8:	013b7363          	bgeu	s6,s3,17de <pipe1+0x98>
        cc = sizeof(buf);
    17dc:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17de:	84b2                	mv	s1,a2
    17e0:	bf65                	j	1798 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	c0450513          	addi	a0,a0,-1020 # 63e8 <malloc+0xd62>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	ddc080e7          	jalr	-548(ra) # 55c8 <printf>
    exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	a52080e7          	jalr	-1454(ra) # 5248 <exit>
    close(fds[0]);
    17fe:	fa842503          	lw	a0,-88(s0)
    1802:	00004097          	auipc	ra,0x4
    1806:	a6e080e7          	jalr	-1426(ra) # 5270 <close>
    for(n = 0; n < N; n++){
    180a:	0000ab17          	auipc	s6,0xa
    180e:	d3eb0b13          	addi	s6,s6,-706 # b548 <buf>
    1812:	416004bb          	negw	s1,s6
    1816:	0ff4f493          	andi	s1,s1,255
    181a:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    181e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1820:	6a85                	lui	s5,0x1
    1822:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x7d>
{
    1826:	87da                	mv	a5,s6
        buf[i] = seq++;
    1828:	0097873b          	addw	a4,a5,s1
    182c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1830:	0785                	addi	a5,a5,1
    1832:	fef99be3          	bne	s3,a5,1828 <pipe1+0xe2>
    1836:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    183a:	40900613          	li	a2,1033
    183e:	85de                	mv	a1,s7
    1840:	fac42503          	lw	a0,-84(s0)
    1844:	00004097          	auipc	ra,0x4
    1848:	a24080e7          	jalr	-1500(ra) # 5268 <write>
    184c:	40900793          	li	a5,1033
    1850:	00f51c63          	bne	a0,a5,1868 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1854:	24a5                	addiw	s1,s1,9
    1856:	0ff4f493          	andi	s1,s1,255
    185a:	fd5a16e3          	bne	s4,s5,1826 <pipe1+0xe0>
    exit(0);
    185e:	4501                	li	a0,0
    1860:	00004097          	auipc	ra,0x4
    1864:	9e8080e7          	jalr	-1560(ra) # 5248 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1868:	85ca                	mv	a1,s2
    186a:	00005517          	auipc	a0,0x5
    186e:	b9650513          	addi	a0,a0,-1130 # 6400 <malloc+0xd7a>
    1872:	00004097          	auipc	ra,0x4
    1876:	d56080e7          	jalr	-682(ra) # 55c8 <printf>
        exit(1);
    187a:	4505                	li	a0,1
    187c:	00004097          	auipc	ra,0x4
    1880:	9cc080e7          	jalr	-1588(ra) # 5248 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1884:	85ca                	mv	a1,s2
    1886:	00005517          	auipc	a0,0x5
    188a:	b9250513          	addi	a0,a0,-1134 # 6418 <malloc+0xd92>
    188e:	00004097          	auipc	ra,0x4
    1892:	d3a080e7          	jalr	-710(ra) # 55c8 <printf>
}
    1896:	60e6                	ld	ra,88(sp)
    1898:	6446                	ld	s0,80(sp)
    189a:	64a6                	ld	s1,72(sp)
    189c:	6906                	ld	s2,64(sp)
    189e:	79e2                	ld	s3,56(sp)
    18a0:	7a42                	ld	s4,48(sp)
    18a2:	7aa2                	ld	s5,40(sp)
    18a4:	7b02                	ld	s6,32(sp)
    18a6:	6be2                	ld	s7,24(sp)
    18a8:	6125                	addi	sp,sp,96
    18aa:	8082                	ret
    if(total != N * SZ){
    18ac:	6785                	lui	a5,0x1
    18ae:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x7d>
    18b2:	02fa0063          	beq	s4,a5,18d2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b6:	85d2                	mv	a1,s4
    18b8:	00005517          	auipc	a0,0x5
    18bc:	b7850513          	addi	a0,a0,-1160 # 6430 <malloc+0xdaa>
    18c0:	00004097          	auipc	ra,0x4
    18c4:	d08080e7          	jalr	-760(ra) # 55c8 <printf>
      exit(1);
    18c8:	4505                	li	a0,1
    18ca:	00004097          	auipc	ra,0x4
    18ce:	97e080e7          	jalr	-1666(ra) # 5248 <exit>
    close(fds[0]);
    18d2:	fa842503          	lw	a0,-88(s0)
    18d6:	00004097          	auipc	ra,0x4
    18da:	99a080e7          	jalr	-1638(ra) # 5270 <close>
    wait(&xstatus);
    18de:	fa440513          	addi	a0,s0,-92
    18e2:	00004097          	auipc	ra,0x4
    18e6:	96e080e7          	jalr	-1682(ra) # 5250 <wait>
    exit(xstatus);
    18ea:	fa442503          	lw	a0,-92(s0)
    18ee:	00004097          	auipc	ra,0x4
    18f2:	95a080e7          	jalr	-1702(ra) # 5248 <exit>
    printf("%s: fork() failed\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	b5850513          	addi	a0,a0,-1192 # 6450 <malloc+0xdca>
    1900:	00004097          	auipc	ra,0x4
    1904:	cc8080e7          	jalr	-824(ra) # 55c8 <printf>
    exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	93e080e7          	jalr	-1730(ra) # 5248 <exit>

0000000000001912 <exitwait>:
{
    1912:	7139                	addi	sp,sp,-64
    1914:	fc06                	sd	ra,56(sp)
    1916:	f822                	sd	s0,48(sp)
    1918:	f426                	sd	s1,40(sp)
    191a:	f04a                	sd	s2,32(sp)
    191c:	ec4e                	sd	s3,24(sp)
    191e:	e852                	sd	s4,16(sp)
    1920:	0080                	addi	s0,sp,64
    1922:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1924:	4901                	li	s2,0
    1926:	06400993          	li	s3,100
    pid = fork();
    192a:	00004097          	auipc	ra,0x4
    192e:	916080e7          	jalr	-1770(ra) # 5240 <fork>
    1932:	84aa                	mv	s1,a0
    if(pid < 0){
    1934:	02054a63          	bltz	a0,1968 <exitwait+0x56>
    if(pid){
    1938:	c151                	beqz	a0,19bc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    193a:	fcc40513          	addi	a0,s0,-52
    193e:	00004097          	auipc	ra,0x4
    1942:	912080e7          	jalr	-1774(ra) # 5250 <wait>
    1946:	02951f63          	bne	a0,s1,1984 <exitwait+0x72>
      if(i != xstate) {
    194a:	fcc42783          	lw	a5,-52(s0)
    194e:	05279963          	bne	a5,s2,19a0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1952:	2905                	addiw	s2,s2,1
    1954:	fd391be3          	bne	s2,s3,192a <exitwait+0x18>
}
    1958:	70e2                	ld	ra,56(sp)
    195a:	7442                	ld	s0,48(sp)
    195c:	74a2                	ld	s1,40(sp)
    195e:	7902                	ld	s2,32(sp)
    1960:	69e2                	ld	s3,24(sp)
    1962:	6a42                	ld	s4,16(sp)
    1964:	6121                	addi	sp,sp,64
    1966:	8082                	ret
      printf("%s: fork failed\n", s);
    1968:	85d2                	mv	a1,s4
    196a:	00005517          	auipc	a0,0x5
    196e:	97650513          	addi	a0,a0,-1674 # 62e0 <malloc+0xc5a>
    1972:	00004097          	auipc	ra,0x4
    1976:	c56080e7          	jalr	-938(ra) # 55c8 <printf>
      exit(1);
    197a:	4505                	li	a0,1
    197c:	00004097          	auipc	ra,0x4
    1980:	8cc080e7          	jalr	-1844(ra) # 5248 <exit>
        printf("%s: wait wrong pid\n", s);
    1984:	85d2                	mv	a1,s4
    1986:	00005517          	auipc	a0,0x5
    198a:	ae250513          	addi	a0,a0,-1310 # 6468 <malloc+0xde2>
    198e:	00004097          	auipc	ra,0x4
    1992:	c3a080e7          	jalr	-966(ra) # 55c8 <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	00004097          	auipc	ra,0x4
    199c:	8b0080e7          	jalr	-1872(ra) # 5248 <exit>
        printf("%s: wait wrong exit status\n", s);
    19a0:	85d2                	mv	a1,s4
    19a2:	00005517          	auipc	a0,0x5
    19a6:	ade50513          	addi	a0,a0,-1314 # 6480 <malloc+0xdfa>
    19aa:	00004097          	auipc	ra,0x4
    19ae:	c1e080e7          	jalr	-994(ra) # 55c8 <printf>
        exit(1);
    19b2:	4505                	li	a0,1
    19b4:	00004097          	auipc	ra,0x4
    19b8:	894080e7          	jalr	-1900(ra) # 5248 <exit>
      exit(i);
    19bc:	854a                	mv	a0,s2
    19be:	00004097          	auipc	ra,0x4
    19c2:	88a080e7          	jalr	-1910(ra) # 5248 <exit>

00000000000019c6 <twochildren>:
{
    19c6:	1101                	addi	sp,sp,-32
    19c8:	ec06                	sd	ra,24(sp)
    19ca:	e822                	sd	s0,16(sp)
    19cc:	e426                	sd	s1,8(sp)
    19ce:	e04a                	sd	s2,0(sp)
    19d0:	1000                	addi	s0,sp,32
    19d2:	892a                	mv	s2,a0
    19d4:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d8:	00004097          	auipc	ra,0x4
    19dc:	868080e7          	jalr	-1944(ra) # 5240 <fork>
    if(pid1 < 0){
    19e0:	02054c63          	bltz	a0,1a18 <twochildren+0x52>
    if(pid1 == 0){
    19e4:	c921                	beqz	a0,1a34 <twochildren+0x6e>
      int pid2 = fork();
    19e6:	00004097          	auipc	ra,0x4
    19ea:	85a080e7          	jalr	-1958(ra) # 5240 <fork>
      if(pid2 < 0){
    19ee:	04054763          	bltz	a0,1a3c <twochildren+0x76>
      if(pid2 == 0){
    19f2:	c13d                	beqz	a0,1a58 <twochildren+0x92>
        wait(0);
    19f4:	4501                	li	a0,0
    19f6:	00004097          	auipc	ra,0x4
    19fa:	85a080e7          	jalr	-1958(ra) # 5250 <wait>
        wait(0);
    19fe:	4501                	li	a0,0
    1a00:	00004097          	auipc	ra,0x4
    1a04:	850080e7          	jalr	-1968(ra) # 5250 <wait>
  for(int i = 0; i < 1000; i++){
    1a08:	34fd                	addiw	s1,s1,-1
    1a0a:	f4f9                	bnez	s1,19d8 <twochildren+0x12>
}
    1a0c:	60e2                	ld	ra,24(sp)
    1a0e:	6442                	ld	s0,16(sp)
    1a10:	64a2                	ld	s1,8(sp)
    1a12:	6902                	ld	s2,0(sp)
    1a14:	6105                	addi	sp,sp,32
    1a16:	8082                	ret
      printf("%s: fork failed\n", s);
    1a18:	85ca                	mv	a1,s2
    1a1a:	00005517          	auipc	a0,0x5
    1a1e:	8c650513          	addi	a0,a0,-1850 # 62e0 <malloc+0xc5a>
    1a22:	00004097          	auipc	ra,0x4
    1a26:	ba6080e7          	jalr	-1114(ra) # 55c8 <printf>
      exit(1);
    1a2a:	4505                	li	a0,1
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	81c080e7          	jalr	-2020(ra) # 5248 <exit>
      exit(0);
    1a34:	00004097          	auipc	ra,0x4
    1a38:	814080e7          	jalr	-2028(ra) # 5248 <exit>
        printf("%s: fork failed\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	8a250513          	addi	a0,a0,-1886 # 62e0 <malloc+0xc5a>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	b82080e7          	jalr	-1150(ra) # 55c8 <printf>
        exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00003097          	auipc	ra,0x3
    1a54:	7f8080e7          	jalr	2040(ra) # 5248 <exit>
        exit(0);
    1a58:	00003097          	auipc	ra,0x3
    1a5c:	7f0080e7          	jalr	2032(ra) # 5248 <exit>

0000000000001a60 <forkfork>:
{
    1a60:	7179                	addi	sp,sp,-48
    1a62:	f406                	sd	ra,40(sp)
    1a64:	f022                	sd	s0,32(sp)
    1a66:	ec26                	sd	s1,24(sp)
    1a68:	1800                	addi	s0,sp,48
    1a6a:	84aa                	mv	s1,a0
    int pid = fork();
    1a6c:	00003097          	auipc	ra,0x3
    1a70:	7d4080e7          	jalr	2004(ra) # 5240 <fork>
    if(pid < 0){
    1a74:	04054163          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a78:	cd29                	beqz	a0,1ad2 <forkfork+0x72>
    int pid = fork();
    1a7a:	00003097          	auipc	ra,0x3
    1a7e:	7c6080e7          	jalr	1990(ra) # 5240 <fork>
    if(pid < 0){
    1a82:	02054a63          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a86:	c531                	beqz	a0,1ad2 <forkfork+0x72>
    wait(&xstatus);
    1a88:	fdc40513          	addi	a0,s0,-36
    1a8c:	00003097          	auipc	ra,0x3
    1a90:	7c4080e7          	jalr	1988(ra) # 5250 <wait>
    if(xstatus != 0) {
    1a94:	fdc42783          	lw	a5,-36(s0)
    1a98:	ebbd                	bnez	a5,1b0e <forkfork+0xae>
    wait(&xstatus);
    1a9a:	fdc40513          	addi	a0,s0,-36
    1a9e:	00003097          	auipc	ra,0x3
    1aa2:	7b2080e7          	jalr	1970(ra) # 5250 <wait>
    if(xstatus != 0) {
    1aa6:	fdc42783          	lw	a5,-36(s0)
    1aaa:	e3b5                	bnez	a5,1b0e <forkfork+0xae>
}
    1aac:	70a2                	ld	ra,40(sp)
    1aae:	7402                	ld	s0,32(sp)
    1ab0:	64e2                	ld	s1,24(sp)
    1ab2:	6145                	addi	sp,sp,48
    1ab4:	8082                	ret
      printf("%s: fork failed", s);
    1ab6:	85a6                	mv	a1,s1
    1ab8:	00005517          	auipc	a0,0x5
    1abc:	9e850513          	addi	a0,a0,-1560 # 64a0 <malloc+0xe1a>
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	b08080e7          	jalr	-1272(ra) # 55c8 <printf>
      exit(1);
    1ac8:	4505                	li	a0,1
    1aca:	00003097          	auipc	ra,0x3
    1ace:	77e080e7          	jalr	1918(ra) # 5248 <exit>
{
    1ad2:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad6:	00003097          	auipc	ra,0x3
    1ada:	76a080e7          	jalr	1898(ra) # 5240 <fork>
        if(pid1 < 0){
    1ade:	00054f63          	bltz	a0,1afc <forkfork+0x9c>
        if(pid1 == 0){
    1ae2:	c115                	beqz	a0,1b06 <forkfork+0xa6>
        wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00003097          	auipc	ra,0x3
    1aea:	76a080e7          	jalr	1898(ra) # 5250 <wait>
      for(int j = 0; j < 200; j++){
    1aee:	34fd                	addiw	s1,s1,-1
    1af0:	f0fd                	bnez	s1,1ad6 <forkfork+0x76>
      exit(0);
    1af2:	4501                	li	a0,0
    1af4:	00003097          	auipc	ra,0x3
    1af8:	754080e7          	jalr	1876(ra) # 5248 <exit>
          exit(1);
    1afc:	4505                	li	a0,1
    1afe:	00003097          	auipc	ra,0x3
    1b02:	74a080e7          	jalr	1866(ra) # 5248 <exit>
          exit(0);
    1b06:	00003097          	auipc	ra,0x3
    1b0a:	742080e7          	jalr	1858(ra) # 5248 <exit>
      printf("%s: fork in child failed", s);
    1b0e:	85a6                	mv	a1,s1
    1b10:	00005517          	auipc	a0,0x5
    1b14:	9a050513          	addi	a0,a0,-1632 # 64b0 <malloc+0xe2a>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	ab0080e7          	jalr	-1360(ra) # 55c8 <printf>
      exit(1);
    1b20:	4505                	li	a0,1
    1b22:	00003097          	auipc	ra,0x3
    1b26:	726080e7          	jalr	1830(ra) # 5248 <exit>

0000000000001b2a <reparent2>:
{
    1b2a:	1101                	addi	sp,sp,-32
    1b2c:	ec06                	sd	ra,24(sp)
    1b2e:	e822                	sd	s0,16(sp)
    1b30:	e426                	sd	s1,8(sp)
    1b32:	1000                	addi	s0,sp,32
    1b34:	32000493          	li	s1,800
    int pid1 = fork();
    1b38:	00003097          	auipc	ra,0x3
    1b3c:	708080e7          	jalr	1800(ra) # 5240 <fork>
    if(pid1 < 0){
    1b40:	00054f63          	bltz	a0,1b5e <reparent2+0x34>
    if(pid1 == 0){
    1b44:	c915                	beqz	a0,1b78 <reparent2+0x4e>
    wait(0);
    1b46:	4501                	li	a0,0
    1b48:	00003097          	auipc	ra,0x3
    1b4c:	708080e7          	jalr	1800(ra) # 5250 <wait>
  for(int i = 0; i < 800; i++){
    1b50:	34fd                	addiw	s1,s1,-1
    1b52:	f0fd                	bnez	s1,1b38 <reparent2+0xe>
  exit(0);
    1b54:	4501                	li	a0,0
    1b56:	00003097          	auipc	ra,0x3
    1b5a:	6f2080e7          	jalr	1778(ra) # 5248 <exit>
      printf("fork failed\n");
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	b7250513          	addi	a0,a0,-1166 # 66d0 <malloc+0x104a>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	a62080e7          	jalr	-1438(ra) # 55c8 <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00003097          	auipc	ra,0x3
    1b74:	6d8080e7          	jalr	1752(ra) # 5248 <exit>
      fork();
    1b78:	00003097          	auipc	ra,0x3
    1b7c:	6c8080e7          	jalr	1736(ra) # 5240 <fork>
      fork();
    1b80:	00003097          	auipc	ra,0x3
    1b84:	6c0080e7          	jalr	1728(ra) # 5240 <fork>
      exit(0);
    1b88:	4501                	li	a0,0
    1b8a:	00003097          	auipc	ra,0x3
    1b8e:	6be080e7          	jalr	1726(ra) # 5248 <exit>

0000000000001b92 <createdelete>:
{
    1b92:	7175                	addi	sp,sp,-144
    1b94:	e506                	sd	ra,136(sp)
    1b96:	e122                	sd	s0,128(sp)
    1b98:	fca6                	sd	s1,120(sp)
    1b9a:	f8ca                	sd	s2,112(sp)
    1b9c:	f4ce                	sd	s3,104(sp)
    1b9e:	f0d2                	sd	s4,96(sp)
    1ba0:	ecd6                	sd	s5,88(sp)
    1ba2:	e8da                	sd	s6,80(sp)
    1ba4:	e4de                	sd	s7,72(sp)
    1ba6:	e0e2                	sd	s8,64(sp)
    1ba8:	fc66                	sd	s9,56(sp)
    1baa:	0900                	addi	s0,sp,144
    1bac:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bae:	4901                	li	s2,0
    1bb0:	4991                	li	s3,4
    pid = fork();
    1bb2:	00003097          	auipc	ra,0x3
    1bb6:	68e080e7          	jalr	1678(ra) # 5240 <fork>
    1bba:	84aa                	mv	s1,a0
    if(pid < 0){
    1bbc:	02054f63          	bltz	a0,1bfa <createdelete+0x68>
    if(pid == 0){
    1bc0:	c939                	beqz	a0,1c16 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bc2:	2905                	addiw	s2,s2,1
    1bc4:	ff3917e3          	bne	s2,s3,1bb2 <createdelete+0x20>
    1bc8:	4491                	li	s1,4
    wait(&xstatus);
    1bca:	f7c40513          	addi	a0,s0,-132
    1bce:	00003097          	auipc	ra,0x3
    1bd2:	682080e7          	jalr	1666(ra) # 5250 <wait>
    if(xstatus != 0)
    1bd6:	f7c42903          	lw	s2,-132(s0)
    1bda:	0e091263          	bnez	s2,1cbe <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bde:	34fd                	addiw	s1,s1,-1
    1be0:	f4ed                	bnez	s1,1bca <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1be2:	f8040123          	sb	zero,-126(s0)
    1be6:	03000993          	li	s3,48
    1bea:	5a7d                	li	s4,-1
    1bec:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bf0:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bf2:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bf4:	07400a93          	li	s5,116
    1bf8:	a29d                	j	1d5e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bfa:	85e6                	mv	a1,s9
    1bfc:	00005517          	auipc	a0,0x5
    1c00:	ad450513          	addi	a0,a0,-1324 # 66d0 <malloc+0x104a>
    1c04:	00004097          	auipc	ra,0x4
    1c08:	9c4080e7          	jalr	-1596(ra) # 55c8 <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	00003097          	auipc	ra,0x3
    1c12:	63a080e7          	jalr	1594(ra) # 5248 <exit>
      name[0] = 'p' + pi;
    1c16:	0709091b          	addiw	s2,s2,112
    1c1a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c1e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c22:	4951                	li	s2,20
    1c24:	a015                	j	1c48 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c26:	85e6                	mv	a1,s9
    1c28:	00004517          	auipc	a0,0x4
    1c2c:	75050513          	addi	a0,a0,1872 # 6378 <malloc+0xcf2>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	998080e7          	jalr	-1640(ra) # 55c8 <printf>
          exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00003097          	auipc	ra,0x3
    1c3e:	60e080e7          	jalr	1550(ra) # 5248 <exit>
      for(i = 0; i < N; i++){
    1c42:	2485                	addiw	s1,s1,1
    1c44:	07248863          	beq	s1,s2,1cb4 <createdelete+0x122>
        name[1] = '0' + i;
    1c48:	0304879b          	addiw	a5,s1,48
    1c4c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c50:	20200593          	li	a1,514
    1c54:	f8040513          	addi	a0,s0,-128
    1c58:	00003097          	auipc	ra,0x3
    1c5c:	630080e7          	jalr	1584(ra) # 5288 <open>
        if(fd < 0){
    1c60:	fc0543e3          	bltz	a0,1c26 <createdelete+0x94>
        close(fd);
    1c64:	00003097          	auipc	ra,0x3
    1c68:	60c080e7          	jalr	1548(ra) # 5270 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c6c:	fc905be3          	blez	s1,1c42 <createdelete+0xb0>
    1c70:	0014f793          	andi	a5,s1,1
    1c74:	f7f9                	bnez	a5,1c42 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c76:	01f4d79b          	srliw	a5,s1,0x1f
    1c7a:	9fa5                	addw	a5,a5,s1
    1c7c:	4017d79b          	sraiw	a5,a5,0x1
    1c80:	0307879b          	addiw	a5,a5,48
    1c84:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c88:	f8040513          	addi	a0,s0,-128
    1c8c:	00003097          	auipc	ra,0x3
    1c90:	60c080e7          	jalr	1548(ra) # 5298 <unlink>
    1c94:	fa0557e3          	bgez	a0,1c42 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c98:	85e6                	mv	a1,s9
    1c9a:	00005517          	auipc	a0,0x5
    1c9e:	83650513          	addi	a0,a0,-1994 # 64d0 <malloc+0xe4a>
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	926080e7          	jalr	-1754(ra) # 55c8 <printf>
            exit(1);
    1caa:	4505                	li	a0,1
    1cac:	00003097          	auipc	ra,0x3
    1cb0:	59c080e7          	jalr	1436(ra) # 5248 <exit>
      exit(0);
    1cb4:	4501                	li	a0,0
    1cb6:	00003097          	auipc	ra,0x3
    1cba:	592080e7          	jalr	1426(ra) # 5248 <exit>
      exit(1);
    1cbe:	4505                	li	a0,1
    1cc0:	00003097          	auipc	ra,0x3
    1cc4:	588080e7          	jalr	1416(ra) # 5248 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc8:	f8040613          	addi	a2,s0,-128
    1ccc:	85e6                	mv	a1,s9
    1cce:	00005517          	auipc	a0,0x5
    1cd2:	81a50513          	addi	a0,a0,-2022 # 64e8 <malloc+0xe62>
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	8f2080e7          	jalr	-1806(ra) # 55c8 <printf>
        exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	00003097          	auipc	ra,0x3
    1ce4:	568080e7          	jalr	1384(ra) # 5248 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce8:	054b7163          	bgeu	s6,s4,1d2a <createdelete+0x198>
      if(fd >= 0)
    1cec:	02055a63          	bgez	a0,1d20 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cf0:	2485                	addiw	s1,s1,1
    1cf2:	0ff4f493          	andi	s1,s1,255
    1cf6:	05548c63          	beq	s1,s5,1d4e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cfa:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cfe:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d02:	4581                	li	a1,0
    1d04:	f8040513          	addi	a0,s0,-128
    1d08:	00003097          	auipc	ra,0x3
    1d0c:	580080e7          	jalr	1408(ra) # 5288 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d10:	00090463          	beqz	s2,1d18 <createdelete+0x186>
    1d14:	fd2bdae3          	bge	s7,s2,1ce8 <createdelete+0x156>
    1d18:	fa0548e3          	bltz	a0,1cc8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1c:	014b7963          	bgeu	s6,s4,1d2e <createdelete+0x19c>
        close(fd);
    1d20:	00003097          	auipc	ra,0x3
    1d24:	550080e7          	jalr	1360(ra) # 5270 <close>
    1d28:	b7e1                	j	1cf0 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d2a:	fc0543e3          	bltz	a0,1cf0 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2e:	f8040613          	addi	a2,s0,-128
    1d32:	85e6                	mv	a1,s9
    1d34:	00004517          	auipc	a0,0x4
    1d38:	7dc50513          	addi	a0,a0,2012 # 6510 <malloc+0xe8a>
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	88c080e7          	jalr	-1908(ra) # 55c8 <printf>
        exit(1);
    1d44:	4505                	li	a0,1
    1d46:	00003097          	auipc	ra,0x3
    1d4a:	502080e7          	jalr	1282(ra) # 5248 <exit>
  for(i = 0; i < N; i++){
    1d4e:	2905                	addiw	s2,s2,1
    1d50:	2a05                	addiw	s4,s4,1
    1d52:	2985                	addiw	s3,s3,1
    1d54:	0ff9f993          	andi	s3,s3,255
    1d58:	47d1                	li	a5,20
    1d5a:	02f90a63          	beq	s2,a5,1d8e <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d5e:	84e2                	mv	s1,s8
    1d60:	bf69                	j	1cfa <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d62:	2905                	addiw	s2,s2,1
    1d64:	0ff97913          	andi	s2,s2,255
    1d68:	2985                	addiw	s3,s3,1
    1d6a:	0ff9f993          	andi	s3,s3,255
    1d6e:	03490863          	beq	s2,s4,1d9e <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d72:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d74:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d78:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d7c:	f8040513          	addi	a0,s0,-128
    1d80:	00003097          	auipc	ra,0x3
    1d84:	518080e7          	jalr	1304(ra) # 5298 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d88:	34fd                	addiw	s1,s1,-1
    1d8a:	f4ed                	bnez	s1,1d74 <createdelete+0x1e2>
    1d8c:	bfd9                	j	1d62 <createdelete+0x1d0>
    1d8e:	03000993          	li	s3,48
    1d92:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d96:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d98:	08400a13          	li	s4,132
    1d9c:	bfd9                	j	1d72 <createdelete+0x1e0>
}
    1d9e:	60aa                	ld	ra,136(sp)
    1da0:	640a                	ld	s0,128(sp)
    1da2:	74e6                	ld	s1,120(sp)
    1da4:	7946                	ld	s2,112(sp)
    1da6:	79a6                	ld	s3,104(sp)
    1da8:	7a06                	ld	s4,96(sp)
    1daa:	6ae6                	ld	s5,88(sp)
    1dac:	6b46                	ld	s6,80(sp)
    1dae:	6ba6                	ld	s7,72(sp)
    1db0:	6c06                	ld	s8,64(sp)
    1db2:	7ce2                	ld	s9,56(sp)
    1db4:	6149                	addi	sp,sp,144
    1db6:	8082                	ret

0000000000001db8 <linkunlink>:
{
    1db8:	711d                	addi	sp,sp,-96
    1dba:	ec86                	sd	ra,88(sp)
    1dbc:	e8a2                	sd	s0,80(sp)
    1dbe:	e4a6                	sd	s1,72(sp)
    1dc0:	e0ca                	sd	s2,64(sp)
    1dc2:	fc4e                	sd	s3,56(sp)
    1dc4:	f852                	sd	s4,48(sp)
    1dc6:	f456                	sd	s5,40(sp)
    1dc8:	f05a                	sd	s6,32(sp)
    1dca:	ec5e                	sd	s7,24(sp)
    1dcc:	e862                	sd	s8,16(sp)
    1dce:	e466                	sd	s9,8(sp)
    1dd0:	1080                	addi	s0,sp,96
    1dd2:	84aa                	mv	s1,a0
  unlink("x");
    1dd4:	00004517          	auipc	a0,0x4
    1dd8:	d4450513          	addi	a0,a0,-700 # 5b18 <malloc+0x492>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	4bc080e7          	jalr	1212(ra) # 5298 <unlink>
  pid = fork();
    1de4:	00003097          	auipc	ra,0x3
    1de8:	45c080e7          	jalr	1116(ra) # 5240 <fork>
  if(pid < 0){
    1dec:	02054b63          	bltz	a0,1e22 <linkunlink+0x6a>
    1df0:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1df2:	4c85                	li	s9,1
    1df4:	e119                	bnez	a0,1dfa <linkunlink+0x42>
    1df6:	06100c93          	li	s9,97
    1dfa:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1dfe:	41c659b7          	lui	s3,0x41c65
    1e02:	e6d9899b          	addiw	s3,s3,-403
    1e06:	690d                	lui	s2,0x3
    1e08:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e0c:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e0e:	4b05                	li	s6,1
      unlink("x");
    1e10:	00004a97          	auipc	s5,0x4
    1e14:	d08a8a93          	addi	s5,s5,-760 # 5b18 <malloc+0x492>
      link("cat", "x");
    1e18:	00004b97          	auipc	s7,0x4
    1e1c:	720b8b93          	addi	s7,s7,1824 # 6538 <malloc+0xeb2>
    1e20:	a091                	j	1e64 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e22:	85a6                	mv	a1,s1
    1e24:	00004517          	auipc	a0,0x4
    1e28:	4bc50513          	addi	a0,a0,1212 # 62e0 <malloc+0xc5a>
    1e2c:	00003097          	auipc	ra,0x3
    1e30:	79c080e7          	jalr	1948(ra) # 55c8 <printf>
    exit(1);
    1e34:	4505                	li	a0,1
    1e36:	00003097          	auipc	ra,0x3
    1e3a:	412080e7          	jalr	1042(ra) # 5248 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3e:	20200593          	li	a1,514
    1e42:	8556                	mv	a0,s5
    1e44:	00003097          	auipc	ra,0x3
    1e48:	444080e7          	jalr	1092(ra) # 5288 <open>
    1e4c:	00003097          	auipc	ra,0x3
    1e50:	424080e7          	jalr	1060(ra) # 5270 <close>
    1e54:	a031                	j	1e60 <linkunlink+0xa8>
      unlink("x");
    1e56:	8556                	mv	a0,s5
    1e58:	00003097          	auipc	ra,0x3
    1e5c:	440080e7          	jalr	1088(ra) # 5298 <unlink>
  for(i = 0; i < 100; i++){
    1e60:	34fd                	addiw	s1,s1,-1
    1e62:	c09d                	beqz	s1,1e88 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e64:	033c87bb          	mulw	a5,s9,s3
    1e68:	012787bb          	addw	a5,a5,s2
    1e6c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e70:	0347f7bb          	remuw	a5,a5,s4
    1e74:	d7e9                	beqz	a5,1e3e <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e76:	ff6790e3          	bne	a5,s6,1e56 <linkunlink+0x9e>
      link("cat", "x");
    1e7a:	85d6                	mv	a1,s5
    1e7c:	855e                	mv	a0,s7
    1e7e:	00003097          	auipc	ra,0x3
    1e82:	42a080e7          	jalr	1066(ra) # 52a8 <link>
    1e86:	bfe9                	j	1e60 <linkunlink+0xa8>
  if(pid)
    1e88:	020c0463          	beqz	s8,1eb0 <linkunlink+0xf8>
    wait(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00003097          	auipc	ra,0x3
    1e92:	3c2080e7          	jalr	962(ra) # 5250 <wait>
}
    1e96:	60e6                	ld	ra,88(sp)
    1e98:	6446                	ld	s0,80(sp)
    1e9a:	64a6                	ld	s1,72(sp)
    1e9c:	6906                	ld	s2,64(sp)
    1e9e:	79e2                	ld	s3,56(sp)
    1ea0:	7a42                	ld	s4,48(sp)
    1ea2:	7aa2                	ld	s5,40(sp)
    1ea4:	7b02                	ld	s6,32(sp)
    1ea6:	6be2                	ld	s7,24(sp)
    1ea8:	6c42                	ld	s8,16(sp)
    1eaa:	6ca2                	ld	s9,8(sp)
    1eac:	6125                	addi	sp,sp,96
    1eae:	8082                	ret
    exit(0);
    1eb0:	4501                	li	a0,0
    1eb2:	00003097          	auipc	ra,0x3
    1eb6:	396080e7          	jalr	918(ra) # 5248 <exit>

0000000000001eba <forktest>:
{
    1eba:	7179                	addi	sp,sp,-48
    1ebc:	f406                	sd	ra,40(sp)
    1ebe:	f022                	sd	s0,32(sp)
    1ec0:	ec26                	sd	s1,24(sp)
    1ec2:	e84a                	sd	s2,16(sp)
    1ec4:	e44e                	sd	s3,8(sp)
    1ec6:	1800                	addi	s0,sp,48
    1ec8:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1eca:	4481                	li	s1,0
    1ecc:	3e800913          	li	s2,1000
    pid = fork();
    1ed0:	00003097          	auipc	ra,0x3
    1ed4:	370080e7          	jalr	880(ra) # 5240 <fork>
    if(pid < 0)
    1ed8:	02054863          	bltz	a0,1f08 <forktest+0x4e>
    if(pid == 0)
    1edc:	c115                	beqz	a0,1f00 <forktest+0x46>
  for(n=0; n<N; n++){
    1ede:	2485                	addiw	s1,s1,1
    1ee0:	ff2498e3          	bne	s1,s2,1ed0 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ee4:	85ce                	mv	a1,s3
    1ee6:	00004517          	auipc	a0,0x4
    1eea:	67250513          	addi	a0,a0,1650 # 6558 <malloc+0xed2>
    1eee:	00003097          	auipc	ra,0x3
    1ef2:	6da080e7          	jalr	1754(ra) # 55c8 <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	00003097          	auipc	ra,0x3
    1efc:	350080e7          	jalr	848(ra) # 5248 <exit>
      exit(0);
    1f00:	00003097          	auipc	ra,0x3
    1f04:	348080e7          	jalr	840(ra) # 5248 <exit>
  if (n == 0) {
    1f08:	cc9d                	beqz	s1,1f46 <forktest+0x8c>
  if(n == N){
    1f0a:	3e800793          	li	a5,1000
    1f0e:	fcf48be3          	beq	s1,a5,1ee4 <forktest+0x2a>
  for(; n > 0; n--){
    1f12:	00905b63          	blez	s1,1f28 <forktest+0x6e>
    if(wait(0) < 0){
    1f16:	4501                	li	a0,0
    1f18:	00003097          	auipc	ra,0x3
    1f1c:	338080e7          	jalr	824(ra) # 5250 <wait>
    1f20:	04054163          	bltz	a0,1f62 <forktest+0xa8>
  for(; n > 0; n--){
    1f24:	34fd                	addiw	s1,s1,-1
    1f26:	f8e5                	bnez	s1,1f16 <forktest+0x5c>
  if(wait(0) != -1){
    1f28:	4501                	li	a0,0
    1f2a:	00003097          	auipc	ra,0x3
    1f2e:	326080e7          	jalr	806(ra) # 5250 <wait>
    1f32:	57fd                	li	a5,-1
    1f34:	04f51563          	bne	a0,a5,1f7e <forktest+0xc4>
}
    1f38:	70a2                	ld	ra,40(sp)
    1f3a:	7402                	ld	s0,32(sp)
    1f3c:	64e2                	ld	s1,24(sp)
    1f3e:	6942                	ld	s2,16(sp)
    1f40:	69a2                	ld	s3,8(sp)
    1f42:	6145                	addi	sp,sp,48
    1f44:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f46:	85ce                	mv	a1,s3
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	5f850513          	addi	a0,a0,1528 # 6540 <malloc+0xeba>
    1f50:	00003097          	auipc	ra,0x3
    1f54:	678080e7          	jalr	1656(ra) # 55c8 <printf>
    exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00003097          	auipc	ra,0x3
    1f5e:	2ee080e7          	jalr	750(ra) # 5248 <exit>
      printf("%s: wait stopped early\n", s);
    1f62:	85ce                	mv	a1,s3
    1f64:	00004517          	auipc	a0,0x4
    1f68:	61c50513          	addi	a0,a0,1564 # 6580 <malloc+0xefa>
    1f6c:	00003097          	auipc	ra,0x3
    1f70:	65c080e7          	jalr	1628(ra) # 55c8 <printf>
      exit(1);
    1f74:	4505                	li	a0,1
    1f76:	00003097          	auipc	ra,0x3
    1f7a:	2d2080e7          	jalr	722(ra) # 5248 <exit>
    printf("%s: wait got too many\n", s);
    1f7e:	85ce                	mv	a1,s3
    1f80:	00004517          	auipc	a0,0x4
    1f84:	61850513          	addi	a0,a0,1560 # 6598 <malloc+0xf12>
    1f88:	00003097          	auipc	ra,0x3
    1f8c:	640080e7          	jalr	1600(ra) # 55c8 <printf>
    exit(1);
    1f90:	4505                	li	a0,1
    1f92:	00003097          	auipc	ra,0x3
    1f96:	2b6080e7          	jalr	694(ra) # 5248 <exit>

0000000000001f9a <kernmem>:
{
    1f9a:	715d                	addi	sp,sp,-80
    1f9c:	e486                	sd	ra,72(sp)
    1f9e:	e0a2                	sd	s0,64(sp)
    1fa0:	fc26                	sd	s1,56(sp)
    1fa2:	f84a                	sd	s2,48(sp)
    1fa4:	f44e                	sd	s3,40(sp)
    1fa6:	f052                	sd	s4,32(sp)
    1fa8:	ec56                	sd	s5,24(sp)
    1faa:	0880                	addi	s0,sp,80
    1fac:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fae:	4485                	li	s1,1
    1fb0:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fb2:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fb4:	69b1                	lui	s3,0xc
    1fb6:	35098993          	addi	s3,s3,848 # c350 <buf+0xe08>
    1fba:	1003d937          	lui	s2,0x1003d
    1fbe:	090e                	slli	s2,s2,0x3
    1fc0:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002ef28>
    pid = fork();
    1fc4:	00003097          	auipc	ra,0x3
    1fc8:	27c080e7          	jalr	636(ra) # 5240 <fork>
    if(pid < 0){
    1fcc:	02054963          	bltz	a0,1ffe <kernmem+0x64>
    if(pid == 0){
    1fd0:	c529                	beqz	a0,201a <kernmem+0x80>
    wait(&xstatus);
    1fd2:	fbc40513          	addi	a0,s0,-68
    1fd6:	00003097          	auipc	ra,0x3
    1fda:	27a080e7          	jalr	634(ra) # 5250 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fde:	fbc42783          	lw	a5,-68(s0)
    1fe2:	05579c63          	bne	a5,s5,203a <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fe6:	94ce                	add	s1,s1,s3
    1fe8:	fd249ee3          	bne	s1,s2,1fc4 <kernmem+0x2a>
}
    1fec:	60a6                	ld	ra,72(sp)
    1fee:	6406                	ld	s0,64(sp)
    1ff0:	74e2                	ld	s1,56(sp)
    1ff2:	7942                	ld	s2,48(sp)
    1ff4:	79a2                	ld	s3,40(sp)
    1ff6:	7a02                	ld	s4,32(sp)
    1ff8:	6ae2                	ld	s5,24(sp)
    1ffa:	6161                	addi	sp,sp,80
    1ffc:	8082                	ret
      printf("%s: fork failed\n", s);
    1ffe:	85d2                	mv	a1,s4
    2000:	00004517          	auipc	a0,0x4
    2004:	2e050513          	addi	a0,a0,736 # 62e0 <malloc+0xc5a>
    2008:	00003097          	auipc	ra,0x3
    200c:	5c0080e7          	jalr	1472(ra) # 55c8 <printf>
      exit(1);
    2010:	4505                	li	a0,1
    2012:	00003097          	auipc	ra,0x3
    2016:	236080e7          	jalr	566(ra) # 5248 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    201a:	0004c603          	lbu	a2,0(s1)
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	59050513          	addi	a0,a0,1424 # 65b0 <malloc+0xf2a>
    2028:	00003097          	auipc	ra,0x3
    202c:	5a0080e7          	jalr	1440(ra) # 55c8 <printf>
      exit(1);
    2030:	4505                	li	a0,1
    2032:	00003097          	auipc	ra,0x3
    2036:	216080e7          	jalr	534(ra) # 5248 <exit>
      exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	20c080e7          	jalr	524(ra) # 5248 <exit>

0000000000002044 <bigargtest>:
{
    2044:	7179                	addi	sp,sp,-48
    2046:	f406                	sd	ra,40(sp)
    2048:	f022                	sd	s0,32(sp)
    204a:	ec26                	sd	s1,24(sp)
    204c:	1800                	addi	s0,sp,48
    204e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2050:	00004517          	auipc	a0,0x4
    2054:	58050513          	addi	a0,a0,1408 # 65d0 <malloc+0xf4a>
    2058:	00003097          	auipc	ra,0x3
    205c:	240080e7          	jalr	576(ra) # 5298 <unlink>
  pid = fork();
    2060:	00003097          	auipc	ra,0x3
    2064:	1e0080e7          	jalr	480(ra) # 5240 <fork>
  if(pid == 0){
    2068:	c121                	beqz	a0,20a8 <bigargtest+0x64>
  } else if(pid < 0){
    206a:	0a054063          	bltz	a0,210a <bigargtest+0xc6>
  wait(&xstatus);
    206e:	fdc40513          	addi	a0,s0,-36
    2072:	00003097          	auipc	ra,0x3
    2076:	1de080e7          	jalr	478(ra) # 5250 <wait>
  if(xstatus != 0)
    207a:	fdc42503          	lw	a0,-36(s0)
    207e:	e545                	bnez	a0,2126 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2080:	4581                	li	a1,0
    2082:	00004517          	auipc	a0,0x4
    2086:	54e50513          	addi	a0,a0,1358 # 65d0 <malloc+0xf4a>
    208a:	00003097          	auipc	ra,0x3
    208e:	1fe080e7          	jalr	510(ra) # 5288 <open>
  if(fd < 0){
    2092:	08054e63          	bltz	a0,212e <bigargtest+0xea>
  close(fd);
    2096:	00003097          	auipc	ra,0x3
    209a:	1da080e7          	jalr	474(ra) # 5270 <close>
}
    209e:	70a2                	ld	ra,40(sp)
    20a0:	7402                	ld	s0,32(sp)
    20a2:	64e2                	ld	s1,24(sp)
    20a4:	6145                	addi	sp,sp,48
    20a6:	8082                	ret
    20a8:	00006797          	auipc	a5,0x6
    20ac:	c8878793          	addi	a5,a5,-888 # 7d30 <args.1807>
    20b0:	00006697          	auipc	a3,0x6
    20b4:	d7868693          	addi	a3,a3,-648 # 7e28 <args.1807+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b8:	00004717          	auipc	a4,0x4
    20bc:	52870713          	addi	a4,a4,1320 # 65e0 <malloc+0xf5a>
    20c0:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20c2:	07a1                	addi	a5,a5,8
    20c4:	fed79ee3          	bne	a5,a3,20c0 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c8:	00006597          	auipc	a1,0x6
    20cc:	c6858593          	addi	a1,a1,-920 # 7d30 <args.1807>
    20d0:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d4:	00004517          	auipc	a0,0x4
    20d8:	9d450513          	addi	a0,a0,-1580 # 5aa8 <malloc+0x422>
    20dc:	00003097          	auipc	ra,0x3
    20e0:	1a4080e7          	jalr	420(ra) # 5280 <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e4:	20000593          	li	a1,512
    20e8:	00004517          	auipc	a0,0x4
    20ec:	4e850513          	addi	a0,a0,1256 # 65d0 <malloc+0xf4a>
    20f0:	00003097          	auipc	ra,0x3
    20f4:	198080e7          	jalr	408(ra) # 5288 <open>
    close(fd);
    20f8:	00003097          	auipc	ra,0x3
    20fc:	178080e7          	jalr	376(ra) # 5270 <close>
    exit(0);
    2100:	4501                	li	a0,0
    2102:	00003097          	auipc	ra,0x3
    2106:	146080e7          	jalr	326(ra) # 5248 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    210a:	85a6                	mv	a1,s1
    210c:	00004517          	auipc	a0,0x4
    2110:	5b450513          	addi	a0,a0,1460 # 66c0 <malloc+0x103a>
    2114:	00003097          	auipc	ra,0x3
    2118:	4b4080e7          	jalr	1204(ra) # 55c8 <printf>
    exit(1);
    211c:	4505                	li	a0,1
    211e:	00003097          	auipc	ra,0x3
    2122:	12a080e7          	jalr	298(ra) # 5248 <exit>
    exit(xstatus);
    2126:	00003097          	auipc	ra,0x3
    212a:	122080e7          	jalr	290(ra) # 5248 <exit>
    printf("%s: bigarg test failed!\n", s);
    212e:	85a6                	mv	a1,s1
    2130:	00004517          	auipc	a0,0x4
    2134:	5b050513          	addi	a0,a0,1456 # 66e0 <malloc+0x105a>
    2138:	00003097          	auipc	ra,0x3
    213c:	490080e7          	jalr	1168(ra) # 55c8 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	00003097          	auipc	ra,0x3
    2146:	106080e7          	jalr	262(ra) # 5248 <exit>

000000000000214a <stacktest>:
{
    214a:	7179                	addi	sp,sp,-48
    214c:	f406                	sd	ra,40(sp)
    214e:	f022                	sd	s0,32(sp)
    2150:	ec26                	sd	s1,24(sp)
    2152:	1800                	addi	s0,sp,48
    2154:	84aa                	mv	s1,a0
  pid = fork();
    2156:	00003097          	auipc	ra,0x3
    215a:	0ea080e7          	jalr	234(ra) # 5240 <fork>
  if(pid == 0) {
    215e:	c115                	beqz	a0,2182 <stacktest+0x38>
  } else if(pid < 0){
    2160:	04054363          	bltz	a0,21a6 <stacktest+0x5c>
  wait(&xstatus);
    2164:	fdc40513          	addi	a0,s0,-36
    2168:	00003097          	auipc	ra,0x3
    216c:	0e8080e7          	jalr	232(ra) # 5250 <wait>
  if(xstatus == -1)  // kernel killed child?
    2170:	fdc42503          	lw	a0,-36(s0)
    2174:	57fd                	li	a5,-1
    2176:	04f50663          	beq	a0,a5,21c2 <stacktest+0x78>
    exit(xstatus);
    217a:	00003097          	auipc	ra,0x3
    217e:	0ce080e7          	jalr	206(ra) # 5248 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2182:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2184:	77fd                	lui	a5,0xfffff
    2186:	97ba                	add	a5,a5,a4
    2188:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0aa8>
    218c:	00004517          	auipc	a0,0x4
    2190:	57450513          	addi	a0,a0,1396 # 6700 <malloc+0x107a>
    2194:	00003097          	auipc	ra,0x3
    2198:	434080e7          	jalr	1076(ra) # 55c8 <printf>
    exit(1);
    219c:	4505                	li	a0,1
    219e:	00003097          	auipc	ra,0x3
    21a2:	0aa080e7          	jalr	170(ra) # 5248 <exit>
    printf("%s: fork failed\n", s);
    21a6:	85a6                	mv	a1,s1
    21a8:	00004517          	auipc	a0,0x4
    21ac:	13850513          	addi	a0,a0,312 # 62e0 <malloc+0xc5a>
    21b0:	00003097          	auipc	ra,0x3
    21b4:	418080e7          	jalr	1048(ra) # 55c8 <printf>
    exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00003097          	auipc	ra,0x3
    21be:	08e080e7          	jalr	142(ra) # 5248 <exit>
    exit(0);
    21c2:	4501                	li	a0,0
    21c4:	00003097          	auipc	ra,0x3
    21c8:	084080e7          	jalr	132(ra) # 5248 <exit>

00000000000021cc <copyinstr3>:
{
    21cc:	7179                	addi	sp,sp,-48
    21ce:	f406                	sd	ra,40(sp)
    21d0:	f022                	sd	s0,32(sp)
    21d2:	ec26                	sd	s1,24(sp)
    21d4:	1800                	addi	s0,sp,48
  sbrk(8192);
    21d6:	6509                	lui	a0,0x2
    21d8:	00003097          	auipc	ra,0x3
    21dc:	0f8080e7          	jalr	248(ra) # 52d0 <sbrk>
  uint64 top = (uint64) sbrk(0);
    21e0:	4501                	li	a0,0
    21e2:	00003097          	auipc	ra,0x3
    21e6:	0ee080e7          	jalr	238(ra) # 52d0 <sbrk>
  if((top % PGSIZE) != 0){
    21ea:	03451793          	slli	a5,a0,0x34
    21ee:	e3c9                	bnez	a5,2270 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21f0:	4501                	li	a0,0
    21f2:	00003097          	auipc	ra,0x3
    21f6:	0de080e7          	jalr	222(ra) # 52d0 <sbrk>
  if(top % PGSIZE){
    21fa:	03451793          	slli	a5,a0,0x34
    21fe:	e3d9                	bnez	a5,2284 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2200:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x65>
  *b = 'x';
    2204:	07800793          	li	a5,120
    2208:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    220c:	8526                	mv	a0,s1
    220e:	00003097          	auipc	ra,0x3
    2212:	08a080e7          	jalr	138(ra) # 5298 <unlink>
  if(ret != -1){
    2216:	57fd                	li	a5,-1
    2218:	08f51363          	bne	a0,a5,229e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    221c:	20100593          	li	a1,513
    2220:	8526                	mv	a0,s1
    2222:	00003097          	auipc	ra,0x3
    2226:	066080e7          	jalr	102(ra) # 5288 <open>
  if(fd != -1){
    222a:	57fd                	li	a5,-1
    222c:	08f51863          	bne	a0,a5,22bc <copyinstr3+0xf0>
  ret = link(b, b);
    2230:	85a6                	mv	a1,s1
    2232:	8526                	mv	a0,s1
    2234:	00003097          	auipc	ra,0x3
    2238:	074080e7          	jalr	116(ra) # 52a8 <link>
  if(ret != -1){
    223c:	57fd                	li	a5,-1
    223e:	08f51e63          	bne	a0,a5,22da <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2242:	00005797          	auipc	a5,0x5
    2246:	04678793          	addi	a5,a5,70 # 7288 <malloc+0x1c02>
    224a:	fcf43823          	sd	a5,-48(s0)
    224e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2252:	fd040593          	addi	a1,s0,-48
    2256:	8526                	mv	a0,s1
    2258:	00003097          	auipc	ra,0x3
    225c:	028080e7          	jalr	40(ra) # 5280 <exec>
  if(ret != -1){
    2260:	57fd                	li	a5,-1
    2262:	08f51c63          	bne	a0,a5,22fa <copyinstr3+0x12e>
}
    2266:	70a2                	ld	ra,40(sp)
    2268:	7402                	ld	s0,32(sp)
    226a:	64e2                	ld	s1,24(sp)
    226c:	6145                	addi	sp,sp,48
    226e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2270:	1552                	slli	a0,a0,0x34
    2272:	9151                	srli	a0,a0,0x34
    2274:	6785                	lui	a5,0x1
    2276:	40a7853b          	subw	a0,a5,a0
    227a:	00003097          	auipc	ra,0x3
    227e:	056080e7          	jalr	86(ra) # 52d0 <sbrk>
    2282:	b7bd                	j	21f0 <copyinstr3+0x24>
    printf("oops\n");
    2284:	00004517          	auipc	a0,0x4
    2288:	4a450513          	addi	a0,a0,1188 # 6728 <malloc+0x10a2>
    228c:	00003097          	auipc	ra,0x3
    2290:	33c080e7          	jalr	828(ra) # 55c8 <printf>
    exit(1);
    2294:	4505                	li	a0,1
    2296:	00003097          	auipc	ra,0x3
    229a:	fb2080e7          	jalr	-78(ra) # 5248 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229e:	862a                	mv	a2,a0
    22a0:	85a6                	mv	a1,s1
    22a2:	00004517          	auipc	a0,0x4
    22a6:	f5e50513          	addi	a0,a0,-162 # 6200 <malloc+0xb7a>
    22aa:	00003097          	auipc	ra,0x3
    22ae:	31e080e7          	jalr	798(ra) # 55c8 <printf>
    exit(1);
    22b2:	4505                	li	a0,1
    22b4:	00003097          	auipc	ra,0x3
    22b8:	f94080e7          	jalr	-108(ra) # 5248 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22bc:	862a                	mv	a2,a0
    22be:	85a6                	mv	a1,s1
    22c0:	00004517          	auipc	a0,0x4
    22c4:	f6050513          	addi	a0,a0,-160 # 6220 <malloc+0xb9a>
    22c8:	00003097          	auipc	ra,0x3
    22cc:	300080e7          	jalr	768(ra) # 55c8 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	00003097          	auipc	ra,0x3
    22d6:	f76080e7          	jalr	-138(ra) # 5248 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22da:	86aa                	mv	a3,a0
    22dc:	8626                	mv	a2,s1
    22de:	85a6                	mv	a1,s1
    22e0:	00004517          	auipc	a0,0x4
    22e4:	f6050513          	addi	a0,a0,-160 # 6240 <malloc+0xbba>
    22e8:	00003097          	auipc	ra,0x3
    22ec:	2e0080e7          	jalr	736(ra) # 55c8 <printf>
    exit(1);
    22f0:	4505                	li	a0,1
    22f2:	00003097          	auipc	ra,0x3
    22f6:	f56080e7          	jalr	-170(ra) # 5248 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22fa:	567d                	li	a2,-1
    22fc:	85a6                	mv	a1,s1
    22fe:	00004517          	auipc	a0,0x4
    2302:	f6a50513          	addi	a0,a0,-150 # 6268 <malloc+0xbe2>
    2306:	00003097          	auipc	ra,0x3
    230a:	2c2080e7          	jalr	706(ra) # 55c8 <printf>
    exit(1);
    230e:	4505                	li	a0,1
    2310:	00003097          	auipc	ra,0x3
    2314:	f38080e7          	jalr	-200(ra) # 5248 <exit>

0000000000002318 <sbrkbasic>:
{
    2318:	7139                	addi	sp,sp,-64
    231a:	fc06                	sd	ra,56(sp)
    231c:	f822                	sd	s0,48(sp)
    231e:	f426                	sd	s1,40(sp)
    2320:	f04a                	sd	s2,32(sp)
    2322:	ec4e                	sd	s3,24(sp)
    2324:	e852                	sd	s4,16(sp)
    2326:	0080                	addi	s0,sp,64
    2328:	8a2a                	mv	s4,a0
  a = sbrk(TOOMUCH);
    232a:	40000537          	lui	a0,0x40000
    232e:	00003097          	auipc	ra,0x3
    2332:	fa2080e7          	jalr	-94(ra) # 52d0 <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    2336:	57fd                	li	a5,-1
    2338:	02f50063          	beq	a0,a5,2358 <sbrkbasic+0x40>
    233c:	85aa                	mv	a1,a0
    printf("%s: sbrk(<toomuch>) returned %p\n", a);
    233e:	00004517          	auipc	a0,0x4
    2342:	3f250513          	addi	a0,a0,1010 # 6730 <malloc+0x10aa>
    2346:	00003097          	auipc	ra,0x3
    234a:	282080e7          	jalr	642(ra) # 55c8 <printf>
    exit(1);
    234e:	4505                	li	a0,1
    2350:	00003097          	auipc	ra,0x3
    2354:	ef8080e7          	jalr	-264(ra) # 5248 <exit>
  a = sbrk(0);
    2358:	4501                	li	a0,0
    235a:	00003097          	auipc	ra,0x3
    235e:	f76080e7          	jalr	-138(ra) # 52d0 <sbrk>
    2362:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2364:	4901                	li	s2,0
    2366:	6985                	lui	s3,0x1
    2368:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1ce>
    236c:	a011                	j	2370 <sbrkbasic+0x58>
    a = b + 1;
    236e:	84be                	mv	s1,a5
    b = sbrk(1);
    2370:	4505                	li	a0,1
    2372:	00003097          	auipc	ra,0x3
    2376:	f5e080e7          	jalr	-162(ra) # 52d0 <sbrk>
    if(b != a){
    237a:	04951c63          	bne	a0,s1,23d2 <sbrkbasic+0xba>
    *b = 1;
    237e:	4785                	li	a5,1
    2380:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2384:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2388:	2905                	addiw	s2,s2,1
    238a:	ff3912e3          	bne	s2,s3,236e <sbrkbasic+0x56>
  pid = fork();
    238e:	00003097          	auipc	ra,0x3
    2392:	eb2080e7          	jalr	-334(ra) # 5240 <fork>
    2396:	892a                	mv	s2,a0
  if(pid < 0){
    2398:	04054d63          	bltz	a0,23f2 <sbrkbasic+0xda>
  c = sbrk(1);
    239c:	4505                	li	a0,1
    239e:	00003097          	auipc	ra,0x3
    23a2:	f32080e7          	jalr	-206(ra) # 52d0 <sbrk>
  c = sbrk(1);
    23a6:	4505                	li	a0,1
    23a8:	00003097          	auipc	ra,0x3
    23ac:	f28080e7          	jalr	-216(ra) # 52d0 <sbrk>
  if(c != a + 1){
    23b0:	0489                	addi	s1,s1,2
    23b2:	04a48e63          	beq	s1,a0,240e <sbrkbasic+0xf6>
    printf("%s: sbrk test failed post-fork\n", s);
    23b6:	85d2                	mv	a1,s4
    23b8:	00004517          	auipc	a0,0x4
    23bc:	3e050513          	addi	a0,a0,992 # 6798 <malloc+0x1112>
    23c0:	00003097          	auipc	ra,0x3
    23c4:	208080e7          	jalr	520(ra) # 55c8 <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00003097          	auipc	ra,0x3
    23ce:	e7e080e7          	jalr	-386(ra) # 5248 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    23d2:	86aa                	mv	a3,a0
    23d4:	8626                	mv	a2,s1
    23d6:	85ca                	mv	a1,s2
    23d8:	00004517          	auipc	a0,0x4
    23dc:	38050513          	addi	a0,a0,896 # 6758 <malloc+0x10d2>
    23e0:	00003097          	auipc	ra,0x3
    23e4:	1e8080e7          	jalr	488(ra) # 55c8 <printf>
      exit(1);
    23e8:	4505                	li	a0,1
    23ea:	00003097          	auipc	ra,0x3
    23ee:	e5e080e7          	jalr	-418(ra) # 5248 <exit>
    printf("%s: sbrk test fork failed\n", s);
    23f2:	85d2                	mv	a1,s4
    23f4:	00004517          	auipc	a0,0x4
    23f8:	38450513          	addi	a0,a0,900 # 6778 <malloc+0x10f2>
    23fc:	00003097          	auipc	ra,0x3
    2400:	1cc080e7          	jalr	460(ra) # 55c8 <printf>
    exit(1);
    2404:	4505                	li	a0,1
    2406:	00003097          	auipc	ra,0x3
    240a:	e42080e7          	jalr	-446(ra) # 5248 <exit>
  if(pid == 0)
    240e:	00091763          	bnez	s2,241c <sbrkbasic+0x104>
    exit(0);
    2412:	4501                	li	a0,0
    2414:	00003097          	auipc	ra,0x3
    2418:	e34080e7          	jalr	-460(ra) # 5248 <exit>
  wait(&xstatus);
    241c:	fcc40513          	addi	a0,s0,-52
    2420:	00003097          	auipc	ra,0x3
    2424:	e30080e7          	jalr	-464(ra) # 5250 <wait>
  exit(xstatus);
    2428:	fcc42503          	lw	a0,-52(s0)
    242c:	00003097          	auipc	ra,0x3
    2430:	e1c080e7          	jalr	-484(ra) # 5248 <exit>

0000000000002434 <sbrkmuch>:
{
    2434:	7179                	addi	sp,sp,-48
    2436:	f406                	sd	ra,40(sp)
    2438:	f022                	sd	s0,32(sp)
    243a:	ec26                	sd	s1,24(sp)
    243c:	e84a                	sd	s2,16(sp)
    243e:	e44e                	sd	s3,8(sp)
    2440:	e052                	sd	s4,0(sp)
    2442:	1800                	addi	s0,sp,48
    2444:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2446:	4501                	li	a0,0
    2448:	00003097          	auipc	ra,0x3
    244c:	e88080e7          	jalr	-376(ra) # 52d0 <sbrk>
    2450:	892a                	mv	s2,a0
  a = sbrk(0);
    2452:	4501                	li	a0,0
    2454:	00003097          	auipc	ra,0x3
    2458:	e7c080e7          	jalr	-388(ra) # 52d0 <sbrk>
    245c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    245e:	06400537          	lui	a0,0x6400
    2462:	9d05                	subw	a0,a0,s1
    2464:	00003097          	auipc	ra,0x3
    2468:	e6c080e7          	jalr	-404(ra) # 52d0 <sbrk>
  if (p != a) {
    246c:	0ca49863          	bne	s1,a0,253c <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2470:	4501                	li	a0,0
    2472:	00003097          	auipc	ra,0x3
    2476:	e5e080e7          	jalr	-418(ra) # 52d0 <sbrk>
    247a:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    247c:	00a4f963          	bgeu	s1,a0,248e <sbrkmuch+0x5a>
    *pp = 1;
    2480:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2482:	6705                	lui	a4,0x1
    *pp = 1;
    2484:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2488:	94ba                	add	s1,s1,a4
    248a:	fef4ede3          	bltu	s1,a5,2484 <sbrkmuch+0x50>
  *lastaddr = 99;
    248e:	064007b7          	lui	a5,0x6400
    2492:	06300713          	li	a4,99
    2496:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1aa7>
  a = sbrk(0);
    249a:	4501                	li	a0,0
    249c:	00003097          	auipc	ra,0x3
    24a0:	e34080e7          	jalr	-460(ra) # 52d0 <sbrk>
    24a4:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    24a6:	757d                	lui	a0,0xfffff
    24a8:	00003097          	auipc	ra,0x3
    24ac:	e28080e7          	jalr	-472(ra) # 52d0 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    24b0:	57fd                	li	a5,-1
    24b2:	0af50363          	beq	a0,a5,2558 <sbrkmuch+0x124>
  c = sbrk(0);
    24b6:	4501                	li	a0,0
    24b8:	00003097          	auipc	ra,0x3
    24bc:	e18080e7          	jalr	-488(ra) # 52d0 <sbrk>
  if(c != a - PGSIZE){
    24c0:	77fd                	lui	a5,0xfffff
    24c2:	97a6                	add	a5,a5,s1
    24c4:	0af51863          	bne	a0,a5,2574 <sbrkmuch+0x140>
  a = sbrk(0);
    24c8:	4501                	li	a0,0
    24ca:	00003097          	auipc	ra,0x3
    24ce:	e06080e7          	jalr	-506(ra) # 52d0 <sbrk>
    24d2:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    24d4:	6505                	lui	a0,0x1
    24d6:	00003097          	auipc	ra,0x3
    24da:	dfa080e7          	jalr	-518(ra) # 52d0 <sbrk>
    24de:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    24e0:	0aa49963          	bne	s1,a0,2592 <sbrkmuch+0x15e>
    24e4:	4501                	li	a0,0
    24e6:	00003097          	auipc	ra,0x3
    24ea:	dea080e7          	jalr	-534(ra) # 52d0 <sbrk>
    24ee:	6785                	lui	a5,0x1
    24f0:	97a6                	add	a5,a5,s1
    24f2:	0af51063          	bne	a0,a5,2592 <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    24f6:	064007b7          	lui	a5,0x6400
    24fa:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1aa7>
    24fe:	06300793          	li	a5,99
    2502:	0af70763          	beq	a4,a5,25b0 <sbrkmuch+0x17c>
  a = sbrk(0);
    2506:	4501                	li	a0,0
    2508:	00003097          	auipc	ra,0x3
    250c:	dc8080e7          	jalr	-568(ra) # 52d0 <sbrk>
    2510:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2512:	4501                	li	a0,0
    2514:	00003097          	auipc	ra,0x3
    2518:	dbc080e7          	jalr	-580(ra) # 52d0 <sbrk>
    251c:	40a9053b          	subw	a0,s2,a0
    2520:	00003097          	auipc	ra,0x3
    2524:	db0080e7          	jalr	-592(ra) # 52d0 <sbrk>
  if(c != a){
    2528:	0aa49263          	bne	s1,a0,25cc <sbrkmuch+0x198>
}
    252c:	70a2                	ld	ra,40(sp)
    252e:	7402                	ld	s0,32(sp)
    2530:	64e2                	ld	s1,24(sp)
    2532:	6942                	ld	s2,16(sp)
    2534:	69a2                	ld	s3,8(sp)
    2536:	6a02                	ld	s4,0(sp)
    2538:	6145                	addi	sp,sp,48
    253a:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    253c:	85ce                	mv	a1,s3
    253e:	00004517          	auipc	a0,0x4
    2542:	27a50513          	addi	a0,a0,634 # 67b8 <malloc+0x1132>
    2546:	00003097          	auipc	ra,0x3
    254a:	082080e7          	jalr	130(ra) # 55c8 <printf>
    exit(1);
    254e:	4505                	li	a0,1
    2550:	00003097          	auipc	ra,0x3
    2554:	cf8080e7          	jalr	-776(ra) # 5248 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2558:	85ce                	mv	a1,s3
    255a:	00004517          	auipc	a0,0x4
    255e:	2a650513          	addi	a0,a0,678 # 6800 <malloc+0x117a>
    2562:	00003097          	auipc	ra,0x3
    2566:	066080e7          	jalr	102(ra) # 55c8 <printf>
    exit(1);
    256a:	4505                	li	a0,1
    256c:	00003097          	auipc	ra,0x3
    2570:	cdc080e7          	jalr	-804(ra) # 5248 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2574:	862a                	mv	a2,a0
    2576:	85a6                	mv	a1,s1
    2578:	00004517          	auipc	a0,0x4
    257c:	2a850513          	addi	a0,a0,680 # 6820 <malloc+0x119a>
    2580:	00003097          	auipc	ra,0x3
    2584:	048080e7          	jalr	72(ra) # 55c8 <printf>
    exit(1);
    2588:	4505                	li	a0,1
    258a:	00003097          	auipc	ra,0x3
    258e:	cbe080e7          	jalr	-834(ra) # 5248 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    2592:	8652                	mv	a2,s4
    2594:	85a6                	mv	a1,s1
    2596:	00004517          	auipc	a0,0x4
    259a:	2ca50513          	addi	a0,a0,714 # 6860 <malloc+0x11da>
    259e:	00003097          	auipc	ra,0x3
    25a2:	02a080e7          	jalr	42(ra) # 55c8 <printf>
    exit(1);
    25a6:	4505                	li	a0,1
    25a8:	00003097          	auipc	ra,0x3
    25ac:	ca0080e7          	jalr	-864(ra) # 5248 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    25b0:	85ce                	mv	a1,s3
    25b2:	00004517          	auipc	a0,0x4
    25b6:	2de50513          	addi	a0,a0,734 # 6890 <malloc+0x120a>
    25ba:	00003097          	auipc	ra,0x3
    25be:	00e080e7          	jalr	14(ra) # 55c8 <printf>
    exit(1);
    25c2:	4505                	li	a0,1
    25c4:	00003097          	auipc	ra,0x3
    25c8:	c84080e7          	jalr	-892(ra) # 5248 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    25cc:	862a                	mv	a2,a0
    25ce:	85a6                	mv	a1,s1
    25d0:	00004517          	auipc	a0,0x4
    25d4:	2f850513          	addi	a0,a0,760 # 68c8 <malloc+0x1242>
    25d8:	00003097          	auipc	ra,0x3
    25dc:	ff0080e7          	jalr	-16(ra) # 55c8 <printf>
    exit(1);
    25e0:	4505                	li	a0,1
    25e2:	00003097          	auipc	ra,0x3
    25e6:	c66080e7          	jalr	-922(ra) # 5248 <exit>

00000000000025ea <sbrkarg>:
{
    25ea:	7179                	addi	sp,sp,-48
    25ec:	f406                	sd	ra,40(sp)
    25ee:	f022                	sd	s0,32(sp)
    25f0:	ec26                	sd	s1,24(sp)
    25f2:	e84a                	sd	s2,16(sp)
    25f4:	e44e                	sd	s3,8(sp)
    25f6:	1800                	addi	s0,sp,48
    25f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    25fa:	6505                	lui	a0,0x1
    25fc:	00003097          	auipc	ra,0x3
    2600:	cd4080e7          	jalr	-812(ra) # 52d0 <sbrk>
    2604:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2606:	20100593          	li	a1,513
    260a:	00004517          	auipc	a0,0x4
    260e:	2e650513          	addi	a0,a0,742 # 68f0 <malloc+0x126a>
    2612:	00003097          	auipc	ra,0x3
    2616:	c76080e7          	jalr	-906(ra) # 5288 <open>
    261a:	84aa                	mv	s1,a0
  unlink("sbrk");
    261c:	00004517          	auipc	a0,0x4
    2620:	2d450513          	addi	a0,a0,724 # 68f0 <malloc+0x126a>
    2624:	00003097          	auipc	ra,0x3
    2628:	c74080e7          	jalr	-908(ra) # 5298 <unlink>
  if(fd < 0)  {
    262c:	0404c163          	bltz	s1,266e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2630:	6605                	lui	a2,0x1
    2632:	85ca                	mv	a1,s2
    2634:	8526                	mv	a0,s1
    2636:	00003097          	auipc	ra,0x3
    263a:	c32080e7          	jalr	-974(ra) # 5268 <write>
    263e:	04054663          	bltz	a0,268a <sbrkarg+0xa0>
  close(fd);
    2642:	8526                	mv	a0,s1
    2644:	00003097          	auipc	ra,0x3
    2648:	c2c080e7          	jalr	-980(ra) # 5270 <close>
  a = sbrk(PGSIZE);
    264c:	6505                	lui	a0,0x1
    264e:	00003097          	auipc	ra,0x3
    2652:	c82080e7          	jalr	-894(ra) # 52d0 <sbrk>
  if(pipe((int *) a) != 0){
    2656:	00003097          	auipc	ra,0x3
    265a:	c02080e7          	jalr	-1022(ra) # 5258 <pipe>
    265e:	e521                	bnez	a0,26a6 <sbrkarg+0xbc>
}
    2660:	70a2                	ld	ra,40(sp)
    2662:	7402                	ld	s0,32(sp)
    2664:	64e2                	ld	s1,24(sp)
    2666:	6942                	ld	s2,16(sp)
    2668:	69a2                	ld	s3,8(sp)
    266a:	6145                	addi	sp,sp,48
    266c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    266e:	85ce                	mv	a1,s3
    2670:	00004517          	auipc	a0,0x4
    2674:	28850513          	addi	a0,a0,648 # 68f8 <malloc+0x1272>
    2678:	00003097          	auipc	ra,0x3
    267c:	f50080e7          	jalr	-176(ra) # 55c8 <printf>
    exit(1);
    2680:	4505                	li	a0,1
    2682:	00003097          	auipc	ra,0x3
    2686:	bc6080e7          	jalr	-1082(ra) # 5248 <exit>
    printf("%s: write sbrk failed\n", s);
    268a:	85ce                	mv	a1,s3
    268c:	00004517          	auipc	a0,0x4
    2690:	28450513          	addi	a0,a0,644 # 6910 <malloc+0x128a>
    2694:	00003097          	auipc	ra,0x3
    2698:	f34080e7          	jalr	-204(ra) # 55c8 <printf>
    exit(1);
    269c:	4505                	li	a0,1
    269e:	00003097          	auipc	ra,0x3
    26a2:	baa080e7          	jalr	-1110(ra) # 5248 <exit>
    printf("%s: pipe() failed\n", s);
    26a6:	85ce                	mv	a1,s3
    26a8:	00004517          	auipc	a0,0x4
    26ac:	d4050513          	addi	a0,a0,-704 # 63e8 <malloc+0xd62>
    26b0:	00003097          	auipc	ra,0x3
    26b4:	f18080e7          	jalr	-232(ra) # 55c8 <printf>
    exit(1);
    26b8:	4505                	li	a0,1
    26ba:	00003097          	auipc	ra,0x3
    26be:	b8e080e7          	jalr	-1138(ra) # 5248 <exit>

00000000000026c2 <argptest>:
{
    26c2:	1101                	addi	sp,sp,-32
    26c4:	ec06                	sd	ra,24(sp)
    26c6:	e822                	sd	s0,16(sp)
    26c8:	e426                	sd	s1,8(sp)
    26ca:	e04a                	sd	s2,0(sp)
    26cc:	1000                	addi	s0,sp,32
    26ce:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    26d0:	4581                	li	a1,0
    26d2:	00004517          	auipc	a0,0x4
    26d6:	25650513          	addi	a0,a0,598 # 6928 <malloc+0x12a2>
    26da:	00003097          	auipc	ra,0x3
    26de:	bae080e7          	jalr	-1106(ra) # 5288 <open>
  if (fd < 0) {
    26e2:	02054b63          	bltz	a0,2718 <argptest+0x56>
    26e6:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    26e8:	4501                	li	a0,0
    26ea:	00003097          	auipc	ra,0x3
    26ee:	be6080e7          	jalr	-1050(ra) # 52d0 <sbrk>
    26f2:	567d                	li	a2,-1
    26f4:	fff50593          	addi	a1,a0,-1
    26f8:	8526                	mv	a0,s1
    26fa:	00003097          	auipc	ra,0x3
    26fe:	b66080e7          	jalr	-1178(ra) # 5260 <read>
  close(fd);
    2702:	8526                	mv	a0,s1
    2704:	00003097          	auipc	ra,0x3
    2708:	b6c080e7          	jalr	-1172(ra) # 5270 <close>
}
    270c:	60e2                	ld	ra,24(sp)
    270e:	6442                	ld	s0,16(sp)
    2710:	64a2                	ld	s1,8(sp)
    2712:	6902                	ld	s2,0(sp)
    2714:	6105                	addi	sp,sp,32
    2716:	8082                	ret
    printf("%s: open failed\n", s);
    2718:	85ca                	mv	a1,s2
    271a:	00004517          	auipc	a0,0x4
    271e:	bde50513          	addi	a0,a0,-1058 # 62f8 <malloc+0xc72>
    2722:	00003097          	auipc	ra,0x3
    2726:	ea6080e7          	jalr	-346(ra) # 55c8 <printf>
    exit(1);
    272a:	4505                	li	a0,1
    272c:	00003097          	auipc	ra,0x3
    2730:	b1c080e7          	jalr	-1252(ra) # 5248 <exit>

0000000000002734 <sbrkbugs>:
{
    2734:	1141                	addi	sp,sp,-16
    2736:	e406                	sd	ra,8(sp)
    2738:	e022                	sd	s0,0(sp)
    273a:	0800                	addi	s0,sp,16
  int pid = fork();
    273c:	00003097          	auipc	ra,0x3
    2740:	b04080e7          	jalr	-1276(ra) # 5240 <fork>
  if(pid < 0){
    2744:	02054263          	bltz	a0,2768 <sbrkbugs+0x34>
  if(pid == 0){
    2748:	ed0d                	bnez	a0,2782 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    274a:	00003097          	auipc	ra,0x3
    274e:	b86080e7          	jalr	-1146(ra) # 52d0 <sbrk>
    sbrk(-sz);
    2752:	40a0053b          	negw	a0,a0
    2756:	00003097          	auipc	ra,0x3
    275a:	b7a080e7          	jalr	-1158(ra) # 52d0 <sbrk>
    exit(0);
    275e:	4501                	li	a0,0
    2760:	00003097          	auipc	ra,0x3
    2764:	ae8080e7          	jalr	-1304(ra) # 5248 <exit>
    printf("fork failed\n");
    2768:	00004517          	auipc	a0,0x4
    276c:	f6850513          	addi	a0,a0,-152 # 66d0 <malloc+0x104a>
    2770:	00003097          	auipc	ra,0x3
    2774:	e58080e7          	jalr	-424(ra) # 55c8 <printf>
    exit(1);
    2778:	4505                	li	a0,1
    277a:	00003097          	auipc	ra,0x3
    277e:	ace080e7          	jalr	-1330(ra) # 5248 <exit>
  wait(0);
    2782:	4501                	li	a0,0
    2784:	00003097          	auipc	ra,0x3
    2788:	acc080e7          	jalr	-1332(ra) # 5250 <wait>
  pid = fork();
    278c:	00003097          	auipc	ra,0x3
    2790:	ab4080e7          	jalr	-1356(ra) # 5240 <fork>
  if(pid < 0){
    2794:	02054563          	bltz	a0,27be <sbrkbugs+0x8a>
  if(pid == 0){
    2798:	e121                	bnez	a0,27d8 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    279a:	00003097          	auipc	ra,0x3
    279e:	b36080e7          	jalr	-1226(ra) # 52d0 <sbrk>
    sbrk(-(sz - 3500));
    27a2:	6785                	lui	a5,0x1
    27a4:	dac7879b          	addiw	a5,a5,-596
    27a8:	40a7853b          	subw	a0,a5,a0
    27ac:	00003097          	auipc	ra,0x3
    27b0:	b24080e7          	jalr	-1244(ra) # 52d0 <sbrk>
    exit(0);
    27b4:	4501                	li	a0,0
    27b6:	00003097          	auipc	ra,0x3
    27ba:	a92080e7          	jalr	-1390(ra) # 5248 <exit>
    printf("fork failed\n");
    27be:	00004517          	auipc	a0,0x4
    27c2:	f1250513          	addi	a0,a0,-238 # 66d0 <malloc+0x104a>
    27c6:	00003097          	auipc	ra,0x3
    27ca:	e02080e7          	jalr	-510(ra) # 55c8 <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	00003097          	auipc	ra,0x3
    27d4:	a78080e7          	jalr	-1416(ra) # 5248 <exit>
  wait(0);
    27d8:	4501                	li	a0,0
    27da:	00003097          	auipc	ra,0x3
    27de:	a76080e7          	jalr	-1418(ra) # 5250 <wait>
  pid = fork();
    27e2:	00003097          	auipc	ra,0x3
    27e6:	a5e080e7          	jalr	-1442(ra) # 5240 <fork>
  if(pid < 0){
    27ea:	02054a63          	bltz	a0,281e <sbrkbugs+0xea>
  if(pid == 0){
    27ee:	e529                	bnez	a0,2838 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    27f0:	00003097          	auipc	ra,0x3
    27f4:	ae0080e7          	jalr	-1312(ra) # 52d0 <sbrk>
    27f8:	67ad                	lui	a5,0xb
    27fa:	8007879b          	addiw	a5,a5,-2048
    27fe:	40a7853b          	subw	a0,a5,a0
    2802:	00003097          	auipc	ra,0x3
    2806:	ace080e7          	jalr	-1330(ra) # 52d0 <sbrk>
    sbrk(-10);
    280a:	5559                	li	a0,-10
    280c:	00003097          	auipc	ra,0x3
    2810:	ac4080e7          	jalr	-1340(ra) # 52d0 <sbrk>
    exit(0);
    2814:	4501                	li	a0,0
    2816:	00003097          	auipc	ra,0x3
    281a:	a32080e7          	jalr	-1486(ra) # 5248 <exit>
    printf("fork failed\n");
    281e:	00004517          	auipc	a0,0x4
    2822:	eb250513          	addi	a0,a0,-334 # 66d0 <malloc+0x104a>
    2826:	00003097          	auipc	ra,0x3
    282a:	da2080e7          	jalr	-606(ra) # 55c8 <printf>
    exit(1);
    282e:	4505                	li	a0,1
    2830:	00003097          	auipc	ra,0x3
    2834:	a18080e7          	jalr	-1512(ra) # 5248 <exit>
  wait(0);
    2838:	4501                	li	a0,0
    283a:	00003097          	auipc	ra,0x3
    283e:	a16080e7          	jalr	-1514(ra) # 5250 <wait>
  exit(0);
    2842:	4501                	li	a0,0
    2844:	00003097          	auipc	ra,0x3
    2848:	a04080e7          	jalr	-1532(ra) # 5248 <exit>

000000000000284c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    284c:	715d                	addi	sp,sp,-80
    284e:	e486                	sd	ra,72(sp)
    2850:	e0a2                	sd	s0,64(sp)
    2852:	fc26                	sd	s1,56(sp)
    2854:	f84a                	sd	s2,48(sp)
    2856:	f44e                	sd	s3,40(sp)
    2858:	f052                	sd	s4,32(sp)
    285a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    285c:	4901                	li	s2,0
    285e:	49bd                	li	s3,15
    int pid = fork();
    2860:	00003097          	auipc	ra,0x3
    2864:	9e0080e7          	jalr	-1568(ra) # 5240 <fork>
    2868:	84aa                	mv	s1,a0
    if(pid < 0){
    286a:	02054063          	bltz	a0,288a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    286e:	c91d                	beqz	a0,28a4 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2870:	4501                	li	a0,0
    2872:	00003097          	auipc	ra,0x3
    2876:	9de080e7          	jalr	-1570(ra) # 5250 <wait>
  for(int avail = 0; avail < 15; avail++){
    287a:	2905                	addiw	s2,s2,1
    287c:	ff3912e3          	bne	s2,s3,2860 <execout+0x14>
    }
  }

  exit(0);
    2880:	4501                	li	a0,0
    2882:	00003097          	auipc	ra,0x3
    2886:	9c6080e7          	jalr	-1594(ra) # 5248 <exit>
      printf("fork failed\n");
    288a:	00004517          	auipc	a0,0x4
    288e:	e4650513          	addi	a0,a0,-442 # 66d0 <malloc+0x104a>
    2892:	00003097          	auipc	ra,0x3
    2896:	d36080e7          	jalr	-714(ra) # 55c8 <printf>
      exit(1);
    289a:	4505                	li	a0,1
    289c:	00003097          	auipc	ra,0x3
    28a0:	9ac080e7          	jalr	-1620(ra) # 5248 <exit>
        if(a == 0xffffffffffffffffLL)
    28a4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    28a6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    28a8:	6505                	lui	a0,0x1
    28aa:	00003097          	auipc	ra,0x3
    28ae:	a26080e7          	jalr	-1498(ra) # 52d0 <sbrk>
        if(a == 0xffffffffffffffffLL)
    28b2:	01350763          	beq	a0,s3,28c0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    28b6:	6785                	lui	a5,0x1
    28b8:	953e                	add	a0,a0,a5
    28ba:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x95>
      while(1){
    28be:	b7ed                	j	28a8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    28c0:	01205a63          	blez	s2,28d4 <execout+0x88>
        sbrk(-4096);
    28c4:	757d                	lui	a0,0xfffff
    28c6:	00003097          	auipc	ra,0x3
    28ca:	a0a080e7          	jalr	-1526(ra) # 52d0 <sbrk>
      for(int i = 0; i < avail; i++)
    28ce:	2485                	addiw	s1,s1,1
    28d0:	ff249ae3          	bne	s1,s2,28c4 <execout+0x78>
      close(1);
    28d4:	4505                	li	a0,1
    28d6:	00003097          	auipc	ra,0x3
    28da:	99a080e7          	jalr	-1638(ra) # 5270 <close>
      char *args[] = { "echo", "x", 0 };
    28de:	00003517          	auipc	a0,0x3
    28e2:	1ca50513          	addi	a0,a0,458 # 5aa8 <malloc+0x422>
    28e6:	faa43c23          	sd	a0,-72(s0)
    28ea:	00003797          	auipc	a5,0x3
    28ee:	22e78793          	addi	a5,a5,558 # 5b18 <malloc+0x492>
    28f2:	fcf43023          	sd	a5,-64(s0)
    28f6:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    28fa:	fb840593          	addi	a1,s0,-72
    28fe:	00003097          	auipc	ra,0x3
    2902:	982080e7          	jalr	-1662(ra) # 5280 <exec>
      exit(0);
    2906:	4501                	li	a0,0
    2908:	00003097          	auipc	ra,0x3
    290c:	940080e7          	jalr	-1728(ra) # 5248 <exit>

0000000000002910 <fourteen>:
{
    2910:	1101                	addi	sp,sp,-32
    2912:	ec06                	sd	ra,24(sp)
    2914:	e822                	sd	s0,16(sp)
    2916:	e426                	sd	s1,8(sp)
    2918:	1000                	addi	s0,sp,32
    291a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    291c:	00004517          	auipc	a0,0x4
    2920:	1e450513          	addi	a0,a0,484 # 6b00 <malloc+0x147a>
    2924:	00003097          	auipc	ra,0x3
    2928:	98c080e7          	jalr	-1652(ra) # 52b0 <mkdir>
    292c:	e165                	bnez	a0,2a0c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    292e:	00004517          	auipc	a0,0x4
    2932:	02a50513          	addi	a0,a0,42 # 6958 <malloc+0x12d2>
    2936:	00003097          	auipc	ra,0x3
    293a:	97a080e7          	jalr	-1670(ra) # 52b0 <mkdir>
    293e:	e56d                	bnez	a0,2a28 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2940:	20000593          	li	a1,512
    2944:	00004517          	auipc	a0,0x4
    2948:	06c50513          	addi	a0,a0,108 # 69b0 <malloc+0x132a>
    294c:	00003097          	auipc	ra,0x3
    2950:	93c080e7          	jalr	-1732(ra) # 5288 <open>
  if(fd < 0){
    2954:	0e054863          	bltz	a0,2a44 <fourteen+0x134>
  close(fd);
    2958:	00003097          	auipc	ra,0x3
    295c:	918080e7          	jalr	-1768(ra) # 5270 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2960:	4581                	li	a1,0
    2962:	00004517          	auipc	a0,0x4
    2966:	0c650513          	addi	a0,a0,198 # 6a28 <malloc+0x13a2>
    296a:	00003097          	auipc	ra,0x3
    296e:	91e080e7          	jalr	-1762(ra) # 5288 <open>
  if(fd < 0){
    2972:	0e054763          	bltz	a0,2a60 <fourteen+0x150>
  close(fd);
    2976:	00003097          	auipc	ra,0x3
    297a:	8fa080e7          	jalr	-1798(ra) # 5270 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    297e:	00004517          	auipc	a0,0x4
    2982:	11a50513          	addi	a0,a0,282 # 6a98 <malloc+0x1412>
    2986:	00003097          	auipc	ra,0x3
    298a:	92a080e7          	jalr	-1750(ra) # 52b0 <mkdir>
    298e:	c57d                	beqz	a0,2a7c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2990:	00004517          	auipc	a0,0x4
    2994:	16050513          	addi	a0,a0,352 # 6af0 <malloc+0x146a>
    2998:	00003097          	auipc	ra,0x3
    299c:	918080e7          	jalr	-1768(ra) # 52b0 <mkdir>
    29a0:	cd65                	beqz	a0,2a98 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    29a2:	00004517          	auipc	a0,0x4
    29a6:	14e50513          	addi	a0,a0,334 # 6af0 <malloc+0x146a>
    29aa:	00003097          	auipc	ra,0x3
    29ae:	8ee080e7          	jalr	-1810(ra) # 5298 <unlink>
  unlink("12345678901234/12345678901234");
    29b2:	00004517          	auipc	a0,0x4
    29b6:	0e650513          	addi	a0,a0,230 # 6a98 <malloc+0x1412>
    29ba:	00003097          	auipc	ra,0x3
    29be:	8de080e7          	jalr	-1826(ra) # 5298 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    29c2:	00004517          	auipc	a0,0x4
    29c6:	06650513          	addi	a0,a0,102 # 6a28 <malloc+0x13a2>
    29ca:	00003097          	auipc	ra,0x3
    29ce:	8ce080e7          	jalr	-1842(ra) # 5298 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    29d2:	00004517          	auipc	a0,0x4
    29d6:	fde50513          	addi	a0,a0,-34 # 69b0 <malloc+0x132a>
    29da:	00003097          	auipc	ra,0x3
    29de:	8be080e7          	jalr	-1858(ra) # 5298 <unlink>
  unlink("12345678901234/123456789012345");
    29e2:	00004517          	auipc	a0,0x4
    29e6:	f7650513          	addi	a0,a0,-138 # 6958 <malloc+0x12d2>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	8ae080e7          	jalr	-1874(ra) # 5298 <unlink>
  unlink("12345678901234");
    29f2:	00004517          	auipc	a0,0x4
    29f6:	10e50513          	addi	a0,a0,270 # 6b00 <malloc+0x147a>
    29fa:	00003097          	auipc	ra,0x3
    29fe:	89e080e7          	jalr	-1890(ra) # 5298 <unlink>
}
    2a02:	60e2                	ld	ra,24(sp)
    2a04:	6442                	ld	s0,16(sp)
    2a06:	64a2                	ld	s1,8(sp)
    2a08:	6105                	addi	sp,sp,32
    2a0a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2a0c:	85a6                	mv	a1,s1
    2a0e:	00004517          	auipc	a0,0x4
    2a12:	f2250513          	addi	a0,a0,-222 # 6930 <malloc+0x12aa>
    2a16:	00003097          	auipc	ra,0x3
    2a1a:	bb2080e7          	jalr	-1102(ra) # 55c8 <printf>
    exit(1);
    2a1e:	4505                	li	a0,1
    2a20:	00003097          	auipc	ra,0x3
    2a24:	828080e7          	jalr	-2008(ra) # 5248 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2a28:	85a6                	mv	a1,s1
    2a2a:	00004517          	auipc	a0,0x4
    2a2e:	f4e50513          	addi	a0,a0,-178 # 6978 <malloc+0x12f2>
    2a32:	00003097          	auipc	ra,0x3
    2a36:	b96080e7          	jalr	-1130(ra) # 55c8 <printf>
    exit(1);
    2a3a:	4505                	li	a0,1
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	80c080e7          	jalr	-2036(ra) # 5248 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2a44:	85a6                	mv	a1,s1
    2a46:	00004517          	auipc	a0,0x4
    2a4a:	f9a50513          	addi	a0,a0,-102 # 69e0 <malloc+0x135a>
    2a4e:	00003097          	auipc	ra,0x3
    2a52:	b7a080e7          	jalr	-1158(ra) # 55c8 <printf>
    exit(1);
    2a56:	4505                	li	a0,1
    2a58:	00002097          	auipc	ra,0x2
    2a5c:	7f0080e7          	jalr	2032(ra) # 5248 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2a60:	85a6                	mv	a1,s1
    2a62:	00004517          	auipc	a0,0x4
    2a66:	ff650513          	addi	a0,a0,-10 # 6a58 <malloc+0x13d2>
    2a6a:	00003097          	auipc	ra,0x3
    2a6e:	b5e080e7          	jalr	-1186(ra) # 55c8 <printf>
    exit(1);
    2a72:	4505                	li	a0,1
    2a74:	00002097          	auipc	ra,0x2
    2a78:	7d4080e7          	jalr	2004(ra) # 5248 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2a7c:	85a6                	mv	a1,s1
    2a7e:	00004517          	auipc	a0,0x4
    2a82:	03a50513          	addi	a0,a0,58 # 6ab8 <malloc+0x1432>
    2a86:	00003097          	auipc	ra,0x3
    2a8a:	b42080e7          	jalr	-1214(ra) # 55c8 <printf>
    exit(1);
    2a8e:	4505                	li	a0,1
    2a90:	00002097          	auipc	ra,0x2
    2a94:	7b8080e7          	jalr	1976(ra) # 5248 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2a98:	85a6                	mv	a1,s1
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	07650513          	addi	a0,a0,118 # 6b10 <malloc+0x148a>
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	b26080e7          	jalr	-1242(ra) # 55c8 <printf>
    exit(1);
    2aaa:	4505                	li	a0,1
    2aac:	00002097          	auipc	ra,0x2
    2ab0:	79c080e7          	jalr	1948(ra) # 5248 <exit>

0000000000002ab4 <iputtest>:
{
    2ab4:	1101                	addi	sp,sp,-32
    2ab6:	ec06                	sd	ra,24(sp)
    2ab8:	e822                	sd	s0,16(sp)
    2aba:	e426                	sd	s1,8(sp)
    2abc:	1000                	addi	s0,sp,32
    2abe:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2ac0:	00004517          	auipc	a0,0x4
    2ac4:	08850513          	addi	a0,a0,136 # 6b48 <malloc+0x14c2>
    2ac8:	00002097          	auipc	ra,0x2
    2acc:	7e8080e7          	jalr	2024(ra) # 52b0 <mkdir>
    2ad0:	04054563          	bltz	a0,2b1a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2ad4:	00004517          	auipc	a0,0x4
    2ad8:	07450513          	addi	a0,a0,116 # 6b48 <malloc+0x14c2>
    2adc:	00002097          	auipc	ra,0x2
    2ae0:	7dc080e7          	jalr	2012(ra) # 52b8 <chdir>
    2ae4:	04054963          	bltz	a0,2b36 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2ae8:	00004517          	auipc	a0,0x4
    2aec:	0a050513          	addi	a0,a0,160 # 6b88 <malloc+0x1502>
    2af0:	00002097          	auipc	ra,0x2
    2af4:	7a8080e7          	jalr	1960(ra) # 5298 <unlink>
    2af8:	04054d63          	bltz	a0,2b52 <iputtest+0x9e>
  if(chdir("/") < 0){
    2afc:	00004517          	auipc	a0,0x4
    2b00:	0bc50513          	addi	a0,a0,188 # 6bb8 <malloc+0x1532>
    2b04:	00002097          	auipc	ra,0x2
    2b08:	7b4080e7          	jalr	1972(ra) # 52b8 <chdir>
    2b0c:	06054163          	bltz	a0,2b6e <iputtest+0xba>
}
    2b10:	60e2                	ld	ra,24(sp)
    2b12:	6442                	ld	s0,16(sp)
    2b14:	64a2                	ld	s1,8(sp)
    2b16:	6105                	addi	sp,sp,32
    2b18:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b1a:	85a6                	mv	a1,s1
    2b1c:	00004517          	auipc	a0,0x4
    2b20:	03450513          	addi	a0,a0,52 # 6b50 <malloc+0x14ca>
    2b24:	00003097          	auipc	ra,0x3
    2b28:	aa4080e7          	jalr	-1372(ra) # 55c8 <printf>
    exit(1);
    2b2c:	4505                	li	a0,1
    2b2e:	00002097          	auipc	ra,0x2
    2b32:	71a080e7          	jalr	1818(ra) # 5248 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b36:	85a6                	mv	a1,s1
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	03050513          	addi	a0,a0,48 # 6b68 <malloc+0x14e2>
    2b40:	00003097          	auipc	ra,0x3
    2b44:	a88080e7          	jalr	-1400(ra) # 55c8 <printf>
    exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	00002097          	auipc	ra,0x2
    2b4e:	6fe080e7          	jalr	1790(ra) # 5248 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2b52:	85a6                	mv	a1,s1
    2b54:	00004517          	auipc	a0,0x4
    2b58:	04450513          	addi	a0,a0,68 # 6b98 <malloc+0x1512>
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	a6c080e7          	jalr	-1428(ra) # 55c8 <printf>
    exit(1);
    2b64:	4505                	li	a0,1
    2b66:	00002097          	auipc	ra,0x2
    2b6a:	6e2080e7          	jalr	1762(ra) # 5248 <exit>
    printf("%s: chdir / failed\n", s);
    2b6e:	85a6                	mv	a1,s1
    2b70:	00004517          	auipc	a0,0x4
    2b74:	05050513          	addi	a0,a0,80 # 6bc0 <malloc+0x153a>
    2b78:	00003097          	auipc	ra,0x3
    2b7c:	a50080e7          	jalr	-1456(ra) # 55c8 <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	00002097          	auipc	ra,0x2
    2b86:	6c6080e7          	jalr	1734(ra) # 5248 <exit>

0000000000002b8a <exitiputtest>:
{
    2b8a:	7179                	addi	sp,sp,-48
    2b8c:	f406                	sd	ra,40(sp)
    2b8e:	f022                	sd	s0,32(sp)
    2b90:	ec26                	sd	s1,24(sp)
    2b92:	1800                	addi	s0,sp,48
    2b94:	84aa                	mv	s1,a0
  pid = fork();
    2b96:	00002097          	auipc	ra,0x2
    2b9a:	6aa080e7          	jalr	1706(ra) # 5240 <fork>
  if(pid < 0){
    2b9e:	04054663          	bltz	a0,2bea <exitiputtest+0x60>
  if(pid == 0){
    2ba2:	ed45                	bnez	a0,2c5a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	fa450513          	addi	a0,a0,-92 # 6b48 <malloc+0x14c2>
    2bac:	00002097          	auipc	ra,0x2
    2bb0:	704080e7          	jalr	1796(ra) # 52b0 <mkdir>
    2bb4:	04054963          	bltz	a0,2c06 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	f9050513          	addi	a0,a0,-112 # 6b48 <malloc+0x14c2>
    2bc0:	00002097          	auipc	ra,0x2
    2bc4:	6f8080e7          	jalr	1784(ra) # 52b8 <chdir>
    2bc8:	04054d63          	bltz	a0,2c22 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2bcc:	00004517          	auipc	a0,0x4
    2bd0:	fbc50513          	addi	a0,a0,-68 # 6b88 <malloc+0x1502>
    2bd4:	00002097          	auipc	ra,0x2
    2bd8:	6c4080e7          	jalr	1732(ra) # 5298 <unlink>
    2bdc:	06054163          	bltz	a0,2c3e <exitiputtest+0xb4>
    exit(0);
    2be0:	4501                	li	a0,0
    2be2:	00002097          	auipc	ra,0x2
    2be6:	666080e7          	jalr	1638(ra) # 5248 <exit>
    printf("%s: fork failed\n", s);
    2bea:	85a6                	mv	a1,s1
    2bec:	00003517          	auipc	a0,0x3
    2bf0:	6f450513          	addi	a0,a0,1780 # 62e0 <malloc+0xc5a>
    2bf4:	00003097          	auipc	ra,0x3
    2bf8:	9d4080e7          	jalr	-1580(ra) # 55c8 <printf>
    exit(1);
    2bfc:	4505                	li	a0,1
    2bfe:	00002097          	auipc	ra,0x2
    2c02:	64a080e7          	jalr	1610(ra) # 5248 <exit>
      printf("%s: mkdir failed\n", s);
    2c06:	85a6                	mv	a1,s1
    2c08:	00004517          	auipc	a0,0x4
    2c0c:	f4850513          	addi	a0,a0,-184 # 6b50 <malloc+0x14ca>
    2c10:	00003097          	auipc	ra,0x3
    2c14:	9b8080e7          	jalr	-1608(ra) # 55c8 <printf>
      exit(1);
    2c18:	4505                	li	a0,1
    2c1a:	00002097          	auipc	ra,0x2
    2c1e:	62e080e7          	jalr	1582(ra) # 5248 <exit>
      printf("%s: child chdir failed\n", s);
    2c22:	85a6                	mv	a1,s1
    2c24:	00004517          	auipc	a0,0x4
    2c28:	fb450513          	addi	a0,a0,-76 # 6bd8 <malloc+0x1552>
    2c2c:	00003097          	auipc	ra,0x3
    2c30:	99c080e7          	jalr	-1636(ra) # 55c8 <printf>
      exit(1);
    2c34:	4505                	li	a0,1
    2c36:	00002097          	auipc	ra,0x2
    2c3a:	612080e7          	jalr	1554(ra) # 5248 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c3e:	85a6                	mv	a1,s1
    2c40:	00004517          	auipc	a0,0x4
    2c44:	f5850513          	addi	a0,a0,-168 # 6b98 <malloc+0x1512>
    2c48:	00003097          	auipc	ra,0x3
    2c4c:	980080e7          	jalr	-1664(ra) # 55c8 <printf>
      exit(1);
    2c50:	4505                	li	a0,1
    2c52:	00002097          	auipc	ra,0x2
    2c56:	5f6080e7          	jalr	1526(ra) # 5248 <exit>
  wait(&xstatus);
    2c5a:	fdc40513          	addi	a0,s0,-36
    2c5e:	00002097          	auipc	ra,0x2
    2c62:	5f2080e7          	jalr	1522(ra) # 5250 <wait>
  exit(xstatus);
    2c66:	fdc42503          	lw	a0,-36(s0)
    2c6a:	00002097          	auipc	ra,0x2
    2c6e:	5de080e7          	jalr	1502(ra) # 5248 <exit>

0000000000002c72 <subdir>:
{
    2c72:	1101                	addi	sp,sp,-32
    2c74:	ec06                	sd	ra,24(sp)
    2c76:	e822                	sd	s0,16(sp)
    2c78:	e426                	sd	s1,8(sp)
    2c7a:	e04a                	sd	s2,0(sp)
    2c7c:	1000                	addi	s0,sp,32
    2c7e:	892a                	mv	s2,a0
  unlink("ff");
    2c80:	00004517          	auipc	a0,0x4
    2c84:	0a050513          	addi	a0,a0,160 # 6d20 <malloc+0x169a>
    2c88:	00002097          	auipc	ra,0x2
    2c8c:	610080e7          	jalr	1552(ra) # 5298 <unlink>
  if(mkdir("dd") != 0){
    2c90:	00004517          	auipc	a0,0x4
    2c94:	f6050513          	addi	a0,a0,-160 # 6bf0 <malloc+0x156a>
    2c98:	00002097          	auipc	ra,0x2
    2c9c:	618080e7          	jalr	1560(ra) # 52b0 <mkdir>
    2ca0:	38051663          	bnez	a0,302c <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2ca4:	20200593          	li	a1,514
    2ca8:	00004517          	auipc	a0,0x4
    2cac:	f6850513          	addi	a0,a0,-152 # 6c10 <malloc+0x158a>
    2cb0:	00002097          	auipc	ra,0x2
    2cb4:	5d8080e7          	jalr	1496(ra) # 5288 <open>
    2cb8:	84aa                	mv	s1,a0
  if(fd < 0){
    2cba:	38054763          	bltz	a0,3048 <subdir+0x3d6>
  write(fd, "ff", 2);
    2cbe:	4609                	li	a2,2
    2cc0:	00004597          	auipc	a1,0x4
    2cc4:	06058593          	addi	a1,a1,96 # 6d20 <malloc+0x169a>
    2cc8:	00002097          	auipc	ra,0x2
    2ccc:	5a0080e7          	jalr	1440(ra) # 5268 <write>
  close(fd);
    2cd0:	8526                	mv	a0,s1
    2cd2:	00002097          	auipc	ra,0x2
    2cd6:	59e080e7          	jalr	1438(ra) # 5270 <close>
  if(unlink("dd") >= 0){
    2cda:	00004517          	auipc	a0,0x4
    2cde:	f1650513          	addi	a0,a0,-234 # 6bf0 <malloc+0x156a>
    2ce2:	00002097          	auipc	ra,0x2
    2ce6:	5b6080e7          	jalr	1462(ra) # 5298 <unlink>
    2cea:	36055d63          	bgez	a0,3064 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2cee:	00004517          	auipc	a0,0x4
    2cf2:	f7a50513          	addi	a0,a0,-134 # 6c68 <malloc+0x15e2>
    2cf6:	00002097          	auipc	ra,0x2
    2cfa:	5ba080e7          	jalr	1466(ra) # 52b0 <mkdir>
    2cfe:	38051163          	bnez	a0,3080 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d02:	20200593          	li	a1,514
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	f8a50513          	addi	a0,a0,-118 # 6c90 <malloc+0x160a>
    2d0e:	00002097          	auipc	ra,0x2
    2d12:	57a080e7          	jalr	1402(ra) # 5288 <open>
    2d16:	84aa                	mv	s1,a0
  if(fd < 0){
    2d18:	38054263          	bltz	a0,309c <subdir+0x42a>
  write(fd, "FF", 2);
    2d1c:	4609                	li	a2,2
    2d1e:	00004597          	auipc	a1,0x4
    2d22:	fa258593          	addi	a1,a1,-94 # 6cc0 <malloc+0x163a>
    2d26:	00002097          	auipc	ra,0x2
    2d2a:	542080e7          	jalr	1346(ra) # 5268 <write>
  close(fd);
    2d2e:	8526                	mv	a0,s1
    2d30:	00002097          	auipc	ra,0x2
    2d34:	540080e7          	jalr	1344(ra) # 5270 <close>
  fd = open("dd/dd/../ff", 0);
    2d38:	4581                	li	a1,0
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	f8e50513          	addi	a0,a0,-114 # 6cc8 <malloc+0x1642>
    2d42:	00002097          	auipc	ra,0x2
    2d46:	546080e7          	jalr	1350(ra) # 5288 <open>
    2d4a:	84aa                	mv	s1,a0
  if(fd < 0){
    2d4c:	36054663          	bltz	a0,30b8 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2d50:	660d                	lui	a2,0x3
    2d52:	00008597          	auipc	a1,0x8
    2d56:	7f658593          	addi	a1,a1,2038 # b548 <buf>
    2d5a:	00002097          	auipc	ra,0x2
    2d5e:	506080e7          	jalr	1286(ra) # 5260 <read>
  if(cc != 2 || buf[0] != 'f'){
    2d62:	4789                	li	a5,2
    2d64:	36f51863          	bne	a0,a5,30d4 <subdir+0x462>
    2d68:	00008717          	auipc	a4,0x8
    2d6c:	7e074703          	lbu	a4,2016(a4) # b548 <buf>
    2d70:	06600793          	li	a5,102
    2d74:	36f71063          	bne	a4,a5,30d4 <subdir+0x462>
  close(fd);
    2d78:	8526                	mv	a0,s1
    2d7a:	00002097          	auipc	ra,0x2
    2d7e:	4f6080e7          	jalr	1270(ra) # 5270 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2d82:	00004597          	auipc	a1,0x4
    2d86:	f9658593          	addi	a1,a1,-106 # 6d18 <malloc+0x1692>
    2d8a:	00004517          	auipc	a0,0x4
    2d8e:	f0650513          	addi	a0,a0,-250 # 6c90 <malloc+0x160a>
    2d92:	00002097          	auipc	ra,0x2
    2d96:	516080e7          	jalr	1302(ra) # 52a8 <link>
    2d9a:	34051b63          	bnez	a0,30f0 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2d9e:	00004517          	auipc	a0,0x4
    2da2:	ef250513          	addi	a0,a0,-270 # 6c90 <malloc+0x160a>
    2da6:	00002097          	auipc	ra,0x2
    2daa:	4f2080e7          	jalr	1266(ra) # 5298 <unlink>
    2dae:	34051f63          	bnez	a0,310c <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2db2:	4581                	li	a1,0
    2db4:	00004517          	auipc	a0,0x4
    2db8:	edc50513          	addi	a0,a0,-292 # 6c90 <malloc+0x160a>
    2dbc:	00002097          	auipc	ra,0x2
    2dc0:	4cc080e7          	jalr	1228(ra) # 5288 <open>
    2dc4:	36055263          	bgez	a0,3128 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2dc8:	00004517          	auipc	a0,0x4
    2dcc:	e2850513          	addi	a0,a0,-472 # 6bf0 <malloc+0x156a>
    2dd0:	00002097          	auipc	ra,0x2
    2dd4:	4e8080e7          	jalr	1256(ra) # 52b8 <chdir>
    2dd8:	36051663          	bnez	a0,3144 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	fd450513          	addi	a0,a0,-44 # 6db0 <malloc+0x172a>
    2de4:	00002097          	auipc	ra,0x2
    2de8:	4d4080e7          	jalr	1236(ra) # 52b8 <chdir>
    2dec:	36051a63          	bnez	a0,3160 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2df0:	00004517          	auipc	a0,0x4
    2df4:	ff050513          	addi	a0,a0,-16 # 6de0 <malloc+0x175a>
    2df8:	00002097          	auipc	ra,0x2
    2dfc:	4c0080e7          	jalr	1216(ra) # 52b8 <chdir>
    2e00:	36051e63          	bnez	a0,317c <subdir+0x50a>
  if(chdir("./..") != 0){
    2e04:	00004517          	auipc	a0,0x4
    2e08:	00c50513          	addi	a0,a0,12 # 6e10 <malloc+0x178a>
    2e0c:	00002097          	auipc	ra,0x2
    2e10:	4ac080e7          	jalr	1196(ra) # 52b8 <chdir>
    2e14:	38051263          	bnez	a0,3198 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2e18:	4581                	li	a1,0
    2e1a:	00004517          	auipc	a0,0x4
    2e1e:	efe50513          	addi	a0,a0,-258 # 6d18 <malloc+0x1692>
    2e22:	00002097          	auipc	ra,0x2
    2e26:	466080e7          	jalr	1126(ra) # 5288 <open>
    2e2a:	84aa                	mv	s1,a0
  if(fd < 0){
    2e2c:	38054463          	bltz	a0,31b4 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e30:	660d                	lui	a2,0x3
    2e32:	00008597          	auipc	a1,0x8
    2e36:	71658593          	addi	a1,a1,1814 # b548 <buf>
    2e3a:	00002097          	auipc	ra,0x2
    2e3e:	426080e7          	jalr	1062(ra) # 5260 <read>
    2e42:	4789                	li	a5,2
    2e44:	38f51663          	bne	a0,a5,31d0 <subdir+0x55e>
  close(fd);
    2e48:	8526                	mv	a0,s1
    2e4a:	00002097          	auipc	ra,0x2
    2e4e:	426080e7          	jalr	1062(ra) # 5270 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e52:	4581                	li	a1,0
    2e54:	00004517          	auipc	a0,0x4
    2e58:	e3c50513          	addi	a0,a0,-452 # 6c90 <malloc+0x160a>
    2e5c:	00002097          	auipc	ra,0x2
    2e60:	42c080e7          	jalr	1068(ra) # 5288 <open>
    2e64:	38055463          	bgez	a0,31ec <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2e68:	20200593          	li	a1,514
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	03450513          	addi	a0,a0,52 # 6ea0 <malloc+0x181a>
    2e74:	00002097          	auipc	ra,0x2
    2e78:	414080e7          	jalr	1044(ra) # 5288 <open>
    2e7c:	38055663          	bgez	a0,3208 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2e80:	20200593          	li	a1,514
    2e84:	00004517          	auipc	a0,0x4
    2e88:	04c50513          	addi	a0,a0,76 # 6ed0 <malloc+0x184a>
    2e8c:	00002097          	auipc	ra,0x2
    2e90:	3fc080e7          	jalr	1020(ra) # 5288 <open>
    2e94:	38055863          	bgez	a0,3224 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2e98:	20000593          	li	a1,512
    2e9c:	00004517          	auipc	a0,0x4
    2ea0:	d5450513          	addi	a0,a0,-684 # 6bf0 <malloc+0x156a>
    2ea4:	00002097          	auipc	ra,0x2
    2ea8:	3e4080e7          	jalr	996(ra) # 5288 <open>
    2eac:	38055a63          	bgez	a0,3240 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2eb0:	4589                	li	a1,2
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	d3e50513          	addi	a0,a0,-706 # 6bf0 <malloc+0x156a>
    2eba:	00002097          	auipc	ra,0x2
    2ebe:	3ce080e7          	jalr	974(ra) # 5288 <open>
    2ec2:	38055d63          	bgez	a0,325c <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2ec6:	4585                	li	a1,1
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	d2850513          	addi	a0,a0,-728 # 6bf0 <malloc+0x156a>
    2ed0:	00002097          	auipc	ra,0x2
    2ed4:	3b8080e7          	jalr	952(ra) # 5288 <open>
    2ed8:	3a055063          	bgez	a0,3278 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2edc:	00004597          	auipc	a1,0x4
    2ee0:	08458593          	addi	a1,a1,132 # 6f60 <malloc+0x18da>
    2ee4:	00004517          	auipc	a0,0x4
    2ee8:	fbc50513          	addi	a0,a0,-68 # 6ea0 <malloc+0x181a>
    2eec:	00002097          	auipc	ra,0x2
    2ef0:	3bc080e7          	jalr	956(ra) # 52a8 <link>
    2ef4:	3a050063          	beqz	a0,3294 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2ef8:	00004597          	auipc	a1,0x4
    2efc:	06858593          	addi	a1,a1,104 # 6f60 <malloc+0x18da>
    2f00:	00004517          	auipc	a0,0x4
    2f04:	fd050513          	addi	a0,a0,-48 # 6ed0 <malloc+0x184a>
    2f08:	00002097          	auipc	ra,0x2
    2f0c:	3a0080e7          	jalr	928(ra) # 52a8 <link>
    2f10:	3a050063          	beqz	a0,32b0 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f14:	00004597          	auipc	a1,0x4
    2f18:	e0458593          	addi	a1,a1,-508 # 6d18 <malloc+0x1692>
    2f1c:	00004517          	auipc	a0,0x4
    2f20:	cf450513          	addi	a0,a0,-780 # 6c10 <malloc+0x158a>
    2f24:	00002097          	auipc	ra,0x2
    2f28:	384080e7          	jalr	900(ra) # 52a8 <link>
    2f2c:	3a050063          	beqz	a0,32cc <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2f30:	00004517          	auipc	a0,0x4
    2f34:	f7050513          	addi	a0,a0,-144 # 6ea0 <malloc+0x181a>
    2f38:	00002097          	auipc	ra,0x2
    2f3c:	378080e7          	jalr	888(ra) # 52b0 <mkdir>
    2f40:	3a050463          	beqz	a0,32e8 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2f44:	00004517          	auipc	a0,0x4
    2f48:	f8c50513          	addi	a0,a0,-116 # 6ed0 <malloc+0x184a>
    2f4c:	00002097          	auipc	ra,0x2
    2f50:	364080e7          	jalr	868(ra) # 52b0 <mkdir>
    2f54:	3a050863          	beqz	a0,3304 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2f58:	00004517          	auipc	a0,0x4
    2f5c:	dc050513          	addi	a0,a0,-576 # 6d18 <malloc+0x1692>
    2f60:	00002097          	auipc	ra,0x2
    2f64:	350080e7          	jalr	848(ra) # 52b0 <mkdir>
    2f68:	3a050c63          	beqz	a0,3320 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2f6c:	00004517          	auipc	a0,0x4
    2f70:	f6450513          	addi	a0,a0,-156 # 6ed0 <malloc+0x184a>
    2f74:	00002097          	auipc	ra,0x2
    2f78:	324080e7          	jalr	804(ra) # 5298 <unlink>
    2f7c:	3c050063          	beqz	a0,333c <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2f80:	00004517          	auipc	a0,0x4
    2f84:	f2050513          	addi	a0,a0,-224 # 6ea0 <malloc+0x181a>
    2f88:	00002097          	auipc	ra,0x2
    2f8c:	310080e7          	jalr	784(ra) # 5298 <unlink>
    2f90:	3c050463          	beqz	a0,3358 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2f94:	00004517          	auipc	a0,0x4
    2f98:	c7c50513          	addi	a0,a0,-900 # 6c10 <malloc+0x158a>
    2f9c:	00002097          	auipc	ra,0x2
    2fa0:	31c080e7          	jalr	796(ra) # 52b8 <chdir>
    2fa4:	3c050863          	beqz	a0,3374 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    2fa8:	00004517          	auipc	a0,0x4
    2fac:	10850513          	addi	a0,a0,264 # 70b0 <malloc+0x1a2a>
    2fb0:	00002097          	auipc	ra,0x2
    2fb4:	308080e7          	jalr	776(ra) # 52b8 <chdir>
    2fb8:	3c050c63          	beqz	a0,3390 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    2fbc:	00004517          	auipc	a0,0x4
    2fc0:	d5c50513          	addi	a0,a0,-676 # 6d18 <malloc+0x1692>
    2fc4:	00002097          	auipc	ra,0x2
    2fc8:	2d4080e7          	jalr	724(ra) # 5298 <unlink>
    2fcc:	3e051063          	bnez	a0,33ac <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    2fd0:	00004517          	auipc	a0,0x4
    2fd4:	c4050513          	addi	a0,a0,-960 # 6c10 <malloc+0x158a>
    2fd8:	00002097          	auipc	ra,0x2
    2fdc:	2c0080e7          	jalr	704(ra) # 5298 <unlink>
    2fe0:	3e051463          	bnez	a0,33c8 <subdir+0x756>
  if(unlink("dd") == 0){
    2fe4:	00004517          	auipc	a0,0x4
    2fe8:	c0c50513          	addi	a0,a0,-1012 # 6bf0 <malloc+0x156a>
    2fec:	00002097          	auipc	ra,0x2
    2ff0:	2ac080e7          	jalr	684(ra) # 5298 <unlink>
    2ff4:	3e050863          	beqz	a0,33e4 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    2ff8:	00004517          	auipc	a0,0x4
    2ffc:	12850513          	addi	a0,a0,296 # 7120 <malloc+0x1a9a>
    3000:	00002097          	auipc	ra,0x2
    3004:	298080e7          	jalr	664(ra) # 5298 <unlink>
    3008:	3e054c63          	bltz	a0,3400 <subdir+0x78e>
  if(unlink("dd") < 0){
    300c:	00004517          	auipc	a0,0x4
    3010:	be450513          	addi	a0,a0,-1052 # 6bf0 <malloc+0x156a>
    3014:	00002097          	auipc	ra,0x2
    3018:	284080e7          	jalr	644(ra) # 5298 <unlink>
    301c:	40054063          	bltz	a0,341c <subdir+0x7aa>
}
    3020:	60e2                	ld	ra,24(sp)
    3022:	6442                	ld	s0,16(sp)
    3024:	64a2                	ld	s1,8(sp)
    3026:	6902                	ld	s2,0(sp)
    3028:	6105                	addi	sp,sp,32
    302a:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    302c:	85ca                	mv	a1,s2
    302e:	00004517          	auipc	a0,0x4
    3032:	bca50513          	addi	a0,a0,-1078 # 6bf8 <malloc+0x1572>
    3036:	00002097          	auipc	ra,0x2
    303a:	592080e7          	jalr	1426(ra) # 55c8 <printf>
    exit(1);
    303e:	4505                	li	a0,1
    3040:	00002097          	auipc	ra,0x2
    3044:	208080e7          	jalr	520(ra) # 5248 <exit>
    printf("%s: create dd/ff failed\n", s);
    3048:	85ca                	mv	a1,s2
    304a:	00004517          	auipc	a0,0x4
    304e:	bce50513          	addi	a0,a0,-1074 # 6c18 <malloc+0x1592>
    3052:	00002097          	auipc	ra,0x2
    3056:	576080e7          	jalr	1398(ra) # 55c8 <printf>
    exit(1);
    305a:	4505                	li	a0,1
    305c:	00002097          	auipc	ra,0x2
    3060:	1ec080e7          	jalr	492(ra) # 5248 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3064:	85ca                	mv	a1,s2
    3066:	00004517          	auipc	a0,0x4
    306a:	bd250513          	addi	a0,a0,-1070 # 6c38 <malloc+0x15b2>
    306e:	00002097          	auipc	ra,0x2
    3072:	55a080e7          	jalr	1370(ra) # 55c8 <printf>
    exit(1);
    3076:	4505                	li	a0,1
    3078:	00002097          	auipc	ra,0x2
    307c:	1d0080e7          	jalr	464(ra) # 5248 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3080:	85ca                	mv	a1,s2
    3082:	00004517          	auipc	a0,0x4
    3086:	bee50513          	addi	a0,a0,-1042 # 6c70 <malloc+0x15ea>
    308a:	00002097          	auipc	ra,0x2
    308e:	53e080e7          	jalr	1342(ra) # 55c8 <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	00002097          	auipc	ra,0x2
    3098:	1b4080e7          	jalr	436(ra) # 5248 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    309c:	85ca                	mv	a1,s2
    309e:	00004517          	auipc	a0,0x4
    30a2:	c0250513          	addi	a0,a0,-1022 # 6ca0 <malloc+0x161a>
    30a6:	00002097          	auipc	ra,0x2
    30aa:	522080e7          	jalr	1314(ra) # 55c8 <printf>
    exit(1);
    30ae:	4505                	li	a0,1
    30b0:	00002097          	auipc	ra,0x2
    30b4:	198080e7          	jalr	408(ra) # 5248 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    30b8:	85ca                	mv	a1,s2
    30ba:	00004517          	auipc	a0,0x4
    30be:	c1e50513          	addi	a0,a0,-994 # 6cd8 <malloc+0x1652>
    30c2:	00002097          	auipc	ra,0x2
    30c6:	506080e7          	jalr	1286(ra) # 55c8 <printf>
    exit(1);
    30ca:	4505                	li	a0,1
    30cc:	00002097          	auipc	ra,0x2
    30d0:	17c080e7          	jalr	380(ra) # 5248 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00004517          	auipc	a0,0x4
    30da:	c2250513          	addi	a0,a0,-990 # 6cf8 <malloc+0x1672>
    30de:	00002097          	auipc	ra,0x2
    30e2:	4ea080e7          	jalr	1258(ra) # 55c8 <printf>
    exit(1);
    30e6:	4505                	li	a0,1
    30e8:	00002097          	auipc	ra,0x2
    30ec:	160080e7          	jalr	352(ra) # 5248 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    30f0:	85ca                	mv	a1,s2
    30f2:	00004517          	auipc	a0,0x4
    30f6:	c3650513          	addi	a0,a0,-970 # 6d28 <malloc+0x16a2>
    30fa:	00002097          	auipc	ra,0x2
    30fe:	4ce080e7          	jalr	1230(ra) # 55c8 <printf>
    exit(1);
    3102:	4505                	li	a0,1
    3104:	00002097          	auipc	ra,0x2
    3108:	144080e7          	jalr	324(ra) # 5248 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    310c:	85ca                	mv	a1,s2
    310e:	00004517          	auipc	a0,0x4
    3112:	c4250513          	addi	a0,a0,-958 # 6d50 <malloc+0x16ca>
    3116:	00002097          	auipc	ra,0x2
    311a:	4b2080e7          	jalr	1202(ra) # 55c8 <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	00002097          	auipc	ra,0x2
    3124:	128080e7          	jalr	296(ra) # 5248 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3128:	85ca                	mv	a1,s2
    312a:	00004517          	auipc	a0,0x4
    312e:	c4650513          	addi	a0,a0,-954 # 6d70 <malloc+0x16ea>
    3132:	00002097          	auipc	ra,0x2
    3136:	496080e7          	jalr	1174(ra) # 55c8 <printf>
    exit(1);
    313a:	4505                	li	a0,1
    313c:	00002097          	auipc	ra,0x2
    3140:	10c080e7          	jalr	268(ra) # 5248 <exit>
    printf("%s: chdir dd failed\n", s);
    3144:	85ca                	mv	a1,s2
    3146:	00004517          	auipc	a0,0x4
    314a:	c5250513          	addi	a0,a0,-942 # 6d98 <malloc+0x1712>
    314e:	00002097          	auipc	ra,0x2
    3152:	47a080e7          	jalr	1146(ra) # 55c8 <printf>
    exit(1);
    3156:	4505                	li	a0,1
    3158:	00002097          	auipc	ra,0x2
    315c:	0f0080e7          	jalr	240(ra) # 5248 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00004517          	auipc	a0,0x4
    3166:	c5e50513          	addi	a0,a0,-930 # 6dc0 <malloc+0x173a>
    316a:	00002097          	auipc	ra,0x2
    316e:	45e080e7          	jalr	1118(ra) # 55c8 <printf>
    exit(1);
    3172:	4505                	li	a0,1
    3174:	00002097          	auipc	ra,0x2
    3178:	0d4080e7          	jalr	212(ra) # 5248 <exit>
    printf("chdir dd/../../dd failed\n", s);
    317c:	85ca                	mv	a1,s2
    317e:	00004517          	auipc	a0,0x4
    3182:	c7250513          	addi	a0,a0,-910 # 6df0 <malloc+0x176a>
    3186:	00002097          	auipc	ra,0x2
    318a:	442080e7          	jalr	1090(ra) # 55c8 <printf>
    exit(1);
    318e:	4505                	li	a0,1
    3190:	00002097          	auipc	ra,0x2
    3194:	0b8080e7          	jalr	184(ra) # 5248 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3198:	85ca                	mv	a1,s2
    319a:	00004517          	auipc	a0,0x4
    319e:	c7e50513          	addi	a0,a0,-898 # 6e18 <malloc+0x1792>
    31a2:	00002097          	auipc	ra,0x2
    31a6:	426080e7          	jalr	1062(ra) # 55c8 <printf>
    exit(1);
    31aa:	4505                	li	a0,1
    31ac:	00002097          	auipc	ra,0x2
    31b0:	09c080e7          	jalr	156(ra) # 5248 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    31b4:	85ca                	mv	a1,s2
    31b6:	00004517          	auipc	a0,0x4
    31ba:	c7a50513          	addi	a0,a0,-902 # 6e30 <malloc+0x17aa>
    31be:	00002097          	auipc	ra,0x2
    31c2:	40a080e7          	jalr	1034(ra) # 55c8 <printf>
    exit(1);
    31c6:	4505                	li	a0,1
    31c8:	00002097          	auipc	ra,0x2
    31cc:	080080e7          	jalr	128(ra) # 5248 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    31d0:	85ca                	mv	a1,s2
    31d2:	00004517          	auipc	a0,0x4
    31d6:	c7e50513          	addi	a0,a0,-898 # 6e50 <malloc+0x17ca>
    31da:	00002097          	auipc	ra,0x2
    31de:	3ee080e7          	jalr	1006(ra) # 55c8 <printf>
    exit(1);
    31e2:	4505                	li	a0,1
    31e4:	00002097          	auipc	ra,0x2
    31e8:	064080e7          	jalr	100(ra) # 5248 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    31ec:	85ca                	mv	a1,s2
    31ee:	00004517          	auipc	a0,0x4
    31f2:	c8250513          	addi	a0,a0,-894 # 6e70 <malloc+0x17ea>
    31f6:	00002097          	auipc	ra,0x2
    31fa:	3d2080e7          	jalr	978(ra) # 55c8 <printf>
    exit(1);
    31fe:	4505                	li	a0,1
    3200:	00002097          	auipc	ra,0x2
    3204:	048080e7          	jalr	72(ra) # 5248 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3208:	85ca                	mv	a1,s2
    320a:	00004517          	auipc	a0,0x4
    320e:	ca650513          	addi	a0,a0,-858 # 6eb0 <malloc+0x182a>
    3212:	00002097          	auipc	ra,0x2
    3216:	3b6080e7          	jalr	950(ra) # 55c8 <printf>
    exit(1);
    321a:	4505                	li	a0,1
    321c:	00002097          	auipc	ra,0x2
    3220:	02c080e7          	jalr	44(ra) # 5248 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3224:	85ca                	mv	a1,s2
    3226:	00004517          	auipc	a0,0x4
    322a:	cba50513          	addi	a0,a0,-838 # 6ee0 <malloc+0x185a>
    322e:	00002097          	auipc	ra,0x2
    3232:	39a080e7          	jalr	922(ra) # 55c8 <printf>
    exit(1);
    3236:	4505                	li	a0,1
    3238:	00002097          	auipc	ra,0x2
    323c:	010080e7          	jalr	16(ra) # 5248 <exit>
    printf("%s: create dd succeeded!\n", s);
    3240:	85ca                	mv	a1,s2
    3242:	00004517          	auipc	a0,0x4
    3246:	cbe50513          	addi	a0,a0,-834 # 6f00 <malloc+0x187a>
    324a:	00002097          	auipc	ra,0x2
    324e:	37e080e7          	jalr	894(ra) # 55c8 <printf>
    exit(1);
    3252:	4505                	li	a0,1
    3254:	00002097          	auipc	ra,0x2
    3258:	ff4080e7          	jalr	-12(ra) # 5248 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    325c:	85ca                	mv	a1,s2
    325e:	00004517          	auipc	a0,0x4
    3262:	cc250513          	addi	a0,a0,-830 # 6f20 <malloc+0x189a>
    3266:	00002097          	auipc	ra,0x2
    326a:	362080e7          	jalr	866(ra) # 55c8 <printf>
    exit(1);
    326e:	4505                	li	a0,1
    3270:	00002097          	auipc	ra,0x2
    3274:	fd8080e7          	jalr	-40(ra) # 5248 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3278:	85ca                	mv	a1,s2
    327a:	00004517          	auipc	a0,0x4
    327e:	cc650513          	addi	a0,a0,-826 # 6f40 <malloc+0x18ba>
    3282:	00002097          	auipc	ra,0x2
    3286:	346080e7          	jalr	838(ra) # 55c8 <printf>
    exit(1);
    328a:	4505                	li	a0,1
    328c:	00002097          	auipc	ra,0x2
    3290:	fbc080e7          	jalr	-68(ra) # 5248 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3294:	85ca                	mv	a1,s2
    3296:	00004517          	auipc	a0,0x4
    329a:	cda50513          	addi	a0,a0,-806 # 6f70 <malloc+0x18ea>
    329e:	00002097          	auipc	ra,0x2
    32a2:	32a080e7          	jalr	810(ra) # 55c8 <printf>
    exit(1);
    32a6:	4505                	li	a0,1
    32a8:	00002097          	auipc	ra,0x2
    32ac:	fa0080e7          	jalr	-96(ra) # 5248 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    32b0:	85ca                	mv	a1,s2
    32b2:	00004517          	auipc	a0,0x4
    32b6:	ce650513          	addi	a0,a0,-794 # 6f98 <malloc+0x1912>
    32ba:	00002097          	auipc	ra,0x2
    32be:	30e080e7          	jalr	782(ra) # 55c8 <printf>
    exit(1);
    32c2:	4505                	li	a0,1
    32c4:	00002097          	auipc	ra,0x2
    32c8:	f84080e7          	jalr	-124(ra) # 5248 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    32cc:	85ca                	mv	a1,s2
    32ce:	00004517          	auipc	a0,0x4
    32d2:	cf250513          	addi	a0,a0,-782 # 6fc0 <malloc+0x193a>
    32d6:	00002097          	auipc	ra,0x2
    32da:	2f2080e7          	jalr	754(ra) # 55c8 <printf>
    exit(1);
    32de:	4505                	li	a0,1
    32e0:	00002097          	auipc	ra,0x2
    32e4:	f68080e7          	jalr	-152(ra) # 5248 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    32e8:	85ca                	mv	a1,s2
    32ea:	00004517          	auipc	a0,0x4
    32ee:	cfe50513          	addi	a0,a0,-770 # 6fe8 <malloc+0x1962>
    32f2:	00002097          	auipc	ra,0x2
    32f6:	2d6080e7          	jalr	726(ra) # 55c8 <printf>
    exit(1);
    32fa:	4505                	li	a0,1
    32fc:	00002097          	auipc	ra,0x2
    3300:	f4c080e7          	jalr	-180(ra) # 5248 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3304:	85ca                	mv	a1,s2
    3306:	00004517          	auipc	a0,0x4
    330a:	d0250513          	addi	a0,a0,-766 # 7008 <malloc+0x1982>
    330e:	00002097          	auipc	ra,0x2
    3312:	2ba080e7          	jalr	698(ra) # 55c8 <printf>
    exit(1);
    3316:	4505                	li	a0,1
    3318:	00002097          	auipc	ra,0x2
    331c:	f30080e7          	jalr	-208(ra) # 5248 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3320:	85ca                	mv	a1,s2
    3322:	00004517          	auipc	a0,0x4
    3326:	d0650513          	addi	a0,a0,-762 # 7028 <malloc+0x19a2>
    332a:	00002097          	auipc	ra,0x2
    332e:	29e080e7          	jalr	670(ra) # 55c8 <printf>
    exit(1);
    3332:	4505                	li	a0,1
    3334:	00002097          	auipc	ra,0x2
    3338:	f14080e7          	jalr	-236(ra) # 5248 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    333c:	85ca                	mv	a1,s2
    333e:	00004517          	auipc	a0,0x4
    3342:	d1250513          	addi	a0,a0,-750 # 7050 <malloc+0x19ca>
    3346:	00002097          	auipc	ra,0x2
    334a:	282080e7          	jalr	642(ra) # 55c8 <printf>
    exit(1);
    334e:	4505                	li	a0,1
    3350:	00002097          	auipc	ra,0x2
    3354:	ef8080e7          	jalr	-264(ra) # 5248 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3358:	85ca                	mv	a1,s2
    335a:	00004517          	auipc	a0,0x4
    335e:	d1650513          	addi	a0,a0,-746 # 7070 <malloc+0x19ea>
    3362:	00002097          	auipc	ra,0x2
    3366:	266080e7          	jalr	614(ra) # 55c8 <printf>
    exit(1);
    336a:	4505                	li	a0,1
    336c:	00002097          	auipc	ra,0x2
    3370:	edc080e7          	jalr	-292(ra) # 5248 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3374:	85ca                	mv	a1,s2
    3376:	00004517          	auipc	a0,0x4
    337a:	d1a50513          	addi	a0,a0,-742 # 7090 <malloc+0x1a0a>
    337e:	00002097          	auipc	ra,0x2
    3382:	24a080e7          	jalr	586(ra) # 55c8 <printf>
    exit(1);
    3386:	4505                	li	a0,1
    3388:	00002097          	auipc	ra,0x2
    338c:	ec0080e7          	jalr	-320(ra) # 5248 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3390:	85ca                	mv	a1,s2
    3392:	00004517          	auipc	a0,0x4
    3396:	d2650513          	addi	a0,a0,-730 # 70b8 <malloc+0x1a32>
    339a:	00002097          	auipc	ra,0x2
    339e:	22e080e7          	jalr	558(ra) # 55c8 <printf>
    exit(1);
    33a2:	4505                	li	a0,1
    33a4:	00002097          	auipc	ra,0x2
    33a8:	ea4080e7          	jalr	-348(ra) # 5248 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    33ac:	85ca                	mv	a1,s2
    33ae:	00004517          	auipc	a0,0x4
    33b2:	9a250513          	addi	a0,a0,-1630 # 6d50 <malloc+0x16ca>
    33b6:	00002097          	auipc	ra,0x2
    33ba:	212080e7          	jalr	530(ra) # 55c8 <printf>
    exit(1);
    33be:	4505                	li	a0,1
    33c0:	00002097          	auipc	ra,0x2
    33c4:	e88080e7          	jalr	-376(ra) # 5248 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    33c8:	85ca                	mv	a1,s2
    33ca:	00004517          	auipc	a0,0x4
    33ce:	d0e50513          	addi	a0,a0,-754 # 70d8 <malloc+0x1a52>
    33d2:	00002097          	auipc	ra,0x2
    33d6:	1f6080e7          	jalr	502(ra) # 55c8 <printf>
    exit(1);
    33da:	4505                	li	a0,1
    33dc:	00002097          	auipc	ra,0x2
    33e0:	e6c080e7          	jalr	-404(ra) # 5248 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    33e4:	85ca                	mv	a1,s2
    33e6:	00004517          	auipc	a0,0x4
    33ea:	d1250513          	addi	a0,a0,-750 # 70f8 <malloc+0x1a72>
    33ee:	00002097          	auipc	ra,0x2
    33f2:	1da080e7          	jalr	474(ra) # 55c8 <printf>
    exit(1);
    33f6:	4505                	li	a0,1
    33f8:	00002097          	auipc	ra,0x2
    33fc:	e50080e7          	jalr	-432(ra) # 5248 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3400:	85ca                	mv	a1,s2
    3402:	00004517          	auipc	a0,0x4
    3406:	d2650513          	addi	a0,a0,-730 # 7128 <malloc+0x1aa2>
    340a:	00002097          	auipc	ra,0x2
    340e:	1be080e7          	jalr	446(ra) # 55c8 <printf>
    exit(1);
    3412:	4505                	li	a0,1
    3414:	00002097          	auipc	ra,0x2
    3418:	e34080e7          	jalr	-460(ra) # 5248 <exit>
    printf("%s: unlink dd failed\n", s);
    341c:	85ca                	mv	a1,s2
    341e:	00004517          	auipc	a0,0x4
    3422:	d2a50513          	addi	a0,a0,-726 # 7148 <malloc+0x1ac2>
    3426:	00002097          	auipc	ra,0x2
    342a:	1a2080e7          	jalr	418(ra) # 55c8 <printf>
    exit(1);
    342e:	4505                	li	a0,1
    3430:	00002097          	auipc	ra,0x2
    3434:	e18080e7          	jalr	-488(ra) # 5248 <exit>

0000000000003438 <rmdot>:
{
    3438:	1101                	addi	sp,sp,-32
    343a:	ec06                	sd	ra,24(sp)
    343c:	e822                	sd	s0,16(sp)
    343e:	e426                	sd	s1,8(sp)
    3440:	1000                	addi	s0,sp,32
    3442:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3444:	00004517          	auipc	a0,0x4
    3448:	d1c50513          	addi	a0,a0,-740 # 7160 <malloc+0x1ada>
    344c:	00002097          	auipc	ra,0x2
    3450:	e64080e7          	jalr	-412(ra) # 52b0 <mkdir>
    3454:	e549                	bnez	a0,34de <rmdot+0xa6>
  if(chdir("dots") != 0){
    3456:	00004517          	auipc	a0,0x4
    345a:	d0a50513          	addi	a0,a0,-758 # 7160 <malloc+0x1ada>
    345e:	00002097          	auipc	ra,0x2
    3462:	e5a080e7          	jalr	-422(ra) # 52b8 <chdir>
    3466:	e951                	bnez	a0,34fa <rmdot+0xc2>
  if(unlink(".") == 0){
    3468:	00003517          	auipc	a0,0x3
    346c:	cd850513          	addi	a0,a0,-808 # 6140 <malloc+0xaba>
    3470:	00002097          	auipc	ra,0x2
    3474:	e28080e7          	jalr	-472(ra) # 5298 <unlink>
    3478:	cd59                	beqz	a0,3516 <rmdot+0xde>
  if(unlink("..") == 0){
    347a:	00004517          	auipc	a0,0x4
    347e:	d3650513          	addi	a0,a0,-714 # 71b0 <malloc+0x1b2a>
    3482:	00002097          	auipc	ra,0x2
    3486:	e16080e7          	jalr	-490(ra) # 5298 <unlink>
    348a:	c545                	beqz	a0,3532 <rmdot+0xfa>
  if(chdir("/") != 0){
    348c:	00003517          	auipc	a0,0x3
    3490:	72c50513          	addi	a0,a0,1836 # 6bb8 <malloc+0x1532>
    3494:	00002097          	auipc	ra,0x2
    3498:	e24080e7          	jalr	-476(ra) # 52b8 <chdir>
    349c:	e94d                	bnez	a0,354e <rmdot+0x116>
  if(unlink("dots/.") == 0){
    349e:	00004517          	auipc	a0,0x4
    34a2:	d3250513          	addi	a0,a0,-718 # 71d0 <malloc+0x1b4a>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	df2080e7          	jalr	-526(ra) # 5298 <unlink>
    34ae:	cd55                	beqz	a0,356a <rmdot+0x132>
  if(unlink("dots/..") == 0){
    34b0:	00004517          	auipc	a0,0x4
    34b4:	d4850513          	addi	a0,a0,-696 # 71f8 <malloc+0x1b72>
    34b8:	00002097          	auipc	ra,0x2
    34bc:	de0080e7          	jalr	-544(ra) # 5298 <unlink>
    34c0:	c179                	beqz	a0,3586 <rmdot+0x14e>
  if(unlink("dots") != 0){
    34c2:	00004517          	auipc	a0,0x4
    34c6:	c9e50513          	addi	a0,a0,-866 # 7160 <malloc+0x1ada>
    34ca:	00002097          	auipc	ra,0x2
    34ce:	dce080e7          	jalr	-562(ra) # 5298 <unlink>
    34d2:	e961                	bnez	a0,35a2 <rmdot+0x16a>
}
    34d4:	60e2                	ld	ra,24(sp)
    34d6:	6442                	ld	s0,16(sp)
    34d8:	64a2                	ld	s1,8(sp)
    34da:	6105                	addi	sp,sp,32
    34dc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    34de:	85a6                	mv	a1,s1
    34e0:	00004517          	auipc	a0,0x4
    34e4:	c8850513          	addi	a0,a0,-888 # 7168 <malloc+0x1ae2>
    34e8:	00002097          	auipc	ra,0x2
    34ec:	0e0080e7          	jalr	224(ra) # 55c8 <printf>
    exit(1);
    34f0:	4505                	li	a0,1
    34f2:	00002097          	auipc	ra,0x2
    34f6:	d56080e7          	jalr	-682(ra) # 5248 <exit>
    printf("%s: chdir dots failed\n", s);
    34fa:	85a6                	mv	a1,s1
    34fc:	00004517          	auipc	a0,0x4
    3500:	c8450513          	addi	a0,a0,-892 # 7180 <malloc+0x1afa>
    3504:	00002097          	auipc	ra,0x2
    3508:	0c4080e7          	jalr	196(ra) # 55c8 <printf>
    exit(1);
    350c:	4505                	li	a0,1
    350e:	00002097          	auipc	ra,0x2
    3512:	d3a080e7          	jalr	-710(ra) # 5248 <exit>
    printf("%s: rm . worked!\n", s);
    3516:	85a6                	mv	a1,s1
    3518:	00004517          	auipc	a0,0x4
    351c:	c8050513          	addi	a0,a0,-896 # 7198 <malloc+0x1b12>
    3520:	00002097          	auipc	ra,0x2
    3524:	0a8080e7          	jalr	168(ra) # 55c8 <printf>
    exit(1);
    3528:	4505                	li	a0,1
    352a:	00002097          	auipc	ra,0x2
    352e:	d1e080e7          	jalr	-738(ra) # 5248 <exit>
    printf("%s: rm .. worked!\n", s);
    3532:	85a6                	mv	a1,s1
    3534:	00004517          	auipc	a0,0x4
    3538:	c8450513          	addi	a0,a0,-892 # 71b8 <malloc+0x1b32>
    353c:	00002097          	auipc	ra,0x2
    3540:	08c080e7          	jalr	140(ra) # 55c8 <printf>
    exit(1);
    3544:	4505                	li	a0,1
    3546:	00002097          	auipc	ra,0x2
    354a:	d02080e7          	jalr	-766(ra) # 5248 <exit>
    printf("%s: chdir / failed\n", s);
    354e:	85a6                	mv	a1,s1
    3550:	00003517          	auipc	a0,0x3
    3554:	67050513          	addi	a0,a0,1648 # 6bc0 <malloc+0x153a>
    3558:	00002097          	auipc	ra,0x2
    355c:	070080e7          	jalr	112(ra) # 55c8 <printf>
    exit(1);
    3560:	4505                	li	a0,1
    3562:	00002097          	auipc	ra,0x2
    3566:	ce6080e7          	jalr	-794(ra) # 5248 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    356a:	85a6                	mv	a1,s1
    356c:	00004517          	auipc	a0,0x4
    3570:	c6c50513          	addi	a0,a0,-916 # 71d8 <malloc+0x1b52>
    3574:	00002097          	auipc	ra,0x2
    3578:	054080e7          	jalr	84(ra) # 55c8 <printf>
    exit(1);
    357c:	4505                	li	a0,1
    357e:	00002097          	auipc	ra,0x2
    3582:	cca080e7          	jalr	-822(ra) # 5248 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3586:	85a6                	mv	a1,s1
    3588:	00004517          	auipc	a0,0x4
    358c:	c7850513          	addi	a0,a0,-904 # 7200 <malloc+0x1b7a>
    3590:	00002097          	auipc	ra,0x2
    3594:	038080e7          	jalr	56(ra) # 55c8 <printf>
    exit(1);
    3598:	4505                	li	a0,1
    359a:	00002097          	auipc	ra,0x2
    359e:	cae080e7          	jalr	-850(ra) # 5248 <exit>
    printf("%s: unlink dots failed!\n", s);
    35a2:	85a6                	mv	a1,s1
    35a4:	00004517          	auipc	a0,0x4
    35a8:	c7c50513          	addi	a0,a0,-900 # 7220 <malloc+0x1b9a>
    35ac:	00002097          	auipc	ra,0x2
    35b0:	01c080e7          	jalr	28(ra) # 55c8 <printf>
    exit(1);
    35b4:	4505                	li	a0,1
    35b6:	00002097          	auipc	ra,0x2
    35ba:	c92080e7          	jalr	-878(ra) # 5248 <exit>

00000000000035be <dirfile>:
{
    35be:	1101                	addi	sp,sp,-32
    35c0:	ec06                	sd	ra,24(sp)
    35c2:	e822                	sd	s0,16(sp)
    35c4:	e426                	sd	s1,8(sp)
    35c6:	e04a                	sd	s2,0(sp)
    35c8:	1000                	addi	s0,sp,32
    35ca:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    35cc:	20000593          	li	a1,512
    35d0:	00002517          	auipc	a0,0x2
    35d4:	47850513          	addi	a0,a0,1144 # 5a48 <malloc+0x3c2>
    35d8:	00002097          	auipc	ra,0x2
    35dc:	cb0080e7          	jalr	-848(ra) # 5288 <open>
  if(fd < 0){
    35e0:	0e054d63          	bltz	a0,36da <dirfile+0x11c>
  close(fd);
    35e4:	00002097          	auipc	ra,0x2
    35e8:	c8c080e7          	jalr	-884(ra) # 5270 <close>
  if(chdir("dirfile") == 0){
    35ec:	00002517          	auipc	a0,0x2
    35f0:	45c50513          	addi	a0,a0,1116 # 5a48 <malloc+0x3c2>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	cc4080e7          	jalr	-828(ra) # 52b8 <chdir>
    35fc:	cd6d                	beqz	a0,36f6 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    35fe:	4581                	li	a1,0
    3600:	00004517          	auipc	a0,0x4
    3604:	c8050513          	addi	a0,a0,-896 # 7280 <malloc+0x1bfa>
    3608:	00002097          	auipc	ra,0x2
    360c:	c80080e7          	jalr	-896(ra) # 5288 <open>
  if(fd >= 0){
    3610:	10055163          	bgez	a0,3712 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3614:	20000593          	li	a1,512
    3618:	00004517          	auipc	a0,0x4
    361c:	c6850513          	addi	a0,a0,-920 # 7280 <malloc+0x1bfa>
    3620:	00002097          	auipc	ra,0x2
    3624:	c68080e7          	jalr	-920(ra) # 5288 <open>
  if(fd >= 0){
    3628:	10055363          	bgez	a0,372e <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    362c:	00004517          	auipc	a0,0x4
    3630:	c5450513          	addi	a0,a0,-940 # 7280 <malloc+0x1bfa>
    3634:	00002097          	auipc	ra,0x2
    3638:	c7c080e7          	jalr	-900(ra) # 52b0 <mkdir>
    363c:	10050763          	beqz	a0,374a <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3640:	00004517          	auipc	a0,0x4
    3644:	c4050513          	addi	a0,a0,-960 # 7280 <malloc+0x1bfa>
    3648:	00002097          	auipc	ra,0x2
    364c:	c50080e7          	jalr	-944(ra) # 5298 <unlink>
    3650:	10050b63          	beqz	a0,3766 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3654:	00004597          	auipc	a1,0x4
    3658:	c2c58593          	addi	a1,a1,-980 # 7280 <malloc+0x1bfa>
    365c:	00002517          	auipc	a0,0x2
    3660:	5e450513          	addi	a0,a0,1508 # 5c40 <malloc+0x5ba>
    3664:	00002097          	auipc	ra,0x2
    3668:	c44080e7          	jalr	-956(ra) # 52a8 <link>
    366c:	10050b63          	beqz	a0,3782 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3670:	00002517          	auipc	a0,0x2
    3674:	3d850513          	addi	a0,a0,984 # 5a48 <malloc+0x3c2>
    3678:	00002097          	auipc	ra,0x2
    367c:	c20080e7          	jalr	-992(ra) # 5298 <unlink>
    3680:	10051f63          	bnez	a0,379e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3684:	4589                	li	a1,2
    3686:	00003517          	auipc	a0,0x3
    368a:	aba50513          	addi	a0,a0,-1350 # 6140 <malloc+0xaba>
    368e:	00002097          	auipc	ra,0x2
    3692:	bfa080e7          	jalr	-1030(ra) # 5288 <open>
  if(fd >= 0){
    3696:	12055263          	bgez	a0,37ba <dirfile+0x1fc>
  fd = open(".", 0);
    369a:	4581                	li	a1,0
    369c:	00003517          	auipc	a0,0x3
    36a0:	aa450513          	addi	a0,a0,-1372 # 6140 <malloc+0xaba>
    36a4:	00002097          	auipc	ra,0x2
    36a8:	be4080e7          	jalr	-1052(ra) # 5288 <open>
    36ac:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    36ae:	4605                	li	a2,1
    36b0:	00002597          	auipc	a1,0x2
    36b4:	46858593          	addi	a1,a1,1128 # 5b18 <malloc+0x492>
    36b8:	00002097          	auipc	ra,0x2
    36bc:	bb0080e7          	jalr	-1104(ra) # 5268 <write>
    36c0:	10a04b63          	bgtz	a0,37d6 <dirfile+0x218>
  close(fd);
    36c4:	8526                	mv	a0,s1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	baa080e7          	jalr	-1110(ra) # 5270 <close>
}
    36ce:	60e2                	ld	ra,24(sp)
    36d0:	6442                	ld	s0,16(sp)
    36d2:	64a2                	ld	s1,8(sp)
    36d4:	6902                	ld	s2,0(sp)
    36d6:	6105                	addi	sp,sp,32
    36d8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    36da:	85ca                	mv	a1,s2
    36dc:	00004517          	auipc	a0,0x4
    36e0:	b6450513          	addi	a0,a0,-1180 # 7240 <malloc+0x1bba>
    36e4:	00002097          	auipc	ra,0x2
    36e8:	ee4080e7          	jalr	-284(ra) # 55c8 <printf>
    exit(1);
    36ec:	4505                	li	a0,1
    36ee:	00002097          	auipc	ra,0x2
    36f2:	b5a080e7          	jalr	-1190(ra) # 5248 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    36f6:	85ca                	mv	a1,s2
    36f8:	00004517          	auipc	a0,0x4
    36fc:	b6850513          	addi	a0,a0,-1176 # 7260 <malloc+0x1bda>
    3700:	00002097          	auipc	ra,0x2
    3704:	ec8080e7          	jalr	-312(ra) # 55c8 <printf>
    exit(1);
    3708:	4505                	li	a0,1
    370a:	00002097          	auipc	ra,0x2
    370e:	b3e080e7          	jalr	-1218(ra) # 5248 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3712:	85ca                	mv	a1,s2
    3714:	00004517          	auipc	a0,0x4
    3718:	b7c50513          	addi	a0,a0,-1156 # 7290 <malloc+0x1c0a>
    371c:	00002097          	auipc	ra,0x2
    3720:	eac080e7          	jalr	-340(ra) # 55c8 <printf>
    exit(1);
    3724:	4505                	li	a0,1
    3726:	00002097          	auipc	ra,0x2
    372a:	b22080e7          	jalr	-1246(ra) # 5248 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    372e:	85ca                	mv	a1,s2
    3730:	00004517          	auipc	a0,0x4
    3734:	b6050513          	addi	a0,a0,-1184 # 7290 <malloc+0x1c0a>
    3738:	00002097          	auipc	ra,0x2
    373c:	e90080e7          	jalr	-368(ra) # 55c8 <printf>
    exit(1);
    3740:	4505                	li	a0,1
    3742:	00002097          	auipc	ra,0x2
    3746:	b06080e7          	jalr	-1274(ra) # 5248 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    374a:	85ca                	mv	a1,s2
    374c:	00004517          	auipc	a0,0x4
    3750:	b6c50513          	addi	a0,a0,-1172 # 72b8 <malloc+0x1c32>
    3754:	00002097          	auipc	ra,0x2
    3758:	e74080e7          	jalr	-396(ra) # 55c8 <printf>
    exit(1);
    375c:	4505                	li	a0,1
    375e:	00002097          	auipc	ra,0x2
    3762:	aea080e7          	jalr	-1302(ra) # 5248 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3766:	85ca                	mv	a1,s2
    3768:	00004517          	auipc	a0,0x4
    376c:	b7850513          	addi	a0,a0,-1160 # 72e0 <malloc+0x1c5a>
    3770:	00002097          	auipc	ra,0x2
    3774:	e58080e7          	jalr	-424(ra) # 55c8 <printf>
    exit(1);
    3778:	4505                	li	a0,1
    377a:	00002097          	auipc	ra,0x2
    377e:	ace080e7          	jalr	-1330(ra) # 5248 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3782:	85ca                	mv	a1,s2
    3784:	00004517          	auipc	a0,0x4
    3788:	b8450513          	addi	a0,a0,-1148 # 7308 <malloc+0x1c82>
    378c:	00002097          	auipc	ra,0x2
    3790:	e3c080e7          	jalr	-452(ra) # 55c8 <printf>
    exit(1);
    3794:	4505                	li	a0,1
    3796:	00002097          	auipc	ra,0x2
    379a:	ab2080e7          	jalr	-1358(ra) # 5248 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    379e:	85ca                	mv	a1,s2
    37a0:	00004517          	auipc	a0,0x4
    37a4:	b9050513          	addi	a0,a0,-1136 # 7330 <malloc+0x1caa>
    37a8:	00002097          	auipc	ra,0x2
    37ac:	e20080e7          	jalr	-480(ra) # 55c8 <printf>
    exit(1);
    37b0:	4505                	li	a0,1
    37b2:	00002097          	auipc	ra,0x2
    37b6:	a96080e7          	jalr	-1386(ra) # 5248 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    37ba:	85ca                	mv	a1,s2
    37bc:	00004517          	auipc	a0,0x4
    37c0:	b9450513          	addi	a0,a0,-1132 # 7350 <malloc+0x1cca>
    37c4:	00002097          	auipc	ra,0x2
    37c8:	e04080e7          	jalr	-508(ra) # 55c8 <printf>
    exit(1);
    37cc:	4505                	li	a0,1
    37ce:	00002097          	auipc	ra,0x2
    37d2:	a7a080e7          	jalr	-1414(ra) # 5248 <exit>
    printf("%s: write . succeeded!\n", s);
    37d6:	85ca                	mv	a1,s2
    37d8:	00004517          	auipc	a0,0x4
    37dc:	ba050513          	addi	a0,a0,-1120 # 7378 <malloc+0x1cf2>
    37e0:	00002097          	auipc	ra,0x2
    37e4:	de8080e7          	jalr	-536(ra) # 55c8 <printf>
    exit(1);
    37e8:	4505                	li	a0,1
    37ea:	00002097          	auipc	ra,0x2
    37ee:	a5e080e7          	jalr	-1442(ra) # 5248 <exit>

00000000000037f2 <iref>:
{
    37f2:	7139                	addi	sp,sp,-64
    37f4:	fc06                	sd	ra,56(sp)
    37f6:	f822                	sd	s0,48(sp)
    37f8:	f426                	sd	s1,40(sp)
    37fa:	f04a                	sd	s2,32(sp)
    37fc:	ec4e                	sd	s3,24(sp)
    37fe:	e852                	sd	s4,16(sp)
    3800:	e456                	sd	s5,8(sp)
    3802:	e05a                	sd	s6,0(sp)
    3804:	0080                	addi	s0,sp,64
    3806:	8b2a                	mv	s6,a0
    3808:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    380c:	00004a17          	auipc	s4,0x4
    3810:	b84a0a13          	addi	s4,s4,-1148 # 7390 <malloc+0x1d0a>
    mkdir("");
    3814:	00003497          	auipc	s1,0x3
    3818:	68448493          	addi	s1,s1,1668 # 6e98 <malloc+0x1812>
    link("README", "");
    381c:	00002a97          	auipc	s5,0x2
    3820:	424a8a93          	addi	s5,s5,1060 # 5c40 <malloc+0x5ba>
    fd = open("xx", O_CREATE);
    3824:	00004997          	auipc	s3,0x4
    3828:	a6498993          	addi	s3,s3,-1436 # 7288 <malloc+0x1c02>
    382c:	a891                	j	3880 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    382e:	85da                	mv	a1,s6
    3830:	00004517          	auipc	a0,0x4
    3834:	b6850513          	addi	a0,a0,-1176 # 7398 <malloc+0x1d12>
    3838:	00002097          	auipc	ra,0x2
    383c:	d90080e7          	jalr	-624(ra) # 55c8 <printf>
      exit(1);
    3840:	4505                	li	a0,1
    3842:	00002097          	auipc	ra,0x2
    3846:	a06080e7          	jalr	-1530(ra) # 5248 <exit>
      printf("%s: chdir irefd failed\n", s);
    384a:	85da                	mv	a1,s6
    384c:	00004517          	auipc	a0,0x4
    3850:	b6450513          	addi	a0,a0,-1180 # 73b0 <malloc+0x1d2a>
    3854:	00002097          	auipc	ra,0x2
    3858:	d74080e7          	jalr	-652(ra) # 55c8 <printf>
      exit(1);
    385c:	4505                	li	a0,1
    385e:	00002097          	auipc	ra,0x2
    3862:	9ea080e7          	jalr	-1558(ra) # 5248 <exit>
      close(fd);
    3866:	00002097          	auipc	ra,0x2
    386a:	a0a080e7          	jalr	-1526(ra) # 5270 <close>
    386e:	a889                	j	38c0 <iref+0xce>
    unlink("xx");
    3870:	854e                	mv	a0,s3
    3872:	00002097          	auipc	ra,0x2
    3876:	a26080e7          	jalr	-1498(ra) # 5298 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    387a:	397d                	addiw	s2,s2,-1
    387c:	06090063          	beqz	s2,38dc <iref+0xea>
    if(mkdir("irefd") != 0){
    3880:	8552                	mv	a0,s4
    3882:	00002097          	auipc	ra,0x2
    3886:	a2e080e7          	jalr	-1490(ra) # 52b0 <mkdir>
    388a:	f155                	bnez	a0,382e <iref+0x3c>
    if(chdir("irefd") != 0){
    388c:	8552                	mv	a0,s4
    388e:	00002097          	auipc	ra,0x2
    3892:	a2a080e7          	jalr	-1494(ra) # 52b8 <chdir>
    3896:	f955                	bnez	a0,384a <iref+0x58>
    mkdir("");
    3898:	8526                	mv	a0,s1
    389a:	00002097          	auipc	ra,0x2
    389e:	a16080e7          	jalr	-1514(ra) # 52b0 <mkdir>
    link("README", "");
    38a2:	85a6                	mv	a1,s1
    38a4:	8556                	mv	a0,s5
    38a6:	00002097          	auipc	ra,0x2
    38aa:	a02080e7          	jalr	-1534(ra) # 52a8 <link>
    fd = open("", O_CREATE);
    38ae:	20000593          	li	a1,512
    38b2:	8526                	mv	a0,s1
    38b4:	00002097          	auipc	ra,0x2
    38b8:	9d4080e7          	jalr	-1580(ra) # 5288 <open>
    if(fd >= 0)
    38bc:	fa0555e3          	bgez	a0,3866 <iref+0x74>
    fd = open("xx", O_CREATE);
    38c0:	20000593          	li	a1,512
    38c4:	854e                	mv	a0,s3
    38c6:	00002097          	auipc	ra,0x2
    38ca:	9c2080e7          	jalr	-1598(ra) # 5288 <open>
    if(fd >= 0)
    38ce:	fa0541e3          	bltz	a0,3870 <iref+0x7e>
      close(fd);
    38d2:	00002097          	auipc	ra,0x2
    38d6:	99e080e7          	jalr	-1634(ra) # 5270 <close>
    38da:	bf59                	j	3870 <iref+0x7e>
    38dc:	03300493          	li	s1,51
    chdir("..");
    38e0:	00004997          	auipc	s3,0x4
    38e4:	8d098993          	addi	s3,s3,-1840 # 71b0 <malloc+0x1b2a>
    unlink("irefd");
    38e8:	00004917          	auipc	s2,0x4
    38ec:	aa890913          	addi	s2,s2,-1368 # 7390 <malloc+0x1d0a>
    chdir("..");
    38f0:	854e                	mv	a0,s3
    38f2:	00002097          	auipc	ra,0x2
    38f6:	9c6080e7          	jalr	-1594(ra) # 52b8 <chdir>
    unlink("irefd");
    38fa:	854a                	mv	a0,s2
    38fc:	00002097          	auipc	ra,0x2
    3900:	99c080e7          	jalr	-1636(ra) # 5298 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3904:	34fd                	addiw	s1,s1,-1
    3906:	f4ed                	bnez	s1,38f0 <iref+0xfe>
  chdir("/");
    3908:	00003517          	auipc	a0,0x3
    390c:	2b050513          	addi	a0,a0,688 # 6bb8 <malloc+0x1532>
    3910:	00002097          	auipc	ra,0x2
    3914:	9a8080e7          	jalr	-1624(ra) # 52b8 <chdir>
}
    3918:	70e2                	ld	ra,56(sp)
    391a:	7442                	ld	s0,48(sp)
    391c:	74a2                	ld	s1,40(sp)
    391e:	7902                	ld	s2,32(sp)
    3920:	69e2                	ld	s3,24(sp)
    3922:	6a42                	ld	s4,16(sp)
    3924:	6aa2                	ld	s5,8(sp)
    3926:	6b02                	ld	s6,0(sp)
    3928:	6121                	addi	sp,sp,64
    392a:	8082                	ret

000000000000392c <openiputtest>:
{
    392c:	7179                	addi	sp,sp,-48
    392e:	f406                	sd	ra,40(sp)
    3930:	f022                	sd	s0,32(sp)
    3932:	ec26                	sd	s1,24(sp)
    3934:	1800                	addi	s0,sp,48
    3936:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3938:	00004517          	auipc	a0,0x4
    393c:	a9050513          	addi	a0,a0,-1392 # 73c8 <malloc+0x1d42>
    3940:	00002097          	auipc	ra,0x2
    3944:	970080e7          	jalr	-1680(ra) # 52b0 <mkdir>
    3948:	04054263          	bltz	a0,398c <openiputtest+0x60>
  pid = fork();
    394c:	00002097          	auipc	ra,0x2
    3950:	8f4080e7          	jalr	-1804(ra) # 5240 <fork>
  if(pid < 0){
    3954:	04054a63          	bltz	a0,39a8 <openiputtest+0x7c>
  if(pid == 0){
    3958:	e93d                	bnez	a0,39ce <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    395a:	4589                	li	a1,2
    395c:	00004517          	auipc	a0,0x4
    3960:	a6c50513          	addi	a0,a0,-1428 # 73c8 <malloc+0x1d42>
    3964:	00002097          	auipc	ra,0x2
    3968:	924080e7          	jalr	-1756(ra) # 5288 <open>
    if(fd >= 0){
    396c:	04054c63          	bltz	a0,39c4 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3970:	85a6                	mv	a1,s1
    3972:	00004517          	auipc	a0,0x4
    3976:	a7650513          	addi	a0,a0,-1418 # 73e8 <malloc+0x1d62>
    397a:	00002097          	auipc	ra,0x2
    397e:	c4e080e7          	jalr	-946(ra) # 55c8 <printf>
      exit(1);
    3982:	4505                	li	a0,1
    3984:	00002097          	auipc	ra,0x2
    3988:	8c4080e7          	jalr	-1852(ra) # 5248 <exit>
    printf("%s: mkdir oidir failed\n", s);
    398c:	85a6                	mv	a1,s1
    398e:	00004517          	auipc	a0,0x4
    3992:	a4250513          	addi	a0,a0,-1470 # 73d0 <malloc+0x1d4a>
    3996:	00002097          	auipc	ra,0x2
    399a:	c32080e7          	jalr	-974(ra) # 55c8 <printf>
    exit(1);
    399e:	4505                	li	a0,1
    39a0:	00002097          	auipc	ra,0x2
    39a4:	8a8080e7          	jalr	-1880(ra) # 5248 <exit>
    printf("%s: fork failed\n", s);
    39a8:	85a6                	mv	a1,s1
    39aa:	00003517          	auipc	a0,0x3
    39ae:	93650513          	addi	a0,a0,-1738 # 62e0 <malloc+0xc5a>
    39b2:	00002097          	auipc	ra,0x2
    39b6:	c16080e7          	jalr	-1002(ra) # 55c8 <printf>
    exit(1);
    39ba:	4505                	li	a0,1
    39bc:	00002097          	auipc	ra,0x2
    39c0:	88c080e7          	jalr	-1908(ra) # 5248 <exit>
    exit(0);
    39c4:	4501                	li	a0,0
    39c6:	00002097          	auipc	ra,0x2
    39ca:	882080e7          	jalr	-1918(ra) # 5248 <exit>
  sleep(1);
    39ce:	4505                	li	a0,1
    39d0:	00002097          	auipc	ra,0x2
    39d4:	908080e7          	jalr	-1784(ra) # 52d8 <sleep>
  if(unlink("oidir") != 0){
    39d8:	00004517          	auipc	a0,0x4
    39dc:	9f050513          	addi	a0,a0,-1552 # 73c8 <malloc+0x1d42>
    39e0:	00002097          	auipc	ra,0x2
    39e4:	8b8080e7          	jalr	-1864(ra) # 5298 <unlink>
    39e8:	cd19                	beqz	a0,3a06 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    39ea:	85a6                	mv	a1,s1
    39ec:	00003517          	auipc	a0,0x3
    39f0:	ae450513          	addi	a0,a0,-1308 # 64d0 <malloc+0xe4a>
    39f4:	00002097          	auipc	ra,0x2
    39f8:	bd4080e7          	jalr	-1068(ra) # 55c8 <printf>
    exit(1);
    39fc:	4505                	li	a0,1
    39fe:	00002097          	auipc	ra,0x2
    3a02:	84a080e7          	jalr	-1974(ra) # 5248 <exit>
  wait(&xstatus);
    3a06:	fdc40513          	addi	a0,s0,-36
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	846080e7          	jalr	-1978(ra) # 5250 <wait>
  exit(xstatus);
    3a12:	fdc42503          	lw	a0,-36(s0)
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	832080e7          	jalr	-1998(ra) # 5248 <exit>

0000000000003a1e <forkforkfork>:
{
    3a1e:	1101                	addi	sp,sp,-32
    3a20:	ec06                	sd	ra,24(sp)
    3a22:	e822                	sd	s0,16(sp)
    3a24:	e426                	sd	s1,8(sp)
    3a26:	1000                	addi	s0,sp,32
    3a28:	84aa                	mv	s1,a0
  unlink("stopforking");
    3a2a:	00004517          	auipc	a0,0x4
    3a2e:	9e650513          	addi	a0,a0,-1562 # 7410 <malloc+0x1d8a>
    3a32:	00002097          	auipc	ra,0x2
    3a36:	866080e7          	jalr	-1946(ra) # 5298 <unlink>
  int pid = fork();
    3a3a:	00002097          	auipc	ra,0x2
    3a3e:	806080e7          	jalr	-2042(ra) # 5240 <fork>
  if(pid < 0){
    3a42:	04054563          	bltz	a0,3a8c <forkforkfork+0x6e>
  if(pid == 0){
    3a46:	c12d                	beqz	a0,3aa8 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3a48:	4551                	li	a0,20
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	88e080e7          	jalr	-1906(ra) # 52d8 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3a52:	20200593          	li	a1,514
    3a56:	00004517          	auipc	a0,0x4
    3a5a:	9ba50513          	addi	a0,a0,-1606 # 7410 <malloc+0x1d8a>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	82a080e7          	jalr	-2006(ra) # 5288 <open>
    3a66:	00002097          	auipc	ra,0x2
    3a6a:	80a080e7          	jalr	-2038(ra) # 5270 <close>
  wait(0);
    3a6e:	4501                	li	a0,0
    3a70:	00001097          	auipc	ra,0x1
    3a74:	7e0080e7          	jalr	2016(ra) # 5250 <wait>
  sleep(10); // one second
    3a78:	4529                	li	a0,10
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	85e080e7          	jalr	-1954(ra) # 52d8 <sleep>
}
    3a82:	60e2                	ld	ra,24(sp)
    3a84:	6442                	ld	s0,16(sp)
    3a86:	64a2                	ld	s1,8(sp)
    3a88:	6105                	addi	sp,sp,32
    3a8a:	8082                	ret
    printf("%s: fork failed", s);
    3a8c:	85a6                	mv	a1,s1
    3a8e:	00003517          	auipc	a0,0x3
    3a92:	a1250513          	addi	a0,a0,-1518 # 64a0 <malloc+0xe1a>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	b32080e7          	jalr	-1230(ra) # 55c8 <printf>
    exit(1);
    3a9e:	4505                	li	a0,1
    3aa0:	00001097          	auipc	ra,0x1
    3aa4:	7a8080e7          	jalr	1960(ra) # 5248 <exit>
      int fd = open("stopforking", 0);
    3aa8:	00004497          	auipc	s1,0x4
    3aac:	96848493          	addi	s1,s1,-1688 # 7410 <malloc+0x1d8a>
    3ab0:	4581                	li	a1,0
    3ab2:	8526                	mv	a0,s1
    3ab4:	00001097          	auipc	ra,0x1
    3ab8:	7d4080e7          	jalr	2004(ra) # 5288 <open>
      if(fd >= 0){
    3abc:	02055463          	bgez	a0,3ae4 <forkforkfork+0xc6>
      if(fork() < 0){
    3ac0:	00001097          	auipc	ra,0x1
    3ac4:	780080e7          	jalr	1920(ra) # 5240 <fork>
    3ac8:	fe0554e3          	bgez	a0,3ab0 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3acc:	20200593          	li	a1,514
    3ad0:	8526                	mv	a0,s1
    3ad2:	00001097          	auipc	ra,0x1
    3ad6:	7b6080e7          	jalr	1974(ra) # 5288 <open>
    3ada:	00001097          	auipc	ra,0x1
    3ade:	796080e7          	jalr	1942(ra) # 5270 <close>
    3ae2:	b7f9                	j	3ab0 <forkforkfork+0x92>
        exit(0);
    3ae4:	4501                	li	a0,0
    3ae6:	00001097          	auipc	ra,0x1
    3aea:	762080e7          	jalr	1890(ra) # 5248 <exit>

0000000000003aee <preempt>:
{
    3aee:	7139                	addi	sp,sp,-64
    3af0:	fc06                	sd	ra,56(sp)
    3af2:	f822                	sd	s0,48(sp)
    3af4:	f426                	sd	s1,40(sp)
    3af6:	f04a                	sd	s2,32(sp)
    3af8:	ec4e                	sd	s3,24(sp)
    3afa:	e852                	sd	s4,16(sp)
    3afc:	0080                	addi	s0,sp,64
    3afe:	8a2a                	mv	s4,a0
  pid1 = fork();
    3b00:	00001097          	auipc	ra,0x1
    3b04:	740080e7          	jalr	1856(ra) # 5240 <fork>
  if(pid1 < 0) {
    3b08:	00054563          	bltz	a0,3b12 <preempt+0x24>
    3b0c:	89aa                	mv	s3,a0
  if(pid1 == 0)
    3b0e:	ed19                	bnez	a0,3b2c <preempt+0x3e>
    for(;;)
    3b10:	a001                	j	3b10 <preempt+0x22>
    printf("%s: fork failed");
    3b12:	00003517          	auipc	a0,0x3
    3b16:	98e50513          	addi	a0,a0,-1650 # 64a0 <malloc+0xe1a>
    3b1a:	00002097          	auipc	ra,0x2
    3b1e:	aae080e7          	jalr	-1362(ra) # 55c8 <printf>
    exit(1);
    3b22:	4505                	li	a0,1
    3b24:	00001097          	auipc	ra,0x1
    3b28:	724080e7          	jalr	1828(ra) # 5248 <exit>
  pid2 = fork();
    3b2c:	00001097          	auipc	ra,0x1
    3b30:	714080e7          	jalr	1812(ra) # 5240 <fork>
    3b34:	892a                	mv	s2,a0
  if(pid2 < 0) {
    3b36:	00054463          	bltz	a0,3b3e <preempt+0x50>
  if(pid2 == 0)
    3b3a:	e105                	bnez	a0,3b5a <preempt+0x6c>
    for(;;)
    3b3c:	a001                	j	3b3c <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3b3e:	85d2                	mv	a1,s4
    3b40:	00002517          	auipc	a0,0x2
    3b44:	7a050513          	addi	a0,a0,1952 # 62e0 <malloc+0xc5a>
    3b48:	00002097          	auipc	ra,0x2
    3b4c:	a80080e7          	jalr	-1408(ra) # 55c8 <printf>
    exit(1);
    3b50:	4505                	li	a0,1
    3b52:	00001097          	auipc	ra,0x1
    3b56:	6f6080e7          	jalr	1782(ra) # 5248 <exit>
  pipe(pfds);
    3b5a:	fc840513          	addi	a0,s0,-56
    3b5e:	00001097          	auipc	ra,0x1
    3b62:	6fa080e7          	jalr	1786(ra) # 5258 <pipe>
  pid3 = fork();
    3b66:	00001097          	auipc	ra,0x1
    3b6a:	6da080e7          	jalr	1754(ra) # 5240 <fork>
    3b6e:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    3b70:	02054e63          	bltz	a0,3bac <preempt+0xbe>
  if(pid3 == 0){
    3b74:	e13d                	bnez	a0,3bda <preempt+0xec>
    close(pfds[0]);
    3b76:	fc842503          	lw	a0,-56(s0)
    3b7a:	00001097          	auipc	ra,0x1
    3b7e:	6f6080e7          	jalr	1782(ra) # 5270 <close>
    if(write(pfds[1], "x", 1) != 1)
    3b82:	4605                	li	a2,1
    3b84:	00002597          	auipc	a1,0x2
    3b88:	f9458593          	addi	a1,a1,-108 # 5b18 <malloc+0x492>
    3b8c:	fcc42503          	lw	a0,-52(s0)
    3b90:	00001097          	auipc	ra,0x1
    3b94:	6d8080e7          	jalr	1752(ra) # 5268 <write>
    3b98:	4785                	li	a5,1
    3b9a:	02f51763          	bne	a0,a5,3bc8 <preempt+0xda>
    close(pfds[1]);
    3b9e:	fcc42503          	lw	a0,-52(s0)
    3ba2:	00001097          	auipc	ra,0x1
    3ba6:	6ce080e7          	jalr	1742(ra) # 5270 <close>
    for(;;)
    3baa:	a001                	j	3baa <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3bac:	85d2                	mv	a1,s4
    3bae:	00002517          	auipc	a0,0x2
    3bb2:	73250513          	addi	a0,a0,1842 # 62e0 <malloc+0xc5a>
    3bb6:	00002097          	auipc	ra,0x2
    3bba:	a12080e7          	jalr	-1518(ra) # 55c8 <printf>
     exit(1);
    3bbe:	4505                	li	a0,1
    3bc0:	00001097          	auipc	ra,0x1
    3bc4:	688080e7          	jalr	1672(ra) # 5248 <exit>
      printf("%s: preempt write error");
    3bc8:	00004517          	auipc	a0,0x4
    3bcc:	85850513          	addi	a0,a0,-1960 # 7420 <malloc+0x1d9a>
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	9f8080e7          	jalr	-1544(ra) # 55c8 <printf>
    3bd8:	b7d9                	j	3b9e <preempt+0xb0>
  close(pfds[1]);
    3bda:	fcc42503          	lw	a0,-52(s0)
    3bde:	00001097          	auipc	ra,0x1
    3be2:	692080e7          	jalr	1682(ra) # 5270 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3be6:	660d                	lui	a2,0x3
    3be8:	00008597          	auipc	a1,0x8
    3bec:	96058593          	addi	a1,a1,-1696 # b548 <buf>
    3bf0:	fc842503          	lw	a0,-56(s0)
    3bf4:	00001097          	auipc	ra,0x1
    3bf8:	66c080e7          	jalr	1644(ra) # 5260 <read>
    3bfc:	4785                	li	a5,1
    3bfe:	02f50263          	beq	a0,a5,3c22 <preempt+0x134>
    printf("%s: preempt read error");
    3c02:	00004517          	auipc	a0,0x4
    3c06:	83650513          	addi	a0,a0,-1994 # 7438 <malloc+0x1db2>
    3c0a:	00002097          	auipc	ra,0x2
    3c0e:	9be080e7          	jalr	-1602(ra) # 55c8 <printf>
}
    3c12:	70e2                	ld	ra,56(sp)
    3c14:	7442                	ld	s0,48(sp)
    3c16:	74a2                	ld	s1,40(sp)
    3c18:	7902                	ld	s2,32(sp)
    3c1a:	69e2                	ld	s3,24(sp)
    3c1c:	6a42                	ld	s4,16(sp)
    3c1e:	6121                	addi	sp,sp,64
    3c20:	8082                	ret
  close(pfds[0]);
    3c22:	fc842503          	lw	a0,-56(s0)
    3c26:	00001097          	auipc	ra,0x1
    3c2a:	64a080e7          	jalr	1610(ra) # 5270 <close>
  printf("kill... ");
    3c2e:	00004517          	auipc	a0,0x4
    3c32:	82250513          	addi	a0,a0,-2014 # 7450 <malloc+0x1dca>
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	992080e7          	jalr	-1646(ra) # 55c8 <printf>
  kill(pid1);
    3c3e:	854e                	mv	a0,s3
    3c40:	00001097          	auipc	ra,0x1
    3c44:	638080e7          	jalr	1592(ra) # 5278 <kill>
  kill(pid2);
    3c48:	854a                	mv	a0,s2
    3c4a:	00001097          	auipc	ra,0x1
    3c4e:	62e080e7          	jalr	1582(ra) # 5278 <kill>
  kill(pid3);
    3c52:	8526                	mv	a0,s1
    3c54:	00001097          	auipc	ra,0x1
    3c58:	624080e7          	jalr	1572(ra) # 5278 <kill>
  printf("wait... ");
    3c5c:	00004517          	auipc	a0,0x4
    3c60:	80450513          	addi	a0,a0,-2044 # 7460 <malloc+0x1dda>
    3c64:	00002097          	auipc	ra,0x2
    3c68:	964080e7          	jalr	-1692(ra) # 55c8 <printf>
  wait(0);
    3c6c:	4501                	li	a0,0
    3c6e:	00001097          	auipc	ra,0x1
    3c72:	5e2080e7          	jalr	1506(ra) # 5250 <wait>
  wait(0);
    3c76:	4501                	li	a0,0
    3c78:	00001097          	auipc	ra,0x1
    3c7c:	5d8080e7          	jalr	1496(ra) # 5250 <wait>
  wait(0);
    3c80:	4501                	li	a0,0
    3c82:	00001097          	auipc	ra,0x1
    3c86:	5ce080e7          	jalr	1486(ra) # 5250 <wait>
    3c8a:	b761                	j	3c12 <preempt+0x124>

0000000000003c8c <sbrkfail>:
{
    3c8c:	7119                	addi	sp,sp,-128
    3c8e:	fc86                	sd	ra,120(sp)
    3c90:	f8a2                	sd	s0,112(sp)
    3c92:	f4a6                	sd	s1,104(sp)
    3c94:	f0ca                	sd	s2,96(sp)
    3c96:	ecce                	sd	s3,88(sp)
    3c98:	e8d2                	sd	s4,80(sp)
    3c9a:	e4d6                	sd	s5,72(sp)
    3c9c:	0100                	addi	s0,sp,128
    3c9e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    3ca0:	fb040513          	addi	a0,s0,-80
    3ca4:	00001097          	auipc	ra,0x1
    3ca8:	5b4080e7          	jalr	1460(ra) # 5258 <pipe>
    3cac:	e901                	bnez	a0,3cbc <sbrkfail+0x30>
    3cae:	f8040493          	addi	s1,s0,-128
    3cb2:	fa840a13          	addi	s4,s0,-88
    3cb6:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    3cb8:	5afd                	li	s5,-1
    3cba:	a061                	j	3d42 <sbrkfail+0xb6>
    printf("%s: pipe() failed\n", s);
    3cbc:	85ca                	mv	a1,s2
    3cbe:	00002517          	auipc	a0,0x2
    3cc2:	72a50513          	addi	a0,a0,1834 # 63e8 <malloc+0xd62>
    3cc6:	00002097          	auipc	ra,0x2
    3cca:	902080e7          	jalr	-1790(ra) # 55c8 <printf>
    exit(1);
    3cce:	4505                	li	a0,1
    3cd0:	00001097          	auipc	ra,0x1
    3cd4:	578080e7          	jalr	1400(ra) # 5248 <exit>
      char *p0 = sbrk(BIG - (uint64)sbrk(0));
    3cd8:	4501                	li	a0,0
    3cda:	00001097          	auipc	ra,0x1
    3cde:	5f6080e7          	jalr	1526(ra) # 52d0 <sbrk>
    3ce2:	064007b7          	lui	a5,0x6400
    3ce6:	40a7853b          	subw	a0,a5,a0
    3cea:	00001097          	auipc	ra,0x1
    3cee:	5e6080e7          	jalr	1510(ra) # 52d0 <sbrk>
    3cf2:	84aa                	mv	s1,a0
      if((uint64)p0 != 0xffffffffffffffffLL){
    3cf4:	57fd                	li	a5,-1
    3cf6:	02f50163          	beq	a0,a5,3d18 <sbrkfail+0x8c>
        char *p1 = sbrk(0);
    3cfa:	4501                	li	a0,0
    3cfc:	00001097          	auipc	ra,0x1
    3d00:	5d4080e7          	jalr	1492(ra) # 52d0 <sbrk>
    3d04:	87aa                	mv	a5,a0
        for(char *p2 = p0; p2 < p1; p2 += 4096)
    3d06:	00a4f963          	bgeu	s1,a0,3d18 <sbrkfail+0x8c>
          *p2 = 1;
    3d0a:	4685                	li	a3,1
        for(char *p2 = p0; p2 < p1; p2 += 4096)
    3d0c:	6705                	lui	a4,0x1
          *p2 = 1;
    3d0e:	00d48023          	sb	a3,0(s1)
        for(char *p2 = p0; p2 < p1; p2 += 4096)
    3d12:	94ba                	add	s1,s1,a4
    3d14:	fef4ede3          	bltu	s1,a5,3d0e <sbrkfail+0x82>
      write(fds[1], "x", 1);
    3d18:	4605                	li	a2,1
    3d1a:	00002597          	auipc	a1,0x2
    3d1e:	dfe58593          	addi	a1,a1,-514 # 5b18 <malloc+0x492>
    3d22:	fb442503          	lw	a0,-76(s0)
    3d26:	00001097          	auipc	ra,0x1
    3d2a:	542080e7          	jalr	1346(ra) # 5268 <write>
      for(;;) sleep(1000);
    3d2e:	3e800513          	li	a0,1000
    3d32:	00001097          	auipc	ra,0x1
    3d36:	5a6080e7          	jalr	1446(ra) # 52d8 <sleep>
    3d3a:	bfd5                	j	3d2e <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3d3c:	0991                	addi	s3,s3,4
    3d3e:	03498563          	beq	s3,s4,3d68 <sbrkfail+0xdc>
    if((pids[i] = fork()) == 0){
    3d42:	00001097          	auipc	ra,0x1
    3d46:	4fe080e7          	jalr	1278(ra) # 5240 <fork>
    3d4a:	00a9a023          	sw	a0,0(s3)
    3d4e:	d549                	beqz	a0,3cd8 <sbrkfail+0x4c>
    if(pids[i] != -1)
    3d50:	ff5506e3          	beq	a0,s5,3d3c <sbrkfail+0xb0>
      read(fds[0], &scratch, 1);
    3d54:	4605                	li	a2,1
    3d56:	faf40593          	addi	a1,s0,-81
    3d5a:	fb042503          	lw	a0,-80(s0)
    3d5e:	00001097          	auipc	ra,0x1
    3d62:	502080e7          	jalr	1282(ra) # 5260 <read>
    3d66:	bfd9                	j	3d3c <sbrkfail+0xb0>
  c = sbrk(PGSIZE);
    3d68:	6505                	lui	a0,0x1
    3d6a:	00001097          	auipc	ra,0x1
    3d6e:	566080e7          	jalr	1382(ra) # 52d0 <sbrk>
    3d72:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    3d74:	5afd                	li	s5,-1
    3d76:	a021                	j	3d7e <sbrkfail+0xf2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3d78:	0491                	addi	s1,s1,4
    3d7a:	01448f63          	beq	s1,s4,3d98 <sbrkfail+0x10c>
    if(pids[i] == -1)
    3d7e:	4088                	lw	a0,0(s1)
    3d80:	ff550ce3          	beq	a0,s5,3d78 <sbrkfail+0xec>
    kill(pids[i]);
    3d84:	00001097          	auipc	ra,0x1
    3d88:	4f4080e7          	jalr	1268(ra) # 5278 <kill>
    wait(0);
    3d8c:	4501                	li	a0,0
    3d8e:	00001097          	auipc	ra,0x1
    3d92:	4c2080e7          	jalr	1218(ra) # 5250 <wait>
    3d96:	b7cd                	j	3d78 <sbrkfail+0xec>
  if(c == (char*)0xffffffffffffffffL){
    3d98:	57fd                	li	a5,-1
    3d9a:	02f98e63          	beq	s3,a5,3dd6 <sbrkfail+0x14a>
  pid = fork();
    3d9e:	00001097          	auipc	ra,0x1
    3da2:	4a2080e7          	jalr	1186(ra) # 5240 <fork>
    3da6:	84aa                	mv	s1,a0
  if(pid < 0){
    3da8:	04054563          	bltz	a0,3df2 <sbrkfail+0x166>
  if(pid == 0){
    3dac:	c12d                	beqz	a0,3e0e <sbrkfail+0x182>
  wait(&xstatus);
    3dae:	fbc40513          	addi	a0,s0,-68
    3db2:	00001097          	auipc	ra,0x1
    3db6:	49e080e7          	jalr	1182(ra) # 5250 <wait>
  if(xstatus != -1)
    3dba:	fbc42703          	lw	a4,-68(s0)
    3dbe:	57fd                	li	a5,-1
    3dc0:	08f71c63          	bne	a4,a5,3e58 <sbrkfail+0x1cc>
}
    3dc4:	70e6                	ld	ra,120(sp)
    3dc6:	7446                	ld	s0,112(sp)
    3dc8:	74a6                	ld	s1,104(sp)
    3dca:	7906                	ld	s2,96(sp)
    3dcc:	69e6                	ld	s3,88(sp)
    3dce:	6a46                	ld	s4,80(sp)
    3dd0:	6aa6                	ld	s5,72(sp)
    3dd2:	6109                	addi	sp,sp,128
    3dd4:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3dd6:	85ca                	mv	a1,s2
    3dd8:	00003517          	auipc	a0,0x3
    3ddc:	69850513          	addi	a0,a0,1688 # 7470 <malloc+0x1dea>
    3de0:	00001097          	auipc	ra,0x1
    3de4:	7e8080e7          	jalr	2024(ra) # 55c8 <printf>
    exit(1);
    3de8:	4505                	li	a0,1
    3dea:	00001097          	auipc	ra,0x1
    3dee:	45e080e7          	jalr	1118(ra) # 5248 <exit>
    printf("%s: fork failed\n", s);
    3df2:	85ca                	mv	a1,s2
    3df4:	00002517          	auipc	a0,0x2
    3df8:	4ec50513          	addi	a0,a0,1260 # 62e0 <malloc+0xc5a>
    3dfc:	00001097          	auipc	ra,0x1
    3e00:	7cc080e7          	jalr	1996(ra) # 55c8 <printf>
    exit(1);
    3e04:	4505                	li	a0,1
    3e06:	00001097          	auipc	ra,0x1
    3e0a:	442080e7          	jalr	1090(ra) # 5248 <exit>
    a = sbrk(0);
    3e0e:	4501                	li	a0,0
    3e10:	00001097          	auipc	ra,0x1
    3e14:	4c0080e7          	jalr	1216(ra) # 52d0 <sbrk>
    3e18:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3e1a:	3e800537          	lui	a0,0x3e800
    3e1e:	00001097          	auipc	ra,0x1
    3e22:	4b2080e7          	jalr	1202(ra) # 52d0 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e26:	874a                	mv	a4,s2
    3e28:	3e8007b7          	lui	a5,0x3e800
    3e2c:	97ca                	add	a5,a5,s2
    3e2e:	6685                	lui	a3,0x1
      n += *(a+i);
    3e30:	00074603          	lbu	a2,0(a4) # 1000 <bigdir+0x96>
    3e34:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e36:	9736                	add	a4,a4,a3
    3e38:	fee79ce3          	bne	a5,a4,3e30 <sbrkfail+0x1a4>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3e3c:	85a6                	mv	a1,s1
    3e3e:	00003517          	auipc	a0,0x3
    3e42:	65250513          	addi	a0,a0,1618 # 7490 <malloc+0x1e0a>
    3e46:	00001097          	auipc	ra,0x1
    3e4a:	782080e7          	jalr	1922(ra) # 55c8 <printf>
    exit(1);
    3e4e:	4505                	li	a0,1
    3e50:	00001097          	auipc	ra,0x1
    3e54:	3f8080e7          	jalr	1016(ra) # 5248 <exit>
    exit(1);
    3e58:	4505                	li	a0,1
    3e5a:	00001097          	auipc	ra,0x1
    3e5e:	3ee080e7          	jalr	1006(ra) # 5248 <exit>

0000000000003e62 <reparent>:
{
    3e62:	7179                	addi	sp,sp,-48
    3e64:	f406                	sd	ra,40(sp)
    3e66:	f022                	sd	s0,32(sp)
    3e68:	ec26                	sd	s1,24(sp)
    3e6a:	e84a                	sd	s2,16(sp)
    3e6c:	e44e                	sd	s3,8(sp)
    3e6e:	e052                	sd	s4,0(sp)
    3e70:	1800                	addi	s0,sp,48
    3e72:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3e74:	00001097          	auipc	ra,0x1
    3e78:	454080e7          	jalr	1108(ra) # 52c8 <getpid>
    3e7c:	8a2a                	mv	s4,a0
    3e7e:	0c800913          	li	s2,200
    int pid = fork();
    3e82:	00001097          	auipc	ra,0x1
    3e86:	3be080e7          	jalr	958(ra) # 5240 <fork>
    3e8a:	84aa                	mv	s1,a0
    if(pid < 0){
    3e8c:	02054263          	bltz	a0,3eb0 <reparent+0x4e>
    if(pid){
    3e90:	cd21                	beqz	a0,3ee8 <reparent+0x86>
      if(wait(0) != pid){
    3e92:	4501                	li	a0,0
    3e94:	00001097          	auipc	ra,0x1
    3e98:	3bc080e7          	jalr	956(ra) # 5250 <wait>
    3e9c:	02951863          	bne	a0,s1,3ecc <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    3ea0:	397d                	addiw	s2,s2,-1
    3ea2:	fe0910e3          	bnez	s2,3e82 <reparent+0x20>
  exit(0);
    3ea6:	4501                	li	a0,0
    3ea8:	00001097          	auipc	ra,0x1
    3eac:	3a0080e7          	jalr	928(ra) # 5248 <exit>
      printf("%s: fork failed\n", s);
    3eb0:	85ce                	mv	a1,s3
    3eb2:	00002517          	auipc	a0,0x2
    3eb6:	42e50513          	addi	a0,a0,1070 # 62e0 <malloc+0xc5a>
    3eba:	00001097          	auipc	ra,0x1
    3ebe:	70e080e7          	jalr	1806(ra) # 55c8 <printf>
      exit(1);
    3ec2:	4505                	li	a0,1
    3ec4:	00001097          	auipc	ra,0x1
    3ec8:	384080e7          	jalr	900(ra) # 5248 <exit>
        printf("%s: wait wrong pid\n", s);
    3ecc:	85ce                	mv	a1,s3
    3ece:	00002517          	auipc	a0,0x2
    3ed2:	59a50513          	addi	a0,a0,1434 # 6468 <malloc+0xde2>
    3ed6:	00001097          	auipc	ra,0x1
    3eda:	6f2080e7          	jalr	1778(ra) # 55c8 <printf>
        exit(1);
    3ede:	4505                	li	a0,1
    3ee0:	00001097          	auipc	ra,0x1
    3ee4:	368080e7          	jalr	872(ra) # 5248 <exit>
      int pid2 = fork();
    3ee8:	00001097          	auipc	ra,0x1
    3eec:	358080e7          	jalr	856(ra) # 5240 <fork>
      if(pid2 < 0){
    3ef0:	00054763          	bltz	a0,3efe <reparent+0x9c>
      exit(0);
    3ef4:	4501                	li	a0,0
    3ef6:	00001097          	auipc	ra,0x1
    3efa:	352080e7          	jalr	850(ra) # 5248 <exit>
        kill(master_pid);
    3efe:	8552                	mv	a0,s4
    3f00:	00001097          	auipc	ra,0x1
    3f04:	378080e7          	jalr	888(ra) # 5278 <kill>
        exit(1);
    3f08:	4505                	li	a0,1
    3f0a:	00001097          	auipc	ra,0x1
    3f0e:	33e080e7          	jalr	830(ra) # 5248 <exit>

0000000000003f12 <mem>:
{
    3f12:	7139                	addi	sp,sp,-64
    3f14:	fc06                	sd	ra,56(sp)
    3f16:	f822                	sd	s0,48(sp)
    3f18:	f426                	sd	s1,40(sp)
    3f1a:	f04a                	sd	s2,32(sp)
    3f1c:	ec4e                	sd	s3,24(sp)
    3f1e:	0080                	addi	s0,sp,64
    3f20:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3f22:	00001097          	auipc	ra,0x1
    3f26:	31e080e7          	jalr	798(ra) # 5240 <fork>
    m1 = 0;
    3f2a:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3f2c:	6909                	lui	s2,0x2
    3f2e:	71190913          	addi	s2,s2,1809 # 2711 <argptest+0x4f>
  if((pid = fork()) == 0){
    3f32:	ed39                	bnez	a0,3f90 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    3f34:	854a                	mv	a0,s2
    3f36:	00001097          	auipc	ra,0x1
    3f3a:	750080e7          	jalr	1872(ra) # 5686 <malloc>
    3f3e:	c501                	beqz	a0,3f46 <mem+0x34>
      *(char**)m2 = m1;
    3f40:	e104                	sd	s1,0(a0)
      m1 = m2;
    3f42:	84aa                	mv	s1,a0
    3f44:	bfc5                	j	3f34 <mem+0x22>
    while(m1){
    3f46:	c881                	beqz	s1,3f56 <mem+0x44>
      m2 = *(char**)m1;
    3f48:	8526                	mv	a0,s1
    3f4a:	6084                	ld	s1,0(s1)
      free(m1);
    3f4c:	00001097          	auipc	ra,0x1
    3f50:	6b2080e7          	jalr	1714(ra) # 55fe <free>
    while(m1){
    3f54:	f8f5                	bnez	s1,3f48 <mem+0x36>
    m1 = malloc(1024*20);
    3f56:	6515                	lui	a0,0x5
    3f58:	00001097          	auipc	ra,0x1
    3f5c:	72e080e7          	jalr	1838(ra) # 5686 <malloc>
    if(m1 == 0){
    3f60:	c911                	beqz	a0,3f74 <mem+0x62>
    free(m1);
    3f62:	00001097          	auipc	ra,0x1
    3f66:	69c080e7          	jalr	1692(ra) # 55fe <free>
    exit(0);
    3f6a:	4501                	li	a0,0
    3f6c:	00001097          	auipc	ra,0x1
    3f70:	2dc080e7          	jalr	732(ra) # 5248 <exit>
      printf("couldn't allocate mem?!!\n", s);
    3f74:	85ce                	mv	a1,s3
    3f76:	00003517          	auipc	a0,0x3
    3f7a:	54a50513          	addi	a0,a0,1354 # 74c0 <malloc+0x1e3a>
    3f7e:	00001097          	auipc	ra,0x1
    3f82:	64a080e7          	jalr	1610(ra) # 55c8 <printf>
      exit(1);
    3f86:	4505                	li	a0,1
    3f88:	00001097          	auipc	ra,0x1
    3f8c:	2c0080e7          	jalr	704(ra) # 5248 <exit>
    wait(&xstatus);
    3f90:	fcc40513          	addi	a0,s0,-52
    3f94:	00001097          	auipc	ra,0x1
    3f98:	2bc080e7          	jalr	700(ra) # 5250 <wait>
    exit(xstatus);
    3f9c:	fcc42503          	lw	a0,-52(s0)
    3fa0:	00001097          	auipc	ra,0x1
    3fa4:	2a8080e7          	jalr	680(ra) # 5248 <exit>

0000000000003fa8 <sharedfd>:
{
    3fa8:	7159                	addi	sp,sp,-112
    3faa:	f486                	sd	ra,104(sp)
    3fac:	f0a2                	sd	s0,96(sp)
    3fae:	eca6                	sd	s1,88(sp)
    3fb0:	e8ca                	sd	s2,80(sp)
    3fb2:	e4ce                	sd	s3,72(sp)
    3fb4:	e0d2                	sd	s4,64(sp)
    3fb6:	fc56                	sd	s5,56(sp)
    3fb8:	f85a                	sd	s6,48(sp)
    3fba:	f45e                	sd	s7,40(sp)
    3fbc:	1880                	addi	s0,sp,112
    3fbe:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3fc0:	00002517          	auipc	a0,0x2
    3fc4:	93050513          	addi	a0,a0,-1744 # 58f0 <malloc+0x26a>
    3fc8:	00001097          	auipc	ra,0x1
    3fcc:	2d0080e7          	jalr	720(ra) # 5298 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3fd0:	20200593          	li	a1,514
    3fd4:	00002517          	auipc	a0,0x2
    3fd8:	91c50513          	addi	a0,a0,-1764 # 58f0 <malloc+0x26a>
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	2ac080e7          	jalr	684(ra) # 5288 <open>
  if(fd < 0){
    3fe4:	04054a63          	bltz	a0,4038 <sharedfd+0x90>
    3fe8:	892a                	mv	s2,a0
  pid = fork();
    3fea:	00001097          	auipc	ra,0x1
    3fee:	256080e7          	jalr	598(ra) # 5240 <fork>
    3ff2:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3ff4:	06300593          	li	a1,99
    3ff8:	c119                	beqz	a0,3ffe <sharedfd+0x56>
    3ffa:	07000593          	li	a1,112
    3ffe:	4629                	li	a2,10
    4000:	fa040513          	addi	a0,s0,-96
    4004:	00001097          	auipc	ra,0x1
    4008:	040080e7          	jalr	64(ra) # 5044 <memset>
    400c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4010:	4629                	li	a2,10
    4012:	fa040593          	addi	a1,s0,-96
    4016:	854a                	mv	a0,s2
    4018:	00001097          	auipc	ra,0x1
    401c:	250080e7          	jalr	592(ra) # 5268 <write>
    4020:	47a9                	li	a5,10
    4022:	02f51963          	bne	a0,a5,4054 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4026:	34fd                	addiw	s1,s1,-1
    4028:	f4e5                	bnez	s1,4010 <sharedfd+0x68>
  if(pid == 0) {
    402a:	04099363          	bnez	s3,4070 <sharedfd+0xc8>
    exit(0);
    402e:	4501                	li	a0,0
    4030:	00001097          	auipc	ra,0x1
    4034:	218080e7          	jalr	536(ra) # 5248 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4038:	85d2                	mv	a1,s4
    403a:	00003517          	auipc	a0,0x3
    403e:	4a650513          	addi	a0,a0,1190 # 74e0 <malloc+0x1e5a>
    4042:	00001097          	auipc	ra,0x1
    4046:	586080e7          	jalr	1414(ra) # 55c8 <printf>
    exit(1);
    404a:	4505                	li	a0,1
    404c:	00001097          	auipc	ra,0x1
    4050:	1fc080e7          	jalr	508(ra) # 5248 <exit>
      printf("%s: write sharedfd failed\n", s);
    4054:	85d2                	mv	a1,s4
    4056:	00003517          	auipc	a0,0x3
    405a:	4b250513          	addi	a0,a0,1202 # 7508 <malloc+0x1e82>
    405e:	00001097          	auipc	ra,0x1
    4062:	56a080e7          	jalr	1386(ra) # 55c8 <printf>
      exit(1);
    4066:	4505                	li	a0,1
    4068:	00001097          	auipc	ra,0x1
    406c:	1e0080e7          	jalr	480(ra) # 5248 <exit>
    wait(&xstatus);
    4070:	f9c40513          	addi	a0,s0,-100
    4074:	00001097          	auipc	ra,0x1
    4078:	1dc080e7          	jalr	476(ra) # 5250 <wait>
    if(xstatus != 0)
    407c:	f9c42983          	lw	s3,-100(s0)
    4080:	00098763          	beqz	s3,408e <sharedfd+0xe6>
      exit(xstatus);
    4084:	854e                	mv	a0,s3
    4086:	00001097          	auipc	ra,0x1
    408a:	1c2080e7          	jalr	450(ra) # 5248 <exit>
  close(fd);
    408e:	854a                	mv	a0,s2
    4090:	00001097          	auipc	ra,0x1
    4094:	1e0080e7          	jalr	480(ra) # 5270 <close>
  fd = open("sharedfd", 0);
    4098:	4581                	li	a1,0
    409a:	00002517          	auipc	a0,0x2
    409e:	85650513          	addi	a0,a0,-1962 # 58f0 <malloc+0x26a>
    40a2:	00001097          	auipc	ra,0x1
    40a6:	1e6080e7          	jalr	486(ra) # 5288 <open>
    40aa:	8baa                	mv	s7,a0
  nc = np = 0;
    40ac:	8ace                	mv	s5,s3
  if(fd < 0){
    40ae:	02054563          	bltz	a0,40d8 <sharedfd+0x130>
    40b2:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    40b6:	06300493          	li	s1,99
      if(buf[i] == 'p')
    40ba:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    40be:	4629                	li	a2,10
    40c0:	fa040593          	addi	a1,s0,-96
    40c4:	855e                	mv	a0,s7
    40c6:	00001097          	auipc	ra,0x1
    40ca:	19a080e7          	jalr	410(ra) # 5260 <read>
    40ce:	02a05f63          	blez	a0,410c <sharedfd+0x164>
    40d2:	fa040793          	addi	a5,s0,-96
    40d6:	a01d                	j	40fc <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    40d8:	85d2                	mv	a1,s4
    40da:	00003517          	auipc	a0,0x3
    40de:	44e50513          	addi	a0,a0,1102 # 7528 <malloc+0x1ea2>
    40e2:	00001097          	auipc	ra,0x1
    40e6:	4e6080e7          	jalr	1254(ra) # 55c8 <printf>
    exit(1);
    40ea:	4505                	li	a0,1
    40ec:	00001097          	auipc	ra,0x1
    40f0:	15c080e7          	jalr	348(ra) # 5248 <exit>
        nc++;
    40f4:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    40f6:	0785                	addi	a5,a5,1
    40f8:	fd2783e3          	beq	a5,s2,40be <sharedfd+0x116>
      if(buf[i] == 'c')
    40fc:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f1aa8>
    4100:	fe970ae3          	beq	a4,s1,40f4 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4104:	ff6719e3          	bne	a4,s6,40f6 <sharedfd+0x14e>
        np++;
    4108:	2a85                	addiw	s5,s5,1
    410a:	b7f5                	j	40f6 <sharedfd+0x14e>
  close(fd);
    410c:	855e                	mv	a0,s7
    410e:	00001097          	auipc	ra,0x1
    4112:	162080e7          	jalr	354(ra) # 5270 <close>
  unlink("sharedfd");
    4116:	00001517          	auipc	a0,0x1
    411a:	7da50513          	addi	a0,a0,2010 # 58f0 <malloc+0x26a>
    411e:	00001097          	auipc	ra,0x1
    4122:	17a080e7          	jalr	378(ra) # 5298 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4126:	6789                	lui	a5,0x2
    4128:	71078793          	addi	a5,a5,1808 # 2710 <argptest+0x4e>
    412c:	00f99763          	bne	s3,a5,413a <sharedfd+0x192>
    4130:	6789                	lui	a5,0x2
    4132:	71078793          	addi	a5,a5,1808 # 2710 <argptest+0x4e>
    4136:	02fa8063          	beq	s5,a5,4156 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    413a:	85d2                	mv	a1,s4
    413c:	00003517          	auipc	a0,0x3
    4140:	41450513          	addi	a0,a0,1044 # 7550 <malloc+0x1eca>
    4144:	00001097          	auipc	ra,0x1
    4148:	484080e7          	jalr	1156(ra) # 55c8 <printf>
    exit(1);
    414c:	4505                	li	a0,1
    414e:	00001097          	auipc	ra,0x1
    4152:	0fa080e7          	jalr	250(ra) # 5248 <exit>
    exit(0);
    4156:	4501                	li	a0,0
    4158:	00001097          	auipc	ra,0x1
    415c:	0f0080e7          	jalr	240(ra) # 5248 <exit>

0000000000004160 <fourfiles>:
{
    4160:	7171                	addi	sp,sp,-176
    4162:	f506                	sd	ra,168(sp)
    4164:	f122                	sd	s0,160(sp)
    4166:	ed26                	sd	s1,152(sp)
    4168:	e94a                	sd	s2,144(sp)
    416a:	e54e                	sd	s3,136(sp)
    416c:	e152                	sd	s4,128(sp)
    416e:	fcd6                	sd	s5,120(sp)
    4170:	f8da                	sd	s6,112(sp)
    4172:	f4de                	sd	s7,104(sp)
    4174:	f0e2                	sd	s8,96(sp)
    4176:	ece6                	sd	s9,88(sp)
    4178:	e8ea                	sd	s10,80(sp)
    417a:	e4ee                	sd	s11,72(sp)
    417c:	1900                	addi	s0,sp,176
    417e:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4180:	00001797          	auipc	a5,0x1
    4184:	5f078793          	addi	a5,a5,1520 # 5770 <malloc+0xea>
    4188:	f6f43823          	sd	a5,-144(s0)
    418c:	00001797          	auipc	a5,0x1
    4190:	5ec78793          	addi	a5,a5,1516 # 5778 <malloc+0xf2>
    4194:	f6f43c23          	sd	a5,-136(s0)
    4198:	00001797          	auipc	a5,0x1
    419c:	5e878793          	addi	a5,a5,1512 # 5780 <malloc+0xfa>
    41a0:	f8f43023          	sd	a5,-128(s0)
    41a4:	00001797          	auipc	a5,0x1
    41a8:	5e478793          	addi	a5,a5,1508 # 5788 <malloc+0x102>
    41ac:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    41b0:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    41b4:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    41b6:	4481                	li	s1,0
    41b8:	4a11                	li	s4,4
    fname = names[pi];
    41ba:	00093983          	ld	s3,0(s2)
    unlink(fname);
    41be:	854e                	mv	a0,s3
    41c0:	00001097          	auipc	ra,0x1
    41c4:	0d8080e7          	jalr	216(ra) # 5298 <unlink>
    pid = fork();
    41c8:	00001097          	auipc	ra,0x1
    41cc:	078080e7          	jalr	120(ra) # 5240 <fork>
    if(pid < 0){
    41d0:	04054563          	bltz	a0,421a <fourfiles+0xba>
    if(pid == 0){
    41d4:	c12d                	beqz	a0,4236 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    41d6:	2485                	addiw	s1,s1,1
    41d8:	0921                	addi	s2,s2,8
    41da:	ff4490e3          	bne	s1,s4,41ba <fourfiles+0x5a>
    41de:	4491                	li	s1,4
    wait(&xstatus);
    41e0:	f6c40513          	addi	a0,s0,-148
    41e4:	00001097          	auipc	ra,0x1
    41e8:	06c080e7          	jalr	108(ra) # 5250 <wait>
    if(xstatus != 0)
    41ec:	f6c42503          	lw	a0,-148(s0)
    41f0:	ed69                	bnez	a0,42ca <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    41f2:	34fd                	addiw	s1,s1,-1
    41f4:	f4f5                	bnez	s1,41e0 <fourfiles+0x80>
    41f6:	03000b13          	li	s6,48
    total = 0;
    41fa:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    41fe:	00007a17          	auipc	s4,0x7
    4202:	34aa0a13          	addi	s4,s4,842 # b548 <buf>
    4206:	00007a97          	auipc	s5,0x7
    420a:	343a8a93          	addi	s5,s5,835 # b549 <buf+0x1>
    if(total != N*SZ){
    420e:	6d05                	lui	s10,0x1
    4210:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x2a>
  for(i = 0; i < NCHILD; i++){
    4214:	03400d93          	li	s11,52
    4218:	a23d                	j	4346 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    421a:	85e6                	mv	a1,s9
    421c:	00002517          	auipc	a0,0x2
    4220:	4b450513          	addi	a0,a0,1204 # 66d0 <malloc+0x104a>
    4224:	00001097          	auipc	ra,0x1
    4228:	3a4080e7          	jalr	932(ra) # 55c8 <printf>
      exit(1);
    422c:	4505                	li	a0,1
    422e:	00001097          	auipc	ra,0x1
    4232:	01a080e7          	jalr	26(ra) # 5248 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4236:	20200593          	li	a1,514
    423a:	854e                	mv	a0,s3
    423c:	00001097          	auipc	ra,0x1
    4240:	04c080e7          	jalr	76(ra) # 5288 <open>
    4244:	892a                	mv	s2,a0
      if(fd < 0){
    4246:	04054763          	bltz	a0,4294 <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    424a:	1f400613          	li	a2,500
    424e:	0304859b          	addiw	a1,s1,48
    4252:	00007517          	auipc	a0,0x7
    4256:	2f650513          	addi	a0,a0,758 # b548 <buf>
    425a:	00001097          	auipc	ra,0x1
    425e:	dea080e7          	jalr	-534(ra) # 5044 <memset>
    4262:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4264:	00007997          	auipc	s3,0x7
    4268:	2e498993          	addi	s3,s3,740 # b548 <buf>
    426c:	1f400613          	li	a2,500
    4270:	85ce                	mv	a1,s3
    4272:	854a                	mv	a0,s2
    4274:	00001097          	auipc	ra,0x1
    4278:	ff4080e7          	jalr	-12(ra) # 5268 <write>
    427c:	85aa                	mv	a1,a0
    427e:	1f400793          	li	a5,500
    4282:	02f51763          	bne	a0,a5,42b0 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    4286:	34fd                	addiw	s1,s1,-1
    4288:	f0f5                	bnez	s1,426c <fourfiles+0x10c>
      exit(0);
    428a:	4501                	li	a0,0
    428c:	00001097          	auipc	ra,0x1
    4290:	fbc080e7          	jalr	-68(ra) # 5248 <exit>
        printf("create failed\n", s);
    4294:	85e6                	mv	a1,s9
    4296:	00003517          	auipc	a0,0x3
    429a:	2d250513          	addi	a0,a0,722 # 7568 <malloc+0x1ee2>
    429e:	00001097          	auipc	ra,0x1
    42a2:	32a080e7          	jalr	810(ra) # 55c8 <printf>
        exit(1);
    42a6:	4505                	li	a0,1
    42a8:	00001097          	auipc	ra,0x1
    42ac:	fa0080e7          	jalr	-96(ra) # 5248 <exit>
          printf("write failed %d\n", n);
    42b0:	00003517          	auipc	a0,0x3
    42b4:	2c850513          	addi	a0,a0,712 # 7578 <malloc+0x1ef2>
    42b8:	00001097          	auipc	ra,0x1
    42bc:	310080e7          	jalr	784(ra) # 55c8 <printf>
          exit(1);
    42c0:	4505                	li	a0,1
    42c2:	00001097          	auipc	ra,0x1
    42c6:	f86080e7          	jalr	-122(ra) # 5248 <exit>
      exit(xstatus);
    42ca:	00001097          	auipc	ra,0x1
    42ce:	f7e080e7          	jalr	-130(ra) # 5248 <exit>
          printf("wrong char\n", s);
    42d2:	85e6                	mv	a1,s9
    42d4:	00003517          	auipc	a0,0x3
    42d8:	2bc50513          	addi	a0,a0,700 # 7590 <malloc+0x1f0a>
    42dc:	00001097          	auipc	ra,0x1
    42e0:	2ec080e7          	jalr	748(ra) # 55c8 <printf>
          exit(1);
    42e4:	4505                	li	a0,1
    42e6:	00001097          	auipc	ra,0x1
    42ea:	f62080e7          	jalr	-158(ra) # 5248 <exit>
      total += n;
    42ee:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    42f2:	660d                	lui	a2,0x3
    42f4:	85d2                	mv	a1,s4
    42f6:	854e                	mv	a0,s3
    42f8:	00001097          	auipc	ra,0x1
    42fc:	f68080e7          	jalr	-152(ra) # 5260 <read>
    4300:	02a05363          	blez	a0,4326 <fourfiles+0x1c6>
    4304:	00007797          	auipc	a5,0x7
    4308:	24478793          	addi	a5,a5,580 # b548 <buf>
    430c:	fff5069b          	addiw	a3,a0,-1
    4310:	1682                	slli	a3,a3,0x20
    4312:	9281                	srli	a3,a3,0x20
    4314:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4316:	0007c703          	lbu	a4,0(a5)
    431a:	fa971ce3          	bne	a4,s1,42d2 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    431e:	0785                	addi	a5,a5,1
    4320:	fed79be3          	bne	a5,a3,4316 <fourfiles+0x1b6>
    4324:	b7e9                	j	42ee <fourfiles+0x18e>
    close(fd);
    4326:	854e                	mv	a0,s3
    4328:	00001097          	auipc	ra,0x1
    432c:	f48080e7          	jalr	-184(ra) # 5270 <close>
    if(total != N*SZ){
    4330:	03a91963          	bne	s2,s10,4362 <fourfiles+0x202>
    unlink(fname);
    4334:	8562                	mv	a0,s8
    4336:	00001097          	auipc	ra,0x1
    433a:	f62080e7          	jalr	-158(ra) # 5298 <unlink>
  for(i = 0; i < NCHILD; i++){
    433e:	0ba1                	addi	s7,s7,8
    4340:	2b05                	addiw	s6,s6,1
    4342:	03bb0e63          	beq	s6,s11,437e <fourfiles+0x21e>
    fname = names[i];
    4346:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    434a:	4581                	li	a1,0
    434c:	8562                	mv	a0,s8
    434e:	00001097          	auipc	ra,0x1
    4352:	f3a080e7          	jalr	-198(ra) # 5288 <open>
    4356:	89aa                	mv	s3,a0
    total = 0;
    4358:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    435c:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4360:	bf49                	j	42f2 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4362:	85ca                	mv	a1,s2
    4364:	00003517          	auipc	a0,0x3
    4368:	23c50513          	addi	a0,a0,572 # 75a0 <malloc+0x1f1a>
    436c:	00001097          	auipc	ra,0x1
    4370:	25c080e7          	jalr	604(ra) # 55c8 <printf>
      exit(1);
    4374:	4505                	li	a0,1
    4376:	00001097          	auipc	ra,0x1
    437a:	ed2080e7          	jalr	-302(ra) # 5248 <exit>
}
    437e:	70aa                	ld	ra,168(sp)
    4380:	740a                	ld	s0,160(sp)
    4382:	64ea                	ld	s1,152(sp)
    4384:	694a                	ld	s2,144(sp)
    4386:	69aa                	ld	s3,136(sp)
    4388:	6a0a                	ld	s4,128(sp)
    438a:	7ae6                	ld	s5,120(sp)
    438c:	7b46                	ld	s6,112(sp)
    438e:	7ba6                	ld	s7,104(sp)
    4390:	7c06                	ld	s8,96(sp)
    4392:	6ce6                	ld	s9,88(sp)
    4394:	6d46                	ld	s10,80(sp)
    4396:	6da6                	ld	s11,72(sp)
    4398:	614d                	addi	sp,sp,176
    439a:	8082                	ret

000000000000439c <concreate>:
{
    439c:	7135                	addi	sp,sp,-160
    439e:	ed06                	sd	ra,152(sp)
    43a0:	e922                	sd	s0,144(sp)
    43a2:	e526                	sd	s1,136(sp)
    43a4:	e14a                	sd	s2,128(sp)
    43a6:	fcce                	sd	s3,120(sp)
    43a8:	f8d2                	sd	s4,112(sp)
    43aa:	f4d6                	sd	s5,104(sp)
    43ac:	f0da                	sd	s6,96(sp)
    43ae:	ecde                	sd	s7,88(sp)
    43b0:	1100                	addi	s0,sp,160
    43b2:	89aa                	mv	s3,a0
  file[0] = 'C';
    43b4:	04300793          	li	a5,67
    43b8:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    43bc:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    43c0:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    43c2:	4b0d                	li	s6,3
    43c4:	4a85                	li	s5,1
      link("C0", file);
    43c6:	00003b97          	auipc	s7,0x3
    43ca:	1f2b8b93          	addi	s7,s7,498 # 75b8 <malloc+0x1f32>
  for(i = 0; i < N; i++){
    43ce:	02800a13          	li	s4,40
    43d2:	acc1                	j	46a2 <concreate+0x306>
      link("C0", file);
    43d4:	fa840593          	addi	a1,s0,-88
    43d8:	855e                	mv	a0,s7
    43da:	00001097          	auipc	ra,0x1
    43de:	ece080e7          	jalr	-306(ra) # 52a8 <link>
    if(pid == 0) {
    43e2:	a45d                	j	4688 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    43e4:	4795                	li	a5,5
    43e6:	02f9693b          	remw	s2,s2,a5
    43ea:	4785                	li	a5,1
    43ec:	02f90b63          	beq	s2,a5,4422 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    43f0:	20200593          	li	a1,514
    43f4:	fa840513          	addi	a0,s0,-88
    43f8:	00001097          	auipc	ra,0x1
    43fc:	e90080e7          	jalr	-368(ra) # 5288 <open>
      if(fd < 0){
    4400:	26055b63          	bgez	a0,4676 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4404:	fa840593          	addi	a1,s0,-88
    4408:	00003517          	auipc	a0,0x3
    440c:	1b850513          	addi	a0,a0,440 # 75c0 <malloc+0x1f3a>
    4410:	00001097          	auipc	ra,0x1
    4414:	1b8080e7          	jalr	440(ra) # 55c8 <printf>
        exit(1);
    4418:	4505                	li	a0,1
    441a:	00001097          	auipc	ra,0x1
    441e:	e2e080e7          	jalr	-466(ra) # 5248 <exit>
      link("C0", file);
    4422:	fa840593          	addi	a1,s0,-88
    4426:	00003517          	auipc	a0,0x3
    442a:	19250513          	addi	a0,a0,402 # 75b8 <malloc+0x1f32>
    442e:	00001097          	auipc	ra,0x1
    4432:	e7a080e7          	jalr	-390(ra) # 52a8 <link>
      exit(0);
    4436:	4501                	li	a0,0
    4438:	00001097          	auipc	ra,0x1
    443c:	e10080e7          	jalr	-496(ra) # 5248 <exit>
        exit(1);
    4440:	4505                	li	a0,1
    4442:	00001097          	auipc	ra,0x1
    4446:	e06080e7          	jalr	-506(ra) # 5248 <exit>
  memset(fa, 0, sizeof(fa));
    444a:	02800613          	li	a2,40
    444e:	4581                	li	a1,0
    4450:	f8040513          	addi	a0,s0,-128
    4454:	00001097          	auipc	ra,0x1
    4458:	bf0080e7          	jalr	-1040(ra) # 5044 <memset>
  fd = open(".", 0);
    445c:	4581                	li	a1,0
    445e:	00002517          	auipc	a0,0x2
    4462:	ce250513          	addi	a0,a0,-798 # 6140 <malloc+0xaba>
    4466:	00001097          	auipc	ra,0x1
    446a:	e22080e7          	jalr	-478(ra) # 5288 <open>
    446e:	892a                	mv	s2,a0
  n = 0;
    4470:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4472:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4476:	02700b13          	li	s6,39
      fa[i] = 1;
    447a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    447c:	a03d                	j	44aa <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    447e:	f7240613          	addi	a2,s0,-142
    4482:	85ce                	mv	a1,s3
    4484:	00003517          	auipc	a0,0x3
    4488:	15c50513          	addi	a0,a0,348 # 75e0 <malloc+0x1f5a>
    448c:	00001097          	auipc	ra,0x1
    4490:	13c080e7          	jalr	316(ra) # 55c8 <printf>
        exit(1);
    4494:	4505                	li	a0,1
    4496:	00001097          	auipc	ra,0x1
    449a:	db2080e7          	jalr	-590(ra) # 5248 <exit>
      fa[i] = 1;
    449e:	fb040793          	addi	a5,s0,-80
    44a2:	973e                	add	a4,a4,a5
    44a4:	fd770823          	sb	s7,-48(a4)
      n++;
    44a8:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    44aa:	4641                	li	a2,16
    44ac:	f7040593          	addi	a1,s0,-144
    44b0:	854a                	mv	a0,s2
    44b2:	00001097          	auipc	ra,0x1
    44b6:	dae080e7          	jalr	-594(ra) # 5260 <read>
    44ba:	04a05a63          	blez	a0,450e <concreate+0x172>
    if(de.inum == 0)
    44be:	f7045783          	lhu	a5,-144(s0)
    44c2:	d7e5                	beqz	a5,44aa <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44c4:	f7244783          	lbu	a5,-142(s0)
    44c8:	ff4791e3          	bne	a5,s4,44aa <concreate+0x10e>
    44cc:	f7444783          	lbu	a5,-140(s0)
    44d0:	ffe9                	bnez	a5,44aa <concreate+0x10e>
      i = de.name[1] - '0';
    44d2:	f7344783          	lbu	a5,-141(s0)
    44d6:	fd07879b          	addiw	a5,a5,-48
    44da:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    44de:	faeb60e3          	bltu	s6,a4,447e <concreate+0xe2>
      if(fa[i]){
    44e2:	fb040793          	addi	a5,s0,-80
    44e6:	97ba                	add	a5,a5,a4
    44e8:	fd07c783          	lbu	a5,-48(a5)
    44ec:	dbcd                	beqz	a5,449e <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    44ee:	f7240613          	addi	a2,s0,-142
    44f2:	85ce                	mv	a1,s3
    44f4:	00003517          	auipc	a0,0x3
    44f8:	10c50513          	addi	a0,a0,268 # 7600 <malloc+0x1f7a>
    44fc:	00001097          	auipc	ra,0x1
    4500:	0cc080e7          	jalr	204(ra) # 55c8 <printf>
        exit(1);
    4504:	4505                	li	a0,1
    4506:	00001097          	auipc	ra,0x1
    450a:	d42080e7          	jalr	-702(ra) # 5248 <exit>
  close(fd);
    450e:	854a                	mv	a0,s2
    4510:	00001097          	auipc	ra,0x1
    4514:	d60080e7          	jalr	-672(ra) # 5270 <close>
  if(n != N){
    4518:	02800793          	li	a5,40
    451c:	00fa9763          	bne	s5,a5,452a <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4520:	4a8d                	li	s5,3
    4522:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4524:	02800a13          	li	s4,40
    4528:	a8c9                	j	45fa <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    452a:	85ce                	mv	a1,s3
    452c:	00003517          	auipc	a0,0x3
    4530:	0fc50513          	addi	a0,a0,252 # 7628 <malloc+0x1fa2>
    4534:	00001097          	auipc	ra,0x1
    4538:	094080e7          	jalr	148(ra) # 55c8 <printf>
    exit(1);
    453c:	4505                	li	a0,1
    453e:	00001097          	auipc	ra,0x1
    4542:	d0a080e7          	jalr	-758(ra) # 5248 <exit>
      printf("%s: fork failed\n", s);
    4546:	85ce                	mv	a1,s3
    4548:	00002517          	auipc	a0,0x2
    454c:	d9850513          	addi	a0,a0,-616 # 62e0 <malloc+0xc5a>
    4550:	00001097          	auipc	ra,0x1
    4554:	078080e7          	jalr	120(ra) # 55c8 <printf>
      exit(1);
    4558:	4505                	li	a0,1
    455a:	00001097          	auipc	ra,0x1
    455e:	cee080e7          	jalr	-786(ra) # 5248 <exit>
      close(open(file, 0));
    4562:	4581                	li	a1,0
    4564:	fa840513          	addi	a0,s0,-88
    4568:	00001097          	auipc	ra,0x1
    456c:	d20080e7          	jalr	-736(ra) # 5288 <open>
    4570:	00001097          	auipc	ra,0x1
    4574:	d00080e7          	jalr	-768(ra) # 5270 <close>
      close(open(file, 0));
    4578:	4581                	li	a1,0
    457a:	fa840513          	addi	a0,s0,-88
    457e:	00001097          	auipc	ra,0x1
    4582:	d0a080e7          	jalr	-758(ra) # 5288 <open>
    4586:	00001097          	auipc	ra,0x1
    458a:	cea080e7          	jalr	-790(ra) # 5270 <close>
      close(open(file, 0));
    458e:	4581                	li	a1,0
    4590:	fa840513          	addi	a0,s0,-88
    4594:	00001097          	auipc	ra,0x1
    4598:	cf4080e7          	jalr	-780(ra) # 5288 <open>
    459c:	00001097          	auipc	ra,0x1
    45a0:	cd4080e7          	jalr	-812(ra) # 5270 <close>
      close(open(file, 0));
    45a4:	4581                	li	a1,0
    45a6:	fa840513          	addi	a0,s0,-88
    45aa:	00001097          	auipc	ra,0x1
    45ae:	cde080e7          	jalr	-802(ra) # 5288 <open>
    45b2:	00001097          	auipc	ra,0x1
    45b6:	cbe080e7          	jalr	-834(ra) # 5270 <close>
      close(open(file, 0));
    45ba:	4581                	li	a1,0
    45bc:	fa840513          	addi	a0,s0,-88
    45c0:	00001097          	auipc	ra,0x1
    45c4:	cc8080e7          	jalr	-824(ra) # 5288 <open>
    45c8:	00001097          	auipc	ra,0x1
    45cc:	ca8080e7          	jalr	-856(ra) # 5270 <close>
      close(open(file, 0));
    45d0:	4581                	li	a1,0
    45d2:	fa840513          	addi	a0,s0,-88
    45d6:	00001097          	auipc	ra,0x1
    45da:	cb2080e7          	jalr	-846(ra) # 5288 <open>
    45de:	00001097          	auipc	ra,0x1
    45e2:	c92080e7          	jalr	-878(ra) # 5270 <close>
    if(pid == 0)
    45e6:	08090363          	beqz	s2,466c <concreate+0x2d0>
      wait(0);
    45ea:	4501                	li	a0,0
    45ec:	00001097          	auipc	ra,0x1
    45f0:	c64080e7          	jalr	-924(ra) # 5250 <wait>
  for(i = 0; i < N; i++){
    45f4:	2485                	addiw	s1,s1,1
    45f6:	0f448563          	beq	s1,s4,46e0 <concreate+0x344>
    file[1] = '0' + i;
    45fa:	0304879b          	addiw	a5,s1,48
    45fe:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4602:	00001097          	auipc	ra,0x1
    4606:	c3e080e7          	jalr	-962(ra) # 5240 <fork>
    460a:	892a                	mv	s2,a0
    if(pid < 0){
    460c:	f2054de3          	bltz	a0,4546 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4610:	0354e73b          	remw	a4,s1,s5
    4614:	00a767b3          	or	a5,a4,a0
    4618:	2781                	sext.w	a5,a5
    461a:	d7a1                	beqz	a5,4562 <concreate+0x1c6>
    461c:	01671363          	bne	a4,s6,4622 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4620:	f129                	bnez	a0,4562 <concreate+0x1c6>
      unlink(file);
    4622:	fa840513          	addi	a0,s0,-88
    4626:	00001097          	auipc	ra,0x1
    462a:	c72080e7          	jalr	-910(ra) # 5298 <unlink>
      unlink(file);
    462e:	fa840513          	addi	a0,s0,-88
    4632:	00001097          	auipc	ra,0x1
    4636:	c66080e7          	jalr	-922(ra) # 5298 <unlink>
      unlink(file);
    463a:	fa840513          	addi	a0,s0,-88
    463e:	00001097          	auipc	ra,0x1
    4642:	c5a080e7          	jalr	-934(ra) # 5298 <unlink>
      unlink(file);
    4646:	fa840513          	addi	a0,s0,-88
    464a:	00001097          	auipc	ra,0x1
    464e:	c4e080e7          	jalr	-946(ra) # 5298 <unlink>
      unlink(file);
    4652:	fa840513          	addi	a0,s0,-88
    4656:	00001097          	auipc	ra,0x1
    465a:	c42080e7          	jalr	-958(ra) # 5298 <unlink>
      unlink(file);
    465e:	fa840513          	addi	a0,s0,-88
    4662:	00001097          	auipc	ra,0x1
    4666:	c36080e7          	jalr	-970(ra) # 5298 <unlink>
    466a:	bfb5                	j	45e6 <concreate+0x24a>
      exit(0);
    466c:	4501                	li	a0,0
    466e:	00001097          	auipc	ra,0x1
    4672:	bda080e7          	jalr	-1062(ra) # 5248 <exit>
      close(fd);
    4676:	00001097          	auipc	ra,0x1
    467a:	bfa080e7          	jalr	-1030(ra) # 5270 <close>
    if(pid == 0) {
    467e:	bb65                	j	4436 <concreate+0x9a>
      close(fd);
    4680:	00001097          	auipc	ra,0x1
    4684:	bf0080e7          	jalr	-1040(ra) # 5270 <close>
      wait(&xstatus);
    4688:	f6c40513          	addi	a0,s0,-148
    468c:	00001097          	auipc	ra,0x1
    4690:	bc4080e7          	jalr	-1084(ra) # 5250 <wait>
      if(xstatus != 0)
    4694:	f6c42483          	lw	s1,-148(s0)
    4698:	da0494e3          	bnez	s1,4440 <concreate+0xa4>
  for(i = 0; i < N; i++){
    469c:	2905                	addiw	s2,s2,1
    469e:	db4906e3          	beq	s2,s4,444a <concreate+0xae>
    file[1] = '0' + i;
    46a2:	0309079b          	addiw	a5,s2,48
    46a6:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    46aa:	fa840513          	addi	a0,s0,-88
    46ae:	00001097          	auipc	ra,0x1
    46b2:	bea080e7          	jalr	-1046(ra) # 5298 <unlink>
    pid = fork();
    46b6:	00001097          	auipc	ra,0x1
    46ba:	b8a080e7          	jalr	-1142(ra) # 5240 <fork>
    if(pid && (i % 3) == 1){
    46be:	d20503e3          	beqz	a0,43e4 <concreate+0x48>
    46c2:	036967bb          	remw	a5,s2,s6
    46c6:	d15787e3          	beq	a5,s5,43d4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    46ca:	20200593          	li	a1,514
    46ce:	fa840513          	addi	a0,s0,-88
    46d2:	00001097          	auipc	ra,0x1
    46d6:	bb6080e7          	jalr	-1098(ra) # 5288 <open>
      if(fd < 0){
    46da:	fa0553e3          	bgez	a0,4680 <concreate+0x2e4>
    46de:	b31d                	j	4404 <concreate+0x68>
}
    46e0:	60ea                	ld	ra,152(sp)
    46e2:	644a                	ld	s0,144(sp)
    46e4:	64aa                	ld	s1,136(sp)
    46e6:	690a                	ld	s2,128(sp)
    46e8:	79e6                	ld	s3,120(sp)
    46ea:	7a46                	ld	s4,112(sp)
    46ec:	7aa6                	ld	s5,104(sp)
    46ee:	7b06                	ld	s6,96(sp)
    46f0:	6be6                	ld	s7,88(sp)
    46f2:	610d                	addi	sp,sp,160
    46f4:	8082                	ret

00000000000046f6 <bigfile>:
{
    46f6:	7139                	addi	sp,sp,-64
    46f8:	fc06                	sd	ra,56(sp)
    46fa:	f822                	sd	s0,48(sp)
    46fc:	f426                	sd	s1,40(sp)
    46fe:	f04a                	sd	s2,32(sp)
    4700:	ec4e                	sd	s3,24(sp)
    4702:	e852                	sd	s4,16(sp)
    4704:	e456                	sd	s5,8(sp)
    4706:	0080                	addi	s0,sp,64
    4708:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    470a:	00003517          	auipc	a0,0x3
    470e:	f5650513          	addi	a0,a0,-170 # 7660 <malloc+0x1fda>
    4712:	00001097          	auipc	ra,0x1
    4716:	b86080e7          	jalr	-1146(ra) # 5298 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    471a:	20200593          	li	a1,514
    471e:	00003517          	auipc	a0,0x3
    4722:	f4250513          	addi	a0,a0,-190 # 7660 <malloc+0x1fda>
    4726:	00001097          	auipc	ra,0x1
    472a:	b62080e7          	jalr	-1182(ra) # 5288 <open>
    472e:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4730:	4481                	li	s1,0
    memset(buf, i, SZ);
    4732:	00007917          	auipc	s2,0x7
    4736:	e1690913          	addi	s2,s2,-490 # b548 <buf>
  for(i = 0; i < N; i++){
    473a:	4a51                	li	s4,20
  if(fd < 0){
    473c:	0a054063          	bltz	a0,47dc <bigfile+0xe6>
    memset(buf, i, SZ);
    4740:	25800613          	li	a2,600
    4744:	85a6                	mv	a1,s1
    4746:	854a                	mv	a0,s2
    4748:	00001097          	auipc	ra,0x1
    474c:	8fc080e7          	jalr	-1796(ra) # 5044 <memset>
    if(write(fd, buf, SZ) != SZ){
    4750:	25800613          	li	a2,600
    4754:	85ca                	mv	a1,s2
    4756:	854e                	mv	a0,s3
    4758:	00001097          	auipc	ra,0x1
    475c:	b10080e7          	jalr	-1264(ra) # 5268 <write>
    4760:	25800793          	li	a5,600
    4764:	08f51a63          	bne	a0,a5,47f8 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4768:	2485                	addiw	s1,s1,1
    476a:	fd449be3          	bne	s1,s4,4740 <bigfile+0x4a>
  close(fd);
    476e:	854e                	mv	a0,s3
    4770:	00001097          	auipc	ra,0x1
    4774:	b00080e7          	jalr	-1280(ra) # 5270 <close>
  fd = open("bigfile.dat", 0);
    4778:	4581                	li	a1,0
    477a:	00003517          	auipc	a0,0x3
    477e:	ee650513          	addi	a0,a0,-282 # 7660 <malloc+0x1fda>
    4782:	00001097          	auipc	ra,0x1
    4786:	b06080e7          	jalr	-1274(ra) # 5288 <open>
    478a:	8a2a                	mv	s4,a0
  total = 0;
    478c:	4981                	li	s3,0
  for(i = 0; ; i++){
    478e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4790:	00007917          	auipc	s2,0x7
    4794:	db890913          	addi	s2,s2,-584 # b548 <buf>
  if(fd < 0){
    4798:	06054e63          	bltz	a0,4814 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    479c:	12c00613          	li	a2,300
    47a0:	85ca                	mv	a1,s2
    47a2:	8552                	mv	a0,s4
    47a4:	00001097          	auipc	ra,0x1
    47a8:	abc080e7          	jalr	-1348(ra) # 5260 <read>
    if(cc < 0){
    47ac:	08054263          	bltz	a0,4830 <bigfile+0x13a>
    if(cc == 0)
    47b0:	c971                	beqz	a0,4884 <bigfile+0x18e>
    if(cc != SZ/2){
    47b2:	12c00793          	li	a5,300
    47b6:	08f51b63          	bne	a0,a5,484c <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    47ba:	01f4d79b          	srliw	a5,s1,0x1f
    47be:	9fa5                	addw	a5,a5,s1
    47c0:	4017d79b          	sraiw	a5,a5,0x1
    47c4:	00094703          	lbu	a4,0(s2)
    47c8:	0af71063          	bne	a4,a5,4868 <bigfile+0x172>
    47cc:	12b94703          	lbu	a4,299(s2)
    47d0:	08f71c63          	bne	a4,a5,4868 <bigfile+0x172>
    total += cc;
    47d4:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    47d8:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    47da:	b7c9                	j	479c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    47dc:	85d6                	mv	a1,s5
    47de:	00003517          	auipc	a0,0x3
    47e2:	e9250513          	addi	a0,a0,-366 # 7670 <malloc+0x1fea>
    47e6:	00001097          	auipc	ra,0x1
    47ea:	de2080e7          	jalr	-542(ra) # 55c8 <printf>
    exit(1);
    47ee:	4505                	li	a0,1
    47f0:	00001097          	auipc	ra,0x1
    47f4:	a58080e7          	jalr	-1448(ra) # 5248 <exit>
      printf("%s: write bigfile failed\n", s);
    47f8:	85d6                	mv	a1,s5
    47fa:	00003517          	auipc	a0,0x3
    47fe:	e9650513          	addi	a0,a0,-362 # 7690 <malloc+0x200a>
    4802:	00001097          	auipc	ra,0x1
    4806:	dc6080e7          	jalr	-570(ra) # 55c8 <printf>
      exit(1);
    480a:	4505                	li	a0,1
    480c:	00001097          	auipc	ra,0x1
    4810:	a3c080e7          	jalr	-1476(ra) # 5248 <exit>
    printf("%s: cannot open bigfile\n", s);
    4814:	85d6                	mv	a1,s5
    4816:	00003517          	auipc	a0,0x3
    481a:	e9a50513          	addi	a0,a0,-358 # 76b0 <malloc+0x202a>
    481e:	00001097          	auipc	ra,0x1
    4822:	daa080e7          	jalr	-598(ra) # 55c8 <printf>
    exit(1);
    4826:	4505                	li	a0,1
    4828:	00001097          	auipc	ra,0x1
    482c:	a20080e7          	jalr	-1504(ra) # 5248 <exit>
      printf("%s: read bigfile failed\n", s);
    4830:	85d6                	mv	a1,s5
    4832:	00003517          	auipc	a0,0x3
    4836:	e9e50513          	addi	a0,a0,-354 # 76d0 <malloc+0x204a>
    483a:	00001097          	auipc	ra,0x1
    483e:	d8e080e7          	jalr	-626(ra) # 55c8 <printf>
      exit(1);
    4842:	4505                	li	a0,1
    4844:	00001097          	auipc	ra,0x1
    4848:	a04080e7          	jalr	-1532(ra) # 5248 <exit>
      printf("%s: short read bigfile\n", s);
    484c:	85d6                	mv	a1,s5
    484e:	00003517          	auipc	a0,0x3
    4852:	ea250513          	addi	a0,a0,-350 # 76f0 <malloc+0x206a>
    4856:	00001097          	auipc	ra,0x1
    485a:	d72080e7          	jalr	-654(ra) # 55c8 <printf>
      exit(1);
    485e:	4505                	li	a0,1
    4860:	00001097          	auipc	ra,0x1
    4864:	9e8080e7          	jalr	-1560(ra) # 5248 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4868:	85d6                	mv	a1,s5
    486a:	00003517          	auipc	a0,0x3
    486e:	e9e50513          	addi	a0,a0,-354 # 7708 <malloc+0x2082>
    4872:	00001097          	auipc	ra,0x1
    4876:	d56080e7          	jalr	-682(ra) # 55c8 <printf>
      exit(1);
    487a:	4505                	li	a0,1
    487c:	00001097          	auipc	ra,0x1
    4880:	9cc080e7          	jalr	-1588(ra) # 5248 <exit>
  close(fd);
    4884:	8552                	mv	a0,s4
    4886:	00001097          	auipc	ra,0x1
    488a:	9ea080e7          	jalr	-1558(ra) # 5270 <close>
  if(total != N*SZ){
    488e:	678d                	lui	a5,0x3
    4890:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x26e>
    4894:	02f99363          	bne	s3,a5,48ba <bigfile+0x1c4>
  unlink("bigfile.dat");
    4898:	00003517          	auipc	a0,0x3
    489c:	dc850513          	addi	a0,a0,-568 # 7660 <malloc+0x1fda>
    48a0:	00001097          	auipc	ra,0x1
    48a4:	9f8080e7          	jalr	-1544(ra) # 5298 <unlink>
}
    48a8:	70e2                	ld	ra,56(sp)
    48aa:	7442                	ld	s0,48(sp)
    48ac:	74a2                	ld	s1,40(sp)
    48ae:	7902                	ld	s2,32(sp)
    48b0:	69e2                	ld	s3,24(sp)
    48b2:	6a42                	ld	s4,16(sp)
    48b4:	6aa2                	ld	s5,8(sp)
    48b6:	6121                	addi	sp,sp,64
    48b8:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    48ba:	85d6                	mv	a1,s5
    48bc:	00003517          	auipc	a0,0x3
    48c0:	e6c50513          	addi	a0,a0,-404 # 7728 <malloc+0x20a2>
    48c4:	00001097          	auipc	ra,0x1
    48c8:	d04080e7          	jalr	-764(ra) # 55c8 <printf>
    exit(1);
    48cc:	4505                	li	a0,1
    48ce:	00001097          	auipc	ra,0x1
    48d2:	97a080e7          	jalr	-1670(ra) # 5248 <exit>

00000000000048d6 <dirtest>:
{
    48d6:	1101                	addi	sp,sp,-32
    48d8:	ec06                	sd	ra,24(sp)
    48da:	e822                	sd	s0,16(sp)
    48dc:	e426                	sd	s1,8(sp)
    48de:	1000                	addi	s0,sp,32
    48e0:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    48e2:	00003517          	auipc	a0,0x3
    48e6:	e6650513          	addi	a0,a0,-410 # 7748 <malloc+0x20c2>
    48ea:	00001097          	auipc	ra,0x1
    48ee:	cde080e7          	jalr	-802(ra) # 55c8 <printf>
  if(mkdir("dir0") < 0){
    48f2:	00003517          	auipc	a0,0x3
    48f6:	e6650513          	addi	a0,a0,-410 # 7758 <malloc+0x20d2>
    48fa:	00001097          	auipc	ra,0x1
    48fe:	9b6080e7          	jalr	-1610(ra) # 52b0 <mkdir>
    4902:	04054d63          	bltz	a0,495c <dirtest+0x86>
  if(chdir("dir0") < 0){
    4906:	00003517          	auipc	a0,0x3
    490a:	e5250513          	addi	a0,a0,-430 # 7758 <malloc+0x20d2>
    490e:	00001097          	auipc	ra,0x1
    4912:	9aa080e7          	jalr	-1622(ra) # 52b8 <chdir>
    4916:	06054163          	bltz	a0,4978 <dirtest+0xa2>
  if(chdir("..") < 0){
    491a:	00003517          	auipc	a0,0x3
    491e:	89650513          	addi	a0,a0,-1898 # 71b0 <malloc+0x1b2a>
    4922:	00001097          	auipc	ra,0x1
    4926:	996080e7          	jalr	-1642(ra) # 52b8 <chdir>
    492a:	06054563          	bltz	a0,4994 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    492e:	00003517          	auipc	a0,0x3
    4932:	e2a50513          	addi	a0,a0,-470 # 7758 <malloc+0x20d2>
    4936:	00001097          	auipc	ra,0x1
    493a:	962080e7          	jalr	-1694(ra) # 5298 <unlink>
    493e:	06054963          	bltz	a0,49b0 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    4942:	00003517          	auipc	a0,0x3
    4946:	e6650513          	addi	a0,a0,-410 # 77a8 <malloc+0x2122>
    494a:	00001097          	auipc	ra,0x1
    494e:	c7e080e7          	jalr	-898(ra) # 55c8 <printf>
}
    4952:	60e2                	ld	ra,24(sp)
    4954:	6442                	ld	s0,16(sp)
    4956:	64a2                	ld	s1,8(sp)
    4958:	6105                	addi	sp,sp,32
    495a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    495c:	85a6                	mv	a1,s1
    495e:	00002517          	auipc	a0,0x2
    4962:	1f250513          	addi	a0,a0,498 # 6b50 <malloc+0x14ca>
    4966:	00001097          	auipc	ra,0x1
    496a:	c62080e7          	jalr	-926(ra) # 55c8 <printf>
    exit(1);
    496e:	4505                	li	a0,1
    4970:	00001097          	auipc	ra,0x1
    4974:	8d8080e7          	jalr	-1832(ra) # 5248 <exit>
    printf("%s: chdir dir0 failed\n", s);
    4978:	85a6                	mv	a1,s1
    497a:	00003517          	auipc	a0,0x3
    497e:	de650513          	addi	a0,a0,-538 # 7760 <malloc+0x20da>
    4982:	00001097          	auipc	ra,0x1
    4986:	c46080e7          	jalr	-954(ra) # 55c8 <printf>
    exit(1);
    498a:	4505                	li	a0,1
    498c:	00001097          	auipc	ra,0x1
    4990:	8bc080e7          	jalr	-1860(ra) # 5248 <exit>
    printf("%s: chdir .. failed\n", s);
    4994:	85a6                	mv	a1,s1
    4996:	00003517          	auipc	a0,0x3
    499a:	de250513          	addi	a0,a0,-542 # 7778 <malloc+0x20f2>
    499e:	00001097          	auipc	ra,0x1
    49a2:	c2a080e7          	jalr	-982(ra) # 55c8 <printf>
    exit(1);
    49a6:	4505                	li	a0,1
    49a8:	00001097          	auipc	ra,0x1
    49ac:	8a0080e7          	jalr	-1888(ra) # 5248 <exit>
    printf("%s: unlink dir0 failed\n", s);
    49b0:	85a6                	mv	a1,s1
    49b2:	00003517          	auipc	a0,0x3
    49b6:	dde50513          	addi	a0,a0,-546 # 7790 <malloc+0x210a>
    49ba:	00001097          	auipc	ra,0x1
    49be:	c0e080e7          	jalr	-1010(ra) # 55c8 <printf>
    exit(1);
    49c2:	4505                	li	a0,1
    49c4:	00001097          	auipc	ra,0x1
    49c8:	884080e7          	jalr	-1916(ra) # 5248 <exit>

00000000000049cc <fsfull>:
{
    49cc:	7171                	addi	sp,sp,-176
    49ce:	f506                	sd	ra,168(sp)
    49d0:	f122                	sd	s0,160(sp)
    49d2:	ed26                	sd	s1,152(sp)
    49d4:	e94a                	sd	s2,144(sp)
    49d6:	e54e                	sd	s3,136(sp)
    49d8:	e152                	sd	s4,128(sp)
    49da:	fcd6                	sd	s5,120(sp)
    49dc:	f8da                	sd	s6,112(sp)
    49de:	f4de                	sd	s7,104(sp)
    49e0:	f0e2                	sd	s8,96(sp)
    49e2:	ece6                	sd	s9,88(sp)
    49e4:	e8ea                	sd	s10,80(sp)
    49e6:	e4ee                	sd	s11,72(sp)
    49e8:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    49ea:	00003517          	auipc	a0,0x3
    49ee:	dd650513          	addi	a0,a0,-554 # 77c0 <malloc+0x213a>
    49f2:	00001097          	auipc	ra,0x1
    49f6:	bd6080e7          	jalr	-1066(ra) # 55c8 <printf>
  for(nfiles = 0; ; nfiles++){
    49fa:	4481                	li	s1,0
    name[0] = 'f';
    49fc:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4a00:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4a04:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4a08:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4a0a:	00003c97          	auipc	s9,0x3
    4a0e:	dc6c8c93          	addi	s9,s9,-570 # 77d0 <malloc+0x214a>
    int total = 0;
    4a12:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4a14:	00007a17          	auipc	s4,0x7
    4a18:	b34a0a13          	addi	s4,s4,-1228 # b548 <buf>
    name[0] = 'f';
    4a1c:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4a20:	0384c7bb          	divw	a5,s1,s8
    4a24:	0307879b          	addiw	a5,a5,48
    4a28:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a2c:	0384e7bb          	remw	a5,s1,s8
    4a30:	0377c7bb          	divw	a5,a5,s7
    4a34:	0307879b          	addiw	a5,a5,48
    4a38:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4a3c:	0374e7bb          	remw	a5,s1,s7
    4a40:	0367c7bb          	divw	a5,a5,s6
    4a44:	0307879b          	addiw	a5,a5,48
    4a48:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4a4c:	0364e7bb          	remw	a5,s1,s6
    4a50:	0307879b          	addiw	a5,a5,48
    4a54:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4a58:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4a5c:	f5040593          	addi	a1,s0,-176
    4a60:	8566                	mv	a0,s9
    4a62:	00001097          	auipc	ra,0x1
    4a66:	b66080e7          	jalr	-1178(ra) # 55c8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4a6a:	20200593          	li	a1,514
    4a6e:	f5040513          	addi	a0,s0,-176
    4a72:	00001097          	auipc	ra,0x1
    4a76:	816080e7          	jalr	-2026(ra) # 5288 <open>
    4a7a:	892a                	mv	s2,a0
    if(fd < 0){
    4a7c:	0a055663          	bgez	a0,4b28 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4a80:	f5040593          	addi	a1,s0,-176
    4a84:	00003517          	auipc	a0,0x3
    4a88:	d5c50513          	addi	a0,a0,-676 # 77e0 <malloc+0x215a>
    4a8c:	00001097          	auipc	ra,0x1
    4a90:	b3c080e7          	jalr	-1220(ra) # 55c8 <printf>
  while(nfiles >= 0){
    4a94:	0604c363          	bltz	s1,4afa <fsfull+0x12e>
    name[0] = 'f';
    4a98:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4a9c:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4aa0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4aa4:	4929                	li	s2,10
  while(nfiles >= 0){
    4aa6:	5afd                	li	s5,-1
    name[0] = 'f';
    4aa8:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4aac:	0344c7bb          	divw	a5,s1,s4
    4ab0:	0307879b          	addiw	a5,a5,48
    4ab4:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ab8:	0344e7bb          	remw	a5,s1,s4
    4abc:	0337c7bb          	divw	a5,a5,s3
    4ac0:	0307879b          	addiw	a5,a5,48
    4ac4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4ac8:	0334e7bb          	remw	a5,s1,s3
    4acc:	0327c7bb          	divw	a5,a5,s2
    4ad0:	0307879b          	addiw	a5,a5,48
    4ad4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ad8:	0324e7bb          	remw	a5,s1,s2
    4adc:	0307879b          	addiw	a5,a5,48
    4ae0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4ae4:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4ae8:	f5040513          	addi	a0,s0,-176
    4aec:	00000097          	auipc	ra,0x0
    4af0:	7ac080e7          	jalr	1964(ra) # 5298 <unlink>
    nfiles--;
    4af4:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4af6:	fb5499e3          	bne	s1,s5,4aa8 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4afa:	00003517          	auipc	a0,0x3
    4afe:	d1650513          	addi	a0,a0,-746 # 7810 <malloc+0x218a>
    4b02:	00001097          	auipc	ra,0x1
    4b06:	ac6080e7          	jalr	-1338(ra) # 55c8 <printf>
}
    4b0a:	70aa                	ld	ra,168(sp)
    4b0c:	740a                	ld	s0,160(sp)
    4b0e:	64ea                	ld	s1,152(sp)
    4b10:	694a                	ld	s2,144(sp)
    4b12:	69aa                	ld	s3,136(sp)
    4b14:	6a0a                	ld	s4,128(sp)
    4b16:	7ae6                	ld	s5,120(sp)
    4b18:	7b46                	ld	s6,112(sp)
    4b1a:	7ba6                	ld	s7,104(sp)
    4b1c:	7c06                	ld	s8,96(sp)
    4b1e:	6ce6                	ld	s9,88(sp)
    4b20:	6d46                	ld	s10,80(sp)
    4b22:	6da6                	ld	s11,72(sp)
    4b24:	614d                	addi	sp,sp,176
    4b26:	8082                	ret
    int total = 0;
    4b28:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4b2a:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4b2e:	40000613          	li	a2,1024
    4b32:	85d2                	mv	a1,s4
    4b34:	854a                	mv	a0,s2
    4b36:	00000097          	auipc	ra,0x0
    4b3a:	732080e7          	jalr	1842(ra) # 5268 <write>
      if(cc < BSIZE)
    4b3e:	00aad563          	bge	s5,a0,4b48 <fsfull+0x17c>
      total += cc;
    4b42:	00a989bb          	addw	s3,s3,a0
    while(1){
    4b46:	b7e5                	j	4b2e <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4b48:	85ce                	mv	a1,s3
    4b4a:	00003517          	auipc	a0,0x3
    4b4e:	cae50513          	addi	a0,a0,-850 # 77f8 <malloc+0x2172>
    4b52:	00001097          	auipc	ra,0x1
    4b56:	a76080e7          	jalr	-1418(ra) # 55c8 <printf>
    close(fd);
    4b5a:	854a                	mv	a0,s2
    4b5c:	00000097          	auipc	ra,0x0
    4b60:	714080e7          	jalr	1812(ra) # 5270 <close>
    if(total == 0)
    4b64:	f20988e3          	beqz	s3,4a94 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4b68:	2485                	addiw	s1,s1,1
    4b6a:	bd4d                	j	4a1c <fsfull+0x50>

0000000000004b6c <rand>:
{
    4b6c:	1141                	addi	sp,sp,-16
    4b6e:	e422                	sd	s0,8(sp)
    4b70:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4b72:	00003717          	auipc	a4,0x3
    4b76:	1a670713          	addi	a4,a4,422 # 7d18 <randstate>
    4b7a:	6308                	ld	a0,0(a4)
    4b7c:	001967b7          	lui	a5,0x196
    4b80:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x1880b5>
    4b84:	02f50533          	mul	a0,a0,a5
    4b88:	3c6ef7b7          	lui	a5,0x3c6ef
    4b8c:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0e07>
    4b90:	953e                	add	a0,a0,a5
    4b92:	e308                	sd	a0,0(a4)
}
    4b94:	2501                	sext.w	a0,a0
    4b96:	6422                	ld	s0,8(sp)
    4b98:	0141                	addi	sp,sp,16
    4b9a:	8082                	ret

0000000000004b9c <badwrite>:
{
    4b9c:	7179                	addi	sp,sp,-48
    4b9e:	f406                	sd	ra,40(sp)
    4ba0:	f022                	sd	s0,32(sp)
    4ba2:	ec26                	sd	s1,24(sp)
    4ba4:	e84a                	sd	s2,16(sp)
    4ba6:	e44e                	sd	s3,8(sp)
    4ba8:	e052                	sd	s4,0(sp)
    4baa:	1800                	addi	s0,sp,48
  unlink("junk");
    4bac:	00003517          	auipc	a0,0x3
    4bb0:	c7c50513          	addi	a0,a0,-900 # 7828 <malloc+0x21a2>
    4bb4:	00000097          	auipc	ra,0x0
    4bb8:	6e4080e7          	jalr	1764(ra) # 5298 <unlink>
    4bbc:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4bc0:	00003997          	auipc	s3,0x3
    4bc4:	c6898993          	addi	s3,s3,-920 # 7828 <malloc+0x21a2>
    write(fd, (char*)0xffffffffffL, 1);
    4bc8:	5a7d                	li	s4,-1
    4bca:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4bce:	20100593          	li	a1,513
    4bd2:	854e                	mv	a0,s3
    4bd4:	00000097          	auipc	ra,0x0
    4bd8:	6b4080e7          	jalr	1716(ra) # 5288 <open>
    4bdc:	84aa                	mv	s1,a0
    if(fd < 0){
    4bde:	06054b63          	bltz	a0,4c54 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4be2:	4605                	li	a2,1
    4be4:	85d2                	mv	a1,s4
    4be6:	00000097          	auipc	ra,0x0
    4bea:	682080e7          	jalr	1666(ra) # 5268 <write>
    close(fd);
    4bee:	8526                	mv	a0,s1
    4bf0:	00000097          	auipc	ra,0x0
    4bf4:	680080e7          	jalr	1664(ra) # 5270 <close>
    unlink("junk");
    4bf8:	854e                	mv	a0,s3
    4bfa:	00000097          	auipc	ra,0x0
    4bfe:	69e080e7          	jalr	1694(ra) # 5298 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4c02:	397d                	addiw	s2,s2,-1
    4c04:	fc0915e3          	bnez	s2,4bce <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4c08:	20100593          	li	a1,513
    4c0c:	00003517          	auipc	a0,0x3
    4c10:	c1c50513          	addi	a0,a0,-996 # 7828 <malloc+0x21a2>
    4c14:	00000097          	auipc	ra,0x0
    4c18:	674080e7          	jalr	1652(ra) # 5288 <open>
    4c1c:	84aa                	mv	s1,a0
  if(fd < 0){
    4c1e:	04054863          	bltz	a0,4c6e <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4c22:	4605                	li	a2,1
    4c24:	00001597          	auipc	a1,0x1
    4c28:	ef458593          	addi	a1,a1,-268 # 5b18 <malloc+0x492>
    4c2c:	00000097          	auipc	ra,0x0
    4c30:	63c080e7          	jalr	1596(ra) # 5268 <write>
    4c34:	4785                	li	a5,1
    4c36:	04f50963          	beq	a0,a5,4c88 <badwrite+0xec>
    printf("write failed\n");
    4c3a:	00003517          	auipc	a0,0x3
    4c3e:	c0e50513          	addi	a0,a0,-1010 # 7848 <malloc+0x21c2>
    4c42:	00001097          	auipc	ra,0x1
    4c46:	986080e7          	jalr	-1658(ra) # 55c8 <printf>
    exit(1);
    4c4a:	4505                	li	a0,1
    4c4c:	00000097          	auipc	ra,0x0
    4c50:	5fc080e7          	jalr	1532(ra) # 5248 <exit>
      printf("open junk failed\n");
    4c54:	00003517          	auipc	a0,0x3
    4c58:	bdc50513          	addi	a0,a0,-1060 # 7830 <malloc+0x21aa>
    4c5c:	00001097          	auipc	ra,0x1
    4c60:	96c080e7          	jalr	-1684(ra) # 55c8 <printf>
      exit(1);
    4c64:	4505                	li	a0,1
    4c66:	00000097          	auipc	ra,0x0
    4c6a:	5e2080e7          	jalr	1506(ra) # 5248 <exit>
    printf("open junk failed\n");
    4c6e:	00003517          	auipc	a0,0x3
    4c72:	bc250513          	addi	a0,a0,-1086 # 7830 <malloc+0x21aa>
    4c76:	00001097          	auipc	ra,0x1
    4c7a:	952080e7          	jalr	-1710(ra) # 55c8 <printf>
    exit(1);
    4c7e:	4505                	li	a0,1
    4c80:	00000097          	auipc	ra,0x0
    4c84:	5c8080e7          	jalr	1480(ra) # 5248 <exit>
  close(fd);
    4c88:	8526                	mv	a0,s1
    4c8a:	00000097          	auipc	ra,0x0
    4c8e:	5e6080e7          	jalr	1510(ra) # 5270 <close>
  unlink("junk");
    4c92:	00003517          	auipc	a0,0x3
    4c96:	b9650513          	addi	a0,a0,-1130 # 7828 <malloc+0x21a2>
    4c9a:	00000097          	auipc	ra,0x0
    4c9e:	5fe080e7          	jalr	1534(ra) # 5298 <unlink>
  exit(0);
    4ca2:	4501                	li	a0,0
    4ca4:	00000097          	auipc	ra,0x0
    4ca8:	5a4080e7          	jalr	1444(ra) # 5248 <exit>

0000000000004cac <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
    4cac:	7179                	addi	sp,sp,-48
    4cae:	f406                	sd	ra,40(sp)
    4cb0:	f022                	sd	s0,32(sp)
    4cb2:	ec26                	sd	s1,24(sp)
    4cb4:	e84a                	sd	s2,16(sp)
    4cb6:	e44e                	sd	s3,8(sp)
    4cb8:	e052                	sd	s4,0(sp)
    4cba:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
    4cbc:	4501                	li	a0,0
    4cbe:	00000097          	auipc	ra,0x0
    4cc2:	612080e7          	jalr	1554(ra) # 52d0 <sbrk>
    4cc6:	8a2a                	mv	s4,a0
  int n = 0;
    4cc8:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
    4cca:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
    4ccc:	4985                	li	s3,1
    uint64 a = (uint64) sbrk(4096);
    4cce:	6505                	lui	a0,0x1
    4cd0:	00000097          	auipc	ra,0x0
    4cd4:	600080e7          	jalr	1536(ra) # 52d0 <sbrk>
    if(a == 0xffffffffffffffff){
    4cd8:	01250863          	beq	a0,s2,4ce8 <countfree+0x3c>
    *(char *)(a + 4096 - 1) = 1;
    4cdc:	6785                	lui	a5,0x1
    4cde:	953e                	add	a0,a0,a5
    4ce0:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x95>
    n += 1;
    4ce4:	2485                	addiw	s1,s1,1
  while(1){
    4ce6:	b7e5                	j	4cce <countfree+0x22>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    4ce8:	4501                	li	a0,0
    4cea:	00000097          	auipc	ra,0x0
    4cee:	5e6080e7          	jalr	1510(ra) # 52d0 <sbrk>
    4cf2:	40aa053b          	subw	a0,s4,a0
    4cf6:	00000097          	auipc	ra,0x0
    4cfa:	5da080e7          	jalr	1498(ra) # 52d0 <sbrk>
  return n;
}
    4cfe:	8526                	mv	a0,s1
    4d00:	70a2                	ld	ra,40(sp)
    4d02:	7402                	ld	s0,32(sp)
    4d04:	64e2                	ld	s1,24(sp)
    4d06:	6942                	ld	s2,16(sp)
    4d08:	69a2                	ld	s3,8(sp)
    4d0a:	6a02                	ld	s4,0(sp)
    4d0c:	6145                	addi	sp,sp,48
    4d0e:	8082                	ret

0000000000004d10 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4d10:	7179                	addi	sp,sp,-48
    4d12:	f406                	sd	ra,40(sp)
    4d14:	f022                	sd	s0,32(sp)
    4d16:	ec26                	sd	s1,24(sp)
    4d18:	e84a                	sd	s2,16(sp)
    4d1a:	1800                	addi	s0,sp,48
    4d1c:	84aa                	mv	s1,a0
    4d1e:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4d20:	00003517          	auipc	a0,0x3
    4d24:	b3850513          	addi	a0,a0,-1224 # 7858 <malloc+0x21d2>
    4d28:	00001097          	auipc	ra,0x1
    4d2c:	8a0080e7          	jalr	-1888(ra) # 55c8 <printf>
  if((pid = fork()) < 0) {
    4d30:	00000097          	auipc	ra,0x0
    4d34:	510080e7          	jalr	1296(ra) # 5240 <fork>
    4d38:	02054e63          	bltz	a0,4d74 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4d3c:	c929                	beqz	a0,4d8e <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4d3e:	fdc40513          	addi	a0,s0,-36
    4d42:	00000097          	auipc	ra,0x0
    4d46:	50e080e7          	jalr	1294(ra) # 5250 <wait>
    if(xstatus != 0) 
    4d4a:	fdc42783          	lw	a5,-36(s0)
    4d4e:	c7b9                	beqz	a5,4d9c <run+0x8c>
      printf("FAILED\n");
    4d50:	00003517          	auipc	a0,0x3
    4d54:	b3050513          	addi	a0,a0,-1232 # 7880 <malloc+0x21fa>
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	870080e7          	jalr	-1936(ra) # 55c8 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4d60:	fdc42503          	lw	a0,-36(s0)
  }
}
    4d64:	00153513          	seqz	a0,a0
    4d68:	70a2                	ld	ra,40(sp)
    4d6a:	7402                	ld	s0,32(sp)
    4d6c:	64e2                	ld	s1,24(sp)
    4d6e:	6942                	ld	s2,16(sp)
    4d70:	6145                	addi	sp,sp,48
    4d72:	8082                	ret
    printf("runtest: fork error\n");
    4d74:	00003517          	auipc	a0,0x3
    4d78:	af450513          	addi	a0,a0,-1292 # 7868 <malloc+0x21e2>
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	84c080e7          	jalr	-1972(ra) # 55c8 <printf>
    exit(1);
    4d84:	4505                	li	a0,1
    4d86:	00000097          	auipc	ra,0x0
    4d8a:	4c2080e7          	jalr	1218(ra) # 5248 <exit>
    f(s);
    4d8e:	854a                	mv	a0,s2
    4d90:	9482                	jalr	s1
    exit(0);
    4d92:	4501                	li	a0,0
    4d94:	00000097          	auipc	ra,0x0
    4d98:	4b4080e7          	jalr	1204(ra) # 5248 <exit>
      printf("OK\n");
    4d9c:	00003517          	auipc	a0,0x3
    4da0:	aec50513          	addi	a0,a0,-1300 # 7888 <malloc+0x2202>
    4da4:	00001097          	auipc	ra,0x1
    4da8:	824080e7          	jalr	-2012(ra) # 55c8 <printf>
    4dac:	bf55                	j	4d60 <run+0x50>

0000000000004dae <main>:

int
main(int argc, char *argv[])
{
    4dae:	c4010113          	addi	sp,sp,-960
    4db2:	3a113c23          	sd	ra,952(sp)
    4db6:	3a813823          	sd	s0,944(sp)
    4dba:	3a913423          	sd	s1,936(sp)
    4dbe:	3b213023          	sd	s2,928(sp)
    4dc2:	39313c23          	sd	s3,920(sp)
    4dc6:	39413823          	sd	s4,912(sp)
    4dca:	39513423          	sd	s5,904(sp)
    4dce:	39613023          	sd	s6,896(sp)
    4dd2:	0780                	addi	s0,sp,960
    4dd4:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4dd6:	4789                	li	a5,2
    4dd8:	08f50563          	beq	a0,a5,4e62 <main+0xb4>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4ddc:	4785                	li	a5,1
  char *justone = 0;
    4dde:	4901                	li	s2,0
  } else if(argc > 1){
    4de0:	0aa7cf63          	blt	a5,a0,4e9e <main+0xf0>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    4de4:	00003797          	auipc	a5,0x3
    4de8:	b8c78793          	addi	a5,a5,-1140 # 7970 <malloc+0x22ea>
    4dec:	c4040713          	addi	a4,s0,-960
    4df0:	00003817          	auipc	a6,0x3
    4df4:	f0080813          	addi	a6,a6,-256 # 7cf0 <malloc+0x266a>
    4df8:	6388                	ld	a0,0(a5)
    4dfa:	678c                	ld	a1,8(a5)
    4dfc:	6b90                	ld	a2,16(a5)
    4dfe:	6f94                	ld	a3,24(a5)
    4e00:	e308                	sd	a0,0(a4)
    4e02:	e70c                	sd	a1,8(a4)
    4e04:	eb10                	sd	a2,16(a4)
    4e06:	ef14                	sd	a3,24(a4)
    4e08:	02078793          	addi	a5,a5,32
    4e0c:	02070713          	addi	a4,a4,32
    4e10:	ff0794e3          	bne	a5,a6,4df8 <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    4e14:	00003517          	auipc	a0,0x3
    4e18:	afc50513          	addi	a0,a0,-1284 # 7910 <malloc+0x228a>
    4e1c:	00000097          	auipc	ra,0x0
    4e20:	7ac080e7          	jalr	1964(ra) # 55c8 <printf>
  int free0 = countfree();
    4e24:	00000097          	auipc	ra,0x0
    4e28:	e88080e7          	jalr	-376(ra) # 4cac <countfree>
    4e2c:	8aaa                	mv	s5,a0
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4e2e:	c4843503          	ld	a0,-952(s0)
    4e32:	c4040493          	addi	s1,s0,-960
  int fail = 0;
    4e36:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4e38:	4a05                	li	s4,1
  for (struct test *t = tests; t->s != 0; t++) {
    4e3a:	e15d                	bnez	a0,4ee0 <main+0x132>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if(countfree() < free0){
    4e3c:	00000097          	auipc	ra,0x0
    4e40:	e70080e7          	jalr	-400(ra) # 4cac <countfree>
    4e44:	0d555e63          	bge	a0,s5,4f20 <main+0x172>
    printf("FAILED -- lost some free pages\n");
    4e48:	00003517          	auipc	a0,0x3
    4e4c:	a7850513          	addi	a0,a0,-1416 # 78c0 <malloc+0x223a>
    4e50:	00000097          	auipc	ra,0x0
    4e54:	778080e7          	jalr	1912(ra) # 55c8 <printf>
    exit(1);
    4e58:	4505                	li	a0,1
    4e5a:	00000097          	auipc	ra,0x0
    4e5e:	3ee080e7          	jalr	1006(ra) # 5248 <exit>
    4e62:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4e64:	00003597          	auipc	a1,0x3
    4e68:	a2c58593          	addi	a1,a1,-1492 # 7890 <malloc+0x220a>
    4e6c:	6488                	ld	a0,8(s1)
    4e6e:	00000097          	auipc	ra,0x0
    4e72:	180080e7          	jalr	384(ra) # 4fee <strcmp>
    4e76:	10050363          	beqz	a0,4f7c <main+0x1ce>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4e7a:	00003597          	auipc	a1,0x3
    4e7e:	ace58593          	addi	a1,a1,-1330 # 7948 <malloc+0x22c2>
    4e82:	6488                	ld	a0,8(s1)
    4e84:	00000097          	auipc	ra,0x0
    4e88:	16a080e7          	jalr	362(ra) # 4fee <strcmp>
    4e8c:	c96d                	beqz	a0,4f7e <main+0x1d0>
  } else if(argc == 2 && argv[1][0] != '-'){
    4e8e:	0084b903          	ld	s2,8(s1)
    4e92:	00094703          	lbu	a4,0(s2)
    4e96:	02d00793          	li	a5,45
    4e9a:	f4f715e3          	bne	a4,a5,4de4 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    4e9e:	00003517          	auipc	a0,0x3
    4ea2:	9fa50513          	addi	a0,a0,-1542 # 7898 <malloc+0x2212>
    4ea6:	00000097          	auipc	ra,0x0
    4eaa:	722080e7          	jalr	1826(ra) # 55c8 <printf>
    exit(1);
    4eae:	4505                	li	a0,1
    4eb0:	00000097          	auipc	ra,0x0
    4eb4:	398080e7          	jalr	920(ra) # 5248 <exit>
          exit(1);
    4eb8:	4505                	li	a0,1
    4eba:	00000097          	auipc	ra,0x0
    4ebe:	38e080e7          	jalr	910(ra) # 5248 <exit>
        printf("FAILED -- lost some free pages\n");
    4ec2:	855a                	mv	a0,s6
    4ec4:	00000097          	auipc	ra,0x0
    4ec8:	704080e7          	jalr	1796(ra) # 55c8 <printf>
        if(continuous != 2)
    4ecc:	09498463          	beq	s3,s4,4f54 <main+0x1a6>
          exit(1);
    4ed0:	4505                	li	a0,1
    4ed2:	00000097          	auipc	ra,0x0
    4ed6:	376080e7          	jalr	886(ra) # 5248 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    4eda:	04c1                	addi	s1,s1,16
    4edc:	6488                	ld	a0,8(s1)
    4ede:	c115                	beqz	a0,4f02 <main+0x154>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4ee0:	00090863          	beqz	s2,4ef0 <main+0x142>
    4ee4:	85ca                	mv	a1,s2
    4ee6:	00000097          	auipc	ra,0x0
    4eea:	108080e7          	jalr	264(ra) # 4fee <strcmp>
    4eee:	f575                	bnez	a0,4eda <main+0x12c>
      if(!run(t->f, t->s))
    4ef0:	648c                	ld	a1,8(s1)
    4ef2:	6088                	ld	a0,0(s1)
    4ef4:	00000097          	auipc	ra,0x0
    4ef8:	e1c080e7          	jalr	-484(ra) # 4d10 <run>
    4efc:	fd79                	bnez	a0,4eda <main+0x12c>
        fail = 1;
    4efe:	89d2                	mv	s3,s4
    4f00:	bfe9                	j	4eda <main+0x12c>
  if(fail){
    4f02:	f2098de3          	beqz	s3,4e3c <main+0x8e>
    printf("SOME TESTS FAILED\n");
    4f06:	00003517          	auipc	a0,0x3
    4f0a:	9da50513          	addi	a0,a0,-1574 # 78e0 <malloc+0x225a>
    4f0e:	00000097          	auipc	ra,0x0
    4f12:	6ba080e7          	jalr	1722(ra) # 55c8 <printf>
    exit(1);
    4f16:	4505                	li	a0,1
    4f18:	00000097          	auipc	ra,0x0
    4f1c:	330080e7          	jalr	816(ra) # 5248 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    4f20:	00003517          	auipc	a0,0x3
    4f24:	9d850513          	addi	a0,a0,-1576 # 78f8 <malloc+0x2272>
    4f28:	00000097          	auipc	ra,0x0
    4f2c:	6a0080e7          	jalr	1696(ra) # 55c8 <printf>
    exit(0);
    4f30:	4501                	li	a0,0
    4f32:	00000097          	auipc	ra,0x0
    4f36:	316080e7          	jalr	790(ra) # 5248 <exit>
        printf("SOME TESTS FAILED\n");
    4f3a:	8556                	mv	a0,s5
    4f3c:	00000097          	auipc	ra,0x0
    4f40:	68c080e7          	jalr	1676(ra) # 55c8 <printf>
        if(continuous != 2)
    4f44:	f7499ae3          	bne	s3,s4,4eb8 <main+0x10a>
      int free1 = countfree();
    4f48:	00000097          	auipc	ra,0x0
    4f4c:	d64080e7          	jalr	-668(ra) # 4cac <countfree>
      if(free1 < free0){
    4f50:	f72549e3          	blt	a0,s2,4ec2 <main+0x114>
      int free0 = countfree();
    4f54:	00000097          	auipc	ra,0x0
    4f58:	d58080e7          	jalr	-680(ra) # 4cac <countfree>
    4f5c:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    4f5e:	c4843583          	ld	a1,-952(s0)
    4f62:	d1fd                	beqz	a1,4f48 <main+0x19a>
    4f64:	c4040493          	addi	s1,s0,-960
        if(!run(t->f, t->s)){
    4f68:	6088                	ld	a0,0(s1)
    4f6a:	00000097          	auipc	ra,0x0
    4f6e:	da6080e7          	jalr	-602(ra) # 4d10 <run>
    4f72:	d561                	beqz	a0,4f3a <main+0x18c>
      for (struct test *t = tests; t->s != 0; t++) {
    4f74:	04c1                	addi	s1,s1,16
    4f76:	648c                	ld	a1,8(s1)
    4f78:	f9e5                	bnez	a1,4f68 <main+0x1ba>
    4f7a:	b7f9                	j	4f48 <main+0x19a>
    continuous = 1;
    4f7c:	4985                	li	s3,1
  } tests[] = {
    4f7e:	00003797          	auipc	a5,0x3
    4f82:	9f278793          	addi	a5,a5,-1550 # 7970 <malloc+0x22ea>
    4f86:	c4040713          	addi	a4,s0,-960
    4f8a:	00003817          	auipc	a6,0x3
    4f8e:	d6680813          	addi	a6,a6,-666 # 7cf0 <malloc+0x266a>
    4f92:	6388                	ld	a0,0(a5)
    4f94:	678c                	ld	a1,8(a5)
    4f96:	6b90                	ld	a2,16(a5)
    4f98:	6f94                	ld	a3,24(a5)
    4f9a:	e308                	sd	a0,0(a4)
    4f9c:	e70c                	sd	a1,8(a4)
    4f9e:	eb10                	sd	a2,16(a4)
    4fa0:	ef14                	sd	a3,24(a4)
    4fa2:	02078793          	addi	a5,a5,32
    4fa6:	02070713          	addi	a4,a4,32
    4faa:	ff0794e3          	bne	a5,a6,4f92 <main+0x1e4>
    printf("continuous usertests starting\n");
    4fae:	00003517          	auipc	a0,0x3
    4fb2:	97a50513          	addi	a0,a0,-1670 # 7928 <malloc+0x22a2>
    4fb6:	00000097          	auipc	ra,0x0
    4fba:	612080e7          	jalr	1554(ra) # 55c8 <printf>
        printf("SOME TESTS FAILED\n");
    4fbe:	00003a97          	auipc	s5,0x3
    4fc2:	922a8a93          	addi	s5,s5,-1758 # 78e0 <malloc+0x225a>
        if(continuous != 2)
    4fc6:	4a09                	li	s4,2
        printf("FAILED -- lost some free pages\n");
    4fc8:	00003b17          	auipc	s6,0x3
    4fcc:	8f8b0b13          	addi	s6,s6,-1800 # 78c0 <malloc+0x223a>
    4fd0:	b751                	j	4f54 <main+0x1a6>

0000000000004fd2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    4fd2:	1141                	addi	sp,sp,-16
    4fd4:	e422                	sd	s0,8(sp)
    4fd6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4fd8:	87aa                	mv	a5,a0
    4fda:	0585                	addi	a1,a1,1
    4fdc:	0785                	addi	a5,a5,1
    4fde:	fff5c703          	lbu	a4,-1(a1)
    4fe2:	fee78fa3          	sb	a4,-1(a5)
    4fe6:	fb75                	bnez	a4,4fda <strcpy+0x8>
    ;
  return os;
}
    4fe8:	6422                	ld	s0,8(sp)
    4fea:	0141                	addi	sp,sp,16
    4fec:	8082                	ret

0000000000004fee <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4fee:	1141                	addi	sp,sp,-16
    4ff0:	e422                	sd	s0,8(sp)
    4ff2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4ff4:	00054783          	lbu	a5,0(a0)
    4ff8:	cb91                	beqz	a5,500c <strcmp+0x1e>
    4ffa:	0005c703          	lbu	a4,0(a1)
    4ffe:	00f71763          	bne	a4,a5,500c <strcmp+0x1e>
    p++, q++;
    5002:	0505                	addi	a0,a0,1
    5004:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5006:	00054783          	lbu	a5,0(a0)
    500a:	fbe5                	bnez	a5,4ffa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    500c:	0005c503          	lbu	a0,0(a1)
}
    5010:	40a7853b          	subw	a0,a5,a0
    5014:	6422                	ld	s0,8(sp)
    5016:	0141                	addi	sp,sp,16
    5018:	8082                	ret

000000000000501a <strlen>:

uint
strlen(const char *s)
{
    501a:	1141                	addi	sp,sp,-16
    501c:	e422                	sd	s0,8(sp)
    501e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5020:	00054783          	lbu	a5,0(a0)
    5024:	cf91                	beqz	a5,5040 <strlen+0x26>
    5026:	0505                	addi	a0,a0,1
    5028:	87aa                	mv	a5,a0
    502a:	4685                	li	a3,1
    502c:	9e89                	subw	a3,a3,a0
    502e:	00f6853b          	addw	a0,a3,a5
    5032:	0785                	addi	a5,a5,1
    5034:	fff7c703          	lbu	a4,-1(a5)
    5038:	fb7d                	bnez	a4,502e <strlen+0x14>
    ;
  return n;
}
    503a:	6422                	ld	s0,8(sp)
    503c:	0141                	addi	sp,sp,16
    503e:	8082                	ret
  for(n = 0; s[n]; n++)
    5040:	4501                	li	a0,0
    5042:	bfe5                	j	503a <strlen+0x20>

0000000000005044 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5044:	1141                	addi	sp,sp,-16
    5046:	e422                	sd	s0,8(sp)
    5048:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    504a:	ce09                	beqz	a2,5064 <memset+0x20>
    504c:	87aa                	mv	a5,a0
    504e:	fff6071b          	addiw	a4,a2,-1
    5052:	1702                	slli	a4,a4,0x20
    5054:	9301                	srli	a4,a4,0x20
    5056:	0705                	addi	a4,a4,1
    5058:	972a                	add	a4,a4,a0
    cdst[i] = c;
    505a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    505e:	0785                	addi	a5,a5,1
    5060:	fee79de3          	bne	a5,a4,505a <memset+0x16>
  }
  return dst;
}
    5064:	6422                	ld	s0,8(sp)
    5066:	0141                	addi	sp,sp,16
    5068:	8082                	ret

000000000000506a <strchr>:

char*
strchr(const char *s, char c)
{
    506a:	1141                	addi	sp,sp,-16
    506c:	e422                	sd	s0,8(sp)
    506e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5070:	00054783          	lbu	a5,0(a0)
    5074:	cb99                	beqz	a5,508a <strchr+0x20>
    if(*s == c)
    5076:	00f58763          	beq	a1,a5,5084 <strchr+0x1a>
  for(; *s; s++)
    507a:	0505                	addi	a0,a0,1
    507c:	00054783          	lbu	a5,0(a0)
    5080:	fbfd                	bnez	a5,5076 <strchr+0xc>
      return (char*)s;
  return 0;
    5082:	4501                	li	a0,0
}
    5084:	6422                	ld	s0,8(sp)
    5086:	0141                	addi	sp,sp,16
    5088:	8082                	ret
  return 0;
    508a:	4501                	li	a0,0
    508c:	bfe5                	j	5084 <strchr+0x1a>

000000000000508e <gets>:

char*
gets(char *buf, int max)
{
    508e:	711d                	addi	sp,sp,-96
    5090:	ec86                	sd	ra,88(sp)
    5092:	e8a2                	sd	s0,80(sp)
    5094:	e4a6                	sd	s1,72(sp)
    5096:	e0ca                	sd	s2,64(sp)
    5098:	fc4e                	sd	s3,56(sp)
    509a:	f852                	sd	s4,48(sp)
    509c:	f456                	sd	s5,40(sp)
    509e:	f05a                	sd	s6,32(sp)
    50a0:	ec5e                	sd	s7,24(sp)
    50a2:	1080                	addi	s0,sp,96
    50a4:	8baa                	mv	s7,a0
    50a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    50a8:	892a                	mv	s2,a0
    50aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    50ac:	4aa9                	li	s5,10
    50ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    50b0:	89a6                	mv	s3,s1
    50b2:	2485                	addiw	s1,s1,1
    50b4:	0344d863          	bge	s1,s4,50e4 <gets+0x56>
    cc = read(0, &c, 1);
    50b8:	4605                	li	a2,1
    50ba:	faf40593          	addi	a1,s0,-81
    50be:	4501                	li	a0,0
    50c0:	00000097          	auipc	ra,0x0
    50c4:	1a0080e7          	jalr	416(ra) # 5260 <read>
    if(cc < 1)
    50c8:	00a05e63          	blez	a0,50e4 <gets+0x56>
    buf[i++] = c;
    50cc:	faf44783          	lbu	a5,-81(s0)
    50d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    50d4:	01578763          	beq	a5,s5,50e2 <gets+0x54>
    50d8:	0905                	addi	s2,s2,1
    50da:	fd679be3          	bne	a5,s6,50b0 <gets+0x22>
  for(i=0; i+1 < max; ){
    50de:	89a6                	mv	s3,s1
    50e0:	a011                	j	50e4 <gets+0x56>
    50e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    50e4:	99de                	add	s3,s3,s7
    50e6:	00098023          	sb	zero,0(s3)
  return buf;
}
    50ea:	855e                	mv	a0,s7
    50ec:	60e6                	ld	ra,88(sp)
    50ee:	6446                	ld	s0,80(sp)
    50f0:	64a6                	ld	s1,72(sp)
    50f2:	6906                	ld	s2,64(sp)
    50f4:	79e2                	ld	s3,56(sp)
    50f6:	7a42                	ld	s4,48(sp)
    50f8:	7aa2                	ld	s5,40(sp)
    50fa:	7b02                	ld	s6,32(sp)
    50fc:	6be2                	ld	s7,24(sp)
    50fe:	6125                	addi	sp,sp,96
    5100:	8082                	ret

0000000000005102 <stat>:

int
stat(const char *n, struct stat *st)
{
    5102:	1101                	addi	sp,sp,-32
    5104:	ec06                	sd	ra,24(sp)
    5106:	e822                	sd	s0,16(sp)
    5108:	e426                	sd	s1,8(sp)
    510a:	e04a                	sd	s2,0(sp)
    510c:	1000                	addi	s0,sp,32
    510e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5110:	4581                	li	a1,0
    5112:	00000097          	auipc	ra,0x0
    5116:	176080e7          	jalr	374(ra) # 5288 <open>
  if(fd < 0)
    511a:	02054563          	bltz	a0,5144 <stat+0x42>
    511e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5120:	85ca                	mv	a1,s2
    5122:	00000097          	auipc	ra,0x0
    5126:	17e080e7          	jalr	382(ra) # 52a0 <fstat>
    512a:	892a                	mv	s2,a0
  close(fd);
    512c:	8526                	mv	a0,s1
    512e:	00000097          	auipc	ra,0x0
    5132:	142080e7          	jalr	322(ra) # 5270 <close>
  return r;
}
    5136:	854a                	mv	a0,s2
    5138:	60e2                	ld	ra,24(sp)
    513a:	6442                	ld	s0,16(sp)
    513c:	64a2                	ld	s1,8(sp)
    513e:	6902                	ld	s2,0(sp)
    5140:	6105                	addi	sp,sp,32
    5142:	8082                	ret
    return -1;
    5144:	597d                	li	s2,-1
    5146:	bfc5                	j	5136 <stat+0x34>

0000000000005148 <atoi>:

int
atoi(const char *s)
{
    5148:	1141                	addi	sp,sp,-16
    514a:	e422                	sd	s0,8(sp)
    514c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    514e:	00054603          	lbu	a2,0(a0)
    5152:	fd06079b          	addiw	a5,a2,-48
    5156:	0ff7f793          	andi	a5,a5,255
    515a:	4725                	li	a4,9
    515c:	02f76963          	bltu	a4,a5,518e <atoi+0x46>
    5160:	86aa                	mv	a3,a0
  n = 0;
    5162:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5164:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5166:	0685                	addi	a3,a3,1
    5168:	0025179b          	slliw	a5,a0,0x2
    516c:	9fa9                	addw	a5,a5,a0
    516e:	0017979b          	slliw	a5,a5,0x1
    5172:	9fb1                	addw	a5,a5,a2
    5174:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5178:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x96>
    517c:	fd06071b          	addiw	a4,a2,-48
    5180:	0ff77713          	andi	a4,a4,255
    5184:	fee5f1e3          	bgeu	a1,a4,5166 <atoi+0x1e>
  return n;
}
    5188:	6422                	ld	s0,8(sp)
    518a:	0141                	addi	sp,sp,16
    518c:	8082                	ret
  n = 0;
    518e:	4501                	li	a0,0
    5190:	bfe5                	j	5188 <atoi+0x40>

0000000000005192 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5192:	1141                	addi	sp,sp,-16
    5194:	e422                	sd	s0,8(sp)
    5196:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5198:	02b57663          	bgeu	a0,a1,51c4 <memmove+0x32>
    while(n-- > 0)
    519c:	02c05163          	blez	a2,51be <memmove+0x2c>
    51a0:	fff6079b          	addiw	a5,a2,-1
    51a4:	1782                	slli	a5,a5,0x20
    51a6:	9381                	srli	a5,a5,0x20
    51a8:	0785                	addi	a5,a5,1
    51aa:	97aa                	add	a5,a5,a0
  dst = vdst;
    51ac:	872a                	mv	a4,a0
      *dst++ = *src++;
    51ae:	0585                	addi	a1,a1,1
    51b0:	0705                	addi	a4,a4,1
    51b2:	fff5c683          	lbu	a3,-1(a1)
    51b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    51ba:	fee79ae3          	bne	a5,a4,51ae <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    51be:	6422                	ld	s0,8(sp)
    51c0:	0141                	addi	sp,sp,16
    51c2:	8082                	ret
    dst += n;
    51c4:	00c50733          	add	a4,a0,a2
    src += n;
    51c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    51ca:	fec05ae3          	blez	a2,51be <memmove+0x2c>
    51ce:	fff6079b          	addiw	a5,a2,-1
    51d2:	1782                	slli	a5,a5,0x20
    51d4:	9381                	srli	a5,a5,0x20
    51d6:	fff7c793          	not	a5,a5
    51da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    51dc:	15fd                	addi	a1,a1,-1
    51de:	177d                	addi	a4,a4,-1
    51e0:	0005c683          	lbu	a3,0(a1)
    51e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    51e8:	fee79ae3          	bne	a5,a4,51dc <memmove+0x4a>
    51ec:	bfc9                	j	51be <memmove+0x2c>

00000000000051ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    51ee:	1141                	addi	sp,sp,-16
    51f0:	e422                	sd	s0,8(sp)
    51f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    51f4:	ca05                	beqz	a2,5224 <memcmp+0x36>
    51f6:	fff6069b          	addiw	a3,a2,-1
    51fa:	1682                	slli	a3,a3,0x20
    51fc:	9281                	srli	a3,a3,0x20
    51fe:	0685                	addi	a3,a3,1
    5200:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5202:	00054783          	lbu	a5,0(a0)
    5206:	0005c703          	lbu	a4,0(a1)
    520a:	00e79863          	bne	a5,a4,521a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    520e:	0505                	addi	a0,a0,1
    p2++;
    5210:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5212:	fed518e3          	bne	a0,a3,5202 <memcmp+0x14>
  }
  return 0;
    5216:	4501                	li	a0,0
    5218:	a019                	j	521e <memcmp+0x30>
      return *p1 - *p2;
    521a:	40e7853b          	subw	a0,a5,a4
}
    521e:	6422                	ld	s0,8(sp)
    5220:	0141                	addi	sp,sp,16
    5222:	8082                	ret
  return 0;
    5224:	4501                	li	a0,0
    5226:	bfe5                	j	521e <memcmp+0x30>

0000000000005228 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5228:	1141                	addi	sp,sp,-16
    522a:	e406                	sd	ra,8(sp)
    522c:	e022                	sd	s0,0(sp)
    522e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5230:	00000097          	auipc	ra,0x0
    5234:	f62080e7          	jalr	-158(ra) # 5192 <memmove>
}
    5238:	60a2                	ld	ra,8(sp)
    523a:	6402                	ld	s0,0(sp)
    523c:	0141                	addi	sp,sp,16
    523e:	8082                	ret

0000000000005240 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5240:	4885                	li	a7,1
 ecall
    5242:	00000073          	ecall
 ret
    5246:	8082                	ret

0000000000005248 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5248:	4889                	li	a7,2
 ecall
    524a:	00000073          	ecall
 ret
    524e:	8082                	ret

0000000000005250 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5250:	488d                	li	a7,3
 ecall
    5252:	00000073          	ecall
 ret
    5256:	8082                	ret

0000000000005258 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5258:	4891                	li	a7,4
 ecall
    525a:	00000073          	ecall
 ret
    525e:	8082                	ret

0000000000005260 <read>:
.global read
read:
 li a7, SYS_read
    5260:	4895                	li	a7,5
 ecall
    5262:	00000073          	ecall
 ret
    5266:	8082                	ret

0000000000005268 <write>:
.global write
write:
 li a7, SYS_write
    5268:	48c1                	li	a7,16
 ecall
    526a:	00000073          	ecall
 ret
    526e:	8082                	ret

0000000000005270 <close>:
.global close
close:
 li a7, SYS_close
    5270:	48d5                	li	a7,21
 ecall
    5272:	00000073          	ecall
 ret
    5276:	8082                	ret

0000000000005278 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5278:	4899                	li	a7,6
 ecall
    527a:	00000073          	ecall
 ret
    527e:	8082                	ret

0000000000005280 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5280:	489d                	li	a7,7
 ecall
    5282:	00000073          	ecall
 ret
    5286:	8082                	ret

0000000000005288 <open>:
.global open
open:
 li a7, SYS_open
    5288:	48bd                	li	a7,15
 ecall
    528a:	00000073          	ecall
 ret
    528e:	8082                	ret

0000000000005290 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5290:	48c5                	li	a7,17
 ecall
    5292:	00000073          	ecall
 ret
    5296:	8082                	ret

0000000000005298 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5298:	48c9                	li	a7,18
 ecall
    529a:	00000073          	ecall
 ret
    529e:	8082                	ret

00000000000052a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    52a0:	48a1                	li	a7,8
 ecall
    52a2:	00000073          	ecall
 ret
    52a6:	8082                	ret

00000000000052a8 <link>:
.global link
link:
 li a7, SYS_link
    52a8:	48cd                	li	a7,19
 ecall
    52aa:	00000073          	ecall
 ret
    52ae:	8082                	ret

00000000000052b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    52b0:	48d1                	li	a7,20
 ecall
    52b2:	00000073          	ecall
 ret
    52b6:	8082                	ret

00000000000052b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    52b8:	48a5                	li	a7,9
 ecall
    52ba:	00000073          	ecall
 ret
    52be:	8082                	ret

00000000000052c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
    52c0:	48a9                	li	a7,10
 ecall
    52c2:	00000073          	ecall
 ret
    52c6:	8082                	ret

00000000000052c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    52c8:	48ad                	li	a7,11
 ecall
    52ca:	00000073          	ecall
 ret
    52ce:	8082                	ret

00000000000052d0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    52d0:	48b1                	li	a7,12
 ecall
    52d2:	00000073          	ecall
 ret
    52d6:	8082                	ret

00000000000052d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    52d8:	48b5                	li	a7,13
 ecall
    52da:	00000073          	ecall
 ret
    52de:	8082                	ret

00000000000052e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    52e0:	48b9                	li	a7,14
 ecall
    52e2:	00000073          	ecall
 ret
    52e6:	8082                	ret

00000000000052e8 <numprocs>:
.global numprocs
numprocs:
 li a7, SYS_numprocs
    52e8:	48d9                	li	a7,22
 ecall
    52ea:	00000073          	ecall
 ret
    52ee:	8082                	ret

00000000000052f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    52f0:	1101                	addi	sp,sp,-32
    52f2:	ec06                	sd	ra,24(sp)
    52f4:	e822                	sd	s0,16(sp)
    52f6:	1000                	addi	s0,sp,32
    52f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    52fc:	4605                	li	a2,1
    52fe:	fef40593          	addi	a1,s0,-17
    5302:	00000097          	auipc	ra,0x0
    5306:	f66080e7          	jalr	-154(ra) # 5268 <write>
}
    530a:	60e2                	ld	ra,24(sp)
    530c:	6442                	ld	s0,16(sp)
    530e:	6105                	addi	sp,sp,32
    5310:	8082                	ret

0000000000005312 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5312:	7139                	addi	sp,sp,-64
    5314:	fc06                	sd	ra,56(sp)
    5316:	f822                	sd	s0,48(sp)
    5318:	f426                	sd	s1,40(sp)
    531a:	f04a                	sd	s2,32(sp)
    531c:	ec4e                	sd	s3,24(sp)
    531e:	0080                	addi	s0,sp,64
    5320:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5322:	c299                	beqz	a3,5328 <printint+0x16>
    5324:	0805c863          	bltz	a1,53b4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5328:	2581                	sext.w	a1,a1
  neg = 0;
    532a:	4881                	li	a7,0
    532c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5330:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5332:	2601                	sext.w	a2,a2
    5334:	00003517          	auipc	a0,0x3
    5338:	9c450513          	addi	a0,a0,-1596 # 7cf8 <digits>
    533c:	883a                	mv	a6,a4
    533e:	2705                	addiw	a4,a4,1
    5340:	02c5f7bb          	remuw	a5,a1,a2
    5344:	1782                	slli	a5,a5,0x20
    5346:	9381                	srli	a5,a5,0x20
    5348:	97aa                	add	a5,a5,a0
    534a:	0007c783          	lbu	a5,0(a5)
    534e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5352:	0005879b          	sext.w	a5,a1
    5356:	02c5d5bb          	divuw	a1,a1,a2
    535a:	0685                	addi	a3,a3,1
    535c:	fec7f0e3          	bgeu	a5,a2,533c <printint+0x2a>
  if(neg)
    5360:	00088b63          	beqz	a7,5376 <printint+0x64>
    buf[i++] = '-';
    5364:	fd040793          	addi	a5,s0,-48
    5368:	973e                	add	a4,a4,a5
    536a:	02d00793          	li	a5,45
    536e:	fef70823          	sb	a5,-16(a4)
    5372:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5376:	02e05863          	blez	a4,53a6 <printint+0x94>
    537a:	fc040793          	addi	a5,s0,-64
    537e:	00e78933          	add	s2,a5,a4
    5382:	fff78993          	addi	s3,a5,-1
    5386:	99ba                	add	s3,s3,a4
    5388:	377d                	addiw	a4,a4,-1
    538a:	1702                	slli	a4,a4,0x20
    538c:	9301                	srli	a4,a4,0x20
    538e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5392:	fff94583          	lbu	a1,-1(s2)
    5396:	8526                	mv	a0,s1
    5398:	00000097          	auipc	ra,0x0
    539c:	f58080e7          	jalr	-168(ra) # 52f0 <putc>
  while(--i >= 0)
    53a0:	197d                	addi	s2,s2,-1
    53a2:	ff3918e3          	bne	s2,s3,5392 <printint+0x80>
}
    53a6:	70e2                	ld	ra,56(sp)
    53a8:	7442                	ld	s0,48(sp)
    53aa:	74a2                	ld	s1,40(sp)
    53ac:	7902                	ld	s2,32(sp)
    53ae:	69e2                	ld	s3,24(sp)
    53b0:	6121                	addi	sp,sp,64
    53b2:	8082                	ret
    x = -xx;
    53b4:	40b005bb          	negw	a1,a1
    neg = 1;
    53b8:	4885                	li	a7,1
    x = -xx;
    53ba:	bf8d                	j	532c <printint+0x1a>

00000000000053bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    53bc:	7119                	addi	sp,sp,-128
    53be:	fc86                	sd	ra,120(sp)
    53c0:	f8a2                	sd	s0,112(sp)
    53c2:	f4a6                	sd	s1,104(sp)
    53c4:	f0ca                	sd	s2,96(sp)
    53c6:	ecce                	sd	s3,88(sp)
    53c8:	e8d2                	sd	s4,80(sp)
    53ca:	e4d6                	sd	s5,72(sp)
    53cc:	e0da                	sd	s6,64(sp)
    53ce:	fc5e                	sd	s7,56(sp)
    53d0:	f862                	sd	s8,48(sp)
    53d2:	f466                	sd	s9,40(sp)
    53d4:	f06a                	sd	s10,32(sp)
    53d6:	ec6e                	sd	s11,24(sp)
    53d8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    53da:	0005c903          	lbu	s2,0(a1)
    53de:	18090f63          	beqz	s2,557c <vprintf+0x1c0>
    53e2:	8aaa                	mv	s5,a0
    53e4:	8b32                	mv	s6,a2
    53e6:	00158493          	addi	s1,a1,1
  state = 0;
    53ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    53ec:	02500a13          	li	s4,37
      if(c == 'd'){
    53f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    53f4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    53f8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    53fc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5400:	00003b97          	auipc	s7,0x3
    5404:	8f8b8b93          	addi	s7,s7,-1800 # 7cf8 <digits>
    5408:	a839                	j	5426 <vprintf+0x6a>
        putc(fd, c);
    540a:	85ca                	mv	a1,s2
    540c:	8556                	mv	a0,s5
    540e:	00000097          	auipc	ra,0x0
    5412:	ee2080e7          	jalr	-286(ra) # 52f0 <putc>
    5416:	a019                	j	541c <vprintf+0x60>
    } else if(state == '%'){
    5418:	01498f63          	beq	s3,s4,5436 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    541c:	0485                	addi	s1,s1,1
    541e:	fff4c903          	lbu	s2,-1(s1)
    5422:	14090d63          	beqz	s2,557c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5426:	0009079b          	sext.w	a5,s2
    if(state == 0){
    542a:	fe0997e3          	bnez	s3,5418 <vprintf+0x5c>
      if(c == '%'){
    542e:	fd479ee3          	bne	a5,s4,540a <vprintf+0x4e>
        state = '%';
    5432:	89be                	mv	s3,a5
    5434:	b7e5                	j	541c <vprintf+0x60>
      if(c == 'd'){
    5436:	05878063          	beq	a5,s8,5476 <vprintf+0xba>
      } else if(c == 'l') {
    543a:	05978c63          	beq	a5,s9,5492 <vprintf+0xd6>
      } else if(c == 'x') {
    543e:	07a78863          	beq	a5,s10,54ae <vprintf+0xf2>
      } else if(c == 'p') {
    5442:	09b78463          	beq	a5,s11,54ca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5446:	07300713          	li	a4,115
    544a:	0ce78663          	beq	a5,a4,5516 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    544e:	06300713          	li	a4,99
    5452:	0ee78e63          	beq	a5,a4,554e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5456:	11478863          	beq	a5,s4,5566 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    545a:	85d2                	mv	a1,s4
    545c:	8556                	mv	a0,s5
    545e:	00000097          	auipc	ra,0x0
    5462:	e92080e7          	jalr	-366(ra) # 52f0 <putc>
        putc(fd, c);
    5466:	85ca                	mv	a1,s2
    5468:	8556                	mv	a0,s5
    546a:	00000097          	auipc	ra,0x0
    546e:	e86080e7          	jalr	-378(ra) # 52f0 <putc>
      }
      state = 0;
    5472:	4981                	li	s3,0
    5474:	b765                	j	541c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5476:	008b0913          	addi	s2,s6,8
    547a:	4685                	li	a3,1
    547c:	4629                	li	a2,10
    547e:	000b2583          	lw	a1,0(s6)
    5482:	8556                	mv	a0,s5
    5484:	00000097          	auipc	ra,0x0
    5488:	e8e080e7          	jalr	-370(ra) # 5312 <printint>
    548c:	8b4a                	mv	s6,s2
      state = 0;
    548e:	4981                	li	s3,0
    5490:	b771                	j	541c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5492:	008b0913          	addi	s2,s6,8
    5496:	4681                	li	a3,0
    5498:	4629                	li	a2,10
    549a:	000b2583          	lw	a1,0(s6)
    549e:	8556                	mv	a0,s5
    54a0:	00000097          	auipc	ra,0x0
    54a4:	e72080e7          	jalr	-398(ra) # 5312 <printint>
    54a8:	8b4a                	mv	s6,s2
      state = 0;
    54aa:	4981                	li	s3,0
    54ac:	bf85                	j	541c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    54ae:	008b0913          	addi	s2,s6,8
    54b2:	4681                	li	a3,0
    54b4:	4641                	li	a2,16
    54b6:	000b2583          	lw	a1,0(s6)
    54ba:	8556                	mv	a0,s5
    54bc:	00000097          	auipc	ra,0x0
    54c0:	e56080e7          	jalr	-426(ra) # 5312 <printint>
    54c4:	8b4a                	mv	s6,s2
      state = 0;
    54c6:	4981                	li	s3,0
    54c8:	bf91                	j	541c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    54ca:	008b0793          	addi	a5,s6,8
    54ce:	f8f43423          	sd	a5,-120(s0)
    54d2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    54d6:	03000593          	li	a1,48
    54da:	8556                	mv	a0,s5
    54dc:	00000097          	auipc	ra,0x0
    54e0:	e14080e7          	jalr	-492(ra) # 52f0 <putc>
  putc(fd, 'x');
    54e4:	85ea                	mv	a1,s10
    54e6:	8556                	mv	a0,s5
    54e8:	00000097          	auipc	ra,0x0
    54ec:	e08080e7          	jalr	-504(ra) # 52f0 <putc>
    54f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    54f2:	03c9d793          	srli	a5,s3,0x3c
    54f6:	97de                	add	a5,a5,s7
    54f8:	0007c583          	lbu	a1,0(a5)
    54fc:	8556                	mv	a0,s5
    54fe:	00000097          	auipc	ra,0x0
    5502:	df2080e7          	jalr	-526(ra) # 52f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5506:	0992                	slli	s3,s3,0x4
    5508:	397d                	addiw	s2,s2,-1
    550a:	fe0914e3          	bnez	s2,54f2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    550e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5512:	4981                	li	s3,0
    5514:	b721                	j	541c <vprintf+0x60>
        s = va_arg(ap, char*);
    5516:	008b0993          	addi	s3,s6,8
    551a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    551e:	02090163          	beqz	s2,5540 <vprintf+0x184>
        while(*s != 0){
    5522:	00094583          	lbu	a1,0(s2)
    5526:	c9a1                	beqz	a1,5576 <vprintf+0x1ba>
          putc(fd, *s);
    5528:	8556                	mv	a0,s5
    552a:	00000097          	auipc	ra,0x0
    552e:	dc6080e7          	jalr	-570(ra) # 52f0 <putc>
          s++;
    5532:	0905                	addi	s2,s2,1
        while(*s != 0){
    5534:	00094583          	lbu	a1,0(s2)
    5538:	f9e5                	bnez	a1,5528 <vprintf+0x16c>
        s = va_arg(ap, char*);
    553a:	8b4e                	mv	s6,s3
      state = 0;
    553c:	4981                	li	s3,0
    553e:	bdf9                	j	541c <vprintf+0x60>
          s = "(null)";
    5540:	00002917          	auipc	s2,0x2
    5544:	7b090913          	addi	s2,s2,1968 # 7cf0 <malloc+0x266a>
        while(*s != 0){
    5548:	02800593          	li	a1,40
    554c:	bff1                	j	5528 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    554e:	008b0913          	addi	s2,s6,8
    5552:	000b4583          	lbu	a1,0(s6)
    5556:	8556                	mv	a0,s5
    5558:	00000097          	auipc	ra,0x0
    555c:	d98080e7          	jalr	-616(ra) # 52f0 <putc>
    5560:	8b4a                	mv	s6,s2
      state = 0;
    5562:	4981                	li	s3,0
    5564:	bd65                	j	541c <vprintf+0x60>
        putc(fd, c);
    5566:	85d2                	mv	a1,s4
    5568:	8556                	mv	a0,s5
    556a:	00000097          	auipc	ra,0x0
    556e:	d86080e7          	jalr	-634(ra) # 52f0 <putc>
      state = 0;
    5572:	4981                	li	s3,0
    5574:	b565                	j	541c <vprintf+0x60>
        s = va_arg(ap, char*);
    5576:	8b4e                	mv	s6,s3
      state = 0;
    5578:	4981                	li	s3,0
    557a:	b54d                	j	541c <vprintf+0x60>
    }
  }
}
    557c:	70e6                	ld	ra,120(sp)
    557e:	7446                	ld	s0,112(sp)
    5580:	74a6                	ld	s1,104(sp)
    5582:	7906                	ld	s2,96(sp)
    5584:	69e6                	ld	s3,88(sp)
    5586:	6a46                	ld	s4,80(sp)
    5588:	6aa6                	ld	s5,72(sp)
    558a:	6b06                	ld	s6,64(sp)
    558c:	7be2                	ld	s7,56(sp)
    558e:	7c42                	ld	s8,48(sp)
    5590:	7ca2                	ld	s9,40(sp)
    5592:	7d02                	ld	s10,32(sp)
    5594:	6de2                	ld	s11,24(sp)
    5596:	6109                	addi	sp,sp,128
    5598:	8082                	ret

000000000000559a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    559a:	715d                	addi	sp,sp,-80
    559c:	ec06                	sd	ra,24(sp)
    559e:	e822                	sd	s0,16(sp)
    55a0:	1000                	addi	s0,sp,32
    55a2:	e010                	sd	a2,0(s0)
    55a4:	e414                	sd	a3,8(s0)
    55a6:	e818                	sd	a4,16(s0)
    55a8:	ec1c                	sd	a5,24(s0)
    55aa:	03043023          	sd	a6,32(s0)
    55ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    55b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    55b6:	8622                	mv	a2,s0
    55b8:	00000097          	auipc	ra,0x0
    55bc:	e04080e7          	jalr	-508(ra) # 53bc <vprintf>
}
    55c0:	60e2                	ld	ra,24(sp)
    55c2:	6442                	ld	s0,16(sp)
    55c4:	6161                	addi	sp,sp,80
    55c6:	8082                	ret

00000000000055c8 <printf>:

void
printf(const char *fmt, ...)
{
    55c8:	711d                	addi	sp,sp,-96
    55ca:	ec06                	sd	ra,24(sp)
    55cc:	e822                	sd	s0,16(sp)
    55ce:	1000                	addi	s0,sp,32
    55d0:	e40c                	sd	a1,8(s0)
    55d2:	e810                	sd	a2,16(s0)
    55d4:	ec14                	sd	a3,24(s0)
    55d6:	f018                	sd	a4,32(s0)
    55d8:	f41c                	sd	a5,40(s0)
    55da:	03043823          	sd	a6,48(s0)
    55de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    55e2:	00840613          	addi	a2,s0,8
    55e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    55ea:	85aa                	mv	a1,a0
    55ec:	4505                	li	a0,1
    55ee:	00000097          	auipc	ra,0x0
    55f2:	dce080e7          	jalr	-562(ra) # 53bc <vprintf>
}
    55f6:	60e2                	ld	ra,24(sp)
    55f8:	6442                	ld	s0,16(sp)
    55fa:	6125                	addi	sp,sp,96
    55fc:	8082                	ret

00000000000055fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    55fe:	1141                	addi	sp,sp,-16
    5600:	e422                	sd	s0,8(sp)
    5602:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5604:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5608:	00002797          	auipc	a5,0x2
    560c:	7207b783          	ld	a5,1824(a5) # 7d28 <freep>
    5610:	a805                	j	5640 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5612:	4618                	lw	a4,8(a2)
    5614:	9db9                	addw	a1,a1,a4
    5616:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    561a:	6398                	ld	a4,0(a5)
    561c:	6318                	ld	a4,0(a4)
    561e:	fee53823          	sd	a4,-16(a0)
    5622:	a091                	j	5666 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5624:	ff852703          	lw	a4,-8(a0)
    5628:	9e39                	addw	a2,a2,a4
    562a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    562c:	ff053703          	ld	a4,-16(a0)
    5630:	e398                	sd	a4,0(a5)
    5632:	a099                	j	5678 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5634:	6398                	ld	a4,0(a5)
    5636:	00e7e463          	bltu	a5,a4,563e <free+0x40>
    563a:	00e6ea63          	bltu	a3,a4,564e <free+0x50>
{
    563e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5640:	fed7fae3          	bgeu	a5,a3,5634 <free+0x36>
    5644:	6398                	ld	a4,0(a5)
    5646:	00e6e463          	bltu	a3,a4,564e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    564a:	fee7eae3          	bltu	a5,a4,563e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    564e:	ff852583          	lw	a1,-8(a0)
    5652:	6390                	ld	a2,0(a5)
    5654:	02059713          	slli	a4,a1,0x20
    5658:	9301                	srli	a4,a4,0x20
    565a:	0712                	slli	a4,a4,0x4
    565c:	9736                	add	a4,a4,a3
    565e:	fae60ae3          	beq	a2,a4,5612 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5662:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5666:	4790                	lw	a2,8(a5)
    5668:	02061713          	slli	a4,a2,0x20
    566c:	9301                	srli	a4,a4,0x20
    566e:	0712                	slli	a4,a4,0x4
    5670:	973e                	add	a4,a4,a5
    5672:	fae689e3          	beq	a3,a4,5624 <free+0x26>
  } else
    p->s.ptr = bp;
    5676:	e394                	sd	a3,0(a5)
  freep = p;
    5678:	00002717          	auipc	a4,0x2
    567c:	6af73823          	sd	a5,1712(a4) # 7d28 <freep>
}
    5680:	6422                	ld	s0,8(sp)
    5682:	0141                	addi	sp,sp,16
    5684:	8082                	ret

0000000000005686 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5686:	7139                	addi	sp,sp,-64
    5688:	fc06                	sd	ra,56(sp)
    568a:	f822                	sd	s0,48(sp)
    568c:	f426                	sd	s1,40(sp)
    568e:	f04a                	sd	s2,32(sp)
    5690:	ec4e                	sd	s3,24(sp)
    5692:	e852                	sd	s4,16(sp)
    5694:	e456                	sd	s5,8(sp)
    5696:	e05a                	sd	s6,0(sp)
    5698:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    569a:	02051493          	slli	s1,a0,0x20
    569e:	9081                	srli	s1,s1,0x20
    56a0:	04bd                	addi	s1,s1,15
    56a2:	8091                	srli	s1,s1,0x4
    56a4:	0014899b          	addiw	s3,s1,1
    56a8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    56aa:	00002517          	auipc	a0,0x2
    56ae:	67e53503          	ld	a0,1662(a0) # 7d28 <freep>
    56b2:	c515                	beqz	a0,56de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    56b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    56b6:	4798                	lw	a4,8(a5)
    56b8:	02977f63          	bgeu	a4,s1,56f6 <malloc+0x70>
    56bc:	8a4e                	mv	s4,s3
    56be:	0009871b          	sext.w	a4,s3
    56c2:	6685                	lui	a3,0x1
    56c4:	00d77363          	bgeu	a4,a3,56ca <malloc+0x44>
    56c8:	6a05                	lui	s4,0x1
    56ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    56ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    56d2:	00002917          	auipc	s2,0x2
    56d6:	65690913          	addi	s2,s2,1622 # 7d28 <freep>
  if(p == (char*)-1)
    56da:	5afd                	li	s5,-1
    56dc:	a88d                	j	574e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    56de:	00009797          	auipc	a5,0x9
    56e2:	e6a78793          	addi	a5,a5,-406 # e548 <base>
    56e6:	00002717          	auipc	a4,0x2
    56ea:	64f73123          	sd	a5,1602(a4) # 7d28 <freep>
    56ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    56f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    56f4:	b7e1                	j	56bc <malloc+0x36>
      if(p->s.size == nunits)
    56f6:	02e48b63          	beq	s1,a4,572c <malloc+0xa6>
        p->s.size -= nunits;
    56fa:	4137073b          	subw	a4,a4,s3
    56fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5700:	1702                	slli	a4,a4,0x20
    5702:	9301                	srli	a4,a4,0x20
    5704:	0712                	slli	a4,a4,0x4
    5706:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5708:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    570c:	00002717          	auipc	a4,0x2
    5710:	60a73e23          	sd	a0,1564(a4) # 7d28 <freep>
      return (void*)(p + 1);
    5714:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5718:	70e2                	ld	ra,56(sp)
    571a:	7442                	ld	s0,48(sp)
    571c:	74a2                	ld	s1,40(sp)
    571e:	7902                	ld	s2,32(sp)
    5720:	69e2                	ld	s3,24(sp)
    5722:	6a42                	ld	s4,16(sp)
    5724:	6aa2                	ld	s5,8(sp)
    5726:	6b02                	ld	s6,0(sp)
    5728:	6121                	addi	sp,sp,64
    572a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    572c:	6398                	ld	a4,0(a5)
    572e:	e118                	sd	a4,0(a0)
    5730:	bff1                	j	570c <malloc+0x86>
  hp->s.size = nu;
    5732:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5736:	0541                	addi	a0,a0,16
    5738:	00000097          	auipc	ra,0x0
    573c:	ec6080e7          	jalr	-314(ra) # 55fe <free>
  return freep;
    5740:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5744:	d971                	beqz	a0,5718 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5746:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5748:	4798                	lw	a4,8(a5)
    574a:	fa9776e3          	bgeu	a4,s1,56f6 <malloc+0x70>
    if(p == freep)
    574e:	00093703          	ld	a4,0(s2)
    5752:	853e                	mv	a0,a5
    5754:	fef719e3          	bne	a4,a5,5746 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5758:	8552                	mv	a0,s4
    575a:	00000097          	auipc	ra,0x0
    575e:	b76080e7          	jalr	-1162(ra) # 52d0 <sbrk>
  if(p == (char*)-1)
    5762:	fd5518e3          	bne	a0,s5,5732 <malloc+0xac>
        return 0;
    5766:	4501                	li	a0,0
    5768:	bf45                	j	5718 <malloc+0x92>
