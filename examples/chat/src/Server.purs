module Examples.Chat.Server where

import Prelude hiding (apply)

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Examples.Chat.State (messageFromJson)
import Gun as Gun
import Gun.Configuration (Configuration, fileOption, webOption)
import Gun.Node (Saveable(..), getData)
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
      webOption := Just server
        <> fileOption
        := Just "radata"

  gun <- liftEffect $ (Gun.create gunConfig)

  chatnode <- Gun.get "chat" gun >>= \n -> Gun.map Passthrough n
  
  _ <- liftEffect $ 
    chatnode # Gun.on (\raw -> do
      let message = getData (SaveableRaw raw)
      case messageFromJson message of 
        (Left error) -> do 
          log "error parsing server message error:"
          pure $ trace error identity
        (Right state) -> do pure $ trace {state} identity
    )

  pure server
