module Gun.Node where

import Data.Argonaut (Json)
import Data.Maybe (Maybe(..))
import Prim.Row (class Lacks)
import Record (delete)
import Type.Proxy (Proxy(..))

foreign import getDataImpl :: forall a. Saveable a -> Json

type Node a
  = { put :: Maybe (Raw a)
    }

type Cursor
  = { "#" :: String
    , ">" :: Json
    }

type Raw a
  = Record
      ( "_" :: Cursor
      | a
      )

data Saveable a
  = SaveableNode (Node a)
  | SaveableRaw (Raw a)
  | SaveableRecord (Record a)

getData :: forall a. Saveable a -> Json
getData = getDataImpl

-- getData :: forall a. Lacks "_" a => Saveable a -> Maybe (Record a)
-- getData = case _ of
--   SaveableNode node -> case node.put of
--     Just raw -> Just (getDataFromRaw raw)
--     Nothing -> Nothing
--   SaveableRaw raw -> Just (getDataFromRaw raw)
--   SaveableRecord record -> Just record

-- getDataFromRaw ::
--   forall a.
--   Lacks "_" a =>
--   Raw a ->
--   Record a
-- getDataFromRaw raw = delete (Proxy :: Proxy "_") raw
