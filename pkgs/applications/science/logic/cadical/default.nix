{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cadical";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "arminbiere";
    repo = "cadical";
    rev = "rel-${version}";
    sha256 = "0y44z3np4gssgdh4aj5qila7pshrbphycdxn2083i8ayyyjbxshp";
  };

  outputs = [ "out" "dev" "lib" ];
  doCheck = true;

  # the configure script is not generated by autotools and does not accept the
  # arguments that the default configurePhase passes like --prefix and --libdir
  configurePhase = ''
    runHook preConfigure

    ./configure

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 build/cadical "$out/bin/cadical"
    install -Dm0755 build/mobical "$out/bin/mobical"
    install -Dm0644 src/ccadical.h "$dev/include/ccadical.h"
    install -Dm0644 build/libcadical.a "$lib/lib/libcadical.a"
    mkdir -p "$out/share/doc/${pname}/"
    install -Dm0755 {LICEN?E,README*,VERSION} "$out/share/doc/${pname}/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simplified Satisfiability Solver";
    maintainers = with maintainers; [ shnarazk ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = "http://fmv.jku.at/cadical";
  };
}
