module Test.Main where

import Prelude

import Data.Argonaut (Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Either (Either)
import Data.Gun.Configuration (Configuration, fileOption, webOption)
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Timer (setInterval)
import Gun (create, get, on, put)
import Gun.User as User

type RootData = { state :: String }

rootDataToJson :: RootData -> Json
rootDataToJson = encodeJson

rootDataFromJson :: Json -> Either JsonDecodeError RootData
rootDataFromJson = decodeJson

type UserData = {secret :: String}

userDataToJson :: UserData -> Json
userDataToJson = encodeJson

userDataFromJson :: Json -> Either JsonDecodeError UserData
userDataFromJson = decodeJson

main :: Effect Unit
main = launchAff_ do

  let 
    gunConfig :: Options Configuration
    gunConfig = webOption := Nothing <>
                fileOption := Just "radata"

  gun <- liftEffect $ (create gunConfig)

  statenode <- liftEffect $ get rootDataFromJson rootDataToJson "state" gun

  _ <- do
    liftEffect $ statenode # on \d -> do pure $ trace { stateNode: d} identity

  _ <- liftEffect $ setInterval 3000 do
    _ <- statenode # put { state: "new" }
    pure unit

  usernode <- liftEffect $ User.user gun

  bob <- User.createUser "bob" "bobspass" usernode
  
  authed <- User.auth "bob" "bobspass" usernode

  case authed of 
    (User.AuthSuccess auth) -> do
      
      pure $ trace "logged in" identity

      userDataNode <- liftEffect $ get userDataFromJson userDataToJson "data" usernode

      _ <- do
        liftEffect $ userDataNode # on \d -> do pure $ trace { userNode: d} identity

      _ <- liftEffect $ setInterval 3000 do
        _ <- userDataNode # put { secret : "Hysjaass" }
        pure unit

      pure $ trace "exit" identity

    (User.AuthError {err}) -> do
      pure $ trace err identity
  

  -- pure $ trace {pair'} identity

  -- out <- work pair' {foobar: "foos"} (algoOption := Just sHA256)

  -- pure $ trace {out} identity

  -- let statenode = gun # get stateFromJson stateToJson "state"
  
  -- _ <- do
  --   liftEffect $ statenode # on \d -> do pure $ trace d identity

  -- _ <- liftEffect $ setInterval 3000 do
  --   log "timer"
  --   let _ = statenode # put { inc: 1, state: "newstate" }
  --   pure unit

  pure unit
