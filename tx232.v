module tx232(
    input   rst,clk,
    input   txck,tstart,
    input   [7:0] txpd,
    output  reg txsd
    );
    
reg [7:0] tpd;
reg [3:0] bcnt;

reg tc0,tc1;
wire tcenr,tcenf;

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
            st0 <= tstart;   st1 <= st0;
        end
end        

assign sten = (st0 & ~st1);

// TXPD Capture at TSTART Rising Edge
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        tpd <= 8'hff;
    else if (tcenr & sten)
        tpd <= txpd;
end

// BCNT : Bit Counter
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        bcnt <= 4'hf;
    else if (tcenr)
        if (sten)
            bcnt <= 0;
        else if (bcnt < 9)
            bcnt <= bcnt + 1;
        else
            bcnt <= 4'hf;
end

// TXSD Generation
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        txsd <= 1;
    else if (tcenf)
        case (bcnt)
        4'd0    :   txsd <= 0;
        4'd1    :   txsd <= tpd[0];
        4'd2    :   txsd <= tpd[1];
        4'd3    :   txsd <= tpd[2];
        4'd4    :   txsd <= tpd[3];
        4'd5    :   txsd <= tpd[4];
        4'd6    :   txsd <= tpd[5];
        4'd7    :   txsd <= tpd[6];
        4'd8    :   txsd <= tpd[7];
        default :   txsd <= 1;
        endcase
end       
    
endmodule
