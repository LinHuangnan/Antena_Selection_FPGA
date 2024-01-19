module multi #
    (
        parameter DATA_WIDTH = 32
    )
    (
    input signed [DATA_WIDTH-1:0] din1,
    input signed [DATA_WIDTH-1:0] din2,
    output reg signed [2*DATA_WIDTH-1:0] dout
    );
    reg [DATA_WIDTH-1:0] num1;
    reg [DATA_WIDTH-1:0] num2;
    wire [2*DATA_WIDTH-1:0] sum;
    
    always @(*)
    begin
        if(din1 < 0)
            num1[DATA_WIDTH-1:0] = ~(din1[DATA_WIDTH-1:0] -1'b1);
        else
            num1[DATA_WIDTH-1:0] = din1[DATA_WIDTH-1:0];           
        if(din2 < 0)
            num2[DATA_WIDTH-1:0] = ~(din2[DATA_WIDTH-1:0] - 1'b1);
        else
            num2[DATA_WIDTH-1:0] = din2[DATA_WIDTH-1:0];            
    end
    
    mul #
    (
        .DATA_WIDTH(DATA_WIDTH)
    ) 
    mul1
    (
        .din1(num1),
        .din2(num2),
        .dout(sum)
    );
    
    always @(*)
    begin
        if((din1 < 0 && din2 < 0) || (din1 > 0 && din2 > 0))
            dout[2*DATA_WIDTH-1:0] = sum[2*DATA_WIDTH-1:0];
        else if((din1 < 0 && din2 > 0) || (din1 > 0 && din2 < 0))
            dout[2*DATA_WIDTH-1:0] = ~sum[2*DATA_WIDTH-1:0] + 1'b1;
        else
            dout = 0;    
    end
    
endmodule