#!/bin/bash
#
# (C) Copyright 2018 Lloyd DB Dewolf
# License: MIT <https://spdx.org/licenses/MIT.html>
#
# Developed by trial and error on macOS Catalina 10.15.2 (19C57)
#
# Pre-condition: logged in as an admin user and that is the user
# you want to configure.
#
# Should be safe to re-run and rerun.
#
### TODO rewrite this in Python Plumbum as any of my time spent 
###      in Bash is lostly


# Need to be on the Internet to download software to install
if ping -c 1 google.com >> /dev/null 2>&1; then
    echo "Computer is online. Continuing..."
else
    echo "Could not ping Google, therefore computer does not appear to be online."
    exit 1
fi


## UNIX ##

# Homebrew requires Apple Command Line Tools (CLT) are installed

pkgutil --pkg-info com.apple.pkg.CLTools_Executables >/dev/null 2>&1
if [[ $? != 0 ]] ; then
	# CLT is not installed
	echo 'XCode Command Line Tools (CLT) are not installed. Run `git`'
	echo 'or any other included tool to interactively install CLT.'
	exit
fi

which -s brew
if [[ $? != 0 ]] ; then
	echo "Homebrew is not installed. Installing now..."
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "Brewing fresh brew..."
	brew update
	# If I'm rerunning, then update installed brews
	brew upgrade
fi


### Brew vim as Apple is always going to be behind
brew install vim


# Install homeshick 
brew install homeshick

homeshick list | grep -q dotfiles
if [[ $? != 0 ]] ; then
	homeshick clone --batch https://github.com/lloydde/dotfiles
fi
### TODO need to set push to ssh first time


# TODO linking every time is too slow even without --force
#      Too slow for improving the script.
## Useful in scenario were re-running to get updates.
# homeshick link


# junegunn/vim-plug will install on first launch of vim
vim +qa!
# Upgrade vim-plug and install/update all plugins
vim +PlugUpgrade +PlugUpdate +qa!


# Install up-to-date version of zsh
brew install zsh

cat /etc/shells | grep -q $(which zsh)
if [[ $? != 0 ]] ; then
	sudo bash -c "echo $(which zsh) >> /etc/shells"
fi

# Need shell to already be in /etc/shells
cat /etc/shells | grep -q $(which zsh)
if [[ $? == 0 ]] ; then
	## Check if my login shell is zsh, else prompt me to change
	## to up-to-date version of zsh
	dscacheutil -q user -a name `whoami` | grep zsh
	if [[ $? != 0 ]] ; then
		chsh -s $(which zsh)
	fi
fi


# Install more CLI tools
brew install hilite ag hub


## end UNIX ##


## .apps ##

# Install mas: Mac App Store command line interface
brew install mas

# Install Apps that available in Mac App Store (mas)

mas account | grep -q '^Not'
if [[ $? == 0 ]] ; then
	# Currently broken in mas 1.4.1
	# https://github.com/mas-cli/mas/issues/107#issuecomment-367383144
	### TODO Fixed, but I've decided adding appleid as file is overkill
	### I probably just delete this `signin` line
	### mas signin $(cat .appleid)
	echo "Please sign in to Mac App Store and then run again."
	exit 1
fi

# List updates and upgrade
# Do this first as I don't want to not list the individual updates
# installed in this script
mas outdated
mas upgrade


# 1Password 7
passwordProductID=$(mas search 1password | egrep '\d+\s+1Password 7 - Password Manager\s+\('| awk '{print $1}')
mas install $passwordProductID

# Things 3
thingsProductID=$(mas search things | egrep '\d+\s+Things 3\s+\(' | awk '{print $1}')
mas install $thingsProductID

# iMovie
iMovieProductID=$(mas search imovie | egrep '\d+\s+iMovie\s+\(' | awk '{print $1}')
mas install $iMovieProductID

# Slack
slackProductID=$(mas search slack | egrep '\d+\s+Slack\s+\(' | awk '{print $1}')
mas install $slackProductID



### TODO favor Apple Store versions 
###      If there is a mas version then I should install
###      from App Store as additional security review
###      A more compelling reason is updating using mas

# Install Apps
brew cask install --appdir=~/Applications dropbox \
                  cryptomator \
                  shiftit \
                  firefox brave-browser google-chrome \
                  flycut \ # Based on Jumpcut
		  atext \
                  flux \
                  omnioutliner evernote skitch \
                  nvalt \
                  slack skype \
                  vlc \
                  openoffice

# Requires sudo
brew cask install google-drive-file-stream

# Sonos is not in main caskroom, but instead in a separate "drivers" :(
brew tap homebrew/cask-drivers
brew cask install --appdir=~/Applications sonos

	# Trying

		## <None currently> ##

	# Computer / Hardware specific

		## <None currently> ##




### TODO if preferences files don't exist (first run) then I should open
###      recently installed application. For example, get Dropbox sync'd.


### TODO make this computer specific
# Current cask installs 3.2L31, but that doesn't work on macOS 10.12.2
# Clicking update in the apps help menu gets the correct version, 3.2 L91
#
### brew cask install scansnap-manager-s1300

# Installed on Kitten as it runs hot
### brew cask install smcfancontrol


## Files & Links

# iCloud Filesystem
if [ ! -L ~/notes ]; then
	ln -s ~/Dropbox/notes/ ~/notes
fi

# Google Drive File Stream
if [ ! -L ~/gdrive ]; then
	ln -s /Volumes/GoogleDrive/My\ Drive ~/gdrive
fi

## end Files & Links




## System Preferences

# Change check for macOS updates from weekly to daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Finder

defaults write com.apple.finder AppleShowAllFiles -bool TRUE
killall Finder


# Dock

brew install dockutil

defaults write com.apple.dock orientation left
defaults write com.apple.Dock autohide -bool TRUE
defaults write com.apple.Dock showhidden -bool TRUE
defaults write com.apple.dock autohide-time-modifier -float 0.5
killall Dock

dockutil --remove Siri --no-restart
dockutil --remove Launchpad --no-restart
dockutil --remove Safari --no-restart
dockutil --remove Contacts --no-restart
dockutil --remove Notes  --no-restart
dockutil --remove Reminders --no-restart
dockutil --remove Maps --no-restart
dockutil --remove Photos --no-restart
dockutil --remove FaceTime --no-restart
dockutil --remove iTunes --no-restart
dockutil --remove iBooks --no-restart
dockutil --remove "App Store" --no-restart
dockutil --remove "System Preferences" --no-restart
dockutil --add /Applications/Things3.app --position 1 --no-restart
dockutil --add /Applications/Google\ Chrome.app --position 2 --no-restart
dockutil --add /Applications/Mail.app --position 3 --no-restart
# Calendar
dockutil --add /Applications/Messages.app --position 5 --no-restart
dockutil --add /Applications/Slack.app --position 6 --no-restart
dockutil --add /Applications/OmniOutliner.app --position 7

# Keyboards

osascript apple-scripts/keyboard-cfg.applescript



# Thanks to
#
# https://www.davd.eu/os-x-automated-provisioning-using-homebrew-and-cask/
#
# Homebrew & homebrew code on checking if CLT installed
# also fd0 for http://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed/219708#219708
