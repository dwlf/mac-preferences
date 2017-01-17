-- Configure "Flickr Uploader"
-- Set "Flickr Uploadr" menu bar icon to black & white
#
# (C) Copyright 2017 Lloyd DB Dewolf
# License: MIT <https://spdx.org/licenses/MIT.html>
#
# Developed by trial and error on macOS Sierra 10.12.2 (16c67)

# Initiate "Flickr Uploadr" so I can adjust the preferencs
tell application "Flickr Uploadr" to launch
delay 1
tell application "Flickr Uploadr" to quit
delay 1
do shell script "defaults write com.yahoo.flickrmac TrayIconBW -bool YES"
tell application "Flickr Uploadr" to launch
