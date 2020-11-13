#!/bin/bash

###################################################################################
# To use...
# bash <(curl https://raw.githubusercontent.com/gdev/dotfile/master/dotfile.sh)
###################################################################################

# Ask for sudo
if sudo --validate; then
    # Keep-alive
    while true; do sudo --non-interactive true; \
        sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Obtaining sudo credentials failed."
    exit 1
fi

###################################################################################
# Homebrew
###################################################################################

echo "Installing Homebrew..."
if ! hash brew 2>/dev/null; then
    if /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null; then
        echo "Homebrew installation succeeded."
    else
        echo "Homebrew installation failed."
        exit 1
    fi
fi

brew install wget

###################################################################################
# Github...
###################################################################################

mkdir ~/GitHub
brew cask install github

###################################################################################
# Hostname and .dotfiles storage
###################################################################################

mkdir ~/.dotfiles

HOSTNAME=~/.dotfiles/hostname
if ! test -f "$HOSTNAME"; then
    echo "Set hostname..."
    read -p "hostname: " hostname > /dev/tty
    sudo scutil --set ComputerName $hostname
    sudo scutil --set LocalHostName $hostname
    sudo scutil --set HostName $hostname
    echo "Hostname set to ${hostname}"
    echo $hostname > $HOSTNAME
fi

# ###################################################################################
# # oh-my-zsh
# ###################################################################################

# rm -rf /Users/gdev/.oh-my-zsh
# echo "EXIT THE ZSH SHELL AT THE NEXT PROMPT!!!"
# sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)  --unattended"
# sed -i.bak 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' .zshrc

###################################################################################
# Casks
###################################################################################

brew cask install downie
brew cask install easyeda
brew cask install cleanmymac
brew cask install netnewswire
brew cask install sketch
brew cask install google-chrome
brew cask install vlc
#brew cask install bartender
brew cask install bricklink-studio 
brew cask install sf-symbols 
brew cask install nova
brew cask install phoenix

###################################################################################
# Phoenix window manager
###################################################################################

wget -O ~/.phoenix.js https://github.com/gdev/phoenix-config
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Phoenix",path:"/Applications/Phoenix.app", hidden:false}'

###################################################################################
# Mac app store
###################################################################################

brew install mas
mas lucky "1Password 7"
mas lucky "iStat Menus"
mas lucky 1Blocker
mas lucky Cardhop
mas lucky Acorn
#mas lucky Airmail
mas lucky Fantastical
mas lucky Tampermonkey
mas lucky Screens
mas lucky "Final Cut Pro"
mas lucky Numbers
mas lucky Pages
mas lucky "Microsoft Word"
mas lucky "Microsoft PowerPoint"
mas lucky "Microsoft Excel"

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 0

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool false

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# App Settings                                                                #
###############################################################################

# Dont open photos on device connect
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
# Revert: defaults -currentHost delete com.apple.ImageCapture disableHotPlug

# Plaintext default in TextEdit
defaults write com.apple.TextEdit RichText -int 0

# Enable time zone support in iCal
defaults write com.apple.iCal "TimeZone support enabled" -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Remove all default dock apps
defaults write com.apple.dock persistent-apps -array

# Only show running apps in dock
# Revert: defaults write com.apple.dock static-only -bool false; killall Dock
#defaults write com.apple.dock static-only -bool true

# Automatically hide and show the Dock:
defaults write com.apple.dock autohide -bool true

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

###############################################################################
# Finder                                                                      # 
###############################################################################

# Disable Time Machine's pop-up message whenever an external drive is plugged in
# Doesn't work? sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Show stuff I like on the desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show the ~/Library folder.
sudo chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Set Desktop as the default location for new Finder windows as "PfDe"
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Add quit to finder
# defaults write com.apple.finder QuitMenuItem -bool true

# Show all extensions in finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable extension change warning in Finder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Delete :DesktopViewSettings:IconViewSettings:arrangeBy" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Delete :FK_StandardViewSettings:IconViewSettings:arrangeBy" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Delete :StandardViewSettings:IconViewSettings:arrangeBy" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings:arrangeBy string grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FK_StandardViewSettings:IconViewSettings:arrangeBy string grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :StandardViewSettings:IconViewSettings:arrangeBy string grid" ~/Library/Preferences/com.apple.finder.plist

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Collapse tags in sidebar
defaults write com.apple.finder SidebarTagsSctionDisclosedState -int 0

# Finder, View, Show View Options (Desktop)
# Icon size: 48
# Grid spacing: 100
# Label position: [x] Right
# Sort by: [Name]
defaults write com.apple.finder DesktopViewSettings '{ "IconViewSettings" = { "iconSize" = 48; "gridSpacing" = 100; "labelOnBottom" = 0; "arrangeBy" = "name"; }; }'

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Show Safari’s bookmarks bar by default:
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Enable the Develop menu and the Web Inspector in Safari:
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Stop safari notifications
defaults write com.apple.Safari CanPromptForPushNotifications -bool false

# Opening "safe" files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool true

# Smart Search Field: [x] Show full website address
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# [x] Show Status Bar
defaults write com.apple.Safari ShowStatusBar -bool true

###############################################################################
# Keyboard Shortcuts                                                          #
###############################################################################

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 12 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 21 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 13 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 22 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 7 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 160 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 23 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 15 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 8 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 24 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 9 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 16 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 25 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 51 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 17 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 26 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 175 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 18 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 36 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 62 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 19 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 162 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 63 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 163 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 37 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 98 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 57 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 10 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 179 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 59 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 11 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 20 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 31 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 30 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 176 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>2148532224</integer></array><key>type</key><string>standard</string></dict></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 184 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>53</integer><integer>23</integer><integer>1179648</integer></array><key>type</key><string>standard</string></dict></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>96</integer><integer>50</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>'

###############################################################################
# System                                                                      #
###############################################################################

SUBMIT_DIAGNOSTIC_DATA_TO_APPLE=TRUE
SUBMIT_DIAGNOSTIC_DATA_TO_APP_DEVELOPERS=TRUE

# Enable automatic network time
sudo systemsetup -setusingnetworktime on

# Disable automatic updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool FALSE

# Always show scrollbars
#defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Expand save dialog
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Enable full keyboard access for all controls,
# (e.g. enable Tab in modal dialogs).
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Turn on and off favorite menu extras
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.airplay" -bool NO
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.clock" -bool NO
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -bool YES
defaults delete com.apple.systemuiserver.menuExtras "/System/Library/CoreServices/Menu Extras/Clock.menu"

###############################################################################
# Show some changes...
###############################################################################

killall -KILL SystemUIServer
killall Dock
killall Safari
killall Finder


###############################################################################
# Xcode and reboot...
###############################################################################

echo "Installing Xcode can take awhile. All other config done..."
mas lucky Xcode

echo "Reboot to complete setup!"
