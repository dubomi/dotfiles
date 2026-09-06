# Out-of-tree kernel driver for AIC8800FC WiFi chipset (BrosTrend AX5L / AX300).
# Produces two .ko files (aic8800_fdrv, aic_load_fw) and installs the firmware
# blobs so NixOS can find them under lib/firmware/aic8800/.
{ lib, stdenv, fetchFromGitHub, kernel }:
stdenv.mkDerivation {
  pname = "aic8800";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "fqrious";
    repo = "aic8800-dkms";
    rev = "f8995f447bbf7a15f923d62102db9a8b64ac0e78";
    hash = "sha256-Lc/uUNw2UebcdB0h6Vqz2QpwXgWGhaYUJik7y5VApjk=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    runHook preBuild
    cd src
    make \
      KVER=${kernel.modDirVersion} \
      KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      ARCH=${stdenv.hostPlatform.linuxArch}
    cd ..
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    modDir=$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800
    install -Dm644 src/aic8800_fdrv/aic8800_fdrv.ko "$modDir/aic8800_fdrv.ko"
    install -Dm644 src/aic_load_fw/aic_load_fw.ko   "$modDir/aic_load_fw.ko"
    for blob in blobs/aic8800/*; do
      install -Dm644 "$blob" "$out/lib/firmware/aic8800/$(basename "$blob")"
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux kernel driver and firmware for AIC8800FC WiFi (BrosTrend AX5L)";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
