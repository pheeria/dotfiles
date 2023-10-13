-- https://apple.stackexchange.com/a/463067
--
-- 1. Automator -> Quick Action -> Run Applescript
-- 2. Paste the following code and save as 'fuckzoom'
-- 3. Settings -> Keyboard -> Shortcuts -> Services -> General -> fuckzoom
-- 4. Assign to Cmd + Option + Ctrl + H and unbind Zoom's global shortcut
-- 5. Profit

tell application "System Events"
    set targetAppName to "zoom.us"
    set toolBarWindowName to "zoom share toolbar window"
    set statusBarWindowName to "zoom share statusbar window"
    
    if (get name of every application process) contains targetAppName then
        tell process targetAppName
            
            -- Get the list of windows for the target application
            set targetWindows to every window
            
            set toolBarWindow to ""
            set statusBarWindow to ""
            
            -- Find the window by its name
            repeat with targetWindow in targetWindows
                if name of targetWindow is statusBarWindowName then
                    set statusBarWindow to targetWindow
                else if name of targetWindow is toolBarWindowName then
                    set toolBarWindow to targetWindow
                end if
            end repeat
            
            if toolBarWindow is not "" then
                set {statusBarX, statusBarY} to position of statusBarWindow
                set {statusBarWidth, statusBarHeight} to size of statusBarWindow
                
                set {toolBarX, toolBarY} to position of toolBarWindow
                set {toolBarWidth, toolBarHeight} to size of toolBarWindow
                
                if toolBarY ≥ 0 then
                    -- Move the window outside the screen area
                    set position of toolBarWindow to {toolBarX, -toolBarHeight}
                    set position of statusBarWindow to {statusBarX, -statusBarHeight}
                else
                    -- Show window
                    set position of statusBarWindow to {statusBarX, toolBarHeight}
                    set position of toolBarWindow to {toolBarX, 0}
                end if
            end if
        end tell
    end if
    
end tell
