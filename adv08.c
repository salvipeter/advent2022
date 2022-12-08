#include <stdbool.h>
#include <stdio.h>

int main(void) {
  const int size = 99;
  int grid[size][size];
  char line[size+3];
  FILE *f = fopen("adv08.txt", "r");
  for (int i = 0; i < size; ++i) {
    fgets(line, size + 3, f);
    for (int j = 0; j < size; ++j)
      grid[i][j] = line[j] - '0';
  }
  fclose(f);

  int count = 0, best = 0;
  for (int i = 0; i < size; ++i)
    for (int j = 0; j < size; ++j) {
      bool hidden[4] = { false };
      int score[4] = { 0 };
      int height = grid[i][j];
      for (int k = 0; k < size; ++k) {
        if (k < i && grid[k][j] >= height)
          hidden[0] = true;
        if (k > i && grid[k][j] >= height)
          hidden[1] = true;
        if (k < j && grid[i][k] >= height)
          hidden[2] = true;
        if (k > j && grid[i][k] >= height)
          hidden[3] = true;
        if (!score[0] && (k == i || (k < i && grid[i-k][j] >= height)))
          score[0] = k;
        if (!score[1] && (i + k == size - 1 || (i + k < size - 1 && grid[i+k][j] >= height)))
          score[1] = k;
        if (!score[2] && (k == j || (k < j && grid[i][j-k] >= height)))
          score[2] = k;
        if (!score[3] && (j + k == size - 1 || (j + k < size - 1 && grid[i][j+k] >= height)))
          score[3] = k;
      }
      if (!(hidden[0] && hidden[1] && hidden[2] && hidden[3]))
        count++;
      int scenic = score[0] * score[1] * score[2] * score[3];
      if (scenic > best)
        best = scenic;
    }

  printf("%d, %d\n", count, best);
}
