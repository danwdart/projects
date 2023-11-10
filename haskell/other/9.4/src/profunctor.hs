{-# OPTIONS_GHC -Wno-type-defaults #-}

module Main (main) where

import Data.Profunctor

l, r ∷ Either Int Int
l = Left 1
r = Right 1

main ∷ IO ()
main = do
    putStrLn "Choice -> - only maps on the particular side of an Either"
    print $ left' show l -- Left "1"
    print $ left' show r -- Right 1
    print $ right' show l -- Left 1
    print $ right' show r -- Right "1"

    putStrLn "Closed ->"
    print $ closed show (const 1) (const "b") -- "1"
    print $ closed succ (const False) (const True) -- True

    putStrLn "Cochoice ->"
    -- unleft is opposite of left'
    print $ unleft (left' show) 1 -- "1"
    -- turns fmap on right to apply
    print $ unright (fmap show) 1 -- "1"
    -- right' is equivalent to fmap on Either a
    print $ unright (right' show) 1 -- "1"

    putStrLn "Costar is like a comonad version of Kleisli but more generic and applicable?"
    -- Runs on input
    print $ runCostar (rmap succ $ Costar (!! 0)) [1] -- 2

    putStrLn "Costrong is the opposite of Strong"
    print $ unfirst (first' show) 1 -- "1"
    print $ unsecond (second' show) 1 -- "1"
    -- using tuple fmap
    print $ unsecond (fmap succ) 1 -- 2

    putStrLn "Forget... well, I'm not sure why you would want to do this..."
    -- Forgets
    runForget ( rmap (++ "Hi") $ Forget print ) "eee" -- "eee"
    -- Remembers
    runForget ( lmap (++ "hi") $ Forget print ) "eee" -- "eeehi"

    putStrLn "Mapping is not much different from a functor... but more general?"
    print $ map' show [1,2,3] -- ["1","2","3"]

    putStrLn "Everything here is a Profunctor, and its base is:"
    -- Left applied to input, arrow run and right applied to output
    print $ dimap (+ 1) (++ "Hi") show 1  -- "2Hi"

    putStrLn "Star is like Kleisli but for functors and more generic and applicable - it lifts."
    -- won't do anything because runs on output
    runStar (rmap succ $ Star print) 1  -- 1
    -- will work
    print =<< runStar (rmap succ $ Star pure) 1 -- 2
    -- dimapping a star is good
    print $ runStar (dimap (+ 1) show $ Star Just) 1  -- Just "2"

    putStrLn "Strong allows params to be passed through"
    -- runs on first param only
    print $ first' show (1, "hey") -- ("1","hey")
    -- on second
    print $ second' show ("hey", 1) -- ("hey","1")

    putStrLn "Wrapping any arrow to profunctor"
    print $ unwrapArrow (rmap (++ "hi") (WrapArrow show) ) 1 -- "1hi"

    putStrLn "You can curry arrows to a profunctor too rather than just ->"
    print $ curry' snd 2 3 -- 3
    print $ uncurry' (+) (1,1) -- 2
