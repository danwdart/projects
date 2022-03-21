{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-unused-imports -Wno-unused-matches #-}

import Graphics.Rendering.OpenGL.GL as GL
import Graphics.Rendering.OpenGL.GL.Framebuffer as GLFB
import SDL as SDL
import SDL.Video.OpenGL as SDLGL
import SDL.Video.Vulkan

main :: IO ()
main = do
    putStrLn "Initialising"
    initializeAll
    -- putStrLn "Loading Vulkan"
    -- vkLoadLibrary Nothing
    -- putStrLn "Getting proc addr"
    -- procaddr <- vkGetVkGetInstanceProcAddr
    putStrLn "Creating window"
    window <- createWindow "SDL GL Demo" defaultWindow {
        windowGraphicsContext = {- VulkanContext -} OpenGLContext defaultOpenGL {
            glProfile = Core Debug 4 5
        },
        windowPosition = Centered
    }
    -- surface <- vkCreateSurface window 
    putStrLn "Creating context"
    glCtx <- glCreateContext window
    putStrLn "Getting drawable size"
    drawableSize <- glGetDrawableSize window
    print drawableSize
    -- putStrLn "Finding display information"
    -- displays <- getDisplays
    -- putStrLn "Displaying display information"
    -- print displays
    clearColor  $= Color4 0 0 0 0
    shadeModel  $= Smooth
    cullFace    $= Just Back
    frontFace   $= CCW
    viewport    $= (Position 0 0, Size 800 600)
    matrixMode  $= Projection
    -- frustum
    loadIdentity
    GL.clear [ColorBuffer, DepthBuffer]
    translate $ Vector3 @GLdouble 0 0 (-5)
    pure ()