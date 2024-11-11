#!/usr/bin/env nix-shell
#! nix-shell -p "haskell.packages.ghc910.ghcWithPackages(pkgs: with pkgs; [ blaze-svg ])" -i runghc

{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Text.Blaze.Svg11 as S
import Text.Blaze.Svg11.Attributes as A
import Text.Blaze.Svg.Renderer.Pretty

main :: IO ()
main = writeFile "2.svg" . renderSvg $ doc

doc :: Svg
doc = docTypeSvg $ do
    defs $ do
        S.title "Demo"

{-
<!-- height, width, viewBox -->
    <defs>
        <title>Demo</title>
        <!-- todo cdata -->
        <style>
            #btn:hover {
                fill: url(#grad1);
            }
        </style>
        <!-- Button hover gradient -->
        <linearGradient
            id="grad1"
            x1="0"
            y1="0"
            x2="1"
            y2="1"
        >
            <stop
                offset="0%"
                stop-color="green"
            />
            <stop
                offset="50%"
                stop-color="yellow"
                stop-opacity="50%"
            />
            <stop
                offset="100%"
                stop-color="red"
            />
        </linearGradient>
        <!-- Button default gradient -->
        <linearGradient
            id="grad2"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xlink:href="#grad1"
            x1="1"
            y1="0"
            x2="0"
            y2="1"
        />
        <!-- Big circle gradient -->
        <radialGradient
            id="rad1"
            cx="0.4"
            cy="0.4"
            fx="0.2"
            fy="0.2"
            r="0.34"
            spreadMethod="reflect"
            gradientUnits="objectBoundingBox"
        >
            <stop offset="0%" stop-color="white"/>
            <stop offset="100%" stop-color="blue"/>
        </radialGradient>
        <!-- Big circle hover gradient -->
        <radialGradient
            id="rad2"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xlink:href="#rad1"
        >
            <stop offset="0%" stop-color="white"/>
            <stop offset="100%" stop-color="green"/>
        </radialGradient>
        <!-- TODO gradientUnits="userSpaceOnUse" -->
        <!-- Background pattern -->
        <pattern
            id="bg"
            x="0"
            y="0"
            width="0.1"
            height="0.1"
            patternUnits="objectBoundingBox"
            patternContentUnits="userSpaceOnUse"
        >
            <rect
                x="0"
                y="0"
                width="500"
                height="500"
                fill="black"
            />
            <rect
                x="0"
                y="0"
                width="100"
                height="100"
                fill="#111"
            />
        </pattern>
        <!-- Text arc path -->
        <path
            id="arc"
            d="M 300,300 A25, 25, 180, 0, 0, 350, 250"
            fill="transparent"
        />
    </defs>
    <!-- Background -->
    <rect
        width="100%"
        height="100%"
        fill="url(#bg)"
    />
    <g
        id="circ"
    >
        <animateTransform
            from="0 200 200"
            to="360 200 200"
            attributeName="transform"
            attributeType="XML"
            type="rotate"
            dur="10s"
            repeatCount="indefinite"
        />
        <!-- Big circle -->
        <circle
            cx="200"
            cy="200"
            r="100"
            fill="url(#rad1)"
        />
        <!-- Ellipse inside the circle -->
        <ellipse
            cx="200"
            cy="250"
            rx="50"
            ry="20"
            stroke="white"
            fill="transparent"
        />
        <!-- Text inside the circle -->
        <text
            x="200"
            y="215"
            font-size="60"
            text-anchor="middle"
            font-family="sans-serif"
            fill="black"
        >
            Hello!
        </text>
    </g>
    <!-- LHS dashed line -->
    <line
        x1="50" y1="100"
        x2="50" y2="350"
        stroke="white"
        stroke-width="10"
        stroke-linecap="round"
        stroke-dasharray="10,20,5,20"
    />
    <!-- Polys -->
    <g
        id="polys"
    >
        <!-- Top left polyline -->
        <polyline
            points="10 10 20 20 20 10 30 20"
            stroke="white"
        />
        <!-- Top polygon -->
        <polygon
            points="100 10 100 20 110 20 110 5"
            stroke="white"
            fill="red"
        />
    </g>
    <!-- Button -->
    <g
        id="button"
    >
        <!-- Button -->
        <rect
            id="btn"
            x="50"
            y="25"
            rx="10"
            ry="10"
            width="300"
            height="50"
            stroke="white"
            stroke-width="1"
            fill="url(#grad2)"
        />
        <!-- Path inside the button -->
        <path
            d="M60, 40 L70,50 H80 V60"
            stroke="white"
            fill="transparent"
        />
        <!-- Second path inside the button -->
        <path
            d="M110, 40 l10, 10 h10 v-10 z"
            stroke="white"
            fill="blue"
        />
        <!-- Some XHTML inserted. -->
        <foreignObject
            x="150"
            y="35"
            width="150"
            height="50"
        >
            <a
                href="https://jolharg.com"
                xmlns="http://www.w3.org/1999/xhtml"
                target="_blank"
            >
                Click me!
            </a>
        </foreignObject>
    </g>
    <!-- Arc text -->
    <text
        fill="white"
    >
        <textPath
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xlink:href="#arc"
        >
            Good day!
        </textPath>
    </text>
    <!-- TODO bezier -->
    <!-- Text at the bottom -->
    <text
        x="200"
        y="350"
        font-size="10"
        text-anchor="middle"
        font-family="sans-serif"
        fill="white"
    >
        Brought to you by the
            <tspan
                fill="grey"
                dy="-5"
                rotate="-30 -25 -20 -15 -10 -5 0 5"
            >people</tspan>
        <tspan dy="5">
            who love hand-writing SVGs.
        </tspan>
    </text>
    <image x="350" y="350" height="32" width="32" href="https://jolharg.com/img/favicon.png" />
</svg>
-}