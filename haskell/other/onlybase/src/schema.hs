{-# LANGUAGE GADTs #-}
module Main where

data Yaml
  = String String
  | Object [(String, Yaml)]
  deriving Show

-- Schema indexed by the Haskell type it decodes to
data Schema a where
  SString :: Schema String
  SPair :: Schema a -> Schema b -> Schema (a, b)  -- Intersection of two schemas (if you think of them as describing sets of values)
  SField :: String -> Schema a -> Schema a
  SUnit :: Schema ()  -- Empty schema

-- Reading a schema: the type index of the schema is part of the output
-- of parsing. It is not known at compile-time, so wrap it in an existential type.

data Some f where
  Some :: f a -> Some f

-- Wrappers for the Schema constructors under the existential Some.

sField :: String -> Some Schema -> Some Schema
sField field (Some schema) = Some (SField field schema)

sPair :: Some Schema -> Some Schema -> Some Schema
sPair (Some schema) (Some schema') = Some (SPair schema schema')

-- Read a schema from some configuration file.
readSchema :: Yaml -> Maybe (Some Schema)
readSchema (String "string") = Just (Some SString)
readSchema (Object xs) = foldr addField (Some SUnit) <$> traverse (traverse readSchema) xs
  where
    addField (field, fieldSchema) = sPair (sField field fieldSchema)
readSchema _ = Nothing

-- Decode a value from Yaml according to a given schema.
decode :: Schema a -> Yaml -> Maybe a
decode SUnit _  = Just ()
decode (SPair s s') x = liftA2 (,) (decode s x) (decode s' x)
decode SString (String s) = Just s
decode (SField field s) (Object o) = do
  x <- lookup field o
  decode s x
decode _ _ = Nothing

-- Encode according to a given schema.
-- Note that encoding is partial because there are nonsensical schemas:
-- you can use SPair to require a Yaml value to be both a string and an object.
-- A more careful definition of schemas could avoid that.
encode :: Schema a -> a -> Maybe Yaml
encode SUnit () = Just (Object [])
encode SString x = Just (String x)
encode (SField field s) x = do
  y <- encode s x
  Just (Object [(field, y)])
encode (SPair s s') (x, x') = do
  y <- encode s x
  y' <- encode s' x'
  case (y, y') of
    (Object z, Object z') -> Just (Object (z <> z'))
    _ -> Nothing

-- Again, existential wrapper to store decoded values,
-- because their types are not known at compile-time.
-- We must also store the schema to be able to recover the type.
data SchemaValue where
  SchemaValue :: Schema a -> a -> SchemaValue

-- Existential wrappers for decode and encode.

decodeS :: Some Schema -> Yaml -> Maybe SchemaValue 
decodeS (Some s) x = SchemaValue s <$> decode s x

encodeS :: SchemaValue -> Maybe Yaml 
encodeS (SchemaValue s x) = encode s x

-- Examples

data B = C | D

exampleSchema :: Yaml
exampleSchema = Object [("type", String "string"), ("class", String "string")]

exampleValue :: Yaml
exampleValue = Object [("type", String "Maybe"), ("class", String "Monad")]


main :: IO ()
main = do
    print $ do
        s <- readSchema exampleSchema
        v <- decodeS s exampleValue
        encodeS v

-- Output:
--
-- Just (Object [("type", String "Maybe"), ("class", String "Monad")])