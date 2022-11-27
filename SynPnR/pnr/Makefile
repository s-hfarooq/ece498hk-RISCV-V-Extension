all:
	SDF_OUT_DIR=../$(SDF_OUT_DIR) GDS_LIB=$(GDS_LIB) LIB_LEF=$(LIB_LEF) TECH_LEF=$(TECH_LEF) SDC_OUT_DIR=../$(SDC_OUT_DIR) VLOGOUT_DIR=../$(VLOGOUT_DIR) TIME_LIB=$(TSMC_LIB) TOP_LEVEL=$(TOP_LEVEL) innovus -init encounter.tcl

pnr_shell:
	SDF_OUT_DIR=../$(SDF_OUT_DIR) GDS_LIB=$(GDS_LIB) LIB_LEF=$(LIB_LEF) TECH_LEF=$(TECH_LEF) SDC_OUT_DIR=../$(SDC_OUT_DIR) VLOGOUT_DIR=../$(VLOGOUT_DIR) TIME_LIB=$(TSMC_LIB) TOP_LEVEL=$(TOP_LEVEL) innovus

clean:
	rm -rf .routing_guide.rgf
	rm -rf .tdrlog
	rm -rf .timing_file.tif
	rm -rf cts.rguide
	rm -rf encounter.cmd*
	rm -rf encounter.log*
	rm -rf innovus.cmd*
	rm -rf innovus.log*
	rm -rf final.def
	rm -rf final.dspf
	rm -rf final.gds2
	rm -rf report.*
	rm -rf $(TOP_LEVEL).*
	rm -rf tiehilo.rpt
	rm -rf timingReports
	rm -rf v2lvs.log
	rm -rf .viaViol.*
	rm -rf .clock_group_typView_*
