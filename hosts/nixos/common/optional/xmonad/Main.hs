{-# LANGUAGE BlockArguments #-}

import Control.Monad (forM_, join)
import Data.Function ((&))
import System.Environment
import System.Process
import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Config
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Operations
import XMonad.Util.EZConfig

main =
  xmonad $
    ewmh $
      docks $
        def
          { modMask = mod4Mask,
            terminal = myTerminal,
            workspaces = myWorkspaces,
            borderWidth = 5,
            focusedBorderColor = "#{{base05-hex}}",
            normalBorderColor = "#{{base05-hex}}",
            startupHook = startup,
            layoutHook = avoidStruts myLayoutHook,
            manageHook = manageDocks <+> manageSpawn <+> manageHook def,
            handleEventHook = fullscreenEventHook <+> docksEventHook <+> handleEventHook def
          }
          `additionalKeysP` keymap
  where
    myWorkspaces =
      ["1:dev", "2:browser", "3:chat", "4:terminal", "5:reading", "6:gaming"]

    myTerminal = "alacritty"
    myBrowser = "firefox"

    keymap =
      [ ("M-p", spawn "rofi -show drun"),
        ("M-w", spawn "rofi -show window"),
        ("M-g", spawn myBrowser),
        ("M-d", spawn "Discord"),
        ("M-v", spawn "alacritty -e 'vimclip'"),
        ("M-s", spawn "spectacle -rcb"),
        ("M-S-s", spawn "spectacle -mcb"),
        ("M-C-s", spawn "spectacle -ucb"),
        ("M-f", sendMessage ToggleStruts),
        ("M-c", kill)
      ]

    uniformBorder = join $ join $ join Border
    border = uniformBorder 0
    spacingHook = spacingRaw False border False border True

    tall = Tall 1 (3 / 100) (1 / 2)

    layouts = tall ||| Full
    myLayoutHook = spacingHook layouts

    startupApps = []
    -- [ (0, "alacritty"),
    --   (1, "google-chrome-stable"),
    --   (2, "Discord")
    -- ]

    startup :: X ()
    startup = do
      forM_ startupApps \(index, app) -> do
        spawnOn (myWorkspaces !! index) app
