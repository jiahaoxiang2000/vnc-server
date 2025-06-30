#!/bin/bash

# VNC Server Management Script for Xilinx Vivado & Vitis
# Optimized for CAD applications with XFCE4 desktop environment

# Default resolution - 2K with higher DPI for better scaling
RESOLUTION="1920x1080"
DPI="120"

# Default display number
VNC_DISPLAY=4

# Parse display number if provided as first argument after command
if [[ "$2" =~ ^[0-9]+$ ]]; then
    VNC_DISPLAY="$2"
fi

# Parse resolution if provided as second/third argument
if [ ! -z "$3" ]; then
    RESOLUTION="$3"
fi

case "$1" in
    start)
        echo "Starting VNC server with XFCE4 desktop for Xilinx Vivado & Vitis"
        echo "Display: :$VNC_DISPLAY | Resolution: $RESOLUTION (DPI: $DPI)"
        
        # Ensure XFCE4 xstartup configuration exists
        if [ ! -f ~/.vnc/xstartup ]; then
            echo "Creating XFCE4 xstartup configuration..."
            mkdir -p ~/.vnc
            cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Set display for X applications
export DISPLAY=:$VNC_DISPLAY

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
        
        vncserver :$VNC_DISPLAY -geometry $RESOLUTION -depth 24 -dpi $DPI -localhost=0
        echo "VNC server started on display :$VNC_DISPLAY (port 59${VNC_DISPLAY}) with XFCE4 desktop"
        echo "You can connect using: hostname:59${VNC_DISPLAY} or hostname:$VNC_DISPLAY"
        echo "Optimized for Xilinx Vivado, Vitis HLS, and other CAD applications"
        ;;
    stop)
        echo "Stopping VNC server on display :$VNC_DISPLAY..."
        vncserver -kill :$VNC_DISPLAY
        echo "VNC server on :$VNC_DISPLAY stopped"
        ;;
    restart)
        echo "Restarting VNC server with XFCE4 desktop for Xilinx Vivado"
        echo "Display: :$VNC_DISPLAY | Resolution: $RESOLUTION (DPI: $DPI)"
        vncserver -kill :$VNC_DISPLAY 2>/dev/null
        sleep 2
        vncserver :$VNC_DISPLAY -geometry $RESOLUTION -depth 24 -dpi $DPI -localhost=0
        echo "VNC server restarted on display :$VNC_DISPLAY (port 59${VNC_DISPLAY}) with XFCE4 desktop"
        echo "Optimized for Xilinx Vivado and other CAD applications"
        ;;
    setup)
        echo "Installing XFCE4 desktop environment for Vivado..."
        sudo apt update
        sudo apt install -y xfce4 xfce4-goodies
        sudo apt install -y tigervnc-standalone-server tigervnc-common
        echo "XFCE4 installation completed"
        echo "Run '$0 start [display] [resolution]' to start the VNC server"
        ;;
    status)
        echo "Checking VNC server status..."
        ps aux | grep -v grep | grep Xtigervnc || echo "No VNC server running"
        echo ""
        echo "Listening ports:"
        netstat -tuln | grep 59 || echo "No VNC ports listening"
        echo ""
        echo "VNC sessions:"
        vncserver -list
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|setup} [display] [resolution]"
        echo ""
        echo "VNC Server Management Script for Xilinx Vivado & Vitis"
        echo "  setup   - Install XFCE4 desktop environment and VNC server"
        echo "  start   - Start VNC server on specified display (default :4) with XFCE4"
        echo "  stop    - Stop VNC server on specified display (default :4)"
        echo "  restart - Restart VNC server on specified display (default :4)"
        echo "  status  - Check VNC server status"
        echo ""
        echo "Connection Information:"
        echo "  VNC Display: :[display] (default :4)"
        echo "  VNC Port: 59[display] (default 5904)"
        echo "  Connect to: hostname:59[display] or hostname:[display]"
        echo ""
        echo "Optional resolution parameter (default: 1920x1080):"
        echo "  1024x768   - Standard 4:3"
        echo "  1280x720   - HD 720p"
        echo "  1366x768   - Common laptop"
        echo "  1920x1080  - Full HD 1080p"
        echo "  2560x1440  - 2K QHD "
        echo "  3840x2160  - 4K UHD (requires powerful client)"
        echo ""
        echo "Example: $0 start 4 1920x1080"
        echo "         $0 start 5 2560x1440"
        echo "         $0 stop 5"
        echo ""
        echo "For Xilinx Vivado & Vitis setup:"
        echo "1. Run: $0 setup     (install XFCE4 desktop)"
        echo "2. Run: $0 start [display] [resolution]     (start VNC with XFCE4)"
        echo "3. Connect via VNC to port 59[display] and install Vivado & Vitis in the desktop environment"
        exit 1
        ;;
esac
