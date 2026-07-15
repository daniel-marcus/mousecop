develop:
  watchexec -e swift -r -- swift run

build:
  ./build.sh

bump-swift:
  swift package tools-version --set-current
