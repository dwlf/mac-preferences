#!/bin/bash
#
# (C) Copyright 2018 Lloyd DB Dewolf
# License: MIT <https://spdx.org/licenses/MIT.html>
#
# Developed by trial and error on macOS High Sierra 10.13.3 (17D102)
#
# Pre-condition: logged in as an admin user and that is the user
# you want to configure.
#
# Should be safe to re-run and rerun.

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
fi

which vi | grep -q /usr/local/bin
if [[ $? != 0 ]] ; then
	brew install vim --with-override-system-vi
fi

# Install homeshick 
brew install homeshick

homeshick list | grep -q dotfiles
if [[ $? != 0 ]] ; then
	homeshick clone -batch https://github.com/lloydde/dotfiles
fi

homeshick list | grep -q dotzsh
if [[ $? != 0 ]] ; then
	homeshick clone --batch https://github.com/lloydde/dotzsh
fi

## Useful in scenario were re-running to get updates.
homeshick link --force

# junegunn/vim-plug will install on first launch of vim
vim +qa!
# Upgrade vim-plug and install/update all plugins
vim +PlugUpgrade +PlugUpdate +qa!


# Install mas: Mac App Store command line interface
brew install mas

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
                  flux \
                  omnioutliner evernote skitch \
                  nvalt \
                  slack skype \
                  vlc \
                  openoffice

# Sonos is not in main caskroom, but instead in a separate "drivers" :(
brew tap caskroom/drivers
brew cask install sonos

	# Trying

	## <None currently> ##

	# Computer / Hardware specific

# TODO make this computer specific
# Current cask installs 3.2L31, but that doesn't work on macOS 10.12.2
# Clicking update in the apps help menu gets the correct version, 3.2 L91
### brew cask install scansnap-manager-s1300


# Install Apps that are not available on brew cask
# ie apps that are only available on Mac App Store


mas account | grep -q '^Not'
if [[ $? == 0 ]] ; then
	# Currently broken in mas 1.4.1
	# https://github.com/mas-cli/mas/issues/107#issuecomment-367383144
	### mas signin $(cat .appleid)
	echo "Please sign in to Mac App Store"
	exit 1
fi

iMovieProductID=$(mas search imovie | egrep '\d+\s+iMovie\s+\(' | awk '{print $1}')
mas install $iMovieProductID




# Thanks to
#
# https://www.davd.eu/os-x-automated-provisioning-using-homebrew-and-cask/
#
# Homebrew & homebrew code on checking if CLT installed
# also fd0 for http://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed/219708#219708
