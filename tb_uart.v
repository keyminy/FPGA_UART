module tb_uart(
    input   rst,clk,
    input   txck,start,
    input   [7:0] pd0,pd1,pd2,pd3,
    output  rcv_done,
    output  [7:0] rpd0,rpd1,rpd2,rpd3
    );

wire tstart;
wire [7:0] txpd;

wire txsd;
wire rxck,rxsd;
wire rxen,rnpd;
wire [7:0] rxpd;

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

assign rxck = txck;
assign rxsd = txsd;
    
rx232_pd u_rx232_pd
(
.rst    (rst    ),
.clk    (clk    ),
.rxck   (rxck   ),
.rxsd   (rxsd   ),
//
.rxen   (rxen   ),
.rnpd   (rnpd   ),
.rxpd   (rxpd   )
);
    
rx232_rcv u_rx232_rcv
(
.rst        (rst    ),
.clk        (clk    ),
.rxen       (rxen   ),
.rnpd       (rnpd   ),
.rxpd       (rxpd   ),
//
.rcv_done   (rcv_done   ),
.rpd0       (rpd0       ),
.rpd1       (rpd1       ),
.rpd2       (rpd2       ),
.rpd3       (rpd3       )
);
    
endmodule
