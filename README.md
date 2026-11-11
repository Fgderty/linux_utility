# Linux System Utilities (x86-64 Assembly)

A collection of basic Linux system utilities written entirely from scratch in x86-64 Assembly (NASM) without using standard C libraries (libc). 

Every utility communicates directly with the Linux kernel using system calls (`syscall`), demonstrating a deep understanding of the x86-64 ABI, stack frames, and register allocation.

## 🛠️ Implemented Utilities
* **cat** — reads and outputs file contents.
* **ls** — lists directory contents (uses `getdents64` syscall).
* **rm** — removes a file (`unlink`).
* **mkdir / rmdir** — creates and removes directories.
* **touch** — creates an empty file.
* **cp** — copies files.
* **echo** — prints text to stdout.
* **clear** — clears the terminal screen using ANSI escape sequences.

## ⚙️ Requirements
* Linux x86-64
* NASM assembler
* GNU ld (linker)
* GNU Make

## 🚀 Build & Run
The project uses a `Makefile` for automated compilation.
```bash
# Build all utilities at once
make

# Clean up compiled binaries and object files
make clean
