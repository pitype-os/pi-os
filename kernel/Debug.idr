module Debug

import Uart

export
trace : (msg : String) -> (result : a) -> a
trace x val = unsafePerformIO (do println x; pure val)
