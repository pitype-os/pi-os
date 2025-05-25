module Core.Monad

public export
record Core a where
  constructor MkCore
  unCore: IO a

public export
runCore : Core a -> IO a
runCore = unCore

public export
liftIO : IO a -> Core a
liftIO = MkCore

public export
Functor Core where
  map f (MkCore m) = MkCore (map f m)

public export
Applicative Core where
  pure x = MkCore (pure x)
  (MkCore m1) <*>  xm2 = MkCore $ m1 <*> runCore xm2

public export
Monad Core where
  (MkCore m1) >>= xm2 = MkCore $ runCore . xm2 =<< m1


