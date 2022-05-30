-- Stolen from https://wiki.haskell.org/Internationalization_of_Haskell_programs_using_gettext

import System.Locale.SetLocale
import Text.I18N.GetText
import Text.Printf
{-
run:

mkdir i18n
hgettext -k __ -o i18n/messages.pot src/gettext.hs
msginit --input=i18n/messages.pot --output-file=i18n/en_GB.po --locale=en_GB.UTF-8
msginit --input=i18n/messages.pot --output-file=i18n/en_US.po --locale=en_US.UTF-8
mkdir -p i18n/en_{GB,US}/LC_MESSAGES
msgfmt --output-file=i18n/en_GB/LC_MESSAGES/gettext.mo i18n/en_GB.po
msgfmt --output-file=i18n/en_US/LC_MESSAGES/gettext.mo i18n/en_US.po

-}

main :: IO ()
main = do
    let __ = getText

    _ <- setLocale LC_ALL (Just "")
    _ <- bindTextDomain "gettext" (Just "i18n")
    _ <- textDomain (Just "gettext")

    putStrLn =<< __ "What is your name?"
    putStr "> "
    name <- getLine
    putStrLn . (`printf` name) =<< __ "Hello, %s!"
    putStrLn . printf =<< __ "What is your favourite colour?"
    putStr "> "
    colour <- getLine
    putStrLn . (`printf` colour) =<< __ "I see. So, %s is your favourite colour. Interesting."
    putStrLn . printf =<< __ "And finally, what do you like to do as a hobby?"
    hobby <- getLine
    putStrLn . (`printf` hobby) =<< __ "I get it! You like %s."
    putStrLn . printf =<< __ "That's all! I hope you enjoyed my survey."
