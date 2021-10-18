module Gun (
  GunNode(..),
  Response(..),
  RawNode(..),
  create,
  opt,
  get,
  put,
  on,
  once,
  map,
  back,
  off
) where

import Prelude
import Control.Promise (Promise, toAffE)
import Data.Argonaut (class DecodeJson, class EncodeJson, Json, JsonDecodeError)
import Data.Either (Either)
import Data.Gun.Configuration (Configuration)
import Data.Options (Options)
import Effect (Effect)
import Effect.Aff (Aff)

data GunNode a
  = GunNode a

type RawNode a = {}

type Response a
  = { data :: Either JsonDecodeError a, key :: String, raw :: RawNode a }

foreign import _create :: forall a. Options Configuration -> GunNode a

create :: forall a. Options Configuration -> GunNode a
create = _create

foreign import _opt :: forall a. Options Configuration -> GunNode a -> GunNode a

opt :: forall a. Options Configuration -> GunNode a -> GunNode a
opt = _opt

foreign import _get :: forall a b. ((Json -> Either JsonDecodeError b)) -> (b -> Json) -> String -> GunNode a -> GunNode b

get :: forall a b. EncodeJson a => DecodeJson a => ((Json -> Either JsonDecodeError b)) -> (b -> Json) -> String -> GunNode a -> GunNode b
get = _get

foreign import _put :: forall a. a -> GunNode a -> GunNode a

put :: forall a. a -> GunNode a -> GunNode a
put = _put

foreign import _on :: forall a. (Response a -> Effect Unit) -> GunNode a -> Effect Unit

on :: forall a. (Response a -> Effect Unit) -> GunNode a -> Effect Unit
on = _on

foreign import _once :: forall a. (Response a -> Effect Unit) -> GunNode a -> Effect Unit

once :: forall a. (Response a -> Effect Unit) -> GunNode a -> Effect Unit
once = _once

foreign import _map :: forall a. (Response a -> Effect Unit) -> GunNode a -> Effect Unit

map :: forall a. (Response a -> Effect Unit) -> GunNode a -> Effect Unit
map = _map


foreign import _back :: forall a b. Int -> GunNode a -> GunNode b

back :: forall a b. Int -> GunNode a -> GunNode b
back = _back

foreign import _off :: forall a. GunNode a -> Effect Unit

off :: forall a. GunNode a -> Effect Unit
off = _off

-- foreign import notImpl :: forall a. GunNode a -> Effect (Promise (Record (key :: String)))
-- not :: forall a. GunNode a -> Aff (Record (key :: String))
-- not = notImpl >>> toAffE
