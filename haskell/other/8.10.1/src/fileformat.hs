import qualified Data.ByteString as B
import Data.ByteString (ByteString)
import Foreign.Storable (Storable (..), )
import Foreign.Storable.Record as Store

data Png = Png {
    magicNumber :: ByteString,
    version :: ByteString
}

store :: Store.Dictionary Png
store =
   Store.run $
   Png <$>
      Store.element magicNumber <*>
      Store.element version

instance Storable Png where
   sizeOf = Store.sizeOf store
   alignment = Store.alignment store
   peek = Store.peek store
   poke = Store.poke store

main :: IO ()
main = return ()