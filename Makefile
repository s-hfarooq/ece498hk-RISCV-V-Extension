#Collect All Source Files

#PRIM_H_SRCS := $(shell find $(PWD)/src/vicuna/ibex/vendor/lowrisc_ip/ip/prim/rtl -name '*.svh')
#PRIM_SRCS := $(shell find $(PWD)/src/vicuna/ibex/vendor/lowrisc_ip/ip/prim/rtl -name '*.sv')
PKG_SRCS := $(shell find $(PWD)/src/vicuna/ibex/rtl -name '*.sv')
HDL_SRCS := $(shell find $(PWD)/src/vicuna/rtl -name '*.sv')


SRCS := $(PKG_SRCS) $(HDL_SRCS)
SYNTH_TCL := $(CURDIR)/synthesis.tcl
VCS_FLAGS = -full64 -lca -sverilog +lint=all,noNS -timescale=lns/10ps -debug acc+all -kdb -fsdb +liborder +libverbose

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
