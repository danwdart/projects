module Data.Code.PHPCode where

data PHPCode a b = PHPCode String
    deriving (Eq, Show)

instance IsString (PHPCode a b) where
    fromString = PHPCode

instance Category PHPCode where
    id = "($x => $x)"
    PHPCode a . PHPCode b = PHPCode $ "(fn ($x) => " <> a <> "(" <> b <> "($x)))"

instance Cartesian PHPCode where
    copy = "(fn ($x) => [$x, $x])"
    consume = "(fn ($x) => null)"
    fst' = "(fn ($x) => $x[0])"
    snd' = "(fn ($x) => $x[1])"

instance Cocartesian PHPCode where
    injectL = "(fn ($x) => ['tag' => 'left', 'value' => $x])"
    injectR = "(fn ($x) => ['tag' => 'right', 'value' => $x])"
    unify = "(fn ($x) => $x['value'])"
    tag = "(fn ($x) => ['tag' => $x[0] ? 'right' : 'left', 'value' => $x[1]])"

instance Strong PHPCode where
    first' (PHPCode f) = PHPCode $ "(fn ($x) => [" <> f <> "($x[0]), $x[1]])"
    second' (PHPCode f) = PHPCode $ "(fn ($x) => [$x[0], " <> f <> "($x[1])])"

instance Choice PHPCode where
    left' (PHPCode f) = PHPCode $ "(fn ($x) => ['tag' => $x['tag'], 'value' => $x['tag'] === 'left' ? " <> f <> " ($x['value']) : $x['value']])"
    right' (PHPCode f) = PHPCode $ "(fn ($x) => ['tag' => $x['tag'], 'value' => $x['tag'] === 'right' ? " <> f <> " ($x['value']) : $x['value']])"

-- instance Symmetric PHPCode where

-- instance Cochoice PHPCode where

-- instance Costrong PHPCode where

-- instance Apply PHPCode where

instance Primitive PHPCode where
    eq = "(fn ($x) => $x[0] === $x[1])"
    reverseString = "(fn ($x) => strrev($x))"

instance PrimitiveConsole PHPCode where
    outputString = "print"
    inputString = "(function () { $r = fopen('php://stdin', 'r'); $ret = fgets($r); fclose($r); return $ret; })" -- difficult to not miss nullary functions

instance Numeric PHPCode where
    num n = PHPCode $ "(fn () => " <> show n <> ")"
    negate' = "(fn ($x) => -$x)"
    add = "(fn ($x) => $x[0] + $x[1])"
    mult = "(fn ($x) => $x[0] * $x[1])"
    div' = "(fn ($x) => $x[0] / $x[1])"
    mod' = "(fn ($x) => $x[0] % $x[1])"

instance Render (PHPCode a b) where
    render (PHPCode f) = f

runInPHP :: (ToJSON input, FromJSON output) => PHPCode input output -> input -> IO (Maybe output)
runInPHP cat param = decode . BSL.pack . secondOfThree <$> readProcessWithExitCode "php" ["-r", "print(json_encode(" <> render cat <> "(" <> BSL.unpack (encode param) <> ")));"] ""
