#!/bin/bash

BWRAP_ARGS+=(
    --unshare-all
    --share-net
    --cap-drop ALL
    --die-with-parent
    # /usr
    --ro-bind /usr{,}
    --symlink usr/lib /lib
    --symlink usr/lib /lib64
    --symlink usr/bin /bin
    --symlink usr/bin /sbin
    # /dev
    --dev /dev
    --dev-bind /dev/dri{,}
    --tmpfs /dev/shm
    # /proc
    --proc /proc
    # /etc
    --ro-bind /etc/machine-id{,}
    --ro-bind /etc/passwd{,}
    --ro-bind /etc/nsswitch.conf{,}
    --ro-bind /etc/resolv.conf{,}
    --ro-bind /etc/localtime{,}
    --ro-bind-try /etc/fonts{,}
    # /sys
    --dir /sys/dev # hack for Intel / AMD graphics, mesa calling virtual nodes needs /sys/dev being 0755
    --ro-bind /sys/dev/char{,}
    --ro-bind /sys/devices{,}
    # /tmp
    --tmpfs /tmp
    --ro-bind-try /tmp/.X11-unix{,} # haayuya suggested this fix on Hyprland: [1] https://aur.archlinux.org/packages/wechat-universal-bwrap#comment-1046129 [2] https://github.com/hyprwm/Hyprland/pull/8874
    --dev /dev
    --dev-bind /dev/dri /dev/dri
    --tmpfs /dev/shm
    --proc /proc
    --ro-bind /etc/machine-id /etc/machine-id
    --ro-bind /etc/passwd /etc/passwd
    --ro-bind /etc/nsswitch.conf /etc/nsswitch.conf
    --ro-bind /etc/resolv.conf /etc/resolv.conf
    --ro-bind /etc/localtime /etc/localtime
    --ro-bind-try /etc/fonts /etc/fonts
    --dir /sys/dev
    --ro-bind /sys/dev/char /sys/dev/char
    --ro-bind /sys/devices /sys/devices
    --tmpfs /tmp
    --ro-bind-try /tmp/.X11-unix /tmp/.X11-unix
    # sangfor
    --ro-bind /usr/local/sangfor/vdiclient/os-release /etc/os-release
    --bind "/run/sangfor"{,}
    --bind "/var/log/sangfor"{,}
    --bind "/etc/sangfor"{,}
)

bwrap ${BWRAP_ARGS[@]} /usr/local/sangfor/vdiclient/bin/vdi_super_agent $@

