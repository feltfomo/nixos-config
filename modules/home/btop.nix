{ config, pkgs, ... }:

{
  programs.btop = {
    enable = true;

    settings = {
      # Theme
      color_theme = "Default";
      theme_background = false;

      # Layout
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      shown_boxes = "cpu mem net proc";

      # Update
      update_ms = 1000;

      # Process
      proc_sorting = "cpu lazy";
      proc_colors = true;
      proc_gradient = true;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;

      # CPU
      cpu_invert_lower = true;
      show_uptime = true;
      show_cpu_watts = true;
      check_temp = true;
      show_coretemp = true;
      show_cpu_freq = true;

      # Memory
      mem_graphs = true;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      use_fstab = true;

      # Network
      net_auto = true;
      net_sync = true;

      # Misc
      rounded_corners = true;
      terminal_sync = true;
      graph_symbol = "braille";
      clock_format = "%X";
      background_update = true;
      log_level = "WARNING";
      save_config_on_exit = true;

      # GPU
      nvml_measure_pcie_speeds = true;
      gpu_mirror_graph = true;
      shown_gpus = "nvidia amd intel";
    };
  };
}
