{ ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleEnableSwipeNavigateWithScrolls = false;
      ApplePressAndHoldEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSAutomaticPeriodSubstitutionEnabled = false;
    };

    dock = {
      autohide = false;
      tilesize = 56;
      show-recents = false;
      mru-spaces = false;
      expose-group-apps = true;
      launchanim = false;
      minimize-to-application = true;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
    };

    finder = {
      FXPreferredViewStyle = "Nlsv"; # list view
      FXDefaultSearchScope = "SCcf"; # search current folder
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
    };

    WindowManager = {
      EnableTiledWindowMargins = false;
      EnableStandardClickToShowDesktop = false;
      HideDesktop = true;
    };

    screencapture = {
      location = "~/Downloads";
      type = "png";
      disable-shadow = true;
    };

    trackpad = {
      Clicking = true;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleMiniaturizeOnDoubleClick = false;
        "com.apple.trackpad.forceClick" = true;
      "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      };
    };
  };
}
