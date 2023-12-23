--
-- The Holy and Sacred Allusive XMonad Configurations
--
--     "they say it makes the world go round!"
--

-- Import Statements
import XMonad
import Data.Monoid ()
import System.Exit ()
import XMonad.Util.SpawnOnce
import Control.Monad ( join, when )
import XMonad.Hooks.ManageDocks
    ( avoidStruts, docks, manageDocks, Direction2D(D, L, R, U) )
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
    ( Direction2D(D, L, R, U),
      gaps,
      setGaps,
      GapMessage(ToggleGaps) )

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Hooks.DynamicLog
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

-- Layouts
import XMonad.Layout.ThreeColumns
import XMonad.Actions.TiledWindowDragging
import XMonad.Layout.Named
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Renamed
import XMonad.Layout.IndependentScreens

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Maybe (maybeToList)
import qualified Codec.Binary.UTF8.String as UTF8

-- Variables (based)
myTerminal      = "kitty"
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myClickJustFocuses :: Bool
myClickJustFocuses = False
myBorderWidth   = 0
myModMask       = mod4Mask
myAltMask       = mod1Mask

------------------------------------------------------------------------
-- KEY BINDINGS
------------------------------------------------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- lock screen
    , ((modm,               xK_F1        ), spawn "betterlockscreen -l")

    -- rofi launcher
    , ((myAltMask,          xK_space     ), spawn "rofi -show drun -theme ~/.config/rofi/launcher.rasi")

    -- Toggle fullscreen for any window
    , ((modm,               xK_F2        ), spawn "wmctrl -r :ACTIVE: -b toggle,fullscreen")

    --, ((modm,               xK_space     ), spawn "rofi -lines 10 -padding 0 -show search -modi search:ddg-ff-search -i -p 'Search: '")

    -- clipboard toggle
    , ((modm,               xK_v         ), spawn "sh ~/.flake/setup/scripts/copyq.sh")

    -- close focused window
    , ((modm .|. shiftMask, xK_c         ), spawn "sh ~/.flake/setup/scripts/kill.sh")

    -- KEYCHRON V1 BINDINGS

    -- Knob Turn Left
    , ((0,                  0x1008ffb0   ), spawn "wpctl set-volume @DEFAULT_SINK@ 5%-")

    -- Knob Turn Right
    , ((0,                  0x1008ffb1   ), spawn "wpctl set-volume @DEFAULT_SINK@ 5%+")

    , ((0,                  0x1008ff47   ), spawn "sh ~/.flake/setup/scripts/mute-toggle.sh")

    -- Knob Press
    , ((0,                  0x1008ffb2   ), spawn "playerctl play-pause")

    --  End Keychron Bindings

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space     ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n         ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab       ), windows W.focusDown)

    -- Top mouse button runs multimedia play/pause
    , ((0,                  0x1008ff14   ), spawn "playerctl play-pause"  )

    -- Front mouse key switches to previous song
    , ((myAltMask,          xK_bracketleft  ), spawn "playerctl previous")

    -- Back mouse key switches to next song
    , ((myAltMask,          xK_bracketright ), spawn "playerctl next")

    -- Push window back into tiling
    , ((modm,               xK_t         ), withFocused $ windows . W.sink)

    -- Take a screenshot
    ,((modm .|. shiftMask, xK_s          ), spawn "flameshot gui")

    -- Run the powermenu
    , ((modm .|. shiftMask, xK_q         ), spawn "sh ~/.config/rofi/powermenu.sh")

    -- Restart xmonad
    , ((modm              , xK_q         ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    [((m .|. modm, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_bracketleft, xK_bracketright, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Forces window into floating mode and is now draggable whilst holding MOD + Left
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- Switches the window that is currently in focus with the master window.
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- Whilst holding MOD + Right enables resizing of window by moving laterally.
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    , ((myAltMask, button1), dragWindow)

    -- Holding MOD + Scroll Down, Shrinks/Expands the current window down
    , ((modm, 5), const $ sendMessage Expand)
    -- Holding MOD + Scroll Up, Shrinks/Expands the current window Up
    , ((modm, 4), const $ sendMessage Shrink)

    , ((modm .|. shiftMask, button1), const $ withFocused $ windows . W.sink)

    ]

------------------------------------------------------------------------
mySpacing i = spacingRaw False (Border 0 0 0 i) True (Border i 0 i 0) True
mySpacingVert i = spacingRaw False (Border 0 0 0 0) True (Border i i 0 0) True
myOuterGaps = gaps [(XMonad.Layout.Gaps.L,10), (XMonad.Layout.Gaps.R,10), (XMonad.Layout.Gaps.U,0), (XMonad.Layout.Gaps.D,30)]
myOuterGapsVert = gaps [(XMonad.Layout.Gaps.L,30), (XMonad.Layout.Gaps.R,30), (XMonad.Layout.Gaps.U,20), (XMonad.Layout.Gaps.D,20)]

tall     = renamed [Replace "Tiled"]
           $ avoidStruts
           $ myOuterGaps
           $ mySpacing 20
           $ Tall 1 (3/100) (1/2)
three    = renamed [Replace "Three"]
           $ avoidStruts
           $ mySpacingVert 10
           $ myOuterGapsVert
           $ Mirror (ThreeCol 1 (3/100) (1/2))
mirror   = renamed [Replace "Mirror"]
           $ mySpacing 10
           $ myOuterGapsVert
           $ Mirror (Tall 1 (3/100) (1/2))
full     = renamed [Replace "Full"]
           $ avoidStruts
           $ Full

myLayout = onWorkspaces [ "1_\984479", "1_\60100", "1_\984180" ] myVerticalLayout $ myDefaultLayout
  where
    myDefaultLayout = tall
    myVerticalLayout = three

------------------------------------------------------------------------

myManageHook = manageDocks <+> composeAll
    [ className =? "feh"            --> doFloat
    , title     =? "Borkski"        --> doFloat
    , title     =? "Friends List"   --> doFloat
    , title     =? "Steam - News"   --> doFloat
    , title     =? "Quit GIMP"      --> doFloat
    , title     =? "Change Foreground Color" --> doFloat
    , className =? "copyq"          --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen --> doFullFloat
    ]

------------------------------------------------------------------------
-- Event handling

-- Currently not utilised.

myEventHook = mempty

------------------------------------------------------------------------

myLogHook = updatePointer (0.5, 0.5) (0, 0)

------------------------------------------------------------------------

--myLeftPP = statusBarProp "xmobar ~/.config/xmobar/xmobarrc-left" (pure pp)

--myRightPP = statusBarProp "xmobar ~/.config/xmobar/xmobarrc-right" (pure pp)

pp = xmobarPP {
          ppCurrent = xmobarColor "#c77889" "" -- . wrap ("<box type=Bottom width=2 mb=5 color=#6690C4>") "</box>"
          , ppVisible = xmobarColor "#6C0C27" ""
          , ppHidden = const "" -- xmobarColor "#0D111A" "" . wrap "*" ""
          , ppTitle = const ""
          , ppSep = "<fc=#FFFFFF> <fn=1> |</fn> </fc>"
          , ppWsSep = "  "
          -- , ppExtras = [windowCount]
          , ppOrder = \(ws:l:t:ex) -> [ws]++ex++[t]
}

------------------------------------------------------------------------

myStartupHook = do
  spawnOnce "nvidia-settings --load-config-only"
  spawnOnce "emacs --daemon"
  spawnOnce "compfy -b"
  spawnOnce "feh --bg-fill ~/.flake/setup/gruvbox-japan.png"
  spawnOnce "copyq &"
  spawnOnce "polybar &"
  spawnOnce "alarm-clock-applet --hidden"
  spawnOnce "element-desktop"
  spawnOnce "firefox 'https://wol.jw.org/en/wol/h/r1/lp-e'"
  spawnOnce "sh ~/.flake/setup/scripts/lights.sh"

------------------------------------------------------------------------

main :: IO ()
main = xmonad
       . docks
       . ewmhFullscreen
       . ewmh
       -- . withSB myLeftPP
       -- . withSB myRightPP
       $ myConfig

------------------------------------------------------------------------

myConfig = def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = [marshall s vw | vw <- ["\984479", "\60100", "\984180"], s <- [0, 1]],
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        logHook            = myLogHook,
        manageHook         = myManageHook,
        layoutHook         = myLayout,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook
}
