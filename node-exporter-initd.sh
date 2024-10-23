#!/bin/bash
# This script will install Node Exporter with init.d
cd /opt
sudo curl -LO "https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz"
sudo mkdir /opt/node_exporter
sudo tar xvfz node_exporter-0.18.1.linux-amd64.tar.gz -C /opt/node_exporter
sudo mv /opt/node_exporter/node_exporter* /opt/node_exporter/node_exporter
cat << EOF >node_exporter
#!/bin/bash
#
# /etc/rc.d/init.d/node_exporter
#
#  Prometheus node exporter
#
#  description: Prometheus node exporter
#  processname: node_exporter

# Source function library.
. /etc/rc.d/init.d/functions

PROGNAME=node_exporter
PROG=/opt/node_exporter/$PROGNAME
USER=root
LOGFILE=/var/log/node-exporter.log
LOCKFILE=/var/run/$PROGNAME.pid

start() {
    echo -n "Starting $PROGNAME: "
    cd /opt/node_exporter/
    daemon --user $USER --pidfile="$LOCKFILE" "$PROG &>$LOGFILE &"
    echo $(pidofproc $PROGNAME) >$LOCKFILE
    echo
}

stop() {
    echo -n "Shutting down $PROGNAME: "
    killproc $PROGNAME
    rm -f $LOCKFILE
    echo
}


case "$1" in
    start)
    start
    ;;
    stop)
    stop
    ;;
    status)
    status $PROGNAME
    ;;
    restart)
    stop
    start
    ;;
    reload)
    echo "Sending SIGHUP to $PROGNAME"
    kill -SIGHUP $(pidofproc $PROGNAME)#!/bin/bash
    ;;
    *)
        echo "Usage: service prometheus {start|stop|status|reload|restart}"
        exit 1
    ;;
esac
EOF
sudo mv node_exporter /etc/init.d/node_exporter
sudo chmod +x /etc/init.d/node_exporter
sudo service start node_exporter
sudo rm -rf node_exporter-0.18.1.linux-amd64.tar.gz
sudo rm -f node-exporter.sh
sudo reboot 
