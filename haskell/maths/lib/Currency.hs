module Currency where

-- >>> :set -XUnicodeSyntax
-- >>> import Currency
-- >>> gbp
-- £
-- >>> Money 1 gbp
-- £1.0e-2
--

data Currency = Currency {
    isoCode :: String,
    symbol  :: String,
    name    :: String,
    rate    :: Float
}

instance Show Currency where
    show (Currency _ sym _ _) = sym

gbp ∷ Currency
gbp = Currency "GBP" "£" "Pound Sterling" 1.0

data Money = Money {
    minorAmount :: Int,
    currency    :: Currency
}

instance Show Money where
    show (Money amount curr) = show curr <> show (fromIntegral amount / 100) -- todo fixpoint
