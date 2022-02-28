# define which architecture you're targeting
ARCH = x86_64
# define your target file here
TARGET = main.efi
#define your sources here
SRCS = $(wildcard src/*.c)
# define your default compiler flags
CFLAGS = -I/nix/store/0c0wspanh2330r1p5vv4qsxbdnkzvf7x-ghc-9.2.1/lib/ghc-9.2.1/include -Iuefi -pedantic -Wall -Wextra -Werror --ansi -O2
# define your default linker flags
#LDFLAGS =
# define your additional libraries here
#LIBS = -lm

# leave the hard work and all the rest to posix-uefi

# set this if you want GNU gcc + ld + objcopy instead of LLVM Clang + Lld
#USE_GCC = 1
include uefi/Makefile
