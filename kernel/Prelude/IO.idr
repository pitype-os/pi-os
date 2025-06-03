module Prelude.IO

import Builtin
import Prelude.PrimIO
import Prelude.Basics
import Prelude.Interfaces

%default total

--------
-- IO --
--------

public export
Functor IO where
  map f io = io_bind io $ io_pure . f

%inline
public export
Applicative IO where
  pure x = io_pure x
  f <*> a
      = io_bind f (\f' =>
          io_bind a (\a' =>
            io_pure (f' a')))

%inline
public export
Monad IO where
  b >>= k = io_bind b k

public export
interface Monad io => HasIO io where
  constructor MkHasIO
  liftIO : IO a -> io a

public export
interface Monad io => HasLinearIO io where
  constructor MkHasLinearIO
  liftIO1 : (1 _ : IO a) -> io a

public export %inline
HasLinearIO IO where
  liftIO1 x = x

public export %inline
HasLinearIO io => HasIO io where
  liftIO x = liftIO1 x

export %inline
primIO : HasIO io => (fn : (1 x : %World) -> IORes a) -> io a
primIO op = liftIO (fromPrim op)

export %inline
primIO1 : HasLinearIO io => (1 fn : (1 x : %World) -> IORes a) -> io a
primIO1 op = liftIO1 (fromPrim op)
