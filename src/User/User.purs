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
import Gun.Node (Node)

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

foreign import _user :: Node -> Effect (Node)

user ::  Node -> Effect (Node)
user = _user

foreign import _userAt :: String -> Node -> Effect (Node)

userAt :: String -> Node -> Effect (Node)
userAt = _userAt

foreign import _createUser ::  (CreatedErrorPayload -> CreateAck) -> (CreatedSuccessPayload -> CreateAck) -> String -> String -> Node -> Effect (Promise CreateAck)

createUser :: String -> String -> Node -> Aff CreateAck
createUser alias pass node = toAffE $ _createUser CreatedError CreatedSuccess alias pass node

foreign import _auth ::  (AuthErrorPayload -> AuthAck) -> (AuthSuccessPayload -> AuthAck) -> String -> String -> Node -> Effect (Promise AuthAck)

auth :: String -> String -> Node -> Aff AuthAck
auth alias pass node = toAffE $ _auth AuthError AuthSuccess alias pass node

foreign import _recall ::  (AuthErrorPayload -> AuthAck) -> (AuthSuccessPayload -> AuthAck) -> Node -> Effect (Promise AuthAck)

recall :: Node -> Aff AuthAck
recall node = toAffE $ _recall AuthError AuthSuccess node

foreign import _leave ::  Node -> Effect (Node)

leave ::  Node -> Effect (Node)
leave = _leave

foreign import _delete ::  String -> String -> Node -> Effect (Promise DeleteSuccessPayload)

delete :: String -> String -> Node -> Aff DeleteSuccessPayload
delete alias pass node = toAffE $ _delete alias pass node
