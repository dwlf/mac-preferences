#!/bin/bash
#
# (C) Copyright 2016 Lloyd DB Dewolf
# License: MIT <https://spdx.org/licenses/MIT.html>
#
# Developed by trial and error on macOS Sierra 10.12.2 (16c67)
#
# Pre-condition: logged in as an admin user and that is the user
# you want to configure.
#
# Should be safe to re-run and rerun.


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
fi

which vi | grep -q /usr/local/bin
if [[ $? != 0 ]] ; then
	brew install vim --with-override-system-vi
fi


# Install my homeshicks

if [ ! -d $HOME/.homesick/repos/homeshick ]; then
	git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
fi

type -t homeshick | grep -q function
if [[ $? != 0 ]] ; then
	source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fi

homeshick list | grep -q dotfiles
if [[ $? != 0 ]] ; then
	homeshick clone -batch https://github.com/lloydde/dotfiles
fi

homeshick list | grep -q dotzsh
if [[ $? != 0 ]] ; then
	homeshick clone --batch https://github.com/lloydde/dotzsh
fi

# Useful in scenario were re-running to get updates.
homeshick link --force

# junegunn/vim-plug will install on first launch of vim
vim +qa!
# Upgrade vim-plug and install/update all plugins
vim +PlugUpgrade +PlugUpdate +qa!


# Install mas: Mac App Store command line interface
brew install mas

# Install and use up-to-date version
brew install zsh
chsh -s $(which zsh)

# Install more CLI tools
brew install hilite ag hub

# If I'm rerunning, then update installed brews
brew upgrade


## end UNIX ##


## Files & Links

### iCloud Filesystem
if [ ! -L ~/notes ]; then
	ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/notes ~/notes
fi

## end Files & Links


## System Preferences

osascript apple-scripts/keyboard-cfg.applescript

## end System Preferences


## .apps ##

# Install Apps
brew cask install dropbox \
                  atom sourcetree \
                  docker \
                  firefox brave \
                  atext \
                  sonos flux \
                  omnioutliner evernote skitch \
                  nvalt \
                  slack skype \
                  vlc \
                  openoffice

	# Trying
brew cask install anki

	# Computer / Hardware specific
# TODO make this computer specific
# Current cask installs 3.2L31, but that doesn't work on macOS 10.12.2
# Clicking update in the apps help menu gets the correct version, 3.2 L91
### brew cask install scansnap-manager-s1300

# Install Apps that are not available on brew cask
# ie apps that are only available on Mac App Store

iMovieProductID=$(mas search imovie | grep -x '\d*\s*iMovie$' | awk '{print $1}')
mas install $iMovieProductID




# Thanks to
#
# https://www.davd.eu/os-x-automated-provisioning-using-homebrew-and-cask/
#
# Homebrew & homebrew code on checking if CLT installed
# also fd0 for http://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed/219708#219708
