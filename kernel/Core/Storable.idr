module Core.Storable

import Core.Addr

public export
interface Storable a where
  size : Int

  peek: HasIO io => Ptr a -> io a
  poke: HasIO io => Ptr a -> a -> io ()

public export
Storable Bits8 where
  size = prim__sizeOfBits8

  peek ptr = readBits8Addr ptr
  poke ptr v = setBits8OffAddr ptr 0 v

public export
Storable Bits16 where
  size = prim__sizeOfBits16

  peek ptr = readBits16Addr ptr
  poke ptr v = setBits16OffAddr ptr 0 v

public export
Storable Bits32 where
  size = prim__sizeOfBits32

  peek ptr = readBits32Addr ptr
  poke ptr v = setBits32OffAddr ptr 0 v

public export
Storable Bits64 where
  size = prim__sizeOfBits64

  peek ptr = readBits64Addr ptr
  poke ptr v = setBits64OffAddr ptr 0 v

public export
Storable Double where
  size = prim__sizeOfDouble

  peek ptr = readDoubleAddr ptr
  poke ptr v = setDoubleOffAddr ptr 0 v

public export
Storable Char where
  size = prim__sizeOfChar

  peek ptr = readCharAddr ptr
  poke ptr v = setCharOffAddr ptr 0 v

