module Test.Main where

import Prelude

import Data.Argonaut (Json, JsonDecodeError, decodeJson, encodeJson)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Timer (setInterval)
import Gun (toJSON)
import Gun as Gun
import Gun.Configuration (Configuration, fileOption, webOption)
import Gun.Node (Saveable(..))
import Gun.Query (Query, emptyQuery, from, map, on, once, onceExec, query)
import Gun.Query.Mapper (Mapper(..))

type RootData
  = { state :: String }

rootDataToJson :: RootData -> Json
rootDataToJson = encodeJson

rootDataFromJson :: Json -> Either JsonDecodeError RootData
rootDataFromJson = decodeJson

type UserData
  = { secret :: String }

userDataToJson :: UserData -> Json
userDataToJson = encodeJson

userDataFromJson :: Json -> Either JsonDecodeError UserData
userDataFromJson = decodeJson

userDataQuery :: forall a. Query ( secret :: String ) 
userDataQuery =
  emptyQuery
    # from "user"
    # from "data"
    # map Passthrough
    # onceExec \key d -> do
      jsondata <- (toJSON d)
      case userDataFromJson jsondata of 
        (Left error) ->
          pure $ trace {error} identity
        (Right data') -> 
          pure $ trace {data'} identity
      pure unit

main :: Effect Unit
main =
  launchAff_ do

    let
      gunConfig :: Options Configuration
      gunConfig =
        webOption := Nothing
          <> fileOption
          := Just "radata"

    let gun = (Gun.create gunConfig)
    let publicNode = Gun.get "public" gun
    let publicDataNode = Gun.get "data" publicNode
    let userNode = Gun.get "user" gun
    let userDataNode = Gun.get "data" userNode

    _ <-
      liftEffect
        $ setInterval 500 do
            let _ = userDataNode # Gun.put (SaveableRecord { secret: "some secrets" })
            let _ = publicDataNode # Gun.put (SaveableRecord { publicdata: "some public data" })
            pure unit

    let _ = query userDataQuery gun
    -- _ <- liftEffect $ query publicDataQuery gun
    -- usernode <- liftEffect $ User.user gun
    -- bob <- User.createUser "bob" "bobspass" usernode
    -- authed <- User.auth "bob" "bobspass" usernode
    -- case authed of
    --   (User.AuthSuccess auth) -> do
    --     pure $ trace "logged in" identity
    --     userDataNode <- liftEffect $ get "data" usernode
    --     _ <- do
    --       liftEffect $ userDataNode # on \d -> do pure $ trace { userNode: d } identity
    --     _ <-
    --       liftEffect
    --         $ setInterval 3000 do
    --             let _ = userDataNode # put { secret: "Hysjaass" }
    --             pure unit
    --     pure $ trace "exit" identity
    --   (User.AuthError { err }) -> do
    --     pure $ trace err identity
    pure unit
