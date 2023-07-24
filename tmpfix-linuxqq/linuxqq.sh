#!/bin/bash

if [ -d ~/.config/QQ/versions ]; then
	find ~/.config/QQ/versions -name sharp-lib -type d -exec rm -r {} \; 2>/dev/null
fi

LD_PRELOAD=/usr/lib/libcurl.so.4.7.0 /opt/QQ/qq "$@"
