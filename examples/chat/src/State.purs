module Examples.Chat.State where

import Data.Argonaut (Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Either (Either)
 
type ServerMessage = {
  text :: String
}

type DatedMessage = {
  text :: String,
  date :: String
}

serverMessageToJson :: ServerMessage -> Json
serverMessageToJson = encodeJson

serverMessageFromJson :: Json -> Either JsonDecodeError ServerMessage
serverMessageFromJson = decodeJson 