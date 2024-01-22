`timescale 1ns/1ps

module test_sfu_check;
//Parameters
parameter DATA_WIDTH = 8;
parameter LABEL_WIDTH = 4; //16个输入天线

//Inputs
reg clk=0;
reg rst=0;
reg x_valid=0;
reg [DATA_WIDTH-1 : 0] x_0=0;
reg [DATA_WIDTH-1 : 0] x_1=0;
reg [LABEL_WIDTH-1:0] x_label_0;
reg [LABEL_WIDTH-1:0] x_label_1;
//Outputs
wire [DATA_WIDTH-1 : 0] y_0;
wire [DATA_WIDTH-1 : 0] y_1;
wire flag_same_sfu;
wire y_valid;

initial begin
    $from_myhdl(
        clk,
        rst,
        x_valid,
        x_0,
        x_1,
        x_label_0,
        x_label_1
    );
    $to_myhdl(
        y_0,
        y_1,
        flag_same_sfu,
        y_valid
    );
    // dump file
    $dumpfile("test_sfu_check.lxt");
    $dumpvars(0, test_sfu_check);
end

sfu_check #
(
    .DATA_WIDTH(DATA_WIDTH),
    .LABEL_WIDTH(LABEL_WIDTH)
)
uut (
    .clk(clk),
    .rst(rst),
    .x_valid(x_valid),
    .x_0(x_0),
    .x_1(x_1),
    .x_label_0(x_label_0),
    .x_label_1(x_label_1),
    .y_0(y_0),
    .y_1(y_1),
    .flag_same_sfu(flag_same_sfu),
    .y_valid(y_valid)
);
endmodule