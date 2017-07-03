#!/bin/bash

#XAUTHORITY=/run/user/120/gdm/Xauthority sudo -u gdm /usr/bin/x0vncserver -display :0 -rfbport 5900 -passwordfile /tmp/vncpasswd
#sudo -u gdm x11vnc -display :0 -rfbauth /tmp/vncpasswd -auth /run/user/120/gdm/Xauthority
#XAUTHORITY=/run/user/120/gdm/Xauthority sudo -u hjy /usr/bin/x0vncserver -display :1 -rfbport 5900 -passwordfile /home/hjy/.vnc/passwd

#/usr/bin/x11vnc -display WAIT%i \
#            -nevershared -forever \
#            -rfbport $((5900 + $(echo %i | awk -F':' '{print $NF}'))) \
#            -rfbportv6 $((5900 + $(echo %i | awk -F':' '{print $NF}'))) \
#            -rfbauth /etc/X11/vncpasswd \
#            -auth /run/user/$(/usr/bin/id -u)/gdm/Xauthority

export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin
export VNC_PASSWD=/etc/X11/vncpasswd
export PID_DIR=/run/x11vnc
if [ ! -d ${PID_DIR} ]; then
    mkdir -p ${PID_DIR}
fi

function StopVNC() {
    local PID_FILE=$1
    local PID=$(cat ${PID_FILE})
    kill ${PID}
    while kill -0 ${PID} 2>/dev/null; do
        kill ${PID}
        sleep 1
    done
    rm -f ${PID_FILE}
}

function StartVNC() {
    local UNIX_SOCK=$1
    local XDISPLAY=":$(echo ${UNIX_SOCK} | grep -o -P '\d+$' )"
    local VNC_PORT="$((5900 + $(echo ${UNIX_SOCK} | grep -o -P '\d+$' ) ))"
    local PID_FILE=${PID_DIR}/$(basename ${UNIX_SOCK}).pid
    local USER=$(stat -c '%U' ${UNIX_SOCK})
    local USER_UID=$(stat -c '%u' ${UNIX_SOCK})
    if [ -f ${PID_FILE} ]; then
        StopVNC ${PID_FILE}
    fi
    /usr/bin/x11vnc -display WAIT${XDISPLAY} \
        -nevershared -forever \
        -rfbport ${VNC_PORT} \
        -rfbauth ${VNC_PASSWD} \
        -auth /run/user/${USER_UID}/gdm/Xauthority &
    local VNC_PID=$!
    echo ${VNC_PID} > ${PID_FILE}
}

function MainLoop() {
    local XN
    local PF
    local UNIX_SOCK
    local PID_FILE
    if [ $(ls -1 ${PID_DIR} | wc -l) -ne 0 ]; then
        echo "pid of x11vnc is found, exit." >&2
        exit 1
    fi
    while true; do
        if [ -f ${PID_DIR}/stop.tag ]; then
            for PF in $(ls -1 ${PID_DIR}/*.pid 2>/dev/null); do
                PID_FILE=${PID_DIR}/$(basename ${PF})
                echo "DEBUG: try kill VNC, with ${PID_FILE}"
                StopVNC ${PID_FILE}
            done
            rm -f ${PID_DIR}/stop.tag
            break
        fi
        for XN in $(ls -1 /tmp/.X11-unix/ 2>/dev/null); do
            UNIX_SOCK=/tmp/.X11-unix/${XN}
            PID_FILE=${PID_DIR}/$(basename ${UNIX_SOCK}).pid
            if [ -S ${UNIX_SOCK} ]; then
                if [ ! -f ${PID_FILE} ]; then
                    StartVNC ${UNIX_SOCK}
                elif kill -0 $(cat ${PID_FILE}); then
                    ## : means skip
                    :
                else
                    rm -f ${PID_FILE}
                    StartVNC ${UNIX_SOCK}
                fi
            fi
        done
        for PF in $(ls -1 ${PID_DIR}/*.pid 2>/dev/null); do
            PID_FILE=${PID_DIR}/$(basename ${PF})
            XN=$(basename $(echo ${PF}) | awk -F'.' '{print $1}')
            UNIX_SOCK=/tmp/.X11-unix/${XN}
            if kill -0 $(cat ${PID_FILE}); then
                if [ ! -S ${UNIX_SOCK} ]; then
                    echo "DEBUG: try kill VNC, with ${UNIX_SOCK}"
                    StopVNC ${PID_FILE}
                fi
            fi
        done
        sleep 3
    done
}

function StopMainLoop() {
    touch ${PID_DIR}/stop.tag
    while [ $(ls -1 ${PID_DIR} | wc -l) -ne 0 ]; do
        sleep 1
    done
    rmdir ${PID_DIR}
    exit 0
}

if [ "xstart" == "x$1" ]; then
    MainLoop
elif [ "xstop" == "x$1" ]; then
    StopMainLoop
elif [ "xrestart" == "x$1" ]; then
    StopMainLoop
    MainLoop
fi

