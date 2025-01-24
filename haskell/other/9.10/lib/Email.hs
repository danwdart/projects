{-# LANGUAGE DerivingStrategies #-}

{-# LANGUAGE UnicodeSyntax      #-}

module Email where

import Data.ByteString.Char8 (ByteString)
-- import Data.ByteString.Char8 qualified as BS
import Format
import Parse

data BAN a = Before a | None | After a

data LocalPart = LocalPart {
    username :: ByteString,
    comment  :: BAN ByteString
}

data DomainPart = Domain {
    domainNameLHS :: ByteString,
    tld           :: ByteString
}

data Email = Email {
    localPart  :: LocalPart,
    domainPart :: DomainPart
}

{-instance Format LocalPart where

instance Format DomainPart where

instance Format Email where
    format (Email lhs' rhs') = format lhs' <> "@" <> format rhs'

-}
