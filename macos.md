# Mac setup

- Basic setup
- Setup SSH key
- Download and install Xcode from the App Store and accept EULA
- Install brew
- Download dot files
  `cd $HOME && git clone git@github.com:tngranados/dotfiles.git && cd dotfiles && make install`
- Install dotfiles dependencies
  `brew install git git-delta bat ripgrep fzf nvim gh fd tldr httpie lazygit jq zoxide entr imagemagick difftastic eza`
- Fix audit issue with zsh
  `sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions && chmod u+w /usr/local/share/zsh /usr/local/share/zsh/site-functions`
- Install vscode and login through GitHub
- Fix annoying opt+space shortcut inserting a non-breaking space
  `mkdir -p $HOME/Library/KeyBindings && echo '{\n"~ " = ("insertText:", " ");\n}' > ~/Library/KeyBindings/DefaultKeyBinding.dict`
- Defaults

  ```sh
  ## Basic UI
  # Only show scrollbars when scrolling
  defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  ## Input
  # Enable tap to click for this user and for the login screen
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Set a fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 20

  # Enable snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  # Show the ~/Library folder
  chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

  # Create ~/Developer folder if it doesn't exists yet
  mkdir -p Developer

  ## Screenshots
  # Set iCloud Drive Screenshos folder
  defaults write com.apple.screencapture "location" -string "~/Library/Mobile Documents/com~apple~CloudDocs/Screenshots/"
  # Use jpg instead of png to reduce file size as quality is good enough
  defaults write com.apple.screencapture "type" -string "jpg"

  ## Finder
  # Set Home as the default location for new Finder windows
  defaults write com.apple.finder NewWindowTarget -string "PfLo"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  ## Disable anoying warning when disconnecting media
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification -bool YES && sudo pkill diskarbitrationd

  ## Dock
  # Remove the auto-hiding Dock delay
  defaults write com.apple.dock autohide-delay -float 0
  # Speed up the animation when hiding/showing the Dock
  defaults write com.apple.dock autohide-time-modifier -float 0.3
  # Move dock to the left
  defaults write com.apple.dock "orientation" -string "left"
  # Set dock icon size
  defaults write com.apple.dock "tilesize" -int "36"
  # Set dock auto-hide to true
  defaults write com.apple.dock "autohide" -bool "true"
  # Don’t show recent applications in Dock
  defaults write com.apple.dock show-recents -bool false

  # Remove Siri from menu bar
  defaults write com.apple.Siri StatusMenuVisible -bool false
  # Add bluetooth to menu bar
  defaults write "com.apple.controlcenter" "NSStatusItem Visible Bluetooth" -bool true
  defaults write "com.apple.controlcenter" "NSStatusItem Preferred Position Bluetooth" -int 310

  # Add iOS & Watch Simulator to Launchpad
  #sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
  #sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

  # Adjust Finder's toolbar title rollover delay
  defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0.1

  # Allow everyone to discover me through airdrop
  defaults write com.apple.sharingd DiscoverableMode -string "Everyone"

  ## Clock
  # Show seconds
  defaults write com.apple.menuextra.clock "ShowSeconds" -bool true

  ## Safari
  # Prevent Safari from opening ‘safe’ files automatically after downloading
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

  # Hide Safari’s bookmarks bar by default
  defaults write com.apple.Safari ShowFavoritesBar -bool false

  # Enable Safari’s debug menu and inspector
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

  # Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  ## Photos
  # Prevent Photos from opening automatically when devices are plugged in
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

  ## System
  # Set 'Move focus to next window' to ⌘º
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "{enabled = 1; value = { parameters = (186, 10, 1048576); type = 'standard'; }; }"
  # Set 'Move focus to the widnow drawer' ⌥⌘º
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 51 "{enabled = 1; value = { parameters = (186, 10, 1572864); type = 'standard'; }; }"
  # Move windows by cmd+ctrl+clicking in any part of it
  # defaults write -g NSWindowShouldDragOnGesture -bool true # Disabled because it interfers with Xcode's jump to definition

  # Set spanish input source
  defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.Spanish-ISO"

  ## Transmission
  # Trash original torrent files
  defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
  # Hide the donate message
  defaults write org.m0k.transmission WarningDonate -bool false
  # Hide the legal disclaimer
  defaults write org.m0k.transmission WarningLegal -bool false
  # IP block list.
  # Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
  defaults write org.m0k.transmission BlocklistNew -bool true
  defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
  defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

  # Randomize port on launch
  defaults write org.m0k.transmission RandomPort -bool true

  ## Xcode
  # Show code folding ribbons
  defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool true

  # Re indent on paste
  defaults write com.apple.dt.Xcode DVTTextIndentOnPaste -bool true

  # Easier work with MVVM
  defaults write com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "ViewModel" "View"

  # Stop current task when running again
  defaults write com.apple.dt.Xcode IDESuppressStopBuildWarning -bool true
  defaults write com.apple.dt.Xcode IDESuppressStopExecutionWarningTarget -string "IDESuppressStopExecutionWarningTargetValue_Stop"

  # Enable spell check
  defaults write com.apple.dt.Xcode AutomaticallyCheckSpellingWhileTyping -bool true

  # Automatically trim whitespace-only lines
  defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true

  # Enable better build system that uses more cores
  defaults write com.apple.dt.XCBuild EnableSwiftBuildSystemIntegration 1

  # Use notifications instead of modals for crashes
  defaults write com.apple.CrashReporter UseUNC 1

  # Show build time instead of the time it finished
  defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true
  ```

Work specific

- Install asdf with ruby and node plugins
- Install dependencies
  ```sh
    brew install postgresql redis
    brew services start postgresql
    brew services start redis
    gem install pg -v '0.18.4' -- --with-cflags="-Wno-error=implicit-function-declaration"
    bundle install
    mkdir -p ~/Developer/work
  ```
- Add `.gitconfig` at `~/Developer/work` with correct user name and email
- Install aws cli
- Install cocoapods
  `sudo gem install cocoapods`
- Defaults
  ```sh
  # Show page guide at column 120
  defaults write com.apple.dt.Xcode DVTTextPageGuideLocation -int 120
  # Better counterparts
  defaults write com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "Protocol" "Protocols" "Network"
  ```

### Restart affected apps

```sh
  for app in "Activity Monitor" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Mail" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission"; do
    killall "${app}" &> /dev/null
  done

  echo "Done. Note that some of these changes require a logout/restart to take effect."
```

### Credits

https://github.com/mathiasbynens/dotfiles/blob/main/.macos
https://macos-defaults.com/
