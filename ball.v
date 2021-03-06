`include "defs.v"

module ball
(
	input               clk,
	input       [10:0]  hcount,
	input       [10:0]  vcount,
	input       [3:0]   speed,
	input               vblank,
	input               change_dir,
	output reg          ball_h_dir,
	output reg  [10:0]  ball_h_init,
	output reg  [10:0]  ball_v_init,
	output reg          pixel_valid
);

reg    [4:0]   ball_speed;
reg            ball_v_dir;

initial begin
	ball_h_init = 10'd310;
	ball_v_init = 10'd230;
	ball_h_dir = `RIGHT;
	ball_v_dir = `DOWN;
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
	if (change_dir == 1'b1) begin
		if (ball_h_dir == `LEFT)
			ball_h_dir <= `RIGHT;
		else
			ball_h_dir <= `LEFT;
	end else begin
		if (ball_h_dir == `RIGHT) begin
			if ((ball_h_init + `BALL_HSIZE + ball_speed) >= `TABLE_RIGHT)
				ball_h_dir <= `LEFT;
			else
				ball_h_init <= ball_h_init + ball_speed;
		end else begin
			if (ball_h_init < (`TABLE_LEFT + ball_speed))
				ball_h_dir <= `RIGHT;
			else
				ball_h_init <= ball_h_init - ball_speed;
		end

		if (ball_v_dir == `DOWN) begin
			if ((ball_v_init + `BALL_VSIZE + ball_speed) >= `TABLE_BOTTOM)
				ball_v_dir <= `UP;
			else
				ball_v_init <= ball_v_init + ball_speed;
		end else begin
			if (ball_v_init < (`TABLE_TOP + ball_speed))
				ball_v_dir <= `DOWN;
			else
				ball_v_init <= ball_v_init - ball_speed;
		end
	end
end

endmodule
