{-# LANGUAGE OverloadedStrings #-}

module Html.Common.Shortcuts (ghPages, ghPagesProjects, projectsSource, imdb, wikipedia, yt, ytChan, ytUser, nhs, oeis, wikia) where

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

ghPages, ghPagesProjects, projectsSource, imdb, wikipedia, yt, ytChan, ytUser, nhs, oeis :: AttributeValue
ghPages = "https://danwdart.github.io/"
ghPagesProjects = ghPages <> "projects/"

projectsSource = "https://github.com/danwdart/projects/tree/master"
wikipedia = "https://en.wikipedia.org/wiki/"
ytChan = "https://www.youtube.com/channel/"
ytUser = "https://www.youtube.com/user/"
yt = "https://www.youtube.com/watch?v="
imdb = "https://www.imdb.com/title/tt"
nhs = "https://www.nhs.uk/conditions/"
oeis = "https://oeis.org/A"

wikia :: AttributeValue -> AttributeValue -> AttributeValue
wikia subwiki article = "https://" <> subwiki <> ".wikia.com/wiki/" <> article
