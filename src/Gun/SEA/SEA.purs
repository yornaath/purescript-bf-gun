module Gun.SEA (
  KeyPair,
  pair,
  sign
) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Gun.Configuration (Configuration)
import Data.Options (Options)
import Effect (Effect)
import Effect.Aff (Aff)

type KeyPair = {
  pub :: String,
  priv :: String,
  epub :: String,
  epriv :: String
}

type AsymetricKeyPair = {
  pub :: String,
  priv :: String
}

foreign import _pair :: Effect (Promise KeyPair)

pair :: Aff KeyPair
pair = toAffE _pair

foreign import _sign :: forall a. AsymetricKeyPair -> a -> Effect (Promise String)

sign :: forall a. AsymetricKeyPair -> a -> Aff String
sign pair' obj = toAffE $ _sign pair' obj
