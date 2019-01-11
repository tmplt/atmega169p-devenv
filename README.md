This directory contains all necessary headers and a Makefile to program on the Atmel AVR Butterfly.
Each `.c`-file placed into this directory is compiled by its own into an `.o`-file.
The main executable is then created by linking these object files.

All warnings are enabled, except those for quirks used in abundance by the included header files.
These extra warnings can be omitted by commenting out the value of `EXTRAFLAGS` in the makefile, but they are highly recommended.

`include/avr` was copied from the latest release of AVR Libc
<http://www.nongnu.org/avr-libc/>. All other header files, and necessary compilation
steps were copied from Atmel Studio 7.0.

After compiling your code with `make`, you program your Butterfly via
`make upload`. Depending on your system configuration, you may need need to run the second step
with root privileges.
If you're using Arch Linux or a similar distribution, copy `meta/50-usbavrisp2.rules` into the system udev rules and reload the udev daemon.
If you're using Nix(OS), append
```nix
services.udev.extraRules = ''
  # Allow users to use the AVR avrisp2 programmer
  SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="2104", TAG+="uaccess", RUN{builtin}+="uaccess"
'';
```
to your system configuration and rebuild the system.
This rule should allow you to program the Butterfly as non-root.

The Makefile depends on `avr-gcc`, `avr-objcopy`, `avr-objdump`, `avr-size`, `avrdude`,
and possibly the `avr-libc` headers.
These can be installed on Arch Linux via the `avr-libc`, `avr-gcc`, `avr-binutils` and `avrdude` packages (or via your distro's equivalent).

If you're using Nix(OS), you can run `nix-shell` in this directory to automagically install all required dependencies and drop yourself in a suitable shell.
