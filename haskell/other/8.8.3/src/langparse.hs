{-# LANGUAGE RankNTypes    #-}
{-# LANGUAGE UnicodeSyntax #-}

testFile ∷ String
testFile = "(function main(a, b) { console.log(a + b); })(1, 2);"

main ∷ IO ()
main = print "Hello World"