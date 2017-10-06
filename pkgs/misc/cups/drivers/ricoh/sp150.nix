{ stdenv, requireFile, cups, glibc }:

stdenv.mkDerivation rec {
  name = "ricoh-sp150-linux-driver-${version}";
  version = "1.0-22";

  src = requireFile {
    name = "RICOH-SP-150_1.0-22_amd64.deb";
    sha256 = "104plzzzi7d0y74gv0nlgl37k7s3ky66lw31hwjsgwnp9pwrg7ly";
    message = ''
      Download the Ubuntu 12.04 LTS(x86-64) Driver from the RICOH website and extract it using Windows/Wine
    '';
  };

  sourceRoot = ".";
  unpackCmd = ''
    ar x "$src"
    tar xf data.tar.gz
  '';


  buildInputs = [
    cups
  ];

  installPhase = ''

    mkdir -p $out/lib
    install -m755 "opt/RICOH/lib/RICOH SP 150cl.so" $out/lib

    mkdir -p $out/bin
    cp "usr/lib/cups/filter/RICOH_SP_150Filter.app" $out/bin

    mkdir -p $out/lib/cups/filter
    ln -s "$out/bin/RICOH_SP_150Filter.app" $out/lib/cups/filter

    mkdir -p $out/share
    cp -R usr/share/* $out/share
  '';

  preFixup = ''
    for bin in "$out/bin/"*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$bin"
      patchelf --set-rpath "$out/lib:${stdenv.lib.getLib cups}/lib" "$bin"
    done

    ln -s ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/
  '';

  # all binaries are already stripped
  dontStrip = true;

  # we did this in prefixup already
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "Linux Driver for RICOH SP 150 printer";
    homepage = https://www.ricoh.com/;
    downloadPage = http://support.ricoh.com/bb/html/dr_ut_e/re1/model/sp150/sp150.htm;
    license = licenses.unfree;

    platforms = platforms.linux;
    maintainers = with maintainers; [ antonxy];
  };
}
