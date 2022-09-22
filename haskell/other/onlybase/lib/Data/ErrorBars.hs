module Data.ErrorBars where

data MinMax a = MinMax {
    min :: a,
    max :: a
}

data WithError a = WithError {
    n :: a,
    absoluteError :: a
}

