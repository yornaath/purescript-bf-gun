module Gun.Node where

import Prelude

import Data.Argonaut (Json)
import Record as Record
import Type.Proxy (Proxy(..))

--data Node :: Row Type -> Type
data Node a
  = Node (Raw a)

data Saveable a =
    SaveableNode (Node a)
  | SaveableRaw (Raw a)
  | SaveableRecord (Record a)

type Raw :: Row Type -> Type
type Raw a
  = Record
      ( "_" ::
          {
            "#" :: String,
            ">" :: Json
          }
      | a
      )
