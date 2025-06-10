module Librairies.Debug.Trace

import Core.Monad
import PC.Uart

export
trace : (msg : String) -> (result : a) -> a
trace x val = unsafePerformIO (do runCore $ println x; pure val)
