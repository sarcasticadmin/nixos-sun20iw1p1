{ lib
, fetchFromGitHub
, buildUBoot
, opensbi
, writeText
, dtb ? "arch/riscv/dts/sun20i-d1-lichee-rv-dock.dtb"
}:

let
  toc1Config = writeText "toc1.cfg" ''
    [opensbi]
    file = ${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin
    addr = 0x40000000
    [dtb]
    file = ${dtb}
    addr = 0x44000000
    [u-boot]
    file = u-boot-nodtb.bin
    addr = 0x4a000000
  '';
in

buildUBoot {
  version = "unstable-2022-05-27";

  src = fetchFromGitHub {
    owner = "smaeul";
    repo = "u-boot";
    # Last git revision from the `d1-wip` branch:
    rev = "528ae9bc6c55edd3ffe642734b4132a8246ea777";
    sha256 = "sha256-OtmGIqRN6f4ab5Xob4X/e7q4wzsA87qvR672zlMT0+U=";
  };

  defconfig = "nezha_defconfig";
  OPENSBI = "${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin";
  extraMeta.platforms = [ "riscv64-linux" ];

  filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
}
