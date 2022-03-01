rm src/*.o src/*.hi
gcc -c src/lib.c -o src/lib.o
ghc src/lib.o src/main.hs -o main
