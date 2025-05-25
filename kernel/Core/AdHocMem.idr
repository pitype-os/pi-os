module Core.AdHocMem

import Core.Addr
import Core.Monad
import Core.Storable

public export
peek : (Storable a) => Ptr a -> Core a
peek p = liftIO $ peek p

public export
poke : (Storable a) => Ptr a -> a -> Core ()
poke p x = liftIO $ poke p x


