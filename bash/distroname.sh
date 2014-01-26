#!/bin/bash
RELEASE=`cat /etc/*release`
if [[ $RELEASE == *Ubuntu* ]]
then
        echo Ubuntu
elif [[ $RELEASE == *Gentoo* ]]
then
        echo Gentoo
else
        echo Unknown
fi
