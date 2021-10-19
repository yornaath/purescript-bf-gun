module Main where

import Prelude

import Data.Argonaut (Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Either (Either)
import Data.Gun.Configuration (Configuration, fileOption, webOption)
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Aff (launchAff, launchAff_)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Class.Console (logShow)
import Effect.Console (log)
import Effect.Timer (setInterval, setTimeout)
import Gun (GunNode, create, get, on, put)
import Gun.SEA (algoOption, pBKDF2, pair, sHA256, secret, work)

type State = { inc :: Int, state :: String }

-- We get encoding and decoding for free because of the `EncodeJson` instances
-- for records, strings, integers, and `Maybe`, along with many other common
-- PureScript types.

stateToJson :: State -> Json
stateToJson = encodeJson

stateFromJson :: Json -> Either JsonDecodeError State
stateFromJson = decodeJson

main :: Effect Unit
main = launchAff_ do

  let 
    gunConfig :: Options Configuration
    gunConfig = webOption := Nothing <>
                fileOption := Just "radata"

  let gun = (create gunConfig) :: GunNode State

  pairA <- pair
  pairB <- pair

  secret' <- secret pairA pairB

  pure $ trace {secret'} identity

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
