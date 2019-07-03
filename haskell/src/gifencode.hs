import Graphics.GD
--  Let's make things into gifs, ideally lossless videos, encoded, for the lels
-- This needs the so file though, so I guess I should make a new docker image...

main :: IO ()
main = do
    i <- newImage (256,256)
    drawFilledRectangle (0,0) (255,255) (rgb 255 255 255) i
    drawLine (100,100) (200,200) (rgb 0 0 0) i
    drawLine (100,100) (200,200) (rgb 0 0 0) i
    setPixel (10,10) (rgb 0 0 0) i
    saveGifFile "bob.gif" i