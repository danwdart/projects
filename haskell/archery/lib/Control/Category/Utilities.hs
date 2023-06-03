{-# LANGUAGE Safe #-}

module Control.Category.Utilities where

import Control.Category
import Control.Category.Strong
import Control.Category.Cartesian
import Control.Category.Choice
import Numeric.Natural
import Prelude hiding ((.))

catpow :: Category cat => Natural -> cat a a -> cat a a
catpow 0 _ = error "can't apply a category applicator zero times"
catpow 1 cat = cat
catpow n cat = cat . catpow (n-1) cat -- go?    

(***) :: (Category cat, Strong cat) => cat a b -> cat c d -> cat (a, c) (b, d)
f *** g = second' g . first' f

(&&&) :: (Category cat, Cartesian cat, Strong cat) => cat a b -> cat a c -> cat a (b, c)
f &&& g = (f *** g) . copy

(+++) :: (Category cat, Choice cat) => cat a b -> cat c d -> cat (Either a c) (Either b d)
f +++ g = right' g . left' f

strong :: (Category cat, Cartesian cat, Strong cat) => cat (a, b) r -> cat a b -> cat a r
strong f x = f . second' x . copy


