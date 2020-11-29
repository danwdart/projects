{-# LANGUAGE UnicodeSyntax #-}
import           Data.Function
-- We're often faced with something difficult to eta-reduce, like...

-- Fns
-- Naming scheme: arity + type e.g. unary + string = uns

uns ∷ String → String
uns a = a <> "!"

bis ∷ String → String → String
bis a b = a <> (" " <> b)

tris ∷ String → String → String → String
tris a b c = a <> (" " <> (b <> (" " <> c)))

-- Tests
-- Naming scheme: test + arity1 + arity2 + ... + num given params (if any)

testUU ∷ String → String
-- test1 a = uns (uns a)
-- well that's clearly composition, so...
testUU = uns . uns

testUB1 ∷ String → String
-- test1 a = uns (bis "Hi!" a)
-- Having three named parameters, we can use the dot alone, capturing the param to the second function.
testUB1 = uns . bis "Hi!"

testUB ∷ String → String → String
-- Ooh err
-- testUB a b = uns (bis a b)
-- We can't use the dot alone because it's not fully eta-reduced, see...
-- testUB a = uns . bis a
-- We can't eta at this point because the a is attached to the bis.
-- We can't also use the $ on its own at the end because that's a syntax error.
-- testUB = uns . bis $
-- What do?
-- We could invent a combinator for this (spoiler it exists)
-- It'd look like this, let's look it up.
-- It's blackbird!

--b1 :: (c -> d) -> (a -> b -> c) -> a -> b -> d
-- b1 = (.) . (.)

-- And finally...
-- testUB = b1 uns bis
-- It works!
-- And as infix symbols...
(...) ∷ (c → d) → (a → b → c) → a → b -> d
(...) = (.) . (.)
testUB = uns ... bis
-- This also works!

-- Can we now make this generic? Like say given I have a UT2...
testUT2 ∷ String → String
-- testUT2 a = uns (tris "My name is" "Bob" a)
testUT2 = uns . tris "My name is" "Bob"
-- So we can definitely do it with one custom argument at the end like this.

testUT1 ∷ String → String → String
-- And use the blackbird if we have two custom arguments at the end like this...
-- testUT1 a b = uns (tris "My name is" a b)
-- testUT1 = b1 uns tris "My name is"
-- Now, b1 fails because it is prefix, and there is more than two arguments.
-- We have to add a dollar here...
-- testUT1 = b1 uns $ tris "My name is"
-- but the regular ... works just fine, presumably because of its fixity or something.
testUT1 = uns ... tris "My name is"

testBUDup ∷ String → String
-- testBUDup a = bis (uns a) (uns a)
-- We can't (yet) double up.
testBUDup a = on bis uns a a

main ∷ IO ()
main = mapM_ putStrLn [
    testUU "Bob",
    testUB1 "Bob",
    testUB "Bob" "Frog",
    testUT2 "Frog",
    testUT1 "Bob" "Frog",
    testBUDup "Bob"]
