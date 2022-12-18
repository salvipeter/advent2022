#!/bin/bash
all=$(awk -f adv18.awk adv18.txt)
air=$(awk -v part=2 -f adv18.awk adv18.txt | awk -f adv18.awk)
echo $(($all-$air))
