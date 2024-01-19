module ssr_cal #
    (
        parameter DATA_WIDTH = 32,
        parameter ANTENA_NUM = 4
    )
    (
        input signed [ANTENA_NUM*DATA_WIDTH-1:0] real_part,
        input signed [ANTENA_NUM*DATA_WIDTH-1:0] imag_part,

        output signed [2*ANTENA_NUM*DATA_WIDTH-1:0] ssr
    );

    genvar i;
    generate
        for(i=0;i<ANTENA_NUM;i=i+1) begin:magnitude_f
            magnitude #
            (
                .DATA_WIDTH(DATA_WIDTH)
            )
            uut
            (
                .real_part( real_part[DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i] ),
                .imag_part( imag_part[DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i] ),
                .out( real_part[2*DATA_WIDTH*(i+1)-1 : 2*DATA_WIDTH*i] )
            );
        end
        
    endgenerate
endmodule