CC         = avr-gcc
OBJCOPY    = avr-objcopy
OBJDUMP    = avr-objdump
SIZE       = avr-size
TARGET     = main
CONTROLLER = atmega169p
SRC        = $(wildcard *.c)
OBJ        = ${SRC:.c=.o}
INCLUDE    = ./include

# Flags copied from Atmel Studio's build output.
CFLAGS += -DBOARD=USER_BOARD -DDEBUG -fdata-sections -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -Wall -mmcu=$(CONTROLLER) -std=gnu99 -fno-strict-aliasing -Wstrict-prototypes -Wmissing-prototypes -Werror-implicit-function-declaration -Wpointer-arith -mrelax -O1 -g3
CFLAGS += -Wl,--start-group -Wl,-lm -Wl,--end-group -Wl,--gc-sections -Wl,--relax
CFLAGS += $(foreach includedir,$(INCLUDE),-I$(includedir)) # Add each dir in ${INCLUDE} as an include directory.

# Flags not found in Atmel Studio's build output (but should be there).
EXTRAFLAGS = -Wextra -pedantic -Wno-expansion-to-defined -Wno-int-to-pointer-cast -Werror

# Quirk; specify non-file targets.
# Explaination at <https://stackoverflow.com/questions/2145590/what-is-the-purpose-of-phony-in-a-makefile#2145605>
.PHONY: all clean

all: $(TARGET).elf hex upload

# Make is smart; it knows how to build object files.
# Flags specified here are propegated down to the compilation of these object files.
$(TARGET).elf: $(OBJ)
	$(CC) $(CFLAGS) $(EXTRAFLAGS) -o $(TARGET).elf $(OBJ) $(ASFLAGS)

hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(TARGET).elf $(TARGET).hex
	$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O ihex $(TARGET).elf $(TARGET).eep || exit 0
	$(OBJDUMP) -h -S $(TARGET).elf > $(TARGET).lss
	$(OBJCOPY) -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(TARGET).elf $(TARGET).srec

upload:
	avrdude -p m169 -c avrisp2 -U flash:w:main.hex

clean:
	@- rm -f *.o *.elf *.hex *.eep *.lss *.srec
