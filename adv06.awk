BEGIN { FS = "" }
{   # call with -v len=4 or -v len=14
    for (i = len; i <= NF; i++) {
        ok = 1
        for (j = 0; ok && j < len - 1; j++)
            for (k = j + 1; ok && k < len; k++)
                if ($(i-j) == $(i-k))
                    ok = 0
        if (ok) {
            print i
            break
        }
    }
}
