`include "defs.v"

module background
(
	input               clk,
	input       [10:0]  hcount,
	input       [10:0]  vcount,
	output              pixel_valid
);

reg   left_valid;
reg   right_valid;
reg   top_valid;
reg   bottom_valid;


always @(posedge clk) begin
	if (  hcount <= `TABLE_LEFT &&
	      hcount >= (`TABLE_LEFT - `TABLE_WIDTH) &&
	      vcount >= (`TABLE_TOP - `TABLE_WIDTH) &&
	      vcount <= (`TABLE_BOTTOM + `TABLE_WIDTH)
	   )
		left_valid <= 1'b1;
	else
		left_valid <= 1'b0;
end

always @(posedge clk) begin
	if (  hcount >= `TABLE_RIGHT &&
	      hcount <= (`TABLE_RIGHT + `TABLE_WIDTH) &&
	      vcount >= (`TABLE_TOP - `TABLE_WIDTH) &&
	      vcount <= (`TABLE_BOTTOM + `TABLE_WIDTH)
	   )
		right_valid <= 1'b1;
	else
		right_valid <= 1'b0;
end

always @(posedge clk) begin
	if (  vcount <= `TABLE_TOP &&
	      vcount >= (`TABLE_TOP - `TABLE_WIDTH) &&
	      hcount >= (`TABLE_LEFT - `TABLE_WIDTH) &&
	      hcount <= (`TABLE_RIGHT + `TABLE_WIDTH)
	   )
		top_valid <= 1'b1;
	else
		top_valid <= 1'b0;
end

always @(posedge clk) begin
	if (  vcount >= `TABLE_BOTTOM &&
	      vcount <= (`TABLE_BOTTOM + `TABLE_WIDTH) &&
	      hcount >= (`TABLE_LEFT - `TABLE_WIDTH) &&
	      hcount <= (`TABLE_RIGHT + `TABLE_WIDTH)
	   )
		bottom_valid <= 1'b1;
	else
		bottom_valid <= 1'b0;
end

assign pixel_valid = left_valid | right_valid | top_valid | bottom_valid;

endmodule
