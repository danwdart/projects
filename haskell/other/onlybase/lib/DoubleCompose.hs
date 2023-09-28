module DoubleCompose where

import Data.Functor.Compose

-- TODO generalise

type DoubleCompose f g h x = Compose (Compose f g) h x

compose2 ∷ f (g (h x)) → DoubleCompose f g h x
compose2 = Compose . Compose

getCompose2 ∷ DoubleCompose f g h x → f (g (h x))
getCompose2 = getCompose . getCompose

newtype ComposeTwo f g h x = ComposeTwo {
    getComposeTwo :: f (g (h x))
} deriving stock (Functor)

-- uhh... maybe?

-- instance (Applicative f, Applicative g, Applicative h) => Applicative (ComposeTwo f g h) where
--     pure = ComposeTwo . pure
