-- Shamelessly stolen from the ideas of https://www.youtube.com/watch?v=xZmPuz9m2t0
{-# LANGUAGE Trustworthy, GADTs, LambdaCase, OverloadedLists, OverloadedStrings, QuantifiedConstraints, StandaloneDeriving #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main where

import Prelude hiding ((.), id)
import Control.Arrow (Kleisli(..))
import Control.Category
import Control.Monad
import Control.Monad.Fix
import Data.Aeson
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BSL
-- import Data.Profunctor
import Data.String
import Numeric.Natural
import System.Process
import qualified Data.Yaml as Y

catpow :: Category cat => Natural -> cat a a -> cat a a
catpow 0 _ = error "can't apply a category applicator zero times"
catpow 1 cat = cat
catpow n cat = cat . catpow (n-1) cat -- go?    

class Render a where
    render :: a -> String

class Category cat => Cartesian cat where
    copy :: cat a (a, a)
    consume :: cat a ()
    fst' :: cat (a, b) a
    snd' :: cat (a, b) b

instance Cartesian (->) where
    copy a = (a, a)
    consume _ = ()
    fst' = fst
    snd' = snd


class Category cat => Cocartesian cat where
    injectL :: cat a (Either a b)
    injectR :: cat a (Either b a)
    unify :: cat (Either a a) a
    tag :: cat (Bool, a) (Either a a)

instance Cocartesian (->) where
    injectL = Left
    injectR = Right
    unify = \case
        Left a -> a
        Right a -> a
    tag (False, a) = Left a
    tag (True, a) = Right a

class Numeric cat where
    num :: Int -> cat a Int
    negate' :: cat Int Int
    add :: cat (Int, Int) Int
    mult :: cat (Int, Int) Int
    div' :: cat (Int, Int) Int
    mod' :: cat (Int, Int) Int

instance Numeric (->) where
    num = const
    negate' = negate
    add = uncurry (+)
    mult = uncurry (*)
    div' = uncurry div
    mod' = uncurry mod

class Category cat => Choice cat where
    left' :: cat a b -> cat (Either a x) (Either b x)
    right' :: cat a b -> cat (Either x a) (Either x b)

instance Choice (->) where
    left' f (Left a) = Left (f a)
    left' _ (Right a) = Right a
    right' _ (Left a) = Left a
    right' f (Right a) = Right (f a)


class Category cat => Strong cat where
    first' :: cat a b -> cat (a, c) (b, c)
    second' :: cat b c -> cat (a, b) (a, c)

instance Strong (->) where
    first' f (a, b) = (f a, b)
    second' f (a, b) = (a, f b) 


class Category cat => Symmetric cat where
    swap :: cat (a, b) (b, a)
    swapEither :: cat (Either a b) (Either b a)
    reassoc :: cat (a, (b, c)) ((a, b), c)
    reassocEither :: cat (Either a (Either b c)) (Either (Either a b) c)

instance Symmetric (->) where
    swap (a, b) = (b, a)
    swapEither (Left a) = Right a
    swapEither (Right a) = Left a
    reassoc (a, (b, c)) = ((a, b), c)
    reassocEither (Left a) = Left (Left a)
    reassocEither (Right (Left b)) = Left (Right b)
    reassocEither (Right (Right c)) = Right c


class Category cat => Cochoice cat where
    unleft :: cat (Either a c) (Either b c) -> cat a b

instance Cochoice (->) where
    unleft :: forall a b c. (Either a c -> Either b c) -> a -> b
    unleft f a = case f (Left a) of
        Left b -> b
        Right c -> goRight c where
            goRight :: c -> b
            goRight c' = case f (Right c') of
                Left b -> b
                Right c'' -> goRight c''


class Category cat => Costrong cat where
    unfirst :: cat (a, c) (b, c) -> cat a b

-- Like Costrong or ArrowLoop
instance Costrong (->) where
    unfirst :: ((a, c) -> (b, c)) -> a -> b
    unfirst f a = let (b, c) = f (a, c) in b


class Category cat => Apply cat where
    app :: cat (cat a b, a) b

instance Apply (->) where
    app (f, x) = f x


class Category cat => Currier cat where
    curry' :: cat (cat (a, b) c) (cat a (cat b c))
    uncurry' :: cat (cat a (cat b c)) (cat (a, b) c)

instance Currier (->) where
    curry' = curry
    uncurry' = uncurry


class Category cat => PrimitiveCurried cat where
    eqCurried :: Eq a => cat a (cat a Bool)

instance PrimitiveCurried (->) where
    eqCurried = (==)


class Category cat => Primitive cat where
    eq :: Eq a => cat (a, a) Bool
    reverseString :: cat String String

instance Primitive (->) where
    eq = uncurry (==)
    reverseString = reverse


instance Monad m => Primitive (Kleisli m) where
    eq = Kleisli (pure . eq)
    reverseString = Kleisli (pure . reverseString)

class Category cat => PrimitiveConsole cat where
    outputString :: cat String ()
    inputString :: cat () String
    --konst :: b -> cat a b

instance PrimitiveConsole (Kleisli IO) where
    outputString = Kleisli putStrLn
    inputString = Kleisli (const getLine)

instance Monad m => Cartesian (Kleisli m) where
    copy = Kleisli $ pure . copy
    consume = Kleisli $ pure . consume
    fst' = Kleisli $ pure . fst'
    snd' = Kleisli $ pure . snd'

instance Monad m => Cocartesian (Kleisli m) where
    injectL = Kleisli $ pure . injectL
    injectR = Kleisli $ pure . injectR
    unify = Kleisli $ pure . unify
    tag = Kleisli $ pure . tag

instance Monad m => Strong (Kleisli m) where
    first' (Kleisli f) = Kleisli $ (\(a, c) -> (,c) <$> f a)
    second' (Kleisli f) = Kleisli $ (\(a, b) -> (a,) <$> f b)

-- I don't really understand this..
instance MonadFix m => Costrong (Kleisli m) where
  unfirst (Kleisli f) = Kleisli (liftM fst . mfix . f')
    where f' x y = f (x, snd y)

instance Monad m => Apply (Kleisli m) where
    app = Kleisli (\(Kleisli f, x) -> f x)

-- instance Monad m => Choice (Kleisli m) where
    
-- instance Monad m => Cochoice (Kleisli m) where

data HSLamb a b = HSLamb String
    deriving (Eq, Show)

-- instance Profunctor HSLamb where
--     dimap :: (a -> b) -> (c -> d) -> HSLamb b c -> HSLamb a d
--     dimap contra cova (HSLamb f) = HSLamb $ "(\\x -> )"

instance IsString (HSLamb a b) where
    fromString = HSLamb

instance Category HSLamb where
    id = "(\\x -> x)"
    HSLamb a . HSLamb b = HSLamb $ "(\\x -> " <> a <> " ( " <> b <> " x))" -- f . g = f (g x), not g (f x)

instance Cartesian HSLamb where
    copy = "(\\x -> (x, x))"
    consume = "(\\x -> ())"
    fst' = "(\\(x, _) -> x)"
    snd' = "(\\(_, y) -> y)"

instance Cocartesian HSLamb where
    injectL = "Left"
    injectR = "Right"
    unify = "(\\case { Left a -> a; Right a -> a; })"
    tag = "(\\case { (False, a) -> Left a; (True, a) -> Right a; })"

instance Strong HSLamb where
    first' (HSLamb f) = HSLamb $ "(\\(x, y) -> (" <> f <> " x, y))"
    second' (HSLamb f) = HSLamb $ "(\\(x, y) -> (x, " <> f <> " y))"

instance Choice HSLamb where
    left' (HSLamb f) = HSLamb $ "(\\case { Left a -> Left (" <> f <> " a); Right a -> Right a; })"
    right' (HSLamb f) = HSLamb $ "(\\case { Left a -> Left a; Right a -> Right (" <> f <> " a); })"

-- instance Symmetric HSLamb where

-- instance Cochoice HSLamb where

-- instance Costrong HSLamb where

-- instance Apply HSLamb where

instance Primitive HSLamb where
    eq = "(arr (\\(x, y) -> x == y))"
    reverseString = "(arr reverse)"

instance PrimitiveConsole HSLamb where
    outputString = "(Kleisli putStrLn)"
    inputString = "_TODO"

instance Numeric HSLamb where
    num n = HSLamb $ "(\\_ -> " <> show n <> ")"
    negate' = "negate"
    add = "(\\(x, y) -> x + y)"
    mult = "(\\(x, y) -> x * y)"
    div' = "(\\(x, y) -> div x y)"
    mod' = "(\\(x, y) -> mod x y)"


instance Render (HSLamb a b) where
    render (HSLamb f) = f


data HSCode a b = HSCode String
    deriving (Eq, Show)

instance IsString (HSCode a b) where
    fromString = HSCode

instance Category HSCode where
    id = "id"
    HSCode a . HSCode b = HSCode $ "(" <> a <> " . " <> b <> ")"

instance Cartesian HSCode where
    copy = "(\\x -> (x, x))"
    consume = "(const ())"
    fst' = "fst"
    snd' = "snd"

instance Cocartesian HSCode where
    injectL = "Left"
    injectR = "Right"
    unify = "(\\case { Left a -> a; Right a -> a; })"
    tag = "(\\case { (False, a) -> Left a; (True, a) -> Right a; })"

instance Strong HSCode where
    first' (HSCode f) = HSCode $ "(Data.Bifunctor.first " <> f <> ")"
    second' (HSCode f) = HSCode $ "(Data.Bifunctor.second " <> f <> ")"

instance Choice HSCode where
    left' (HSCode f) = HSCode $ "(\\case { Left a -> Left (" <> f <> " a); Right a -> Right a; })"
    right' (HSCode f) = HSCode $ "(\\case { Left a -> Left a; Right a -> Right (" <> f <> " a); })"

-- instance Symmetric HSCode where

-- instance Cochoice HSCode where

-- instance Costrong HSCode where

-- instance Apply HSCode where

instance Primitive HSCode where
    eq = "(arr . uncurry $ (==))"
    reverseString = "(arr reverse)"

instance PrimitiveConsole HSCode where
    outputString = "(Kleisli putStrLn)"
    inputString = "(Kleisli (const getLine))"

instance Numeric HSCode where
    num n = HSCode $ "(const " <> show n <> ")"
    negate' = "negate"
    add = "(uncurry (+))"
    mult = "(uncurry (*))"
    div' = "(uncurry div)"
    mod' = "(uncurry mod)"


instance Render (HSCode a b) where
    render (HSCode f) = f


data JSCode a b = JSCode String
    deriving (Eq, Show)

instance IsString (JSCode a b) where
    fromString = JSCode

instance Category JSCode where
    id = "(x => x)"
    JSCode a . JSCode b = JSCode $ "(x => " <> a <> "(" <> b <> "(x)))"

instance Cartesian JSCode where
    copy = "(x => [x, x])"
    consume = "(x => null)"
    fst' = "(([x, _]) => x)"
    snd' = "(([_, y]) => y)"

instance Cocartesian JSCode where
    injectL = "(x => ({tag: 'left', value: x}))"
    injectR = "(x => ({tag: 'right', value: x}))"
    unify = "(x => x.value)"
    tag = "(([b, x]) => ({tag: b ? 'right' : 'left', value: x}))"

instance Strong JSCode where
    first' (JSCode f) = JSCode $ "(([x, y]) => [" <> f <> "(x), y])"
    second' (JSCode f) = JSCode $ "(([x, y]) => [x, " <> f <> "(y)])"

instance Choice JSCode where
    left' (JSCode f) = JSCode $ "(({tag, value}) => ({tag, value: tag === 'left' ? " <> f <> " (value) : value}))"
    right' (JSCode f) = JSCode $ "(({tag, value}) => ({tag, value: tag === 'right' ? " <> f <> " (value) : value}))"

-- instance Symmetric JSCode where

-- instance Cochoice JSCode where

-- instance Costrong JSCode where

-- instance Apply JSCode where

instance Primitive JSCode where
    eq = "(([x, y]) => x === y)"
    reverseString = "(x => x.split('').reverse().join(''))"

instance PrimitiveConsole JSCode where
    outputString = "console.log"
    inputString = "prompt"

instance Numeric JSCode where
    num n = JSCode $ "(_ => " <> show n <> ")"
    negate' = "(x => -x)"
    add = "(([x, y]) => x + y)"
    mult = "(([x, y]) => x * y)"
    div' = "(([x, y]) => x / y)"
    mod' = "(([x, y]) => x % y)"

instance Render (JSCode a b) where
    render (JSCode f) = f



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

-- newtype Diagram a b = Diagram { toGraph :: State Graph InputOutputLinks }

data FreeFunc p a b where
    Id :: FreeFunc p x x
    Compose :: FreeFunc p y z -> FreeFunc p x y -> FreeFunc p x z
    Copy :: FreeFunc p x (x, x)
    Consume :: FreeFunc p x ()
    First :: FreeFunc p a b -> FreeFunc p (a, x) (b, x)
    Second :: FreeFunc p a b -> FreeFunc p (x, a) (x, b)
    Unfirst :: FreeFunc p (a, x) (b, x) -> FreeFunc p a b
    Fst :: FreeFunc p (a, b) a
    Snd :: FreeFunc p (a, b) b
    InjectL :: FreeFunc p a (Either a b)
    InjectR :: FreeFunc p a (Either b a)
    Left' :: FreeFunc p a b -> FreeFunc p (Either a x) (Either b x)
    Right' :: FreeFunc p a b -> FreeFunc p (Either x a) (Either x b)
    Unleft :: FreeFunc p (Either a x) (Either b x) -> FreeFunc p a b
    Unify :: FreeFunc p (Either a a) a
    Tag :: FreeFunc p (Bool, a) (Either a a)
    Num :: Int -> FreeFunc p a Int
    Negate :: FreeFunc p Int Int
    Add :: FreeFunc p (Int, Int) Int
    Mult :: FreeFunc p (Int, Int) Int
    Div :: FreeFunc p (Int, Int) Int
    Mod :: FreeFunc p (Int, Int) Int
    Lift :: p a b -> FreeFunc p a b

deriving instance (forall a b. Show (p a b)) => Show (FreeFunc p x y)

instance (forall a b. ToJSON (k a b)) => ToJSON (FreeFunc k x y) where
    toJSON Id = String "Id"
    toJSON (Compose f g) = object [ "type" .= String "Compose", "args" .= Array [ toJSON f, toJSON g ] ]
    toJSON Copy = String "Copy"
    toJSON Consume = String "Consume"
    toJSON (First f) = object [ "type" .= String "First", "args" .= Array [ toJSON f ] ]
    toJSON (Second f) = object [ "type" .= String "Second", "args" .= Array [ toJSON f ] ]
    toJSON (Unfirst f) = object [ "type" .= String "Unfirst", "args" .= Array [ toJSON f ] ]
    toJSON Fst = String "Fst"
    toJSON Snd = String "Snd"
    toJSON InjectL = String "InjectL"
    toJSON InjectR = String "InjectR"
    toJSON (Left' f) = object [ "type" .= String "Left'", "args" .= Array [ toJSON f ] ]
    toJSON (Right' f) = object [ "type" .= String "Right'", "args" .= Array [ toJSON f ] ]
    toJSON (Unleft f) = object [ "type" .= String "Unleft'", "args" .= Array [ toJSON f ] ]
    toJSON Unify = String "Unify"
    toJSON Tag = String "Tag"
    toJSON (Num n) = object [ "type" .= String "Num", "args" .= Array [ toJSON n ] ]
    toJSON Negate = String "Negate"
    toJSON Add = String "Add"
    toJSON Mult = String "Add"
    toJSON Div = String "Div"
    toJSON Mod = String "Mod"
    toJSON (Lift f) = object [ "type" .= String "Lift", "args" .= Array [ toJSON f ] ]

instance Category (FreeFunc p) where
    id = Id
    (.) = Compose

instance Cartesian (FreeFunc p) where
    copy = Copy
    consume = Consume
    fst' = Fst
    snd' = Snd

instance Strong (FreeFunc p) where
    first' = First
    second' = Second

instance Costrong (FreeFunc p) where
    unfirst = Unfirst

instance Cocartesian (FreeFunc p) where
    injectL = InjectL
    injectR = InjectR
    unify = Unify
    tag = Tag

instance Choice (FreeFunc p) where
    left' = Left'
    right' = Right'

instance Cochoice (FreeFunc p) where
    unleft = Unleft

-- instance Symmetric (FreeFunc p) where

instance Numeric (FreeFunc p) where
    num = Num
    negate' = Negate
    add = Add
    mult = Mult
    div' = Div
    mod' = Mod

data Prims a b where
    ReverseString :: Prims String String
    Equal :: Eq a => Prims (a, a) Bool

deriving instance Show (Prims a b)

instance ToJSON (Prims a b) where
    toJSON ReverseString = String "ReverseString"
    toJSON Equal = String "Equal"

instance Primitive (FreeFunc Prims) where
    reverseString = Lift ReverseString
    eq = Lift Equal

data PrimsConsole a b where
    OutputString :: PrimsConsole String ()
    InputString :: PrimsConsole () String

instance PrimitiveConsole (FreeFunc PrimsConsole) where
    outputString = Lift OutputString
    inputString = Lift InputString

data PrimsFile a b where
    WriteFile :: PrimsFile (String, String) ()
    ReadFile :: PrimsFile String String


-- >>> (>>>) :: 

(***) :: Strong cat => cat a b -> cat c d -> cat (a, c) (b, d)
f *** g = second' g . first' f

(&&&) :: (Cartesian cat, Strong cat) => cat a b -> cat a c -> cat a (b, c)
f &&& g = (f *** g) . copy

(+++) :: Choice cat => cat a b -> cat c d -> cat (Either a c) (Either b d)
f +++ g = right' g . left' f

strong :: (Cartesian cat, Strong cat) => cat (a, b) r -> cat a b -> cat a r
strong f x = f . second' x . copy

matchOn :: (Cartesian cat, Strong cat, Cocartesian cat) => cat a Bool -> cat a (Either a a)
matchOn predicate = tag . first' predicate . copy


isEven :: forall cat. (Numeric cat, Cartesian cat, Strong cat, Primitive cat) => cat Int Bool
isEven = strong eq (num 0) . mod2 where
    mod2 :: cat Int Int
    mod2 = strong mod' (num 2)


isPalindrome :: (Cartesian cat, Strong cat, Primitive cat) => cat String Bool
isPalindrome = eq . first' reverseString . copy

collatzStep :: forall cat. (Numeric cat, Cartesian cat, Cocartesian cat, Choice cat, Strong cat, Primitive cat) => cat Int Int
collatzStep = unify . (onOdds +++ onEvens) . matchOn isEven where
    onOdds :: cat Int Int
    onOdds = strong add (num 1) . strong mult (num 3)

    onEvens :: cat Int Int
    onEvens = strong div' (num 2)

revInputProgram :: (PrimitiveConsole cat, Primitive cat) => cat () ()
revInputProgram = outputString . reverseString . inputString

secondOfThree :: (a, b, c) -> b
secondOfThree (_, b, _) = b

runInGHCiParamC :: (Show input, Read output) => HSCode input output -> input -> IO output
runInGHCiParamC cat param = read . secondOfThree <$> readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", render cat <> " " <> show param] ""

runInGHCiParamL :: (Show input, Read output) => HSLamb input output -> input -> IO output
runInGHCiParamL cat param = read . secondOfThree <$> readProcessWithExitCode "ghci" ["-e", ":set -XLambdaCase", "-e", "import Control.Arrow", "-e", render cat <> " " <> show param] ""

runInNode :: (ToJSON input, FromJSON output) => JSCode input output -> input -> IO (Maybe output)
runInNode cat param = decode . BSL.pack . secondOfThree <$> readProcessWithExitCode "node" ["-e", "console.log(JSON.stringify(" <> render cat <> "(" <> BSL.unpack (encode param) <> ")))"] ""

runInPHP :: (ToJSON input, FromJSON output) => PHPCode input output -> input -> IO (Maybe output)
runInPHP cat param = decode . BSL.pack . secondOfThree <$> readProcessWithExitCode "php" ["-r", "print(json_encode(" <> render cat <> "(" <> BSL.unpack (encode param) <> ")));"] ""

{-
debugTest :: forall a b cat runnerCat. String -> cat a b -> [(String, runnerCat a b -> a -> b)] -> [a] -> IO ()
debugTest name fn runners cases = do
    putStrLn name
    mapM_ (\(runnerName, runner) -> do
        putStrLn $ runnerName <> ": " <> render (fn :: runnerCat a b)
        putStrLn $ runnerName <> " (Running): " <> show $ traverse (runner fn) cases
        ) runners
-}

main :: IO ()
main = do
    putStrLn "isPalindrome"
    putStrLn $ "HSLamb: " <> render (isPalindrome :: HSLamb String Bool)
    floopyHSL <- runInGHCiParamL isPalindrome "floopy"
    abobaHSL <- runInGHCiParamL isPalindrome "aboba"
    putStrLn $ "HSLamb (GHCi): " <> show floopyHSL
    putStrLn $ "HSLamb (GHCi): " <> show abobaHSL
    putStrLn $ "HSCode: " <> render (isPalindrome :: HSCode String Bool)
    floopyHSC <- runInGHCiParamC isPalindrome "floopy"
    abobaHSC <- runInGHCiParamC isPalindrome "aboba"
    putStrLn $ "HSCode (GHCi): " <> show floopyHSC
    putStrLn $ "HSCode (GHCi): " <> show abobaHSC
    putStrLn $ "JSCode: " <> render (isPalindrome :: JSCode String Bool)
    floopyNode <- runInNode isPalindrome "floopy" :: IO (Maybe Bool)
    abobaNode <- runInNode isPalindrome "aboba" :: IO (Maybe Bool)
    putStrLn $ "JSCode (Node, floopy): " <> show (floopyNode)
    putStrLn $ "JSCode (Node, aboba): " <> show (abobaNode)
    putStrLn $ "PHPCode: " <> render (isPalindrome :: PHPCode String Bool)
    floopyPHP <- runInPHP isPalindrome "floopy" :: IO (Maybe Bool)
    abobaPHP <- runInPHP isPalindrome "aboba" :: IO (Maybe Bool)
    putStrLn $ "PHPCode (PHP, floopy): " <> show (floopyPHP)
    putStrLn $ "PHPCode (PHP, aboba): " <> show (abobaPHP)
    putStrLn $ "FreeFunc: " <> show (isPalindrome :: FreeFunc Prims String Bool)
    putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (isPalindrome :: FreeFunc Prims String Bool))
    putStrLn $ "FreeFunc (YAML encoded): " <> (BS.unpack $ Y.encode (isPalindrome :: FreeFunc Prims String Bool))
    putStrLn $ "Execute on (free): " <> show (isPalindrome "floopy")
    putStrLn $ "Execute on (evilolive): " <> show (isPalindrome "aboba")
    putStrLn ""
    putStrLn "collatzStep"
    putStrLn $ "HSLamb: " <> render (collatzStep :: HSLamb Int Int)
    hsl5 <- runInGHCiParamL collatzStep 5
    hsl4 <- runInGHCiParamL collatzStep 4
    putStrLn $ "HSLamb (GHCi, 5): " <> show hsl5
    putStrLn $ "HSLamb (GHCi, 4): " <> show hsl4
    putStrLn $ "HSCode: " <> render (collatzStep :: HSCode Int Int)
    hsc5 <- runInGHCiParamC collatzStep 5
    hsc4 <- runInGHCiParamC collatzStep 4
    putStrLn $ "HSCode (GHCi, 5): " <> show hsc5
    putStrLn $ "HSCode (GHCi, 4): " <> show hsc4
    putStrLn $ "JSCode: " <> render (collatzStep :: JSCode Int Int)
    node5 <- runInNode collatzStep 5
    node4 <- runInNode collatzStep 4
    putStrLn $ "JSCode (Node, 5): " <> show (node5)
    putStrLn $ "JSCode (Node, 4): " <> show (node4)
    putStrLn $ "PHPCode: " <> render (collatzStep :: PHPCode Int Int)
    php5 <- runInPHP collatzStep 5
    php4 <- runInPHP collatzStep 4
    putStrLn $ "PHPCode (PHP, 5): " <> show (php5)
    putStrLn $ "PHPCode (PHP, 4): " <> show (php4)
    putStrLn $ "FreeFunc: " <> show (collatzStep :: FreeFunc Prims Int Int)
    putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (collatzStep :: FreeFunc Prims Int Int))
    putStrLn $ "FreeFunc (YAML encoded): " <> (BS.unpack $ Y.encode (collatzStep :: FreeFunc Prims Int Int))
    putStrLn $ "Execute on 3: " <> show (collatzStep 3)
    putStrLn $ "Execute on 4: " <> show (collatzStep 4)
    putStrLn ""
    putStrLn "revInputProgram" -- @TODO use a different type?
    -- putStrLn $ "HSLamb: " <> render (revInputProgram :: HSLamb () ()) -- @TODO fix
    -- runInGHCiParamL revInputProgram ()
    putStrLn $ "HSCode: " <> render (revInputProgram :: HSCode () ())
    -- runInGHCiParamC revInputProgram ()
    putStrLn $ "JSCode: " <> render (revInputProgram :: JSCode () ()) -- we ain't running that as we're in no browser
    putStrLn $ "PHPCode: " <> render (revInputProgram :: PHPCode () ())
    -- runInPHP revInputProgram ()
    -- putStrLn $ "FreeFunc: " <> show (revInputProgram :: (PrimitiveConsole (FreeFunc p), Primitive (FreeFunc p)) => FreeFunc p () ())
    -- putStrLn $ "FreeFunc (JSON encoded): " <> (BSL.unpack $ encode (revInputProgram :: FreeFunc p () ()))
    putStrLn $ "Executing using runKleisli."
    runKleisli revInputProgram ()