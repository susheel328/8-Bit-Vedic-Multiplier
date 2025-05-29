
//module vedic_multiplier_8bit(
//  input [7:0] a,b,
//  output [15:0]p
//);

//wire [7:0] w1,w2,w3,w4,w6,a1;
//wire [11:0] w5,w7,a2,a3;

//multi_4bit M1(.a(a[3:0]),.b(b[3:0]),.p(w1));//w[3:0] to be concatinated
//assign w2={4'b0000,w1[7:4]};

//multi_4bit M2(.a(a[7:4]),.b(b[3:0]),.p(w3));
//assign a1= w2+w3;

//multi_4bit M3(.a(a[3:0]),.b(b[7:4]),.p(w4));
//assign w5 ={4'b0000,w4[7:0]};

//multi_4bit M4(.a(a[7:4]),.b(b[7:4]),.p(w6));
//assign w7= {w6[7:0],4'b0000};

//assign a2=w5+w7;

//assign a3=a1+a2;

//assign p={a3,w1[3:0]};


//endmodule


`timescale 1ns / 1ps
module vedic_multiplier_8bit(
    input  wire        clk,
    input  wire        rst,
    //output [3:0] din1, din2, din3, din4, 
    output reg [6:0]   segments, // Seven segment outputs
    output reg [3:0]   anodes ,   // Anode control signals
    input [7:0] a,b,
   output [15:0]p
);

    reg [3:0] digits [3:0];    // Array of digits to display
    reg [1:0] digit_select;    // Current digit select
    reg [14:0] refresh_counter; // Refresh rate counter
    
    wire [7:0] w1,w2,w3,w4,w6,a1;// wires for vedic multiplier
    wire [11:0] w5,w7,a2,a3;// wires for vedic multiplier
   
    
    //VEDIC MULTIPLIER---------------------------------------------------------
    
    multi_4bit M1(.a(a[3:0]),.b(b[3:0]),.p(w1));
    assign w2={4'b0000,w1[7:4]};
    
    multi_4bit M2(.a(a[7:4]),.b(b[3:0]),.p(w3));
    assign a1= w2+w3;
    
    multi_4bit M3(.a(a[3:0]),.b(b[7:4]),.p(w4));
    assign w5 ={4'b0000,w4[7:0]};
    
    multi_4bit M4(.a(a[7:4]),.b(b[7:4]),.p(w6));
    assign w7= {w6[7:0],4'b0000};
    
    assign a2=w5+w7;
    
    assign a3=a1+a2;
    
    assign p={a3,w1[3:0]};
    
//    assign din1 = p[3:0];
//    assign din2 = p[7:4];
//    assign din3 = p[11:8];
//    assign din4 = p[15:12];
    
//-----------------------------------------------------------------------------


    // Initialize digits to display
    always @(p) begin
        digits[3] = p[3:0];
        digits[2] = p[7:4];
        digits[1] = p[11:8];
        digits[0] = p[15:12];
    end

    // Segment decoder instance
    wire [6:0] decoded_segments;
    segment_decoder seg_dec (
        .digit(digits[digit_select]),
        .segments(decoded_segments)
    );

    // Refresh rate control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 0;
            digit_select <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 25000) begin // Adjusted for 0.25 ms refresh rate
                refresh_counter <= 0;
                digit_select <= digit_select + 1;
                if (digit_select == 3)
                    digit_select <= 0;
            end
        end
    end

    // Update segments and anodes
    always @(*) begin
        segments = decoded_segments;
        anodes = 4'b1111;
        anodes[digit_select] = 1'b0; // Enable current digit's anode
    end

endmodule
