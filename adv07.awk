/cd \// { pwd = "/"; dirs["/"] = 0 }
/cd \./ { sub(/[^/]*\/$/, "", pwd) }
/cd [a-z]/ { pwd = pwd $3 "/" }
/^dir/ { dirs[pwd $2 "/"] = 0 }
/^[0-9]/ { files[pwd $2] = $1 }
END {
    for (d in dirs) {
        for (f in files)
            if (index(f, d) == 1)
                dirs[d] += files[f]
        if (dirs[d] <= 100000)
            sum += dirs[d]
    }
    needed = 30000000 - (70000000 - dirs["/"])
    best = "/"
    for (d in dirs)
        if (dirs[d] >= needed && dirs[d] < dirs[best])
            best = d
    print sum ", " dirs[best]
}
