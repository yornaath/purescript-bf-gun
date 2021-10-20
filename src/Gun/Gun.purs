module Gun
  ( Node(..)
  , Response(..)
  , RawNode(..)
  , user
  , create
  , opt
  , get
  , put
  , putWithCertificate
  , on
  , once
  , map
  , back
  , off
  , CreatedSuccessPayload
  , CreatedErrorPayload
  , CreateAck(..)
  , AuthSuccessPayload
  , AuthErrorPayload
  , AuthAck(..)
  , createUser
  , auth
  ) where

import Prelude
import Control.Promise (Promise, toAffE)
import Data.Argonaut (class DecodeJson, class EncodeJson, Json, JsonDecodeError)
import Data.Either (Either)
import Data.Gun.Configuration (Configuration)
import Data.Options (Options, options)
import Effect (Effect)
import Effect.Aff (Aff)
import Foreign (Foreign)
import Gun.SEA (Certificate)

data Node a
  = Node a
  | UserNode a

type RawNode :: forall k. k -> Type
type RawNode a
  = {}

type Response a
  = { data :: Either JsonDecodeError a, key :: String, raw :: RawNode a }

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

foreign import _putWithCertificate :: forall a. Certificate -> a -> Node a -> Effect (Node a)

putWithCertificate :: forall a. Certificate -> a -> Node a -> Effect (Node a)
putWithCertificate = _putWithCertificate

foreign import _on :: forall a. (Response a -> Effect Unit) -> Node a -> Effect Unit

on :: forall a. (Response a -> Effect Unit) -> Node a -> Effect Unit
on = _on

foreign import _once :: forall a. (Response a -> Effect Unit) -> Node a -> Effect Unit

once :: forall a. (Response a -> Effect Unit) -> Node a -> Effect Unit
once = _once

foreign import _map :: forall a. (Response a -> Effect Unit) -> Node a -> Effect Unit

map :: forall a. (Response a -> Effect Unit) -> Node a -> Effect Unit
map = _map

foreign import _back :: forall a. Int -> Node a -> Effect (Node a)

back :: forall a. Int -> Node a -> Effect (Node a)
back = _back

foreign import _off :: forall a. Node a -> Effect Unit

off :: forall a. Node a -> Effect Unit
off = _off

foreign import _user :: forall a. Node a -> Effect (Node a)

user :: forall a. Node a -> Effect (Node a)
user = _user

type CreatedSuccessPayload
  = { pub :: String, ok :: Int }

type CreatedErrorPayload
  = { err :: String }

data CreateAck
  = CreatedSuccess CreatedSuccessPayload
  | CreatedError CreatedErrorPayload

type AuthSuccessPayload
  = { ack :: Int, get :: String, id :: String, pub :: String, ok :: Int, soul :: String }

type AuthErrorPayload
  = { err :: String }

data AuthAck
  = AuthSuccess AuthSuccessPayload
  | AuthError AuthErrorPayload

foreign import _createUser :: forall a. (CreatedErrorPayload -> CreateAck) -> (CreatedSuccessPayload -> CreateAck) -> String -> String -> Node a -> Effect (Promise CreateAck)

createUser :: forall a. String -> String -> Node a -> Aff CreateAck
createUser alias pass node = toAffE $ _createUser CreatedError CreatedSuccess alias pass node

foreign import _auth :: forall a. (AuthErrorPayload -> AuthAck) -> (AuthSuccessPayload -> AuthAck) -> String -> String -> Node a -> Effect (Promise AuthAck)

auth :: forall a. String -> String -> Node a -> Aff AuthAck
auth alias pass node = toAffE $ _auth AuthError AuthSuccess alias pass node

-- foreign import notImpl :: forall a. Node a -> Effect (Promise (Record (key :: String)))
-- not :: forall a. Node a -> Aff (Record (key :: String))
-- not = notImpl >>> toAffE
