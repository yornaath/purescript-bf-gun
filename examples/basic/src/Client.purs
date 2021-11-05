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

  let gun = Gun.create gunConfig

  let messages = Gun.get "messages" gun
  let people = Gun.get "people" gun

  _ <- do  
  
    log "listening"

    let _ = messages # Gun.on (\key message ->
      pure $ trace {message} identity
    )
    
    let mappedPeople = people # Gun.map Passthrough

    let _ = mappedPeople # Gun.on (\key person ->
      pure $ trace {person} identity
    )
    
    pure unit

  pure unit