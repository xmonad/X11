# Change Log / Release Notes

## unknown

  * Added `cWX`, `cWY`, `cWWidth`, `cWHeight` constants (`AttributeMask`) (#82)

  * Added `FocusChangeEvent` to `data Event` (#81)

  * Added `setWMNormalHints` (#83)

## 1.10.2 (2021-10-24)

  * Restored compatibility with GHC 7.10 (and possibly even older) (#80)

## 1.10.1 (2021-08-15)

  * Fixed possible high CPU usage of some blocking calls with the threaded RTS (#78)

## 1.10 (2021-05-31)

  * Added `setClientMessageEvent'` (#71)

  * Fixed type of `xrrUpdateConfiguration` (#72)

  * Fixed bottom when deserializing XRRNotifyEvent in `getEvent` (#72)

  * Added `xrrGetMonitors` and `XRRMonitorInfo` (#42)

  * Added `setClassHint` (#76)

  * Added a few missing event mask fields to `WindowAttributes` (#77)

## 1.9.2 (2020-08-25)

  * Make sure that X11 search paths determined by autoconf are actually passed
    through to Cabal. The fix was contributed by Greg Steuck (#53, #69).

  * Locate the include statement for `HsAllKeysyms.h` above the relevant ifdefs
    to avoid issues during cross compilation. The fix was contributed by
    Vanessa McHale (#65)

## 1.8 (February 9, 2017)

  * Added `deleteProperty`

  * Add SelectionClear event to xlib Extra
