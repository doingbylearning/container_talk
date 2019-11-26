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
read
info "so we learned how to more or less isolate a container, what about resources would the little fairy ask"
info "'can we isolate them as well?' did she ask"
read
info "YES WE CAN!"
info "cgroups to the rescue :D"

cgroups='cpu,cpuacct,memory';
uuid="ps_$(shuf -i 42002-42254 -n 1)"
set -x
sudo cgcreate -g "$cgroups:/$uuid"
sudo cgset -r cpu.shares="512" "$uuid"
sudo cgset -r memory.limit_in_bytes="$((128 * 1000000))" "$uuid"
sudo sudo mount -t proc proc "${PWD}/rootfs/proc"
sudo cgexec -g "$cgroups:$uuid" \
  unshare --pid --fork --mount --uts --ipc --mount-proc="${PWD}/rootfs/proc" \
    chroot rootfs
sudo umount "${PWD}/rootfs/proc"
set +x
