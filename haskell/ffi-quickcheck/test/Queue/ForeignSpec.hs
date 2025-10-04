module Queue.ForeignSpec where

import Control.Monad
import Data.Foldable
import Data.Kind
import Foreign
import Queue.Foreign
import Test.Hspec              hiding (runIO)
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Monadic

{- HLINT ignore "Use camelCase" -}

-- prop :: [Int] -> [Int] -<

-- prop ∷ [Int] → [Int] → Property
-- prop x y = collect (size x) $ size x > 3 ==> x <> y === y <> x

-- prop2 x y = collect (size x) $ size x > 3 ==> x <> y === y <> x
--     where types = (x :: [Int], y :: [Int])

-- TODO model this?

-- translate queue types

{-

testAction = do
    q <- QueueSpec.new 1
    put q 1
    get q
    QueueSpec.size q

-}
-- manual = Free (NewF (\q -> Free (PutF q 1) >> Free (SizeF q)))

prop_EmptyQueueHasCorrectSize ∷ Int → Property
prop_EmptyQueueHasCorrectSize size = size > 0 ==> withMaxSuccess 10000 . collect size . monadicIO $ do
    size <- run $ do
        q <- cqueue_new size
        cqueue_size q
    assert $ size == 0

prop_QueueWithFewerElementsAsSizeShowUpInSize ∷ Int → [Int] → Property
prop_QueueWithFewerElementsAsSizeShowUpInSize size elements = size > 0 && length elements < size ==> withMaxSuccess 10000 . collect size . monadicIO $ do
    size <- run $ do
        q <- cqueue_new size
        traverse_ (cqueue_put q) elements
        cqueue_size q
    assert $ size == length elements

prop_QueueWithFewerElementsAsSizeShowUpInGet ∷ Int → [Int] → Property
prop_QueueWithFewerElementsAsSizeShowUpInGet size elements = size > 0 && length elements <= size ==> withMaxSuccess 10000 . collect size . monadicIO $ do
    elementsOut <- run $ do
        q <- cqueue_new size
        traverse_ (cqueue_put q) elements
        replicateM (length elements) (cqueue_get q)
    assert $ elements == elementsOut


spec ∷ Spec
spec = describe "Queue.Foreign" $ do
    prop "creates queues with the correct size" prop_EmptyQueueHasCorrectSize
    prop "shows the size of a queue with fewer elements than its size" prop_QueueWithFewerElementsAsSizeShowUpInSize
    prop "shows the elements of a queue with fewer elements than its size" prop_QueueWithFewerElementsAsSizeShowUpInGet
