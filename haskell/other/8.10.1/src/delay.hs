import           Control.Concurrent
import           Control.Monad
import           Data.Functor
import           Data.List
import           System.Console.ANSI
import           System.IO
import           System.Random

typeDelay :: Int -> String -> IO ()
typeDelay delay = mapM_ (\c -> threadDelay delay >> putChar c)

typeSlow :: String -> IO ()
typeSlow = typeDelay 50000

typeFast :: String -> IO ()
typeFast = typeDelay 10000

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    hideCursor
    typeSlow "Hello World\n\nWelcome to the ARVIX system.\n\nCalculating initialisation variables\t\\\b|\b/\b-\b/\b-\bDone.\n"
    typeSlow "Cracking password\n"
    fastPass
    putChar '\n'
    typeSlow "Logging into mainframe\n"
    typeSlow "root@mainframe:~# "
    putChar '\n'
    showCursor

pass :: IO String
pass = crackPassword <&> (\pw -> intercalate pw $ charsToStringList "MYPASSWORD")

fastPass :: IO ()
fastPass = pass >>= typeFast

charsToStringList :: String -> [String]
charsToStringList = fmap (: [])

-- password :: IO String
-- password = crackPassword <&> (\pw -> intercalate pw $ charsToStringList "MYPASSWORD")

crackPassword :: IO String
crackPassword = (replicateM 25 (randomRIO ('A','Z')) <&> intersperse '\b') <&> (++"\b")
