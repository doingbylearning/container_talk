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

info "and yes my friends we now come to the all time favorite .... NETWORK :D"
debug "note: we will recycle the already existing docker0 bridge as i dont also want to setup this stuff ^^"

uuid="ps_$(shuf -i 42002-42254 -n 1)"
ip="$(echo "${uuid: -3}" | sed 's/0//g')"
mac="${uuid: -3:1}:${uuid: -2}"

cowsay "buckle up buckaroo"
read
set -x
sudo ip link add dev veth0_"$uuid" type veth peer name veth1_"$uuid"
sudo ip link set dev veth0_"$uuid" up
sudo ip link set veth0_"$uuid" master docker0
sudo ip netns add netns_"$uuid"
sudo ip link set veth1_"$uuid" netns netns_"$uuid"
sudo ip netns exec netns_"$uuid" ip link set dev lo up
sudo ip netns exec netns_"$uuid" ip link set veth1_"$uuid" address 02:42:ac:11:00"$mac"
sudo ip netns exec netns_"$uuid" ip addr add 172.17.0."$ip"/24 dev veth1_"$uuid"
sudo ip netns exec netns_"$uuid" ip link set dev veth1_"$uuid" up
sudo ip netns exec netns_"$uuid" ip route add default via 172.17.0.1
set +x
info "hoooooooold on, what the hell just happened ?"
read
info "ah well lets find out what it did"
set -x
sudo mount -t proc proc "${PWD}/rootfs/proc"
sudo ip netns exec netns_"$uuid" \
  unshare --pid --fork --mount --uts --ipc --mount-proc="${PWD}/rootfs/proc" \
    chroot rootfs /bin/bash
sudo umount "${PWD}/rootfs/proc"
set +x
read
set -x
sudo ip link del dev veth0_"$uuid"
sudo ip netns del netns_"$uuid"
set +x
info "hmm well yeah ^^ so what happened with unshare --net xD?"
