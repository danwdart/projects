{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {};
  devPackages = {
    "squizlabs/php_codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "squizlabs-php_codesniffer-d7c00c3000ac0ce79c96fcbfef86b49a71158cd1";
        src = fetchurl {
          url = https://api.github.com/repos/squizlabs/PHP_CodeSniffer/zipball/d7c00c3000ac0ce79c96fcbfef86b49a71158cd1;
          sha256 = "0nzac879c26yhasglki9pc8k04czb1wv0wwcadw7fwc51zay4606";
        };
      };
    };
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "dandart-projects";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "Expat";
  };
}