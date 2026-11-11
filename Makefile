# Makefile for Linux Utilities (x86-64 Assembly)

ASM = nasm
ASM_FLAGS = -f elf64
LD = ld

# List of all utilities to build
UTILS = cat clear cp echo ls mkdir rm rmdir touch

all: $(UTILS)

# Rule to link the object file
%: src/%.o
 $(LD) $< -o $@

# Rule to compile the assembly file
src/%.o: src/%.asm
 $(ASM) $(ASM_FLAGS) $< -o $@

# Clean up build artifacts
clean:
 rm -f $(UTILS) src/*.o

.PHONY: all clean
