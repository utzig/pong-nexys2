module paddle
(
	input               clk,
	input       [10:0]  hcount,
	input       [10:0]  vcount,
	input       [10:0]  hpos,
	input               up,
	input               down,
	input               vblank,
	output reg          pixel_valid
);

reg    [10:0]  paddle_v_pos;

initial begin
	paddle_v_pos = 11'd230; //FIXME: 240 - `PADDLE_HEIGHT / 2;
end

always @(posedge clk) begin
	if
	(
	      vcount >= paddle_v_pos &&
	      vcount <= (paddle_v_pos + `PADDLE_HEIGHT) &&
	      hcount >= hpos &&
	      hcount <= (hpos + `PADDLE_WIDTH)
	)
		pixel_valid <= 1'b1;
	else
		pixel_valid <= 1'b0;
end

always @(posedge vblank) begin
	if
	(
	     up == 1'b1 &&
	     paddle_v_pos >= (`TABLE_TOP + `VMARGIN + `PADDLE_SPEED)
	)
		paddle_v_pos <= paddle_v_pos - `PADDLE_SPEED;

	if
	(
	     down == 1'b1 &&
	     (paddle_v_pos + `PADDLE_HEIGHT) <= (`TABLE_BOTTOM - `VMARGIN - `PADDLE_SPEED)
	)
		paddle_v_pos <= paddle_v_pos + `PADDLE_SPEED;
end

endmodule
