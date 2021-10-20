module Gun.Node where 

data Node a
  = Node a
  | UserNode a

type RawNode :: forall k. k -> Type
type RawNode a
  = {}