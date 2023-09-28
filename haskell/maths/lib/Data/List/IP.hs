module Data.IP where

import Data.Digits

-- ipv4 is 32-bit. ipv6 is 128-bit.

-- if so, then ipv3 is 16-bit, ipv2 is 8-bit, ipv1 is 4-bit, ipv5 is 64-bit :p

-- how about phone numbers?

-- there appears to be about...
--  10^8 for 01, 10^8 for 02, 10^8 for 03, 10^8 for 07, 2 x 10^7 for 0800/0808, 4 x 10^7 for 0844/0845/0870/0871 so 4 x 10^8 + 6 x 10^7 ~ 2^29, so ~29 bits.

-- so I guess you could fit 8 devices per phone number into the ipv4 address space.

numberToOctets ∷ Integer → [Integer]
numberToOctets _ = []

numberToNibbles ∷ Integer → [Integer]
numberToNibbles _ = []
