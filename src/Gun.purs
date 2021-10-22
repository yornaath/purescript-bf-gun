module Gun
  ( create
  , opt
  , get
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
import Data.Options (Options, options)
import Effect (Effect)
import Foreign (Foreign)
import Gun.Configuration (Configuration)
import Gun.Node (Node, Raw, Saveable)
import Gun.SEA (Certificate)

foreign import _create :: forall a. Foreign -> Effect (Node a)

create :: forall a. Options Configuration -> Effect (Node a)
create opts = _create (options opts)

foreign import _opt :: forall a. Options Configuration -> Node a -> Effect (Node a)

opt :: forall a. Options Configuration -> Node a -> Effect (Node a)
opt = _opt

foreign import _get :: forall a b. String -> Node a -> Effect (Node b)

get :: forall a b. String -> Node a -> Effect (Node b)
get = _get

foreign import _put :: forall a. Saveable a -> Node a -> Effect (Node a)

put :: forall a. Saveable a -> Node a -> Effect (Node a)
put = _put

foreign import _set :: forall a. Saveable a -> Node a -> Effect (Node a)

set :: forall a. Saveable a -> Node a -> Effect (Node a)
set = _set

foreign import _putWithCertificate :: forall a. Certificate -> Saveable a -> Node a -> Effect (Node a)

putWithCertificate :: forall a. Certificate -> Saveable a -> Node a -> Effect (Node a)
putWithCertificate = _putWithCertificate

foreign import _on :: forall a. (Raw a -> Effect Unit) -> Node a -> Effect (Node a)

on :: forall a. (Raw a -> Effect Unit) -> Node a -> Effect (Node a)
on = _on

foreign import _once :: forall a. (Raw a -> Effect Unit) -> Node a -> Effect (Node a)

once :: forall a. (Raw a -> Effect Unit) -> Node a -> Effect (Node a)
once = _once

foreign import _map :: forall a b. (Saveable a -> Saveable b) -> Node a -> Effect (Node b)

map :: forall a b. (Saveable a -> Saveable b) -> Node a -> Effect (Node b)
map = _map

foreign import _back :: forall a. Int -> Node a -> Effect (Node a)

back :: forall a. Int -> Node a -> Effect (Node a)
back = _back

foreign import _off :: forall a. Node a -> Effect Unit

off :: forall a. Node a -> Effect Unit
off = _off
