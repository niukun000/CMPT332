
# Kun Niu
# kun869



# Boru sun, 
# bos226, 
# 11233036



CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu99 -Wall -pedantic
INCLUDES = -I/student/cmpt332/pthreads -I.
LFLAGS = -L/student/cmpt332/pthreads/lib/Linuxx86_64 -L.
PA1LIBS = -lpthreads
PA2LIBS = -lpthread


#sample-linux: sample-linux.o linux-lib.o
#	ar -rcs liblinux-lib.a linux-lib.o
#	$(CC) sample-linux.o $(LFLAGS) $(PA2LIBS) -llinux-lib -o sample-linux

all: PartA1 PartA2 group-testlist shell

shell:
	./partE.bash mkdir testFolder
PartA1: PartA1.o libsquare.a
	$(CC) PartA1.o $(LFLAGS) $(PA1LIBS) -lsquare -o PartA1

PartA1.o: PartA1.c
	$(CC) -c $(CFLAGS) PartA1.c $(INCLUDES)

PartA2: PartA2.o libsquare.a
	$(CC) PartA2.o $(LFLAGS) $(PA2LIBS) -lsquare -o PartA2

PartA2.o: PartA2.c
	$(CC) -c $(CFLAGS) PartA2.c $(INCLUDES)

libsquare.a:libsquare.a(square.o)

square.o: square.c square.h
	$(CC) -c $(CFLAGS) square.c

group-testlist: group37-testlist.o liblist.a
	$(CC) group37-testlist.o -L. -llist -o group-testlist

liblist.a: liblist.a(list_adders.o list_removers.o list_movers.o)

list_removers.o: list_removers.c list.h
	$(CC) -c $(CFLAGS) list_removers.c

list_movers.o: list_movers.c list.h
	$(CC) -c $(CFLAGS) list_movers.c

list_adders.o: list_adders.c list.h
	$(CC) -c $(CFLAGS) list_adders.c 

clean:
	rm -rf *.o
	rm -rf *.a
	rm -rf PartA1
	rm -rf PartA2
	rm -rf group-testlist
