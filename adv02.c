#include <stdio.h>

int main(void) {
  int score1[9] = { 4, 8, 3, 1, 5, 9, 7, 2, 6 };
  int score2[9] = { 3, 4, 8, 1, 5, 9, 2, 6, 7 };
  FILE *f = fopen("adv02.txt", "r");
  char c1, c2;
  int sum1 = 0, sum2 = 0;
  while (fscanf(f, "%c %c\n", &c1, &c2) == 2) {
    int index = (c1 - 'A') * 3 + (c2 - 'X');
    sum1 += score1[index];
    sum2 += score2[index];
  }
  fclose(f);
  printf("%d, %d\n", sum1, sum2);
}
