{ stdenv, fetchurl, libusb }:

stdenv.mkDerivation rec {
  name = "libphidget22";
  version = "22";

  src = fetchurl {
    url = "https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22.tar.gz";
    sha256 = "1nvi1kax9pzbbhqylzy3bf6hs2p7isbixk91fmfbjw0jnj06vsns";
  };

  #outputs = [ "out" "dev" ];

  nativeBuildInputs = [ ];
  propagatedBuildInputs = [ libusb ];

  meta = with stdenv.lib; {
    homepage = https://www.phidgets.com/;
    license = with licenses; [gpl3 lgpl3];
  };
}
