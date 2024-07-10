module tx232_ctl(
    input   rst,clk,
    input   txck,start,
    input   [7:0] pd0,pd1,pd2,pd3,
    output  reg tstart,
    output  reg [7:0] txpd
    );
    
reg [3:0] bcnt;
reg [2:0] bycnt;

reg tc0,tc1;
wire tcenf,tcenr;

reg st0,st1;
wire sten;

// TXCK Edge Detection
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            tc0 <= 0;   tc1 <= 0;
        end
    else
        begin
            tc0 <= txck;   tc1 <= tc0;
        end
end        

assign tcenr = (tc0 & ~tc1);     
assign tcenf = (tc1 & ~tc0);         

// TSTART Risind Edge Detection
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            st0 <= 0;   st1 <= 0;
        end
    else if (tcenf)
        begin
            st0 <= start;   st1 <= st0;
        end
end        

assign sten = (st0 & ~st1); // Falling to Falling

// TXPD & TSTART Timing control Counter
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            bcnt <= 4'hf;   bycnt <= 3'h7;
        end
    else if (tcenr)
        if (sten)
            begin
                bcnt <= 4'h0;   bycnt <= 3'h0;
            end
        else if (bcnt < 9)
            bcnt <= bcnt + 1;
        else
            if (bycnt < 3)
                begin
                    bcnt <= 0;  bycnt <= bycnt + 1;
                end
            else
                begin
                    bcnt <= 4'hf;   bycnt <= 3'h7;
                end                
end

// TXPD & TSTART Output 
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            txpd <= 8'hff;  tstart <= 0;
        end
    else if (tcenf)
        begin
            case (bycnt)
            3'h0    : txpd <= pd0;
            3'h1    : txpd <= pd1;
            3'h2    : txpd <= pd2;
            3'h3    : txpd <= pd3;
            default : txpd <= 8'hff;
            endcase
            //
            if ((bcnt >= 4) & (bcnt <= 5))
                tstart <= 1;
            else
                tstart <= 0;
        end
end

endmodule
