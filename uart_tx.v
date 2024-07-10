module uart_tx(
    input   rst,clk,
    input   txck,start,
    input   [7:0] pd0,pd1,pd2,pd3,
    //
    output  txsd
    );

wire tstart;
wire [7:0] txpd;

tx232_ctl u_tx232_ctl
(
.rst    (rst    ),
.clk    (clk    ),
.txck   (txck   ),
.start  (start  ),
.pd0    (pd0    ),
.pd1    (pd1    ),
.pd2    (pd2    ),
.pd3    (pd3    ),
//
.tstart (tstart ),
.txpd   (txpd   )
);

tx232 u_tx232
(
.rst    (rst    ),
.clk    (clk    ),
.txck   (txck   ),
.tstart (tstart ),
.txpd   (txpd   ),
//
.txsd   (txsd   )
);

endmodule
