//SFU检查模块
//规定1，2天线属于同一个SFU
//3，4天线属于同一个SFU
//依次类推
module sfu_check #
(
    parameter DATA_WIDTH = 8,
    parameter LABEL_WIDTH = 1
)
(
    input clk,rst,x_valid,
    input [DATA_WIDTH-1 : 0] x_0,x_1,
    input [LABEL_WIDTH-1:0] x_label_0,x_label_1,
    output reg [DATA_WIDTH-1 : 0] y_0,y_1,
    output reg flag_same_sfu,
    output reg y_valid
);

always @(posedge clk) begin
    if(rst == 1'b1) begin
        y_0 <= 0;
        y_1 <= 0;
        flag_same_sfu <= 0;
        y_valid <= 1'b0;
    end
    else begin
        y_valid <= x_valid;
        if(x_label_0 + 1'b1 == x_label_1)  begin
            if(x_label_0[0]==1'b0)begin
                flag_same_sfu <= 1;
                y_0 <= 0;
                y_1 <= 0;
            end
            else begin
                flag_same_sfu <= 0;
                y_0 <= x_0;
                y_1 <= x_1;
            end
        end
        else if(x_label_1 + 1'b1 == x_label_0) begin
            if(x_label_1[0]==1'b0)begin
                flag_same_sfu <= 1;
                y_0 <= 0;
                y_1 <= 0;
            end
            else begin
                flag_same_sfu <= 0;
                y_0 <= x_0;
                y_1 <= x_1;
            end
        end
        else begin
            flag_same_sfu <= 0;
            y_0 <= x_0;
            y_1 <= x_1;
        end
    end
    
end

endmodule