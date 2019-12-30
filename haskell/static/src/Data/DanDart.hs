{-# LANGUAGE OverloadedStrings #-}

module Data.DanDart (keywords, descTitle, musicalStyles, favCharacters, musicList) where

import Html.Common.Shortcuts
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

keywords :: [AttributeValue]
keywords = [
    "dan",
    "dart",
    "software",
    "engineer",
    "mathematics",
    "lover",
    "radio",
    "ham",
    "php",
    "javascript",
    "css",
    "coffee",
    "coffeescript",
    "laravel",
    "zend",
    "framework",
    "linux",
    "gnu",
    "express.js",
    "ubuntu",
    "debian"
    ]

descTitle :: String
descTitle = "Dan Dart: Software Engineer, Mathematics Lover, Radio Ham, Musician"

musicalStyles :: [Html]
musicalStyles = [
    "Prog Rock",
    "Heavy Metal",
    "Ambient",
    "Classical"
    ]

favCharacters :: [(Html, AttributeValue, [(Html, AttributeValue, Html)])]
favCharacters = [
    (
        "Star Trek",
        wikipedia <> "Star_Trek",
        [
            (
                "Spock",
                wikipedia <> "Spock",
                "I often think of the world logically"
            ),
            (
                "Evil (Mirror) Spock",
                wikia "memory-alpha" "Spock_(mirror)",
                "of his outrageous beard and he's just hysterical"
            ),
            (
                "Data",
                wikipedia <> "Data_%28Star_Trek%29",
                "I am curious, confused and if he was human he'd probably be autistic"
            )
        ]
    ),
    (
        "Danganronpa",
        wikipedia <> "Danganronpa",
        [
            (
                "Nagito Komaeda",
                wikipedia <> "List_of_Danganronpa_characters#Danganronpa_2:_Goodbye_Despair",
                "I'm very lucky and obsessed with hope, and also trash"
            ),
            (
                "Chihiro Fujisaki",
                wikipedia <> "List_of_Danganronpa_characters#Danganronpa:_Trigger_Happy_Havoc",
                "I love programming and feel similar about life"
            )
        ]
    ),
    (
        "Steven Universe",
        wikipedia <> "Steven_Universe",
        [
            (
                "Amethyst",
                wikia "steven-universe" "Amethyst",
                "she's got \"a system\" and I like her vibe."
            )
        ]
    ),
    (
        "Kobayashi-san Chi no Maid Dragon",
        wikipedia <> "Miss_Kobayashi%27s_Dragon_Maid",
        [
            (
                "Fafnir",
                wikia "maid-dragon" "Fafnir",
                "he's dapper, awesome, interesting and acts hilariously"
            )
        ]
    ),
    (
        "Mirai Nikki",
        wikipedia <> "Future_Diary",
        [
            (
                "Yukiteru Amano",
                wikia "futurediary" "Yukiteru_Amano",
                "my waifu is Yuno, and Yuki is depressed and I would act like he acts in the OVA"
            )
        ]
    ),
    (
        "Berserk",
        wikipedia <> "Berserk_%28manga%29",
        [
            (
                "Griffith",
                wikipedia <> "List_of_Berserk_characters#Griffith",
                "he's sneaky and smart and he looks fabulous"
            )
        ]
    ),
    (
        "Kuroshitsuji",
        wikipedia <> "Black_Butler",
        [
            (
                "Grell Sutcliff",
                "https://kuroshitsuji.fandom.com/wiki/Grell_Sutcliff",
                "he's hysterical, fabulous and has good taste in butlers"
            )
        ]
    ),
    (
        "Mahoutsukai no Yome",
        wikipedia <> "The_Ancient_Magus%27_Bride",
        [
            (
                "Elias Ainsworth",
                wikia "ancientmagusbride" "Elias_Ainsworth",
                "he's caring, doesn't act like outrageous humans and Chise is my waifu"
            )
        ]
    ),
    (
        "Neon Genesis Evangelion",
        wikipedia <> "Neon_Genesis_Evangelion",
        [
            (
                "Shinji Ikari",
                wikipedia <> "Shinji_Ikari",
                "existentialism, essentially. He's a whiner, but I like his thought patterns when he's being existential."
            )
        ]
    ),
    (
        "MLP",
        wikipedia <> "My_Little_Pony:_Friendship_Is_Magic",
        [
            (
                "Twilight Sparkle",
                wikipedia <> "List_of_My_Little_Pony%3A_Friendship_Is_Magic_characters#Twilight_Sparkle",
                "knowledge and being awesome"
            )
        ]
    ),
    (
        "Alice's Adventures in Wonderland",
        wikipedia <> "Alice%27s_Adventures_in_Wonderland",
        [
            (
                "The Mad Hatter",
                wikipedia <> "Hatter_(Alice%27s_Adventures_in_Wonderland)",
                "I like his sense of humour, eccentricity and hats"
            )
        ]
    ),
    (
        "The Filthy Frank Show",
        ytUser <> "TVFilthyFrank",
        [
            (
                "Real Frank",
                wikia "filthy-frank" "Filthy_Frank",
                "he's lost and good to his crew. ^Also depression, yay^"
            )
        ]
    ),
    (
        "Back to the Future",
        wikipedia <> "Back_to_the_Future_(franchise)",
        [
            (
                "\"Doc\" Emmett Brown",
                wikipedia <> "Emmett_Brown",
                "he's eccentric and time travel, hell yeah"
            )
        ]
    ),
    (
        "Doctor Who",
        wikipedia <> "Doctor_Who",
        [
            (
                "The Doctor",
                wikipedia <> "The_Doctor_(Doctor_Who)",
                "of eccentricity, inventions and awesomeness"
            )
        ]
    ),
    (
        "Battleborn",
        wikipedia <> "Battleborn_(video_game)",
        [
            (
                "Marquis",
                "https://battleborn.com/en/battleborn/marquis/",
                "those quotes are amazing, dunk dunk dunk!"
            )
        ]
    )
    ]
    


musicList :: [(Html, [Html])]
musicList = [
    (
        "Pink Floyd",
        [
            "Comfortably Numb",
            "Another Brick in the Wall",
            "Wish You Were Here",
            "The Dark Side of the Moon (yes, to me it's a single song)"
        ]
    ),
    (
        "Focus",
        [
            "Anonymus II",
            "Eruption",
            "Sylvia/Hocus Pocus"
        ]
    ),
    (
        "16volt",
        [
            "At The End",
            "Therapy"
        ]
    ),
    (
        "Bring Me The Horizon",
        ["That's The Spirit (the whole album is amazing!)"]
    ),
    (
        "Starset",
        ["My Demons"]
    ),
    (
        "Bach",
        ["Wohltemperierte Klavier"]
    ),
    (
        "Holst",
        ["Planets"]
    ),
    (
        "Many more...",
        []
    )
    ]