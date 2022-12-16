{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-local-binds -Wno-missing-signatures -Wno-type-defaults -Wno-unused-matches #-}

import           Data.Map (Map)
import qualified Data.Map as M
import           Data.Set (Set)
import qualified Data.Set as S

main ∷ IO ()
main = pure ()

data OhOrZero = Oh | Zero deriving stock (Eq)
data HundredPrefix = A | One | NoPrefix deriving stock (Eq)
data Scale = Long | PeletierLong | Short | Sand deriving stock (Eq)

type ScaleOffset = Int
type ScaleMultiplier = Int
type StringLong = String → String
type StringShort = String → String
type ScaleDetails = (ScaleOffset, ScaleMultiplier, StringLong, Maybe (Int, StringShort))

scaleDetails ∷ Scale → ScaleDetails
scaleDetails Long = (0, 6, (++ "illion"), Just (3, ("thousand " ++) . (++ "illion")))
scaleDetails PeletierLong = (0, 6, (++ "illion"), Just (3, (++ "illiard")))
scaleDetails Short = (3, 3, (++ "illion"), Nothing)
scaleDetails Sand = (0, 3, (++ "sand"), Nothing)

data Config = Config {
    oh      :: OhOrZero,
    hundred :: HundredPrefix,
    scale   :: Scale
}

modifier ∷ (Integer → Integer) → String → Set Integer → Map Integer String → Map Integer String
modifier modNumFn name range changes = M.mapKeys modNumFn . M.map (++ name) $ M.union changes (
    M.restrictKeys basics range)

pows ∷ Map Integer String → Map Integer String
pows = M.mapKeys (10 ^)

mergeUpMaps ∷ Map a (Map a c) → Map a c
mergeUpMaps = undefined

scaledPowData ∷ Map Int String
scaledPowData = M.fromList [
    (1, "m"),
    (2, "b"),
    (3, "tr"),
    (4, "quadr"),
    (5, "quint"),
    (6, "sext"),
    (7, "sept"),
    (8, "oct"),
    (9, "non"),
    (10, "dec")
    ]

scaledPowModData ∷ Map Int String
scaledPowModData = M.fromList [
    (1, "un"),
    (2, "duo"),
    (3, "tre"),
    (4, "quattuor"),
    (5, "quin"),
    (6, "se"),
    (7, "septem"),
    (8, "octo"),
    (9, "novem")
    ]

scaledPowTData ∷ Map Int String
scaledPowTData = M.fromList [
    (2, "vi"),
    (3, "tri"),
    (4, "quadra"){-},
    (5, "quinqua"),
    (6, "sexa"),
    (7, "septua"),
    (8, "octo"),
    (9, "nona")
    -}
    ]

combPowData ∷ Map Int String
combPowData = M.fromList . concatMap (\(k, v) -> M.toList $
        M.mapKeys ((k +) . (10 *)) (
            M.map (v ++) scaledPowTData
        )
    ) $ M.toList scaledPowModData

scaledPows ∷ Scale → Map Int String → Map Integer String
scaledPows sc datas = M.map sl (M.mapKeys (((10 ^ so) *) . ((10 ^ sm) ^)) datas) <>
    maybe M.empty (\(offset, offsetName) -> M.map offsetName (
        M.mapKeys (((10 ^ so) *) . ((10 ^ offset) *) . ((10 ^ sm) ^)) datas
    )) miss
    where
        (so, sm, sl, miss) = scaleDetails sc
unscaledPows list = []

defWords ∷ Map Integer String
defWords = numToWords (Config Zero One Long)

basics ∷ Map Integer String
basics = M.fromList [
    (1, "one"),
    (2, "two"),
    (3, "three"),
    (4, "four"),
    (5, "five"),
    (6, "six"),
    (7, "seven"),
    (8, "eight"),
    (9, "nine")
    ]

numToWords ∷ Config → Map Integer String
numToWords (Config o h s) = let (so, sm, sl, miss) = scaleDetails s in
    M.fromList [(0, if o == Oh then "oh" else "zero")] <>
    basics <>
    M.fromList [
        (10, "ten"),
        (11, "eleven"),
        (12, "twelve")
        ] <>
    modifier (10 +) "teen" (S.fromList [3..9]) (M.fromList [(3, "thir"), (5, "fif"), (8, "eigh")]) <>
    modifier (10 *) "ty" (S.fromList [2..9]) (M.fromList [(2, "twen"), (3, "thir"), (5, "fif"), (8, "eigh")]) <>
    pows (M.fromList [(2, "hundred"), (3, "thousand")]) <>
    scaledPows s scaledPowData <>
    scaledPows s (M.map (++ "dec") $ M.mapKeys (+ 10) scaledPowModData) <>
    scaledPows s (M.map (++ "gint") $ M.mapKeys (* 10) scaledPowTData) <>
    scaledPows s (M.map (++ "gint") $ M.mapKeys (* 10) combPowData)
    {- ++
    scaledPows 10 scale "ard" "on" "illi" "gint" "" [
        -- tens and hundreds
        (2, "vi"),
        (3, "tri"),
        (4, "quadra"),
        (5, "quinqua"),
        (6, "sexa"),
        (7, "septua"),
        (8, "octo"),
        (9, "nona")
        ] [
        -- singles and tens
        (1, "un"),
        (5, "quinqua"),
        (6, "ses")
        ] ++
    scaledPows 100 scale "ard" "on" "illi" "cent" "a" [
        (2, "du"),
        (3, "tre")
        ] [] ++
    scaledPows 100 scale "ard" "on" "illi" "gent" "" [
        (4, "quadrin"),
        (5, "quin")
        ] [] ++
    unscaledPows [
        (100, "googol")
        ] -}

ords ∷ [(Integer, String)]
ords = []

fraction ∷ [(Integer, String)]
fraction = []

indianPow ∷ [(Integer, String)]
indianPow = [
    (5, "lakh"),
    (7, "crore"),
    (9, "arab"),
    (11, "kharab"),
    (13, "nil"),
    (15, "padma"),
    (17, "shankh")
    ]

ramanayaVedicPow ∷ [(Integer, String)]
ramanayaVedicPow = [
    (0, "ēka"),
    (1, "daśa"),
    (2, "śata"),
    (3, "sahasra"),
    (4, "ayuta"),
    (5, "lakṣa"),
    (6, "niyuta"),
    (7, "kōṭi"),
    (12, "śaṅku"),
    (17, "mahāśaṅku"),
    (22, "vr̥nda"),
    (27, "mahāvr̥nda"),
    (32, "padma"),
    (37, "mahāpadma"),
    (42, "kharva"),
    (47, "mahākharva"),
    (52, "samudra"),
    (57, "ōgha"),
    (62, "mahaugha")
    ]

fifthCenturyIndianPow ∷ [(Integer, String)]
fifthCenturyIndianPow = [
    (5, "lakṣá"),
    (7, "kōṭi"),
    (9, "ayuta"),
    (13, "niyuta"),
    (14, "pakoti"),
    (15, "vivara"),
    (17, "kshobhya"),
    (19, "vivaha"),
    (21, "kotippakoti"),
    (23, "bahula"),
    (25, "nagabala"),
    (28, "nahuta"),
    (29, "titlambha"),
    (31, "vyavasthanapajnapati"),
    (33, "hetuhila"),
    (35, "ninnahuta"),
    (37, "hetvindriya"),
    (39, "samaptalambha"),
    (41, "gananagati"),
    (42, "akkhobini"),
    (43, "niravadya"),
    (45, "mudrabala"),
    (47, "sarvabala"),
    (49, "bindu"),
    (51, "sarvajna"),
    (53, "vibhutangama"),
    (56, "abbuda"),
    (63, "nirabbuda"),
    (70, "ahaha"),
    (77, "ababa"),
    (84, "atata"),
    (91, "soganghika"),
    (98, "uppala"),
    (105, "kumuda"),
    (112, "pundarika"),
    (119, "paduma"),
    (126, "kathana"),
    (133, "mahakathana"),
    (140, "asaṃkhyeya"),
    (421, "dhvajagranishamani"),
    -- 7 * 2 ^ 122
    (37218383881977644441306597687849648128, "bodhisattva")
    ]

fifthCenturyInfianInfinitiesPow ∷ [(Integer, String)]
fifthCenturyInfianInfinitiesPow = [
    (200, "lalitavistarautra"),
    (600, "matsya"),
    (2000, "kurma"),
    (3600, "varaha"),
    (4800, "narasimha"),
    (5800, "vamana"),
    (6000, "parashurama"),
    (6800, "rama"),
    (1, "khrishnaraja"),
    (8000, "kalki"),
    (9800, "balarama"),
    (10000, "dasavatara"),
    (18000, "bhagavatapurana"),
    (30000, "avatamsakasutra"),
    (50000, "mahadeva"),
    (60000, "prajapati"),
    (80000, "jyotiba"),
    (20000000000, "parvati"),
    (400000000000000000, "paro")
    ]
