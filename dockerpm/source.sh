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
alias drri='drr -it'
alias drrd='drr -d'

alias de='d exec'
alias dp='d ps'
alias dl='d logs'
alias dlf='d logs -f'
alias ds='d search'
alias dsp='d system prune -af'

alias dhrr='drr -v $PWD:$PWD -w $PWD --net host -it'
alias dhr='dhrr -u $UID:$GROUPS -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -e HOME=$HOME'
alias dhrx='dhr -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'
alias dhrrx='dhrr -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'
alias dhrj='dhrx '

alias dhr-node='dhr -v $HOME:$HOME -v $PWD:$PWD node:alpine'

alias node='dhr-node node'
alias npm='dhr-node npm'
alias npx='dhr-node npx'
alias yarn='dhr-node yarn'

alias dhr-hs='dhr -v $HOME/.stack:$HOME/.stack -v $HOME/.cabal:$HOME/.cabal -v $HOME/.ghci:$HOME/.ghci dandart/haskell'

alias cabal='dhr-hs cabal'
alias stack='dhr-hs stack'
alias ghci='dhr-hs ghci'
alias ghc='dhr-hs ghc'
alias runghc='dhr-hs runghc'
alias runhaskell='dhr-hs runhaskell'

alias dhrr-nmap='dhrr jess/nmap'
alias nmap='dhrr-nmap'

alias dhrr-masscan='dhrr jess/masscan'
alias masscan='dhrr-masscan'

# can't find
# gladish rosegarden yoshimi jack-rack ardour

# steam qemu
# medibuntu? other distros?

# virtualised things?

# todo include desktop files

# alias dhr-qemu='dhrx --device /dev/kvm SOMEBODY'

alias dhr-qjackctl='dhrx lasery/qjackctl'
alias qjackctl='dhr-qjackctl qjackctl'

alias dhr-audacity='dhrx jess/audacity'
alias audacity='dhr-audacity audacity'

alias dhr-wine='dhrx jess/wine'
alias wine='dhr-wine wine'

alias dhr-wireshark='dhrrx jess/wireshark'
alias wireshark='dhr-wireshark'

alias dhr-wargames='dhrx jess/wargames'
alias wargames='dhr-wargames'

alias dhr-vscode='dhrx jess/vscode'
alias vscode='dhr-vscode'

alias dhr-vlc='dhrx jess/vlc'
alias vlc='dhr-vlc'

alias dhr-virtualbox='dhrx jess/virtualbox'
alias virtualbox='dhr-virtualbox'

alias dhr-traceroute='dhrx jess/traceroute'
alias traceroute='dhr-traceroute'

alias dhr-spotify='dhrx jess/spotify'
alias spotify='dhr-spotify'

alias dhr-skype='dhrx jess/skype'
alias skype='dhr-skype'

alias dhr-routersploit='dhrx jess/routersploit'
alias routersploit='dhr-routersploit'

alias dhr-rdesktop='dhrx jess/rdesktop'
alias rdesktop='dhr-rdesktop'

alias dhr-metasploit='dhrx jess/metasploit'
alias metasploit='dhr-metasploit'

alias dhr-keepassxc='dhrx jess/keepassxc'
alias keepassxc='dhr-keepassxc'

alias dhr-john='dhrx jess/john'
alias john='dhr-john'

alias dhr-inkscape='dhrx jess/inkscape'
alias inkscape='dhr-inkscape'

alias dhr-cathode='dhrx -v $HOME:$HOME -v $PWD:$PWD jess/cathode'
alias cathode='dhr-cathode'

alias dhr-kali='dhrx jess/kalilinux'

# alias dhr-kvm='dhrx jess/kvm'
