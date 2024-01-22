`timescale 1ns/1ps

module test_ssr_cal;
//Parameters
parameter DATA_WIDTH = 32;
parameter ANTENA_NUM = 1;

//Inputs
reg signed [ANTENA_NUM*DATA_WIDTH-1:0] real_part;
reg signed [ANTENA_NUM*DATA_WIDTH-1:0] imag_part;

//Outputs
wire signed [2*ANTENA_NUM*DATA_WIDTH-1:0] ssr;

initial begin
    $from_myhdl(
        real_part,
        imag_part
    );
    $to_myhdl(
        ssr
    );
    // dump file
    $dumpfile("test_ssr_cal.lxt");
    $dumpvars(0, test_ssr_cal);
end

ssr_cal #
(
    .DATA_WIDTH(DATA_WIDTH),
    .ANTENA_NUM(ANTENA_NUM)
)
uut (
    .real_part(real_part),
    .imag_part(imag_part),
    .ssr(ssr)
);
endmodule