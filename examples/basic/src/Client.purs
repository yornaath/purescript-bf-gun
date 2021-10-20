module Examples.Basic.Client where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Examples.Basic.State (stateFromJson, stateToJson)
import Gun as Gun
import Gun.Configuration (Configuration, peersOption)

main :: Effect Unit
main = launchAff_ do
  let
    gunConfig :: Options Configuration
    gunConfig =
      peersOption := Just ["http://localhost:8080/gun"]

  gun <- liftEffect $ (Gun.create gunConfig)

  statenode <- liftEffect $ Gun.get stateFromJson stateToJson "state" gun

  pure $ trace statenode identity

  _ <- do  
    log "listening"
    _ <- liftEffect $ statenode # Gun.on (\d -> do 
      case d.data of 
        (Left _) -> do log "error parsing server message "
        (Right state) -> do log state.message
    )
    pure unit
      

  pure unit