#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  char line[20];
  int count1 = 0, count2 = 0;

  FILE *f = fopen("adv04.txt", "r");
  while (fgets(line, 20, f)) {
    int a1 = atoi(line);
    int a2 = atoi(strchr(line, '-') + 1);
    int b1 = atoi(strchr(line, ',') + 1);
    int b2 = atoi(strrchr(line, '-') + 1);
    if ((a1 <= b1 && a2 >= b2) || (b1 <= a1 && b2 >= a2))
      count1++;
    if (a1 <= b2 && a2 >= b1)
      count2++;
  }
  fclose(f);

  printf("%d, %d\n", count1, count2);
}
