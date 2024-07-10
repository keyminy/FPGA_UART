restart
add_force rst {1 0ns} {0 1ps} {1 10ns}
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns
add_force txck {0 0ns} {1 500ns} -repeat_every 1000ns

add_force tstart 0

add_force txpd -radix hex 45
run 12us
add_force tstart 1
run 2us
add_force tstart 0
run 6us

add_force txpd -radix hex 38
run 2us
add_force tstart 1
run 2us
add_force tstart 0
run 6us

run 20us