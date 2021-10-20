module Gun.User where

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

foreign import _user :: forall a. Node a -> Effect (Node a)

user :: forall a. Node a -> Effect (Node a)
user = _user

foreign import _createUser :: forall a. (CreatedErrorPayload -> CreateAck) -> (CreatedSuccessPayload -> CreateAck) -> String -> String -> Node a -> Effect (Promise CreateAck)

createUser :: forall a. String -> String -> Node a -> Aff CreateAck
createUser alias pass node = toAffE $ _createUser CreatedError CreatedSuccess alias pass node

foreign import _auth :: forall a. (AuthErrorPayload -> AuthAck) -> (AuthSuccessPayload -> AuthAck) -> String -> String -> Node a -> Effect (Promise AuthAck)

auth :: forall a. String -> String -> Node a -> Aff AuthAck
auth alias pass node = toAffE $ _auth AuthError AuthSuccess alias pass node
