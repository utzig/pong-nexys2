`include "defs.v"

module pong
(
	input             clk,
	input      [3:0]  sw,
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
	.pixel_valid  ( ball_pixel_valid  )
);

always @(posedge clk_2) begin
	blank <= vblank;

	if (ball_pixel_valid == 1'b1) begin
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
