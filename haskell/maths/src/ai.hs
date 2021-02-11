{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-local-binds -Wno-unused-top-binds -Wno-unused-matches -Wno-missing-signatures #-}
-- Neural Network

-- @see https://victorzhou.com/blog/intro-to-neural-networks/

sigmoid :: Double -> Double
sigmoid x = 1 / (1 + exp (0 - x))

derivSigmoid :: Double -> Double
derivSigmoid x = s * (1 - s)
    where s = sigmoid x

dot :: [Double] -> [Double] -> Double
dot [a, b] [c, d] = a * c + b * d
dot _ _ = error "Not implemented"

data Neuron = Neuron {
    weights :: [Double],
    bias :: Double
} deriving (Show)

mseLoss :: [Double] -> [Double] -> Double
mseLoss trues preds = sum (fmap (**2) (zipWith (-) trues preds)) / fromIntegral (length trues)

data Network = Network {
    hiddenLayer :: [Neuron],
    outputLayer :: [Neuron]
} deriving (Show)

dots :: [Double] -> Neuron -> Double
dots inputs neuron = dot (weights neuron) inputs + (bias neuron)

feedforward :: [Double] -> Neuron -> Double
feedforward inputs neuron = sigmoid $ dots inputs neuron

ffLayer :: [Double] -> Network -> Double
ffLayer inputs (Network hiddens outputs) = feedforward (fmap (feedforward inputs) hiddens) (head outputs)

learnRate :: Double
learnRate = 0.1

epochs :: Int
epochs = 1000

train data' allYTrues network@Network {
    hiddenLayer = hiddenLayer',
    outputLayer = outputLayer'
} =
    fmap (\epoch ->
        fmap (\(xs, yTrue) ->
            let sumHidden = fmap (dots xs) hiddenLayer'
                sigHidden = fmap sigmoid sumHidden
                sumOutput = fmap (dots sumHidden) outputLayer'
                sigOutput = fmap sigmoid sumOutput
                yPred = ffLayer xs network
                d_L_d_ypred = -2 * (yTrue - yPred)
                dOutputs = derivSigmoid (sumOutput !! 0)
                -- dHiddens = fmap ((*) dOutputs) sigHidden

                -- d_ypred_d_w5 = (hiddenLayer' !! 0) * derivSigmoid(sum_o1)
            in 1

            ) (zip data' allYTrues)
        ) [1..epochs]


defaultNetwork :: Network
defaultNetwork = Network {
    hiddenLayer = [
        Neuron [0, 1] 0,
        Neuron [0, 1] 0
        ],
    outputLayer = [
        Neuron [0, 1] 0
        ]
}


main ∷ IO ()
main = do
    print $ ffLayer [2, 3] defaultNetwork
    print $ mseLoss [1,0,0,1] [0,0,0,0]