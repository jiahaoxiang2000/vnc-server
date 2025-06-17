#!/bin/bash

# VNC Server Management Script

case "$1" in
    start)
        echo "Starting VNC server..."
        vncserver :2 -geometry 1024x768 -depth 24
        echo "VNC server started on display :2 (port 5902)"
        echo "You can connect using: hostname:5902 or hostname:2"
        ;;
    stop)
        echo "Stopping VNC server..."
        vncserver -kill :2
        echo "VNC server stopped"
        ;;
    restart)
        echo "Restarting VNC server..."
        vncserver -kill :2 2>/dev/null
        sleep 2
        vncserver :2 -geometry 1024x768 -depth 24
        echo "VNC server restarted on display :2 (port 5902)"
        ;;
    status)
        echo "Checking VNC server status..."
        ps aux | grep -v grep | grep Xtightvnc || echo "No VNC server running"
        echo ""
        echo "Listening ports:"
        netstat -tuln | grep 590 || echo "No VNC ports listening"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        echo ""
        echo "VNC Server Management Script"
        echo "  start   - Start VNC server on display :2"
        echo "  stop    - Stop VNC server"
        echo "  restart - Restart VNC server"
        echo "  status  - Check VNC server status"
        exit 1
        ;;
esac
