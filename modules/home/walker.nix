{ config, pkgs, ... }:
{
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "catppuccin-mocha";
    };

    themes = {
      "catppuccin-mocha" = {
        layouts = {
          "layout" = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <interface>
              <requires lib="gtk" version="4.0"></requires>
              <object class="GtkWindow" id="Window">
                <style>
                  <class name="window"></class>
                </style>
                <property name="resizable">true</property>
                <property name="title">Walker</property>
                <child>
                  <object class="GtkBox" id="BoxWrapper">
                    <style>
                      <class name="box-wrapper"></class>
                    </style>
                    <property name="width-request">644</property>
                    <property name="overflow">hidden</property>
                    <property name="orientation">horizontal</property>
                    <property name="valign">center</property>
                    <property name="halign">center</property>
                    <child>
                      <object class="GtkBox" id="Box">
                        <style>
                          <class name="box"></class>
                        </style>
                        <property name="orientation">vertical</property>
                        <property name="hexpand-set">true</property>
                        <property name="hexpand">true</property>
                        <property name="spacing">10</property>
                        <child>
                          <object class="GtkBox" id="SearchContainer">
                            <style>
                              <class name="search-container"></class>
                            </style>
                            <property name="overflow">hidden</property>
                            <property name="orientation">horizontal</property>
                            <property name="halign">fill</property>
                            <property name="hexpand-set">true</property>
                            <property name="hexpand">true</property>
                            <child>
                              <object class="GtkEntry" id="Input">
                                <style>
                                  <class name="input"></class>
                                </style>
                                <property name="halign">fill</property>
                                <property name="hexpand-set">true</property>
                                <property name="hexpand">true</property>
                              </object>
                            </child>
                          </object>
                        </child>
                        <child>
                          <object class="GtkBox" id="ContentContainer">
                            <style>
                              <class name="content-container"></class>
                            </style>
                            <property name="orientation">horizontal</property>
                            <property name="spacing">10</property>
                            <property name="vexpand">true</property>
                            <property name="vexpand-set">true</property>
                            <child>
                              <object class="GtkLabel" id="ElephantHint">
                                <style>
                                  <class name="elephant-hint"></class>
                                </style>
                                <property name="hexpand">true</property>
                                <property name="height-request">100</property>
                                <property name="label">Waiting for elephant...</property>
                              </object>
                            </child>
                            <child>
                              <object class="GtkLabel" id="Placeholder">
                                <style>
                                  <class name="placeholder"></class>
                                </style>
                                <property name="label">No Results</property>
                                <property name="yalign">0.0</property>
                                <property name="hexpand">true</property>
                              </object>
                            </child>
                            <child>
                              <object class="GtkScrolledWindow" id="Scroll">
                                <style>
                                  <class name="scroll"></class>
                                </style>
                                <property name="hexpand">true</property>
                                <property name="can_focus">false</property>
                                <property name="overlay-scrolling">true</property>
                                <property name="max-content-width">600</property>
                                <property name="max-content-height">500</property>
                                <property name="min-content-height">0</property>
                                <property name="propagate-natural-height">true</property>
                                <property name="propagate-natural-width">true</property>
                                <property name="hscrollbar-policy">automatic</property>
                                <property name="vscrollbar-policy">automatic</property>
                                <child>
                                  <object class="GtkGridView" id="List">
                                    <style>
                                      <class name="list"></class>
                                    </style>
                                    <property name="max_columns">1</property>
                                    <property name="can_focus">false</property>
                                  </object>
                                </child>
                              </object>
                            </child>
                            <child>
                              <object class="GtkBox" id="Preview">
                                <style>
                                  <class name="preview"></class>
                                </style>
                              </object>
                            </child>
                          </object>
                        </child>
                        <child>
                          <object class="GtkBox" id="Keybinds">
                            <property name="hexpand">true</property>
                            <property name="margin-top">10</property>
                            <style>
                              <class name="keybinds"></class>
                            </style>
                            <child>
                              <object class="GtkBox" id="GlobalKeybinds">
                                <property name="spacing">10</property>
                                <style>
                                  <class name="global-keybinds"></class>
                                </style>
                              </object>
                            </child>
                            <child>
                              <object class="GtkBox" id="ItemKeybinds">
                                <property name="hexpand">true</property>
                                <property name="halign">end</property>
                                <property name="spacing">10</property>
                                <style>
                                  <class name="item-keybinds"></class>
                                </style>
                              </object>
                            </child>
                          </object>
                        </child>
                        <child>
                          <object class="GtkLabel" id="Error">
                            <style>
                              <class name="error"></class>
                            </style>
                            <property name="xalign">0</property>
                            <property name="visible">false</property>
                          </object>
                        </child>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </interface>
          '';
        };

        style = ''
          * {
            all: unset;
          }

          * {
            font-family: "JetBrains Mono";
            font-size: 14px;
          }

          scrollbar {
            opacity: 0;
          }

          .normal-icons {
            -gtk-icon-size: 16px;
          }

          .large-icons {
            -gtk-icon-size: 36px;
          }

          .box-wrapper {
            background: alpha(#1e1e2e, 0.3);
            padding: 12px;
            border-radius: 20px;
            border: 2px solid #cba6f7;
            box-shadow:
              0 19px 38px rgba(0, 0, 0, 0.3),
              0 15px 12px rgba(0, 0, 0, 0.22);
            }

          .box {
            background: alpha(#181825, 0.3);
            padding: 20px;
            border-radius: 20px;
            border: 2px solid #313244;
          }

          .search-container {
            border-radius: 10px;
            border: 2px solid #313244;
          }

          .input {
            background: #1e1e2e;
            color: #cdd6f4;
            caret-color: #cdd6f4;
            padding: 10px;
          }

          .input placeholder {
            opacity: 0.5;
          }

          .preview-box,
          .elephant-hint,
          .placeholder {
            color: #cdd6f4;
          }

          .list {
            color: #cdd6f4;
          }

          .item-box {
            border-radius: 10px;
            padding: 10px;
          }

          .item-quick-activation {
            background: #cba6f7;
            border-radius: 10px;
            padding: 10px;
            color: #1e1e2e;
          }

          child:hover .item-box,
          child:selected .item-box {
            background: alpha(#cba6f7, 0.2);
          }

          child:selected .item-box *:not(.item-quick-activation) {
            color: #b4befe;
          }

          .item-subtext {
            font-size: 12px;
            opacity: 0.5;
          }

          .item-image {
            margin-right: 14px;
          }

          .keybinds-wrapper {
            border-top: 1px solid #cba6f7;
            font-size: 12px;
            color: #cba6f7;
          }

          .keybind {
            color: #6c7086;
          }

          .keybind-bind {
            font-weight: bold;
            text-transform: lowercase;
          }

          .preview {
            border-top: 1px solid #cba6f7;
            padding: 10px;
            border-radius: 10px;
            color: #cdd6f4;
          }

          .preview .large-icons {
            -gtk-icon-size: 64px;
          }

          .error {
            padding: 10px;
            background: #f38ba8;
            color: #1e1e2e;
          }

          :not(.calc).current {
            font-style: italic;
          }

          .calc .item-text {
            font-size: 24px;
          }

          .symbols .item-image {
            font-size: 24px;
          }
        '';
      };
    };
  };
}
