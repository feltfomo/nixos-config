{ lib, ... }:
let
  vars = import ./../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {

    ".config-hyprland/noctalia/plugins/submap-osd/manifest.json" = {
      generator = lib.generators.toJSON { };
      value = {
        id = "submap-osd";
        name = "Submap OSD";
        version = "1.0.0";
        minNoctaliaVersion = "3.6.0";
        author = "feltfomo";
        license = "MIT";
        repository = "local";
        description = "OSD overlay showing active Hyprland submap";
        entryPoints = { main = "Main.qml"; };
        dependencies = { plugins = []; };
        metadata = { defaultSettings = {}; };
      };
    };

    ".config-hyprland/noctalia/plugins/submap-osd/Main.qml".text = ''
      import QtQuick
      import Quickshell
      import Quickshell.Io
      import Quickshell.Wayland
      import qs.Commons

      Item {
          id: root
          property var pluginApi: null
          property string submapName: ""

          signal showOsd()
          signal hideOsd()

          Process {
              id: fileReader
              command: ["cat", "/tmp/hypr-submap"]
              stdout: SplitParser {
                  onRead: data => root.submapName = data.trim()
              }
          }

          IpcHandler {
              target: "plugin:submap-osd"

              function display(): void {
                  Logger.i("SubOSD", "display called");
                  fileReader.running = true;
                  root.showOsd();
                  hideTimer.restart();
              }

              function dismiss(): void {
                  root.hideOsd();
              }
          }

          Timer {
              id: hideTimer
              interval: 3000
              onTriggered: root.hideOsd()
          }

          Variants {
              model: Quickshell.screens
              PanelWindow {
                  id: osdWindow
                  required property var modelData
                  screen: modelData
                  visible: false
                  color: "transparent"
                  anchors {
                      bottom: true
                      left: true
                      right: true
                  }
                  margins.bottom: 80
                  exclusionMode: ExclusionMode.Ignore
                  WlrLayershell.layer: WlrLayer.Overlay
                  WlrLayershell.namespace: "submap-osd"
                  implicitHeight: 56

                  Connections {
                      target: root
                      function onShowOsd() {
                          pluginApi.withCurrentScreen(function(currentScreen) {
                              if (osdWindow.screen === currentScreen) {
                                  osdWindow.visible = true;
                                  osdContent.opacity = 1;
                              }
                          });
                      }
                      function onHideOsd() {
                          osdContent.opacity = 0;
                      }
                  }

                  Item {
                      id: osdContent
                      anchors.fill: parent
                      opacity: 0

                      Behavior on opacity {
                          NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                      }

                      onOpacityChanged: {
                          if (opacity === 0) osdWindow.visible = false;
                      }

                      Rectangle {
                          anchors.centerIn: parent
                          width: pill.implicitWidth + 40
                          height: 48
                          radius: 24
                          color: Qt.alpha(Color.mSurface, 0.75)
                          border.color: Qt.alpha(Color.mOutline, 0.3)
                          border.width: 1

                          Row {
                              id: pill
                              anchors.centerIn: parent
                              spacing: 8

                              Rectangle {
                                  width: 26
                                  height: 26
                                  radius: Style.radiusS
                                  color: Qt.alpha(Color.mPrimary, 0.18)
                                  anchors.verticalCenter: parent.verticalCenter

                                  Text {
                                      anchors.centerIn: parent
                                      text: "󰌌"
                                      color: Color.mPrimary
                                      font.pixelSize: 15
                                      font.family: "JetBrainsMono Nerd Font"
                                  }
                              }

                              Text {
                                  anchors.verticalCenter: parent.verticalCenter
                                  text: "Submap:"
                                  color: Color.mOnSurfaceVariant
                                  font.pixelSize: 12
                                  font.family: Settings.data.ui.fontMain
                              }

                              Text {
                                  anchors.verticalCenter: parent.verticalCenter
                                  text: root.submapName
                                  color: Color.mOnSurface
                                  font.pixelSize: 14
                                  font.family: Settings.data.ui.fontMain
                              }
                          }
                      }
                  }
              }
          }
      }
    '';

  };
}
