{ mkDerivation, aeson, base, blaze-html, blaze-markup, bytestring
, Cabal, containers, ghcjs-dom, jsaddle, jsaddle-dom, jsaddle-warp
, reactive-banana, req, stdenv, text
}:
mkDerivation {
  pname = "web";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base blaze-html blaze-markup bytestring Cabal containers
    ghcjs-dom jsaddle jsaddle-dom jsaddle-warp reactive-banana req text
  ];
  homepage = "https://github.com/danwdart/dansstuff#readme";
  license = stdenv.lib.licenses.publicDomain;
}
