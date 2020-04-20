import           Data.Function                  ( (&) )
import           Control.Monad                  ( join )

import           XMonad
import           XMonad.Config.Kde
import           XMonad.Layout.Spacing
import           XMonad.Util.EZConfig
import           XMonad.Actions.SpawnOn
import           XMonad.Hooks.ManageDocks

main =
  xmonad
    $                docks
    $                kdeConfig
                       { modMask    = mod4Mask
                       , layoutHook = myLayoutHook
                       , manageHook = manageDocks <+> myManagerHook <+> manageHook kdeConfig
                       , terminal   = myTerminal
                       }
    `additionalKeys` keymap
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

  myTerminal    = "alacritty"
  keymap        = [((mod4Mask, xK_p), spawn "rofi -show run")]

  uniformBorder = join $ join $ join Border
  border        = uniformBorder 4
  spacingHook   = spacingRaw True border True border True

  layouts       = Tall 1 (3 / 100) (1 / 2) ||| Full
  myLayoutHook  = desktopLayoutModifiers $ spacingHook layouts


