BEGIN { RS = "" }
{
    if (less($1, $2))
        sum += NR
    insert($1)
    insert($2)
}
END {
    a = insert("[[2]]")
    b = insert("[[6]]")
    print sum ", " a * b
}

function splitList(str, a) {
    gsub(/\[/, "[ ", str)
    gsub(/\]/, " ]", str)
    gsub(/  /, " ", str)
    split(str, a, "[, ]")
}

function lessImpl(a, i, b, j) {
    if (!(i in a))
        return 1
    if (!(j in b))
        return 0
    if (a[i] == b[j])
        return lessImpl(a, i + 1, b, j + 1)
    if (a[i] == "]")
        return 1
    if (b[j] == "]")
        return 0
    if (a[i] == "[") {
        b[j-1] = b[j]
        b[j] = "]"
        return lessImpl(a, i + 1, b, j - 1)
    }
    if (b[j] == "[") {
        a[i-1] = a[i]
        a[i] = "]"
        return lessImpl(a, i - 1, b, j + 1)
    }
    return (a[i] < b[j])
}

function less(a, b) {
    splitList(a, la)
    splitList(b, lb)
    return lessImpl(la, 1, lb, 1)
}

# Inserts a string in the `sorted` array, and returns the index
function insert(x) {
    for (i = 1; i in sorted && less(sorted[i], x); i++);
    if (i in sorted)
        for (j = length(sorted); j >= i; j--)
            sorted[j+1] = sorted[j]
    sorted[i] = x
    return i
}
