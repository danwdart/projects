{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches -Wno-unused-local-binds #-}

import qualified Data.ByteString.Lazy.Char8       as BSL

import           Control.Monad.IO.Class

import           Data.Char
import           Data.List.Split
import           Data.Ratio

import           JSDOM
import           JSDOM.Document
import           JSDOM.Element                    (setInnerHTML)
import           JSDOM.Types

import           Language.Javascript.JSaddle      hiding ((!))
import           Language.Javascript.JSaddle.Warp

import           Text.Blaze.Html.Renderer.Utf8
import           Text.Blaze.Html5                 as H hiding (main)
import qualified Text.Blaze.Html5                 as H (main)
import           Text.Blaze.Html5.Attributes      as A

myHead ∷ Html
myHead = H.head $ do
    meta ! charset "utf-8"
    link ! rel "stylesheet" ! href "https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
    H.style "\
        \canvas#graph {\
        \    width: 100%;\
        \    height: 200px;\
        \    border: 1px solid black;\
        \}\
        \.form-group:last-of-type {\
        \    margin-bottom: 0;\
        \}\
        \"

scripts ∷ Html
scripts = do
    script ! src "https://code.jquery.com/jquery-3.3.1.slim.min.js" $ mempty
    script ! src "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" $ mempty
    script ! src "https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" $ mempty

myBody ∷ Html
myBody = body ! class_ "bg-dark" $ do
    (H.main ! class_ "container-fluid") . (H.div ! class_ "row") $ (
            H.div ! class_ "col-md-8 my-5 pt-3 pb-2 bg-light offset-md-2" $ do
                h1 "Continued Fraction Expander"
                H.form $ do
                    H.div ! class_ "form-group" $ do
                        H.label ! for "cfe" $ "Enter continued fraction expansion:"
                        input ! type_ "text" ! A.id "cfe" ! class_ "form-control col-md-12" ! placeholder "1;1,1,1,1,1"
                    H.div ! class_ "form-group" $ do
                        H.div "Constants:"
                        button ! type_ "button" ! class_ "btn btn-secondary" ! dataAttribute "cfe" "1;4,1,18,1,1,1,4,1,9,9,2,1,1,1,2,7,1,1" $ "ζ(3)"
                        button ! type_ "button" ! class_ "btn btn-secondary" ! dataAttribute "cfe" "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2" $ "√2"
                        button ! type_ "button" ! class_ "btn btn-secondary" ! dataAttribute "cfe" "1;1,1,3,1,5,1,7,1,9,1,11,1,13,1,15,1,17,1,19,1,21" $ "tan(1)"
                        button ! type_ "button" ! class_ "btn btn-secondary" ! dataAttribute "cfe" "1;1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1" $ "Φ"
                        button ! type_ "button" ! class_ "btn btn-secondary" ! dataAttribute "cfe" "2;1,2,1,1,4,1,1,6,1,1,8,1,1,10,1,1,12,1,1,14,1,1,16,1,1,18" $ "e"
                        button ! type_ "button" ! class_ "btn btn-secondary" ! dataAttribute "cfe" "3;7,15,1,292,1,1,1,2,1,3,1,14,2,1,1,2,2,2,2" $ "π"
                    H.div ! class_ "form-group" $ do
                        H.label ! for "dec" $ "In decimal:"
                        H.div ! A.id "dec" ! class_ "border col-md-12" $ "1"
                    H.div ! class_ "form-group" $ do
                        H.label ! for "frac" $ "Current fraction:"
                        H.div ! A.id "frac" ! class_ "border col-md-12" $ do
                            sup "1"
                            "⁄"
                            sub "10")
    scripts

page ∷ Html
page =  do
    myHead
    myBody

jq ∷ String → JSM JSVal
jq = jsg1 ("$" :: String)

splitIntoNumbers ∷ String → [Int]
splitIntoNumbers s = read <$> splitWhen (not . isNumber) s

intToRatio ∷ Int → Ratio Int
intToRatio = (% 1)

cfToRatio ∷ [Ratio Int] → Ratio Int
cfToRatio = foldl1 (\t n -> n + (1 / t))

-- Not even needed!
-- cfToFrac :: [Int] -> (Int, Int)
-- cfToFrac = foldl (\(n, d) m -> (d + (n * m), n)) (1, 1)

getCFEDetails ∷ JSString → Ratio Int
getCFEDetails str = cfToRatio . fmap fromIntegral . reverse . splitIntoNumbers $ fromJSString str

callEmptyMethod ∷ String → JSVal → JSM JSVal
callEmptyMethod m o = o # m $ ([] :: [String])

calc ∷ JSM ()
calc = do
    cfe <- jq "#cfe"
    dec <- jq "#dec"
    cfeVal <- callEmptyMethod "val" cfe
    cfeStr <- fromJSValUnchecked cfeVal
    let ratio = getCFEDetails cfeStr
    -- dec # ("html" :: String) $ cfeVal
    pure ()

jsMain ∷ JSM ()
jsMain = do
    doc <- currentDocumentUnchecked
    elBody <- getBodyUnchecked doc
    elHead <- getHeadUnchecked doc
    elDoc <- getDocumentElementUnchecked doc
    setInnerHTML elDoc . BSL.unpack $ renderHtml page
    cfe <- jq "#cfe"
    dec <- jq "#dec"
    fracNum <- jq "#frac sup"
    fracDen <- jq "#frac sub"
    graph <- jq "canvas#graph"
    liftIO . putStrLn $ "Ready"
    pure ()

main ∷ IO ()
main = run 5000 jsMain

{-
const calc = () => {
    const cfe = $cfe.val(),
        [value, frac] = getCFEDetails(cfe);

    $dec.html(value);
    $fracNum.html(frac[0]);
    $fracDen.html(frac[1]);
};

$(`#cfe`).on(`keyup`, calc);
$(`#cfe`).on(`change`, calc);
$(`button[data-cfe]`).on(`click`, ev => {
    $cfe.val($(ev.target).data(`cfe`));
    calc();
});
-}
