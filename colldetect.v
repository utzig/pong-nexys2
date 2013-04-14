`include "defs.v"

module colldetect
(
	input               clk,
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

always @(posedge clk) begin
	if (ball_dir == `LEFT) begin
		if ((ball_h - ball_speed) <= `TABLE_LEFT)
			coll_wall <= 1'b1;
		else begin
			coll_wall <= 1'b0;

			if ((ball_h - ball_speed) <= (`PADDLE_LEFT + `PADDLE_WIDTH) &&
			    !(ball_v > (left_paddle_pos + `PADDLE_HEIGHT) ||
			     (ball_v + `BALL_VSIZE) < left_paddle_pos))
				coll_paddle <= 1'b1;
			else
				coll_paddle <= 1'b0;
		end
	end else begin
		if ((ball_h + `BALL_HSIZE + ball_speed) >= `TABLE_RIGHT)
			coll_wall <= 1'b1;
		else begin
			coll_wall <= 1'b0;

			if ((ball_h + `BALL_HSIZE + ball_speed) >= `PADDLE_RIGHT &&
			    !(ball_v > (right_paddle_pos + `PADDLE_HEIGHT) ||
			     (ball_v + `BALL_VSIZE) < right_paddle_pos))
				coll_paddle <= 1'b1;
			else
				coll_paddle <= 1'b0;
		end
	end
end

endmodule
