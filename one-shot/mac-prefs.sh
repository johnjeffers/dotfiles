#!/usr/bin/env bash

# HOT TIP: You can use plistwatch to determine which setting is
# being updated when you modify something in System Settings.
# https://github.com/catilac/plistwatch

# Get the sudo password because we'll need it later.
echo ""
echo "Enter your sudo password."
sudo -v

# Close System Preferences to make sure it doesn't interfere.
osascript -e 'tell application "System Preferences" to quit'

### General -> Sharing
###########################################################
# Get and set the hostname.
echo ""
echo "Current hostname is $(hostname)"
echo "Press enter to keep it, or type a new hostname."
echo ""
read -r -p "Hostname: " new_hostname
echo ""
if [[ $new_hostname == "" ]]; then
	echo "Keeping hostname $(hostname)"
else
	# Name shown in Settings -> General -> Sharing
	sudo scutil --set ComputerName "${new_hostname}"
	# Name shown by the hostname command
	sudo scutil --set HostName "${new_hostname}.local"
	# Bonjour hostname ending in .local
	sudo scutil --set LocalHostName "${new_hostname}"
fi

### Desktop & Dock
###########################################################
# Remove all icons from the dock
defaults write "com.apple.dock" "persistent-apps" -array
# Don't show recent apps.
defaults write com.apple.dock show-recents -bool false
# Dock icon size.
defaults write com.apple.dock tilesize -int 40
# Dock position.
defaults write com.apple.dock orientation -string left

### Mouse & Trackpad
###########################################################
# Disable natural scrolling.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

### Network
###########################################################
# Enable firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

### Appearance
###########################################################
# Set sidebar icon size to small.
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

### Control Center
###########################################################
# Always show the sound icon in the menu bar.
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

### Finder
###########################################################
# Show icons for disks/servers/removable media on the desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Show the path bar.
defaults write com.apple.finder ShowPathbar -bool true
# Keep folders on top.
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Don't create .DS_Store files on network or USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Don't warn when emptying trash.
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Set default location to $HOME
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
# Search current folder by default.
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Don't reopen windows when logging in.
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
# Don't show tags.
defaults write com.apple.finder ShowRecentTags -bool false
# Show item info for desktop icons.
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
# Enable snap-to-grid everywhere.
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# Set grid spacing.
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist
# Set icon size.
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

# ### Restart things that need to be restarted.
# ###########################################################
killall Finder
killall Dock
