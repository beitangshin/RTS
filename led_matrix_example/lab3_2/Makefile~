CC = gcc
CFLAGS=-Wall


lab3_2 : lab3_2.o led_matrix.o
	$(CC) -o lab3_2 lab3_2.o led_matrix.o

lab3_2.o : lab3_2.c
	$(CC) -c lab3_2.c

led_matrix.o : led_matrix.c
	$(CC) -c led_matrix.c

clean :
	rm lab3_2.o led_matrix.o

