module rx232_rcv
    (
    input   rst,clk,
    input   rxen,rnpd,
    input   [7:0] rxpd,
    //
    output  reg rcv_done,
    output  reg [7:0] rpd0,rpd1,rpd2,rpd3
    );
    
reg [7:0] pd0,pd1,pd2;
reg rx0,rx1;
reg rn0,rn1;
reg [2:0] bycnt;

// Edge Detect : RXEN, RNPD
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            rx0 <= 0;   rx1 <= 0;
            rn0 <= 0;   rn1 <= 0;            
        end
    else
        begin
            rx0 <= rxen;   rx1 <= rx0;
            rn0 <= rnpd;   rn1 <= rn0;
        end
end          

// RPD Catch Timing Control Counter : BYCNT 
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        bycnt <= 3'h7;
    else 
        if (rx0 & ~rx1)
            bycnt <= 0;
        else if (rn1 & ~rn0)
            bycnt <= bycnt + 1;
        else if (rxen == 0)
            bycnt <= 3'h7;
end

// Parallel Data Catch
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            pd0 <= 8'hff;   pd1 <= 8'hff;   pd2 <= 8'hff;  // pd3 <= 8'hff;    
        end
    else 
        if (rn0 & ~rn1)
            case (bycnt)
            3'd0    : pd0 <= rxpd;
            3'd1    : pd1 <= rxpd;
            3'd2    : pd2 <= rxpd;
        //    3'd3    : pd3 <= rxpd;
            //default
            endcase
end     

// Parallel Data Catch
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            rpd0 <= 8'hff;   rpd1 <= 8'hff;   rpd2 <= 8'hff;   rpd3 <= 8'hff;    
        end
    else 
        if ((rn0 & ~rn1) & (bycnt == 3))
            begin
                rpd0 <= pd0;   
                rpd1 <= pd1;   
                rpd2 <= pd2;   
                rpd3 <= rxpd; 
            end
end     

// Done Signal
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        rcv_done <= 0;   
    else if (bycnt == 4)
        rcv_done <= 1;
    else 
        rcv_done <= 0; 
end     

endmodule
