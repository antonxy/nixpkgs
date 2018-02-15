{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "xerces-c-${version}";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${name}.tar.gz";
    sha256 = "05af63yfkisbwn8pcms95a2rmbfhhjmwv2fcp3si4mm8ml82j5nk";
  };

  meta = {
    homepage = http://xerces.apache.org/xerces-c/;
    description = "Validating XML parser written in a portable subset of C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
