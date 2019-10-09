#!/bin/bash
# Shell scripting is basically functional programming...
# We work in the "IO monad"... everything standardly is printed a la ghci or auto-putStrLn.
# Variables are assignment
MYVAR="Hello World"
MYNUM=2
# We also have export, so that's like library constants I guess
# echo is "return" / "pure"
echo $MYVAR
# Pipes are like >>= (every new command will have a new "IO" which can be captured and used as a stream)
# yes is repeat, head is init and tail is tail.
yes "Hi" | head -n2
yes "Hello" | head -n2 | tail -n2

# Functions exist with variable arguments, and space, like in Haskell, is function application
greet () {
    echo "My name is $1"
}
# Aliases are more like #define...but they're only for sourcing... so sourcing is like hsc2hs I guess
# alias g=greet
greet "Bob"
greet "Ted"
# No need for liftIO...
echo "Bob" >> ted.txt
cat ted.txt
rm ted.txt
# Although shouldn't we make these their own function, at least pretend that we have an IO?
fileIO() {
    echo $2 >> $1
    cat $1
    rm $1
}

# We can omit quotes if no spaces exist
fileIO ted2.txt Hello

# Bash natively supports networking without nc.
# Here's a demonstration of using it to set up a bidirectional pipe.

# Create /dev/fd/3 - this way we can hold connections and pipes open!
exec 3<>/dev/tcp/dandart.co.uk/80
REQ_DAN="GET / HTTP/1.1\nHost: dandart.co.uk\nConnection: close\n\n"

# -e will evaluate escape sequences
# Send to pipe
echo -e $REQ_DAN >&3

# Receive from pipe
cat <&3

# Close pipe
exec 3>&-
# or exec 3<&-

# With NC, we get the response immediately
echo -e $REQ_DAN | nc dandart.co.uk 80

# Looks like we need SSL!
echo -e $REQ_DAN | openssl s_client -quiet -connect dandart.co.uk:443

# We can also make auto pipes of these
mkfifo bob
echo -e $REQ_DAN | openssl s_client -quiet -connect dandart.co.uk:443 > bob &
cat bob
# cleanup
rm bob

# We can even interact with system pipes and send ourselves messages in other ways.
# We can find pipes with find ~ -type p -perm +rw 2>/dev/null, or with lsof / netstat.
# Sockets with find ~ -type s & blocks with find ~ -type b
# To interact with sockets, we need nc, I think
# TODO EOF
echo "Hi" | nc -lU bob.sock &
PID=$!
echo "Hello" | nc -U bob.sock &
PID2=$!
sleep 1
kill $PID
kill $PID2
rm bob.sock
# Kill everything going to a pipe is here
# fuser -TERM -k /path/to/fifo

# $() and `` are capture IO commands
# Basic maths
ONE=1
TWO=2
THREE=$[$ONE + $TWO]
# No non-int without bc
POINTTHREE=$(echo .$ONE + .$TWO | bc)
echo $THREE
echo $POINTTHREE
# This is basically FFI...
NUMBER=$(BC_LINE_LENGTH=0 bc -l <<< "obase=16;scale=2000;a(1)")
NNP=${NUMBER:1}
echo $NNP | fold -w2 | xxd -r > PF.data
strings PF.data