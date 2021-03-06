`include "defs.v"

module vga_controller
(
	input                rst,
	input                pixel_clk,
	output       [10:0]  hcount,
	output       [10:0]  vcount,
	output reg           hs,
	output reg           vs,
	output reg           vblank
);

reg   [10:0] hcounter;
reg   [10:0] vcounter;
reg          video_enable;
reg          blanking;

assign hcount = hcounter;
assign vcount = vcounter;

always @(posedge pixel_clk) begin
	vblank <= blanking;
end

always @(posedge pixel_clk) begin
	if (rst == 1'b1)
		hcounter <= 11'b0;
	else if (hcounter == `HMAX)
		hcounter <= 11'b0;
	else
		hcounter <= hcounter + 1;
end

always @(posedge pixel_clk) begin
	if (rst == 1'b1)
		vcounter <= 11'b0;
	else if (hcounter == `HMAX) begin
		if (vcounter == `VMAX)
			vcounter <= 11'b0;
		else
			vcounter <= vcounter + 1;
	end
end

always @(posedge pixel_clk) begin
	if (hcounter >= `HFP && hcounter < `HSP)
		hs <= `SPP;
	else
		hs <= ~`SPP;
end

always @(posedge pixel_clk) begin
	if (vcounter >= `VFP && vcounter < `VSP)
		vs <= `SPP;
	else
		vs <= ~`SPP;
end

always @(hcounter or vcounter) begin
	if (hcounter < `HLINES && vcounter < `VLINES)
		video_enable = 1'b1;
	else
		video_enable = 1'b0;

	if (vcounter >= `VLINES)
		blanking = 1'b1;
	else
		blanking = 1'b0;
end

endmodule
