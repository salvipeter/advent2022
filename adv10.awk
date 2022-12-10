BEGIN { x = 1; cycle = 1; ORS="" }
/noop/ { step() }
/addx/ { step(); step(); x += $2 }
END { print sum "\n" }

function step() {
    crt = (cycle - 1) % 40
    print (crt - x)^2 < 2 ? "#" : "."
    if (cycle % 40 == 0)
        print "\n"
    if (cycle % 40 == 20)
        sum += cycle * x
    cycle++
}
