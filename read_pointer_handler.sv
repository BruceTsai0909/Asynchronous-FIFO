module read_pointer_handler #(parameter WIDTH=3) (
  input r_en,
  input rclk,
  input rrst_n,
  input [WIDTH:0] g_wptr_sync,
  output reg [WIDTH:0] b_rptr,
  output reg [WIDTH:0] g_rptr,
  output reg empty,
);

wire rempty;

reg [WIDTH:0] b_rptr_next;
reg [WIDTH:0] g_rptr_next;

always@(posedge rclk or negedge rrst_n) begin
  if(!rrst_n) begin
    b_rptr <= 0;
    g_rptr <= 0;
  end
  else begin
    b_rptr <= b_rptr_next;
    g_rptr <= g_rptr_next;
  end
end

assign b_rptr_next = b_rptr + (r_en & !empty);
assign g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;
assign rempty = (g_wptr_sync == g_rptr_next);

always@(posedge rclk or negedge rrst_n)begin
  if(!rrst_n) empty <= 1;
  else empty <= rempty;
end


endmodule