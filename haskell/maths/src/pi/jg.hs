-- Shamelessly stolen from http://www.cs.ox.ac.uk/people/jeremy.gibbons/publications/spigot.pdf
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-local-binds -Wno-incomplete-patterns -Wno-name-shadowing -Wno-missing-signatures -Wno-type-defaults #-}

import           Data.Ratio

main :: IO ()
main = pure ()

type LFT = (Integer, Integer, Integer, Integer)

extr :: LFT -> Integer -> Rational
extr (q,r,s,t) x = (fromInteger q * x + fromInteger r) % (fromInteger s * x + fromInteger t)

unit :: LFT
unit = (1,0,0,1)

comp :: LFT -> LFT -> LFT
comp (q,r,s,t) (u,v,w,x) = (q*u+r*w,q*v+r*x,s*u+t*w,s*v+t*x)


stream :: (b->c) -> (b->c->Bool) -> (b->c->b) -> (b->a->b) ->
           b -> [a] -> [c]
stream   next safe prod cons z (x:xs)
              = if   safe z y
     then y : stream next safe prod cons (prod z y) (x:xs)
     else stream next safe prod cons (cons z x) xs
       where y = next z

initr                 = ((1,0,0,1), 1)
lfts                 = [let j = 3*(3*i+1)*(3*i+2)
                        in (i*(2*i-1),j*(5*i-2),0,j) | i<-[1..]]
next ((q,r,s,t),i)   = div (q*x+5*r) (s*x+5*t) where x = 27*i+15
safe ((q,r,s,t),i) n = n == div (q*x+125*r) (s*x+125*t)
                        where x=675*i-216
prod (z,i) n         = (comp (10, -10*n, 0, 1) z, i)
cons (z,i) z'        = (comp z z', i+1)

pigi = stream next safe prod cons init lfts where
    init      = unit
    lfts      = [(k, 4*k+2, 0, 2*k+1) | k<-[1..]]
    next z    = floor (extr z 3)
    safe z n  = n == floor (extr z 4)
    prod z n  = comp (10, -10*n, 0, 1) z
    cons = comp

piL = stream next safe prod cons init lfts where
    init                 = ((0,4,1,0), 1)
    lfts                 = [(2*i-1, i*i, 1, 0) | i<-[1..]]
    next ((q,r,s,t),i)   = floor ((q*x+r) % (s*x+t)) where
        x=2*i-1
        safe ((q,r,s,t),i) n = n == floor ((q*x+2*r) % (s*x+2*t))
            where x=5*i-2
                  prod (z,i) n         = (comp (10, -10*n, 0, 1) z, i)
                  cons (z,i) z'        = (comp z z', i+1)


piG = stream next safe prod cons initr lfts

piG2 = process next prod cons initr lfts
process next prod cons u (x:xs)
     = y : process next prod cons (prod v y) xs
        where v = cons u x
              y = next v


piG3 = g(1,180,60,2) where
    g(q,r,t,i) = let (u,y)=(3*(3*i+1)*(3*i+2),div(q*(27*i-12)+5*r)(5*t))
                 in y : g(10*q*i*(2*i-1),10*u*(q*(5*i-2)+r-y*t),t*u,i+1)

