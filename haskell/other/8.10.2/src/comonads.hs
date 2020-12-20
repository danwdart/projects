{-# LANGUAGE UnicodeSyntax #-}
import           Control.Comonad.Env
import           Control.Comonad.Store
import           Control.Comonad.Traced

main ∷ IO ()
main = do
    print . runEnv $ env "hi" "a"
    print . snd . runStore $ store head "hey"
    print $ (runTraced $ traced head) "hello"