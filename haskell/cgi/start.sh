#!/bin/bash
ghc cgi-bin/compiled.hs
echo "http://locahost:8000"
python2 -m CGIHTTPServer