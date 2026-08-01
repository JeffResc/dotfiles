{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "net-info";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/Alaz-Oz/Net-Info/releases/download/v${finalAttrs.version}/Net.Info.zip";
    hash = "sha256-4BF9ZWAjIGCmI3G5gW+KRAc8KT+1tPHShoSCow0Vn2g=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -r "Net Info.app" "$out/Applications/Net Info.app"
    runHook postInstall
  '';

  meta = {
    description = "macOS menu bar extension to show network speed";
    homepage = "https://github.com/Alaz-Oz/Net-Info";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
