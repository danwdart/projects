{-# LANGUAGE DataKinds, DeriveAnyClass, DeriveGeneric, OverloadedStrings #-}

-- Order me a pizza
import Control.Monad.IO.Class
import Data.Aeson
import Data.Aeson.Encode.Pretty
import Data.Aeson.Types
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BSL
import Data.Char
import Data.Function
import Data.Functor
-- import qualified Data.HashMap.Lazy as HM
import Data.List
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as T
-- import qualified Data.Vector as V
import GHC.Generics
import qualified Network.HTTP.Client as HC
import Network.HTTP.Req
import System.Environment
import Text.PrettyPrint.GenericPretty

type Email = String
type Password = String

data Login = Login {
    email :: Email,
    password :: Password
} deriving (Eq, FromJSON, Generic, Show, ToJSON)

data LoginResponse = LoginResponse {
    _data :: Maybe LoginResponseData,
    _errorCode :: Int,
    _success :: Bool,
    _message :: Maybe String,
    _redirectUri :: Maybe String
} deriving (Eq, Generic, Show)

instance FromJSON LoginResponse where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = \(_:f:fs) -> toUpper f : fs}

data LoginResponseData = LoginResponseData {
    stateId :: String
} deriving (Eq, Generic, Show, ToJSON)

instance FromJSON LoginResponseData where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = \(f:fs) -> toUpper f : fs}

data GetBasketResponse = GetBasketResponse {
    storeId :: Int,
    displayTotalPrice :: String,
    canChangeFulfilmentMethod :: Bool,
    unqualifiedVouchers :: [String],
    items :: [String],
    isDelivery :: Bool,
    proceedUrl :: String,
    displaySubTotalPrice :: String,
    information :: String,
    displayOriginalTotalPrice :: String,
    displayTotalSaving :: String,
    isRealTimeMealDealWizardEnabled :: Bool,
    displayDeliveryChargeAmount :: String,
    minimumOrderValue :: Float
} deriving (Eq, FromJSON, Generic, Show)

data BasketInfoResponse = BasketInfoResponse {
    totalPrice :: Float,
    -- storeId :: Int, -- exists but clash
    basketItems :: [String]
} deriving (Eq, Generic, Show)

instance FromJSON BasketInfoResponse where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = \(f:fs) -> toUpper f : fs}

data NavResponse = NavResponse {
    siteImage :: String,
    canRenderBasket :: Bool,
    noNotificationsAvailableForInitalLoad :: Bool, -- yes, misspelled
    fulfilmentRedirectUrl :: String,
    sessionIdentifier :: String,
    bigDipUpsellOverlayEnabled :: Bool,
    storeName :: String,
    hasStoreInfo :: Bool,
    formattedPrice :: String,
    deliveryCharge :: String,
    userName :: String,
    basketUrl :: String,
    fulfilmentMethod :: String,
    homeUrl :: String,
    isLoggedIn :: Bool,
    pageType :: String
} deriving (Eq, FromJSON, Generic, Show)

data Step = Step {
    imageUrl :: String,
    description :: String
} deriving (Eq, FromJSON, Generic, Out, Show)

data DealsDealsResponse = DealsDealsResponse {
    displayOrder :: Int,
    steps :: [Step],
    isValid :: Bool,
    -- imageUrl :: String,
    -- name :: String,
    -- id :: Int,
    -- description :: String,
    feedsPeopleCount :: Int
} deriving (Eq, FromJSON, Generic, Out, Show)

data StoreDealsResponse = StoreDealsResponse {
    -- displayOrder :: Int,
    deals :: [DealsDealsResponse],
    topDealSteps :: Int,
    -- imageUrl :: String,
    name :: String,
    -- isGroup :: Bool,
    id :: Int
    -- description :: String
} deriving (Eq, FromJSON, Generic, Out, Show)

data DealsResponse = DealsResponse {
    storeDeals :: [StoreDealsResponse]
} deriving (Eq, FromJSON, Generic, Out, Show)

host = https "www.dominos.co.uk"

uriGetLogin = host /: "user" /: "login"
uriPostLogin = host /: "Account" /: "Login"
uriProcessLogin = host /: "Account" /: "ProcessLogin"
uriBasketInfo = host /: "BasketDetails" /: "BasketInfo"
uriNav = host /: "Navigation" /: "GetNavigationInfo"
uriDeals = host /: "Deals" /: "StoreDealGroups"
uriBasket = host /: "basketdetails" /: "show"
uriGetBasket = host /: "CheckoutBasket" /: "GetBasket"

ua = "Firefox/100"

uaHeader = header "User-Agent" ua
xhrHeader = header "X-Requested-With" "XMLHttpRequest"

defaultHeaders = uaHeader <> xhrHeader

type Token = BS.ByteString

getXsrfToken :: HC.CookieJar -> Token
getXsrfToken cj = HC.cookie_value . fromJust $ find (("XSRF-TOKEN" ==) . HC.cookie_name) $ HC.destroyCookieJar cj

getHomepage :: Req (HC.CookieJar, Token)
getHomepage = do
    resPage <- req GET uriGetLogin NoReqBody bsResponse uaHeader
    let jar = responseCookieJar resPage
    let token = getXsrfToken jar
    return (jar, token)

login :: Email -> Password -> Token -> HC.CookieJar -> Req (HC.CookieJar, Token, LoginResponseData)
login email password xsrfToken jar = do
    resLogin <- req POST uriPostLogin (ReqBodyJson (Login email password)) jsonResponse
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
    return (loggedInJar, loggedInXsrfToken, stateObject)


processLogin :: LoginResponseData -> Token -> HC.CookieJar -> Req HC.CookieJar
processLogin stateObject xsrfToken loggedInJar = do
    resProcess <- req POST uriProcessLogin (ReqBodyJson stateObject) ignoreResponse
        (
            defaultHeaders <>
            header "X-XSRF-TOKEN" xsrfToken <>
            header "Referer" (BS.pack . show $ uriGetLogin) <>
            cookieJar loggedInJar
        )
    return $ responseCookieJar resProcess

basket :: HC.CookieJar -> Req (HC.CookieJar, Token)
basket processedJar = do
    resBasket <- req GET uriBasket NoReqBody bsResponse (cookieJar processedJar)
    let basketJar = responseCookieJar resBasket
    let basketXsrfToken = getXsrfToken basketJar
    return (basketJar, basketXsrfToken)

createDefaultHeaders :: HC.CookieJar -> Token -> Option 'Https
createDefaultHeaders basketJar basketXsrfToken = defaultHeaders <>
    header "X-XSRF-TOKEN" basketXsrfToken <>
    header "Referer" "https://www.dominos.co.uk/basketdetails/show" <>
    cookieJar basketJar 

-- This 'Https is from DataKinds
getBasket :: Option 'Https -> Req IgnoreResponse
getBasket newDefaultHeaders = req GET uriGetBasket NoReqBody ignoreResponse (
    queryParam "noCache" (Just ("67512637912536197" :: String)) <>
    newDefaultHeaders
    )

basketInfo :: Option 'Https -> Req IgnoreResponse
basketInfo newDefaultHeaders = req GET uriBasketInfo NoReqBody ignoreResponse newDefaultHeaders

dealsInfo :: Req (JsonResponse [DealsResponse])
dealsInfo = req GET uriDeals NoReqBody jsonResponse (
    queryParam "dealsVersion" (Just ("637036279849230000" :: String)) <>
    queryParam "fulfilmentMethod" (Just ("1" :: String)) <>
    queryParam "isoCode" (Just ("en-GB" :: String)) <>
    queryParam "storeId" (Just ("29001" :: String)) <>
    queryParam "v" (Just ("65.1.0.11098" :: String))
    )

nav :: Option 'Https -> Req (JsonResponse NavResponse)
nav newDefaultHeaders = req GET uriNav NoReqBody jsonResponse newDefaultHeaders

greet :: JsonResponse NavResponse -> Req ()
greet resNav = do
    let navResponse = responseBody resNav
    liftIO . putStrLn $ "Hello " ++ (userName navResponse) ++ ", your local store seems to be " ++ (storeName navResponse)

debugJSON :: JsonResponse Value -> Req ()
debugJSON = liftIO . BSL.putStrLn . encodePretty . responseBody

debug :: (FromJSON a, Show a) => JsonResponse a -> Req ()
debug = liftIO . print . responseBody

debugPP :: (FromJSON a, Out a) => JsonResponse a -> Req ()
debugPP = liftIO . pp . responseBody

valueToObject :: Value -> Object
valueToObject (Object a) = a

valueToArray :: Value -> Array
valueToArray (Array a) = a

reqMain :: Email -> Password -> Req ()
reqMain email password = do
    (jar, xsrfToken) <- getHomepage
    (loggedInJar, loggedInXsrfToken, stateObject) <- login email password xsrfToken jar
    processedJar <- processLogin stateObject xsrfToken loggedInJar
    (basketJar, basketXsrfToken) <- basket processedJar
    let newDefaultHeaders = createDefaultHeaders basketJar basketXsrfToken
    resGetBasket <- getBasket newDefaultHeaders
    resBasketInfo <- basketInfo newDefaultHeaders
    resNav <- nav newDefaultHeaders

    greet resNav
    -- resDeals <- dealsInfo
    -- debugPP resDeals
main :: IO ()
main = do
    [email, password] <- sequence $ getEnv <$> ["DOMINOS_EMAIL", "DOMINOS_PASSWORD"]
    runReq defaultHttpConfig $ reqMain email password