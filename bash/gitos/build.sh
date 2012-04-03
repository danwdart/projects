#GitOS - Builder
# This application goes and gets the latest builds of everything, asks you to compile it and 
case "$1" in
    install)
        echo Cloning Linux...
        git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
        echo Cloning uClibc...
        git clone git://uclibc.org/uClibc.git
        echo Cloning busybox...
        git clone git://git.busybox.net/busybox.git
    ;;
    update)
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
    ;;
    *)
        echo "Usage: $0 install|update"
    ;;
esac
