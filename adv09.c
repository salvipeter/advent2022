#include <stdio.h>
#include <stdlib.h>

typedef struct Visit {
  int x, y;
  struct Visit *next;
} Visit;

Visit *visit_add(Visit *visits, int x, int y) {
  for (Visit *v = visits; v; v = v->next)
    if (v->x == x && v->y == y)
      return visits;
  Visit *new = (Visit *)malloc(sizeof(Visit));
  new->x = x; new->y = y;
  new->next = visits;
  return new;
}

void visit_free(Visit *visits) {
  if (visits)
    visit_free(visits->next);
  free(visits);
}

int visit_length(Visit *visits) {
  if (visits)
    return 1 + visit_length(visits->next);
  return 0;
}

void absgn(int n, int *a, int *s) {
  *a = abs(n);
  *s = n == 0 ? 0 : n / *a;
}

int main(int argc, char **argv) {
  int len = argc > 1 ? 10 : 2; // Second part when run with arguments
  int pos[10][2];
  for (int i = 0; i < len; ++i)
    pos[i][0] = pos[i][1] = 0;
  Visit *visits = visit_add(NULL, 0, 0);

  char line[10];
  FILE *f = fopen("adv09.txt", "r");
  while (fgets(line, 10, f)) {
    int n = atoi(&line[2]), dx = 0, dy = 0;
    switch (line[0]) {
    case 'U': dy = n; break;
    case 'D': dy = -n; break;
    case 'L': dx = -n; break;
    case 'R': dx = n; break;
    default: ;
    }
    while (dx != 0 || dy != 0) {
      int ax, ay, sx, sy;
      absgn(dx, &ax, &sx); absgn(dy, &ay, &sy);
      pos[0][0] += sx; pos[0][1] += sy;
      dx -= sx; dy -= sy;
      for (int i = 1; i < len; ++i) {
        absgn(pos[i-1][1] - pos[i][0], &ax, &sx);
        absgn(pos[i-1][0] - pos[i][1], &ay, &sy);
        if (ax <= 1 && ay <= 1)
          continue;
        pos[i][0] += sx; pos[i][1] += sy;
        if (i == len - 1)
          visits = visit_add(visits, pos[i][0], pos[i][1]);
      }
    }
  }
  fclose(f);

  printf("%d\n", visit_length(visits));
  visit_free(visits);
}
