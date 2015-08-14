-- | This example requires `purescript-node-readline` to be installed.

module Test.Main where

import Prelude

import Control.Monad.Eff.Console

import Signal
import Signal.Loop (Emitter(), runLoop)
import Signal.Channel (send)

import Node.ReadLine

main = do
  interface <- createInterface noCompletion

  let makePrompt :: String -> Emitter _ String
      makePrompt s c = do
        setPrompt ">" 2 interface
        setLineHandler (send c) interface
        case s of
          "" -> return unit
          s  -> log $ "You typed: " ++ s
        prompt interface
        return s

  -- The loop reads the most recently entered string from the "future" signal
  -- and uses the makePrompt function to display it.
  runLoop "" \future -> makePrompt <$> future
