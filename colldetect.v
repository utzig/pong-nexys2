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
	output reg   [6:0]  seg,
	output reg   [3:0]  an,
	output reg          coll_paddle,
	output reg          coll_wall
);

initial coll_wall = 1'b0;

reg  [15:0]  counter;
reg          update_lcd;
reg  [3:0]   digit;
reg  [3:0]   player1_0;
reg  [3:0]   player1_1;
reg  [3:0]   player2_0;
reg  [3:0]   player2_1;
reg  [1:0]   cnt;

initial begin
	cnt = 2'b00;
	counter = 16'd0;
	update_lcd = 1'b0;
	update_lcd = 1'b0;
	player1_0 = 4'd0;
	player1_1 = 4'd0;
	player2_0 = 4'd0;
	player2_1 = 4'd0;
end

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

	counter <= counter + 16'd1;
	if (counter == 16'd50000) begin
		counter <= 16'd0;
		update_lcd <= 1'b1;
	end else
		update_lcd <= 1'b0;
end

always @(posedge update_lcd) begin
	case (cnt)
		2'b00:    digit <= player1_0;
		2'b01:    digit <= player2_1;
		2'b10:    digit <= player2_0;
		default:  digit <= player1_1;
	endcase

	case (digit)
		4'd0:    seg <= 7'b1000000;
		4'd1:    seg <= 7'b1111001;
		4'd2:    seg <= 7'b0100100;
		4'd3:    seg <= 7'b0110000;
		4'd4:    seg <= 7'b0011001;
		4'd5:    seg <= 7'b0010010;
		4'd6:    seg <= 7'b0000010;
		4'd7:    seg <= 7'b1111000;
		4'd8:    seg <= 7'b0000000;
		4'd9:    seg <= 7'b0010000;
		default: seg <= 7'b0001110;
	endcase

	case (cnt)
		2'b00:   an <= 4'b0111;
		2'b01:   an <= 4'b1011;
		2'b10:   an <= 4'b1101;
		default: an <= 4'b1110;
	endcase

	cnt <= cnt + 2'd1;
end

always @(posedge coll_wall) begin
	if (ball_dir == `LEFT) begin
		if (player1_0 == 4'd9) begin
			if (player1_1 == 4'd9)
				player1_1 <= 4'd0;
			else
				player1_1 <= player1_1 + 4'd1;
			player1_0 <= 4'd0;
		end else
			player1_0 <= player1_0 + 4'd1;
	end else begin
		if (player2_0 == 4'd9) begin
			if (player2_1 == 4'd9)
				player2_1 <= 4'd0;
			else
				player2_1 <= player2_1 + 4'd1;
			player2_0 <= 4'd0;
		end else
			player2_0 <= player2_0 + 4'd1;
	end
end

endmodule
