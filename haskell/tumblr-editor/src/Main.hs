{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax #-}

module Main where


import Control.Monad.IO.Class
import Control.Concurrent
import           Test.WebDriver
import           Test.WebDriver.Class
import Test.WebDriver.Session
import Test.WebDriver.Monad

firefoxConfig ∷ WDConfig
firefoxConfig = defaultConfig {-{
    wdCapabilities = defaultCaps {
        additionalCaps = [
            ("moz:firefoxOptions", object [
                ("args", Array (fromList [String "--headless"]))
            ])
        ]
    }
}-}

chromeConfig ∷ WDConfig
chromeConfig = defaultConfig {
    wdCapabilities = defaultCaps {
        browser = chrome {
            chromeOptions = ["--headless"]
        }
    }
}

-- Run java -jar /usr/share/selenium-server/selenium-server-standalone.jar

main :: IO ()
main = runSession firefoxConfig $ do
    let email = "aaaa"
    let password = "aaa"
    openPage "https://tumblr.com"
    login <- findElem (ById "signup_login_button")
    click login
    emailBox <- findElem (ById "signup_determine_email")
    sendKeys email emailBox
    loginButton <- findElem (ById "signup_forms_submit")
    click loginButton
    passwordButton <- findElem (ById "forgot_password_link")
    click passwordButton
    passwordBox <- findElem (ById "signup_password")
    sendKeys password passwordBox
    click loginButton
    liftIO (threadDelay 10000000)
    {-}
    openPage $ "http://" <> siteName <> ".localhost:" <> show myPort
    getSession
    as <- findElems (ByCSS "a[href^=http]")
    hrefs <- mapM (`attr` "href") as
    as <- findElems (ByCSS "img[src^=http]")
    navbar <- findElem $ ByClass "navbar-nav"
    linkName <- getText linkToClick
    click linkToClick
    cards <- findElems $ ByClass "card"
    -}
    closeSession
