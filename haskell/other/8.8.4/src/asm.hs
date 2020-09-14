{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE UnboxedTuples #-}
{-# LANGUAGE GHCForeignImportPrim #-}
{-# LANGUAGE UnliftedFFITypes #-}

import Language.Asm.Inline
import Language.Asm.Inline.QQ

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

main :: IO ()
main = return ()