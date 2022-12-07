#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Dir {
  int size;
  struct Dir *next;
} Dir;

Dir *dir_insert(Dir *d, int size) {
  Dir *new = (Dir *)malloc(sizeof(Dir));
  new->size = size;
  new->next = d;
  return new;
}

void dir_free(Dir *d) {
  if (d)
    dir_free(d->next);
  free(d);
}

Dir *computeSizes(FILE *f, Dir *dirs) {
  char line[30];
  int size = 0;
  if (!fgets(line, 30, f))
    return dir_insert(dirs, 0);
  while (strncmp(line, "$ cd ..", 7) != 0) {
    if (strncmp(line, "$ cd", 4) == 0 && line[5] != '/') {
      dirs = computeSizes(f, dirs);
      size += dirs->size;
    } else if (line[0] >= '0' && line[0] <= '9')
      size += atoi(line);
    if (!fgets(line, 30, f))
      break;
  }
  return dir_insert(dirs, size);
}

int main(void) {
  FILE *f = fopen("adv07.txt", "r");
  Dir *dirs = computeSizes(f, NULL);
  fclose(f);

  int sum = 0;
  for (Dir *d = dirs; d; d = d->next)
    if (d->size <= 100000)
      sum += d->size;

  int needed = 30000000 - (70000000 - dirs->size);
  int best = dirs->size;
  for (Dir *d = dirs; d; d = d->next)
    if (d->size >= needed && d->size < best)
      best = d->size;
  dir_free(dirs);

  printf("%d, %d\n", sum, best);
}
