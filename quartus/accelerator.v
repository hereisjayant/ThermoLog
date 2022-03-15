module accelerator (
    input clk,
    input reset_n,
    input unsigned [3:0] addr,
    input rd_en,
    input wr_en,
    output reg unsigned [31:0] readdata,
    input unsigned [31:0] writedata
);

    // define 3 by 3 noise reduction matrix
    reg [31:0] p1; // top left pixel
    reg [31:0] p2; // top pixel
    reg [31:0] p3; // top right pixel
    reg [31:0] p4; // center left pixel
    reg [31:0] p5; // center pixel
    reg [31:0] p6; // center right pixel
    reg [31:0] p7; // bottom left pixel
    reg [31:0] p8; // bottom pixel
    reg [31:0] p9; // bottom right pixel

    // writing pixel value into registers
    always @ (posedge clk) begin

        // active low reset
        if (!reset_n) begin
            p1 = 32'b0;
            p2 = 32'b0;
            p3 = 32'b0;
            p4 = 32'b0;
            p5 = 32'b0;
            p6 = 32'b0;
            p7 = 32'b0;
            p8 = 32'b0;
            p9 = 32'b0;
        end

        // write individual pixel value
        else if (wr_en) begin
            case (addr)
                4'h1: p1 = writedata;
                4'h2: p2 = writedata;
                4'h3: p3 = writedata;
                4'h4: p4 = writedata;
                4'h5: p5 = writedata;
                4'h6: p6 = writedata;
                4'h7: p7 = writedata;
                4'h8: p8 = writedata;
                4'h9: p9 = writedata;
                default : /* none */;
            endcase
        end
    end

    // combinational logic for output pixel value
    always @ (*) begin
        if (rd_en == 1)
            if (addr == 4'h0)
                readdata = (
                    p1 * 32'h05 + p2 * 32'h0A + p3 * 32'h05 + 
                    p4 * 32'h0A + p5 * 32'h28 + p6 * 32'h0A + 
                    p7 * 32'h05 + p8 * 32'h0A + p9 * 32'h05
                );
        else readdata = 32'd0;
    end
endmodule
