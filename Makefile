CFLAGS=-g -std=c11 -Wall -pedantic

adv% : adv%.c
	$(CC) -o $@ $< $(CFLAGS)
