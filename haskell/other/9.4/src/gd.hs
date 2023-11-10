module Main (main) where

import Graphics.GD
import Seq
--  Let's make things into gifs, ideally lossless videos, encoded, for the lels
-- This needs the so file though, so I guess I should make a new docker image...

{-
main2 :: IO ()
main2 = do
    i <- newImage (256,256)
    drawFilledRectangle (0,0) (255,255) (rgb 255 255 255) i
    drawLine (100,100) (200,200) (rgb 0 0 0) i
    setPixel (10,10) (rgb 0 0 0) i
    saveGifFile "bob.gif" i
-}

    -- so what about a combinator for \f x -> f x >> pure x for things that pure IO () but I want the result from?
    -- idk maybe better in the state monad or the env monad?
main ∷ IO ()
main = newImage (256, 256) >>>=
    drawFilledRectangle (0, 0) (255, 255) (rgb 255 255 255) >>>=
    drawLine (100, 100) (200, 200) (rgb 0 0 0) >>=
    saveGifFile "jim.gif"
