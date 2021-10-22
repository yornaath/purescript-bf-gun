module Gun.Node where

import Data.Argonaut (Json)

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
