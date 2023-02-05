{ lib, config, ... }: {
  options.satellite-dev = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "While true, makes out of store symlinks for files in dev mode";
    };

    root = lib.mkOption {
      type = lib.types.str;
      default = "~/Projects/satellite";
      description = "Where the satellite repo is cloned";
    };

    path = lib.mkOption {
      type = lib.types.functionTo lib.types.path;
      description = "The function used to conditionally symlink in or out of store based on the above paths";
    };
  };

  config.satellite-dev.path = path:
    if config.satellite-dev.enable then
      config.lib.file.mkOutOfStoreSymlink "${config.satellite-dev.root}/${path}"
    else "${../..}/${path}";
}
