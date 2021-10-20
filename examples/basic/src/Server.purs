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
