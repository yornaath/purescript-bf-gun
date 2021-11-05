module Examples.Chat.Client where

import Prelude

import Control.Coroutine as CR
import Control.Coroutine.Aff (emit)
import Control.Coroutine.Aff as CRA
import Data.Either (Either(..))
import Data.JSDate (now, toString)
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Debug (trace)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Examples.Chat.Client.Components.Chat (Message(..))
import Examples.Chat.Client.Components.Chat as Chat
import Examples.Chat.State (DatedMessage, serverMessageFromJson, serverMessageToJson)
import Gun as Gun
import Gun.Configuration (Configuration, peersOption)
import Gun.Node (Node, Saveable(..), getData)
import Gun.Query.Mapper (Mapper(..))
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.Subscription as HS
import Halogen.VDom.Driver (runUI)

-- A producer coroutine that emits messages that arrive from the websocket.
gunProducer :: Node () -> CR.Producer DatedMessage Aff Unit
gunProducer socket = CRA.produce \emitter -> do
  let chat = Gun.map Passthrough socket
  let _ = chat # Gun.on (\key raw -> do
                            let message = getData (SaveableRaw raw)
                            case serverMessageFromJson message of 
                              (Left error) -> do 
                                log "error parsing server message error:"
                                pure $ trace error identity
                              (Right message') -> do
                                log key
                                emit emitter { text: message'.text, date: key }
  )
  pure unit

-- A consumer coroutine that takes the `query` function from our component IO
-- record and sends `ReceiveMessage` queries in when it receives inputs from the
-- producer.
gunConsumer :: (forall a. Chat.Query a -> Aff (Maybe a)) -> CR.Consumer DatedMessage Aff Unit
gunConsumer query = CR.consumer \msg -> do
  void $ query $ H.mkTell $ Chat.ReceiveMessage msg
  pure Nothing

-- A handler for messages from our component IO that sends them to the server
-- using the websocket
gunSender :: Node () -> Chat.Message -> Effect Unit
gunSender chatnode message = do
  case message of 
    OutputMessage message' -> do 
      let messagenode = Gun.get message'.date chatnode
      let _ = Gun.put (SaveableRecord { text: message'.text }) messagenode
      pure unit

main :: Effect Unit
main = do

  let
    gunConfig :: Options Configuration
    gunConfig =
      peersOption := Just ["http://localhost:8080/gun"]

  let gun = Gun.create gunConfig

  let chatnode = Gun.get "chat" gun

  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI Chat.component unit body

    -- Subscribe to all output messages from our component
    _ <- H.liftEffect $ HS.subscribe io.messages $ gunSender chatnode

    -- Connecting the consumer to the producer initializes both,
    -- feeding queries back to our component as messages are received.
    CR.runProcess (gunProducer chatnode CR.$$ gunConsumer io.query)

-- import Prelude

-- import Data.Either (Either(..))
-- import Data.Maybe (Maybe(..))
-- import Data.Options (Options, (:=))
-- import Debug (trace)
-- import Effect (Effect)
-- import Effect.Aff (launchAff_)
-- import Effect.Class (liftEffect)
-- import Effect.Class.Console (log)
-- import Examples.Basic.State (stateFromJson, stateToJson)
-- import Gun as Gun
-- import Gun.Configuration (Configuration, peersOption)

-- main :: Effect Unit
-- main = launchAff_ do
--   let
--     gunConfig :: Options Configuration
--     gunConfig =
--       peersOption := Just ["http://localhost:8080/gun"]

--   gun <- liftEffect $ (Gun.create gunConfig)

--   statenode <- liftEffect $ Gun.get stateFromJson stateToJson "state" gun

--   pure $ trace statenode identity

--   _ <- do  
--     log "listening"
--     _ <- liftEffect $ statenode # Gun.on (\d -> do 
--       case d.data of 
--         (Left _) -> do log "error parsing server message "
--         (Right state) -> do log state.message
--     )
--     pure unit
      

--   pure unit