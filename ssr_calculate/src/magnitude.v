module magnitude #
    (
        parameter DATA_WIDTH = 32
    )
    (
    input signed [DATA_WIDTH-1:0] real_part,
    input signed [DATA_WIDTH-1:0] imag_part,
    output signed [2*DATA_WIDTH-1:0] out
    );
    
    wire signed [2*DATA_WIDTH-1:0] square_real;
    wire signed [2*DATA_WIDTH-1:0] square_imag;
    
    multi #
    (
        .DATA_WIDTH(DATA_WIDTH)
    )
    m1
    (
        .din1(real_part),
        .din2(real_part),
        .dout(square_real)
    );

    multi #
    (
        .DATA_WIDTH(DATA_WIDTH)
    )
    m2
    (
        .din1(imag_part),
        .din2(imag_part),
        .dout(square_imag)
    );
    
    assign out = square_real + square_imag;
                                                  
endmodule