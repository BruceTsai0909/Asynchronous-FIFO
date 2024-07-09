`include "write_pointer_handler.sv"
`include "read_pointer_handler.sv"
`include "fifo_memory.sv"
`include "synchronizer.sv"

module asynchronize_fifo #(parameter DEPTH=8, DATA_WIDTH=8) (
    input [DATA_WIDTH-1:0] data_in,
    input w_en,
    input wrst_n,
    input wclk,
    input r_en,
    input rrst_n,
    input rclk,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);

    parameter PTR_WIDTH = $clog2(DEPTH);

    reg [PTR_WIDTH:0] g_rptr_sync, g_wptr_sync;
    reg [PTR_WIDTH:0] b_rptr, b_wptr;
    reg [PTR_WIDTH:0] g_rptr, g_wptr;


    synchronizer #(PTR_WIDTH) write_synchronizer (.clk(wclk), .rst_n(wrst_n), .d_in(g_rptr), .d_out(g_rptr_sync));
    synchronizer #(PTR_WIDTH) read_synchronizer (.clk(rclk), .rst_n(rrst_n), .d_in(g_wptr), .d_out(g_wptr_sync));

    write_pointer_handler #(PTR_WIDTH) wph (.wclk(wclk), .w_en(w_en), .wrst_n(wrst_n), .g_rptr_sync(g_rptr_sync), .full(full), .b_wptr(b_wptr), .g_wptr(g_wptr));
    read_pointer_handler #(PTR_WIDTH) rph (.r_en(r_en), .rclk(rclk), .rrst_n(rrst_n), .g_wptr_sync(g_wptr_sync), .b_rptr(b_rptr), .g_rptr(g_rptr), .empty(empty));

    fifo_memory fifomem ( .wclk(wclk), .rclk(rclk), .r_en(r_en), .w_en(w_en), .full(full), .empty(empty), .b_wptr(b_wptr), .b_rptr(b_rptr), .data_in(data_in), .data_out(data_out));
    
endmodule