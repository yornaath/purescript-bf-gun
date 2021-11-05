module Gun.Query where

import Prelude

import Data.List (List(..), snoc)
import Effect (Effect)
import Gun as Gun
import Gun.Node (Node, Raw, Saveable)
import Gun.Query.Mapper (Mapper)

data QueryOperator a
  = From String
  | Map (Mapper a) 
  | Once
  | OnceExec (Exec a)
  | On (Exec a)

type Exec a = String -> Raw a -> Effect Unit

type Query a = List (QueryOperator a)

emptyQuery :: forall a. Query a
emptyQuery = Nil

from :: forall a . String -> Query a -> Query a
from path query' = snoc query' (From path)

map :: forall a. Mapper a -> Query a -> Query a
map filter query' = snoc query' (Map filter)

once :: forall a. Query a -> Query a
once query' = snoc query' (Once)

onceExec :: forall a. Exec a -> Query a -> Query a
onceExec exec query' = snoc query' (OnceExec exec)

on :: forall a. Exec a -> Query a -> Query a
on exec query' = snoc query' (On exec)

query :: forall a. Query a -> Node a -> Node a
query (Cons nextQuery tail) node = do 
  let push = case nextQuery of 
              From path -> do Gun.get path node
              Map mapper -> do Gun.map mapper node
              Once -> do Gun.once node
              OnceExec cb -> Gun.onceExec cb node
              On cb -> Gun.on cb node
  query tail push
query Nil node = node

-- query :: forall a. Query a -> Effect (Node a) -> Effect (Node a)
-- query q node = query' q 
--   where
--   query' :: forall a. QueryOperator a -> Query a -> Effect (Node a)
--   query'
-- type QueryOperation a = Tuple (Effect (Node a)) (QueryOperator (Record a))

-- combine :: forall a. QueryOperator (Record a) -> Node a -> QueryOperation a
-- combine query node = Tuple (pure node) query

-- perform :: forall a. QueryOperation a -> QueryOperation a
-- perform operation@(Tuple node query) = bimap (\n -> do
--   o <- n
--   case query of 
--     From path -> do Gun.getAt path o
--     Map filter -> do Gun.map filter o
--     Once -> do Gun.once o
--     OnceExec cb -> Gun.onceExec cb o
--     _ -> pure o
-- ) identity operation

-- (\n -> 
--   case query of 
--     Once -> Gun.once n
--     _ -> pure n
-- )

--runQuery :: forall a. Query (Record a) -> Node a -> Effect (Either JsonDecodeError (Record a))
-- runQuery query node = do 
--   pure $ Left $ TypeMismatch "not implemented"

-- runQuery query node = foldM runNext node paths 
--   where
--     getNext acc nextPath = get nextPath acc
--   pure $ Left $ TypeMismatch "not implemented"