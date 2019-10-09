{ mkDerivation, base, brick, containers, fakedata, random, stdenv
, text, time, uuid, vector
}:
mkDerivation {
  pname = "peoplemanager";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base brick containers fakedata random text time uuid vector
  ];
  description = "People Manager Game";
  license = stdenv.lib.licenses.agpl3;
}
