#!/bin/bash

BWRAP_ARGS+=(
    #--unshare-all
    --share-net
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
    --ro-bind /etc{,}
    --ro-bind /etc/machine-id{,}
    --ro-bind /etc/group{,}
    --ro-bind /etc/passwd{,}
    --ro-bind /etc/nsswitch.conf{,}
    --ro-bind /etc/resolv.conf{,}
    #--ro-bind-try /etc/localtime{,}
    --ro-bind-try /etc/fonts{,}
    --ro-bind-try "/etc/pki"{,}
    --ro-bind-try "/etc/system-fips"{,}
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

if [[ ! -d "/var/log/sangfor/vdiclient" ]]; then
    install -dm777 /var/log/sangfor/vdiclient
fi
if [[ ! -d "/run/sangfor/vdiclient" ]]; then
    install -dm777 /run/sangfor/vdiclient
fi

exec bwrap ${BWRAP_ARGS[@]} /usr/local/sangfor/vdiclient/bin/vdi_super_agent $@
