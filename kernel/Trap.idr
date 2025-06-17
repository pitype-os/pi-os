module Trap

%foreign "C:exit"
prim_exit : PrimIO ()

export
exit : IO ()
exit = primIO prim_exit
