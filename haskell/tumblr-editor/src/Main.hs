{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-record-updates -Wno-unused-top-binds #-}
{- Above is for saying chrome {..} -}

module Main (main) where

import Control.Concurrent
import Control.Monad (void)
import Control.Monad.IO.Class
import Data.Foldable
import Data.Functor.Compose
import Data.Text              (pack, unpack)
import System.Environment
import Test.WebDriver

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

main ∷ IO ()
main = do
    [email, password, _, _, tag, newsource] <- getCompose $ pack <$> Compose getArgs
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
        openPage $ "https://tumblr.com/tagged/" <> unpack tag
        agreeButton <- findElem (ByCSS "button[mode=primary]")
        click agreeButton
        liftIO (threadDelay 500000)
        postElements <- findElems (ByCSS "[data-id]")
        for_ postElements $ \postElement -> do
            -- use then findElemFrom
            editButton <- findElemFrom postElement (ByCSS "[aria-label=\"Edit\"")
            click editButton
            frame <- findElem (ByCSS "iframe[title=\"Post forms\"]")
            focusFrame (WithElement frame)
            settingsButton <- findElem (ByClass "post-settings") -- post-settings
            click settingsButton
            contentSourceBox <- findElem (ById "sourceUrl_input")
            clearInput contentSourceBox
            sendKeys newsource contentSourceBox
            saveButton <- findElem (ByClass "create_post_button")
            void $ findElem (ByCSS "[data-js-clickableclose]")
            click saveButton
            focusFrame DefaultFrame
            liftIO (threadDelay 1000000)
        closeSession
