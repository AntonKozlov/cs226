#all : exocall
	#./exocall

#exocall : exocall.c
	#gcc -g -o exocall exocall.c

P := hello syscall exocall 

CFLAGS = -g
LDFLAGS = -static
all : $P

clean :
	rm -f $P
