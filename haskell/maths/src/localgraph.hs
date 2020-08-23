import           Data.Graph.DGraph
import           Data.Graph.Traversal
import           Data.Graph.Types
import           Data.Graph.UGraph
import           Data.Graph.Visualize

import           Data.List
import           Data.Maybe

import           Control.Concurrent

import           Data.GraphViz
import           Data.GraphViz.Attributes.Complete
import           Data.Hashable
import qualified Data.Text.Lazy                    as TL

import           Data.Graph.Inductive.Graph
import           Data.Graph.Inductive.PatriciaTree
-- chair is 3m/s = 180m/min = 10.8km/h

walkingGraph :: UGraph String Int
walkingGraph = fromEdgesList [
    Edge "Home" "Brewery Lane" 300,
    Edge "Home" "Pub" 200,
    Edge "Pub" "Brewery Lane" 250,
    Edge "Pub" "B&M" 400,
    Edge "Pub" "Dobbies" 560,
    Edge "Brewery Lane" "Sandwich" 360,
    Edge "Pub" "Sandwich" 370, --
    Edge "Brewery Lane" "CoopChippy" 300,
    Edge "CoopChippy" "Park Start" 450,
    Edge "Brewery Lane" "Park Start" 640,
    Edge "Park Start" "Pond" 160,
    Edge "Park Start" "Church Road" 240,
    Edge "Pond" "Church Road" 235,
    Edge "Church Road" "High Street Top" 160,
    Edge "High Street Top" "Tesco" 210,
    Edge "High Street Top" "Subway" 135,
    Edge "Subway" "Aldi Car Park" 25,
    Edge "Aldi Car Park" "Aldi" 90,
    Edge "High Street Top" "McColls" 195,
    Edge "Park Start" "McColls" 455,
    Edge "CoopChippy" "BackFootpathStart" 300,
    Edge "BackFootpathStart" "DoctorsEntranceOfPark" 730,
    Edge "DoctorsEntranceOfPark" "Pond" 170,
    Edge "DoctorsEntranceOfPark" "Church Road" 150, -- to test
    Edge "DoctorsEntranceOfPark" "Doctors" 160,
    Edge "Doctors" "Tesco" 400,
    Edge "Doctors" "Jones" 400,
    Edge "Home" "Road Above" 1650,
    Edge "Road Above" "CoopChippy" 2700
    ]

-- START fgl

vwg = vertices walkingGraph

walkingFglNodes :: [LNode String]
walkingFglNodes = zip [0..] vwg

walkingFglEdges :: [LEdge Int]
walkingFglEdges = map (\(a, b, c) -> (fromJust (elemIndex a vwg), fromJust (elemIndex b vwg), c)) $ edgeTriples walkingGraph

fglGraph :: Gr String Int
fglGraph = mkGraph walkingFglNodes walkingFglEdges

-- END fgl

walkingGraphTimeInMinutes :: UGraph String Double
walkingGraphTimeInMinutes = (/10) . fromIntegral . round . (/18) . fromIntegral <$> walkingGraph

birdsEyeGraph :: UGraph String Int
birdsEyeGraph = fromEdgesList [
    Edge "Home" "Folks" 4300,
    Edge "Folks" "Charles" 5130,
    Edge "Home" "Charles" 9100,
    Edge "Home" "Colin" 12615,
    Edge "Home" "RUH" 24670,
    Edge "Home" "Airport" 25470,
    Edge "Home" "Birth" 86400,
    Edge "Home" "Grandad" 99850,
    Edge "Home" "Paddington" 168000,
    Edge "Home" "Sagrada Familia" 1145830,
    Edge "Home" "Murano" 1271035,
    Edge "Home" "Izotcha" 9637235,
    Edge "Home" "FSF" 5130480,
    Edge "Home" "White House" 5765205,
    Edge "Home" "Sydney Opera House" 17150260,
    Edge "Home" "Magnetic North" 4725445,
    Edge "Home" "Magnetic South" 17272380,
    Edge "Home" "Furthest Point" 20000000, -- near Campbell Escarpment... Campbell Island, then Auckland Island
    Edge "Magnetic North" "Magnetic South" 16814685
    ]

compositionGraph :: DGraph String String
compositionGraph = fromArcsList [
    Arc "1C1_1" "1C2_1" "$ 1C1_1",
    Arc "1C1_1" "1C2_1" "& 1C1_1",
    Arc "1C2_1" "1C3_1" "$ 1C1_1",
    Arc "1C2_1" "1C3_1" "& 1C1_1"
    ]


main :: IO ()
main = return ()

-- | Same as 'plotUGraph' but render edge attributes
plotUGraphEdged :: (Hashable v, Ord v, PrintDot v, Show v, Show e)
 => UGraph v e
 -> IO ThreadId
plotUGraphEdged g = forkIO $ runGraphvizCanvas Sfdp (toUndirectedDot True g) Xlib

labeledNodes :: (Data.Graph.Types.Graph g, Show v) => g v e -> [(v, String)]
labeledNodes g = (\v -> (v, show v)) <$> vertices g

labeledEdges :: (Hashable v, Eq v, Show e) => UGraph v e -> [(v, v, String)]
labeledEdges g = (\(Edge v1 v2 attr) -> (v1, v2, show attr)) <$> Data.Graph.UGraph.edges g

toUndirectedDot :: (Hashable v, Ord v, Show v, Show e)
 => Bool -- ^ Label edges
 -> UGraph v e
 -> DotGraph v
toUndirectedDot labelEdges g = graphElemsToDot params (labeledNodes g) (labeledEdges g)
    where params = sensibleDotParams True labelEdges -- t

sensibleDotParams
 :: Bool -- ^ Directed
 -> Bool -- ^ Label edges
 -> GraphvizParams t l String () l
sensibleDotParams directed edgeLabeled = nonClusteredParams
    { isDirected = directed
    , globalAttributes =
        [ GraphAttrs [Overlap ScaleOverlaps]
        , EdgeAttrs [FontColor (X11Color DarkGreen)]
        ]
    , fmtEdge = edgeFmt
    }
    where
        edgeFmt (_, _, l) = [Label $ StrLabel $ TL.pack l | edgeLabeled]


