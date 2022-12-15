#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int l, r;
} Range;

typedef struct {
  int x, y, bx, by, d;
} Sensor;

int calcRanges(Sensor *s, int n, Range *r, int y) {
  int m = 0;
  for (int i = 0; i < n; ++i) {
    int d = s[i].d - abs(y - s[i].y);
    if (d < 0)
      continue;
    r[m].l = s[i].x - d;
    r[m++].r = s[i].x + d;
  }
  return m;
}

bool nextIn(Range *r, int m, int x, int *n) {
  bool found = false;
  for (int i = 0; i < m; ++i)
    if (r[i].l > x && (!found || r[i].l < *n)) {
      *n = r[i].l;
      found = true;
    }
  return found;
}

int nextOut(Range *r, int m, int x) {
  bool changed;
  do {
    changed = false;
    for (int i = 0; i < m; ++i)
      if (r[i].l <= x && r[i].r >= x) {
        x = r[i].r + 1;
        changed = true;
      }
  } while (changed);
  return x;
}

int main(void) {
  int count = 0;
  char line[100];
  Sensor sensors[25];
  Range ranges[25];

  FILE *f = fopen("adv15.txt", "r");
  int n;
  for (n = 0; fgets(line, 100, f); n++) {
    char *s = line;
    s = strchr(s, '=') + 1; sensors[n].x  = atoi(s);
    s = strchr(s, '=') + 1; sensors[n].y  = atoi(s);
    s = strchr(s, '=') + 1; sensors[n].bx = atoi(s);
    s = strchr(s, '=') + 1; sensors[n].by = atoi(s);
    sensors[n].d = abs(sensors[n].x - sensors[n].bx) +
      abs(sensors[n].y - sensors[n].by);
  }
  fclose(f);

  int y = 2000000, max = 4000000;

  /* # of beacons in the line */
  for (int i = 0; i < n; ++i)
    if (sensors[i].by == y) {
      bool found = false;
      for (int j = i + 1; j < n; ++j)
        if (sensors[j].bx == sensors[i].bx && sensors[j].by == y) {
          found = true;
          break;
        }
      if (!found)
        count--;
    }

  int m = calcRanges(sensors, n, ranges, y);
  /* Find minimal x */
  int x = INT_MAX, tmp;
  for (int i = 0; i < m; ++i)
    if (ranges[i].l < x)
      x = ranges[i].l;
  /* Jump through ranges */
  do {
    tmp = nextOut(ranges, m, x);
    count += tmp - x;
  } while (nextIn(ranges, m, tmp, &x));

  /* Find first valid position */
  for (y = 0; y <= max; ++y) {
    m = calcRanges(sensors, n, ranges, y);
    x = nextOut(ranges, m, 0);
    if (x <= max)
      break;
  }

  printf("%d, %lu\n", count, 4000000L * x + y);
}
