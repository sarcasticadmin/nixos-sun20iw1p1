{ stdenv, lib, fetchFromGitHub, kernel, kmod, breakpointHook }:

stdenv.mkDerivation rec {
  name = "sharp-memory-lcd-${version}-${kernel.version}";
  #version = "unstable-20230420";
  version = "0";

  src = fetchFromGitHub {
    owner = "sarcasticadmin";
    repo = "Sharp-Memory-LCD-Kernel-Driver";
    rev = "0a7cea8629d0cdb64c806605f0dbcaf7fa42d18f";
    sha256 = "sha256-waEhVf7yh5EGSBhk+vSUJUIXxLyl4pB3h8rQNXX/A34=";
  };

  hardeningDisable = [ "pic" ];

  #nativeBuildInputs = [ breakpointHook kernel.moduleBuildDependencies ];                       # 2
  nativeBuildInputs = [ kernel.moduleBuildDependencies ];

  makeFlags = kernel.makeFlags ++ [
    "VERSION=${version}"
    "KROOT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
    cp sharp.ko $out/lib/modules/${kernel.modDirVersion}/misc/
  '';

  #buildPhase = ''
  #  make $makeFlags
  #'';

  #installPhase = ''
  #  runHook preInstall
  #  install -D hid-ite8291r3.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
  #  runHook postInstall
  #''; 

  #makeFlags = kernel.makeFlags ++ [
  #  "-C"
  #  "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  #  "M=$(sourceRoot)"
  #];

  #buildFlags = [ "modules" ];
  #installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  #installTargets = [ "modules_install" ];
  #makeFlags = [
  #  "KERNELRELEASE=${kernel.modDirVersion}"                                 # 3
  #  "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"    # 4
  #  "INSTALL_MOD_PATH=$(out)"                                               # 5
  #];

  #buildPhase = ''
  

  meta = with lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/aramg/droidcam";
    license = licenses.gpl2;
    maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
  };
}
