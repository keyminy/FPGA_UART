module uart_codec
    (    input 	btnl, // rst. High Active Reset
    input 	clk,  // 100MHz Clock Input
    input 	btnr, // start btn. Tact Switch Input. Push High
    input 	btnd, // LED sel btn. Tact Switch Input. Push High
    input 	[15:0] sw,
    input	rxsd,rxck,
    //
    output  reg txck,
    output  txsd,
    output	[6:0] seg,
    output  dp,
    output	[3:0] an,
    output 	reg [15:0] led

    );

wire 	rst;

wire 	key;
reg 	k0,k1,lsel;

wire   [7:0] pd0,pd1,pd2,pd3;

reg   	[5:0] cnt;	// for 1MHz TXCK Generation

wire 	rcv_done;
wire 	[7:0]	rlength,rpd0,rpd1,rpd2,rpd3;
wire 	[15:0]	rpd;

//

assign seg = 7'b1111111;	// Always Off

assign dp = 0;	// Always On
assign an = {lsel,~lsel,~lsel,lsel};

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		led <= 0;	
	else if (lsel == 0)
		led <= sw;
	else
		led = rpd;
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			cnt <= 0;	txck <= 0;
		end
	else 
		if (cnt < 49)
			cnt <= cnt + 1;
		else	
			begin	
				cnt <= 0;
				txck <= ~txck;
			end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			lsel <= 0;	k0 <= 0;	k1 <= 0;
		end
	else 
		begin
			k0 <= key;	k1 <= k0;
			if (k0 & ~k1)
				lsel <= ~lsel;
		end
end

//

ascii2hex u_ascii2hex
(
.rst		(rst		),
.clk		(clk		),
.pd0		(rpd0		),
.pd1		(rpd1		),
.pd2		(rpd2		),
.pd3		(rpd3		),
//
.rpd		(rpd		)
);

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
    
//

hex2ascii u_hex2ascii
(
.rst		(rst		),
.clk		(clk		),
.sw	    	(sw	    	),
//
.pd0		(pd0		),
.pd1		(pd1		),
.pd2		(pd2		),
.pd3		(pd3		)
);

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

debounce u_debounce0
(
.rst        (rst        ),
.clk        (clk        ),
.btnr  		(btnr  		),
//
.key  		(start  	)
);

debounce u_debounce1
(
.rst        (rst        ),
.clk        (clk        ),
.btnr  		(btnd  		),
//
.key  		(key	  	)
);

assign rst = ~btnl;

endmodule
