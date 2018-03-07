with import <nixpkgs> {};

let
  avr_incflags = (with pkgs; [
    "-isystem ${avrlibc}/avr/include"
    "-B${avrlibc}/avr/lib/avr5"
    "-L${avrlibc}/avr/lib/avr5"
  ]);
in
  stdenv.mkDerivation {
    name = "butterfly-env";

    buildInputs = [
      avrgcc
      avrbinutils
      avrdude
      avrlibc
      gnumake
    ];

    CFLAGS = avr_incflags;
    ASFLAGS = avr_incflags;
  }
