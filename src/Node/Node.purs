module Gun.Node where

import Data.Argonaut (Json)

type Node = {}

data Saveable a =
    SaveableNode (Node)
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
