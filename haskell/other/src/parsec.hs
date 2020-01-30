import System.Console.ANSI.Types
import Control.Monad
import Text.Parsec

number :: Parsec String u Int
number = read <$> many digit

newtype DanImage = DanImage {
    getPixels :: [[Color]]
} deriving (Eq, Show)

encodeDanImage :: DanImage -> String
encodeDanImage = undefined

danParserMonadic :: Parsec String u DanImage
danParserMonadic = do
    _ <- string "DAN"
    version <- many digit
    when (version /= "03") $ fail "Unsupported version"
    _ <- newline
    width <- number
    _ <- char ','
    height <- number
    _ <- newline
    -- todo count
    pixels <- sepBy (sepBy (toEnum . read <$> many digit) (char ',')) newline
    when (height /= length pixels) $ fail "Height not correct"
    when (width /= length (head pixels)) $ fail "Width not correct"
    return $ DanImage pixels

main :: IO ()
main = do
    print $ parse (char 'h') "Wtf?" "hi"
    print $ parse (string "My word." >> anyChar) "Wtf?" "My word..."
    print $ parse ((,) <$> string "My word." <*> anyChar) "Wtf?" "My word..."
    print $ parse danParserMonadic "Can't parse image." "DAN03\n2,2\n0,1\n2,3"