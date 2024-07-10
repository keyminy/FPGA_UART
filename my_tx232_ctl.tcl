restart
add_force rst {1 0ns} {0 1ps} {1 10ns}
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns
add_force txck {0 0ns} {1 500ns} -repeat_every 1000ns

add_force start 0

add_force pd0 -radix hex 31
add_force pd1 -radix hex 35
add_force pd2 -radix hex 41
add_force pd3 -radix hex 45

run 10us
add_force start 1
run 4us
add_force start 0
run 46us
