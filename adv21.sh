#!/bin/bash
TMPFILE=$(mktemp adv_XXX.pl)
cat adv21.pl > $TMPFILE
sed 's/^\(.*\): \(.*\)$/monkey(\1, \2)./' adv21.txt >> $TMPFILE
swipl -g main -t halt $TMPFILE
rm -f $TMPFILE
