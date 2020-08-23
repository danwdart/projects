import           Data.Ratio

import           Factory.Math.Implementations.Pi.BBP.Algorithm
import           Factory.Math.Implementations.Pi.BBP.Bellard
import           Factory.Math.Implementations.Pi.BBP.Series
import           Factory.Math.Pi

main :: IO ()
main = return ()

dig (MkSeries numerators getDenominators seriesScalingFactor base) = zipWith (*) (iterate (/ fromIntegral base) 1) $ map (sum . zipWith (%) numerators . getDenominators) [0 ..]
