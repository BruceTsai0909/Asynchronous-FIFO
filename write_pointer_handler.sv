module write_pointer_handler #(parameter WIDTH=3) (
  input wclk, w_en, wrst_n, 
  input [WIDTH:0] g_rptr_sync,
  output reg full,
  output reg [WIDTH:0] b_wptr,
  output reg [WIDTH:0] g_wptr
);
  
  reg [WIDTH:0] b_wptr_next;
  reg [WIDTH:0] g_wptr_next;
  wire wfull;

  assign b_wptr_next = b_wptr + (w_en & !full);
  assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;
  
  always@(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
        b_wptr <= 0;
        g_wptr <= 0;
    end
    else begin
        b_wptr <= b_wptr_next;
        g_wptr <= g_wptr_next;
    end
  end

  assign wfull = (g_wptr_next == {~g_rptr_sync[WIDTH:WIDTH-1], g_rptr_sync[WIDTH-2:0]});

  always@(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) full <= 0;
    else fulll <= wfull;
  end

  
endmodule