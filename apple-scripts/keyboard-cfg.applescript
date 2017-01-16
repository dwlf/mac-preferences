-- Swap Control & Command keys, and set Caps Lock to Esc 
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
		
		-- Set Caps Lock key to Escape press
		# Caps Lock Key (button 2 found by trial and error)
		tell pop up button 2 of sheet 1 of window "Keyboard"
			click
			tell menu 1
				click menu item "⎋ Escape"
			end tell
		end tell
		
		-- Switch Control and Command keys
		# Select Control Key (button 3 found by trial and error)
		tell pop up button 3 of sheet 1 of window "Keyboard"
			click
			tell menu 1
				click menu item "⌘ Command"
			end tell
		end tell
		# Select Command Key (button 1 found by trial and error)
		tell pop up button 1 of sheet 1 of window "Keyboard"
			click
			tell menu 1
				click menu item "⌃ Control"
			end tell
		end tell
		
		click button "OK" of sheet 1 of window "Keyboard"
	end tell
end tell

tell application "System Preferences" to quit

# Thank you to
# https://www.macosxautomation.com/applescript/features/system-prefs.html
# 
# "wait for it"
# http://apple.stackexchange.com/questions/209352/applescript-cant-get-tab-group-1-of-window-el-capitan/209434#209434

