module mul #
    (
        parameter DATA_WIDTH = 32
    )
    (
    input [DATA_WIDTH-1:0] din1,
    input [DATA_WIDTH-1:0] din2,
    output reg [2*DATA_WIDTH-1:0] dout
    );
    integer i;
    
    always@(*)
    begin
        dout = 0;
        for(i = 0; i < DATA_WIDTH; i = i + 1)
        begin
            if(din2[i] == 1)
            begin
                dout = (din1 << i) + dout;
            end
            else
                dout = dout;
        end
    end 
endmodule