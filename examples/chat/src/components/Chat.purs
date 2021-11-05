module Examples.Chat.Client.Components.Chat where

import Prelude

import Data.Array as A
import Data.JSDate (now, toString)
import Data.Map as M
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..), fst, snd)
import Effect.Class (class MonadEffect, liftEffect)
import Examples.Chat.State (DatedMessage)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Web.Event.Event (Event)
import Web.Event.Event as Event

type Slot = H.Slot Query Message

data Query a = ReceiveMessage DatedMessage a

data Message = OutputMessage DatedMessage

data Action
  = HandleInput String
  | Submit Event

type State = 
  { messages :: M.Map String String
  , inputText :: String
  }

component :: forall i m. MonadEffect m => H.Component Query i Message m 
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = handleAction
        , handleQuery = handleQuery
        }
    }

initialState :: forall i. i -> State
initialState _ = { messages: M.fromFoldable [], inputText: "" }

sortMessages :: M.Map String String -> Array String
sortMessages messages = M.toUnfoldable messages # A.sortBy (\a b -> if fst a > fst b then GT else LT ) # map snd

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.form
    [ HE.onSubmit Submit ]
    [ HH.ol_ $ map (\msg -> HH.li_ [ HH.text msg ]) $ sortMessages state.messages
    , HH.text "test"
    , HH.input
        [ HP.type_ HP.InputText
        , HP.value (state.inputText)
        , HE.onValueInput HandleInput
        ]
    , HH.button
        [ HP.type_ HP.ButtonSubmit ]
        [ HH.text "Send Message" ]
    ]

handleAction :: forall m. MonadEffect m => Action -> H.HalogenM State Action () Message m Unit
handleAction = case _ of
  HandleInput text -> do
    H.modify_ (_ { inputText = text })
  Submit ev -> do
    H.liftEffect $ Event.preventDefault ev
    date <- liftEffect now
    st <- H.get
    let outgoingMessage = {text: st.inputText, date: (toString date)}
    H.raise $ OutputMessage outgoingMessage

handleQuery :: forall m a. Query a -> H.HalogenM State Action () Message m (Maybe a)
handleQuery = case _ of
  ReceiveMessage msg a -> do
    H.modify_ \st -> st { messages = M.insert msg.date msg.text st.messages }
    pure (Just a)