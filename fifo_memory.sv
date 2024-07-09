module fifo_memory #(parameter DATA_WIDTH=8, DEPTH=8, PTR_WIDTH=3) (
    input wclk,
    input rclk,
    input r_en,
    input w_en,

    input full,
    input empty,

    input [PTR_WIDTH:0] b_wptr,
    input [PTR_WIDTH:0] b_rptr,

    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
);

reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];

always@(posedge wclk) begin
    if(w_en & !full) begin
        fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
    end
end

always@(posedge rclk) begin
    if(r_en & !empty) begin
        data_out <= fifo[b_rptr[PTR_WIDTH-1:0]];
    end
end


endmodule