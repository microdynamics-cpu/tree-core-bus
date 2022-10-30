ILOG = iverilog
ISIM = vvp
TOP = top

MST    ?= 3
SLV    ?= 2
SIZE   ?= "(4*1024*1024)"
GEN_BUS = ../../build/bus_generator
GEN_TOP = ../gen_axi_top.sh
BUS_V   = ../design/amba_axi_m$(MST)s$(SLV).v

all: gen_bus gen_top comp simu

gen_bus:
	@if [ ! -x $(GEN_BUS) ]; then make -C ../.. all; fi
	@if [ ! -x $(GEN_BUS) ]; then echo "Something wrong"; exit -1; fi
	@if [ ! -d ../design ]; then mkdir ../design; fi
	@if [   -f $(BUS_V) ]; then rm -f $(BUS_V); fi
	$(GEN_BUS) --master=$(MST) --slave=$(SLV) --output=$(BUS_V)
	@if [ ! -r $(BUS_V) ]; then echo "Couldn't generate $(BUS_V)"; fi

gen_top:
	@if [ ! -x $(GEN_TOP) ]; then echo "Cannot find $(GEN_TOP)"; exit -1; fi
	@if [ ! -d ../design ]; then mkdir ../design; fi
	@if [   -f ../design/$(TOP).v ]; then rm -f ../design/$(TOP).v; fi
	$(GEN_TOP) -mst $(MST) -slv $(SLV) -siz $(SIZE) -out ../design/top.v
	@if [ ! -r ../design/$(TOP).v ]; then echo "Couldn't generate ../design/$(TOP).v"; fi

TB_INC := -I../design
TB_INC += -I../ip
TB_SRC := ./sim_define.v ../ip/axi_tester.v
TB_SRC += ../ip/mem_axi.v $(BUS_V) ../design/$(TOP).v
comp:
	($(ILOG) -o $(TOP).vvp -s $(TOP) $(TB_INC) $(TB_SRC) || exit -1) 2>&1 | tee compile.log

SIMU_OPTION := +SINGLE_TEST=1 +BURST_TEST=1 +BURST_RANDOM_TEST=1
SIMU_OPTION += +BURST_MISALIGNED_TEST=1 +SINGLE_TEST_MEM=1
simu: comp
	$(ISIM) -l vvp.log $(TOP).vvp $(SIMU_OPTION)

clean:
	rm -f $(TOP).vvp *.log *.vcd *.fst *.bmp

.PHONY: all gen_bus gen_top comp simu clean