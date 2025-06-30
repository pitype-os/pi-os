module Main

import Data.C.Ptr
import Data.IORef
import Pages
import Trap
import Uart

import Data.List

%export "urefc:Main_kinit"
kinit : IO Nat
kinit = pure 10

main : IO ()
main = do
  println "Welcome to PI-OS!"
  testPages
  exit





