module Gun
  ( create
  , opt
  , get
  , getAt
  , put
  , set
  , putWithCertificate
  , on
  , once
  , map
  , back
  , off
  ) where

import Prelude

import Data.Array (foldM)
import Data.Options (Options, options)
import Effect (Effect)
import Foreign (Foreign)
import Gun.Configuration (Configuration)
import Gun.Node (Node, Raw, Saveable)
import Gun.SEA (Certificate)

foreign import _create :: Foreign -> Effect (Node)

create :: Options Configuration -> Effect (Node)
create opts = _create (options opts)

foreign import _opt :: Options Configuration -> Node -> Effect (Node)

opt ::  Options Configuration -> Node -> Effect (Node)
opt = _opt

foreign import _get :: String -> Node -> Effect (Node)

get :: String -> Node -> Effect (Node)
get = _get

getAt :: Array String -> Node -> Effect (Node)
getAt paths node = foldM getNext node paths 
  where
    getNext acc nextPath = get nextPath acc
  
foreign import _put :: forall a. Saveable a -> Node -> Effect (Node)

put :: forall a. Saveable a -> Node -> Effect (Node)
put = _put

foreign import _set :: forall a. Saveable a -> Node -> Effect (Node)

set :: forall a. Saveable a -> Node -> Effect (Node)
set = _set

foreign import _putWithCertificate :: forall a. Certificate -> Saveable a -> Node -> Effect (Node)

putWithCertificate :: forall a. Certificate -> Saveable a -> Node -> Effect (Node)
putWithCertificate = _putWithCertificate

foreign import _on :: forall a. (Raw a -> Effect Unit) -> Node -> Effect (Node)

on :: forall a. (Raw a -> Effect Unit) -> Node -> Effect (Node)
on = _on

foreign import _once :: forall a. (Raw a -> Effect Unit) -> Node -> Effect (Node)

once :: forall a. (Raw a -> Effect Unit) -> Node -> Effect (Node)
once = _once

foreign import _map :: forall a b. (Saveable a -> Saveable b) -> Node -> Effect (Node)

map :: forall a b. (Saveable a -> Saveable b) -> Node -> Effect (Node)
map = _map

foreign import _back :: Int -> Node -> Effect (Node)

back :: Int -> Node -> Effect (Node)
back = _back

foreign import _off :: Node -> Effect Unit

off :: Node -> Effect Unit
off = _off
