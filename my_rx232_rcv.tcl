restart
add_force rst {1 0ns} {0 1ps} {1 10ns}
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns

add_force rxen 0
add_force rnpd 0
add_force rxpd -radix hex ff
run 10us

add_force rxen 1

add_force rxpd -radix hex 31
run 4us
add_force rnpd 1
run 2us
add_force rnpd 0
run 4us

add_force rxpd -radix hex 35
run 4us
add_force rnpd 1
run 2us
add_force rnpd 0
run 4us

add_force rxpd -radix hex 41
run 4us
add_force rnpd 1
run 2us
add_force rnpd 0
run 4us

add_force rxpd -radix hex 45
run 4us
add_force rnpd 1
run 2us
add_force rnpd 0
run 4us

add_force rxen 0
add_force rxpd -radix hex ff
run 10us
