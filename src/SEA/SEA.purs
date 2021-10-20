module Gun.SEA
  ( KeyPair
  , work
  , pair
  , sign
  , verify
  , encrypt
  , decrypt
  , secret
  , certify
  , AlgoType(..)
  , Encoding(..)
  , Certificate(..)
  , sHA256
  , pBKDF2
  , base64
  , base32
  , base16
  , WorkOptions(..)
  , algoOption
  , encodingOption
  , iterationsOptions
  , saltOptions
  , hashOptions
  ) where

import Prelude
import Control.Promise (Promise, toAffE)
import Data.Maybe (Maybe)
import Data.Options (Option, Options, opt, optional, options)
import Effect (Effect)
import Effect.Aff (Aff)
import Foreign (Foreign)

type KeyPair
  = { pub :: String
    , priv :: String
    , epub :: String
    , epriv :: String
    }

type AsymetricKeyPair
  = { pub :: String
    , priv :: String
    }

type PubKey
  = { pub :: String
    }

type EPriv
  = { epriv :: String
    }

type Certificate
  = { m ::
        { c :: String
        , w :: Array String
        }
    }

newtype AlgoType
  = AlgoType String

newtype Encoding
  = Encoding String

sHA256 = AlgoType "SHA-256" :: AlgoType

pBKDF2 = AlgoType "PBKDF2" :: AlgoType

base64 = Encoding "base64" :: Encoding

base32 = Encoding "base32" :: Encoding

base16 = Encoding "base16" :: Encoding

foreign import data WorkOptions :: Type

algoOption :: Option WorkOptions (Maybe AlgoType)
algoOption = optional (opt "name")

encodingOption :: Option WorkOptions (Maybe Encoding)
encodingOption = optional (opt "encode")

iterationsOptions :: Option WorkOptions (Maybe Number)
iterationsOptions = optional (opt "iterations")

saltOptions :: Option WorkOptions (Maybe String)
saltOptions = optional (opt "salt")

hashOptions :: Option WorkOptions (Maybe String)
hashOptions = optional (opt "hash")

foreign import _work :: forall a. KeyPair -> a -> Foreign -> Effect (Promise String)

work :: forall a. KeyPair -> a -> Options WorkOptions -> Aff String
work pair' obj opts = toAffE $ _work pair' obj (options opts)

foreign import _pair :: Effect (Promise KeyPair)

pair :: Aff KeyPair
pair = toAffE _pair

foreign import _sign :: forall a. AsymetricKeyPair -> a -> Effect (Promise String)

sign :: forall a. AsymetricKeyPair -> a -> Aff String
sign pair' obj = toAffE $ _sign pair' obj

foreign import _verify :: forall a. PubKey -> a -> Effect (Promise String)

verify :: forall a. PubKey -> a -> Aff String
verify pub obj = toAffE $ _verify pub obj

foreign import _encrypt :: forall a. EPriv -> a -> Effect (Promise String)

encrypt :: forall a. EPriv -> a -> Aff String
encrypt priv obj = toAffE $ _encrypt priv obj

foreign import _decrypt :: forall a. EPriv -> a -> Effect (Promise String)

decrypt :: forall a. EPriv -> a -> Aff String
decrypt priv obj = toAffE $ _decrypt priv obj

foreign import _secret :: KeyPair -> KeyPair -> Effect (Promise String)

secret :: KeyPair -> KeyPair -> Aff String
secret pairA pairB = toAffE $ _secret pairA pairB

foreign import _certify :: String -> Array String -> KeyPair -> Effect (Promise Certificate)

certify :: String -> Array String -> KeyPair -> Aff Certificate
certify pub paths pair' = toAffE $ _certify pub paths pair'
