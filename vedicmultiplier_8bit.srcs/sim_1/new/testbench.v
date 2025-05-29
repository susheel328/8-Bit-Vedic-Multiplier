`timescale 1ns / 1ps

module tb_vedic_multiplier_8bit;

    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] p;

    // Instantiate the DUT (Design Under Test)
    vedic_multiplier_8bit uut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        // apply test values
        a = 8'd10; b = 8'd5;
        #10;

        a = 8'd15; b = 8'd15;
        #10;

        a = 8'd100; b = 8'd2;
        #10;

        a = 8'd255; b = 8'd255;
        #10;

        $finish;
    end

endmodule
