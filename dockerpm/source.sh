# Most of this stuff is rootless
d() {
    docker $@
}

sd() {
    sudo docker $@
}

doco() {
    if [ -f docker-compose.yml ]
    then
        docker-compose -f docker-compose.yml $@
    else
        if [ -f ~/docker-compose.user.yml ]
        then
            docker-compose -f ~/docker-compose.user.yml $@
        else
            echo "No docker-compose.user.yml found in current path or home directory."
        fi
    fi
}

sdoco() {
    if [ -f docker-compose.yml ]
    then
        sudo docker-compose -f docker-compose.yml $@
    else
        if [ -f ~/docker-compose.system.yml ]
        then
            sudo docker-compose -f ~/docker-compose.system.yml $@
        else
            echo "No docker-compose.system.yml found in current path or home directory."
        fi
    fi
}

dc() {
    if [ -f docker-compose.dev.yml ]
    then
        doco -f docker-compose.dev.yml $@
    else
        doco $@
    fi
}

sdc() {
    if [ -f docker-compose.dev.yml ]
    then
        sdoco -f docker-compose.dev.yml $@
    else
        sdoco $@
    fi
}

dca() {
    if [ -f docker-compose.admin.yml ]
    then
        sdc -f docker-compose.admin.yml $@ 
    else
        echo "No docker-compose.admin.yml present."
    fi
}

sdca() {
    if [ -f docker-compose.admin.yml ]
    then
        sdc -f docker-compose.admin.yml $@ 
    else
        echo "No docker-compose.admin.yml present."
    fi
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

alias sdcu='sdc up -d'
alias sdcd='sdc down'
alias sdce='sdc exec'
alias sdcr='sdc run'
alias sdcrr='sdc run --service-ports --rm'

alias sdcl='sdc logs'
alias sdclf='sdc logs -f'
alias sdcp='sdc ps'

alias sdcsta='sdc start'
alias sdcsto='sdc stop'

alias sdcre='sdc restart'

alias sdr='sd run'
alias sdri='sd run -it'
alias sdrd='sd run -d'

alias sdsta='sd start'
alias sdsto='sd stop'

alias sdre='sd restart'

alias sdrr='sd run --rm'
alias sdrri='sdrr -it'
alias sdrrd='sdrr -d'

alias sde='sd exec'
alias sdp='sd ps'
alias sdl='sd logs'
alias sdlf='sd logs -f'
alias sds='sd search'
alias sdsp='sd system prune -af'

# Run in a home env (fake root)
alias dhr='drr -v $PWD:$PWD -w $PWD --net host -it'

# Run in a home env (fake root, X)
alias dhrx='dhr -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'


# Run in a home env (real root)
alias sdhr='sdrr -v $PWD:$PWD -w $PWD --net host -it'

# Run in a home env (real root or defined user, X)
alias sdhrrx='sdhr -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'


# Run in a home env (using root-owned daemon, run as user, X)
alias sdhrx='sdhrrx -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -u $UID:$GROUPS'

# Apps

alias dhr-node='dhr -v $HOME:/root -v $PWD:$PWD node:alpine'

alias node='dhr-node node'
alias npm='dhr-node npm'
alias npx='dhr-node npx'
alias yarn='dhr-node yarn'

alias dhr-hs='dhr -v $HOME/.stack:/root/.stack -v $HOME/.cabal:/root/.cabal -v $HOME/.ghci:/root/.ghci -v $HOME/.hoogle:/root/.hoogle -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket dandart/haskell'

alias cabal='dhr-hs cabal'
alias stack='dhr-hs stack'
alias ghci='dhr-hs ghci'
alias ghc='dhr-hs ghc'
alias runghc='dhr-hs runghc'
alias runhaskell='dhr-hs runhaskell'
alias ghcid='stack exec ghcid -- -r -c stack ghci'

alias dhr-nmap='sdhr jess/nmap'
alias nmap='dhr-nmap'

alias dhr-masscan='sdhr jess/masscan'
alias masscan='dhr-masscan'

# can't find
# gladish rosegarden yoshimi jack-rack ardour

# steam qemu
# medibuntu? other distros?

# virtualised things?

# todo include desktop files

# alias dhr-qemu='dhrx --device /dev/kvm SOMEBODY'

alias dhr-qjackctl='dhrx lasery/qjackctl'
alias qjackctl='dhr-qjackctl qjackctl'

# won't work atm
#alias dhr-audacity='dhrx jess/audacity'
#alias audacity='dhr-audacity audacity'

alias dhr-wine='dhrx -v $HOME/.wine:/root/.wine -v $HOME/.local/share:/root/.local/share jess/wine'
alias wine='dhr-wine wine'

alias dhr-torbrowser='dhrx jess/tor-browser'
alias tor-browser='dhr-torbrowser'

alias dhr-wireshark='sdhrx jess/wireshark'
alias wireshark='dhr-wireshark'

alias dhr-wargames='dhrx jess/wargames'
alias wargames='dhr-wargames'

alias dhr-vscode='sdhrrx -v $HOME/.config/Code:/home/user/.config/Code jess/vscode' # user "user" - can't override?
alias code='dhr-vscode'

alias dhr-vlc='dhrx jess/vlc'
alias vlc='dhr-vlc'

alias dhr-virtualbox='dhrx jess/virtualbox'
alias virtualbox='dhr-virtualbox'

alias dhr-traceroute='dhrx jess/traceroute'
alias traceroute='dhr-traceroute'

alias dhr-spotify='dhrx jess/spotify'
alias spotify='dhr-spotify'

alias dhr-skype='dhrx -v $HOME/.config:/root/.config jess/skype'
alias skype='dhr-skype'

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

alias dhr-cathode='dhrx -v $HOME:$HOME -v $PWD:$PWD --device /dev/dri jess/cathode'
alias cathode='dhr-cathode'

alias dhr-kali='sdhr jess/kalilinux'
alias kali='dhr-kali bash'

alias dhr-steam='sdhrx -v $HOME/.steam:$HOME/.steam -v $HOME/.local:$HOME/.local tianon/steam'
alias steam='dhr-steam'

alias dhr-mongo='drri -p27017:27017 mongo'
alias mongod='dhr-mongo'
# alias dhr-kvm='dhrx jess/kvm'

# sdhrx because ipc host
alias dhr-firefox='sdhrx -v $HOME/.mozilla:$HOME/.mozilla -v $HOME/.cache:$HOME/.cache -v $HOME/Downloads:$HOME/Downloads -v /dev/snd:/dev/snd --device /dev/snd --device /dev/dri --device /dev/video0 --device /dev/video1 --ipc host --group-add audio --group-add video jess/firefox'
alias fx='dhr-firefox'
alias firefox='dhr-firefox'
alias dfirefox='dhr-firefox'

alias dhr-vim='dhr -v $HOME/.vimrc:/root/.vimrc -v /root/.vim:/root/.vim -v $HOME/.viminfo:/root/.viminfo thinca/vim'
alias dvim='dhr-vim'
