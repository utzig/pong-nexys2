`include "defs.v"

module pong
(
	input             clk,
	input      [3:0]  sw,
	input      [3:0]  btn,
	output     [2:0]  led,
	output            hs,
	output            vs,
	output     [7:0]  rgb
);

wire   [10:0]  hcount;
wire   [10:0]  vcount;
reg            clk_2;

reg            color;
wire           vblank;
reg            blank;

wire           coll_paddle;
wire           coll_wall;
wire           ball_dir;
wire   [10:0]  ball_h;
wire   [10:0]  ball_v;
wire           ball_valid;
wire           bg_valid;
wire   [10:0]  left_paddle_pos;
wire   [10:0]  right_paddle_pos;
wire           left_paddle_valid;
wire           right_paddle_valid;

assign led[0] = coll_paddle;
assign rgb[0] = color;
assign rgb[1] = color;
assign rgb[2] = color;
assign rgb[3] = color;
assign rgb[4] = color;
assign rgb[5] = color;
assign rgb[6] = color;
assign rgb[7] = color;

always @(posedge clk) begin
	clk_2 <= ~clk_2;
	
end

vga_controller vga0
(
	.rst         ( 1'b0    ),
	.pixel_clk   ( clk_2   ),
	.hcount      ( hcount  ),
	.vcount      ( vcount  ),
	.hs          ( hs      ),
	.vs          ( vs      ),
	.vblank      ( vblank  )
);

ball ball0
(
	.clk          ( clk_2             ),
	.hcount       ( hcount            ),
	.vcount       ( vcount            ),
	.speed        ( sw                ),
	.vblank       ( blank             ),
	.change_dir   ( coll_paddle       ),
	.ball_h_dir   ( ball_dir          ),
	.ball_h_init  ( ball_h            ),
	.ball_v_init  ( ball_v            ),
	.pixel_valid  ( ball_valid        )
);

background background0
(
	.clk          ( clk              ),
	.hcount       ( hcount           ),
	.vcount       ( vcount           ),
	.pixel_valid  ( bg_valid         )
);

paddle left_paddle
(
	.clk           ( clk                     ),
	.hcount        ( hcount                  ),
	.vcount        ( vcount                  ),
	.hpos          ( `PADDLE_LEFT            ),
	.up            ( btn[1]                  ),
	.down          ( btn[0]                  ),
	.vblank        ( blank                   ),
	.paddle_v_pos  ( left_paddle_pos         ),
	.pixel_valid   ( left_paddle_valid       )
);

paddle right_paddle
(
	.clk           ( clk                     ),
	.hcount        ( hcount                  ),
	.vcount        ( vcount                  ),
	.hpos          ( `PADDLE_RIGHT           ),
	.up            ( btn[3]                  ),
	.down          ( btn[2]                  ),
	.vblank        ( blank                   ),
	.paddle_v_pos  ( right_paddle_pos        ),
	.pixel_valid   ( right_paddle_valid      )
);

colldetect colldetect0
(
	.clk               ( clk                     ),
	.left_paddle_pos   ( left_paddle_pos         ),
	.right_paddle_pos  ( right_paddle_pos        ),
	.ball_dir          ( ball_dir                ),
	.ball_h            ( ball_h                  ),
	.ball_v            ( ball_v                  ),
	.ball_speed        ( sw                      ),
	.coll_paddle       ( coll_paddle             ),
	.coll_wall         ( led[1]                  )
);

always @(posedge clk_2) begin
	blank <= vblank;

	if (
	      ball_valid == 1'b1 ||
	      bg_valid == 1'b1 ||
	      left_paddle_valid == 1'b1 ||
	      right_paddle_valid == 1'b1
	   )
	begin
		color = 1'b1;
	end else begin
		color = 1'b0;
	end

end

endmodule
