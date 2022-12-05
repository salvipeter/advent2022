#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Crate {
  char id;
  struct Crate *next;
} Crate;

Crate *crate_new(char id) {
  Crate *new = (Crate *)malloc(sizeof(Crate));
  new->id = id;
  new->next = NULL;
  return new;
}

void crate_append(Crate **place, Crate *crate) {
  if (*place) {
    Crate *c = *place;
    while (c->next != NULL)
      c = c->next;
    c->next = crate;
  } else
    *place = crate;
}

void crate_free(Crate *crate) {
  if (crate)
    crate_free(crate->next);
  free(crate);
}

void crate_move(Crate **from, Crate **to, int n, bool reverse) {
  if (reverse)
    for (int i = 0; i < n; ++i)
      crate_move(from, to, 1, false);
  else {
    Crate *c = *from;
    for (int i = 1; i < n; ++i)
      c = c->next;
    Crate *tmp = *from;
    *from = c->next;
    c->next = *to;
    *to = tmp;
  }
}

int main(int argc, char **argv) {
  bool part2 = argc > 1; // Second part when run with arguments

  char line[50];
  Crate *crates[9] = { NULL };

  FILE *f = fopen("adv05.txt", "r");
  while (fgets(line, 50, f)) {
    int size = strlen(line);
    if (size > 0 && line[0] == 'm') {
      // Movement
      strtok(line, " "); // "move"
      int n = atoi(strtok(NULL, " "));
      strtok(NULL, " "); // "from"
      int from = atoi(strtok(NULL, " "));
      strtok(NULL, " "); // "to"
      int to = atoi(strtok(NULL, " "));
      crate_move(&crates[from-1], &crates[to-1], n, !part2);
    } else {
      // Crate setup
      for (int i = 0; size > 4 * i + 1; ++i) {
        char c = line[4*i+1];
        if (isupper(c))
          crate_append(&crates[i], crate_new(c));
      }
    }
  }
  fclose(f);

  for (int i = 0; i < 9; ++i) {
    printf("%c", crates[i]->id);
    crate_free(crates[i]);
  }
  printf("\n");
}
