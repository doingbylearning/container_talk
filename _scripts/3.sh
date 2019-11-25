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

info "hmm can we do this better?"
info "i heard about namespaces? what the fuck are they cO"
unshare --help
read
debug "HA now i know how to do this :D :D"
info "I'll just use unshare with --pid --fork --mount and --mount-proc"
alert "wait a minute ..... why would i need to fork ...."
read
info "hmm .... maybe we want to drop privileges as early as possible? let's look this up"
debug "Unshare the PID namespace, so that the calling process has a new PID namespace for its children which is not shared with any previously existing process."
debug "The calling process is not moved into the new namespace."
debug "The first child created by the calling process will have the process ID 1 and will assume the role of init(1) in the new namespace."

read

sudo mount -t proc proc "${PWD}/rootfs/proc"
sudo unshare --pid --fork --mount --mount-proc="${PWD}/rootfs/proc" \
  chroot rootfs ps auxwf
sudo umount "${PWD}/rootfs/proc"

info "SUCCESS!!!!"
echo
echo
echo
cowsay "but wait there is more ....."
info "what do you mean there is more magic cow?"

read

notice "ahhhh yes these utbla ipc and network namespaces .... but who needs those ....."
info "hmm yeah okay might be interesting >_> lets see.."

read
info "so network is pretty straight forward .. and yes children we will come to this later :D"
info "first lets cover uts and ipc"
notice "can anybody tell me of you what in the love of god is a uts and ipc namespace cO?"

read
info "The UTS namespace is used to isolate two specific elements of the system that relate to the uname system call."
info "The UTS(UNIX Time Sharing) namespace is named after the data structure used to store information returned by the uname system call."
info "Specifically, the UTS namespace isolates the hostname and the NIS domain name."

read
info "ipc()  is a common kernel entry point for the System V IPC calls for messages, semaphores, and shared memory."

info "NOICE thanks magic cow :D"
alert "but who here can explain me what the hell these actually are ....?"
read

info "let's try out the uts stuff by finding my current hostname"
hostname
info "now let's do the same inside the container ... HA i said it :D"
sudo mount -t proc proc "${PWD}/rootfs/proc"
sudo unshare --pid --fork --mount --uts --mount-proc="${PWD}/rootfs/proc" \
  chroot rootfs
sudo umount "${PWD}/rootfs/proc"

info "soooo lets get to the ipc thingy also"
info "first lets grab the current ipc stat from my host system"
ipcs -a
info "and now lets isolate the shizzle"
sudo mount -t proc proc "${PWD}/rootfs/proc"
sudo unshare --pid --fork --mount --uts --ipc --mount-proc="${PWD}/rootfs/proc" \
  chroot rootfs
sudo umount "${PWD}/rootfs/proc"

cowsay "i love this shit"
info "and so do i magic cow <3"
