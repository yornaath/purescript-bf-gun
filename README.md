# purescript-bf-gun

Gun DB bindings in purescript.

## Docs
[pursuit.purescript.org/packages/purescript-bf-gun](https://pursuit.purescript.org/packages/purescript-bf-gun)

## Quickstart

A simple quickstart with shared state type between client and express server.

### Server
```purescript
module Examples.Basic.Server where

import Prelude hiding (apply)

import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Timer (setInterval)
import Examples.Basic.State (stateFromJson, stateToJson)
import Gun as Gun
import Gun.Configuration (Configuration, fileOption, webOption)
import Node.Express.App (App, listenHttp, get)
import Node.Express.Response (send)
import Node.HTTP (Server)

app :: App
app = get "/" do
  send "body"

main :: Effect Server
main = do

  server <-
    listenHttp app 8080 \_ ->
      log $ "Server Listening on " <> show 8080
      
  let
    gunConfig :: Options Configuration
    gunConfig =
      webOption := Just server
        <> fileOption
        := Just "radata"

  gun <- liftEffect $ (Gun.create gunConfig)

  statenode <- liftEffect $ Gun.get stateFromJson stateToJson "state" gun

  _ <-
    liftEffect
      $ setInterval 3000 do
        log "sending message"
        _ <- statenode # Gun.put { message: "Message from server" }
        pure unit

  pure server

```

### Client
```purescript
module Examples.Basic.Client where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Examples.Basic.State (stateFromJson, stateToJson)
import Gun as Gun
import Gun.Configuration (Configuration, peersOption)

main :: Effect Unit
main = launchAff_ do
  let
    gunConfig :: Options Configuration
    gunConfig =
      peersOption := Just ["http://localhost:8080/gun"]

  gun <- liftEffect $ (Gun.create gunConfig)

  statenode <- liftEffect $ Gun.get stateFromJson stateToJson "state" gun

  pure $ trace statenode identity

  _ <- do  
    log "listening"
    _ <- liftEffect $ statenode # Gun.on (\d -> do 
      case d.data of 
        (Left _) -> do log "error parsing server message "
        (Right state) -> do log state.message
    )
    pure unit
      

  pure unit
```
