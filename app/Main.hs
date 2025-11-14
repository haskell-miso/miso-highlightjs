-----------------------------------------------------------------------------
{-# LANGUAGE CPP               #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
module Main where
-----------------------------------------------------------------------------
import           Control.Monad
import           Language.Javascript.JSaddle
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.CSS as CSS
import           Miso.Html as H
import           Miso.Html.Property as P
-----------------------------------------------------------------------------
#ifdef WASM
foreign export javascript "hs_start" main :: IO ()
#endif
-----------------------------------------------------------------------------
main :: IO ()
main = run (startApp app)
-----------------------------------------------------------------------------
data Action = Init
type Model  = ()
-----------------------------------------------------------------------------
app :: App Model Action
app = (component () update_ viewModel)
#ifndef WASM
  { scripts =
      [ Src "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js"
      , Src "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/languages/haskell.min.js"
      ]
  , styles = [ Href "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/default.min.css" ]
  }
#endif
-----------------------------------------------------------------------------
update_ :: Action -> Effect parent model action
update_ Init = io_ $ void $ do
  hljs <- global ! ("hljs" :: MisoString)
  hljs # ("highlightAll" :: MisoString) $ ()
-----------------------------------------------------------------------------
viewModel :: Model -> View Model Action
viewModel () =
  H.div_
  [ CSS.style_ [ "font-family" =: "monospace" ]
  ]
  [ H.h1_
    []
    [ "🍜 ", a_ [ href_ "https://github.com/haskell-miso/miso-highlightjs" ] [ "highlight.js" ]
    ]
  , H.button_ [ H.onClick Init ] [ "Highlight" ]
  , H.pre_
      []
      [ H.p_ [ ] [ "HTML" ]
      , H.code_
        [ class_ "language-html"
        ]
        [ """<head><title class=\"foo\">hi</title></head>
          """
        ]
      , H.p_ [] [ "SQL" ]
      , H.code_
        [ class_ "language-sql"
        ]
        [ """ SELECT * FROM person WHERE name LIKE 'J*'
          """
        ]
      , H.p_ [] [ "JS" ]
      , H.code_
        [ class_ "language-javascript"
        ]
        [ """ (function () { console.log ('hey'); })() """
        ]
      , H.p_ [] [ "Haskell" ]
      , H.code_
        [ class_ "language-haskell"
        ]
        [ """
          module Main where

          main :: IO ()
          main = print (Person "bob" 42)

          data Person
            = Person
            { name :: String
            , age :: Int
            } deriving (Show, Eq)
          """
        ]
      ]
    ]
-----------------------------------------------------------------------------
