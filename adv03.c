#include <ctype.h>
#include <stdio.h>
#include <string.h>

int priority(char c) {
  if (islower(c))
    return c - 'a' + 1;
  return c - 'A' + 27;
}

int main(void) {
  char line[100], prev1[100], prev2[100];
  int sum1 = 0, sum2 = 0;

  FILE *f = fopen("adv03.txt", "r");
  for (int n = 1; fgets(line, 100, f); n++) {
    int size = strlen(line);
    for (int i = 0; i < size / 2; i++)
      if (strrchr(line, line[i]) >= &line[size/2]) {
        sum1 += priority(line[i]);
        break;
      }
    if (n % 3 == 0)
      for (int i = 0; i < size; i++)
        if (strchr(prev1, line[i]) && strchr(prev2, line[i])) {
          sum2 += priority(line[i]);
          break;
        }
    strcpy(prev2, prev1);
    strcpy(prev1, line);
  }
  fclose(f);

  printf("%d, %d\n", sum1, sum2);
}
