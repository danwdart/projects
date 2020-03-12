main :: IO ()
main = return ()

data OhOrZero = Oh | Zero deriving (Eq)
data AOrOneOrNothing = Aa | One | Nothing deriving (Eq)
data Scale = Long | Peletier | Short deriving (Eq)

data Config = Config {
    oh :: OhOrZero,
    hundred :: AOrOneOrNothing,
    scale :: Scale
}

modifier modNumFn name range changes = []

pows list = []

scaledPows mulOfScale scale midScaleName fullScaleName allScaleName secondaryScaleName nameListPrimary nameListSecondary optionalName = []

unscaledPows list = []

defWords = numToWords (Config Zero One Long)

numToWords config = [
    (0, if oh config == Oh then "oh" else "zero"),
    (1, "one"),
    (2, "two"),
    (3, "three"),
    (4, "four"),
    (5, "five"),
    (6, "six"),
    (7, "seven"),
    (8, "eight"),
    (9, "nine"),
    (10, "ten"),
    (11, "eleven"),
    (12, "twelve")
    ] ++
    modifier (10+) "teen" [3..9] [(3, "thir"), (5, "fif")] ++
    modifier (10*) "ty" [2..9] [(2, "twen"), (3, "thir"), (5, "fif")] ++
    pows [(2, "hundred"), (3, "thousand")] ++
    scaledPows 1 scale "ard" "on" "illi" "" "" [
        (1, "m"),
        (2, "b"),
        (3, "tr"),
        (4, "quadr"),
        (5, "quint"),
        (6, "sext"),
        (7, "sept"),
        (8, "oct"),
        (9, "non"),
        (10, "dec"),
        (11, "undec"),
        (12, "duodec"),
        (13, "tredec"),
        (14, "quattuordec"),
        (15, "quindec"),
        (16, "sedec"),
        (17, "septendec"),
        (18, "octodec"),
        (19, "novemdec")
        ] [] ++
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
        ]

ords = []

fraction = []

indianPow = [
    (5, "lakh"),
    (7, "crore"),
    (9, "arab"),
    (11, "kharab"),
    (13, "nil"),
    (15, "padma"),
    (17, "shankh")
    ]

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