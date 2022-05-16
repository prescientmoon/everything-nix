{-# LANGUAGE BlockArguments #-}

import Control.Monad (join)
import Data.Function ((&))
import System.Environment
import System.Process
import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Config (defaultConfig)
import XMonad.Config.Kde
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Operations
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders

kdeOn :: Bool
kdeOn = False

-- startingConfig = if kdeOn then kdeConfig else defaultConfig

main =
  xmonad $
    ewmh $
      docks $
        defaultConfig
          { modMask = mod4Mask,
            layoutHook = myLayoutHook,
            startupHook = startup,
            manageHook = manageDocks <+> myManagerHook <+> manageHook kdeConfig,
            handleEventHook = handleEventHook kdeConfig <+> fullscreenEventHook,
            terminal = myTerminal,
            workspaces = myWorkspaces,
	    borderWidth = 0
          }
          `additionalKeysP` keymap
  where
    myWorkspaces =
      ["1:dev", "2:browser", "3:chat", "4:terminal", "5", "6", "7", "8", "9", "0"]

    appWorkspaceConfig =
      [ (3, "Discord"),
        (4, "alacritty"),
        (2, "google-chrome-stable")
      ]

    manageWorkspaces =
      appWorkspaceConfig
        & fmap \(workspaceId, name) -> do
          let workspaceName = myWorkspaces !! (workspaceId - 1)
          className =? name --> doShift workspaceName

    kdeFloats =
      [ "yakuake",
        "Yakuake",
        "Kmix",
        "kmix",
        "plasma",
        "Plasma",
        "plasma-desktop",
        "Plasma-desktop",
        "krunner",
        "ksplashsimple",
        "ksplashqml",
        "ksplashx"
      ]

    floatKdeStuff = [className =? name --> doFloat | name <- kdeFloats]

    myManagerHook =
      composeAll $
        concat
          [ if kdeOn then floatKdeStuff else [],
            manageWorkspaces
          ]

    myTerminal = "alacritty"
    myBrowser = "google-chrome-stable"

    -- TODO: find a way to bind all the program-opening-keybindings to a single sub-map
    keymap =
      [ ("M-p", spawn "rofi -show drun"),
        ("M-w", spawn "rofi -show window"),
        ("M-g", spawn myBrowser),
        ("M-d", spawn "Discord"),
        ("M-v", spawn "alacritty -e vimclip"),
        ("M-c", kill)
      ]

    uniformBorder = join $ join $ join Border
    border = uniformBorder 4
    spacingHook = spacingRaw True border True border True

    tall = Tall 1 (3 / 100) (1 / 2)
    threeCols = ThreeCol 1 (3 / 100) (1 / 2)

    layouts = tall ||| threeCols ||| Full
    myLayoutHook = desktopLayoutModifiers $ spacingHook layouts

    startup :: X ()
    startup = do
      -- The file is dynamically set in wallpaper.nix
      spawn "xwallpaper --zoom ~/.config/wallpaper"
