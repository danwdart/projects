{ mkDerivation, base, containers, random, stdenv }:
mkDerivation {
  pname = "boardgames";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base containers random ];
  homepage = "https://github.com/danwdart/dansstuff#readme";
  license = stdenv.lib.licenses.publicDomain;
}
