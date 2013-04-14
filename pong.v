`include "defs.v"

module pong
(
	input             clk,
	input      [3:0]  sw,
	input      [3:0]  btn,
	output            hs,
	output            vs,
	output reg [2:0]  red,
	output reg [2:0]  green,
	output reg [1:0]  blue
);

wire   [10:0]  hcount;
wire   [10:0]  vcount;
reg            clk_2;

wire           vblank;
reg            blank;

wire           ball_valid;
wire           bg_valid;
wire           left_paddle_valid;
wire           right_paddle_valid;

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
	.hpos          ( `TABLE_LEFT + `HMARGIN  ),
	.up            ( btn[0]                  ),
	.down          ( btn[1]                  ),
	.vblank        ( blank                   ),
	.pixel_valid   ( left_paddle_valid       )
);

paddle right_paddle
(
	.clk           ( clk                                      ),
	.hcount        ( hcount                                   ),
	.vcount        ( vcount                                   ),
	.hpos          ( `TABLE_RIGHT - `HMARGIN - `PADDLE_WIDTH  ),
	.up            ( btn[2]                                   ),
	.down          ( btn[3]                                   ),
	.vblank        ( blank                                    ),
	.pixel_valid   ( right_paddle_valid                       )
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
		red <= 3'h7;
		green <= 3'h7;
		blue <= 2'h3;
	end else begin
		red <= 3'h0;
		green <= 3'h0;
		blue <= 2'h0;
	end

end

endmodule
