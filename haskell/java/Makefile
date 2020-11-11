all:
	stack ghc -- -fPIC -dynamic -c -O HsMain.hs
	javac -cp javacpp.jar Main.java
	java -jar javacpp.jar -Dplatform.compiler=ghc -Dplatform.compiler.output="-optc-O3 -Wall Main.o -dynamic -fPIC -shared -lstdc++ -lHSrts-ghc8.10.2 -o " -Dplatform.linkpath.prefix2="-optl -Wl,-rpath," HsMain
run:
	java -cp javacpp.jar