module Uart

import Data.C.Ptr

UART : AnyPtr
UART = prim__inc_ptr prim__getNullAnyPtr  0x10000000 1

export
println: String -> IO ()
println xs = println' (unpack xs)
  where 
    println': List Char -> IO ()
    println' [] = setPtr UART $ cast {to=Bits8} '\n'
    println' (x :: xs) = do
      setPtr UART $ cast {to=Bits8} x
      println' xs

