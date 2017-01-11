#!/bin/bash
#
# (C) Copyright 2016 Lloyd DB Dewolf
# License: MIT <https://spdx.org/licenses/MIT.html>
#
# Developed by trial and error on macOS Sierra 10.12.2 (16c67)
#
# Pre-condition: logged in as an admin user and the user you want to configure.

# Check if my login shell is zsh or set it to zsh
dscacheutil -q user -a name `whoami` | grep zsh
if [[ $? != 0 ]] ; then
	chsh -s /bin/zsh
fi



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


# Install CLI tools
brew install hilite ag 
brew install vim --with-override-system-vi

# Install Apps
brew cask install dropbox \
                  atext \
                  omnioutliner evernote skitch \
                  nvalt \
                  docker \
                  slack skype \
                  vlc \
                  openoffice




# Thanks to
#
# https://www.davd.eu/os-x-automated-provisioning-using-homebrew-and-cask/
#
# Homebrew & homebrew code on checking if CLT installed
# also fd0 for http://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed/219708#219708
