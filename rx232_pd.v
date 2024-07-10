module rx232_pd
    (
    input   rst,clk,
    input   rxck,rxsd,
    //
    output  reg rxen,rnpd,
    output  reg [7:0] rxpd
    );
    
reg [7:0] pd;
reg rxc0,rxc1;
reg [3:0] bcnt,rcnt;

reg rxsdi;

// RXCK Edge Detection
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            rxc0 <= 0;   rxc1 <= 0;
        end
    else
        begin
            rxc0 <= rxck;   rxc1 <= rxc0;
        end
end          

// Front Handling Starts Here

// RX Control Bit Counter : BCNT 
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            bcnt <= 4'hf;   rxsdi <= 1;
        end
    else if (rxc0 & ~rxc1)
        begin
            rxsdi <= rxsd;
            if ((bcnt >= 9) & (rxsd == 0))
                bcnt <= 0;
            else if (bcnt < 15)
                bcnt <= bcnt + 1;
        end
end

// Serial to Parall Convert
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        pd <= 8'hff;
    else if (rxc1 & ~rxc0)
        case (bcnt)
        4'd1    :   pd[0] <= rxsdi;
        4'd2    :   pd[1] <= rxsdi;
        4'd3    :   pd[2] <= rxsdi;
        4'd4    :   pd[3] <= rxsdi;
        4'd5    :   pd[4] <= rxsdi;
        4'd6    :   pd[5] <= rxsdi;
        4'd7    :   pd[6] <= rxsdi;
        4'd8    :   pd[7] <= rxsdi;
        endcase
end     

// After Handling Starts Here
  
// RX Capture Data Out Control Counter
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        rcnt <= 4'hf;   
    else if (rxc1 & ~rxc0)
        if ((bcnt == 9) & (rxsd == 1))  // Stop bit Check
            rcnt <= 0;
        else if (rcnt < 15)
            rcnt <= rcnt + 1;
end

// RXPD Data & Control Out 
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            rxen <= 0;   
            rnpd <= 0;   
            rxpd <= 8'hff;
        end
    else if (rxc0 & ~rxc1)
        begin
            if (rcnt < 10)  
                rxen <= 1;
            else  
                rxen <= 0;
            //
            if ((rcnt >= 3) & (rcnt <= 4))
                rnpd <= 1;
            else
                rnpd <= 0;
            //
            if (rcnt == 0)
                rxpd <= pd;
            else if (rcnt > 9)
                rxpd <= 8'hff;
        end 
end
    
endmodule
