module tb_uart_n(
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

uart_tx u_uart_tx
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
.txsd   (txsd   )
);

assign rxck = txck;
assign rxsd = txsd;
    
uart_rx u_uart_rx
(
.rst    (rst    ),
.clk    (clk    ),
.rxck   (rxck   ),
.rxsd   (rxsd   ),
//
.rcv_done   (rcv_done   ),
.rpd0       (rpd0       ),
.rpd1       (rpd1       ),
.rpd2       (rpd2       ),
.rpd3       (rpd3       )
);
    
endmodule
