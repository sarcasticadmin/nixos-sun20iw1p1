{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "riscv64-linux";
  nixpkgs.overlays = [ (import ./overlay.nix) ];
  imports = [ "${modulesPath}/installer/sd-card/sd-image.nix" ];

  # Boot0 -> U-Boot
  sdImage = {
    #firmwarePartitionOffset = 20;
    postBuildCommands = ''
      dd if=${pkgs.ubootLicheeRV}/u-boot-sunxi-with-spl.bin of=$img bs=1024 seek=8 conv=notrunc
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    # Sun20i_d1_spl doesn't support loading U-Boot from a partition. The line below is a stub
    populateFirmwareCommands = "";
    # compressImage = false;
  };

  # U-Boot -> kernel -> initrd -> init
  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;

    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = pkgs.linuxPackages_nezha;
    kernelParams = [ "console=ttyS0,115200n8" "console=tty1" "earlycon=sbi" ];

    initrd.availableKernelModules = lib.mkForce [ ];

    kernelModules = [ "sharp" ];

    extraModulePackages = [ pkgs.linuxPackages_nezha.rtl8723ds pkgs.linuxPackages_nezha.sharp-lcd ];
    # Exclude zfs
    supportedFilesystems = lib.mkForce [ ];
  };

  nix.settings = {
    substituters = [
      "https://cache.nichi.co" # x86_64-linux cross build cache
      "https://unmatched.cachix.org" # Native / emulated build cache, however it is a bit old
    ];
    trusted-public-keys = [
      "hydra.nichi.co-0:P3nkYHhmcLR3eNJgOAnHDjmQLkfqheGyhZ6GLrUVHwk="
      "unmatched.cachix.org-1:F8TWIP/hA2808FDABsayBCFjrmrz296+5CQaysosTTc="
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };
}
