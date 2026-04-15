{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.dmsConfigNiri =
    { pkgs, lib, ... }:
    let
      pluginFiles = import ./_dms-plugins.nix { inherit pkgs lib; };
    in
    {
      imports = [
        inputs.dms.nixosModules.default
        ./_dms-niri/templates.nix
      ];

      programs.dank-material-shell = {
        enable = true;
        package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableClipboardPaste = true;
        enableCalendarEvents = true;
        enableSystemMonitoring = true;
        enableVPN = true;
      };

      environment.systemPackages = with pkgs; [
        khal
        glib
      ];

      hjem.users.${vars.username}.files =
        let
          toJSON = lib.generators.toJSON { };

          settings = {
            # ── Theming ────────────────────────────────────────────────────
            currentThemeName = "dynamic";
            currentThemeCategory = "dynamic";
            matugenScheme = "scheme-tonal-spot";
            matugenContrast = 0;
            runUserMatugenTemplates = true;
            runDmsMatugenTemplates = true;
            matugenTargetMonitor = "";

            matugenTemplateGtk = true;
            matugenTemplateQt5ct = true;
            matugenTemplateQt6ct = true;
            matugenTemplateNiri = false;
            matugenTemplateHyprland = false;
            matugenTemplateMangowc = false;
            matugenTemplateFirefox = false;
            matugenTemplatePywalfox = false;
            matugenTemplateZenBrowser = false;
            matugenTemplateVesktop = false;
            matugenTemplateEquibop = false;
            matugenTemplateGhostty = false;
            matugenTemplateKitty = false;
            matugenTemplateFoot = false;
            matugenTemplateAlacritty = false;
            matugenTemplateNeovim = false;
            matugenTemplateWezterm = false;
            matugenTemplateDgop = false;
            matugenTemplateKcolorscheme = false;
            matugenTemplateVscode = false;
            matugenTemplateEmacs = false;
            matugenTemplateZed = false;
            matugenTemplateNeovimSetBackground = true;
            matugenTemplateNeovimSettings = {
              dark  = { baseTheme = "github_dark";  harmony = 0.5; };
              light = { baseTheme = "github_light"; harmony = 0.5; };
            };

            gtkThemingEnabled = false;
            qtThemingEnabled = false;

            # ── Appearance ─────────────────────────────────────────────────
            popupTransparency = 0.5;
            dockTransparency = 0.5;
            widgetBackgroundColor = "sch";
            widgetColorMode = "default";
            controlCenterTileColorMode = "primary";
            buttonColorMode = "primary";
            cornerRadius = 16;

            niriLayoutGapsOverride = -1;
            niriLayoutRadiusOverride = -1;
            niriLayoutBorderSize = -1;
            hyprlandLayoutGapsOverride = -1;
            hyprlandLayoutRadiusOverride = -1;
            hyprlandLayoutBorderSize = -1;
            mangoLayoutGapsOverride = -1;
            mangoLayoutRadiusOverride = -1;
            mangoLayoutBorderSize = -1;

            # ── Blur ───────────────────────────────────────────────────────
            blurEnabled = true;
            blurBorderColor = "outline";
            blurBorderCustomColor = "#ffffff";
            blurBorderOpacity = 1;
            wallpaperFillMode = "Fill";
            blurredWallpaperLayer = false;
            blurWallpaperOnOverview = true;

            # ── Animation ──────────────────────────────────────────────────
            animationSpeed = 1;
            customAnimationDuration = 500;
            syncComponentAnimationSpeeds = true;
            popoutAnimationSpeed = 1;
            popoutCustomAnimationDuration = 150;
            modalAnimationSpeed = 1;
            modalCustomAnimationDuration = 150;
            enableRippleEffects = true;

            # ── Material 3 Elevation ───────────────────────────────────────
            m3ElevationEnabled = true;
            m3ElevationIntensity = 12;
            m3ElevationOpacity = 30;
            m3ElevationColorMode = "default";
            m3ElevationLightDirection = "top";
            m3ElevationCustomColor = "#000000";
            modalElevationEnabled = true;
            popoutElevationEnabled = true;
            barElevationEnabled = true;

            # ── Bar ────────────────────────────────────────────────────────
            barConfigs = [
              {
                id = "default";
                name = "Main Bar";
                enabled = true;
                position = 0;
                screenPreferences = [ "all" ];
                showOnLastDisplay = true;
                leftWidgets = [
                  "launcherButton"
                  "workspaceSwitcher"
                  "focusedWindow"
                ];
                centerWidgets = [
                  { id = "clock"; enabled = true; }
                ];
                rightWidgets = [
                  "systemTray"
                  "notificationButton"
                  "battery"
                  {
                    id = "controlCenterButton";
                    enabled = true;
                    showAudioPercent = false;
                    showMicIcon = false;
                    showMicPercent = false;
                  }
                ];
                spacing = 4;
                innerPadding = 4;
                bottomGap = 0;
                transparency = 0.49;
                widgetTransparency = 0;
                squareCorners = false;
                noBackground = false;
                gothCornersEnabled = false;
                gothCornerRadiusOverride = false;
                gothCornerRadiusValue = 12;
                borderEnabled = false;
                borderColor = "surfaceText";
                borderOpacity = 1;
                borderThickness = 1;
                fontScale = 1;
                autoHide = false;
                autoHideDelay = 250;
                openOnOverview = false;
                visible = true;
                popupGapsAuto = true;
                popupGapsManual = 4;
              }
              {
                id = "bar1776217847984";
                name = "Bar 2";
                enabled = true;
                position = 1;
                screenPreferences = [
                  {
                    model = "Unknown";
                    name = {
                      name = {
                        name        = vars.monitors.secondary;
                        refreshRate = 180;
                        res         = "2560x1440";
                        x           = 2560;
                        y           = 0;
                      };
                      refreshRate = 180;
                      res         = "2560x1440";
                      x           = 2560;
                      y           = 0;
                    };
                  }
                  {
                    model = "Unknown";
                    name = {
                      name        = vars.monitors.secondary;
                      refreshRate = 180;
                      res         = "2560x1440";
                      x           = 2560;
                      y           = 0;
                    };
                  }
                  {
                    name  = vars.monitors.secondary;
                    model = "Unknown";
                  }
                ];
                showOnLastDisplay = false;
                leftWidgets = [
                  { id = "cpuTemp";    enabled = true; minimumWidth = true; }
                  { id = "diskUsage"; enabled = true; mountPath = "/"; diskUsageMode = 0; }
                  { id = "memUsage";  enabled = true; minimumWidth = true; showInGb = false; }
                  { id = "cpuUsage";  enabled = true; minimumWidth = true; }
                ];
                centerWidgets = [ "music" ];
                rightWidgets = [
                  { id = "privacyIndicator"; enabled = true; }
                  { id = "clipboardPlus";    enabled = true; }
                  { id = "colorPicker";      enabled = true; }
                  { id = "powerMenuButton";  enabled = true; }
                  { id = "appsDock";         enabled = true; }
                ];
                spacing = 0;
                innerPadding = 4;
                bottomGap = 0;
                transparency = 0.49;
                widgetTransparency = 0;
                squareCorners = true;
                noBackground = false;
                gothCornersEnabled = true;
                gothCornerRadiusOverride = false;
                gothCornerRadiusValue = 12;
                borderEnabled = false;
                borderColor = "surfaceText";
                borderOpacity = 1;
                borderThickness = 1;
                widgetOutlineEnabled = false;
                widgetOutlineColor = "primary";
                widgetOutlineOpacity = 1;
                widgetOutlineThickness = 1;
                widgetPadding = 8;
                maximizeWidgetIcons = false;
                maximizeWidgetText = false;
                removeWidgetPadding = false;
                fontScale = 1;
                iconScale = 1;
                autoHide = false;
                autoHideDelay = 250;
                showOnWindowsOpen = false;
                openOnOverview = false;
                visible = true;
                popupGapsAuto = true;
                popupGapsManual = 4;
                maximizeDetection = true;
                scrollEnabled = true;
                scrollXBehavior = "column";
                scrollYBehavior = "workspace";
                shadowIntensity = 0;
                shadowOpacity = 60;
                shadowDirectionMode = "inherit";
                shadowDirection = "top";
                shadowColorMode = "default";
                shadowCustomColor = "#000000";
              }
            ];

            # ── Bar widget visibility ──────────────────────────────────────
            showLauncherButton = true;
            showWorkspaceSwitcher = true;
            showFocusedWindow = true;
            showWeather = true;
            showMusic = true;
            showClipboard = true;
            showCpuUsage = true;
            showMemUsage = true;
            showCpuTemp = true;
            showGpuTemp = true;
            selectedGpuIndex = 0;
            enabledGpuPciIds = [ ];
            showSystemTray = true;
            showClock = true;
            showNotificationButton = true;
            showBattery = true;
            showControlCenterButton = true;
            showCapsLockIndicator = true;

            # ── Control Center ─────────────────────────────────────────────
            controlCenterShowNetworkIcon = true;
            controlCenterShowBluetoothIcon = true;
            controlCenterShowAudioIcon = true;
            controlCenterShowAudioPercent = false;
            controlCenterShowVpnIcon = true;
            controlCenterShowBrightnessIcon = false;
            controlCenterShowBrightnessPercent = false;
            controlCenterShowMicIcon = false;
            controlCenterShowMicPercent = false;
            controlCenterShowBatteryIcon = false;
            controlCenterShowPrinterIcon = false;
            controlCenterShowScreenSharingIcon = true;
            controlCenterWidgets = [
              { id = "volumeSlider";     enabled = true; width = 50; }
              { id = "brightnessSlider"; enabled = true; width = 50; }
              { id = "wifi";             enabled = true; width = 50; }
              { id = "bluetooth";        enabled = true; width = 50; }
              { id = "audioOutput";      enabled = true; width = 50; }
              { id = "audioInput";       enabled = true; width = 50; }
              { id = "nightMode";        enabled = true; width = 50; }
              { id = "darkMode";         enabled = true; width = 50; }
            ];

            showPrivacyButton = true;
            privacyShowMicIcon = false;
            privacyShowCameraIcon = false;
            privacyShowScreenShareIcon = false;

            # ── Workspace Switcher ─────────────────────────────────────────
            showWorkspaceIndex = false;
            showWorkspaceName = false;
            showWorkspacePadding = false;
            workspaceScrolling = false;
            showWorkspaceApps = false;
            workspaceDragReorder = true;
            maxWorkspaceIcons = 3;
            workspaceAppIconSizeOffset = 0;
            groupWorkspaceApps = false;
            workspaceFollowFocus = false;
            showOccupiedWorkspacesOnly = false;
            reverseScrolling = false;
            dwlShowAllTags = false;
            workspaceActiveAppHighlightEnabled = false;
            workspaceColorMode = "default";
            workspaceOccupiedColorMode = "none";
            workspaceUnfocusedColorMode = "default";
            workspaceUrgentColorMode = "default";
            workspaceFocusedBorderEnabled = false;
            workspaceFocusedBorderColor = "primary";
            workspaceFocusedBorderThickness = 2;
            workspaceNameIcons = { };

            # ── Dock ───────────────────────────────────────────────────────
            showDock = true;
            dockAutoHide = false;
            dockSmartAutoHide = false;
            dockGroupByApp = false;
            dockRestoreSpecialWorkspaceOnClick = false;
            dockOpenOnOverview = false;
            dockPosition = 1;
            dockSpacing = 9;
            dockBottomGap = -10;
            dockMargin = 10;
            dockIconSize = 40;
            dockIndicatorStyle = "circle";
            dockBorderEnabled = true;
            dockBorderColor = "primary";
            dockBorderOpacity = 1;
            dockBorderThickness = 1;
            dockIsolateDisplays = false;
            dockLauncherEnabled = true;
            dockLauncherLogoMode = "os";
            dockLauncherLogoCustomPath = "";
            dockLauncherLogoColorOverride = "primary";
            dockLauncherLogoSizeOffset = 0;
            dockLauncherLogoBrightness = 0.5;
            dockLauncherLogoContrast = 1;
            dockMaxVisibleApps = 0;
            dockMaxVisibleRunningApps = 0;
            dockShowOverflowBadge = true;
            appsDockHideIndicators = false;
            appsDockColorizeActive = false;
            appsDockActiveColorMode = "primary";
            appsDockEnlargeOnHover = false;
            appsDockEnlargePercentage = 125;
            appsDockIconSizePercentage = 100;

            screenPreferences = {
              dock = [
                {
                  model = "M27QA ICE";
                  name = {
                    name = {
                      name        = vars.monitors.primary;
                      refreshRate = 180;
                      res         = "2560x1440";
                      x           = 0;
                      y           = 0;
                    };
                    refreshRate = 180;
                    res         = "2560x1440";
                    x           = 0;
                    y           = 0;
                  };
                }
                {
                  model = "M27QA ICE";
                  name  = {
                    name        = vars.monitors.primary;
                    refreshRate = 180;
                    res         = "2560x1440";
                    x           = 0;
                    y           = 0;
                  };
                }
                {
                  name  = vars.monitors.primary;
                  model = "M27QA ICE";
                }
              ];
            };
            showOnLastDisplay = { dock = true; };

            # ── App Launcher / Spotlight ───────────────────────────────────
            appLauncherViewMode = "list";
            spotlightModalViewMode = "list";
            sortAppsAlphabetically = false;
            appLauncherGridColumns = 4;
            spotlightCloseNiriOverview = true;
            rememberLastQuery = false;
            spotlightSectionViewModes = { apps = "list"; };
            appDrawerSectionViewModes = { apps = "list"; };
            niriOverviewOverlayEnabled = true;
            dankLauncherV2Size = "medium";
            dankLauncherV2BorderEnabled = true;
            dankLauncherV2BorderThickness = 2;
            dankLauncherV2BorderColor = "primary";
            dankLauncherV2ShowFooter = true;
            dankLauncherV2UnloadOnClose = false;
            browserPickerViewMode = "grid";
            browserUsageHistory = { };
            appPickerViewMode = "grid";
            filePickerUsageHistory = { };
            launcherLogoMode = "os";
            launcherLogoCustomPath = "";
            launcherLogoColorOverride = "primary";
            launcherLogoColorInvertOnMode = false;
            launcherLogoBrightness = 0.5;
            launcherLogoContrast = 1;
            launcherLogoSizeOffset = 8;
            launcherPluginVisibility = { };
            launcherPluginOrder = [ ];

            # ── Running Apps ───────────────────────────────────────────────
            runningAppsCompactMode = true;
            barMaxVisibleApps = 0;
            barMaxVisibleRunningApps = 0;
            barShowOverflowBadge = true;
            runningAppsCurrentWorkspace = true;
            runningAppsGroupByApp = false;
            runningAppsCurrentMonitor = false;
            focusedWindowCompactMode = false;
            centeringMode = "index";

            # ── Music / Media ──────────────────────────────────────────────
            mediaSize = 1;
            waveProgressEnabled = true;
            scrollTitleEnabled = true;
            audioVisualizerEnabled = true;
            audioScrollMode = "volume";
            audioWheelScrollAmount = 5;

            # ── Clock / Calendar ───────────────────────────────────────────
            clockCompactMode = false;
            clockDateFormat = "";
            use24HourClock = true;
            showSeconds = true;
            padHours12Hour = false;
            firstDayOfWeek = -1;
            showWeekNumber = false;
            nightModeEnabled = false;

            # ── Weather ────────────────────────────────────────────────────
            weatherEnabled = true;
            useAutoLocation = false;
            useFahrenheit = true;
            windSpeedUnit = "kmh";

            # ── Typography ─────────────────────────────────────────────────
            fontFamily = "Inter Variable";
            monoFontFamily = "Fira Code";
            fontWeight = 400;
            fontScale = 1;

            # ── Icon / Cursor ──────────────────────────────────────────────
            iconTheme = "System Default";
            cursorSettings = {
              theme = "System Default";
              size = 24;
              niri = {
                hideWhenTyping = false;
                hideAfterInactiveMs = 0;
              };
              hyprland = {
                hideOnKeyPress = false;
                hideOnTouch = false;
                inactiveTimeout = 0;
              };
              dwl = {
                cursorHideTimeout = 0;
              };
            };

            # ── Notifications ──────────────────────────────────────────────
            notificationOverlayEnabled = true;
            notificationPopupShadowEnabled = true;
            notificationPopupPrivacyMode = false;
            notificationTimeoutLow = 5000;
            notificationTimeoutNormal = 5000;
            notificationTimeoutCritical = 0;
            notificationCompactMode = false;
            notificationPopupPosition = 0;
            notificationAnimationSpeed = 1;
            notificationCustomAnimationDuration = 400;
            notificationHistoryEnabled = true;
            notificationHistoryMaxCount = 50;
            notificationHistoryMaxAgeDays = 7;
            notificationHistorySaveLow = true;
            notificationHistorySaveNormal = true;
            notificationHistorySaveCritical = true;
            notificationRules = [ ];
            notificationFocusedMonitor = true;

            # ── OSD ────────────────────────────────────────────────────────
            osdAlwaysShowValue = true;
            osdPosition = 5;
            osdVolumeEnabled = true;
            osdMediaVolumeEnabled = true;
            osdMediaPlaybackEnabled = true;
            osdBrightnessEnabled = true;
            osdIdleInhibitorEnabled = true;
            osdMicMuteEnabled = true;
            osdCapsLockEnabled = true;
            osdPowerProfileEnabled = false;
            osdAudioOutputEnabled = true;

            # ── Lock Screen ────────────────────────────────────────────────
            lockScreenShowPowerActions = true;
            lockScreenShowSystemIcons = true;
            lockScreenShowTime = true;
            lockScreenShowDate = true;
            lockScreenShowProfileImage = true;
            lockScreenShowPasswordField = true;
            lockScreenShowMediaPlayer = true;
            lockScreenPowerOffMonitorsOnLock = false;
            lockAtStartup = false;
            enableFprint = false;
            maxFprintTries = 15;
            enableU2f = false;
            u2fMode = "or";
            lockScreenActiveMonitor = "all";
            lockScreenInactiveColor = "#000000";
            lockScreenNotificationMode = 0;
            lockScreenVideoEnabled = false;
            lockScreenVideoPath = "";
            lockScreenVideoCycling = false;
            lockDateFormat = "";
            greeterRememberLastSession = true;
            greeterRememberLastUser = true;
            greeterEnableFprint = false;
            greeterEnableU2f = false;
            greeterWallpaperPath = "";
            greeterUse24HourClock = true;
            greeterShowSeconds = false;
            greeterPadHours12Hour = false;
            greeterLockDateFormat = "";
            greeterFontFamily = "";
            greeterWallpaperFillMode = "";
            fadeToLockEnabled = true;
            fadeToLockGracePeriod = 5;
            fadeToDpmsEnabled = true;
            fadeToDpmsGracePeriod = 5;
            loginctlLockIntegration = true;
            hideBrightnessSlider = false;

            # ── Power Menu ─────────────────────────────────────────────────
            powerActionConfirm = true;
            powerActionHoldDuration = 0.5;
            powerMenuActions = [
              "reboot"
              "logout"
              "poweroff"
              "lock"
              "suspend"
              "restart"
            ];
            powerMenuDefaultAction = "logout";
            powerMenuGridLayout = false;
            customPowerActionLock = "";
            customPowerActionLogout = "";
            customPowerActionSuspend = "";
            customPowerActionHibernate = "";
            customPowerActionReboot = "";
            customPowerActionPowerOff = "";

            # ── Power / Display timeouts ───────────────────────────────────
            acMonitorTimeout = 0;
            acLockTimeout = 0;
            acSuspendTimeout = 0;
            acSuspendBehavior = 0;
            acProfileName = "";
            batteryMonitorTimeout = 0;
            batteryLockTimeout = 0;
            batterySuspendTimeout = 0;
            batterySuspendBehavior = 0;
            batteryProfileName = "";
            batteryChargeLimit = 100;
            lockBeforeSuspend = false;
            brightnessDevicePins = { };

            # ── Display ────────────────────────────────────────────────────
            displayNameMode = "system";
            niriOutputSettings = { };
            hyprlandOutputSettings = { };
            displayProfiles = { };
            activeDisplayProfile = { };
            displayProfileAutoSelect = false;
            displayShowDisconnected = false;
            displaySnapToEdge = true;

            # ── Network / Bluetooth / Audio pins ──────────────────────────
            networkPreference = "auto";
            wifiNetworkPins = { };
            bluetoothDevicePins = { };
            audioInputDevicePins = { };
            audioOutputDevicePins = { };

            # ── System Monitor ─────────────────────────────────────────────
            systemMonitorEnabled = false;
            systemMonitorShowHeader = true;
            systemMonitorTransparency = 0.8;
            systemMonitorColorMode = "primary";
            systemMonitorShowCpu = true;
            systemMonitorShowCpuGraph = true;
            systemMonitorShowCpuTemp = true;
            systemMonitorShowGpuTemp = false;
            systemMonitorGpuPciId = "";
            systemMonitorShowMemory = true;
            systemMonitorShowMemoryGraph = true;
            systemMonitorShowNetwork = true;
            systemMonitorShowNetworkGraph = true;
            systemMonitorShowDisk = true;
            systemMonitorShowTopProcesses = false;
            systemMonitorTopProcessCount = 3;
            systemMonitorTopProcessSortBy = "cpu";
            systemMonitorGraphInterval = 60;
            systemMonitorLayoutMode = "auto";
            systemMonitorX = -1;
            systemMonitorY = -1;
            systemMonitorWidth = 320;
            systemMonitorHeight = 480;
            systemMonitorDisplayPreferences = [ "all" ];
            systemMonitorVariants = [ ];

            # ── Misc / Other ───────────────────────────────────────────────
            modalDarkenBackground = true;
            syncModeWithPortal = true;
            terminalsAlwaysDark = false;
            muxType = "tmux";
            muxUseCustomCommand = false;
            muxCustomCommand = "";
            muxSessionFilter = "";
            launchPrefix = "";
            keyboardLayoutNameCompactMode = false;
            appIdSubstitutions = [
              { pattern = "Spotify";                          replacement = "spotify";              type = "exact"; }
              { pattern = "beepertexts";                      replacement = "beeper";               type = "exact"; }
              { pattern = "home assistant desktop";           replacement = "homeassistant-desktop"; type = "exact"; }
              { pattern = "com.transmissionbt.transmission";  replacement = "transmission-gtk";     type = "contains"; }
              { pattern = "^steam_app_(\\d+)$";               replacement = "steam_icon_$1";        type = "regex"; }
            ];

            # ── Notepad ────────────────────────────────────────────────────
            notepadUseMonospace = true;
            notepadFontFamily = "";
            notepadFontSize = 14;
            notepadShowLineNumbers = false;
            notepadTransparencyOverride = -1;
            notepadLastCustomTransparency = 0.7;

            # ── Sounds ─────────────────────────────────────────────────────
            soundsEnabled = true;
            useSystemSoundTheme = false;
            soundNewNotification = true;
            soundVolumeChanged = true;
            soundPluggedIn = true;

            # ── Updater ────────────────────────────────────────────────────
            updaterHideWidget = false;
            updaterUseCustomCommand = false;
            updaterCustomCommand = "";
            updaterTerminalAdditionalParams = "";

            # ── Clipboard ──────────────────────────────────────────────────
            clipboardEnterToPaste = false;

            # ── Desktop Widgets ────────────────────────────────────────────
            desktopClockEnabled = false;
            desktopClockStyle = "analog";
            desktopClockTransparency = 0.8;
            desktopClockColorMode = "primary";
            desktopClockShowDate = true;
            desktopClockShowAnalogNumbers = false;
            desktopClockShowAnalogSeconds = true;
            desktopClockX = -1;
            desktopClockY = -1;
            desktopClockWidth = 280;
            desktopClockHeight = 180;
            desktopClockDisplayPreferences = [ "all" ];
            desktopWidgetPositions = { };
            desktopWidgetGridSettings = { };
            desktopWidgetInstances = [ ];
            desktopWidgetGroups = [ ];

            # ── Built-in plugin settings ───────────────────────────────────
            builtInPluginSettings = {
              dms_settings_search = { trigger = "?"; };
            };

            # ── Misc registry / version ────────────────────────────────────
            customThemeFile = "";
            registryThemeVariants = { };
            configVersion = 5;
          };
        in
        {
          ".config/DankMaterialShell/settings.json" = {
            generator = toJSON;
            value = settings;
          };
        } // pluginFiles;
    };
}
