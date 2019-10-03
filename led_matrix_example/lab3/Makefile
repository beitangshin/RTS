CC = gcc
CFLAGS=-Wall


lab3_1 : lab3_1.o led_matrix.o
	$(CC) -o lab3_1 lab3_1.o led_matrix.o

lab3_1.o : lab3_1.c
	$(CC) -c lab3_1.c

#led_matrix.o : led_matrix.c
#	$(CC) -c led_matrix.c

clean :
	rm lab3_1.o led_matrix.o

