#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  int x = 1, cycle = 1, sum = 0;
  char line[10];
  FILE *f = fopen("adv10.txt", "r");
  while (fgets(line, 10, f)) {
    bool add = strncmp(line, "noop", 4) != 0;
    for (int i = 0; i < (add ? 2 : 1); ++i) {
      int crt = (cycle - 1) % 40;
      printf("%c", abs(crt - x) < 2 ? '#' : '.');
      if (cycle % 40 == 0)
        printf("\n");
      if (cycle % 40 == 20)
        sum += cycle * x;
      cycle++;
    }
    if (add)
      x += atoi(&line[5]);
  }
  fclose(f);
  printf("%d\n", sum);
}
