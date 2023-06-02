module Queue.ForeignSpec where

import Control.Monad
import Data.Kind
import Foreign
import           Test.Hspec hiding (runIO)
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Monadic
import Queue.Foreign

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

prop_EmptyQueueHasCorrectSize :: Int -> Property
prop_EmptyQueueHasCorrectSize size = size > 0 ==> withMaxSuccess 10000 . collect size . monadicIO $ do
    size <- run $ do
        q <- queue_new size
        queue_size q
    assert $ size == 0

prop_QueueWithFewerElementsAsSizeShowUpInSize :: Int -> [Int] -> Property
prop_QueueWithFewerElementsAsSizeShowUpInSize size elements = size > 0 && length elements < size ==> withMaxSuccess 10000 . collect size . monadicIO $ do
    size <- run $ do
        q <- queue_new size
        mapM_ (queue_put q) elements
        queue_size q
    assert $ size == length elements

prop_QueueWithFewerElementsAsSizeShowUpInGet :: Int -> [Int] -> Property
prop_QueueWithFewerElementsAsSizeShowUpInGet size elements = size > 0 && length elements <= size ==> withMaxSuccess 10000 . collect size . monadicIO $ do
    elementsOut <- run $ do
        q <- queue_new size
        mapM_ (queue_put q) elements
        replicateM (length elements) (queue_get q) 
    assert $ elements == elementsOut


spec ∷ Spec
spec = describe "Queue.Foreign" $ do
    it "creates queues with the correct size" $
        property prop_EmptyQueueHasCorrectSize
    it "shows the size of a queue with fewer elements than its size" $
        property prop_QueueWithFewerElementsAsSizeShowUpInSize
    it "shows the elements of a queue with fewer elements than its size" $
        property prop_QueueWithFewerElementsAsSizeShowUpInGet