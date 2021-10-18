module Main where

import Prelude

import Data.Argonaut (Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Either (Either)
import Data.Gun.Configuration (Configuration, fileOption, webOption)
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Class.Console (logShow)
import Effect.Console (log)
import Effect.Timer (setInterval, setTimeout)
import Gun (GunNode, create, get, on, put)

type State = { inc :: Int, state :: String }

-- We get encoding and decoding for free because of the `EncodeJson` instances
-- for records, strings, integers, and `Maybe`, along with many other common
-- PureScript types.

stateToJson :: State -> Json
stateToJson = encodeJson

stateFromJson :: Json -> Either JsonDecodeError State
stateFromJson = decodeJson

main :: Effect Unit
main = do

  let 
    gunConfig :: Options Configuration
    gunConfig = webOption := Nothing <>
                fileOption := Nothing

  let gun = (create gunConfig) :: GunNode State

  let statenode = gun # get stateFromJson stateToJson "state"
  
  _ <- do
    statenode # on \d -> do pure $ trace d identity

  _ <- setInterval 3000 do
    log "timer"
    let _ = statenode # put { inc: 1, state: "newstate" }
    pure unit

  pure unit
