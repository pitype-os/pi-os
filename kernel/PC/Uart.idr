module PC.Uart

import Core.Addr
import Core.AdHocMem
import Core.Monad
import Core.Storable

UART : Ptr Char
UART = plusAddr nullPtr 0x10000000
  where 
    nullPtr: Ptr Char
    nullPtr = (prim__castPtr prim__getNullAnyPtr)

export
println: String -> Core ()
println xs = println' (unpack xs)
  where 
    println': List Char -> Core ()
    println' [] = poke UART '\n'
    println' (x :: xs) = do
      poke UART x
      println' xs

