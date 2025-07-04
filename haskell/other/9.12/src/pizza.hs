{-# LANGUAGE DerivingVia    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Trustworthy       #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-incomplete-uni-patterns #-}

module Main (main) where

-- Order me a pizza
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Except
import Data.Aeson
-- import Data.Aeson.Encode.Pretty
-- import Data.Aeson.Types
import Data.ByteString.Char8          qualified as BS
-- import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Char
-- import Data.Function
-- import Data.Functor
-- import Data.HashMap.Lazy qualified as HM
import Data.List
import Data.Maybe
-- import Data.Text (Text)
-- import Data.Text qualified as T
-- import Data.Vector qualified as V
import GHC.Generics
import Network.HTTP.Client            qualified as HC
import Network.HTTP.Req
import System.Environment
import Text.PrettyPrint.GenericPretty

type Email = String
type Password = String

data Login = Login {
    email    :: Email,
    password :: Password
}
    deriving stock (Eq, Generic, Show)
    deriving (FromJSON, ToJSON) via Generically Login

data LoginResponse = LoginResponse {
    _data        :: Maybe LoginResponseData,
    _errorCode   :: Int,
    _success     :: Bool,
    _message     :: Maybe String,
    _redirectUri :: Maybe String
} deriving stock (Eq, Generic, Show)

instance FromJSON LoginResponse where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = \(_:f:fs) -> toUpper f : fs}

newtype LoginResponseData = LoginResponseData {
    stateId :: String
}
    deriving stock (Eq, Generic, Show)
    deriving (ToJSON) via Generically LoginResponseData

instance FromJSON LoginResponseData where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = \(f:fs) -> toUpper f : fs}

data GetBasketResponse = GetBasketResponse {
    storeId                         :: Int,
    displayTotalPrice               :: String,
    canChangeFulfilmentMethod       :: Bool,
    unqualifiedVouchers             :: [String],
    items                           :: [String],
    isDelivery                      :: Bool,
    proceedUrl                      :: String,
    displaySubTotalPrice            :: String,
    information                     :: String,
    displayOriginalTotalPrice       :: String,
    displayTotalSaving              :: String,
    isRealTimeMealDealWizardEnabled :: Bool,
    displayDeliveryChargeAmount     :: String,
    minimumOrderValue               :: Float
}
    deriving stock (Eq, Generic, Show)
    deriving (FromJSON) via Generically GetBasketResponse

data BasketInfoResponse = BasketInfoResponse {
    totalPrice  :: Float,
    -- storeId :: Int, -- exists but clash
    basketItems :: [String]
} deriving stock (Eq, Generic, Show)

instance FromJSON BasketInfoResponse where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = \(f:fs) -> toUpper f : fs}

data NavResponse = NavResponse {
    siteImage                             :: String,
    canRenderBasket                       :: Bool,
    noNotificationsAvailableForInitalLoad :: Bool, -- yes, misspelled
    fulfilmentRedirectUrl                 :: String,
    sessionIdentifier                     :: String,
    bigDipUpsellOverlayEnabled            :: Bool,
    storeName                             :: String,
    hasStoreInfo                          :: Bool,
    formattedPrice                        :: String,
    deliveryCharge                        :: String,
    userName                              :: String,
    basketUrl                             :: String,
    fulfilmentMethod                      :: String,
    homeUrl                               :: String,
    isLoggedIn                            :: Bool,
    pageType                              :: String
}
    deriving stock (Eq, Generic, Show)
    deriving (FromJSON) via Generically NavResponse

data Step = Step {
    imageUrl    :: String,
    description :: String
}
    deriving stock (Eq, Generic, Show)
    deriving (FromJSON) via Generically Step

instance Out Step

data DealsDealsResponse = DealsDealsResponse {
    displayOrder     :: Int,
    steps            :: [Step],
    isValid          :: Bool,
    -- imageUrl :: String,
    -- name :: String,
    -- id :: Int,
    -- description :: String,
    feedsPeopleCount :: Int
}
    deriving stock (Eq, Generic, Show)
    deriving (FromJSON) via Generically DealsDealsResponse

instance Out DealsDealsResponse

data StoreDealsResponse = StoreDealsResponse {
    -- displayOrder :: Int,
    deals        :: [DealsDealsResponse],
    topDealSteps :: Int,
    -- imageUrl :: String,
    name         :: String,
    -- isGroup :: Bool,
    id           :: Int
    -- description :: String
}
    deriving stock (Eq, Generic, Show)
    deriving (FromJSON) via Generically StoreDealsResponse

instance Out StoreDealsResponse

newtype DealsResponse = DealsResponse {
    storeDeals :: [StoreDealsResponse]
}
    deriving stock (Eq, Generic, Show)
    deriving (FromJSON) via Generically DealsResponse

instance Out DealsResponse

host ∷ Url 'Https
host = https "www.dominos.co.uk"

uriGetLogin, uriPostLogin, uriProcessLogin, uriNav, uriBasket ∷ Url 'Https
uriGetLogin = host /: "user" /: "login"
uriPostLogin = host /: "Account" /: "Login"
uriProcessLogin = host /: "Account" /: "ProcessLogin"
-- uriBasketInfo = host /: "BasketDetails" /: "BasketInfo"
uriNav = host /: "Navigation" /: "GetNavigationInfo"
-- uriDeals = host /: "Deals" /: "StoreDealGroups"
uriBasket = host /: "basketdetails" /: "show"
-- uriGetBasket = host /: "CheckoutBasket" /: "GetBasket"

ua ∷ BS.ByteString
ua = "Firefox/100"

uaHeader, xhrHeader, defaultHeaders ∷ Option scheme
uaHeader = header "User-Agent" ua
xhrHeader = header "X-Requested-With" "XMLHttpRequest"

defaultHeaders = uaHeader <> xhrHeader

type Token = BS.ByteString

getXsrfToken ∷ HC.CookieJar → Token
getXsrfToken cj = (HC.cookie_value . fromJust) . find (("XSRF-TOKEN" ==) . HC.cookie_name) $ HC.destroyCookieJar cj

getHomepage ∷ MonadHttp m ⇒ m (HC.CookieJar, Token)
getHomepage = do
    resPage <- req GET uriGetLogin NoReqBody bsResponse uaHeader
    let jar = responseCookieJar resPage
    let token = getXsrfToken jar
    pure (jar, token)

login ∷ MonadHttp m ⇒ Email → Password → Token → HC.CookieJar → m (HC.CookieJar, Token, LoginResponseData)
login sEmail sPassword xsrfToken jar = do
    resLogin <- req POST uriPostLogin (ReqBodyJson (Login sEmail sPassword)) jsonResponse
        (
            defaultHeaders <>
            header "X-XSRF-TOKEN" xsrfToken <>
            header "Referer" (BS.pack . show $ uriGetLogin) <>
            cookieJar jar
        )
    let response = responseBody resLogin
    let loggedInJar = responseCookieJar resLogin
    let loggedInXsrfToken = getXsrfToken loggedInJar
    let stateObject = fromJust . _data $ response
    pure (loggedInJar, loggedInXsrfToken, stateObject)


processLogin ∷ MonadHttp m ⇒ LoginResponseData → Token → HC.CookieJar → m HC.CookieJar
processLogin stateObject xsrfToken loggedInJar = do
    resProcess <- req POST uriProcessLogin (ReqBodyJson stateObject) ignoreResponse
        (
            defaultHeaders <>
            header "X-XSRF-TOKEN" xsrfToken <>
            header "Referer" (BS.pack . show $ uriGetLogin) <>
            cookieJar loggedInJar
        )
    pure $ responseCookieJar resProcess

basket ∷ MonadHttp m ⇒ HC.CookieJar → m (HC.CookieJar, Token)
basket processedJar = do
    resBasket <- req GET uriBasket NoReqBody bsResponse (cookieJar processedJar)
    let basketJar = responseCookieJar resBasket
    let basketXsrfToken = getXsrfToken basketJar
    pure (basketJar, basketXsrfToken)

createDefaultHeaders ∷ HC.CookieJar → Token → Option 'Https
createDefaultHeaders basketJar basketXsrfToken = defaultHeaders <>
    header "X-XSRF-TOKEN" basketXsrfToken <>
    header "Referer" "https://www.dominos.co.uk/basketdetails/show" <>
    cookieJar basketJar

-- This 'Https is from DataKinds
{-
getBasket :: MonadHttp m => Option 'Https -> m IgnoreResponse
getBasket newDefaultHeaders = req GET uriGetBasket NoReqBody ignoreResponse (
    queryParam "noCache" (Just ("67512637912536197" :: String)) <>
    newDefaultHeaders
    )
-}

{-
basketInfo :: MonadHttp m => Option 'Https -> m IgnoreResponse
basketInfo newDefaultHeaders = req GET uriBasketInfo NoReqBody ignoreResponse newDefaultHeaders
-}

{-}
dealsInfo :: MonadHttp m => m (JsonResponse [DealsResponse])
dealsInfo = req GET uriDeals NoReqBody jsonResponse (
    queryParam "dealsVersion" (Just ("637036279849230000" :: String)) <>
    queryParam "fulfilmentMethod" (Just ("1" :: String)) <>
    queryParam "isoCode" (Just ("en-GB" :: String)) <>
    queryParam "storeId" (Just ("29001" :: String)) <>
    queryParam "v" (Just ("65.1.0.11098" :: String))
    )
-}

nav ∷ MonadHttp m ⇒ Option 'Https → m (JsonResponse NavResponse)
nav = req GET uriNav NoReqBody jsonResponse

greet ∷ MonadHttp m ⇒ JsonResponse NavResponse → m ()
greet resNav = do
    let navResponse = responseBody resNav
    liftIO . putStrLn $ "Hello " <> (userName navResponse <> (", your local store seems to be " <> storeName navResponse))

-- debugJSON :: MonadHttp m => JsonResponse Value -> m ()
-- debugJSON = liftIO . BSL.putStrLn . encodePretty . responseBody

-- debug :: MonadHttp m => (FromJSON a, Show a) => JsonResponse a -> m ()
-- debug = liftIO . print . responseBody

-- debugPP :: MonadHttp m => (FromJSON a, Out a) => JsonResponse a -> m ()
-- debugPP = liftIO . pp . responseBody

-- valueToObject :: Value -> Object
-- valueToObject (Object a) = a

-- valueToArray :: Value -> Array
-- valueToArray (Array a) = a

reqMain ∷ MonadHttp m ⇒ Email → Password → m ()
reqMain sEmail sPassword = do
    (jar, xsrfToken) <- getHomepage
    (loggedInJar, _, stateObject) <- login sEmail sPassword xsrfToken jar
    processedJar <- processLogin stateObject xsrfToken loggedInJar
    (basketJar, basketXsrfToken) <- basket processedJar
    let newDefaultHeaders = createDefaultHeaders basketJar basketXsrfToken
    -- resGetBasket <- getBasket newDefaultHeaders
    -- resBasketInfo <- basketInfo newDefaultHeaders
    resNav <- nav newDefaultHeaders

    greet resNav
    -- resDeals <- dealsInfo
    -- debugPP resDeals
main ∷ IO ()
main = void . runExceptT $ catchError (
    do
        [sEmail, sPassword] <- liftIO (traverse getEnv ["DOMINOS_EMAIL", "DOMINOS_PASSWORD"])
        void . liftIO . runReq defaultHttpConfig $ reqMain sEmail sPassword
    ) (const . liftIO . putStrLn $ "Environment variables not present. Needed: DOMINOS_EMAIL, DOMINOS_PASSWORD")
