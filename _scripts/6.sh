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

#set -o errexit
#set -o pipefail
set -o nounset

cowsay "but wait there's more!"
info "magic cow somebody should really make a cheeseburger out of you ..."
read
cowsay "but what about securityyyyyy"
info "what about it? -.-"
read
cowsay "isn't that important tooooo?"
info "but but but we did already so much *sigh* ok you win, yeah it is -kind of-"
info "soooo what can we do even more about security?"

info "capabilities"
sudo capsh --print

read
info "so let's try it out"
set -x
sudo capsh --drop=cap_chown,cap_setpcap,cap_setfcap,cap_sys_admin --chroot=$PWD/rootfs --
set +x
