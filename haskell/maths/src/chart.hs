module Main (main) where

import Chart
import Codec.Picture
import Codec.Picture.ColorQuant
import Control.Monad.Except
import Control.Monad.IO.Class
import Data.List                              qualified as L
import System.Directory

pngToImage ∷ FilePath → ExceptT String IO DynamicImage
pngToImage = ExceptT . readImage

seqToImage ∷ [Integer] → ExceptT String IO DynamicImage
seqToImage numberSequence = do
    liftIO $ putStrLn "Creating image..."
    liftIO $ seqToPng "tmp.png" "Lucas" "Lucas" 0 numberSequence
    liftIO $ putStrLn "Decoding image..."
    i0 <- pngToImage "tmp.png"
    liftIO $ putStrLn "Deleting image..."
    liftIO . removeFile $ "tmp.png"
    pure i0

iandp ∷ [Integer] → ExceptT String IO (Image Pixel8, Palette)
iandp xs = palettize defaultPaletteOptions . convertRGB8 <$> seqToImage xs

lucases ∷ [Integer]
lucases = 2 : 1 : zipWith (+) lucases (drop 1 lucases)

main ∷ IO ()
main = do
    result <- runExceptT $ do
        let nums ∷ [[Integer]]
            nums = take 16 $ L.inits lucases
        iandps <- traverse iandp nums
        let incdels ∷ [(Palette, GifDelay, Image Pixel8)]
            incdels = fmap (\(i, p) -> (p, 20, i)) iandps
        liftIO $ putStrLn "Encoding as GIF..."
        ExceptT . sequenceA $ writeGifImages "tmp.gif" LoopingNever incdels
        liftIO $ putStrLn "Done."
        pure ()
    case result of
        Left failure  -> putStrLn failure
        Right success -> pure success
