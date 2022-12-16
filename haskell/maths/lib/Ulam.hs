
module Ulam where

import           Data.List (find)
import           Data.Maybe

type X = Int
type Y = Int
type Dx = Int
type Dy = Int

type Number = Int
type Loc = (X, Y)
type DiffLoc = (Dx, Dy)

data Item = Item {
    num     :: Number,
    loc     :: Loc,
    diffLoc :: DiffLoc
} deriving stock (Eq, Show)

type Grid = [Item]

initGrid ∷ Grid
initGrid = [Item 0 (0, 0) (1, 0)]

iter ∷ Int → (a → a) → a → a
iter 0 _ x = x
iter n f x = iter (n-1) f (f x)

continueGrid ∷ Grid → Grid
continueGrid grid = grid <> [newitem] where
    lg = last grid
    turn (1, 0)  = (0, 1)
    turn (0, 1)  = (-1, 0)
    turn (-1, 0) = (0, -1)
    turn (0, -1) = (1, 0)
    turn a       = error $ "Invalid turn " <> show a
    search g dl = find (\i -> diffLoc i == dl) g
    getDiffLoc g diffLoc =
        if isJust (search g (turn diffLoc)) then
            diffLoc
        else
            turn diffLoc
    nextItem Item { num, loc = (x, y), diffLoc = diffLoc@(dx, dy) } = Item {
        num = num + 1,
        loc = (x + dx, y + dy),
        diffLoc = getDiffLoc grid diffLoc
    }
    newitem = nextItem lg

writeGrid ∷ Int → Grid
writeGrid n = iter n continueGrid initGrid
