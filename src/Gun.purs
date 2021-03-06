module Gun
  ( create
  , opt
  , get
  , put
  , set
  , putWithCertificate
  , on
  , once
  , onceExec
  , map
  , back
  , off
  , toJSON
  ) where

import Prelude

import Data.Argonaut (Json)
import Data.Maybe (Maybe)
import Data.Options (Options, options)
import Effect (Effect)
import Foreign (Foreign)
import Gun.Configuration (Configuration)
import Gun.Node (Cursor, Node, Raw, Saveable)
import Gun.Query.Mapper (Mapper(..))
import Gun.SEA (Certificate)

foreign import _create ::forall a. Foreign -> Node a

create :: forall a. Options Configuration -> Node a
create opts = _create (options opts)

foreign import _opt :: forall a. Options Configuration -> Node a -> Node a

opt :: forall a. Options Configuration -> Node a -> Node a
opt = _opt

foreign import _get :: forall a b. String -> Node a -> Node b

get :: forall a b. String -> Node a -> Node b
get = _get

foreign import _put :: forall a. Saveable a -> Node a -> Node a

put :: forall a. Saveable a -> Node a -> Node a
put = _put

foreign import _set :: forall a. Saveable a -> Node a -> Node a

set :: forall a. Saveable a -> Node a -> Node a
set = _set

foreign import _putWithCertificate :: forall a. Certificate -> Saveable a -> Node a -> Node a

putWithCertificate :: forall a. Certificate -> Saveable a -> Node a -> Node a
putWithCertificate = _putWithCertificate

foreign import _on :: forall a. (String -> Raw a -> Effect Unit) -> Node a -> Node a

on :: forall a. (String -> Raw a -> Effect Unit) -> Node a -> Node a
on = _on

foreign import _once :: forall a. (String -> Raw a -> Effect Unit) -> Node a -> Node a

once :: forall a. Node a -> Node a
once = _once \_ _ -> pure unit

onceExec :: forall a. (String -> Raw a -> Effect Unit) -> Node a -> Node a
onceExec = _once

foreign import _map :: forall a b. (Mapper a) -> Node a -> Node b

map :: forall a b. (Mapper a) -> Node a -> Node b
map = _map

foreign import _toJSON :: forall a. Raw a -> Effect Json

toJSON :: forall a. Raw a -> Effect Json
toJSON = _toJSON

foreign import _back :: forall a. Int -> Node a -> Node a

back :: forall a. Int -> Node a -> Node a
back = _back

foreign import _off :: forall a. Node a -> Unit

off :: forall a. Node a -> Unit
off = _off
