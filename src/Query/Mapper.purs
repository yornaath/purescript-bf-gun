module Gun.Query.Mapper where

import Data.Maybe (Maybe)
import Effect (Effect)
import Gun.Node (Raw, Saveable, Cursor)

data Mapper a = 
    Func (Raw a -> Effect (Maybe (Saveable a)))
  | Cursor Cursor
  | Passthrough