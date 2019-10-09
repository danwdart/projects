{ mkDerivation, aeson, base, fakedata, hpack, serverless-haskell
, stdenv, text
}:
mkDerivation {
  pname = "sls";
  version = "0.1.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base fakedata serverless-haskell text
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    aeson base fakedata serverless-haskell text
  ];
  testHaskellDepends = [
    aeson base fakedata serverless-haskell text
  ];
  prePatch = "hpack";
  homepage = "https://github.com/danwdart/sls#readme";
  license = stdenv.lib.licenses.bsd3;
}
