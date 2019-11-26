#!/usr/bin/env bash

function _fmt ()      {
  local color_ok="\x1b[32m"
  local color_bad="\x1b[31m"

  local color="${color_bad}"
  if [ "${1}" = "debug" ] || [ "${1}" = "info" ] || [ "${1}" = "notice" ]; then
    color="${color_ok}"
  fi

  local color_reset="\x1b[0m"
  echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" ${1})${color_reset}";
}
function emergency () { echo "$(_fmt emergency) ${@}" 1>&2 || true; exit 1; }
function alert ()     { echo "$(_fmt alert) ${@}" 1>&2 || true; }
function critical ()  { echo "$(_fmt critical) ${@}" 1>&2 || true; }
function error ()     { echo "$(_fmt error) ${@}" 1>&2 || true; }
function warning ()   { echo "$(_fmt warning) ${@}" 1>&2 || true; }
function notice ()    { echo "$(_fmt notice) ${@}" 1>&2 || true; }
function info ()      { echo "$(_fmt info) ${@}" 1>&2 || true; }
function debug ()     { echo "$(_fmt debug) ${@}" 1>&2 || true; }

set -o errexit
set -o pipefail
set -o nounset

info "let's see if we can somehow go into this rootfs and do something with it"
info "in the end dont we just need some good old chroot?"
read
info "okay let's try this out! lets check with the python version on the systems :D"
info "python on the host system"
set -x
python --version
set +x
info "python in the rootfs"
set -x
sudo chroot rootfs python --version
set +x

info "BÄM we are done!!!"
alert "wait a minute .... what the hell about other things ?"
alert "don't we want isolation  and stuff ??? i guess that's not so simple after all...."
