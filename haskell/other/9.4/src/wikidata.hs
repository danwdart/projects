{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-imports #-}

import Language.GraphQL
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Req

-- POST https://tptools.toolforge.org/wdql.php
-- query / queryId

-- Get all schema:

{-
{
  __schema {
    queryType {
      fields {
        name
      }
    }
  }
}
-}

--  curl 'https://tptools.toolforge.org/wdql.php' -H 'Content-Type: application/json' -H 'Accept: application/json' --compressed  --data-binary '{"query":"{\n\t__schema{\n queryType {\n fields{\n name\n }\n }\n }\n}"}'

{-
SELECT DISTINCT ?item ?itemLabel WHERE {
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE]". }
  {
    SELECT DISTINCT ?item WHERE {
      ?item p:P735 ?statement0.
      ?statement0 (ps:P735/(wdt:P279*)) wd:Q463035.
      ?item p:P734 ?statement1.
      ?statement1 (ps:P734/(wdt:P279*)) wd:Q351735.
    }
    LIMIT 100
  }
}
-}

main ∷ IO ()
main = pure ()
