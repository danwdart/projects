main :: IO ()
main = return ()

type NumHooks = Int

newtype Hook = Hook {
    getHookNo :: Int
} deriving (Eq, Show)

makeHooks :: NumHooks -> [Hook]
makeHooks = undefined

data Direction = Clockwise | Anticlockwise deriving (Enum, Eq, Show)

type Hang = (Hook, Direction)

type PotentialSolution = [Hang]

data IterationStats a = IterationStats {
    steps :: Integer,
    sequence :: [a],
    result :: a
} deriving (Show)

iterateUntilUnchanged :: (a -> a) -> a -> a
iterateUntilUnchanged = undefined

iterateUntilUnchangedWithStats :: (a -> a) -> a -> IterationStats a
iterateUntilUnchangedWithStats = undefined

initialSeq :: PotentialSolution
initialSeq = undefined

flattenSeq :: PotentialSolution -> PotentialSolution
flattenSeq = undefined

isFallingSolution :: PotentialSolution -> Bool
isFallingSolution = null . flattenSeq