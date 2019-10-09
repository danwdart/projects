{ mkDerivation, base, HaskellNet, mongoDB, mtl, propellor, stdenv
, text
}:
mkDerivation {
  pname = "old-network";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base HaskellNet mongoDB mtl propellor text
  ];
  homepage = "https://github.com/danwdart/dansstuff#readme";
  license = stdenv.lib.licenses.publicDomain;
}
