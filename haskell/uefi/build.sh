rm src/*stub.h src/*.o src/*.hi
ghc src/KMain.hs
gcc -I`ghc --print-libdir`/include src/main.c -c -o src/main.o
ghc -no-hs-main src/Lib.o src/main.o -o main