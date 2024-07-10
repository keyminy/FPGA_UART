module uart_rx(
    input   rst,clk,
    input   rxck,rxsd,
    output  rcv_done,
    output  [7:0] rpd0,rpd1,rpd2,rpd3
    );

wire rxen,rnpd;
wire [7:0] rxpd;

    
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
