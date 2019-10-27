#!/bin/bash
echo -e "admin\n$2\ntelnetd\nquit" | telnet $1 9527
echo -e "root\nxmhdipc\n" | telnet $1