{-
Ideas/TODO:
- Create simple declarative "conky script creation API" to avoid string programming
- Don't reference home dir
-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts #-}
import XMonad hiding ((|||))
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import XMonad.Layout.LayoutCombinators
import XMonad.Layout.ResizableTile
import XMonad.Layout.Master
import XMonad.Layout.Tabbed

import qualified XMonad.StackSet as W
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig
    (additionalKeys, additionalMouseBindings)
import System.IO (Handle, hPutStrLn, hPutStr)
import Data.Monoid (Endo, All)

--------------------
-- Basic Settings --
--------------------

homeDir :: String
homeDir = "/home/fiendfan1"

myTerminal :: String
myTerminal = "terminator"

myBorderWidth :: Dimension
myBorderWidth = 1

-- | mod4 is Windows key
myModMask :: KeyMask
myModMask = mod4Mask

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
 
myWorkspaces :: [String]
myWorkspaces =
    clickable . map dzenEscape $ ["1 Development", "2 Web", "3 Music", "4", "5"]
  where
    clickable :: [String] -> [String]
    clickable labels =
        [
        "^ca(1,xdotool key super+"++show i++")"++label++"^ca()"
            | (i, label) <- zip [(1::Int)..] labels
        ]

myNormalBorderColor :: String
myNormalBorderColor = "#424242"
myFocusedBorderColor :: String
myFocusedBorderColor = "#007BFF"

wallpaperImage :: FilePath
wallpaperImage = homeDir ++ "/Theme Assets/haskell_pink.png"

--------------------
-- Keymap configs --
--------------------

myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
    [
    -- Toggle the status bar gap.
    ((myModMask, xK_b ), sendMessage ToggleStruts),

    -- Volume control.
    ((myModMask, xK_u), spawn "amixer -D pulse set Master 2%+"),
    ((myModMask, xK_y), spawn "amixer -D pulse set Master 2%-"),

    -- Vertical Resize ResizableTall windows.
    -- !!! These Override default keys !!!
    ((myModMask, xK_j), sendMessage MirrorShrink),
    ((myModMask, xK_k), sendMessage MirrorExpand),

    -- Set the keys 'i' and 'o' to the default actions of
    -- 'j' and 'k', respectively.
    ((myModMask, xK_i), windows W.focusDown),
    ((myModMask, xK_o), windows W.focusUp)
    ]

-- | Mouse bindings.
myMouseBindings :: [((KeyMask, Button), Window -> X ())]
myMouseBindings = []

------------
-- Layout --
------------

-- !!!!!!!!!!!!!!
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
-- !!!!!!!!!!!!!!
myLayout = avoidStruts $ tallLayout {- ||| hybridLayout-} ||| Full

-- | A tall layout where all windows on right
--   side can be resized vertically.
tallLayout :: ResizableTall a
tallLayout = ResizableTall 1 0.03 0.5 []

-- | Tabbed layout.
tabLayout = tabbed shrinkText tabTheme
-- | Theme applied to tabbed layout.
tabTheme :: Theme
tabTheme = def {
    inactiveBorderColor = "#FF0000",
    activeTextColor = "#00FF00"
    }

-- | A layout that puts the master window on the
--   left side, and all other windows on the
--   right, in a tabbed layout.
hybridLayout = mastered 0.03 0.5 tabLayout

------------------
-- Window rules --
------------------

-- | Execute arbitrary actions and WindowSet manipulations when managing
--   a new window. You can use this to, for example, always float a
--   particular program, or have a client always appear on a particular
--   workspace.
--
--   To find the property name associated with a program, use
--   > xprop | grep WM_CLASS
--   and click on the client you're interested in.
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll [
    className =? "lotroclient.exe" --> doFloat,
    className =? "Wine" --> doFloat,
--    className =? "MPlayer"        --> doFloat,
--    className =? "Gimp"           --> doFloat,
--    resource  =? "desktop_window" --> doIgnore,
--    resource  =? "kdesktop"       --> doIgnore,
    manageDocks
    ]

-----------------------
-- Handle Event Hook --
-----------------------

myHandleEventHook :: Event -> X All
myHandleEventHook =
    handleEventHook def <+> docksEventHook

----------------
-- XMonad Bar --
----------------

-- | Base dzen command.
dzenBaseCommand :: String
dzenBaseCommand = "dzen2 -dock -fg '" ++ dzenForeground ++
                "' -bg '" ++ dzenBackground ++
                "' -fn \"" ++ dzenFont ++ "\""

-- | Command to launch the left bar.
dzenBar :: String
dzenBar = dzenBaseCommand ++ " -w '"++dzenSize++"' -x '0'"

-- | Width of left dzen bar.
dzenSizei :: Int
dzenSizei = 1024
dzenSize :: String
dzenSize = show dzenSizei

-- | Font used on entire bar.
dzenFont :: String
dzenFont = "Ubuntu:size=13:antialias=true"

-- Colors --

dzenBackground :: String
dzenBackground = "#000000"
dzenForeground :: String
dzenForeground = "#FFFFFF"

dzenNormal :: String -> String
dzenNormal = dzenColor dzenForeground dzenBackground . pad

dzenFocus :: String -> String
dzenFocus = dzenColor "#DEDEDE" "#121212" . pad

dzenUnfocus :: String -> String
dzenUnfocus = dzenColor "#393939" dzenBackground . pad

dzenHidden :: String -> String
dzenHidden = dzenColor "#6D9CBE" dzenBackground . pad

dzenUrgent :: String -> String
dzenUrgent = dzenColor "#FF0000" dzenBackground . pad

dzenLayout :: String -> String
dzenLayout = dzenHidden

dzenOutput :: Handle -> String -> IO ()
dzenOutput outHandle xmonadLog = do
    hPutStr outHandle $
        "^i(" ++ homeDir ++ "/.xmonad/icons/images/arch_logo_mine.xbm)  |  "
    hPutStrLn outHandle xmonadLog

-- | A hook to transform log information.
myLogHook :: Handle -> X ()
myLogHook handle =
    dynamicLogWithPP $ def {
        ppCurrent         = dzenFocus,
        ppVisible         = dzenNormal,
        ppHidden          = dzenHidden,
        ppHiddenNoWindows = dzenUnfocus,
        ppUrgent          = dzenUrgent,
        ppLayout          = dzenLayout,
        ppTitle           = (" " ++) .
                            dzenNormal .
                            dzenEscape,
        ppWsSep           = " ",
        ppSep             = "  |  ",
        ppOutput          = dzenOutput handle
    }

---------------
-- Conky Bar --
---------------

-- | Start the conky bar with conkyConfig.
startConkyBar :: IO ()
startConkyBar = do
    writeFile (homeDir ++ "/.xmonad/.conky_dzen") conkyConfig
    spawn conkyBar

-- | Base conky command.
conkyCommand :: String
conkyCommand = "conky -c " ++ homeDir ++ "/.xmonad/.conky_dzen"

-- | Command to start conky with output being
--   directed to a new dzen bar.
conkyBar :: String
conkyBar = conkyCommand ++ " | " ++
           dzenBaseCommand ++ " -w '"++conkySize++"' -x '"++dzenSize++"'"

-- | My screen is 1920px wide.
conkySize :: String
conkySize = show $ 1920 - dzenSizei

conkyConfig :: String
conkyConfig =
    -- Conky settings.
    "background yes\nout_to_console yes\nout_to_x no\n" ++
    "update_interval 1.0\ncpu_avg_samples 2\n" ++

    -- Begin content.
    "TEXT\n" ++

    -- Volume display.
    "^i(" ++ homeDir ++ "/.xmonad/icons/images/spkr_01.xbm)  " ++
    "^fg(\\#0055FF)${exec amixer -D pulse get Master | " ++
    "egrep -o [0-9]+% | head -n1}  " ++

{-
    -- Full Per-Core CPU usage display.
    "^fg()|  ^i(" ++ homeDir ++ "/.xmonad/icons/images/cpu.xbm)  " ++
    "^fg(\\#FF0055)${cpu cpu1}% ${cpu cpu2}% " ++
    "${cpu cpu3}% ${cpu cpu4}% ${cpu cpu5}% ${cpu cpu6}% ${cpu cpu7}% ${cpu cpu8}%^fg()  |  " ++
-}

    -- Summary CPU usage display.
    "^fg()|  ^i(" ++ homeDir ++ "/.xmonad/icons/images/cpu.xbm)  " ++
    "^fg(\\#FF0055)${cpu}%^fg()  |  " ++

    -- RAM usage display.
    "^i(" ++ homeDir ++ "/.xmonad/icons/images/mem.xbm)  " ++
    "^fg(\\#55FF00)${mem} ^fg()  |  " ++

    -- GPU usage display. I am using an AMD GPU. TODO fix use open source driver
    {-
    "^i(" ++ homeDir ++ "/.xmonad/icons/images/pacman.xbm)  " ++
    "^fg(\\#D4FF00)${exec aticonfig --odgc --adapter=0" ++
    " | grep \"GPU load\" | egrep -o \"[0-9]+%\"}" ++
    "^fg()  | " ++
    -}

    -- CPU temp display.
    "^i(" ++ homeDir ++ "/.xmonad/icons/images/temp.xbm)  " ++
    "^fg(\\#FF0055)${exec sensors | grep temp1 | egrep -o \"[0-9.]+°C\" " ++
    "| head -n1} ^fg()  |  " ++

    -- Time display.
    "^i(" ++ homeDir ++ "/.xmonad/icons/stlarch/clock1.xbm)  " ++
    "^fg(\\#0055FF)${time %l:%M %p}" ++
    "\n"

------------------
-- Startup hook --
------------------
 
-- | Perform an arbitrary action each time xmonad starts or is restarted
--   with mod-q.
myStartupHook :: X ()
myStartupHook = do
    setWMName "LG3D"
    io $ setWallpaper wallpaperImage
    --io comptonStart

-- | Start compton with config file.
comptonStart :: IO ()
comptonStart = spawn $ "compton --config " ++ homeDir ++ "/.compton.conf"

-- | Set wallpaper.
setWallpaper :: FilePath -> IO ()
setWallpaper file = spawn $ "feh --bg-fill \""++file++"\""

----------
-- Main --
----------

main :: IO ()
main = do
    dzenHandle <- spawnPipe dzenBar
    startConkyBar
    xmonad $ myConfig dzenHandle

myConfig barHandle = def {
    -- Simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
 
    -- Hooks, layouts...
    layoutHook         = myLayout,
    manageHook         = myManageHook,
    logHook            = myLogHook barHandle,
    startupHook        = myStartupHook,
    handleEventHook    = myHandleEventHook
    } `additionalKeys` myKeys
      `additionalMouseBindings` myMouseBindings
