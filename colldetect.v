`include "defs.v"

module colldetect
(
	input               vblank,
	input       [10:0]  left_paddle_pos,
	input       [10:0]  right_paddle_pos,
	input               ball_dir,
	input       [10:0]  ball_h,
	input       [10:0]  ball_v,
	input        [3:0]  ball_speed,
	output reg          coll_paddle,
	output reg          coll_wall
);

initial coll_wall = 1'b0;

always @(posedge vblank) begin
	if (ball_dir == `LEFT) begin
		if ((ball_h - ball_speed) <= `TABLE_LEFT)
			coll_wall <= 1'b1;
		else
			coll_wall <= 1'b0;
	end else begin
		if ((ball_h + `BALL_HSIZE + ball_speed) >= `TABLE_RIGHT)
			coll_wall <= 1'b1;
		else
			coll_wall <= 1'b0;
	end
end

endmodule
