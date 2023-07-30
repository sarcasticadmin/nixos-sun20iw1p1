{ stdenv, lib, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "sharp-memory-lcd-${version}-${kernel.version}";
  version = "unstable-20230420";

  src = fetchFromGitHub {
    owner = "w4ilun";
    repo = "Sharp-Memory-LCD-Kernel-Driver";
    rev = "56fc25d3cc0d8d32065b6e54f3901378a1b83dea";
    sha256 = "";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;                       # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"                                 # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"    # 4
    "INSTALL_MOD_PATH=$(out)"                                               # 5
  ];

  meta = with lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/aramg/droidcam";
    license = licenses.gpl2;
    maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
  };
}
