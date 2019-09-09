{-# LANGUAGE DeriveAnyClass, DeriveGeneric, OverloadedStrings #-}

-- Order me a pizza
import Control.Monad.IO.Class
import Data.Aeson
import Data.Aeson.Encode.Pretty
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BSL
import Data.Char
import Data.Function
import Data.Functor
import Data.List
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as T
import GHC.Generics
import qualified Network.HTTP.Client as HC
import Network.HTTP.Req
import System.Environment

data Login = Login {
    email :: String,
    password :: String
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

uriGetLogin = https "www.dominos.co.uk" /: "user" /: "login"
uriPostLogin = https "www.dominos.co.uk" /: "Account" /: "Login"
uriProcessLogin = https "www.dominos.co.uk" /: "Account" /: "ProcessLogin"
uriBasketInfo = https "www.dominos.co.uk" /: "BasketDetails" /: "BasketInfo"
uriNav = https "www.dominos.co.uk" /: "Navigation" /: "GetNavigationInfo"
uriDeals = https "www.dominos.co.uk" /: "Deals" /: "StoreDealGroups"
uriBasket = https "www.dominos.co.uk" /: "basketdetails" /: "show"
uriGetBasket = https "www.dominos.co.uk" /: "CheckoutBasket" /: "GetBasket"

ua = "Firefox/100"

main :: IO ()
main = do
    [email, password] <- sequence $ getEnv <$> ["DOMINOS_EMAIL", "DOMINOS_PASSWORD"]
    res <- runReq defaultHttpConfig $ do
        resPage <- req GET uriGetLogin NoReqBody bsResponse (
            header "User-Agent" ua
            )
        let jar = responseCookieJar resPage
        let xsrfToken = HC.cookie_value . fromJust $ find (("XSRF-TOKEN" ==) . HC.cookie_name) $ HC.destroyCookieJar jar
        resLogin <- req POST
            uriPostLogin
            (
                ReqBodyJson (
                    Login email password
                )
            )
            jsonResponse
            (
                header "X-Requested-With" "XMLHttpRequest" <>
                header "X-XSRF-TOKEN" xsrfToken <>
                header "User-Agent" ua <>
                header "Referer" (BS.pack . show $ uriGetLogin) <>
                cookieJar jar
            )
        let response = responseBody resLogin
        let loggedInJar = responseCookieJar resLogin
        let loggedInXsrfToken = HC.cookie_value . fromJust $ find (("XSRF-TOKEN" ==) . HC.cookie_name) $ HC.destroyCookieJar loggedInJar
        let stateObject = fromJust . _data $ response

        resProcess <- req POST
            uriProcessLogin
            (
                ReqBodyJson (
                    stateObject
                )
            )
            ignoreResponse
            (
                header "X-Requested-With" "XMLHttpRequest" <>
                header "X-XSRF-TOKEN" xsrfToken <>
                header "User-Agent" ua <>
                header "Referer" (BS.pack . show $ uriGetLogin) <>
                cookieJar loggedInJar
            )
        let processedJar = responseCookieJar resProcess

        resBasket <- req GET uriBasket NoReqBody bsResponse (
            cookieJar processedJar
            )
        let basketJar = responseCookieJar resBasket
        let basketXsrfToken = HC.cookie_value . fromJust $ find (("XSRF-TOKEN" ==) . HC.cookie_name) $ HC.destroyCookieJar loggedInJar

        resGetBasket <- req GET uriGetBasket NoReqBody ignoreResponse (
            queryParam "noCache" (Just ("67512637912536197" :: String)) <>
            header "X-Requested-With" "XMLHttpRequest" <>
            header "User-Agent" ua <>
            header "X-XSRF-TOKEN" basketXsrfToken <>
            header "Referer" "https://www.dominos.co.uk/basketdetails/show" <>
            cookieJar basketJar 
            )
        --liftIO . print $ (responseBody resGetBasket :: GetBasketResponse)

        resBasketInfo <- req GET uriBasketInfo NoReqBody ignoreResponse (
            cookieJar basketJar <>
            header "X-Requested-With" "XMLHttpRequest" <>
            header "User-Agent" ua <>
            header "Referer" "https://www.dominos.co.uk/basketdetails/show" <>
            header "X-XSRF-TOKEN" basketXsrfToken
            )
        --liftIO . print $ (responseBody resBasketInfo :: BasketInfoResponse)

        resNav <- req GET uriNav NoReqBody jsonResponse (
            cookieJar basketJar <>
            header "X-Requested-With" "XMLHttpRequest" <>
            header "User-Agent" ua <>
            header "Referer" "https://www.dominos.co.uk/basketdetails/show" <>
            header "X-XSRF-TOKEN" basketXsrfToken
            )
        let navResponse = responseBody resNav :: NavResponse
        liftIO . putStrLn $ "Hello " ++ (userName navResponse) ++ ", your local store seems to be " ++ (storeName navResponse)

        {-resDeals <- req GET uriDeals NoReqBody jsonResponse (
            queryParam "dealsVersion" (Just ("637036279849230000" :: String)) <>
            queryParam "fulfilmentMethod" (Just ("1" :: String)) <>
            queryParam "isoCode" (Just ("en-GB" :: String)) <>
            queryParam "storeId" (Just ("29001" :: String)) <>
            queryParam "v" (Just ("65.1.0.11098" :: String))
            )
        liftIO . BSL.putStrLn . encodePretty $ (responseBody resDeals :: Value)-}
        
    return ()