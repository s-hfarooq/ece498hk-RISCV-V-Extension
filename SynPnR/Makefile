export

# Make file for TSMC 65RF place and route 
# Master Verilog file
TOP_LEVEL	= toplevel_498
# svt standard cells
TSMC65RF_PDK_IC6 = /ece498hk/libs/T65GP_RFMIM_2fF_1P0V_2P5V_1p9m_6X1Z1U_ALRDL_OA61_PDK
PDK_HOME	= $(TSMC65RF_PDK_IC6)/stdcell_dig/fb_tsmc065gp_rvt_lvt
VERILOG_LIB	= $(PDK_HOME)/aci/sc-ad10/verilog/tsmc65_rvt_sc_adv10.v
PROJECT_HOME	= .
OUT_DIR		= $(PROJECT_HOME)

TSMC_DB_DIR		= $(PDK_HOME)/aci/sc-ad10/synopsys
#TSMC_DB			= typical.db
TSMC_DB			= scadv10_cln65gp_rvt_ss_0p9v_125c.db
#TSMC_DB			= scadv10_cln65gp_rvt_tt_1p0v_25c.db
TSMC_DB_BEST	= scadv10_cln65gp_rvt_ff_1p1v_m40c.db
TSMC_LIB		= $(TSMC_DB_DIR)/scadv10_cln65gp_rvt_ss_0p9v_125c.lib
# TSMC_LIB		= $(TSMC_DB_DIR)/scadv10_cln65gp_rvt_tt_1p0v_25c.lib
TSMC_LIB_BEST	= $(TSMC_DB_DIR)/scadv10_cln65gp_rvt_ff_1p1v_m40c.lib
#TSMC_LIB		= $(TSMC_DB_DIR)/typical.lib
#TSMC_DB			= fast.db
#TSMC_LIB		= $(TSMC_DB_DIR)/fast.lib
LIB_LEF			= $(PDK_HOME)/aci/sc-ad10/lef/tsmc65_rvt_sc_adv10_macro.lef
TECH_LEF		= $(PDK_HOME)/aci/sc-ad10/lef/tsmc_cln65_a10_6X2Z_tech.lef
GDS_LIB			= $(PDK_HOME)/aci/sc-ad10/gds2/tsmc65_rvt_sc_adv10.gds2
CDL_LIB			= $(PDK_HOME)/aci/sc-ad10/lvs_netlist/tsmc65_rvt_sc_adv10.cdl

RTL_DIR			= $(PROJECT_HOME)/rtl_src
PNR_DIR			= $(PROJECT_HOME)/pnr
WORK_DIR		= $(PROJECT_HOME)/work
LOG_DIR			= $(PROJECT_HOME)/logs
REPORT_DIR		= $(PROJECT_HOME)/reports
SDC_OUT_DIR		= $(PROJECT_HOME)/sdcout
SDF_OUT_DIR		= $(PROJECT_HOME)/sdfout
VLOGOUT_DIR		= $(PROJECT_HOME)/vlogout

# VERILOG_FILES   = $(RTL_DIR)/verilog.sv
OUR_V_FILES := $(shell find $(PWD)/../src -maxdepth 1 -name '*.v')
OUR_SV_FILES := $(shell find $(PWD)/../src -maxdepth 1 -name '*.sv' ! -name "toplevel.sv")
VICUNA_PKG_SRCS := $(shell find $(PWD)/../src/vicuna/rtl -name '*_pkg.sv')
VICUNA_CFG_SRCS := $(shell find $(PWD)/../src/vicuna/ -name '*_config.sv')
VICUNA_SRCS := $(shell find $(PWD)/../src/vicuna/rtl -name '*.sv' ! -name '*_pkg.sv')

ENTRO_SRCS := $(shell find $(PWD)/../src/vicuna/ibex/other -name '*.sv')
DV_SRCS := $(shell find $(PWD)/../src/vicuna/ibex/vendor/lowrisc_ip/dv/sv/dv_utils -name '*.svh')
PRIM_PKG_SRCS := $(shell find $(PWD)/../src/vicuna/ibex/vendor/lowrisc_ip/ip/prim/rtl -name '*_pkg.sv')
PRIM_OTHER_SRCS := $(shell find $(PWD)/../src/vicuna/ibex/syn/rtl -name '*gating.v')
IBEX_PKG_SRCS := $(shell find $(PWD)/../src/vicuna/ibex/rtl -name '*_pkg.sv')
IBEX_SRCS := $(shell find $(PWD)/../src/vicuna/ibex/rtl -name '*.sv' ! -name '*_pkg.sv' ! -name '*_tracing.sv')
VERILOG_FILES := $(ENTRO_SRCS) $(DV_SRCS) $(PRIM_PKG_SRCS) $(PRIM_OTHER_SRCS) $(IBEX_PKG_SRCS) $(IBEX_SRCS) $(VICUNA_PKG_SRCS) $(VICUNA_CFG_SRCS) $(VICUNA_SRCS) $(OUR_V_FILES) $(OUR_SV_FILES) $(PWD)/../src/toplevel.sv
# PNR Cells to take care of RVT/LVT stuff
POWERCAP_CELL  = FILLCAP16A10TR
WELLTAP_CELL   = FILLTIE2A10TR
TIEHILO_CELL   = TIEHIX1MA10TR TIELOX1MA10TR
DESIGN_CLOCK   = clk
DESIGN_RESET   = rst
FILLER_CELL    = "FILL128A10TR FILL64A10TR FILL32A10TR FILL16A10TR FILLCAP8A10TR FILL4A10TR FILL2A10TR FILL1A10TR"
INCPHY_CELL    = FILLCAP16A10TR FILLCAP8A10TR
EXCPHY_CELL    = FILL128A10TR FILLTIE128A10TR FILL64A10TR FILLTIE64A10TR FILL32A10TR FILLTIE32A10TR FILL16A10TR FILLTIE16A10TR FILL8A10TR FILLTIE8A10TR FILL4A10TR FILLTIE4A10TR FILL2A10TR FILLTIE2A10TR FILL1A10TR

################################################################################
# Define targets
################################################################################


#make usage
usage:
	@echo "Makefile targets:"
	@echo "  all ***incomplete***"
	@echo "  clean"
	@echo "  synthesis_only"
	@echo "  synthesis_shell"
	@echo "  synthesis_dv"
	@echo "  sim_rtl"
	@echo "  sim_gate"
	@echo "  sim_gate_sdf"
	@echo "  pnr"
	@echo "  pnr_shell"
	@echo "  pnr_clean"
	@echo "  sim_pnr"
	@echo "  sim_pnr_sdf"

#make all
all: sim_rtl sim_gate sim_gate_sdf pnr sim_pnr sim_pnr_sdf


#synthesize rtl and create gate level netlist
synthesis_only: $(PROJECT_HOME)/.gate_compiled


#simulate rtl
sim_rtl: $(VECTOR_DIR)/$(TOP_LEVEL).rtl.list


#simulate gate level
sim_gate: $(VECTOR_DIR)/$(TOP_LEVEL).gate.list


#simulate gate level with sdf
sim_gate_sdf: $(VECTOR_DIR)/$(TOP_LEVEL).gate.sdf.list


#place and route
#pnr: $(PROJECT_HOME)/.gate_compiled
pnr: $(PROJECT_HOME)/.gate_compiled
	$(MAKE) -C $(PNR_DIR)
	@touch $(PROJECT_HOME)/.pnr_complete

pnr_shell:
	$(MAKE) -C $(PNR_DIR) pnr_shell

pnr_clean:
	$(MAKE) -C $(PNR_DIR) clean

#simulate pnr netlist
sim_pnr: $(VECTOR_DIR)/$(TOP_LEVEL).pnr.list


#simulate pnr with sdf
sim_pnr_sdf: $(VECTOR_DIR)/$(TOP_LEVEL).pnr.sdf.list


##make work directory
#$(WORK_DIR):
#	@vlib $(WORK_DIR)


#make log file directory
$(LOG_DIR):
	@mkdir $(LOG_DIR)


#make report directory
$(REPORT_DIR):
	@mkdir $(REPORT_DIR)


#make synopsys design constraints directory
$(SDC_OUT_DIR):
	@mkdir $(SDC_OUT_DIR)


#make standard delay format directory
$(SDF_OUT_DIR):
	@mkdir $(SDF_OUT_DIR)


#make verilog output directory
$(VLOGOUT_DIR):
	@mkdir $(VLOGOUT_DIR)


#make do file directory
$(DOFILE_DIR):
	@mkdir $(DOFILE_DIR)


#make vector directory
$(VECTOR_DIR):
	@mkdir $(VECTOR_DIR)


#compile rtl
$(PROJECT_HOME)/.verilog_compiled: $(LOG_DIR) $(VERILOG_FILES) $(PROJECT_HOME)/.verilog_lib_compiled
	@echo "##################################################################"
	@echo "#     Compiling RTL Verilog                                      #"
	@echo "##################################################################"
	@xmverilog -c $(VERILOG_FILES) > $(LOG_DIR)/verilog_compile.log
	@touch $(PROJECT_HOME)/.verilog_compiled


#compile verilog library
$(PROJECT_HOME)/.verilog_lib_compiled: $(LOG_DIR)
	@echo "##################################################################"
	@echo "#     Compiling Verilog Library                                  #"
	@echo "##################################################################"
	@xmverilog -c $(VERILOG_LIB) > $(LOG_DIR)/verilog_lib.log
	@touch $(PROJECT_HOME)/.verilog_lib_compiled


#synthesize rtl
$(PROJECT_HOME)/.gate_compiled: $(SDF_OUT_DIR) $(SDC_OUT_DIR) $(VLOGOUT_DIR) $(REPORT_DIR) $(PROJECT_HOME)/bin/dc_syn $(VERILOG_FILES) $(PROJECT_HOME)/.verilog_compiled
	@echo "##################################################################"
	@echo "#     Synthesizing Verilog                                       #"
	@echo "##################################################################"
	@SDF_OUT_DIR=$(SDF_OUT_DIR) SDC_OUT_DIR=$(SDC_OUT_DIR) VLOGOUT_DIR=$(VLOGOUT_DIR) TOP_LEVEL=$(TOP_LEVEL) REPORT_DIR=$(REPORT_DIR) VERILOG_FILES="$(VERILOG_FILES)" SYNOPSYS_DB_DIR=$(TSMC_DB_DIR) SYNOPSYS_DB=$(TSMC_DB) SYNOPSYS_DB_BEST=$(TSMC_DB_BEST) dc_shell-xg-t -f $(PROJECT_HOME)/bin/dc_syn > $(LOG_DIR)/$(TOP_LEVEL)_synthesis.log
	@xmverilog +xmtimescale+1ns/1ps -c $(VLOGOUT_DIR)/$(TOP_LEVEL).gate.v > $(LOG_DIR)/gate_source_compile.log
	@touch $(PROJECT_HOME)/.gate_compiled


#compile pnr verilog
#$(PROJECT_HOME)/.pnr_compiled: $(PROJECT_HOME)/.verilog_lib_compiled pnr
$(PROJECT_HOME)/.pnr_compiled: $(PROJECT_HOME)/.verilog_lib_compiled 
	@echo "##################################################################"
	@echo "#     Compiling place-and-route verilog                          #"
	@echo "##################################################################"
#	@vlog $(VLOGOUT_DIR)/$(TOP_LEVEL).pnr.v > $(LOG_DIR)/pnr_source_compiled.log

#make dofiles
$(DOFILE_DIR)/dofile.do: $(DOFILE_DIR)
	@echo "##################################################################"
	@echo "#     Creating do files                                          #"
	@echo "##################################################################"
	@DOFILE_DIR=$(DOFILE_DIR) $(PROJECT_HOME)/bin/make_bytes.pl
	@DOFILE_DIR=$(DOFILE_DIR) $(PROJECT_HOME)/bin/make_headers.pl
	@DOFILE_DIR=$(DOFILE_DIR) VECTOR_DIR=$(VECTOR_DIR) TOP_LEVEL=$(TOP_LEVEL) $(PROJECT_HOME)/bin/make_dofile.pl $(PROJECT_HOME)/bin/commands.vec


#make golden vectors
$(VECTOR_DIR)/golden_vectors: $(VECTOR_DIR) $(DOFILE_DIR)/dofile.do
	@echo "##################################################################"
	@echo "#     Making golden vectors                                      #"
	@echo "##################################################################"
	@VECTOR_DIR=$(VECTOR_DIR) $(PROJECT_HOME)/bin/make_outvectors.pl $(DOFILE_DIR)/dofile.do


#run rtl simulation
$(VECTOR_DIR)/$(TOP_LEVEL).rtl.list: $(PROJECT_HOME)/.verilog_compiled $(DOFILE_DIR)/dofile.do $(VECTOR_DIR)/golden_vectors
	@echo "##################################################################"
	@echo "#     Running RTL simulation                                     #"
	@echo "##################################################################"
	@vsim $(TOP_LEVEL) -do $(DOFILE_DIR)/dofile.do -quiet -c -t 100ps +nowarnTFMPC
	@mv $(VECTOR_DIR)/$(TOP_LEVEL).list $(VECTOR_DIR)/$(TOP_LEVEL).rtl.list
	@diff -q $(VECTOR_DIR)/$(TOP_LEVEL).rtl.list $(VECTOR_DIR)/golden_vectors
	@echo " "
	@echo "--> rtl vectors MATCH golden vectors :) <--"
	@echo " "


#run gate level simulation
$(VECTOR_DIR)/$(TOP_LEVEL).gate.list: $(PROJECT_HOME)/.gate_compiled $(DOFILE_DIR)/dofile.do $(VECTOR_DIR)/golden_vectors
	@echo "##################################################################"
	@echo "#     Running Gate-level simulation                              #"
	@echo "##################################################################"
	@vsim $(TOP_LEVEL) -do $(DOFILE_DIR)/dofile.do -quiet -c -t 100ps +nowarnTFMPC
	@mv $(VECTOR_DIR)/$(TOP_LEVEL).list $(VECTOR_DIR)/$(TOP_LEVEL).gate.list
	@diff -q $(VECTOR_DIR)/$(TOP_LEVEL).gate.list $(VECTOR_DIR)/golden_vectors
	@echo " "
	@echo "--> gate vectors MATCH golden vectors :) <--"
	@echo " "


#run gate level with sdf simulation
$(VECTOR_DIR)/$(TOP_LEVEL).gate.sdf.list: $(PROJECT_HOME)/.gate_compiled $(DOFILE_DIR)/dofile.do $(VECTOR_DIR)/golden_vectors
	@echo "##################################################################"
	@echo "#     Running Gate-level with SDF simulation                     #"
	@echo "##################################################################"
	@vsim $(TOP_LEVEL) -do $(DOFILE_DIR)/dofile.do -quiet -c +nowarnTFMPC -sdfmax $(SDF_OUT_DIR)/$(TOP_LEVEL).gate.sdf -t 1ps
	@mv $(VECTOR_DIR)/$(TOP_LEVEL).list $(VECTOR_DIR)/$(TOP_LEVEL).gate.sdf.list
	@diff -q $(VECTOR_DIR)/$(TOP_LEVEL).gate.sdf.list $(VECTOR_DIR)/golden_vectors
	@echo " "
	@echo "--> gate sdf vectors MATCH golden vectors :) <--"
	@echo " "


#run pnr level simulation
$(VECTOR_DIR)/$(TOP_LEVEL).pnr.list: $(PROJECT_HOME)/.pnr_compiled $(DOFILE_DIR)/dofile.do $(VECTOR_DIR)/golden_vectors
	@echo "##################################################################"
	@echo "#     Running place-and-route level simulation                   #"
	@echo "##################################################################"
	@vsim $(TOP_LEVEL) -do $(DOFILE_DIR)/dofile.do -quiet -c +nowarnTFMPC -t 100ps
	@mv $(VECTOR_DIR)/$(TOP_LEVEL).list $(VECTOR_DIR)/$(TOP_LEVEL).pnr.list
	@diff -q $(VECTOR_DIR)/$(TOP_LEVEL).pnr.list $(VECTOR_DIR)/golden_vectors
	@echo " "
	@echo "--> pnr vectors MATCH golden vectors :) <--"
	@echo " "


#run pnr level with sdf simulation
$(VECTOR_DIR)/$(TOP_LEVEL).pnr.sdf.list: $(PROJECT_HOME)/.pnr_compiled $(DOFILE_DIR)/dofile.do $(VECTOR_DIR)/golden_vectors
	@echo "##################################################################"
	@echo "#     Running place-and-route level with SDF simulation          #"
	@echo "##################################################################"
	@vsim $(TOP_LEVEL) -do $(DOFILE_DIR)/dofile.do -quiet -c +nowarnTFMPC -sdfmax $(SDF_OUT_DIR)/$(TOP_LEVEL).pnr.sdf -t 1ps
	@mv $(VECTOR_DIR)/$(TOP_LEVEL).list $(VECTOR_DIR)/$(TOP_LEVEL).pnr.sdf.list
	@diff -q $(VECTOR_DIR)/$(TOP_LEVEL).pnr.sdf.list $(VECTOR_DIR)/golden_vectors
	@echo " "
	@echo "--> pnr sdf vectors MATCH golden vectors :) <--"
	@echo " "


#clean up files
clean:
	$(MAKE) -C $(PNR_DIR) clean
	rm -rf $(SDC_OUT_DIR)
	rm -rf $(SDF_OUT_DIR)
	rm -rf $(REPORT_DIR)
	rm -rf $(LOG_DIR)
	rm -rf $(VLOGOUT_DIR)
	rm -rf $(WORK_DIR)
	rm -rf $(DOFILE_DIR)
	rm -rf $(VECTOR_DIR)
	rm -rf $(PROJECT_HOME)/.gate_compiled
	rm -rf $(PROJECT_HOME)/.pnr_complete
	rm -rf $(PROJECT_HOME)/.verilog_lib_compiled
	rm -rf $(PROJECT_HOME)/.verilog_compiled
	rm -rf $(PROJECT_HOME)/alib-52
	rm -rf $(PROJECT_HOME)/command.log
	rm -rf $(PROJECT_HOME)/default.svf
	rm -rf $(PROJECT_HOME)/transcript
	rm -rf $(PROJECT_HOME)/vsim.wlf


# Start a DC Shell with shell variables for debug / line-by-line synthesis
synthesis_shell: $(SDF_OUT_DIR) $(SDC_OUT_DIR) $(VLOGOUT_DIR) $(REPORT_DIR) $(PROJECT_HOME)/bin/dc_syn $(VERILOG_FILES)
	@echo "##################################################################"
	@echo "#     Starting Synthesis Shell                                   #"
	@echo "##################################################################"
	@SDF_OUT_DIR=$(SDF_OUT_DIR) SDC_OUT_DIR=$(SDC_OUT_DIR) VLOGOUT_DIR=$(VLOGOUT_DIR) TOP_LEVEL=$(TOP_LEVEL) REPORT_DIR=$(REPORT_DIR) VERILOG_FILES="$(VERILOG_FILES)" SYNOPSYS_DB_DIR=$(TSMC_DB_DIR) SYNOPSYS_DB=$(TSMC_DB) SYNOPSYS_DB_BEST=$(TSMC_DB_BEST) dc_shell-xg-t
