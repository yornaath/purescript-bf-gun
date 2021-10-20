module Examples.Basic.State where

import Data.Argonaut (Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Either (Either)
  
type State
  = { message :: String }

stateToJson :: State -> Json
stateToJson = encodeJson

stateFromJson :: Json -> Either JsonDecodeError State
stateFromJson = decodeJson