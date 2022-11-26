{-# LANGUAGE UnicodeSyntax #-} -- needed for lsp etc
{-# LANGUAGE DataKinds, GADTs #-}

module Data.DisparateList where

-- tbh this is really like some kind of super tuple
data DisparateList ts where
    Nil :: DisparateList '[]
    (:>) :: a -> DisparateList t -> DisparateList (a ': t)

infixr 5 :>

instance Show (DisparateList '[]) where
    show _ = "that's it"

instance (Show a, Show (DisparateList t)) ⇒ Show (DisparateList (a ': t)) where
    show (a :> t) = show a <> " and " <> show t

-- >>> 1 :> 2 :> Nil
-- 1 and 2 and that's it
--

-- >>> :t 1 :> 2 :> 'a' :> [6,7,2] :> undefined
-- 1 :> 2 :> 'a' :> [6,7,2] :> undefined
--   :: (Num a1, Num a2, Num a3) =>
--      DisparateList (a1 : a2 : Char : [a3] : t)
--

