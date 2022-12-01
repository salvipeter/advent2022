#include <stdio.h>

void update_max(int *max, int sum) {
  if (sum > max[0]) {
    max[2] = max[1];
    max[1] = max[0];
    max[0] = sum;
  } else if (sum > max[1]) {
    max[2] = max[1];
    max[1] = sum;
  } else if (sum > max[2])
    max[2] = sum;
}

int main(void) {
  int max[3] = {0}, sum = 0;
  char line[10]; // should be large enough

  FILE *f = fopen("adv01.txt", "r");
  while (fgets(line, 10, f)) {
    if (line[0] == '\n') {
      update_max(max, sum);
      sum = 0;
    } else {
      int n;
      sscanf(line, "%d", &n);
      sum += n;
    }
  }
  update_max(max, sum); // final sum not processed yet
  fclose(f);

  printf("%d, %d\n", max[0], max[0] + max[1] + max[2]);
}
