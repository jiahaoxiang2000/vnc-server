#!/bin/bash

# VNC Server Management Script

# Default resolution - 2K with higher DPI for better scaling
RESOLUTION="2560x1440"
DPI="120"

# Check if resolution is provided as second argument
if [ ! -z "$2" ]; then
    RESOLUTION="$2"
fi

case "$1" in
    start)
        echo "Starting VNC server with resolution: $RESOLUTION (DPI: $DPI)"
        vncserver :2 -geometry $RESOLUTION -depth 24 -dpi $DPI
        echo "VNC server started on display :2 (port 5902) at 2K resolution"
        echo "You can connect using: hostname:5902 or hostname:2"
        echo "Recommended client zoom: 90% for optimal viewing"
        ;;
    stop)
        echo "Stopping VNC server..."
        vncserver -kill :2
        echo "VNC server stopped"
        ;;
    restart)
        echo "Restarting VNC server with resolution: $RESOLUTION (DPI: $DPI)"
        vncserver -kill :2 2>/dev/null
        sleep 2
        vncserver :2 -geometry $RESOLUTION -depth 24 -dpi $DPI
        echo "VNC server restarted on display :2 (port 5902) at 2K resolution"
        echo "Recommended client zoom: 90% for optimal viewing"
        ;;
    status)
        echo "Checking VNC server status..."
        ps aux | grep -v grep | grep Xtightvnc || echo "No VNC server running"
        echo ""
        echo "Listening ports:"
        netstat -tuln | grep 590 || echo "No VNC ports listening"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status} [resolution]"
        echo ""
        echo "VNC Server Management Script"
        echo "  start   - Start VNC server on display :2"
        echo "  stop    - Stop VNC server"
        echo "  restart - Restart VNC server"
        echo "  status  - Check VNC server status"
        echo ""
        echo "Optional resolution parameter (default: 1920x1080):"
        echo "  1024x768   - Standard 4:3"
        echo "  1280x720   - HD 720p"
        echo "  1366x768   - Common laptop"
        echo "  1920x1080  - Full HD 1080p (default)"
        echo "  2560x1440  - 2K QHD"
        echo ""
        echo "Example: $0 start 1366x768"
        exit 1
        ;;
esac
