# sls

Notes:
    Build process is silent with recent versions of sls. Use `sudo stack build --docker --docker-image fpco/stack-build:lts-13.30` to build verbosely, otherwise you'll be staring at something blank for potentially hours.

    And yes, it does need to be 13.30 rather than the actual snapshot in use, as that's the newest version still compatible with AWS's libc. See: https://github.com/seek-oss/serverless-haskell

    Needs to be sudo to run as system docker as rootless `docker --version` output is incompatible with `stack --docker`. See: https://github.com/commercialhaskell/stack/issues/5087

    To use offline, you should run `sudo docker pull lambci/lambda:build-provided` if you don't want your first request to hang for a good while. It does this in the background, however it's just a silent nuisance.

Usage:
    Start offline: `sudo sls offline --useDocker`

TODO:
    Find a way not to rebuild stack programs in deploy so we can deploy as user.