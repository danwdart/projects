{ mkDerivation, aeson, base, bytestring, discord-haskell
, http-client, http-types, hxt, hxt-xpath, mtl, req, retry
, safe-foldable, stdenv, text, transformers, wai, warp
}:
mkDerivation {
  pname = "dubloons";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base bytestring discord-haskell http-client http-types hxt
    hxt-xpath mtl req retry safe-foldable text transformers wai warp
  ];
  homepage = "https://github.com/danwdart/projects#readme";
  license = stdenv.lib.licenses.publicDomain;
}
