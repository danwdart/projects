with import <unstable> {};
runCommand "js" {
    buildInputs = [
        nodejs-16_x
        nodePackages.npm # version with node is too old
        nodePackages.npm-check-updates
        python39 # for npm stuff
        yarn # haven't decided yet
    ];
} ""
