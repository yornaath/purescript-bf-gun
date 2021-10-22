module Examples.Basic.Server where

import Prelude hiding (apply)

import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Timer (setInterval)
import Gun as Gun
import Gun.Configuration (Configuration, fileOption, webOption)
import Gun.Node (Saveable(..))
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

  gun <- Gun.create gunConfig

  messages <- Gun.get "state" gun

  alice <- Gun.get "alice" gun
  alicenodeWithData <- alice # Gun.put (SaveableRecord {name : "Alice"})

  people <- Gun.get "people" gun
  _ <- people # Gun.set (SaveableNode alicenodeWithData)

  _ <-
    setInterval 900 do
      log "sending message from server"
      _ <- messages # Gun.put (SaveableRecord { message: "Message from server" })
      pure unit

  pure server
