#!/bin/sh

DAEMON=/usr/bin/python
APPDIR="/home/ec2-user/application_backend/UIUC-API"

PARAMETERS="$APPDIR/app.py"
LOGFILE="$APPDIR/daemon.log"

start() {
    echo -n "starting up $DAEMON"
    RUN=`cd / && $DAEMON $PARAMETERS > $LOGFILE 2>&1 &`

    if [ "$?" -eq 0 ]; then
        echo "Done."
    else
        echo "FAILED."
    fi
}

stop() {
    killall $DAEMON
}

status() {
    killall -0 $DAEMON

    if [ "$?" -eq 0 ]; then
        echo "Running."
    else
        echo "Not Running."
    fi
}

case "$1" in
    start)
        start
        ;;

    restart)
        stop
        sleep 2
        start
        ;;

    stop)
        stop
        ;;

    status)
        status
        ;;

    *)
        echo "usage : $0 start|restart|stop|status"
        ;;
esac

exit 0
