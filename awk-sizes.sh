#!/bin/bash
ls -l *.awk | awk -e '{printf("Day %2d: %4d bytes\n",substr($9,4,2),$5)}'
