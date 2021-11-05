module Examples.Basic.Server where

import Prelude hiding (apply)

import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Effect (Effect)
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

  let gun = Gun.create gunConfig

  let alice = Gun.get "alice" gun
  let alicenodeWithData = alice # Gun.put (SaveableRecord {name : "Alice"})

  let people = Gun.get "people" gun
  
  let _ = people # Gun.set (SaveableNode alicenodeWithData)

  let messages = Gun.get "messages" gun

  _ <-
    setInterval 900 do
      log "sending message from server"
      let _ = messages # Gun.put (SaveableRecord { message: "Message from server" })
      pure unit

  pure server
