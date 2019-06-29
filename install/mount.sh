#!/bin/bash

build() {
  add_module nvme
  add_module ntfs
  add_module nls_utf8
  add_module loop
  add_binary ntfsfix
  add_runscript
}

help() {
  cat <<HELPEOF
This hook adds support for loop root file systems
HELPEOF
}