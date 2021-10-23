module Gun.Query where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.Argonaut (Json, JsonDecodeError(..), decodeJson)
import Data.Array (cons, foldM, snoc)
import Data.Bifunctor (class Bifunctor, bimap)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Gun.Node (Cursor, Node)

data QueryOperator a
  = From (Array String) 
  | Map (Maybe Cursor) 
  | Once 
  | OnceExec (Exec a)
  | On (Exec a)

type Exec a = (Either JsonDecodeError a -> Effect Unit)

-- type Operator
--   = Free OperatorF

-- from :: Array String -> Operator Unit
-- from str = liftF (From str unit)

-- map :: Cursor -> Operator Unit
-- map cursor = liftF (Map cursor unit)

-- once :: Operator Unit
-- once = liftF (Once unit)

type Query a = Array (QueryOperator a)

emptyQuery :: forall a. Query a
emptyQuery = []

from :: forall a . Array String -> Query a -> Query a
from path query = snoc query (From path)

map :: forall a. Maybe Cursor -> Query a -> Query a
map filter query = snoc query (Map filter)

once :: forall a. Query a -> Query a
once query = snoc query (Once)

onceExec :: forall a. Exec a -> Query a -> Query a
onceExec exec query = snoc query (OnceExec exec)

on :: forall a. Exec a -> Query a -> Query a
on exec query = snoc query (On exec)

q :: forall a. Array (QueryOperator a)
q = emptyQuery # 
    from ["user", "data"] # 
    map Nothing # 
    once # 
    on \d -> do 
      pure unit

type QueryOperation a = Tuple (Node a) (QueryOperator (Record a))

combine :: forall a. QueryOperator (Record a) -> Node a -> QueryOperation a
combine query node = Tuple node query

perform :: forall a b. QueryOperation a -> QueryOperation b
perform operation = bimap

--runQuery :: forall a. Query (Record a) -> Node a -> Effect (Either JsonDecodeError (Record a))
-- runQuery query node = do 
--   pure $ Left $ TypeMismatch "not implemented"

-- runQuery query node = foldM runNext node paths 
--   where
--     getNext acc nextPath = get nextPath acc
--   pure $ Left $ TypeMismatch "not implemented"