module Examples.Basic.Client where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Class.Console (log)
import Gun as Gun
import Gun.Configuration (Configuration, peersOption)
import Gun.Query.Mapper (Mapper(..))

main :: Effect Unit
main = do
  let
    gunConfig :: Options Configuration
    gunConfig =
      peersOption := Just ["http://localhost:8080/gun"]

  gun <- Gun.create gunConfig

  messages <- Gun.get "messages" gun
  people <- Gun.get "people" gun

  _ <- do  
  
    log "listening"

    _ <- messages # Gun.on \message -> do pure $ trace {message} identity
    
    mappedPeople <- people # Gun.map Passthrough

    let __ = mappedPeople # Gun.on (\person ->
                                      pure $ trace {person} identity
    )
    
    pure unit

  pure unit