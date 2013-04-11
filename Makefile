SRC = vga_controller.v ball.v background.v defs.v pong.v

CLEAN = pong.bgn pong.drc pong.mrp pong.ngd pong.pcf \
	pong.bld pong.lso stopwatch.lso pong.ncd pong.ngm pong.srp \
	pong.bit pong_signalbrowser.* pong-routed_pad.tx \
	pong.map pong_summary.xml timing.twr \
	pong-routed* pong_usage* pong.ngc param.opt netlist.lst \
	xst pong.prj pong*.xrpt smartpreview.twr pong.svf _impactbatch.log

all: pong.bit

pong.prj: $(SRC)
	rm -f pong.prj
	@for i in `echo $^`; do \
	    echo "verilog worlk $$i" >> pong.prj; \
	done

pong.ngc: pong.prj
	xst -ifn pong.xst

pong.ngd: pong.ngc nexys2.ucf
	ngdbuild -uc nexys2.ucf pong.ngc

pong.ncd: pong.ngd
	map pong.ngd

pong-routed.ncd: pong.ncd
	par -ol high -w pong.ncd pong-routed.ncd

pong.bit: pong-routed.ncd
	bitgen -w pong-routed.ncd pong.bit

upload:
	djtgcfg prog -d Nexys2 -i 0 -f pong.bit

clean:
	rm -Rf $(CLEAN)

.PHONY: clean view
