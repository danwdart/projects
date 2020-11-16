{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax #-}

module Main where


import Control.Monad.IO.Class
import Control.Concurrent
import Data.Functor.Compose
import Data.Text (pack, unpack)
import System.Environment
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
main = do
    [email, password, username, domain, tag, newsource] <- getCompose $ pack <$> Compose getArgs
    runSession firefoxConfig $ do
        setImplicitWait 500000
        openPage "https://tumblr.com"
        login <- findElem (ById "signup_login_button")
        click login
        emailBox <- findElem (ById "signup_determine_email")
        sendKeys email emailBox
        loginButton <- findElem (ById "signup_forms_submit")
        click loginButton
        liftIO (threadDelay 500000)
        passwordButton <- findElem (ByClass "forgot_password_link")
        click passwordButton
        passwordBox <- findElem (ById "signup_password")
        sendKeys password passwordBox
        click loginButton
        liftIO (threadDelay 3000000)
        agreeButton <- findElem (ByCSS "button[mode=primary]")
        click agreeButton
        liftIO (threadDelay 2000000)
        openPage $ "https://tumblr.com/tagged/" <> unpack tag
        -- Get all the posts and then for each post
        -- use then findElemFrom
        editButton <- findElem (ByCSS "[aria-label=\"Edit\"")
        click editButton
        liftIO (threadDelay 5000000)
        settingsButton <- findElem (ByClass "post-form--post-settings-button") -- post-settings
        click settingsButton
        contentSourceBox <- findElem (ById "sourceUrl_input")
        sendKeys newsource contentSourceBox
        saveButton <- findElem (ByClass "create_post_button")
        closeButton <- findElem (ByCSS "[data-js-clickableclose]")
        click saveButton
        liftIO (threadDelay 100000000)
        closeSession
