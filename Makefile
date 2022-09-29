#Collect All Source Files

VICUNA_PKG_SRCS := $(shell find $(PWD)/src/vicuna/rtl -name '*_pkg.sv')
VICUNA_CFG_SRCS := $(shell find $(PWD)/src/vicuna/ -name '*_config.sv')
VICUNA_SRCS := $(shell find $(PWD)/src/vicuna/rtl -name '*.sv' ! -name '*_pkg.sv')

ENTRO_SRCS := $(shell find $(PWD)/src/vicuna/ibex/other -name '*.sv')
DV_SRCS := $(shell find $(PWD)/src/vicuna/ibex/vendor/lowrisc_ip/dv/sv/dv_utils -name '*.svh')
PRIM_PKG_SRCS := $(shell find $(PWD)/src/vicuna/ibex/vendor/lowrisc_ip/ip/prim/rtl -name '*_pkg.sv')
PRIM_OTHER_SRCS := $(shell find $(PWD)/src/vicuna/ibex/syn/rtl -name '*gating.v')
IBEX_PKG_SRCS := $(shell find $(PWD)/src/vicuna/ibex/rtl -name '*_pkg.sv')
IBEX_SRCS := $(shell find $(PWD)/src/vicuna/ibex/rtl -name '*.sv' ! -name '*_pkg.sv' ! -name '*_tracing.sv')


SRCS := $(ENTRO_SRCS) $(DV_SRCS) $(PRIM_PKG_SRCS) $(PRIM_OTHER_SRCS) $(IBEX_PKG_SRCS) $(IBEX_SRCS) $(VICUNA_PKG_SRCS) $(VICUNA_CFG_SRCS) $(VICUNA_SRCS)
SYNTH_TCL := $(CURDIR)/synthesis.tcl
VCS_FLAGS = -full64 -lca -sverilog +lint=all,noNS -timescale=lns/10ps -debug -kdb -fsdb +liborder +libverbose +incdir+$(PWD)/src/vicuna/ibex/vendor/lowrisc_ip/ip/prim/rtl +incdir+$(PWD)/src/vicuna/ibex/vendor/lowrisc_ip/dv/sv/dv_utils -assert svaext

.PHONY: clean
.PHONY: run
.PHONY: synth

sim/simv: $(SRCS) $(ASM)
		mkdir -p sim
		cd sim && vcs -R $(SRCS) $(VCS_FLAGS) -msg_config=../warn.config

run: sim/simv $(ASM)
		bin/rv load memory.sh $(ASM) << y
		cd sim && ./simv

synth : $(SRCS)
		mkdir -p synth
		cd synth && dc_shell -f $(SYNTH_TCL)

clean:
		rm -rf sim synth
