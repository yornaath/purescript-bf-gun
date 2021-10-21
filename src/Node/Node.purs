module Gun.Node where

import Data.Argonaut (Json)

data Node a
  = Node a
  | UserNode a

type Raw :: forall k. k -> Type
type Raw a
  = {
    data :: Json,
    "#" :: String,
    ">" :: Json
  }
