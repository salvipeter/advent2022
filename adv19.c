#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int costs[4][4], minerals[4], robots[4], max_cost;

int max(int a, int b) { return a >= b ? a : b; }

int upperBound(int i, int t) {
  return minerals[i] + robots[i] * t + (t - 1) * t / 2;
}

int guessMax(int t) {
  int t0 = 0;
  while (upperBound(0, t0) < costs[3][0] || upperBound(2, t0) < costs[3][2])
    t0++;
  return upperBound(3, t - t0) + robots[3] * t0;
}

int maxGeodes(int time, int best) {
  if (time == 0 || best >= guessMax(time))
    return minerals[3];

  for (int i = 3; i >= 0; i--) {
    if ((i == 0 && robots[0] >= max_cost) ||
        ((i == 1 || i == 2) && robots[i] >= costs[i+1][i]))
      continue;
    bool can_build = true;
    for (int j = 0; j < 3; ++j)
      if (costs[i][j] > minerals[j])
        can_build = false;
    if (can_build) {
      for (int j = 0; j < 4; ++j)
        minerals[j] += robots[j] - costs[i][j];
      robots[i]++;
      best = max(best, maxGeodes(time - 1, best));
      robots[i]--;
      for (int j = 0; j < 4; ++j)
        minerals[j] -= robots[j] - costs[i][j];
    }
  }

  for (int j = 0; j < 4; ++j)
    minerals[j] += robots[j];
  best = max(best, maxGeodes(time - 1, best));
  for (int j = 0; j < 4; ++j)
    minerals[j] -= robots[j];

  return best;
}

int main(void) {
  char line[200];
  int n = 0, sum = 0, prod = 1;
  FILE *f = fopen("adv19.txt", "r");
  while (fgets(line, 200, f)) {
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j)
        costs[i][j] = 0;
      minerals[i] = 0;
      robots[i] = 0;
    }
    char *s = line;
    for (int i = 0; i < 30; ++i) {
      s = strchr(s, ' ') + 1;
      switch (i) {
      case 0:  n           = atoi(s); break;
      case 5:  costs[0][0] = atoi(s); break;
      case 11: costs[1][0] = atoi(s); break;
      case 17: costs[2][0] = atoi(s); break;
      case 20: costs[2][1] = atoi(s); break;
      case 26: costs[3][0] = atoi(s); break;
      case 29: costs[3][2] = atoi(s); break;
      default: ;
      }
    }
    max_cost = 0;
    for (int i = 0; i < 4; ++i)
      max_cost = max(max_cost, costs[i][0]);
    robots[0] = 1;
    sum += n * maxGeodes(24, 0);
    if (n <= 3)
      prod *= maxGeodes(32, 0);
  }
  fclose(f);
  printf("%d, %d\n", sum, prod);
}
