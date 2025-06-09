module Pi.Main

import Core.Monad
import Core.Pages
import PC.Trap
import PC.Uart

main : IO ()
main = runCore $ do
  println "Welcome to PI OS!"
  exit



