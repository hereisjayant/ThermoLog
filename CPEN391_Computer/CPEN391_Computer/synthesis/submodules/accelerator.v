module accelerator (
    input clk,
    input reset_n,
    input unsigned [1:0] addr, 
    input rd_en,
    input wr_en,
    output reg unsigned [31:0] readdata, 
    input unsigned [31:0] writedata
);

    reg unsigned [31:0] saved_value;
    integer i;

    // writing
    always @ (posedge clk) begin
        if (reset_n == 0) saved_value <= 32'b0;
        else if (wr_en == 1 && addr == 2'b00) saved_value <= writedata;
        else if (wr_en == 1 && addr == 2'b01) saved_value <= saved_value + 1;
    end

    // reading 
    always@(*) begin
        readdata <= 32'b0; 
        if (rd_en == 1) begin
            if (addr == 2'b00) begin 
                for(i = 0; i < 32; i = i + 1) readdata[i] <= saved_value[31 - i]; 
            end
            else if (addr == 2'b01) readdata <= saved_value;
            else if (addr == 2'b10) readdata <= ~saved_value;
        end 
    end
endmodule