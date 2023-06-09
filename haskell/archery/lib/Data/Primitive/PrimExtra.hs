module Data.Primitive.PrimExtra where

data PrimExtra a b where
    IntToString :: PrimExtra Int String
    ConcatString :: PrimExtra (String, String) String
    ConstString :: String -> PrimExtra a String

instance PrimitiveExtra (FreeFunc PrimExtra) where
    intToString = Lift IntToString
    concatString = Lift ConcatString
    constString s = Lift (ConstString s)

instance ToJSON (PrimExtra a b) where
    toJSON IntToString = String "IntToString"
    toJSON ConcatString = String "ConcatString"
    toJSON (ConstString s) = object [ "type" .= ("ConstString" :: T.Text), "args" .= Array [ String (T.pack s) ] ]

instance FromJSON (PrimExtra Int String) where
    parseJSON (String "IntToString") = pure IntToString
    parseJSON _ = fail "TypeError: expecting Int -> String"

instance FromJSON (PrimExtra (String, String) String) where
    parseJSON (String "ConcatString") = pure ConcatString
    parseJSON _ = fail "TypeError: expecting (String, String) -> String"

instance FromJSON (PrimExtra () String) where
    parseJSON = withObject "PrimExtra" $ \obj -> do
        t <- obj .: "type"
        if (t == ("ConstString" :: T.Text)) then do
            Array [ String s ] <- obj .: "args"
            pure $ ConstString (T.unpack s)
        else fail "TypeError: expected () -> String"

-- instance Interpret PrimExtra ()