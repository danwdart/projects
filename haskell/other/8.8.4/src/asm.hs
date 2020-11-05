{-# LANGUAGE GHCForeignImportPrim #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UnboxedTuples        #-}
{-# LANGUAGE UnicodeSyntax        #-}
{-# LANGUAGE UnliftedFFITypes     #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Language.Asm.Inline
import           Language.Asm.Inline.QQ

-- segfaults!
defineAsmFun "cpuidName"
  [asmTy| (o : Int) | (b : Int) (d : Int) (c : Int) |]
  [asm|
  mov %rax, 0
  cpuid
  mov {b}, %rbx
  mov {d}, %rdx
  mov {c}, %rcx
  |]

main ∷ IO ()
main = return ()
