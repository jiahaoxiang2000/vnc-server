#!/bin/bash

# VNC Server Management Script for Xilinx Vivado
# Optimized for CAD applications with XFCE4 desktop environment

# Default resolution - 2K with higher DPI for better scaling
RESOLUTION="2560x1440"
DPI="120"

# Check if resolution is provided as second argument
if [ ! -z "$2" ]; then
    RESOLUTION="$2"
fi

case "$1" in
    start)
        echo "Starting VNC server with XFCE4 desktop for Xilinx Vivado"
        echo "Resolution: $RESOLUTION (DPI: $DPI)"
        
        # Ensure XFCE4 xstartup configuration exists
        if [ ! -f ~/.vnc/xstartup ]; then
            echo "Creating XFCE4 xstartup configuration..."
            mkdir -p ~/.vnc
            cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Set display for X applications
export DISPLAY=:4

# Start D-Bus session
if [ -x /usr/bin/dbus-launch ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Set up environment for CAD tools
export QT_X11_NO_MITSHM=1
export _JAVA_AWT_WM_NONREPARENTING=1

# XFCE4 Desktop Environment - ideal for CAD applications
startxfce4 &

# Keep the session alive
while true; do
    sleep 60
done
EOF
            chmod +x ~/.vnc/xstartup
            echo "XFCE4 xstartup configuration created"
        fi
        
        vncserver :4 -geometry $RESOLUTION -depth 24 -dpi $DPI -localhost=0
        echo "VNC server started on display :4 (port 5904) with XFCE4 desktop"
        echo "You can connect using: hostname:5904 or hostname:4"
        echo "Optimized for Xilinx Vivado and other CAD applications"
        ;;
    stop)
        echo "Stopping VNC server..."
        vncserver -kill :4
        echo "VNC server stopped"
        ;;
    restart)
        echo "Restarting VNC server with XFCE4 desktop for Xilinx Vivado"
        echo "Resolution: $RESOLUTION (DPI: $DPI)"
        vncserver -kill :4 2>/dev/null
        sleep 2
        vncserver :4 -geometry $RESOLUTION -depth 24 -dpi $DPI -localhost=0
        echo "VNC server restarted on display :4 (port 5904) with XFCE4 desktop"
        echo "Optimized for Xilinx Vivado and other CAD applications"
        ;;
    setup)
        echo "Installing XFCE4 desktop environment for Vivado..."
        sudo apt update
        sudo apt install -y xfce4 xfce4-goodies
        sudo apt install -y tigervnc-standalone-server tigervnc-common
        echo "XFCE4 installation completed"
        echo "Run '$0 start' to start the VNC server"
        ;;
    status)
        echo "Checking VNC server status..."
        ps aux | grep -v grep | grep Xtigervnc || echo "No VNC server running"
        echo ""
        echo "Listening ports:"
        netstat -tuln | grep 590 || echo "No VNC ports listening"
        echo ""
        echo "VNC sessions:"
        vncserver -list
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|setup} [resolution]"
        echo ""
        echo "VNC Server Management Script for Xilinx Vivado"
        echo "  setup   - Install XFCE4 desktop environment and VNC server"
        echo "  start   - Start VNC server on display :4 with XFCE4"
        echo "  stop    - Stop VNC server"
        echo "  restart - Restart VNC server"
        echo "  status  - Check VNC server status"
        echo ""
        echo "Connection Information:"
        echo "  VNC Display: :4"
        echo "  VNC Port: 5904"
        echo "  Connect to: hostname:5904 or hostname:4"
        echo ""
        echo "Optional resolution parameter (default: 2560x1440):"
        echo "  1024x768   - Standard 4:3"
        echo "  1280x720   - HD 720p"
        echo "  1366x768   - Common laptop"
        echo "  1920x1080  - Full HD 1080p"
        echo "  2560x1440  - 2K QHD (default - recommended for Vivado)"
        echo "  3840x2160  - 4K UHD (requires powerful client)"
        echo ""
        echo "Example: $0 start 1920x1080"
        echo ""
        echo "For Xilinx Vivado setup:"
        echo "1. Run: $0 setup     (install XFCE4 desktop)"
        echo "2. Run: $0 start     (start VNC with XFCE4)"
        echo "3. Connect via VNC to port 5904 and install Vivado in the desktop environment"
        exit 1
        ;;
esac
