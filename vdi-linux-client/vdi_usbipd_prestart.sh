#!/bin/bash

if [[ ! -f "/usr/local/sangfor/vdiclient/lib/usbip-core.ko" ]]; then
    zstdcat /lib/modules/$(uname -r)/kernel/drivers/usb/usbip/usbip-core.ko.zst > /usr/local/sangfor/vdiclient/lib/usbip-core.ko
fi

if [[ ! -f "/usr/local/sangfor/vdiclient/lib/usbip-host.ko" ]]; then
    zstdcat /lib/modules/$(uname -r)/kernel/drivers/usb/usbip/usbip-host.ko.zst > /usr/local/sangfor/vdiclient/lib/usbip-host.ko
fi

