{-# LANGUAGE CPP              #-}
{-# LANGUAGE Unsafe           #-}

module Run where

#if defined(__GHCJS__)
run :: a -> a
run = id
#else
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Warp as W    
run :: JSM () -> IO ()
run = W.run 3003
#endif