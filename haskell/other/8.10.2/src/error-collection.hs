{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

-- import Control.Monad
-- import Data.Bifunctor
import           Data.Biapplicative
import           Data.Char
import           Data.Map           (Map)

-- Stolen from xmonad-contrib XMonad.Util.Stack
tagBy ∷ (a → Bool) → a → Either a a
tagBy p a = if p a then Right a else Left a

sequenceEither ∷ [Either x r] → ([x], [r])
-- sequenceEither s = bipure (lefts s) (rights s) -- two loops you see.
sequenceEither = foldl eitherBucketSort ([],[]) -- now just one!

-- there's certainly a more efficient way to do this one specifically
-- then maybe we can do the other one
filterBoth ∷ (a → Bool) → [a]→ ([a], [a])
filterBoth f = sequenceEither . fmap (tagBy f)
-- filterBoth f x = bipure (filter (not . f) x) (filter f x) -- still two loops but probably more efficient
-- how can it be done with one... let's see now

-- big ol' map o' lists
bucketSort ∷ (a → b) → a → Map b [a] → Map b [a]
bucketSort = undefined

-- TODO biap
taggedBoolBucketSort ∷ ([a], [a]) → (Bool, a) → ([a], [a])
taggedBoolBucketSort (xs, rs) (False, x) = (x:xs, rs)
taggedBoolBucketSort (xs, rs) (True, r) = (xs, r:rs)

-- sure it's reversed but idc
eitherBucketSort ∷ ([x], [r]) → Either x r → ([x], [r])
eitherBucketSort (xs, rs) (Left x) = (x:xs, rs)
eitherBucketSort (xs, rs) (Right r) = (xs, r:rs)

-- (a -> b) -> [a] -> b -> b ?

-- eitherBucketSort (Right 2) $ eitherBucketSort (Left 1) ([],[])

catchAll ∷ (Traversable t, Biapplicative c) ⇒ (a → Either x r) → t a → c (t x) (t r)
catchAll = undefined

catchFirst ∷ (Traversable t, Biapplicative c) ⇒ (a → Either x r) → t a → c x (t r)
catchFirst = undefined

catchAllMR ∷ (Monoid x, Traversable t, Biapplicative c) ⇒ (a → Either x r) → t a → c (t x) r
catchAllMR = undefined

catchAllME ∷ (Monoid x, Traversable t, Biapplicative c) ⇒ (a → Either x r) → t a → c x (t r)
catchAllME = undefined

catchAllMB ∷ (Monoid x, Traversable t, Biapplicative c) ⇒ (a → Either x r) → t a → c x r
catchAllMB = undefined

main ∷ IO ()
main = do
    print (sequenceEither $ fmap (tagBy isAlpha) "abcdef123" :: (String, String))
    print (filterBoth isAlpha "abcdef123" :: (String, String))
    -- print (catchAll (tagBy isAlpha) "abcdef1234567890" :: (String, String))
    -- print (catchFirst (tagBy isAlpha) "abcdef1234567890" :: (Char, String))
