CFLAGS=-g -std=c11 -Wall -pedantic -O3

adv% : adv%.c
	$(CC) -o $@ $< $(CFLAGS)
