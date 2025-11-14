:ramen: ✨ miso-highlightjs
====================

`miso` integration with [highlight.js](https://highlightjs.org/)

```haskell
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
      ]
    ]
-----------------------------------------------------------------------------
```

### Build (Web Assembly)

```bash
$ nix develop .#wasm --command bash -c "make"
```

### Build (JavaScript)

```bash
$ nix develop .#ghcjs
$ build app
```

### Serve

To host the built application you can call `serve`

```bash
$ nix develop .#wasm --command bash -c "make serve"
```

### Clean

```bash
$ nix develop --command bash -c "make clean"
```

This comes with a GitHub action that builds and auto hosts the example.
