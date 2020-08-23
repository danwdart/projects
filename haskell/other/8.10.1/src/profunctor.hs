{-# OPTIONS_GHC -Wno-type-defaults #-}

import           Data.Profunctor

l, r :: Either Int Int
l = Left 1
r = Right 1

main :: IO ()
main = do
    putStrLn "Choice -> - only maps on the particular side of an Either"
    print $ left' show l
    print $ left' show r
    print $ right' show l
    print $ right' show r
    putStrLn "Closed ->"
    print $ closed show (const 1) (const "b")
    print $ closed succ (const False) (const True)
    putStrLn "Cochoice ->"
    print $ unleft (left' show) 1 -- unleft is opposite of left'
    print $ unright (fmap show) 1 -- turns fmap on right to apply
    print $ unright (right' show) 1 -- right' is equivalent to fmap on Either a
    putStrLn "Costar is like a comonad version of Kleisli but more generic and applicable?"
    print $ runCostar (rmap succ $ Costar (!! 0)) [1] -- Runs on input
    putStrLn "Costrong is the opposite of Strong"
    print $ unfirst (first' show) 1
    print $ unsecond (second' show) 1
    print $ unsecond (fmap succ) 1 -- using tuple fmap
    putStrLn "Forget... well, I'm not sure why you would want to do this..."
    runForget ( rmap (++"Hi") $ Forget print ) "eee" -- Forgets
    runForget ( lmap (++"hi") $ Forget print ) "eee" -- Remembers
    putStrLn "Mapping is not much different from a functor... but more general?"
    print $ map' show [1,2,3]
    putStrLn "Everything here is a Profunctor, and its base is:"
    print $ dimap (+1) (++"Hi") show 1 -- Left applied to input, arrow run and right applied to output
    putStrLn "Star is like Kleisli but for functors and more generic and applicable - it lifts."
    runStar (rmap succ $ Star print) 1 -- won't do anything because runs on output
    print =<< runStar (rmap succ $ Star return) 1 -- will work
    print $ runStar (dimap (+1) show $ Star Just) 1 -- dimapping a star is good
    putStrLn "Strong allows params to be passed through"
    print $ first' show (1, "hey") -- runs on first param only
    print $ second' show ("hey", 1) -- on second
    putStrLn "Wrapping any arrow to profunctor"
    print $ unwrapArrow (rmap (++"hi") (WrapArrow show) ) 1
    putStrLn "You can curry arrows to a profunctor too rather than just ->"
    print $ curry' snd 2 3
    print $ uncurry' (+) (1,1)
