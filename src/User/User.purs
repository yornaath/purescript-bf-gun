module Gun.User
  ( CreateAck(..)
  , AuthAck(..)
  , AuthSuccessPayload
  , CreatedSuccessPayload
  , CreatedErrorPayload
  , AuthErrorPayload
  , DeleteSuccessPayload
  , user
  , userAt
  , createUser
  , auth
  , recall
  , leave
  , delete
  ) where

import Prelude
import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)
import Gun.Node(Node)

data CreateAck
  = CreatedSuccess CreatedSuccessPayload
  | CreatedError CreatedErrorPayload

data AuthAck
  = AuthSuccess AuthSuccessPayload
  | AuthError AuthErrorPayload

type AuthSuccessPayload
  = { ack :: Int, get :: String, id :: String, pub :: String, ok :: Int, soul :: String }

type CreatedSuccessPayload
  = { pub :: String, ok :: Int }

type CreatedErrorPayload
  = { err :: String }

type AuthErrorPayload
  = { err :: String }

type DeleteSuccessPayload
  = { ok :: Int }

foreign import _user :: forall a. Node a -> Effect (Node a)

user :: forall a.  Node a -> Effect (Node a)
user = _user

foreign import _userAt :: forall a. String -> Node a -> Effect (Node a)

userAt :: forall a. String -> Node a -> Effect (Node a)
userAt = _userAt

foreign import _createUser :: forall a.  (CreatedErrorPayload -> CreateAck) -> (CreatedSuccessPayload -> CreateAck) -> String -> String -> Node a -> Effect (Promise CreateAck)

createUser :: forall a. String -> String -> Node a -> Aff CreateAck
createUser alias pass node = toAffE $ _createUser CreatedError CreatedSuccess alias pass node

foreign import _auth :: forall a. (AuthErrorPayload -> AuthAck) -> (AuthSuccessPayload -> AuthAck) -> String -> String -> Node a -> Effect (Promise AuthAck)

auth :: forall a. String -> String -> Node a -> Aff AuthAck
auth alias pass node = toAffE $ _auth AuthError AuthSuccess alias pass node

foreign import _recall :: forall a. (AuthErrorPayload -> AuthAck) -> (AuthSuccessPayload -> AuthAck) -> Node a -> Effect (Promise AuthAck)

recall :: forall a. Node a -> Aff AuthAck
recall node = toAffE $ _recall AuthError AuthSuccess node

foreign import _leave :: forall a.  Node a -> Effect (Node a)

leave :: forall a. Node a -> Effect (Node a)
leave = _leave

foreign import _delete :: forall a. String -> String -> Node a -> Effect (Promise DeleteSuccessPayload)

delete :: forall a. String -> String -> Node a -> Aff DeleteSuccessPayload
delete alias pass node = toAffE $ _delete alias pass node
