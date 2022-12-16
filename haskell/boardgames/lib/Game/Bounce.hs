{-# LANGUAGE LambdaCase #-}
{-# OPTIONS_GHC
    -Wno-unused-matches
    -Wno-unused-top-binds
    -Wno-missing-signatures
    -Wno-missing-exported-signatures
    -Wno-unused-local-binds
    -Wno-overlapping-patterns
    -Wno-name-shadowing
#-}

module Game.Bounce where

{-}
A-|-|-B
|-|-|-|
C-|-|-D

Using SCREEN coords, not Cartesian!
-}

data Corner = A | B | C | D deriving stock (Eq, Show, Bounded, Enum)

type Width = Int
type Height = Int

type Size = (Width, Height)

type X = Int
type Y = Int

type Coord = (X, Y)

type DiffX = Int
type DiffY = Int

type Direction = (DiffX, DiffY)

-- (a -> a -> a) -> (a, a) -> (a, a) -> (a, a)
move ∷ Direction → Coord → Coord
move (dx, dy) (x, y) = (x + dx, y + dy) -- is there some kind of... fold?

moveBounce ∷ Size → Direction → Coord → Coord
moveBounce = undefined -- incorporate bouncing

cornerToCoord ∷ Size → Corner → Coord
cornerToCoord (width, height) = \case
    A -> (0, 0)
    B -> (width - 1, 0)
    C -> (0, height - 1)
    D -> (width - 1, height - 1)

coordToMaybeCorner ∷ Size → Coord → Maybe Corner
coordToMaybeCorner (width, height) = \case
    (0, 0)                      -> Just A
    (widthminus1, 0)            -> Just B
    (0, heightminus1)           -> Just C
    (widthminus1, heightminus1) -> Just D
    _                           -> Nothing
    where
        widthminus1 = width - 1 -- what?
        heightminus1 = height - 1 -- huh?

cornerToDirection ∷ Corner → Direction
cornerToDirection = \case
    A -> (1, 1)
    B -> (-1, 1)
    C -> (1, -1)
    D -> (-1, -1)

bounceFromWall = undefined

hasHitWall = undefined

findCorner ∷ Size → Corner → Corner
findCorner (width, height) corner = undefined
