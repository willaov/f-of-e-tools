TREEROOT	= ../../
include $(TREEROOT)/tools/sunflower/conf/setup.conf
IROOT = $(TREEROOT)/tools/sunflower/

TARGET-ARCH	= riscv32-elf
TARGET		= riscv

PROGRAM		= arith_check
PROGRAM-SF	= arith_check-sf
INIT		= init
INIT-SF		= init-sf

OPTFLAGS	= -O0
INCLUDES	= -I$(IROOT)benchmarks/include -I$(IROOT)tools/riscv/include -I$(IROOT)sys/include -I$(IROOT)sys/kern/superH -I$(IROOT)sys/libOS/port
CFLAGS		= -march=rv32i -mabi=ilp32 $(TARGET-ARCH-FLAGS) -Wall 
ASFLAGS		= --march=rv32i --mabi=ilp32
LDFLAGS		= -L$(TOOLSLIB)/$(TARGET) -Map $(PROGRAM).map -Tsail.ld
LDFLAGS-SF	= -Ttext $(LOADADDR-SF)  -L$(TOOLSLIB)/$(TARGET) -Map $(PROGRAM).map
SREC2HEX	= srec2hex
LOADADDR-SF	= 0x08004000

OBJS		=\
		$(INIT).o\
		$(PROGRAM).o\

OBJS-SF		=\
		$(INIT-SF).o\
		$(PROGRAM).o\

all:	$(PROGRAM) $(PROGRAM).sr $(PROGRAM-SF) $(PROGRAM-SF).sr Makefile

$(INIT).o: $(INIT).S
	$(AS) $(ASFLAGS) $(INIT).S -o $(INIT).o

$(PROGRAM): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@ -lc -lm -lgcc

$(PROGRAM).sr:$(PROGRAM)
	$(OBJCOPY) -O srec $(PROGRAM) $@

$(PROGRAM).o: $(PROGRAM).c Makefile
	$(CC) $(CFLAGS) $(INCLUDES) $(OPTFLAGS) -c $(PROGRAM).c


$(INIT-SF).o: $(INIT-SF).S
	$(CPP) $(INIT-SF).S > $(INIT-SF).i; $(AS) $(ASFLAGS) $(INIT-SF).i -o $(INIT-SF).o

$(PROGRAM-SF): $(OBJS-SF)
	$(LD) $(LDFLAGS-SF) $(OBJS-SF) -o $@ -lc -lgcc -lgloss

$(PROGRAM-SF).sr:$(PROGRAM-SF)
	$(OBJCOPY) -O srec $(PROGRAM-SF) $@

install: all
	$(SREC2HEX) -b 4096 $(PROGRAM).sr
	cp program.hex $(TREEROOT)/verilog/hardware/processor/programs
	cp data.hex $(TREEROOT)/verilog/hardware/processor/programs
	cd $(TREEROOT)/verilog/hardware/processor; $(MAKE)

clean:
	$(RM) init.i *.o $(PROGRAM) $(PROGRAM).sr $(PROGRAM).map
	$(RM) init-sf.i *.o $(PROGRAM-SF) $(PROGRAM-SF).sr $(PROGRAM-SF).map
	$(RM) program.hex data.hex
