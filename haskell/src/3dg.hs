import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core

main :: IO ()
main = startGUI defaultConfig setup

alert :: String -> JSFunction ()
alert = ffi "alert(%1)"

consolelog :: String -> JSFunction ()
consolelog = ffi "console.log(%1)"

setup :: Window -> UI ()
setup w = do
    return w # set title "Hi"

    title <- UI.h1 #. "title"
        # set style [("color","grey")]
        # set text "Hello!"
    
    getBody w #+ [element title]
    
    liftUI $ do
        runFunction $ alert "Hello World"
        runFunction $ consolelog "Hi Console!"

    return ()