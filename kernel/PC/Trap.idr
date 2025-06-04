module PC.Trap

import Core.Monad

%foreign "C:exit"
prim_exit : PrimIO ()

export
exit : Core ()
exit = liftIO $ primIO prim_exit
