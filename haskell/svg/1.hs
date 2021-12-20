#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/master.tar.gz -p "haskell.packages.ghc921.ghcWithPackages(pkgs: with pkgs; [ blaze-svg ])" -i runghc

{-# LANGUAGE OverloadedStrings #-}

import Text.Blaze.Svg11 as S
import Text.Blaze.Svg11.Attributes as A
import Text.Blaze.Svg.Renderer.Pretty

main :: IO ()
main = writeFile "1.svg" . renderSvg $ doc

doc :: Svg
doc = docTypeSvg ! width "400" ! height "400" $ do
    rect ! width "100%" ! height "100%" ! fill "black"
    circle ! cx "200" ! cy "200" ! r "100" ! fill "purple"
    text_ ! x "200" ! y "215" ! fontSize "60" ! textAnchor "middle" ! fill "black" $ "Hi!"