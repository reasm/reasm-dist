# reasm-dist

This repository contains a script, **build.bash**, that builds and publishes a
standard distribution for **reasm**. The `src` directory contains additional
files that are included in the distribution.

The following programs are required to run **build.bash**:

* bash
* git
* mail
* mvn
* scp
* tar (GNU)
* xz

This script is designed to be run unattended. Errors are sent by email. Run the
script with `bash build.bash`.
