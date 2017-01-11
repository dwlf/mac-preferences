-- Restore Default Modifier Keys 
-- macOS Keyboard Preference AppleScript
#
# (C) Copyright 2016 Lloyd DB Dewolf
# License: MIT <https://spdx.org/licenses/MIT.html>
#
# Pre-condition: keyboard is the default keyboard
#
# Developed by trial and error on macOS Sierra 10.12.2 (16c67)

# Restart system preferences to make GUI state more predictable
if application "System Preferences" is running then
	tell application "System Preferences" to quit
	delay 1
end if

# Open system preferences to the Keyboard Pane
tell application "System Preferences"
	activate
	set the current pane to pane id "com.apple.preference.keyboard"
end tell

tell application "System Events"
	tell process "System Preferences"
		repeat until exists tab group 1 of window "Keyboard"
		end repeat
		click button "Modifier Keys…" of tab group 1 of window "Keyboard"
		click button "Restore Defaults" of sheet 1 of window "Keyboard"
		click button "OK" of sheet 1 of window "Keyboard"
	end tell
end tell

tell application "System Preferences" to quit
