module Examples.Basic.Client where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Gun as Gun
import Gun.Configuration (Configuration, peersOption)

main :: Effect Unit
main = launchAff_ do
  let
    gunConfig :: Options Configuration
    gunConfig =
      peersOption := Just ["http://localhost:8080/gun"]

  gun <- liftEffect $ (Gun.create gunConfig)

  messages <- liftEffect $ Gun.get "state" gun
  people <- liftEffect $ Gun.get "people" gun

  _ <- do  
  
    log "listening"

    _ <- liftEffect $ messages # Gun.on (\state -> do
      pure $ trace {state} identity
    )

    mappedPeople <- liftEffect $ people # Gun.map identity

    _ <- liftEffect $ mappedPeople # Gun.on (\person ->
      pure $ trace {person} identity
    )
    
    pure unit
      

  pure unit