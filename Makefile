SOURCE_DIR=.
RESCOMP ?= ../rescomp/target/rescomp.jar
BUILD_DIR ?= bin
CFG ?= ../dclib/cfg/durango16k.cfg
DCLIB ?= ../dclib/bin
DCINC ?= ../dclib/inc

all: casa.dux

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/title.h: title.png $(BUILD_DIR)
	java -jar ${RESCOMP} -n title -m BACKGROUND -i title.png -o $(BUILD_DIR)/title.h

$(BUILD_DIR)/dibu01.h: dibu01.png $(BUILD_DIR)
	java -jar ${RESCOMP} -n dibu01 -m BACKGROUND -i dibu01.png -o $(BUILD_DIR)/dibu01.h
	
$(BUILD_DIR)/paleta.h: paleta.png $(BUILD_DIR)
	java -jar ${RESCOMP} -n paleta -m SPRITESHEET -i paleta.png -h 15 -w 16 -o $(BUILD_DIR)/paleta.h
	


$(BUILD_DIR)/main.casm: $(SOURCE_DIR)/main.c $(BUILD_DIR)/title.h $(BUILD_DIR)/paleta.h $(BUILD_DIR)/dibu01.h
	cc65 -I $(DCINC) $(SOURCE_DIR)/main.c -t none --cpu 6502 -o $(BUILD_DIR)/main.casm

$(BUILD_DIR)/main.o: $(BUILD_DIR)/main.casm $(BUILD_DIR)
	ca65 -t none $(BUILD_DIR)/main.casm -o $(BUILD_DIR)/main.o

$(BUILD_DIR)/casa.bin: $(BUILD_DIR) $(BUILD_DIR)/main.o
	ld65 -m $(BUILD_DIR)/witch.txt -C $(CFG) $(BUILD_DIR)/main.o $(DCLIB)/qgraph.lib $(DCLIB)/system.lib $(DCLIB)/psv.lib $(DCLIB)/durango.lib -o $(BUILD_DIR)/casa.bin	

casa.dux: $(BUILD_DIR)/casa.bin $(BUILD_DIR)
	java -jar ${RESCOMP} -m SIGNER -n $$(git log -1 | head -1 | sed 's/commit //' | cut -c1-8) -t CASA -d "Colorea los dibujos" -i $(BUILD_DIR)/casa.bin -o casa.dux

clean:
	rm -Rf $(BUILD_DIR) casa.dux
