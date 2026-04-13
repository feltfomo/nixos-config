# Plain Nix attrset — NOT a flake-parts module, _ prefix excludes from import-tree.
# Usage: import ./_noctalia-base.nix { inherit vars; }
# Each compositor overrides what it needs with lib.recursiveUpdate.
{ vars }:
{
  settingsVersion = 59;

  bar = {
    # compositor-specific: barType, density, frameThickness, frameRadius, hideOnOverview
    position = "top";
    monitors = [ ];
    showOutline = false;
    showCapsule = true;
    capsuleOpacity = 1;
    capsuleColorKey = "none";
    widgetSpacing = 6;
    contentPadding = 2;
    fontScale = 1;
    enableExclusionZoneInset = true;
    backgroundOpacity = 0.93;
    useSeparateOpacity = false;
    marginVertical = 4;
    marginHorizontal = 4;
    outerCorners = true;
    displayMode = "always_visible";
    autoHideDelay = 500;
    autoShowDelay = 150;
    showOnWorkspaceSwitch = true;
    widgets = {
      left = [
        { colorizeSystemIcon = "none"; customIconPath = ""; enableColorization = false; icon = "rocket"; iconColor = "none"; id = "Launcher"; useDistroLogo = false; }
        { clockColor = "none"; customFont = ""; formatHorizontal = "HH:mm ddd, MMM dd"; formatVertical = "HH mm - dd MM"; id = "Clock"; tooltipFormat = "HH:mm ddd, MMM dd"; useCustomFont = false; }
        { compactMode = true; diskPath = "/"; iconColor = "none"; id = "SystemMonitor"; showCpuCores = false; showCpuFreq = false; showCpuTemp = true; showCpuUsage = true; showDiskAvailable = false; showDiskUsage = false; showDiskUsageAsPercent = false; showGpuTemp = false; showLoadAverage = false; showMemoryAsPercent = false; showMemoryUsage = true; showNetworkStats = false; showSwapUsage = false; textColor = "none"; useMonospaceFont = true; usePadding = false; }
        { colorizeIcons = false; hideMode = "hidden"; id = "ActiveWindow"; maxWidth = 145; scrollingMode = "hover"; showIcon = true; showText = true; textColor = "none"; useFixedWidth = false; }
        { compactMode = false; hideMode = "hidden"; hideWhenIdle = false; id = "MediaMini"; maxWidth = 145; panelShowAlbumArt = true; scrollingMode = "hover"; showAlbumArt = true; showArtistFirst = true; showProgressRing = true; showVisualizer = false; textColor = "none"; useFixedWidth = false; visualizerType = "linear"; }
      ];
      center = [
        { characterCount = 2; colorizeIcons = false; emptyColor = "secondary"; enableScrollWheel = true; focusedColor = "primary"; followFocusedScreen = false; fontWeight = "bold"; groupedBorderOpacity = 1; hideUnoccupied = false; iconScale = 0.8; id = "Workspace"; labelMode = "index"; occupiedColor = "secondary"; pillSize = 0.6; showApplications = false; showApplicationsHover = false; showBadge = true; showLabelsOnlyWhenOccupied = true; unfocusedIconsOpacity = 1; }
      ];
      right = [
        { blacklist = [ ]; chevronColor = "none"; colorizeIcons = false; drawerEnabled = true; hidePassive = false; id = "Tray"; pinned = [ ]; }
        { hideWhenZero = false; hideWhenZeroUnread = false; iconColor = "none"; id = "NotificationHistory"; showUnreadBadge = true; unreadBadgeColor = "primary"; }
        { deviceNativePath = "__default__"; displayMode = "graphic-clean"; hideIfIdle = false; hideIfNotDetected = true; id = "Battery"; showNoctaliaPerformance = false; showPowerProfiles = false; }
        { displayMode = "onhover"; iconColor = "none"; id = "Volume"; middleClickCommand = "pwvucontrol || pavucontrol"; textColor = "none"; }
        { applyToAllMonitors = false; displayMode = "onhover"; iconColor = "none"; id = "Brightness"; textColor = "none"; }
        { colorizeDistroLogo = false; colorizeSystemIcon = "none"; customIconPath = ""; enableColorization = false; icon = "noctalia"; id = "ControlCenter"; useDistroLogo = false; }
      ];
    };
    mouseWheelAction = "none";
    reverseScroll = false;
    mouseWheelWrap = true;
    middleClickAction = "none";
    middleClickFollowMouse = false;
    middleClickCommand = "";
    rightClickAction = "controlCenter";
    rightClickFollowMouse = true;
    rightClickCommand = "";
    screenOverrides = [ ];
  };

  general = {
    avatarImage = "${vars.home}/.face";
    dimmerOpacity = 0.2;
    showScreenCorners = false;
    forceBlackScreenCorners = false;
    scaleRatio = 1;
    radiusRatio = 1;
    iRadiusRatio = 1;
    boxRadiusRatio = 1;
    screenRadiusRatio = 1;
    animationSpeed = 1;
    animationDisabled = false;
    compactLockScreen = false;
    lockScreenAnimations = false;
    lockOnSuspend = true;
    showSessionButtonsOnLockScreen = true;
    showHibernateOnLockScreen = false;
    enableLockScreenMediaControls = false;
    enableShadows = true;
    enableBlurBehind = true;
    shadowDirection = "bottom_right";
    shadowOffsetX = 2;
    shadowOffsetY = 3;
    language = "";
    allowPanelsOnScreenWithoutBar = true;
    showChangelogOnStartup = true;
    telemetryEnabled = false;
    enableLockScreenCountdown = true;
    lockScreenCountdownDuration = 10000;
    autoStartAuth = false;
    allowPasswordWithFprintd = false;
    clockStyle = "custom";
    clockFormat = "hh\\nmm";
    passwordChars = false;
    lockScreenMonitors = [ ];
    lockScreenBlur = 0;
    lockScreenTint = 0;
  };

  ui = {
    fontDefault = "Noto Sans";
    fontFixed = "monospace";
    fontDefaultScale = 1;
    fontFixedScale = 1;
    tooltipsEnabled = true;
    scrollbarAlwaysVisible = true;
    boxBorderEnabled = true;
    panelBackgroundOpacity = 0.55;
    translucentWidgets = true;
    panelsAttachedToBar = true;
    settingsPanelMode = "attached";
    settingsPanelSideBarCardStyle = true;
  };

  location = {
    name = "";
    weatherEnabled = true;
    weatherShowEffects = true;
    weatherTaliaMascotAlways = false;
    useFahrenheit = false;
    use12hourFormat = false;
    showWeekNumberInCalendar = false;
    showCalendarEvents = true;
    showCalendarWeather = true;
    analogClockInCalendar = false;
    firstDayOfWeek = -1;
    hideWeatherTimezone = false;
    hideWeatherCityName = false;
    autoLocate = false;
  };

  calendar.cards = [
    { enabled = true; id = "calendar-header-card"; }
    { enabled = true; id = "calendar-month-card"; }
    { enabled = true; id = "weather-card"; }
  ];

  wallpaper = {
    enabled = true;
    overviewEnabled = false;
    directory = "${vars.home}/Wallpapers";
    monitorDirectories = [ ];
    enableMultiMonitorDirectories = false;
    showHiddenFiles = false;
    viewMode = "single";
    setWallpaperOnAllMonitors = true;
    linkLightAndDarkWallpapers = true;
    fillMode = "crop";
    fillColor = "#000000";
    useSolidColor = false;
    solidColor = "#1a1a2e";
    automationEnabled = false;
    wallpaperChangeMode = "random";
    randomIntervalSec = 300;
    transitionDuration = 1500;
    transitionType = [ "fade" "disc" "stripes" "wipe" "pixelate" "honeycomb" ];
    skipStartupTransition = false;
    transitionEdgeSmoothness = 0.05;
    panelPosition = "follow_bar";
    hideWallpaperFilenames = false;
    useOriginalImages = false;
    overviewBlur = 0.4;
    overviewTint = 0.6;
    useWallhaven = false;
    wallhavenQuery = "";
    wallhavenSorting = "relevance";
    wallhavenOrder = "desc";
    wallhavenCategories = "111";
    wallhavenPurity = "100";
    wallhavenRatios = "";
    wallhavenApiKey = "";
    wallhavenResolutionMode = "atleast";
    wallhavenResolutionWidth = "";
    wallhavenResolutionHeight = "";
    sortOrder = "name";
    favorites = [ ];
  };

  appLauncher = {
    enableClipboardHistory = true;
    autoPasteClipboard = false;
    enableClipPreview = true;
    clipboardWrapText = true;
    enableClipboardSmartIcons = true;
    enableClipboardChips = true;
    clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
    clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
    position = "center";
    pinnedApps = [ ];
    sortByMostUsed = true;
    terminalCommand = "kitty -e";
    customLaunchPrefixEnabled = false;
    customLaunchPrefix = "";
    viewMode = "list";
    showCategories = true;
    iconMode = "tabler";
    showIconBackground = false;
    enableSettingsSearch = true;
    enableWindowsSearch = true;
    enableSessionSearch = true;
    ignoreMouseInput = false;
    screenshotAnnotationTool = "";
    overviewLayer = false;
    density = "default";
  };

  controlCenter = {
    position = "close_to_bar_button";
    diskPath = "/";
    shortcuts = {
      left = [ { id = "Network"; } { id = "Bluetooth"; } { id = "WallpaperSelector"; } { id = "NoctaliaPerformance"; } ];
      right = [ { id = "Notifications"; } { id = "PowerProfile"; } { id = "KeepAwake"; } { id = "NightLight"; } ];
    };
    cards = [
      { enabled = true;  id = "profile-card"; }
      { enabled = true;  id = "shortcuts-card"; }
      { enabled = true;  id = "audio-card"; }
      { enabled = false; id = "brightness-card"; }
      { enabled = true;  id = "weather-card"; }
      { enabled = true;  id = "media-sysmon-card"; }
    ];
  };

  dock = {
    enabled = true;
    position = "bottom";
    # compositor-specific: displayMode, monitors
    dockType = "floating";
    backgroundOpacity = 1;
    floatingRatio = 1;
    size = 1;
    onlySameOutput = true;
    monitors = [ ];
    pinnedApps = [ ];
    colorizeIcons = false;
    showLauncherIcon = false;
    launcherPosition = "end";
    launcherUseDistroLogo = false;
    launcherIcon = "";
    launcherIconColor = "none";
    pinnedStatic = false;
    inactiveIndicators = false;
    groupApps = false;
    groupContextMenuMode = "extended";
    groupClickAction = "cycle";
    groupIndicatorStyle = "dots";
    deadOpacity = 0.6;
    animationSpeed = 1;
    sitOnFrame = false;
    showDockIndicator = false;
    indicatorThickness = 3;
    indicatorColor = "primary";
    indicatorOpacity = 0.6;
  };

  plugins = {
    autoUpdate = false;
    notifyUpdates = true;
  };
}
