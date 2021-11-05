module Examples.Chat.Server where

import Prelude hiding (apply)

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Console (log)
import Examples.Chat.State (serverMessageFromJson)
import Gun as Gun
import Gun.Configuration (Configuration, fileOption, webOption)
import Gun.Node (Raw, Saveable(..), getData)
import Gun.Query.Mapper (Mapper(..))
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
      webOption := Just server <> 
      fileOption := Just "radata"

  let gun = Gun.create gunConfig

  let chatnode = gun # Gun.get "chat" # Gun.map Passthrough
  
  let 
    onMessage :: String -> Raw (text :: String) -> Effect Unit
    onMessage key raw = do
      let message = getData (SaveableRaw raw)
      case serverMessageFromJson message of 
        (Left error) -> do 
          log "error parsing server message error:"
          pure $ trace error identity
        (Right state) -> do pure $ trace {state, key} identity

  let _ = chatnode # Gun.on onMessage

  pure server
