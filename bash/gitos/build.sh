#GitOS - Builder
case "$1" in
    install)
        mkdir source
        cd source
        echo Cloning Linux...
        git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
        echo Cloning uClibc...
        git clone --depth=1 git://uclibc.org/uClibc.git
        echo Cloning busybox...
        git clone --depth=1 git://git.busybox.net/busybox.git
        cd ..
    ;;
    update)
        cd source
        echo Updating Linux...
        cd linux
        git pull
        cd ..
        echo Updating uClibc...
        cd uClibc
        git pull
        cd ..
        echo Updating busybox...
        cd busybox
        git pull
        cd ..
        cd ..
    ;;
    *)
        echo "Usage: $0 install|update"
    ;;
esac
