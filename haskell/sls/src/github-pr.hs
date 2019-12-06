import AWSLambda
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL
-- import Data.Text

main :: IO ()
main = lambdaMain handler

handler :: Value -> IO String
handler evt = return $ BSL.unpack $ encode evt