{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  autoconf,
  automake,
  libtool,

  gfortran,
  flex,
  bison,
  jre8,
  blas,
  lapack,
  curl,
  readline,
  expat,
  pkg-config,
  buildPackages,
  targetPackages,
  libffi,
  binutils,
  libuuid

}:

stdenv.mkDerivation rec {

  pname = "openmodelica";
  version = "1.25.0";
  src = fetchFromGitHub {
    owner = "OpenModelica";
    repo = "OpenModelica";
    rev = "25d97cae0c27d49286af2bdc95420d01f67ea064";
  #  "sha256": "07f0r93r7283h1wkc83xviahi31y5vnp6larhaj9ky54rhq73iyr",
    hash = "sha256-2cdxMMyk+JmkgllRc+0uPowIVdx9IDZ5gAOJk0fKwB0=";
    fetchSubmodules = true;
  };

  bootstrap_src = fetchFromGitHub {
    owner = "OpenModelica";
    repo = "OMBootstrapping";
    rev = "91938f0acbdc6e9ba91114376e3640ca6147b579";
    hash = "sha256-t5nwkuwJ2kuLdbvQ92HGdFcgNdlgoMOVVOgznwoe9/Y=";
  };


  nativeBuildInputs = [
    cmake

    autoconf
    automake
    libtool


    jre8
    gfortran
    flex
    bison
    pkg-config

  ];

  buildInputs = [
    blas
    lapack
    curl
    readline
    expat
    libffi
    binutils
    libuuid
  ];

  cmakeFlags = [
    "-DOM_USE_CCACHE=OFF"
    "-DOM_ENABLE_GUI_CLIENTS=OFF"
    "-DOM_OMC_ENABLE_CPP_RUNTIME=OFF"
  ];

  preConfigure = ''
    # Copy bootstrap sources into place, see OMCompiler/Compiler/boot/CMakeLists.txt
    mkdir -p OMCompiler/Compiler/boot/bomc/
    cp -r ${bootstrap_src}/* OMCompiler/Compiler/boot/bomc/
    touch OMCompiler/Compiler/boot/bomc/sources.tar.gz # This is used in cmake to check whether the files have been downloaded already
    ls OMCompiler/Compiler/boot/bomc/
  '';

  meta = with lib; {
    description = "Interactive OpenModelica session shell";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}

