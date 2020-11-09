import           Data.Function                  ( (&) )
import           Control.Monad                  ( join )

import           XMonad
import           XMonad.Config.Kde
import           XMonad.Util.EZConfig
import           XMonad.Actions.SpawnOn
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.EwmhDesktops      ( fullscreenEventHook )
import           XMonad.Hooks.EwmhDesktops      ( ewmh )

import           XMonad.Layout.Spacing
import           XMonad.Layout.ThreeColumns

main =
  xmonad
    $                 ewmh
    $                 docks
    $                 kdeConfig
                        { modMask = mod4Mask
                        , layoutHook = myLayoutHook
                        , manageHook = manageDocks <+> myManagerHook <+> manageHook kdeConfig
                        , handleEventHook = handleEventHook kdeConfig <+> fullscreenEventHook
                        , terminal = myTerminal
                        }
    `additionalKeysP` keymap
 where
  kdeFloats =
    [ "yakuake"
    , "Yakuake"
    , "Kmix"
    , "kmix"
    , "plasma"
    , "Plasma"
    , "plasma-desktop"
    , "Plasma-desktop"
    , "krunner"
    , "ksplashsimple"
    , "ksplashqml"
    , "ksplashx"
    ]

  myManagerHook =
    composeAll [ className =? name --> doFloat | name <- kdeFloats ]

  myTerminal = "alacritty"
  myBrowser  = "google-chrome-stable"

  -- TODO: find a way to bind all the program-opening-keybindings to a single sub-map
  keymap =
    [ ("M-p", spawn "rofi -show run")
    , ("M-g", spawn myBrowser)
    , ("M-d", spawn "Discord")
    , ("M-s", spawn "slack")
    , ("M-r", spawn "ksysgurad")
    ]

  uniformBorder = join $ join $ join Border
  border        = uniformBorder 4
  spacingHook   = spacingRaw True border True border True

  tall          = Tall 1 (3 / 100) (1 / 2)
  threeCols     = ThreeCol 1 (3 / 100) (1 / 2)

  layouts       = tall ||| threeCols ||| Full
  myLayoutHook  = desktopLayoutModifiers $ spacingHook layouts


