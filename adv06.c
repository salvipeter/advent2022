#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  int len = atoi(argv[1]); // call with 4 or 14
  char *last = (char *)malloc(len);
  FILE *f = fopen("adv06.txt", "r");
  for (int i = 1; true; ++i) {
    for (int j = len - 2; j >= 0; j--)
      last[j+1] = last[j];
    last[0] = fgetc(f);
    bool ok = true;
    for (int j = 0; ok && j < len - 1; ++j)
      for (int k = j + 1; ok && k < len; ++k)
        if (last[j] == last[k])
          ok = false;
    if (i >= len && ok) {
      printf("%d\n", i);
      break;
    }
  }
  fclose(f);
  free(last);
}
