`ifndef _defs_v_
`define _defs_v_

`define HMAX   11'd800
`define VMAX   11'd525
`define HLINES 11'd640
`define HFP    11'd648
`define HSP    11'd744
`define VLINES 11'd480
`define VFP    11'd482
`define VSP    11'd484
`define SPP    1'b0

`define BALL_HSIZE  11'd4
`define BALL_VSIZE  11'd4
`define BALL_RED    3'h7;
`define BALL_GREEN  3'h0;
`define BALL_BLUE   2'h0;

`define RIGHT       1'b0
`define LEFT        1'b1
`define DOWN        1'b0
`define UP          1'b1

`define TABLE_TOP     11'd60
`define TABLE_BOTTOM  11'd420
`define TABLE_LEFT    11'd30
`define TABLE_RIGHT   11'd610
`define TABLE_WIDTH   11'd5

`define PADDLE_HEIGHT 11'd20
`define PADDLE_WIDTH  11'd5
`define PADDLE_SPEED  4'd5

`define HMARGIN        11'd10
`define VMARGIN        11'd5

`define PADDLE_LEFT    (`TABLE_LEFT + `HMARGIN)
`define PADDLE_RIGHT   (`TABLE_RIGHT - `HMARGIN - `PADDLE_WIDTH)

`endif
