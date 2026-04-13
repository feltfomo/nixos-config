{ inputs, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.zen = { pkgs, lib, ... }:
  let
    system = pkgs.stdenv.hostPlatform.system;

    sources = builtins.fromJSON (builtins.readFile "${inputs.zen-browser}/sources.json");
    sinePack = {
      manager = pkgs.fetchFromGitHub {
        inherit (sources.addons.sine.manager) rev hash;
        repo = "Sine";
        owner = "CosmoCreeper";
      };
      bootloader = pkgs.fetchFromGitHub {
        inherit (sources.addons.sine.bootloader) rev hash;
        repo = "bootloader";
        owner = "sineorg";
      };
    };

    zenUnwrapped = (inputs.zen-browser.packages.${system}."twilight-unwrapped").overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        for libdir in "$out"/lib/zen-bin-*; do
          chmod -R u+w "$libdir"
          cp "${sinePack.bootloader}/program/config.js" "$libdir/config.js"
          mkdir -p "$libdir/defaults/pref"
          cp "${sinePack.bootloader}/program/defaults/pref/config-prefs.js" "$libdir/defaults/pref/config-prefs.js"
        done
      '';
    });

    zen = pkgs.wrapFirefox zenUnwrapped {
      icon = "zen-twilight";
      extraPrefs = "";
      extraPrefsFiles = [];
    };

    desktopFile = "zen-twilight.desktop";
    profilePath = "/home/${vars.username}/.config/zen/${vars.zenProfile}";

    sineMods = [
      "Nebula"
    ];

    spaces = {};
    pins = {};
    keyboardShortcuts = [];

    sineManagerScript = pkgs.writeShellScript "zen-sine-manager" ''
      if [ ! -d "${profilePath}" ]; then
        echo "zen: profile not found yet, skipping sine manager"
        exit 0
      fi

      CHROME_DIR="${profilePath}/chrome"
      mkdir -p "$CHROME_DIR/JS"
      mkdir -p "$CHROME_DIR/utils"
      mkdir -p "$CHROME_DIR/locales"

      cp -rf "${sinePack.manager}/engine" "$CHROME_DIR/JS/engine"
      cp -f "${sinePack.manager}/sine.sys.mjs" "$CHROME_DIR/JS/sine.sys.mjs"
      cp -rf "${sinePack.bootloader}/profile/utils/." "$CHROME_DIR/utils/"
      cp -rf "${sinePack.manager}/locales/." "$CHROME_DIR/locales/"
    '';

    sineModsScript = pkgs.writeShellScript "zen-sine-mods" ''
      if [ ! -d "${profilePath}" ]; then
        echo "zen: profile not found yet, skipping sine mods"
        exit 0
      fi

      MODS_FILE="${profilePath}/chrome/sine-mods/mods.json"
      MANAGED_FILE="${profilePath}/zen-sine-mods-nix-managed.json"
      BASE_DIR="${profilePath}"
      SINE_MODS="${lib.concatStringsSep " " sineMods}"

      mkdir -p "$BASE_DIR/chrome/sine-mods"

      if [ ! -f "$MODS_FILE" ]; then
        echo '{}' > "$MODS_FILE"
      fi

      if [ -f "$MANAGED_FILE" ]; then
        CURRENT_MANAGED=$(${lib.getExe pkgs.jq} -r '.[]' "$MANAGED_FILE" 2>/dev/null || echo "")
      else
        CURRENT_MANAGED=""
      fi

      for mod_id in $CURRENT_MANAGED; do
        if [[ " $SINE_MODS " != *" $mod_id "* ]]; then
          ${lib.getExe pkgs.jq} "del(.[\"$mod_id\"])" "$MODS_FILE" > "$MODS_FILE.tmp" && mv "$MODS_FILE.tmp" "$MODS_FILE"
          rm -rf "$BASE_DIR/chrome/sine-mods/$mod_id"
          echo "Removed sine mod $mod_id"
        fi
      done

      for mod_id in $SINE_MODS; do
        MOD_DIR="$BASE_DIR/chrome/sine-mods/$mod_id"
        if [ -d "$MOD_DIR" ]; then
          continue
        fi
        mkdir -p "$MOD_DIR"
        INSTALLED=false

        SINE_URL="https://raw.githubusercontent.com/sineorg/store/main/mods/$mod_id/mod.zip"
        TMPZIP=$(mktemp -d)
        echo "Fetching sine mod $mod_id..."

        if ${lib.getExe pkgs.curl} -sfL "$SINE_URL" -o "$TMPZIP/mod.zip" 2>/dev/null; then
          if ${lib.getExe pkgs.unzip} -o "$TMPZIP/mod.zip" -d "$TMPZIP/extracted" >/dev/null 2>&1; then
            ITEMS=("$TMPZIP/extracted"/*)
            if [ ''${#ITEMS[@]} -eq 1 ] && [ -d "''${ITEMS[0]}" ]; then
              cp -r "''${ITEMS[0]}"/* "$MOD_DIR/" 2>/dev/null || true
              cp -r "''${ITEMS[0]}"/.* "$MOD_DIR/" 2>/dev/null || true
            else
              cp -r "$TMPZIP/extracted"/* "$MOD_DIR/" 2>/dev/null || true
            fi
            INSTALLED=true
            echo "Installed sine mod $mod_id from Sine store"
          fi
        fi
        rm -rf "$TMPZIP"

        if [ "$INSTALLED" = false ]; then
          echo "Falling back to Zen theme store for $mod_id..."
          THEME_URL="https://raw.githubusercontent.com/zen-browser/theme-store/main/themes/$mod_id/theme.json"
          THEME_JSON=$(${lib.getExe pkgs.curl} -s "$THEME_URL")
          if [ -z "$THEME_JSON" ] || ! echo "$THEME_JSON" | ${lib.getExe pkgs.jq} empty 2>/dev/null; then
            echo "Failed to fetch mod $mod_id from both stores"
            rm -rf "$MOD_DIR"
            continue
          fi
          echo "$THEME_JSON" > "$MOD_DIR/theme.json"
          for file in chrome.css preferences.json readme.md; do
            ${lib.getExe pkgs.curl} -s "https://raw.githubusercontent.com/zen-browser/theme-store/main/themes/$mod_id/$file" \
              -o "$MOD_DIR/$file" || true
          done
          INSTALLED=true
        fi

        if [ "$INSTALLED" = true ] && [ -f "$MOD_DIR/theme.json" ]; then
          THEME_DATA=$(cat "$MOD_DIR/theme.json")
          TRANSFORMED=$(echo "$THEME_DATA" | ${lib.getExe pkgs.jq} '
            def to_local: if (. // "" | test("^https?://")) then (split("/") | last) else . end;
            .enabled = true |
            ."no-updates" = false |
            .style = (
              if (.style | type) == "string" then { "chrome": (.style | to_local), "content": "" }
              elif (.style | type) == "object" then
                { "chrome": ((.style.chrome // "") | to_local), "content": ((.style.content // "") | to_local) }
              else { "chrome": "", "content": "" }
              end
            ) |
            if .preferences then .preferences = (.preferences | to_local) else . end |
            if .readme then .readme = (.readme | to_local) else . end
          ')
          ${lib.getExe pkgs.jq} --arg id "$mod_id" --argjson theme "$TRANSFORMED" \
            '.[$id] = $theme' "$MODS_FILE" > "$MODS_FILE.tmp" && mv "$MODS_FILE.tmp" "$MODS_FILE"
        fi
      done

      echo "$SINE_MODS" | tr ' ' '\n' | ${lib.getExe pkgs.jq} -R -s \
        'split("\n") | map(select(. != ""))' > "$MANAGED_FILE"

      CHROME_CSS="$BASE_DIR/chrome/sine-mods/chrome.css"
      CONTENT_CSS="$BASE_DIR/chrome/sine-mods/content.css"
      for f in "$CHROME_CSS" "$CONTENT_CSS"; do
        printf '/* Sine Mods - Generated by NixOS.\n * DO NOT EDIT DIRECTLY.\n */\n' > "$f"
      done

      ENABLED_MODS=$(${lib.getExe pkgs.jq} -r \
        'to_entries[] | select(.value.enabled == null or .value.enabled == true) | .key' "$MODS_FILE")

      for mod_id in $ENABLED_MODS; do
        CHROME_FILE=$(${lib.getExe pkgs.jq} -r ".\"$mod_id\".style.chrome // empty" "$MODS_FILE")
        CONTENT_FILE=$(${lib.getExe pkgs.jq} -r ".\"$mod_id\".style.content // empty" "$MODS_FILE")
        MOD_NAME=$(${lib.getExe pkgs.jq} -r ".\"$mod_id\".name // \"$mod_id\"" "$MODS_FILE")
        MOD_AUTHOR=$(${lib.getExe pkgs.jq} -r ".\"$mod_id\".author // \"unknown\"" "$MODS_FILE")
        if [ -n "$CHROME_FILE" ] && [ -f "$BASE_DIR/chrome/sine-mods/$mod_id/$CHROME_FILE" ]; then
          printf '/* %s by @%s */\n' "$MOD_NAME" "$MOD_AUTHOR" >> "$CHROME_CSS"
          cat "$BASE_DIR/chrome/sine-mods/$mod_id/$CHROME_FILE" >> "$CHROME_CSS"
          echo "" >> "$CHROME_CSS"
        fi
        if [ -n "$CONTENT_FILE" ] && [ -f "$BASE_DIR/chrome/sine-mods/$mod_id/$CONTENT_FILE" ]; then
          printf '/* %s by @%s */\n' "$MOD_NAME" "$MOD_AUTHOR" >> "$CONTENT_CSS"
          cat "$BASE_DIR/chrome/sine-mods/$mod_id/$CONTENT_FILE" >> "$CONTENT_CSS"
          echo "" >> "$CONTENT_CSS"
        fi
      done

      echo "/* End of Sine Mods */" >> "$CHROME_CSS"
      echo "/* End of Sine Mods */" >> "$CONTENT_CSS"
    '';

    sessionsScript = pkgs.writeShellScript "zen-sessions" (
      let
        spacesJson = builtins.toJSON (lib.mapAttrsToList (_: s: {
          uuid = "{${s.id}}";
          inherit (s) name position;
          icon = s.icon;
          containerTabId = if s.container == null then 0 else s.container;
          theme = {
            type = if s.theme.type == null then "gradient" else s.theme.type;
            gradientColors = if s.theme.colors == null then [] else
              map (c: {
                inherit (c) algorithm lightness position type;
                c = [c.red c.green c.blue];
                isCustom = c.custom;
                isPrimary = c.primary or true;
              }) s.theme.colors;
            opacity = if s.theme.opacity == null then 0.5 else s.theme.opacity;
            rotation = s.theme.rotation;
            texture = if s.theme.texture == null then 0.0 else s.theme.texture;
          };
          hasCollapsedPinnedTabs = false;
        }) spaces);

        nonGroupPins = lib.filterAttrs (_: p: !p.isGroup) pins;
        pinsJson = builtins.toJSON (lib.mapAttrsToList (_: p:
          {
            pinned = true;
            hidden = false;
            zenWorkspace = if p.workspace == null then null else "{${p.workspace}}";
            zenSyncId = "{${p.id}}";
            zenEssential = p.isEssential;
            zenDefaultUserContextId = "true";
            zenPinnedIcon = null;
            zenIsEmpty = false;
            zenHasStaticIcon = false;
            zenGlanceId = null;
            zenIsGlance = false;
            searchMode = null;
            userContextId = if p.container == null then 0 else p.container;
            attributes = {};
            index = p.position;
            lastAccessed = 0;
            groupId = if p.isGroup || p.folderParentId != null
              then (if p.isGroup then "{${p.id}}" else "{${p.folderParentId}}")
              else null;
          }
          // lib.optionalAttrs p.editedTitle { zenStaticLabel = p.title; }
          // lib.optionalAttrs (p.url != null) {
            entries = [{ url = p.url; title = p.title; charset = "UTF-8"; ID = 0; persist = true; }];
          }
        ) nonGroupPins);

        groupPins = lib.filterAttrs (_: p: p.isGroup) pins;
        foldersJson = builtins.toJSON (map (f: {
          pinned = true;
          splitViewGroup = false;
          id = f.id;
          name = f.name;
          collapsed = f.collapsed;
          saveOnWindowClose = true;
          parentId = f.parentId;
          prevSiblingInfo = { type = "start"; id = null; };
          emptyTabIds = [];
          userIcon = if f.icon == null then "" else f.icon;
          workspaceId = f.workspaceId;
          index = f.index;
        }) (lib.mapAttrsToList (_: p: {
          id = "{${p.id}}";
          name = p.title;
          collapsed = p.isFolderCollapsed or false;
          icon = p.folderIcon;
          parentId = if p.folderParentId == null then null else "{${p.folderParentId}}";
          workspaceId = if p.workspace == null then null else "{${p.workspace}}";
          index = p.position;
        }) groupPins));

        spacesFile = pkgs.writeText "zen-spaces.json" spacesJson;
        pinsFile = pkgs.writeText "zen-pins.json" pinsJson;
        foldersFile = pkgs.writeText "zen-folders.json" foldersJson;
      in
      ''
        SESSIONS_FILE="${profilePath}/zen-sessions.jsonlz4"
        SESSIONS_TMP="$(mktemp)"
        SESSIONS_MOD="$(mktemp)"
        BACKUP="$SESSIONS_FILE.backup"

        cleanup() { rm -f "$SESSIONS_TMP" "$SESSIONS_MOD"; }
        trap cleanup EXIT

        if [ ! -f "$SESSIONS_FILE" ]; then
          echo "zen-sessions: file not found, Zen will create it on first run"
          exit 0
        fi

        if pgrep -x zen-twilight > /dev/null 2>&1; then
          echo "zen-sessions: Zen is running, close it and rebuild to apply spaces/pins"
          exit 1
        fi

        cp "$SESSIONS_FILE" "$BACKUP"
        ${lib.getExe pkgs.mozlz4a} -d "$SESSIONS_FILE" "$SESSIONS_TMP" || { mv "$BACKUP" "$SESSIONS_FILE"; exit 1; }

        ${lib.getExe pkgs.jq} \
          --slurpfile spaces ${spacesFile} \
          --slurpfile pins ${pinsFile} \
          --slurpfile folders ${foldersFile} \
          '
            ($spaces[0]) as $ds | ($pins[0]) as $dp | ($folders[0]) as $df |
            .spaces = (.spaces // []) | .tabs = (.tabs // []) | .folders = (.folders // []) |
            ([$ds[].uuid]) as $dsUuids | ([.spaces[].uuid]) as $esUuids |
            .spaces = [.spaces[] | . as $e | ($ds | map(select(.uuid == $e.uuid)) | .[0] // null) as $o | if $o != null then ($e * $o) else . end] |
            .spaces += [$ds[] | select(.uuid as $u | $esUuids | index($u) | not)] |
            ([$dp[].zenSyncId]) as $dpIds | ([.tabs[].zenSyncId]) as $etIds |
            .tabs = [.tabs[] | . as $e | ($dp | map(select(.zenSyncId == $e.zenSyncId)) | .[0] // null) as $o | if $o != null then $e * {pinned: $o.pinned, zenEssential: $o.zenEssential, zenWorkspace: $o.zenWorkspace, userContextId: $o.userContextId, index: $o.index, entries: $o.entries, groupId: $o.groupId} else . end] |
            .tabs += [$dp[] | select(.zenSyncId as $id | $etIds | index($id) | not)] |
            ([$df[].id]) as $dfIds | ([.folders[].id]) as $efIds |
            .folders = [.folders[] | . as $e | ($df | map(select(.id == $e.id)) | .[0] // null) as $o | if $o != null then ($e * $o) else . end] |
            .folders += [$df[] | select(.id as $id | $efIds | index($id) | not)] |
            .tabs = (.tabs | sort_by(.index // 0)) |
            .folders = (.folders | sort_by(.index // 0))
          ' "$SESSIONS_TMP" > "$SESSIONS_MOD" || { mv "$BACKUP" "$SESSIONS_FILE"; exit 1; }

        [ -s "$SESSIONS_MOD" ] || { mv "$BACKUP" "$SESSIONS_FILE"; exit 1; }
        ${lib.getExe pkgs.mozlz4a} "$SESSIONS_MOD" "$SESSIONS_FILE" || { mv "$BACKUP" "$SESSIONS_FILE"; exit 1; }
        rm -f "$BACKUP"
      ''
    );

    shortcutsScript = pkgs.writeShellScript "zen-shortcuts" ''
      if [ ! -d "${profilePath}" ]; then
        echo "zen: profile not found yet, skipping shortcuts"
        exit 0
      fi

      SHORTCUTS_FILE="${profilePath}/zen-keyboard-shortcuts.json"

      if [ ! -f "$SHORTCUTS_FILE" ]; then
        echo "zen-shortcuts: file not found, Zen will create it on first run"
        exit 0
      fi

      OVERRIDES='${builtins.toJSON keyboardShortcuts}'

      MERGED=$(${lib.getExe pkgs.jq} --argjson overrides "$OVERRIDES" '
        .shortcuts |= map(
          . as $e |
          ($overrides | map(select(.id == $e.id)) | .[0]) as $o |
          if $o then
            { id: $e.id, group: $e.group, l10nId: $e.l10nId, action: $e.action, reserved: $e.reserved, internal: $e.internal }
            + { key: ($o.key // ""), keycode: ($o.keycode // null), modifiers: ($o.modifiers // {control:false,alt:false,shift:false,meta:false,accel:false}), disabled: ($o.disabled // false) }
          else $e end
        )
      ' "$SHORTCUTS_FILE")

      echo "$MERGED" > "$SHORTCUTS_FILE"
    '';

  in
  {
    hjem.users.${vars.username} = {
      packages = [ zen ];
      files.".config/zen/policies/policies.json" = {
        generator = builtins.toJSON;
        value = {
          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisableFeedbackCommands = true;
            DisablePocket = true;
            DontCheckDefaultBrowser = true;
            DisableAppUpdate = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            AutofillCreditCardEnabled = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
          };
        };
      };
    };

    xdg.mime.defaultApplications = {
      "text/html"                 = desktopFile;
      "x-scheme-handler/http"    = desktopFile;
      "x-scheme-handler/https"   = desktopFile;
      "x-scheme-handler/about"   = desktopFile;
      "x-scheme-handler/unknown" = desktopFile;
      "application/xhtml+xml"    = desktopFile;
      "x-scheme-handler/mailto"  = desktopFile;
      "x-scheme-handler/chrome"  = desktopFile;
      "application/json"         = desktopFile;
    };

    environment.sessionVariables.BROWSER = "zen-twilight";

    system.activationScripts.zenSineManager = {
      deps = [];
      text = ''
        echo "zen: installing sine manager..."
        ${sineManagerScript}
      '';
    };

    system.activationScripts.zenSineMods = {
      deps = [ "zenSineManager" ];
      text = ''
        echo "zen: updating sine mods..."
        ${sineModsScript}
      '';
    };

    system.activationScripts.zenSessions = {
      deps = [ "zenSineMods" ];
      text = ''
        echo "zen: updating spaces/pins..."
        ${sessionsScript}
      '';
    };

    system.activationScripts.zenShortcuts = {
      deps = [ "zenSessions" ];
      text = ''
        echo "zen: updating keyboard shortcuts..."
        ${shortcutsScript}
      '';
    };
  };
}
