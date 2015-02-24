#!/bin/bash -Eu

declare -a projects=(fragag-commons fragag-test-helpers reasm-core reasm-commons reasm-m68k reasm-z80 reasm-batch)

install() {
  echo "Installing $1" &&
  cd "./$1" && # './' bypasses CDPATH
  git reset --hard &&
  git clean -dfx &&
  mvn clean install &&
  cd .. &&
  echo
}

build() {
  if [[ $# -gt 0 ]]
  then
    install "$1" &&
    shift &&
    build "$@"
  fi
}

package_dist() {
  echo "Packaging reasm distribution" &&
  rm -rf dist &&
  mkdir dist &&
  cp reasm-batch/target/reasm-batch-*.jar dist/reasm.jar &&
  cp $(git ls-files src) dist/ &&
  cd ./dist &&
  tar --create --file=reasm.tar.xz --xz * &&
  cd .. &&
  echo
}

publish_sources() {
  if [[ $# -gt 0 ]]
  then
    echo "Pushing $1" &&
    cd "./$1" &&
    git push origin master &&
    cd .. &&
    echo &&
    shift &&
    publish_sources "$@"
  fi
}

publish_self() {
  echo "Pushing reasm-dist" &&
  git push &&
  echo
}

upload_dist() {
  echo "Uploading reasm distribution" &&
  scp dist/reasm.tar.xz fragag.ca:files/public/reasm.tar.xz &&
  echo
}

run() {
  # Abort if repository is not clean
  if git diff HEAD --quiet
  then
    build ${projects[@]} &&
    package_dist &&
    publish_sources ${projects[@]} &&
    publish_self &&
    upload_dist
  else
    echo "reasm-dist's working directory and index are not clean"
    false
  fi
}

set -o pipefail

run
