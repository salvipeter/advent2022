/X/ { score1++ }
/Y/ { score1 += 2; score2 += 3 }
/Z/ { score1 += 3; score2 += 6 }
/A Y|B Z|C X/ { score1 += 6 }
/A X|B Y|C Z/ { score1 += 3 }
/A X|B Z|C Y/ { score2 += 3 }
/A Z|B Y|C X/ { score2 += 2 }
/A Y|B X|C Z/ { score2++ }
END { print score1 ", " score2 }
