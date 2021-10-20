module Gun.Configuration where


import Data.Maybe (Maybe)
import Data.Options (Option, opt, optional)
import Effect (Effect)
import Node.HTTP (Server)

foreign import data Configuration :: Type

fileOption :: Option Configuration (Maybe String)
fileOption = optional (opt "file")

peersOption :: Option Configuration (Maybe (Array String))
peersOption = optional (opt "peers")

webOption :: Option Configuration (Maybe Server)
webOption = optional (opt "web")

uuidOption :: Option Configuration (Maybe (Effect String))
uuidOption = optional (opt "uuid")