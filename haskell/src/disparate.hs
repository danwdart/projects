{-# LANGUAGE ExistentialQuantification #-}

data Disparate = forall a. (Show a) => ShowableDisparate {
    get :: a
 } |
    forall b. HiddenDisparate {
    get :: b
}

instance Show Disparate where
    show (ShowableDisparate a) = show a
    show (HiddenDisparate a) = "(hidden)"

data NamedDisparate = NamedDisparate {
    name :: String,
    idn :: Int,
    thing :: Disparate
} deriving (Show)

as :: [Disparate]
as = [
    ShowableDisparate $ Just 1,
    ShowableDisparate 2,
    ShowableDisparate "Hi",
    HiddenDisparate ($)]

bs :: [NamedDisparate]
bs = [
    NamedDisparate {name = "Jim", idn = -1, thing = ShowableDisparate "My Name Is Jim!"},
    NamedDisparate {name = "Bob", idn = 0, thing = HiddenDisparate $ \x a -> x a },
    NamedDisparate {name = "Comb", idn = 1, thing = HiddenDisparate (.)},
    NamedDisparate {name = "Comb2", idn = 2, thing = HiddenDisparate $ (.) (.) }]

cs :: [NamedDisparate]
cs = map (\n -> NamedDisparate {name = "Bob" ++ show n, idn = n, thing = HiddenDisparate (.) }) [1..5]

ds :: [NamedDisparate]
ds = take 5 $ iterate (\(NamedDisparate n i (HiddenDisparate b)) -> NamedDisparate n (i + 1) (HiddenDisparate b)) $ NamedDisparate "Bob" 1 (HiddenDisparate (.))

main :: IO ()
main = do
    print as
    print bs
    print cs
    print ds