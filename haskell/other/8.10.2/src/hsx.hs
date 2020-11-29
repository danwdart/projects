{-# LANGUAGE UnicodeSyntax #-}
-- {-# LANGUAGE FlexibleContexts, OverloadedStrings, TemplateHaskell, TypeFamilies, QuasiQuotes #-}
-- import Data.Text
-- import HSP
-- import HSP.Monad
-- import Language.Haskell.HSX.QQ
-- import Language.Haskell.HSX.Transform

-- myName :: Text
-- myName = "Bob"

-- html :: (XMLGenerator m) => XMLGenT m (XMLType m)
-- html = undefined -- [hsx| <header><h1><% myName %></h1></header> |]

main ∷ IO ()
main = pure () -- print $ unXMLGenT html
