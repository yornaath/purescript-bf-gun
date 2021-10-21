module Examples.Chat.State where

import Data.Argonaut (Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Either (Either)
 
type Message = {
  text :: String
}

messageToJson :: Message -> Json
messageToJson = encodeJson

messageFromJson :: Json -> Either JsonDecodeError Message
messageFromJson = decodeJson