module Gun
  ( ListenerResponse(..)
  , create
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
import Data.Argonaut (class DecodeJson, class EncodeJson, Json, JsonDecodeError)
import Data.Either (Either)
import Data.Gun.Configuration (Configuration)
import Data.Options (Options, options)
import Effect (Effect)
import Foreign (Foreign)
import Gun.SEA (Certificate)
import Gun.Node (Node, RawNode)

foreign import _create :: forall a. Foreign -> Effect (Node a)

create :: forall a. Options Configuration -> Effect (Node a)
create opts = _create (options opts)

foreign import _opt :: forall a. Options Configuration -> Node a -> Effect (Node a)

opt :: forall a. Options Configuration -> Node a -> Effect (Node a)
opt = _opt

foreign import _get :: forall a b. ((Json -> Either JsonDecodeError b)) -> (b -> Json) -> String -> Node a -> Effect (Node b)

get :: forall a b. EncodeJson b => DecodeJson b => ((Json -> Either JsonDecodeError b)) -> (b -> Json) -> String -> Node a -> Effect (Node b)
get = _get

foreign import _put :: forall a. a -> Node a -> Effect (Node a)

put :: forall a. a -> Node a -> Effect (Node a)
put = _put

foreign import _set :: forall a. a -> Node a -> Effect (Node a)

set :: forall a. a -> Node a -> Effect (Node a)
set = _set

foreign import _putWithCertificate :: forall a. Certificate -> a -> Node a -> Effect (Node a)

putWithCertificate :: forall a. Certificate -> a -> Node a -> Effect (Node a)
putWithCertificate = _putWithCertificate

type ListenerResponse a
  = { data :: Either JsonDecodeError a, key :: String, raw :: RawNode a }

foreign import _on :: forall a. (ListenerResponse a -> Effect Unit) -> Node a -> Effect Unit

on :: forall a. (ListenerResponse a -> Effect Unit) -> Node a -> Effect Unit
on = _on

foreign import _once :: forall a. (ListenerResponse a -> Effect Unit) -> Node a -> Effect Unit

once :: forall a. (ListenerResponse a -> Effect Unit) -> Node a -> Effect Unit
once = _once

foreign import _map :: forall a. (ListenerResponse a -> Effect Unit) -> Node a -> Effect Unit

map :: forall a. (ListenerResponse a -> Effect Unit) -> Node a -> Effect Unit
map = _map

foreign import _back :: forall a. Int -> Node a -> Effect (Node a)

back :: forall a. Int -> Node a -> Effect (Node a)
back = _back

foreign import _off :: forall a. Node a -> Effect Unit

off :: forall a. Node a -> Effect Unit
off = _off
