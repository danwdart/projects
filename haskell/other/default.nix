{ mkDerivation, aeson, aeson-pretty, ansi-terminal, async, avahi
, base, bytestring, concurrent-extra, containers, digits, directory
, egyptian-fractions, elf, fakedata, FixedPoint-simple, flow, gd
, GenericPretty, gogol, gogol-core, gogol-translate, haxl, HDBC
, HDBC-mysql, HDBC-postgresql, HDBC-sqlite3, hsp, hsx2hs
, http-client, http-types, hxt, hxt-xpath, lens, lifted-async, mtl
, numbers, optics, primes, qchas, random, regex-tdfa, req, retry
, safe-foldable, shell-conduit, stdenv, stm, tardis
, template-haskell, text, threepenny-gui, transformers
, unordered-containers, vector, wai, warp, yaml
}:
mkDerivation {
  pname = "other";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson aeson-pretty ansi-terminal async avahi base bytestring
    concurrent-extra containers digits directory egyptian-fractions elf
    fakedata FixedPoint-simple flow gd GenericPretty gogol gogol-core
    gogol-translate haxl HDBC HDBC-mysql HDBC-postgresql HDBC-sqlite3
    hsp hsx2hs http-client http-types hxt hxt-xpath lens lifted-async
    mtl numbers optics primes qchas random regex-tdfa req retry
    safe-foldable shell-conduit stm tardis template-haskell text
    threepenny-gui transformers unordered-containers vector wai warp
    yaml
  ];
  homepage = "https://github.com/danwdart/dansstuff#readme";
  license = stdenv.lib.licenses.publicDomain;
}
