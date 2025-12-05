IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

RTL_DIR = rtl
TB_DIR = tb
WORK_DIR = work

VVP_FILE = $(WORK_DIR)/tb_p_module.vvp
VCD_FILE = $(WORK_DIR)/wave.ocd

RTL_SOURCES = $(RTL_DIR)/p_module.sv \
              $(RTL_DIR)/m_module.sv \
              $(RTL_DIR)/enc_round.sv

TB_SOURCES = $(TB_DIR)/tb_p_module.sv

ALL_SOURCES = $(RTL_SOURCES) $(TB_SOURCES)

IVERILOG_FLAGS = -g2012 -Wall -I$(RTL_DIR) -I$(TB_DIR)

.PHONY: all clean sim run waves help

all: sim

$(WORK_DIR):
	mkdir -p $(WORK_DIR)

sim: $(WORK_DIR)
	$(IVERILOG) $(IVERILOG_FLAGS) -o $(VVP_FILE) $(ALL_SOURCES)

run: sim
	$(VVP) $(VVP_FILE)

waves: run
	$(GTKWAVE) $(VCD_FILE)

clean:
	rm -rf $(WORK_DIR)

help:
	@echo "Доступные цели:"
	@echo "  make sim    - компиляция дизайна"
	@echo "  make run    - запуск симуляции"
	@echo "  make waves  - просмотр волновых форм"
	@echo "  make clean  - очистка артефактов"
	@echo "  make all    - то же что и 'make sim'"

