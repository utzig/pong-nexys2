`include "defs.v"

module ball
(
	input               clk,
	input       [10:0]  hcount,
	input       [10:0]  vcount,
	input       [3:0]   speed,
	input               vblank,
	output reg          pixel_valid
);

reg    [4:0]   ball_speed;
reg            ball_h_dir;
reg            ball_v_dir;

reg    [10:0]  ball_h_init;
reg    [10:0]  ball_v_init;

initial begin
	ball_h_init = 10'd310;
	ball_v_init = 10'd230;
	ball_h_dir = 1'b0;
	ball_v_dir = 1'b0;
end

always @(posedge clk) begin
	ball_speed <= speed;

	if (hcount >= ball_h_init && hcount <= (ball_h_init + `BALL_HSIZE) &&
	    vcount >= ball_v_init && vcount <= (ball_v_init + `BALL_VSIZE))
		pixel_valid <= 1'b1;
	else
		pixel_valid <= 1'b0;
end

always @(posedge vblank) begin
	if (ball_h_dir == `RIGHT) begin
		if ((ball_h_init + `BALL_HSIZE + ball_speed) >= `HLINES)
			ball_h_dir <= `LEFT;
		else
			ball_h_init <= ball_h_init + ball_speed;
	end else begin
		if (ball_h_init < ball_speed)
			ball_h_dir <= `RIGHT;
		else
			ball_h_init <= ball_h_init - ball_speed;
	end

	if (ball_v_dir == `DOWN) begin
		if ((ball_v_init + `BALL_VSIZE + ball_speed) >= `VLINES)
			ball_v_dir <= `UP;
		else
			ball_v_init <= ball_v_init + ball_speed;
	end else begin
		if (ball_v_init < ball_speed)
			ball_v_dir <= `DOWN;
		else
			ball_v_init <= ball_v_init - ball_speed;
	end
end

endmodule
