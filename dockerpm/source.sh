d() {
    sudo docker $@
}

dc() {
    [ -f docker-compose.dev.yml ] && sudo docker-compose -f docker-compose.yml -f docker-compose.dev.yml $@ || sudo docker-compose $@
}

alias dcu='dc up -d'
alias dcd='dc down'
alias dce='dc exec'
alias dcr='dc run'
alias dcrr='dc run --service-ports --rm'

alias dcl='dc logs'
alias dclf='dc logs -f'
alias dcp='dc ps'

alias dcsta='dc start'
alias dcsto='dc stop'

alias dcre='dc restart'

alias dr='d run'
alias dri='d run -it'
alias drd='d run -d'

alias dsta='d start'
alias dsto='d stop'

alias dre='d restart'

alias drr='d run --rm'
alias drri='d run --rm -it'
alias drrd='d run --rm -d'

alias de='d exec'
alias dp='d ps'
alias dl='d logs'
alias dlf='d logs -f'
alias ds='d search'
alias dsp='d system prune -af'

alias dhr='drr -u $UID:$GROUPS -v $PWD:$PWD -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -e HOME=$HOME -w $PWD --net host -it'
alias dhrx='dhr -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'

alias dhr-node='dhr -v node:$HOME -v $PWD:$PWD node:alpine'

alias node='dhr-node node'
alias npm='dhr-node npm'
alias yarn='dhr-node yarn'

alias dhr-hs='dhr -v $HOME/.stack:$HOME/.stack -v $HOME/.cabal:$HOME/.cabal -v $HOME/.ghci:$HOME/.ghci haskell'

alias cabal='dhr-hs cabal'
alias stack='dhr-hs stack'
alias ghci='dhr-hs ghci'
alias ghc='dhr-hs ghc'
alias runghc='dhr-hs runghc'
alias runhackell='dhr-hs runhaskell'